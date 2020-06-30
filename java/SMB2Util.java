package com.yyt.ogis.common.util;

import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.EnumSet;
import java.util.concurrent.TimeUnit;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hierynomus.msdtyp.AccessMask;
import com.hierynomus.msfscc.fileinformation.FileIdBothDirectoryInformation;
import com.hierynomus.mssmb2.SMB2CreateDisposition;
import com.hierynomus.mssmb2.SMB2ShareAccess;
import com.hierynomus.smbj.SMBClient;
import com.hierynomus.smbj.SmbConfig;
import com.hierynomus.smbj.auth.AuthenticationContext;
import com.hierynomus.smbj.connection.Connection;
import com.hierynomus.smbj.session.Session;
import com.hierynomus.smbj.share.DiskShare;
import com.hierynomus.smbj.share.File;


/**
 * 
 * @author <a href="liuyiming@cqyyt.com">Liu yiming</a>
 * @version 1.0
 * @date 2020年6月30日 下午2:10:08 
 * @desc 访问共享文件夹,smb2.0协议
 */
public class SMB2Util {
	
	private final static Logger logger = LoggerFactory.getLogger(SMB2Util.class);	
	
	/**
	 *  从共享目录拷贝文件到本地，SMB2.0协议
	 * @param domain
	 * @param username
	 * @param password
	 * @param remotePath
	 * @param srcPath
	 */
	public static void smb2Get(String domain,String username,String password
			,String remotePath,String srcPath) {
		// 设置超时时间(可选)
		SmbConfig config = SmbConfig.builder().withTimeout(120, TimeUnit.SECONDS)
				.withTimeout(120, TimeUnit.SECONDS) // 超时设置读，写和Transact超时（默认为60秒）
	            .withSoTimeout(180, TimeUnit.SECONDS) // Socket超时（默认为0秒）
	            .build();
		// 如果不设置超时时间	
		//SMBClient client = new SMBClient();
		SMBClient client = new SMBClient(config);
		try {
			Connection connection = client.connect(domain);	// 如:123.123.123.123
			AuthenticationContext ac = new AuthenticationContext(username, password.toCharArray(), domain);
			Session session = connection.authenticate(ac);
			// 连接共享文件夹
			DiskShare share = (DiskShare) session.connectShare(remotePath);			
			String dstRoot = srcPath;	// 如: D:/smd2/
			for (FileIdBothDirectoryInformation f : share.list("","*.xps")) {
				String filePath = f.getFileName();
				String dstPath = dstRoot + f.getFileName();
				
				FileOutputStream fos = new FileOutputStream(dstPath);
				BufferedOutputStream bos = new BufferedOutputStream(fos);
				
				if (share.fileExists(filePath)) {
					System.out.println("正在下载文件:" + f.getFileName());
					
					File smbFileRead = share.openFile(filePath, EnumSet.of(AccessMask.GENERIC_READ), null, SMB2ShareAccess.ALL, SMB2CreateDisposition.FILE_OPEN, null);
					InputStream in = smbFileRead.getInputStream();
					byte[] buffer = new byte[4096];
					int len = 0;
					while ((len = in.read(buffer, 0, buffer.length)) != -1) {
						bos.write(buffer, 0, len);
					}
					
					bos.flush();
					bos.close();									
					logger.info("文件下载成功");
				} else {					
					logger.info("文件不存在");
				}
			}
		} catch (Exception e) {
			logger.error("获取文件失败：{}",e.getMessage(),e);
		}
	}
	
	/**
	 * 从本地上传文件到共享目录，SMB2.0协议
	 * @param localFilePath 本地文件路径
	 * @param domain 共享服务器IP
	 * @param username 共享服务器用户名
	 * @param password 共享服务器密码
	 * @param remotePath 共享文件存放的路径
	 * @return success/failed
	 */
	public static String smb2Put(String localFilePath,String domain,String username,String password,String remotePath,String remoteSubPath) {
		String result = null;
        FileInputStream fis = null;
        OutputStream fos=null;
        try {        	
        	java.io.File localFile = new java.io.File(localFilePath);
        	String fileName = localFile.getName();
        	// 设置超时时间(可选)
    		SmbConfig config = SmbConfig.builder().withTimeout(120, TimeUnit.SECONDS)
    				.withTimeout(120, TimeUnit.SECONDS) // 超时设置读，写和Transact超时（默认为60秒）
    	            .withSoTimeout(180, TimeUnit.SECONDS) // Socket超时（默认为0秒）
    	            .build();
    		// 如果不设置超时时间	
    		//SMBClient client = new SMBClient();
    		SMBClient client = new SMBClient(config);
    		Connection connection = client.connect(domain);	// 如:123.123.123.123
			AuthenticationContext ac = new AuthenticationContext(username, password.toCharArray(), domain);
			Session session = connection.authenticate(ac);
			// 连接共享文件夹
			DiskShare share = (DiskShare) session.connectShare(remotePath);
			File smbFile = share.openFile(remoteSubPath+fileName, EnumSet.of(AccessMask.GENERIC_ALL), null, SMB2ShareAccess.ALL, SMB2CreateDisposition.FILE_SUPERSEDE, null);
			fis = new FileInputStream(localFile);
			fos=smbFile.getOutputStream();
			IOUtils.copyLarge(fis, fos);			
			result = "success";
		} catch (Exception e) {
			result = "failed";
			logger.error("从本地上传文件到共享目录失败：{}",e.getMessage(),e);
		} finally {
            try {
                if (fis != null) {
                    fis.close();
                }
                if(fos!=null) {
                	fos.close();
                }
            } catch (IOException e) {                             
                logger.error("从本地上传文件到共享目录失败，关闭文件输入流失败：{}",e.getMessage(),e);
            }
        }
        return result;       
	}
	
	
}

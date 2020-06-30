package com.yyt.ogis.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;

/**
 * 
 * @author <a href="liuyiming@cqyyt.com">Liu yiming</a>
 * @version 1.0
 * @date 2020年6月28日 上午11:02:46 
 * @desc 文件操作类 
 */
public class FileUtil {
	
	private final static Logger logger = LoggerFactory.getLogger(FileUtil.class);
	
	/**
	 * 本地拷贝文件
	 * @param srcPathStr 源文件的地址信息
	 * @param targetPathStr 目标文件的地址信息 
	 */
	public static void copyFile(String srcPathStr,String targetPathStr) throws Exception{
		//源文件地址
		String srcFileName=srcPathStr.substring(srcPathStr.lastIndexOf("\\")+1);
		logger.info("源文件地址：{}",srcFileName);
		//目标文件地址
		targetPathStr=targetPathStr+File.separator+srcFileName;
		logger.info("目标文件地址：{}",targetPathStr);
		FileInputStream fis=null;
		FileOutputStream fos=null;
		try {
			fis=new FileInputStream(srcPathStr);
			fos=new FileOutputStream(targetPathStr);
			byte[] datas=new byte[1024*8];
			int len=0;
			while ((len=fis.read(datas))!=-1) {
				fos.write(datas,0,len);
			}
			
		} catch (Exception e) {
			logger.error("复制文件失败：{}",e.getMessage(),e);
			throw new Exception(e.getMessage());
		}finally {
			try {
				if(fis!=null) {
					fis.close();
				}
				if(fos!=null) {
					fos.close();
				}
			} catch (Exception e2) {
				logger.error("复制文件失败：{}",e2.getMessage(),e2);
				throw new Exception(e2.getMessage());
			}
		}
	}	
	
    /**
     * Description: 从共享目录拷贝文件到本地，SMB1.0协议
     *
     * @Version1.0 Sep 25, 2009 3:48:38 PM
     * @param remoteUrl
     *          共享目录上的文件路径
     * @param localDir
     *          本地目录
     */
    public static byte[] smbGet(String remoteUrl, NtlmPasswordAuthentication auth) {
        byte[] bytes = {};
        try {
            SmbFile remoteFile = new SmbFile(remoteUrl, auth);
            if (Utility.isEmpty(remoteFile)) {
                logger.info("共享文件不存在");
                return null;
            }
            bytes = IOUtils.toByteArray(remoteFile.getInputStream());
        } catch (Exception e) {            
            logger.error("从共享目录下载文件失败：{}",e.getMessage(),e);
        }
 
        return bytes;
    }

    /**
     * Description: 从本地上传文件到共享目录，SMB1.0协议
     *
     * @Version1.0 Sep 25, 2009 3:49:00 PM
     * @param remoteUrl
     *          共享文件目录
     * @param localFilePath
     *          本地文件绝对路径
     */
    public static String smbPut(String remoteUrl, String localFilePath, NtlmPasswordAuthentication auth) {
        String result = null;
        FileInputStream fis = null;
        try {
            File localFile = new File(localFilePath);
//            localFile.setReadOnly();
            String fileName = localFile.getName();
            SmbFile remoteFile =null;
            if(Utility.isEmpty(auth)) {
            	remoteFile=new SmbFile(remoteUrl + "/" + fileName);
            }else {
            	remoteFile = new SmbFile(remoteUrl + "/" + fileName, auth);            
            }
            fis = new FileInputStream(localFile);
            IOUtils.copyLarge(fis, remoteFile.getOutputStream());
            result = "success";
        } catch (Exception e) {
            result = "failed";           
            logger.error("从本地上传文件到共享目录失败：{}",e.getMessage(),e);
        } finally {
            try {
                if (fis != null) {
                    fis.close();
                }
            } catch (IOException e) {                             
                logger.error("从本地上传文件到共享目录失败，关闭文件输入流失败：{}",e.getMessage(),e);
            }
        }
        return result;
    }
 
    /**
     * Description: 从共享目录删除文件，SMB1.0协议
     *
     * @Version1.0 Sep 25, 2009 3:48:38 PM
     * @param remoteUrl 共享目录上的文件路径    
     */
    public static void smbDel(String remoteUrl, NtlmPasswordAuthentication auth) {
        try {
            SmbFile remoteFile = new SmbFile(remoteUrl, auth);
            if (remoteFile.exists()) {
                remoteFile.delete();
            }
        } catch (Exception e) {         
            logger.error("从共享目录删除文件失败：{}",e.getMessage(),e);
        }
    }
	
}

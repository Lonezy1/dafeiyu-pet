@echo off
title Close All DaFeiYu Pets
echo Closing all DaFeiYu pet processes...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ps = Get-CimInstance Win32_Process | Where-Object { $_.Name -in @('node.exe','electron.exe') -and $_.CommandLine -like '*dsh-pet*' }; if($ps){ $ps | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Write-Host ('Closed {0} process(es).' -f $ps.Count) } else { Write-Host 'No DaFeiYu process found.' }"
echo.
echo Done.
pause

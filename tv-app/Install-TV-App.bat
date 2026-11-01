@echo off
setlocal EnableDelayedExpansion
title Install TV Launcher on Samsung TV
rem Your TV's IP address: on the TV, MENU > Network > Network Status
set TV=100.70.110.124
set TS=
for %%d in ("%USERPROFILE%\tizen-sdk" "C:\tizen-sdk" "C:\tizen-studio" "%USERPROFILE%\tizen-studio" "D:\tizen-sdk" "D:\tizen-studio" "%LOCALAPPDATA%\tizen-sdk") do (
  if not defined TS if exist "%%~d\tools\ide\bin\tizen.bat" set "TS=%%~d"
)
if not defined TS set TS=C:\tizen-studio
set TIZEN=%TS%\tools\ide\bin\tizen.bat
set SDB=%TS%\tools\sdb.exe
set APPDIR=%~dp0TVLauncher
rem Password for the local signing key (only used on this PC)
set PW=tvlauncher2026
set LOG=%~dp0install-log.txt

echo TV Launcher installer > "%LOG%"
if not exist "%TIZEN%" (
  echo The Tizen SDK isn't installed yet.
  echo Download web-cli_Tizen_SDK_10.0_windows-64.exe from download.tizen.org,
  echo run it, keep the default folder, then run this again.
  echo Tizen Studio not found >> "%LOG%"
  pause & exit /b 1
)

echo [1/5] Connecting to the TV at %TV% ...
"%SDB%" connect %TV% >> "%LOG%" 2>&1
"%SDB%" devices >> "%LOG%" 2>&1
findstr /C:"%TV%:26101" "%LOG%" | findstr /C:"device" >nul
if errorlevel 1 (
  echo     Could not connect. Check that Developer Mode is ON on the TV
  echo     with Host PC IP set to this PC's IP, and that the TV was restarted.
  pause & exit /b 1
)

echo [2/5] Setting up the signing certificate ...
call :findcert
if not defined CERT call "%TIZEN%" certificate -a TVLauncher -p %PW% -c US -f tvlauncher >> "%LOG%" 2>&1
call :findcert
if not defined CERT (
  echo     Couldn't create the certificate. Send install-log.txt to Claude.
  pause & exit /b 1
)
echo Using certificate !CERT! >> "%LOG%"
call "%TIZEN%" security-profiles add -n TVLauncher -a "%CERT%" -p %PW% >> "%LOG%" 2>&1

echo [3/5] Packaging the app ...
del /q "%APPDIR%\*.wgt" 2>nul
call "%TIZEN%" package -t wgt -s TVLauncher -- "%APPDIR%" >> "%LOG%" 2>&1
for %%f in ("%APPDIR%\*.wgt") do ren "%%~f" TVLauncher.wgt
if not exist "%APPDIR%\TVLauncher.wgt" (
  echo     Packaging failed. Send install-log.txt to Claude.
  pause & exit /b 1
)

echo [4/5] Installing on the TV ...
call "%TIZEN%" install -n TVLauncher.wgt -s %TV%:26101 -- "%APPDIR%" > "%~dp0step4.txt" 2>&1
type "%~dp0step4.txt" >> "%LOG%"
findstr /C:"Failed" "%~dp0step4.txt" >nul
if not errorlevel 1 (
  echo     First method failed, trying the TV's own installer ...
  echo --- fallback install >> "%LOG%"
  "%SDB%" -s %TV%:26101 capability >> "%LOG%" 2>&1
  "%SDB%" -s %TV%:26101 push "%APPDIR%\TVLauncher.wgt" /opt/usr/apps/tmp/TVLauncher.wgt >> "%LOG%" 2>&1
  "%SDB%" -s %TV%:26101 shell 0 vd_appinstall SaintTVLnc.TVLauncher /opt/usr/apps/tmp/TVLauncher.wgt >> "%LOG%" 2>&1
)
del /q "%~dp0step4.txt" 2>nul

echo [5/5] Opening it on the TV ...
"%SDB%" -s %TV%:26101 shell 0 was_execute SaintTVLnc.TVLauncher >> "%LOG%" 2>&1

echo.
echo Done. Look at the TV. If nothing opened, tell Claude and it will read install-log.txt.
pause
exit /b 0

:findcert
set CERT=
for %%c in ("%TS%-data\keystore\author\tvlauncher.p12" "%USERPROFILE%\tizen-sdk-data\keystore\author\tvlauncher.p12" "C:\tizen-sdk-data\keystore\author\tvlauncher.p12" "C:\tizen-studio-data\keystore\author\tvlauncher.p12" "%USERPROFILE%\tizen-studio-data\keystore\author\tvlauncher.p12") do (
  if not defined CERT if exist "%%~c" set "CERT=%%~c"
)
exit /b 0

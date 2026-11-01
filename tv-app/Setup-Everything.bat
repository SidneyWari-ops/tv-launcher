@echo off
setlocal
title Tizen SDK setup + TV Launcher install
set URL=https://download.tizen.org/sdk/Installer/tizen-sdk_10.0/web-cli_Tizen_SDK_10.0_windows-64.exe
set EXE=%~dp0web-cli_Tizen_SDK_10.0_windows-64.exe
set DEST=%USERPROFILE%\tizen-sdk
set LOG=%~dp0setup-log.txt
echo Setup started %DATE% %TIME% > "%LOG%"

if exist "%DEST%\tools\ide\bin\tizen.bat" (
  echo Tizen SDK already installed. >> "%LOG%"
  goto tvinstall
)

if not exist "%EXE%" (
  echo [1/3] Downloading the Tizen SDK installer from download.tizen.org, about 370 MB ...
  echo downloading >> "%LOG%"
  curl.exe -L --fail -o "%EXE%.part" "%URL%"
  if errorlevel 1 (
    echo     Download failed. >> "%LOG%"
    echo     Download failed. Tell Claude.
    pause & exit /b 1
  )
  move /y "%EXE%.part" "%EXE%" >nul
)
echo download done >> "%LOG%"

echo [2/3] Installing the Tizen SDK to %DEST% (this can take several minutes) ...
echo installing >> "%LOG%"
"%EXE%" --accept-license "%DEST%"
echo installer exit code %ERRORLEVEL% >> "%LOG%"
if not exist "%DEST%\tools\ide\bin\tizen.bat" (
  echo     The SDK install didn't finish. >> "%LOG%"
  echo     The SDK install didn't finish. Tell Claude.
  pause & exit /b 1
)
echo sdk installed >> "%LOG%"

:tvinstall
echo [3/3] Installing TV Launcher on the TV ...
call "%~dp0Install-TV-App.bat"

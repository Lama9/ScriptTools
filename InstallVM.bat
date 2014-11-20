
@echo off
adb connect 10.10.2.146
set DailyBuildPath=\\10.10.2.72\DVDFab_package\daily_build\vbox1\


if "%1"=="vmc" goto Install_Vmc
if "%1"=="vmcd" goto Install_vmc_debug
if "%1"=="xbmc" goto install_xbmc
if "%1"=="xbmcd" goto install_xbmc_debug
goto err


:Install_Vmc
echo "install VMC"
set apkfpath=%DailyBuildPath%.Vidonme_mediacenter\Lite_release\
adb uninstall org.vidonme.mediacenter
goto installapk


:Install_vmc_debug
echo "Install VMC Debug"
set apkfpath=%DailyBuildPath%.Vidonme_mediacenter\Lite\
adb uninstall org.vidonme.mediacenter
goto installapk


:install_xbmc
echo "Install XBMC13.2"
set apkfpath=%DailyBuildPath%.\VidOnXBMC\XBMC13\RELEASE\
adb uninstall org.vidonme.xbmc13
goto installapk


:install_xbmc_debug
echo "Install XBMC13 Debug"
set apkfpath=%DailyBuildPath%.\VidOnXBMC\XBMC13\debug\
adb uninstall org.vidonme.xbmc13
goto installapk



:installapk
@echo off
for /f "delims=" %%a in ('dir /b /od %apkfpath%') do (
    set filename=%%a
)
echo %apkfpath%%filename%
rem pause
adb install %apkfpath%%filename%
goto end


:err
echo "%0 VMC | xbmc | VMCD |XBMCD"
goto end

:end



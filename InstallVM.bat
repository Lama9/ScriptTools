rem By Lama

@chcp 936
::V 0.0.1
@echo off

adb disconnect 10.10.2.146
adb connect 10.10.2.146
set DailyBuildPath=\\10.10.2.72\DVDFab_package\daily_build\vbox1\

if "%1"=="vmc" goto Install_Vmc
if "%1"=="vmcd" goto Install_vmc_debug
if "%1"=="xbmc" goto install_xbmc
if "%1"=="xbmcd" goto install_xbmc_debug
if "%1"=="vmca" goto install_vmca
if "%1"=="vmcad" goto install_vmca_debug
if "%1"=="vms" goto install_vms
if "%1"=="vmsd" goto install_vms_debug
if "%1"=="vmslog" goto get_vms_log
if "%1"=="reboot" goto reboot
if "%1"=="ping_dns" goto ping_dns
goto err

:ping_dns
for /l %%i in (1,1,70) do ping NS%%i.DOMAINCONTROL.COM
goto end

:reboot
adb shell reboot
goto end

:Install_Vmc
echo "install VMC"
set apkfpath=%DailyBuildPath%.\Vidonme_mediacenter\Lite_release\
adb uninstall org.vidonme.mediacenter
goto installapk


:Install_vmc_debug
echo "Install VMC Debug"
set apkfpath=%DailyBuildPath%.\Vidonme_mediacenter\Lite\
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
rem adb uninstall org.vidonme.xbmc13
goto installapk

:install_vmca
echo "Install VidOn Cloud"
set apkfpath=\\10.10.2.72\nas\DVDFab_package\VidOn.me_Mobile\VidOn.meAndroidPlayer\Test\VidOn_Cloud_TV\
adb uninstall org.vidonme.cloud.tv
goto installapk

:install_vmca_debug
echo "Install VidOn Cloud Debug"
set apkfpath=\\10.10.2.72\nas\DVDFab_package\VidOn.me_Mobile\VidOn.meAndroidPlayer\Test\VidOn_Cloud_TV\
adb uninstall org.vidonme.cloud.tv
goto installapk




:install_vms
echo "Install VidOn Server"
set apkfpath=\\10.10.2.72\nas\DVDFab_package\daily_build\vbox1\VidOnServer\DEBUG\
 adb uninstall org.vidonme.server
goto installapk

:install_vms_debug
echo "Install VidOn Server Debug"
set apkfpath=\\10.10.2.72\nas\DVDFab_package\daily_build\vbox1\VidOnServer\DEBUG\
 adb uninstall org.vidonme.server
goto installapk

:get_vms_log
echo "Get VMS Log"
adb pull "/mnt/sdcard/Android/data/org.vidonme.server/files/.vidon/profile/VMS2.log" .
adb pull "/mnt/sdcard/Android/data/org.vidonme.server/files/.vidon/profile/MediaAnalysis.log" .
goto end


:installapk
@echo off
for /f "delims=" %%a in ('dir /b /od /A-D "%apkfpath%"') do (
    set filename=%%a
)
echo %apkfpath%%filename%
rem pause
adb install -r "%apkfpath%%filename%"
goto end


:err
echo %0 
echo "vmc | xbmc | vmcd | xbmcd | vmca | vmcad | vms | vmsd | vmslog | reboot"
echo.
echo 参数解释
echo 无参数时为连接机顶盒adb
echo vmc       安装RELEASE版 VidOn Media Center
echo vmcd      安装Debug版 VidOn Media Center
echo xbmc      安装RELEASE版 VidOn xbmc
echo xbmcd     安装Debug版 VidOn xbmc
echo vmca      安装RELEASE版 VidOn Cloud for TV
echo vmcad     安装Debug版 VidOn Cloud for TV
echo vms       安装RELEASE版 VidOn Server for Android
echo vmsd      安装Debug版 VidOn Server for Android
echo vmslog    获取VidOn Server日志文件
echo reboot    重启机顶盒

goto end

:end
echo.






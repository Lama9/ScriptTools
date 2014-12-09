#!/bin/bash

#Get XBMC AddOn all from XBMC website
#By Lama

#Global variables
LocalGitHubRepoRootPath="./LocalGitHubRepo"
PublicGitHubRepoRootPath="./GitHubRepo"
AddOnRepoRootPath="./AddOnRepo"

#Public Tools function
function CheckDir(){
    if [ ! -d "$1"]; then
        mkdir -p "$1"
        return 0
    else
        return 1
    fi
}

function CheckDirIsEmpty(){
    local l_fileCount='ls $1 | wc -l'
    if ["$l_fileCount" -gt "0"];then
        return 0
    else
        return 1
    fi
}

#Init git repo
function GetLocalGitHubRepo(){
    if [ ! -d "$LocalGitHubRepoRootPath"]; then
        mkdir "$LocalGitHubRepoRootPath"
    fi
    cd "$LocalGitHubRepoRootPath"
    git clone http://10.10.2.39/vidonme/addons.git
    cd ./addons
    git pull
    cd ../..
}

function GetPublicGitHubRepo(){
    if [ ! -d "$PublicGitHubRepoRootPath"]; then
        mkdir "$PublicGitHubRepoRootPath"
    fi
    cd "$PublicGitHubRepoRootPath"
    git clone http://10.10.2.39/vidonme/addons.git
    cd ./addons
    git pull
    cd ../..
}

function InitGitHubRepo(){
    echo ""
    
    if [ ! -d "./Zips" ]; then
        mkdir "./Zips"
    fi
    if [ ! -d "./Repo" ]; then
        mkdir "./Repo"
    fi
}

#检查是否所有的AddOn都有解压过的源码文件。如果没有则解压生成相应文件。
function CheckSourceCodeFile(){
    if [ ! -d "./Zips" ]; then
        mkdir "./Zips"
        return
    fi
    cd "./Zips"
    
    local ZipsFolderList=($(ls -F | grep '/$'))
    local TempUrl=""
    local Count=0
    for TempUrl in ${ZipsFolderList[@]}
    do
#        if [ " ! -d "../Repo/$TempUrl" " -o " CheckDirIsEmpty "../Repo/$TempUrl" " ]; then
            cd "$TempUrl"
            local ZipsFilesList=($(ls | grep -i '.zip') )
            if [ -n "${ZipsFilesList[0]}" ]; then
                unzip -o -q -d ../../Repo/ ${ZipsFilesList[0]}
            fi
            cd ..
#        fi
        
        Count=`expr $Count + 1`
        clear
        echo "$Count/${#ZipsFolderList[@]}"
    done
    
    cd ..

}

function GetAddOnVersion(){
    local AddOnXml=$1
    local AddOnVersion=($( grep  -o 'version=\([0-9,\.,\"]\+\)' "./addon.xml" | grep -o '\([0-9,\.]\+\)'));
    return ${AddOnVersion[1]}
}

#检查是否所有的AddOn都有解压过的源码文件。如果没有则解压生成相应文件。
function CheckZipFile(){
    if [ ! -d "./Repo" ]; then
        mkdir "./Repo"
        return
    fi
    cd "./Repo"
    
    local ZipsFolderList=($(ls -F | grep '/$'))
    local TempUrl=""
    for TempUrl in ${ZipsFolderList[@]}
    do
        cd "$TempUrl"
        local AddOnVersion=GetAddOnVersion
        if [ [ ! -d "../Zips/$TempUrl" ] -o [ CheckDirIsEmpty "../Zips/$TempUrl" ] ]; then
            
            local ZipsFilesList=($(ls | grep -i '.zip') )
            if [ -n "${ZipsFilesList[0]}" ]; then
#                unzip -d ../../Repo/ ${ZipsFilesList[0]}
                echo " unzip "
            fi
        fi
        cd ..

    done
    
    cd ..

}

function PushPublicGitHub(){
    cd "./GitHubRepo/CrazyAddOns/"
    echo "git pull"
    git pull
    echo "git add ."
    git add .
    echo "git commit"
    git commit -a -m "commit"
    echo "git push"
    git push
    cd "../../"
   
}

function CreatAddOnXMLFile(){
    cd "$1"
    python addons_xml_generator.py
    cd ..
}

function CopyFileToPublicGitHub(){
    cp -f ./AddOnRepo/addons.xml ./GitHubRepo/CrazyAddOns/
    cp -f ./AddOnRepo/addons.xml.md5 ./GitHubRepo/CrazyAddOns/
    cp -f -R ./AddOnRepo/Zips/* ./GitHubRepo/CrazyAddOns/Zips/
    
#    cd ./AddOnRepo/Zips/
#    local ZipsFolderList=($(ls -F | grep '/$'))
#    local TempUrl=""
#    local Count=0
#    for TempUrl in ${ZipsFolderList[@]}
#    do
##        if [ " ! -d "../Repo/$TempUrl" " -o " CheckDirIsEmpty "../Repo/$TempUrl" " ]; then
#            cd "$TempUrl"
#            local ZipsFilesList=($(ls | grep -i '.zip') )
#            
#            for TempFileName in ${ZipsFilesList[@]}
#            do
#                if [ "! -d "../../.././GitHubRepo/CrazyAddOns/Zips/"" -o "! -f "../../.././GitHubRepo/CrazyAddOns/Zips/$TempFileName"" -o "($(md5num ./$TempFileName)) != "($(md5num "../../.././GitHubRepo/CrazyAddOns/Zips/$TempFileName"))"" ]
#                    cp -f "./$TempFileName" ../../.././GitHubRepo/CrazyAddOns/Zips/
#                fi
#            done
#            
#            cd ..
##        fi
#        
#        Count=`expr $Count + 1`
#        clear
#        echo "$Count/${#ZipsFolderList[@]}"
#    done
#    cd ..
}

function CopyFileFromLocalGitHub(){
    cd ./LocalGitHubRepo/addons/
    git pull
    cp -f -R ./addons/repo/* ../.././AddOnRepo/Zips
    cd ../../
}

function UnzipAddonFile(){
    cd ./AddOnRepo
    CheckSourceCodeFile
    cd ..
}


if [ -n $1 ]; then
    CopyFileFromLocalGitHub
    UnzipAddonFile
    CreatAddOnXMLFile "./AddOnRepo"
    CopyFileToPublicGitHub
    
    cd "./GitHubRepo/CrazyAddOns/"
    git status
    cd ../../
    PushPublicGitHub
elif [ "$1" == "updatapublic" ]; then
    echo ""
fi
exit


#!/bin/bash

#Get XBMC AddOn all from XBMC website
#By Lama

RootFolder="./AddOn"
TempFolder="./Temp"
RootUrl="http://mirrors.xbmc.org/addons/frodo/"
GetZipFileCount=0

#Download Zip File
function DownloadFile(){
    local CUrl=$1
    
    wget -nc $CUrl
}

#Get html file and analysis Url 
function GetUrlData(){
    local CUrl=$1
    OLD_IFS="$IFS"
    IFS="/"
    local CUrlArr=($CUrl);
    local CUrlArrLength=${#CUrlArr[@]}
    IFS="$OLD_IFS"
    

    local SaveFileName="./${CUrlArr[(`expr $CUrlArrLength - 1`)]}"

    if [ ! -d $SaveFileName ]; then
        mkdir $SaveFileName
    fi
    cd $SaveFileName
    wget -q $CUrl
    
    #Recursive analysis URL
    local CurUrl=($(grep -o '>plugin.video\([a-Z,\.,\s,\/,\_,0-9,\-]\+\)' "./index.html" | grep -o 'plugin.video\([a-Z,\.,\s,\/,\_,0-9,\-]\+\)'));
#    echo ${#CurUrl[@]} "============" ${CurUrl[@]}  "-------" ${CurUrl[0]}
		local TempUrl=""
    for TempUrl in ${CurUrl[@]}
    do
        local urlstring="$CUrl$TempUrl"
        StartGetAddOn $urlstring
        #Just download the latest zip package
        if [ ${urlstring: -3} == "zip" ]; then
            GetZipFileCount=`expr $GetZipFileCount + 1`
            
            echo "GetZipFileCount:$GetZipFileCount"
            break;
        fi

    done
    
    rm index.html
    cd ..
}


function StartGetAddOn(){
	StartUrl=$1
	if [ ${StartUrl: -1} == "/" ]; then
	    GetUrlData "$StartUrl";
	elif [ ${StartUrl: -3} == "zip" ]; then
	    DownloadFile "$StartUrl";
	fi
}




if [ -n "$1" ]; then
    CurUrl=$1
else
    CurUrl="http://mirrors.xbmc.org/addons/frodo/"
    
    if [ ! -d "$TempFolder" ]; then
        echo "Creat TempFolder"
        mkdir "$TempFolder"
    fi

    if [ ! -d "$RootFolder" ]; then
        echo "Creat RootFolder"
        mkdir "$RootFolder"
    fi

fi

cd ./AddOn
StartGetAddOn $CurUrl


#read -p "Press any key to continue." var

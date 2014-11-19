#!/bin/bash
#Statistics for a specified user submitted the day the number of lines of code.

function count() {
    local insert=0
    local delete=0
    local files=0
    while read line ;do
        
        current=`echo $line | awk -F',' '{printf $1}' | awk '{printf $1}'`
        if [[ -n $current ]]; then
            files=`expr $files + $current`
        fi
        
        current=`echo $line| awk -F',' '{printf $2}' | awk '{printf $1}'`
        if [[ -n $current ]]; then 
            insert=`expr $insert + $current`
        fi

        current=`echo $line | awk -F',' '{printf $3}' | awk '{printf $1}'`
        if [[ -n $current ]]; then
            delete=`expr $delete + $current`
        fi
    done < .tmp.count
    echo "$files file changed, $insert insertions(+), $delete deletions(-)"
}

function countAll() {
    echo $1
    git log --author=$1 --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
    count;
    rm .tmp.count
}

function countToday() {
    echo $1
    local current=`date +%s`;
    local begin=`date +%Y-%m-%d |xargs date +%s -d`;
    local minutes=$(($current - $begin));

    git log --author="$1" --since="$minutes seconds ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
    count;
    rm .tmp.count

}

function countOneDay() {
    echo $1
    git log --author=$1 --since="1 days ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
    count;
    rm .tmp.count

}

function DefultCount() {
    echo "text"
}




UserName=("yongjian.xing" "kun.xie" "fuhai.jin" "jiangwei.gai");
i=0;
length=${#UserName[@]};
git pull;
if [[ ! -n $1 ]] ; then
    echo "All User Today Code Count!";
    while [ "$i" != "$length" ] 
    do
        countToday ${UserName[$i]};
        i=$(expr "$i" + "1");
        echo;
    done 
    exit;
elif [[ ! -n $2 ]] ; then
    if [[ $1 = "all" ]] ; then
        echo "All User All Code Count!";
        while [ "$i" != "$length" ] 
        do
            countAll ${UserName[$i]};
            i=$(expr "$i" + "1");
            echo;
        done 
        exit;
    elif [[ $1 = "oneday" ]]; then

        echo "All User OneDay Code Count!";
        while [ "$i" != "$length" ] 
        do
            countOneDay ${UserName[$i]};
            i=$(expr "$i" + "1");
            echo;
        done 
        exit;
    elif [[ $1 = "today" ]]; then
        echo "All User Today Code Count!";
        while [ "$i" != "$length" ] 
        do
            countToday ${UserName[$i]};
            i=$(expr "$i" + "1");
            echo;
        done 
        exit;
    else
        echo "args: all | oneday | today";
    fi

else
if [[ $1 = "all" ]] ; then 
    echo "countall";
    countAll $2;
elif [[ $1 = "oneday" ]]; then
    countOneDay $2;
elif [[ $1 = "today" ]]; then
    countToday $2;
else
    echo "args: all | oneday | today";
fi
fi

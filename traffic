#!/bin/bash

if [ -n "$1" ]; then
eth_name=$1
else
eth_name="eth0"
fi

i=0

send_o=`busybox ifconfig $eth_name | grep bytes | awk '{print $6}' | awk -F : '{print $2}'`
recv_o=`busybox ifconfig $eth_name | grep bytes | awk '{print $2}' | awk -F : '{print $2}'`
send_n=$send_o
recv_n=$recv_o

while [ $i -le 999999999 ]; do
send_l=$send_n
recv_l=$recv_n
sleep 1
send_n=`busybox ifconfig $eth_name | grep bytes | awk '{print $6}' | awk -F : '{print $2}'`
recv_n=`busybox ifconfig $eth_name | grep bytes | awk '{print $2}' | awk -F : '{print $2}'`
i=`expr $i + 1`

#send_r=`expr /( $send_n - $send_l /) / 1024 /1024`
#recv_r=`expr /( $recv_n - $recv_l /) / 1024 /1024`
#total_r=`expr /( $send_r + $recv_r /)`

#send_ra=`expr /( $send_n - $send_o /) / $i / 1024 /1024`
#recv_ra=`expr /( $recv_n - $recv_o /) / $i / 1024 /1024`
#total_ra=`expr /( $send_ra + $recv_ra /) `


send_r=$(echo "scale=4;( $send_n - $send_l ) / 1024 /1024" | bc)
recv_r=$(echo "scale=4;( $recv_n - $recv_l ) / 1024 /1024" | bc)
total_r=$(echo "scale=4;( $send_r + $recv_r )" | bc)

send_ra=$(echo "scale=4;( $send_n - $send_o ) / $i / 1024 /1024" | bc)
recv_ra=$(echo "scale=4;( $recv_n - $recv_o ) / $i / 1024 /1024" | bc)
total_ra=$(echo "scale=4;( $send_ra + $recv_ra )" | bc)


sendn=`busybox ifconfig $eth_name | grep bytes | awk -F '(' '{print $3}' | awk -F ')' '{print $1}'`
recvn=`busybox ifconfig $eth_name | grep bytes | awk -F '(' '{print $2}' | awk -F ')' '{print $1}'`

clear
echo  "Run Time $i S"
echo  "Last second  :   Send rate: $send_r MBytes/sec  Recv rate: $recv_r MBytes/sec  Total rate: $total_r MBytes/sec"
echo  "Average value:   Send rate: $send_ra MBytes/sec  Recv rate: $recv_ra MBytes/sec  Total rate: $total_ra MBytes/sec"
echo  "Total traffic after startup:    Send traffic: $sendn  Recv traffic: $recvn"
done 

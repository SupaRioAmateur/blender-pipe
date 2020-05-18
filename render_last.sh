#!/bin/bash

#################################
# render last and send to discord
#################################
source "/home/supa/.sc/sc.ini"
FILE_DIR="/mnt/blender/"
FILE_OUTPUT_DIR=$FILE_DIR"output/"
FILE_LAST_PATH=`ls -1tr --group-directories-first $FILE_DIR*.blend | tail -1`
FILE_LAST=`basename $FILE_LAST_PATH`
FILE_NAME=`basename $FILE_LAST .blend`
TIME_START=`date +%m-%d.%H:%M:%S.`
FILE_OUTPUT_PRENAME=$TIME_START$FILE_NAME
FILE_OUTPUT_NAME=$TIME_START$FILE_NAME'0249.png'
FILE_OUTPUT_NAME_JPG=$TIME_START$FILE_NAME'.jpg'

echo $FILE_LAST started at $TIME_START

TIME_FLY=`blender -b $FILE_DIR$FILE_LAST -o $FILE_OUTPUT_DIR$FILE_OUTPUT_PRENAME -f -2 | grep -o -e "Time: [0-9]*:[0-9]*.[0-9]*"`

if [ -f $FILE_OUTPUT_DIR$FILE_OUTPUT_NAME ];
then
    convert $FILE_OUTPUT_DIR$FILE_OUTPUT_NAME $FILE_OUTPUT_DIR$FILE_OUTPUT_NAME_JPG 1>/dev/null
    curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"${TIME_FLY}\"}" $RIO_HOOK 1>/dev/null
    curl -F 'file=@'$FILE_OUTPUT_DIR$FILE_OUTPUT_NAME_JPG $RIO_HOOK 1>/dev/null
else
    pushbullet push all note $FILE_LAST started at $TIME_START, but failed 1>/dev/null
fi
exit



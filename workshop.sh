#!/bin/bash
while read p; do
        /home/steamcmd.sh +login anonymous +workshop_download_item 282440 $p +quit
  done < /home/steamapps/common/qlds/baseq3/workshop.txt
mv /home/steamapps/workshop /home/steamapps/common/qlds/steamapps/workshop

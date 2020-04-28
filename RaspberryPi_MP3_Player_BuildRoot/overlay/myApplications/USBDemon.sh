#!/bin/bash


USBFlag=0
FirstDetectUSB_Flag=0
FirstUSBDetect=0
SecondUSBDetect=0

while true
do
sleep 1
NewUSB=$(find /dev/ -name sd*)
   if  [[  -z $NewUSB  ]] ; then 
	#echo "no USB Found"
	if [[  $USBFlag  -eq 1 ]] ; then
		echo "Flag=1" > DetectUSB
		USBFlag=0 
	fi
   else #something now is connected
	#Another detect the usb 
    if [  "$FirstDetectUSB_Flag" -eq 1 ] ; then
        	FirstDetectUSB_Flag=0
       		SecondUSBDetect=$NewUSB
	else
    #Firest USB 
       		FirstDetectUSB_Flag=$[ $FirstDetectUSB_Flag +1 ]
        	FirstUSBDetect=$NewUSB
	fi
	if ! [  "$SecondUSBDetect" = "$FirstUSBDetect"  ] ; then # a change happens  
     		 partitions="$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}')"
      	    for partition in $partitions; do
	  	echo "$partition is connected"
          	mountpoint="/media/$partition)"
          	mkdir -p $mountpoint
          	mount $partition $mountpoint &>/dev/null
		no_of_songs_media=$(find $mountpoint -name "*.mp3" | wc -l)
		type="$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $11}')"
		size="$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $8}')"
	        espeak " $no_of_songs_media mp3 songs Found on USB " --stdout  >x.wave
                aplay x.wave 
                espeak "it's type is $type and it's size is $size" --stdout >y.wave
                aplay y.wave 
                echo "Flag=1" > DetectUSB
	        USBFlag=1
	    done
	fi
  fi
done

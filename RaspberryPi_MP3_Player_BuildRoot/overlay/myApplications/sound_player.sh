#! /bin/sh


Directory="/"
flag_1=0

initSongsArray()
{
Start_Flag=0
Songs=()
number_of_songs=0
PlayFlag=0

while IFS= read -r var
do 
  Songs+=($var)
  number_of_songs=$[ $number_of_songs +1 ]
done <<<  $(find $Directory -iname "*mp3" 2>/dev/null) &>/dev/null 
echo "Number of Songs is  " $number_of_songs

MaxSongArray=$[$number_of_songs-1]


}
initSongsArray

#pin 17 -> start button
if [ ! -d /sys/class/gpio/gpio17 ]
 then
   
   echo "17" >/sys/class/gpio/export
   echo "in" >/sys/class/gpio/gpio17/direction
fi

#pin 18 -> stop button
if [ ! -d /sys/class/gpio/gpio18 ]
 then
   echo "18" >/sys/class/gpio/export
   echo "in" >/sys/class/gpio/gpio18/direction
fi

#pin 23 -> next button
if [ ! -d /sys/class/gpio/gpio23 ]
 then
  echo "23" >/sys/class/gpio/export
  echo "in" >/sys/class/gpio/gpio23/direction
fi

#pin 24 -> pre button
if [ ! -d /sys/class/gpio/gpio24 ]
 then
 echo "24" >/sys/class/gpio/export
 echo "in" >/sys/class/gpio/gpio24/direction
fi

#pin 25 -> shuffel button
if [ ! -d /sys/class/gpio/gpio25 ]
 then
 echo "25" >/sys/class/gpio/export
 echo "in" >/sys/class/gpio/gpio25/direction
fi



while true
do
   source /myApplications/DetectUSB
   if [[ $Flag -eq 1 ]] ;
   then
   last_song=${Songs[$song_index]}
   counter=0
   pidof mpg123 | xargs kill -9 $RESULT &> /dev/null 
   initSongsArray
   for item in ${Songs[*]}
     do
      if [[ $item == $last_song ]]
        then
         Start_Flag=1
         PlayFlag=1
         song_index=$counter
         ( nohup mpg123 ${item}  >out.txt 2>err.txt & )
     fi
    counter=$(($counter+1))
    done
   echo Flag=0 >/myApplications/DetectUSB
   fi 

  if [ $flag_1 -eq 1 ]
    then
      flag_1=0
      if [ $PlayFlag -eq 1 ]
        then
           echo "${Songs[$song_index]} is running "
      elif [ $PlayFlag -eq 0 ]
        then
          echo "${Songs[$song_index]} is Stopped "
     elif [ $song_index -eq 0 ]
       then
         echo "No Songs founds "
      fi
  elif [ $flag_1 -eq 2 ]
    then
      flag_1=0
      echo "${Songs[$song_index]} is continued "
  fi
 

   if [ $(cat /sys/class/gpio/gpio17/value) -eq 1 ];  #start
     then
      sleep 1s
       PlayFlag=1
       flag_1=1
       #first start of mp3 player
       if [ $Start_Flag -eq 0 ]
         then
            Start_Flag=1   
            ( nohup mpg123 ${Songs[@]:$song_index}  >out.txt 2>err.txt & )
         else
           #continue the song
           flag_1=2
           pidof mpg123 | xargs kill -18
         fi 
     fi
     #next
   if [ $(cat /sys/class/gpio/gpio23/value) -eq 1 ];
     then
        sleep 1s
        flag_1=1
        if [ $PlayFlag -eq 1 ]
        then 
            song_index=$(($song_index+1))
            if [ $song_index -gt $MaxSongArray ];
               then
                  song_index=0
            fi 
            pidof mpg123 | xargs kill -9 &>/dev/null
           ( nohup mpg123 ${Songs[@]:$song_index}  >out.txt 2>err.txt & )
        fi
   fi
   if [ $(cat /sys/class/gpio/gpio24/value) -eq 1 ];
      then
          sleep 1s
          flag_1=1
          if [ $PlayFlag -eq 1 ]
             then 
              song_index=$(($song_index-1))
              if  [ $song_index -lt 0 ]
                then
                   song_index=$MaxSongArray
               fi
              pidof mpg123 | xargs kill -9 $RESULT &> /dev/null
              ( nohup mpg123 ${Songs[@]:$song_index}  >out.txt 2>err.txt & )
            fi   
   fi 

     #stop
     if [ $(cat /sys/class/gpio/gpio18/value) -eq 1 ];
        then
           sleep 1s
           pidof mpg123 | xargs kill -20
           PlayFlag=0 
           flag_1=1
     fi
   #shuffel
   if [ $(cat /sys/class/gpio/gpio25/value) -eq 1 ];
     then
        sleep 1s
        if [ $PlayFlag -eq 1 ]
        then 
            pidof mpg123 | xargs kill -9 &>/dev/null
           ( nohup mpg123 -z  ${Songs[@]}  >out.txt 2>err.txt & )
           echo "MP3 player is shuffling  songs "
      fi
   fi

done


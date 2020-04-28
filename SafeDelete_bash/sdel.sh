#!/bin/bash
#for periodic run 
(crontab -l 2>/dev/null;echo "*/30 * * * * sdel.sh") | crontab -	
#check if the TRASH is exist or Not
if [ -d ~/TRASH ]
then
	echo "TRASH Folder is exist" 
else
	echo "TRASH Folder is not exist"	
	mkdir TRASH
fi 

#echo $#
#check all the input arguments
for item in $@
do 
	#check if the file is aleady compressed or not 	
	if  file $item | grep -q "gzip" 
	then
		mv $item.tgz ~/TRASH 
		rm -r $item
	elif ! [ -e $item ]
	then
		echo "The file Not exist"
	else 
		tar -zcvf $item.tgz $item
		mv $item.tgz ~/TRASH
		rm -r $item
	fi
done
#delte the files that are modeified from more 2 days  
find ~/TRASH -type f -mmin +48 -exec rm -f {} \;

########
#tar -zxvf result.tgz

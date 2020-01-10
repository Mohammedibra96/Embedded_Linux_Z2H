#!/bin/bash

(crontab -l 2>/dev/null;
echo "*/30 * * * * mytrash") | crontab -	
if [ -d ~/TRASH ]
then
	echo "The Folder is exist" 
else
	echo "The Folder is not exist"	
	mkdir TRASH
fi 

echo $#
for item in $@
do 
	#echo $item
	if  file $item | grep -q "gzip" 
	then
		mv $item.tgz /home/mohamed/TRASH 
		rm -r $item
	elif ! [ -e $item ]
	then
		echo "The file Not exist"
	else 
		tar -zcvf $item.tgz $item
		mv $item.tgz /home/mohamed/TRASH
		rm -r $item
	fi
done

find /home/mohamed/TRASH -type f -mmin +48 -exec rm -f {} \;

########
#tar -zxvf result.tgz

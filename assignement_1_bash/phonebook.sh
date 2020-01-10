#!/bin/bash
clear

c=0
Arr=()   #Array for names 
Number=() #Array for first Number 
Number2=() #Array for the second Number
c=0
c2=0
DelteAll=0   #flag For Delete all option 
#read contacts from phonebookDB.txt
input=~/phonebookDB.txt
if [ -e ~/phonebookDB.txt  ]
then
	echo "The file is exist"	
	while IFS= read -r line
	do		
		line="$(echo "$line"|tr -d '\n')" 
		if [[ $c == 0 ]]
		then 
			#first line name 				
			Arr[$c2]="$line"
			c=$[$c+1]
				
		elif [[ $c == 1 ]]
		then 
			#second line Number 1
			Number[$c2]="$line"
			c=$[$c+1]
			
		elif [[ $c == 2 ]]
		then 
			#third line Number 2			
			Number2[$c2]="$line"
			c=$[$c-2]
			c2=$[$c2+1]		
		fi
	done < "$input"
 
else
	echo "The file is not exist"	
fi 



####################
###################
###################

continue=1
skip=1
if [[ $1 == '-v' ]]
then 
	echo "view ALL"
elif [[ $1 == '-i' ]]
then 
	echo "Insert contact"
	choose=1
elif [[ $1 == '-e' ]]
then 
	echo "Delete ALL"
	choose=4
elif [[ $1 == '-d' ]]
then 
	echo "Delete by Name"
	choose=2
elif [[ $1 == '-s' ]]
then	 
	echo "Search by Name"
	choose=5
else 
	echo "No extention used"
	skip=0;
fi 

while [ $continue == 1 ];
do
	if [[ $skip == 0 ]]
	then 
		echo "************************************************"
		echo "Plz chose mode"
		echo "1)Add Contact"
		echo "2)Remove Contact"
		echo "3)View All"
		echo "4)Delete All"
		echo "5)Search By Name"
		echo "6)Exit"  
		read -p "Plz enter Choice: " choose
	fi 
if [[ $choose == 1 ]];
then
	clear
	echo "Add Contact"
	read -p "Plz enter Name: " AddedName
	read -p "Plz enter Number: " AddedNumber
	reg='^[0-9]{8}$'
	while [[ ! $AddedNumber =~ ^[0-9]+$ ]]   #the number must be a digit
	do
		read -p "Plz enter a valid number: " AddedNumber
	done
 	read -p "Do you want to enter second Number y or n: " ch
	if [[ $ch == 'y' ]]
	then 
	read -p "Plz enter Number 2: " AddedNumber2
	while [[ ! $AddedNumber2 =~ ^[0-9]+$ ]]
	do
		read -p "Plz enter a valid number: " AddedNumber2
	done	
	else 
		AddedNumber2=-1   #if there isn't number 2  
	fi
	f=1
	for item in ${Arr[*]}
	do 
		if [[ $item == $AddedName ]]
			then 
			echo "Found a name"
			f=0
		fi 
	done 
	if [[ $f == 1 ]]
	then
		#insert contact in the 3 arrays names and number 1 number 2 
		size=${#Arr[*]}		
		Arr[$size]=$AddedName	
		Number[$size]=$AddedNumber
		Number2[$size]=$AddedNumber2 	
		echo "Insert a contact is Done"
	else 
		echo "Failed to insert a contact because the name is dublicate"
	fi 	
elif [[ $choose == 2 ]]
then 
clear 
echo "remove Contact"
#######################
#######################
#######################
#Remove An element
flag=0
read -p "Plz enter  Name " value
SearchCounter=0
for itemi in ${Arr[*]}
	do 
	if [[ $itemi == $value ]]
	then 
		unset 'Arr[SearchCounter]'
		unset 'Number[SearchCounter]'
		unset 'Number2[SearchCounter]'
		flag=1
		SearchCounter=$[$SearchCounter+1]
	else 
		SearchCounter=$[$SearchCounter+1]
	fi 
done 
if [[ $flag == 1 ]]
then
	echo "Delete is done successfully" 
else 
	echo "The element is not exist"
fi 

elif [[ $choose == 3 ]]
then
clear
echo "***************************"
echo "View All"
#########################
##########################
##########################
#view All

Counter1=0
printf "You have %d Contacts in the list." ${#Number[*]}
echo ''
echo '******************************' 

for item in ${Arr[*]}
do
printf "%s\t\t" "Name:" 
printf "%s\t" $item
Counter1=$[$Counter1+1]
done 
echo " "
Counter2=0
for itemm in ${Number[*]}
do 
printf "%s\t" "First Number:"
printf "%s\t" $itemm
Counter2=$[$Counter2+1]
done 

echo " "
Counter2=0

for itemm in ${Number2[*]}
do 
printf "%s\t" "Second Number:"
if [[ $itemm == -1  ]]  #if this contact hasn't number 2
then 

	printf "%s\t" "N/A"   #not applicable
else 
	printf "%s\t" $itemm
	Counter2=$[$Counter2+1]
fi
done 

echo " "

##########################
##########################
############################
elif [[ $choose == 4 ]]
then 
clear  
echo "***************************"
echo "Delete All Mode"
Arr=()
Number=()
Number2=()
rm -f ~/phonebookDB.txt
touch ~/phonebookDB.txt
DelteAll=1
elif [[ $choose == 5 ]]
then
clear 
read -p "Plz enter  Name: " SearchedName
Counter3=0
Found=0
for item in ${Arr[*]}
do
if [[ $item == $SearchedName ]]
then
Found=1 
echo "The contact information is:"
printf "%s   \t" "Name:"
echo $item
printf "%s\t" "Number 1:"
echo ${Number[$Counter3]}
printf "%s\t" "Number 2:"
if [[ ${Number2[$Counter3]} == -1  ]]
then 
	printf "%s\t" "N/A"
	echo ""
else 
	printf "%s\t" ${Number2[$Counter3]}
	echo ""
fi
else 
Counter3=$[$Counter3+1]
fi
done
if [[ $Found == 0 ]]
then
echo "No Founded Contact"
fi 
elif [[ $choose == 6 ]]
then 
clear 
echo "***************************"
echo "Exit Mode"
#if the file is exist Delete then update
if [[	$DelteAll != 1 ]]
then 
rm -f ~/phonebookDB.txt
fi 
Counter1=0
for item in ${Arr[*]}
do 
echo $item >> ~/phonebookDB.txt 
echo ${Number[$Counter1]} >> ~/phonebookDB.txt
echo ${Number2[$Counter1]} >> ~/phonebookDB.txt
Counter1=$[$Counter1+1]
done
continue=0
else 
clear
echo "plz enter valid choice"
fi 
skip=0
done 

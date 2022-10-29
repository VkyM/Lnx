## MySql multiple db backup with simple configuration
```
#!/bin/bash

# Give Mysql configuration in the middle of " ".

host="192.168.100.xx"			# This is mysql ip
Server="MyServer"				# Alternative name for mysql server
port="3306"						# Mysql port number
user="vkydb"					# Mysql username
passwd="vky@zz!23"				# Mysql password
DataBases=(db1 db2 db3)			# Give the databases which want to be backup
mail_id="dbbackup@zzz.com"		# Give the mail id to receive acknowledgement
Dest="Backup/"					# Give the destination folder to store the sql file

# Dont edit the below code 

NumberOfDb=${#DataBases[@]}				# This variable store length of Databases array value
Error=0									# This is flag variable that defines any error or not while backup.
Errdb=0									# This variable stores no.of db could not be backup
touch Msg.txt							# It creates the Msg.txt file.
echo -n > Msg.txt						# Insert next line in Msg.txt file
echo "Server : $Server" >> Msg.txt		# Insert Server Name in Msg.txt file
echo "Host   : $host" >> Msg.txt		# Insert Host ip in Msg.txt 
echo -e "\n Number of Database : $NumberOfDb \n" >> Msg.txt 	# Insert No.of DB in Msg.txt file
#echo $host $user $NumberOfDb			# For testing the variable 

for (( i=0,j=1;i<${NumberOfDb};i++,j++))
do
	mysqldump --column-statistics=0 -h $host --port $port -u $user -p$passwd -R ${DataBases[$i]} > $Dest${DataBases[$i]}$(date +%d%m%Y).sql
	if [ "$?" -eq "0" ]
	then
		echo -e "$j. ${DataBases[$i]} -> DB backup is completed successfully \n" >> Msg.txt
	    	echo "done"
	else
		echo -e "$j. ${DataBases[$i]} -> DB Backup Error \n" >> Msg.txt 
		Error=1
		let Errdb++
		echo "Error"
	fi
done

if [ "$Error" -eq "1" ]
then
	mail -s "$Server: $Errdb DB could not be Backup " $mail_id < Msg.txt
else
	mail -s "$Server DB Backup is completed successfully" $mail_id < Msg.txt
fi
```



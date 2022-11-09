## Send alert mail when backup is complete. 

Steps:

1. Install ssmtp and mailutils
2. Create User for sending mail
3. Set SMTP Server
4. Create Script for backup
5. Add the Scrpt in crontab.
----------------------------------------------------------------------------------------------------------

### 1. Install ssmtp and mailutils 
```

# To install ssmtp
sudo apt install ssmtp 

# To remove unnecessory packages because of more packages are installed during install ssmtp
sudo apt autoremove 

# For mail command
sudo apt install mailutils 

```
----------------------------------------------------------------------------------------------------------

### 2. Create user for sending mail 
```

sudo useradd -m <mail_user>
# -m for create home directory.

# Set password for mail user.
sudo passwd <mail_user>

# Set specific command to run for mail user cause of sending mail using visudo
<mail_user> ALL=NOPASSWD: /usr/bin/mail, /usr/bin/echo
```
Note:-
```
That <mail_user> have mail account.
For Example:- If mail_user name is vignesh.m, mail id is same 
Ex:- vignesh.m@zzz.com -> valid mail id
```
----------------------------------------------------------------------------------------------------------

### 3. Set smtp server under /etc/ssmtp/ssmtp.conf:(only edit by sudo user) 
```

root=postmaster

#SMTP Server
mailhub=mail.zzz.com:465

# domain name
hostname=zzz.com

#mail user name
AuthUser=vignesh.m@zzz.com

# mail password
AuthPass=Vyyy@xxx

# For secure
UseTLS=Yes

```
----------------------------------------------------------------------------------------------------------------

### 4. Create Script for backup mysql database 

Ex:-
```
#!/bin/bash
mysqldump -u <db_user> -h localhost -p<password> -R <dbname> > /home/mail_user/dump$(date +%Y-%m-%d_%H_%M).sql
if [ "$?" -eq "0" ]
then
  sudo echo "sys backup complete" | mail -s "Backup Complete" vicky.sys@gmail.com
# echo "done";
else
  sudo echo "sys backup incomplete" | mail -s "Error During Backup" vicky.sys@gmail.com
#       echo "Error while running mysqldump"
fi
```

Note:-
```
	$? 	-> means value from past command, if past command is successfull,? value is 0 otherwise some value.
	echo 	-> body of the message.
	-s	-> subject of the message.
	At End	-> To Whom you want send? in case "To" is vicky.nimdasys@gmail.com 
	
	If you use rsync command, Then give permission to source dir/file for mail_user.


If script is successfully running, then add in <mail_user> crontab. 	 
```
-------------------------------------------------------------------------------------------------------------------------
### 5. Add the Scrpt in crontab.
Ex:-
`50 23 * * * sh /home/mail_user/<script_name>`
OR
`50 23 * * * ./<script_name>`

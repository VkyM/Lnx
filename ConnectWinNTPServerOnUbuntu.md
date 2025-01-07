## Get time from NTP server of Windows 11 on ubuntu

Steps:

1. Configure NTP Server on Windows 11
2. Check the Windows NTP Server on network
3. Install and configure NTP on ubuntu as client
4. Connect with Windows NTP server from ubuntu
----------------------------------------------------------------------------------------------------------

### 1. Configure NTP Server on Windows 11 

Open PowerShell as Administrator.
Check the status of the Windows Time service:  
`Get-Service W32Time`

If the service is stopped, start it:  
`Start-Service W32Time`

Set the service to start automatically:  
`Set-Service W32Time -StartupType Automatic`

Modify the registry to configure the Windows Time service to act as an NTP server:  
`Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Name "AnnounceFlags" -Value 5`

Restart the Windows Time service for the changes to take effect:  
`Restart-Service W32Time`

Set NTP Server
```
w32tm /config /manualpeerlist:<IP_Address> /syncfromflags:manual /reliable:yes /update
net stop w32time
net start w32time
```
----------------------------------------------------------------------------------------------------------

### 2. Check the Windows NTP Server on network  

On the ubuntu system
`sudo nmap -sU -p <Windows_NTP_Server`

----------------------------------------------------------------------------------------------------------

### 3. Install and configure NTP on ubuntu as client 
```
sudo apt install ntp -y
sudo nano /etc/ntp.conf

# Add the below line in /etc/ntp.conf file and comment the other ntp server 
server <WINDOWS_NTP_SERVER_IP> iburst

sudo systemctl restart ntp
```

----------------------------------------------------------------------------------------------------------------

### 4. Connect with Windows NTP server from ubuntu  

`sudo ntpdate -u <NTP Server IP>`


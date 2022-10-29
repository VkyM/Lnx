### connect tcp/udp stream via jumphost. ###

1. Install nginx
2. Add stream directive in nginx.conf file.
3. create directory structure as mentioned in stream directive
4. create stream conf file.
5. Testing the stream.

--------------------------------------------------------------------------------------------------------------
####1. Install nginx for reverse proxy ####
`sudo apt install nginx`

--------------------------------------------------------------------------------------------------------------
#### 2. Add stream directive in nginx.conf file ####
```

stream {

    # Reverse proxy stream configuration files.
    include /etc/nginx/rproxy/streams/enabled/*.conf;
}

```
--------------------------------------------------------------------------------------------------------------
#### 3.  create directory structure as mentioned in stream directive ####
```
	etc
	|_nginx
	   |_rproxy
	      |_streams
		    |_available
		    |_enabled
```
Note:- 
	* availabe -> create conf file.	
	* enabled  -> link files that refers "avilable" directory. ( Easily manage conf files)
----------------------------------------------------------------------------------------------------------------
#### 4. create stream conf file. ####
We create stream conf in the order of service (or) host.

Per Host:
streams/available/server1.cybernexa.com.conf
```
			upstream web1-ssh 
			{
 				server 192.168.1.2:22;
			}

			server 
			{
				listen 22002;
				proxy_pass web1-ssh;
			}
	
			upstream db1-mysql
			{
				server 192.168.1.3:3306;
			}

			server 
			{
				listen 33063;
				proxy_pass db1-mysql;
			}
```

Per Service:
streams/available/ssh.conf
```
			upstream web1-ssh 
			{
 				server 192.168.1.3:22;
			}

			server 
			{
				listen 22002;
				proxy_pass web1-ssh;
			}
		
			upstream web2-ssh 
			{
 				server 192.168.1.4:22;
			}				
			server 
			{
				listen 22003;
				proxy_pass web2-ssh;
			}
```
Note:
Create link for conf files.
`sudo ln -s /etc/nginx/rproxy/streams/available/*.conf /etc/nginx/rproxy/streams/enabled`
-------------------------------------------------------------------------------------------------------------------------------------------------------

#### 5. Testing the stream. ####

Testing the nginx configuration syntax
`sudo nginx -t`

Restart the nginx service
`sudo systemctl restart nginx`

* Check listen ports are open in jump host using netstat command.
* If you want mysql via stream, Set private ip in mysql bind address.

-----------------------------------------------------------------------------------------------------------------------------------------------------------


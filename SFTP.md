# SFTP Server
Add The Following lines in **/etc/ssh/sshd_config** to configure SFTP Server.
```
#Subsystem      sftp    /usr/lib/openssh/sftp-server            -> Comment if it is uncommented

# Enable password authentication to particular group for access sftp without key

    Match Group SftpGroup
            PasswordAuthentication yes
    Match all


Subsystem sftp internal-sftp

Match User SftpAdmin
   ChrootDirectory /SFTP                -> cannot move its parent directory
   ForceCommand internal-sftp
   X11Forwarding no
   AllowTcpForwarding no                -> Only for SFTP

Match User IT
   ChrootDirectory /SFTP/IT/
   ForceCommand internal-sftp
   X11Forwarding no
   AllowTcpForwarding no

Match User cosmos
   ChrootDirectory /SFTP/cosmos/
   ForceCommand internal-sftp
   X11Forwarding no
   AllowTcpForwarding no
```   

Note:- 
`ChrootDirectory directory must be owned by root and group root and have 755 mode, we can upload files under the sub directory of Chroot Directory`


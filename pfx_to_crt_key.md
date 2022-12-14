### Convert a pfx certificate to crt and key files

#### Extract encrypted private key
`openssl pkcs12 -in cert.pfx -nocerts -out cert-encrypted.key`

> Note:- **Type the password that you used to protect your keypair when you created the .pfx file. You will be prompted again to provide a new password to protect the .key file**

#### Convert encrypted private key to decrypted private key
`openssl rsa -in cert-encrypted.key -out cert.key`

#### Extract public key
` openssl pkcs12 -in cert.pfx -clcerts -nokeys -out cert.crt `

#### Generate CA file
` openssl pkcs12 -in cert.pfx -nokeys -nodes -cacerts -out ca-bundle.crt `

> Note:- **if ca-bundle is empty when extract from .pfx, Dont include httpd.conf**

### Usage in httpd config
```
<VirtualHost *:443>
	ServerName domain.com
	ServerAlias www.domain.com
	DocumentRoot www.domain.com
	SSLEngine              on
	SSLCertificateFile     /etc/pki/tls/certs/cert.crt
        SSLCACertificateFile   /etc/pki/tls/certs/ca-bundle.crt
	SSLCertificateKeyFile  /etc/pki/tls/certs/cert.key
</VirtualHost>
```

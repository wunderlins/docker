# ssl certificate

if you do not wont to use the self signed certificate, make sure to configure 
the real FQDN in `../.env` first. then add the following tow files in 
this folder:

- `tls.crt`: The Certificate in PEM format (i.e. `fullchain.pem` with letsencrypt)
- `tls.key`: The Private key in PEM format (i.e. `privkey.pem` with letsencrypt)

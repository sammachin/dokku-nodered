#! /bin/bash

#############################################################################################################
# Add this file to /home/ubuntu and then add a cron job for the following:
# 30 2 15 * * sudo certbot renew --deploy-hook /home/ubuntu/renew_certs.sh >/dev/null 2>&1
# That will run certbot renew at 02:30 on the 15th of each month, if the cert is renewed it then 
# runs this script as a post-deploy to install the new certs
#############################################################################################################

sudo cp  /etc/letsencrypt/live/workbench.red/fullchain.pem /home/ubuntu/server.crt
sudo cp  /etc/letsencrypt/live/workbench.red/privkey.pem /home/ubuntu/server.key
sudo rm /home/ubuntu/cert-key.tar 
tar cvf /home/ubuntu/cert-key.tar /home/ubuntu/server.key /home/ubuntu/server.crt 

for i in $(dokku apps:list --quiet); do
    echo "Updating $i"
    dokk

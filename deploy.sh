#! /bin/bash

appname=$1
user=$2
pass=`node pass.js`


if dokku --quiet apps:exists $appname
then
	echo "ERROR"
	exit
fi
echo "Deploying $appname"
dokku apps:create $appname
git remote add $appname dokku@nodered.nexmodev.com:$appname
git push $appname master
echo "Deployed"

echo "Setting up TLS"
dokku config:set --no-restart $appname DOKKU_LETSENCRYPT_EMAIL=devrel@nexmo.com
dokku letsencrypt $appname
echo "TLS Enabled"

echo "Setting password"
dokku enter $appname web node ./setpasswd.js $user $pass
echo "Restarting Node-RED"
dokku enter $appname web pkill node-red

echo READY `dokku url $appname` $user $pass 

#! /bin/bash

appname=$1
user=$2
pass=$3


echo "Setting password"
dokku enter $appname web node ./setpasswd.js $user $pass
echo "Restarting Node-RED"
dokku enter $appname web pkill node-red


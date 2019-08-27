#! /bin/bash

appname=$1


echo "Checking versions on $appname" 
dokku enter $appname web npm outdated

echo "Updating NodeRED to 0.20.5"
dokku enter $appname web  npm install node-red@0.20.5
dokku enter $appname web  npm update 

echo "Restarting Node-RED"
dokku enter $appname web pkill node-red


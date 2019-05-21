#! /bin/bash

appname=$1


if dokku --quiet apps:exists $appname
then
	exit
fi
echo "App does not exist"

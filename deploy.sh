#! /bin/bash
  
hostname='one.example.com'
domain='example.com'
appname=$1
user=$2
pass=`xkcdpass -n 4 -d ''`
aws_r53_zone='ABC123'

echo "Checking for Existing App"
if host ${appname}.${domain} | grep "${domain} has address"
then
        echo "ERROR ${appname} already exists"
        exit
fi

echo "Setting up DNS"
eval "cat <<EOF
$(<./dns.template)
EOF
" 2> /dev/null > dns.json
aws route53 change-resource-record-sets --hosted-zone-id ${aws_r53_zone} --change-batch file://dns.json
echo "DNS Complete"


echo "Deploying $appname"
dokku apps:create $appname
git remote add $appname dokku@127.0.0.1:$appname

mkdir /var/lib/dokku/data/storage/${appname}
mkdir /var/lib/dokku/data/storage/${appname}/files
mkdir /var/lib/dokku/data/storage/${appname}/userDir
dokku storage:mount $appname /var/lib/dokku/data/storage/${appname}/files:/files
dokku storage:mount $appname /var/lib/dokku/data/storage/${appname}/userDir:/userDir

git push $appname master
echo "Deployed"

echo "Setting up TLS"
dokku certs:add $appname < ~/cert-key.tar
echo "TLS Enabled"


echo "Setting password"
dokku enter $appname web node ./setpasswd.js $user $pass
echo "Restarting Node-RED"
dokku enter $appname web pkill node-red

echo READY 
echo URL: `dokku url $appname`
echo Username: $user
echo Password: $pass 

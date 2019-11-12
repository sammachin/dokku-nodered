#! /bin/bash
  
hostname='three.workbench.red'
domain='workbench.red'
appname=$1
aws_r53_zone='Z3LYIJDM6IDEPH'


echo "Removing DNS Record"
action='DELETE'
eval "cat <<EOF
$(<./dns.template)
EOF
" 2> /dev/null > dns.json
aws route53 change-resource-record-sets --hosted-zone-id ${aws_r53_zone} --change-batch file://dns.json
echo "DNS Complete"


echo "Destroying $appname"
dokku --force apps:destroy $appname

echo "Removing Git Remote"
git remote rm $appname

echo DONE 

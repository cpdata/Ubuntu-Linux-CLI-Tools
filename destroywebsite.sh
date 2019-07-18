#! /bin/bash
#FILENAME: destroywebsite.sh 
#Author: Charles Paul Cross  - charlie@cpdatadesigns.com
#Notes: Always run with sudo
#LICENSE: All Rights Reserved
#USAGE: ./destroywebsite.sh domain.com
#DESCRIPTION: eletes a websites apache2 config file and all associated directories and files.
##############################

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root ex.(sudo ./destroywebsite.sh)" 1>&2
   exit 1
fi

NEWSITE=$1


if [[ -z "$NEWSITE" ]]
then
echo "What website domain name would you like to destroy? ex.(domain.com) :"
read NEWSITE
fi

if [[ -n "$NEWSITE" ]]
then
echo "Deconstruction of $NEWSITE initialized......."
rm /etc/apache2/sites-available/$NEWSITE.conf
rm /etc/apache2/sites-enabled/$NEWSITE.conf
service apache2 reload
echo "/etc/apache2/sites-available/$NEWSITE.conf has been deleted and disabled."
echo "Delete all directories and files with recursive force /var/www/$NEWSITE ? ex.(yes/no) :"
read RESPONSE
if [[ "$RESPONSE" == "YES" ]] || [[ "$RESPONSE" == "yes" ]] || [[ "$RESPONSE" == "Y" ]] || [[ "$RESPONSE" == "y" ]] || [[ "$RESPONSE" == "Yes" ]]
then
rm -rf /var/www/$NEWSITE
echo "/var/www/$NEWSITE and all it's files have been permanently deleted!"
else
echo "/var/www/$NEWSITE folders and files were not deleted and are safe and sound......"
fi
echo "$NEWSITE Deconstruction complete!"
else
echo "Deconstruction FAILED!!! You must specify a website domain to destroy."
fi


#!/bin/bash
#FILENAME: deleteme.sh
#AUTHOR: Charles P. Cross
#EMAIL: charlie@cpdatadesigns.com
#LICENSE: All Rights Reserved
#USAGE: ./createFTPUser.sh domain.com newusername
#DESCRIPTION: Guides setting up a FTP user and setting them to a specific directory. Useful for shared hosting
##############################

DIRECTORY=$1
USER=$2
echo "What will be users password?"
sudo useradd --home /var/www/$DIRECTORY/public_html/ --group www-data --shell /bin/dummy $USER
sudo passwd $USER
sudo chown -R $USER:www-data /var/www/$DIRECTORY/public_html/
sudo chmod g+s /var/www/$DIRECTORY/public_html/
sudo service vsftpd restart 
echo "FTP User $USER has been created and setup on this Directory"
echo "/var/www/$DIRECTORY/public_html/"


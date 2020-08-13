#!/bin/bash
#
# NAME   : New Website Serverside Setup Wizard
# FILE   : makewebsite.sh
# AUTHOR : Charles Paul Cross - charlie@cpdatadesigns.com
#
# DESCRIPTION : Guides user with terminal prompt questions to configure and setup a new website on an
#                               linux/apache2 webserver. This is Useful for shared hosting. Apache Root must be set to /var/www else
#                               this file needs to be modified to where apache2 has route access.
#                               The root directory of the new site will be /var/www/SITENAMEHERE/public_html
#
# 1)Creates proper directory tree for a new website using the new user inputed domain name
# 2)If provided zip file will be extracted to the proper folder to populate the site
# 3)If SSL is needed a temporary self signed certificate is created along with a CSR that can be used to get real SSL
#   If SSL is selected as yes then the CSR and self signed are set up. Always select yes unless the site will never
#       use SSL which is not recommended.
# 4)Apache2 .conf file is created differently if ssl was selected then the site.conf is enabled for the provided domain
# 5)Sets proper certificate permissions and directory ownership
# 6)Reloads Apache2
#
# NOTES:
# 1)Assumes site directorys should be created as /var/www/SITENAMEHERE/public_html
# 2)Currently only unzips .zip files . tar.gz coming soon. You don't need a zip file. leave it blank and it will just
#   create a default welcome index.php page you can replace once you upload files to the directory. It's there to let
#       you know your DNS is pointing correctly and you did everything right. Or if it is a new site or you don't have a#       zip file.
# 3)SSL support creates Self-Signed certificate 50 years
# 4)Always run with sudo
# 5)The First 3 key prompts for creating the SSL is just for you it can be as simple as 1234 you just have to remember
#   it until the final step of the prompts. When asked for the Challenge password it is not the same thing as the key it
#       asked for in the beggining. You can leave this blank if not you may need to provide it to your SSL
#       certificate provider.
#
# Extended Commands: ./makewebsite.sh {DOMAIN_NAME} {FULL_PATH_TO_ZIP_FILE} {BOOL IS_USING_SSL}
# Example Use: sudo ./makewebsite.sh domain.com domain.com.zip 1
#
# COPYRIGHT: Any reproduction or use of this file is forbidden unless permission is given by the author.
#
#####
#Sudo has been added to every command
#####
# Make sure only root can run our script
#if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run with sudo or as root ex.(sudo ./makewebsite.sh)" 1>&2
#   exit 1
#fi
######

NEWSITE=$1
SITEFILES=$2
USESSL=$3

function createHost {

SITENAME=$1

sudo echo "<VirtualHost *:80>
        ServerAdmin webmaster@cpdatadesigns.com
        ServerName  $SITENAME
        ServerAlias www.$SITENAME

        # Indexes + Directory Root.
        DirectoryIndex index.php index.html index.htm
        DocumentRoot /var/www/$SITENAME/public_html

        # CGI Directory
        ScriptAlias /cgi-bin/ /var/www/$SITENAME/cgi-bin/
        <Location /cgi-bin>
                Options +ExecCGI
        </Location>


        # Logfiles
        ErrorLog  /var/www/$SITENAME/logs/error.log
        CustomLog /var/www/$SITENAME/logs/access.log combined
</VirtualHost>" > $SITENAME.conf

sudo mv $SITENAME.conf /etc/apache2/sites-available/$SITENAME.conf

sudo a2ensite $SITENAME.conf
sudo service apache2 reload


}

function createSSLHost {

SITENAME=$1

sudo echo "<VirtualHost *:80>
        ServerAdmin webmaster@cpdatadesigns.com
        ServerName  $SITENAME
        ServerAlias www.$SITENAME

        # Indexes + Directory Root.
        DirectoryIndex index.php index.html index.htm
        DocumentRoot /var/www/$SITENAME/public_html

        # CGI Directory
        ScriptAlias /cgi-bin/ /var/www/$SITENAME/cgi-bin/
        <Location /cgi-bin>
                Options +ExecCGI
        </Location>


        # Logfiles
        ErrorLog  /var/www/$SITENAME/logs/error.log
        CustomLog /var/www/$SITENAME/logs/access.log combined
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>

        ServerAdmin webmaster@cpdatadesigns.com
        ServerName  $SITENAME
        ServerAlias www.$SITENAME

        # Indexes + Directory Root.
        DirectoryIndex index.php index.html index.htm
        DocumentRoot /var/www/$SITENAME/public_html

        # CGI Directory
        ScriptAlias /cgi-bin/ /var/www/$SITENAME/cgi-bin/
        <Location /cgi-bin>
                Options +ExecCGI
        </Location>


        # Logfiles
        ErrorLog  /var/www/$SITENAME/logs/error.log
        CustomLog /var/www/$SITENAME/logs/access.log combined

        #   SSL Engine Switch:
        #   Enable/Disable SSL for this virtual host.
        SSLEngine on
        SSLCertificateFile /var/www/$SITENAME/ssl/certs/$SITENAME.crt
        SSLCertificateKeyFile /var/www/$SITENAME/ssl/keys/$SITENAME.key
        #SSLCertificateChainFile /var/www/$SITENAME/ssl/certs/$SITENAME.ca-bundle
</VirtualHost>

</IfModule>" > $SITENAME.conf

sudo mv $SITENAME.conf /etc/apache2/sites-available/$SITENAME.conf

sudo a2ensite $SITENAME.conf
sudo service apache2 reload


}

function createSelfSignedSSL {
SITENAME=$1
sudo openssl genrsa -des3 -out $SITENAME.key 2048
sudo openssl req -new -key $SITENAME.key -out $SITENAME.csr
sudo cp $SITENAME.key $SITENAME.backup.key
sudo openssl rsa -in $SITENAME.backup.key -out $SITENAME.key
sudo rm $SITENAME.backup.key
sudo openssl x509 -req -days 18250 -in $SITENAME.csr -signkey $SITENAME.key -out $SITENAME.crt
sudo mv $SITENAME.crt /var/www/$SITENAME/ssl/certs/
sudo mv $SITENAME.csr /var/www/$SITENAME/ssl/csrs
sudo mv $SITENAME.key /var/www/$SITENAME/ssl/keys

}

############################RUN TIME###################################


if [[ -z "$NEWSITE" ]]
then
echo "What is the new websites full domain name without 'http://www.' ex.(domain.com or sub.domain.com)? : "
read NEWSITE
fi

if [[ -n "$NEWSITE" ]]
then
echo "Creating new site $NEWSITE"
sudo mkdir /var/www/$NEWSITE
sudo mkdir /var/www/$NEWSITE/bin
sudo mkdir /var/www/$NEWSITE/tmp
sudo mkdir /var/www/$NEWSITE/logs
sudo mkdir /var/www/$NEWSITE/etc
sudo mkdir /var/www/$NEWSITE/keys
sudo mkdir /var/www/$NEWSITE/ssl
sudo mkdir /var/www/$NEWSITE/ssl/certs
sudo mkdir /var/www/$NEWSITE/ssl/csrs
sudo mkdir /var/www/$NEWSITE/ssl/keys
sudo mkdir /var/www/$NEWSITE/public_html
sudo mkdir /var/www/$NEWSITE/cgi-bin
sudo chown -R ubuntu:ubuntu /var/www/$NEWSITE
fi

if [[ -z "$SITEFILES" ]]
then
echo "What is the full path to the .zip file containing the new website? : "
read SITEFILES

fi

if [[ -f "$SITEFILES" ]]
then
sudo unzip $SITEFILES -d /var/www/$NEWSITE/public_html
sudo rm $SITEFILES
else
echo "No zip file to unpack $NEWSITE does not have any files....."
echo "<html><head><title>$NEWSITE</title></head><body><p>Welcome to $NEWSITE</p></body></html>" > /var/www/$NEWSITE/public_html/index.php
fi

if [[ -z "$USESSL" ]]
then

echo "Does this website need to use SSL for https ex.(yes/no)? : "
read USESSL

if [[ "$USESSL" == "YES" ]] || [[ "$USESSL" == "y" ]] || [[ "USESSL" == "Y" ]] || [[ "$USESSL" == "yes" ]] || [[ "$USESSL" == "Yes" ]]
then
USESSL=1
else
USESSL=0
fi

fi

if [[ $USESSL -eq 1 ]]
then
echo "Use any passphrase at least 4 characters no need to write it down it is temporary you just have to remember for the last step of creating this certificate."
createSelfSignedSSL "$NEWSITE"
echo "Temporary Self-Signed SSL certificate for $NEWSITE created!"
echo "Change SSL certificates out with the real ones at /var/www/$NEWSITE/ssl/"
createSSLHost "$NEWSITE"
echo "Apache2 configuration file $NEWSITE.conf with SSL created and enabled!"
else
createHost "$NEWSITE"
echo "Apache2 Configuration file $NEWSITE.conf without SSL created and enabled!"
fi


# Set Group and Permissions
sudo chown -R ubuntu:www-data /var/www/$NEWSITE/public_html
sudo chmod -R 640 /var/www/$NEWSITE/ssl/certs
sudo chmod -R 600 /var/www/$NEWSITE/ssl/keys
sudo chmod -R 600 /var/www/$NEWSITE/ssl/csrs

echo "--- !!!FINISHED!!! --- $NEWSITE setup complete!"

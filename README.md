# Ubuntu-Linux-CLI-Tools
This is a command line tool for linux webservers. It is a collection of bash and shell scripts that you can use to make your life easy as a system administrator. Designed and tested for Ubuntu Server OS. 

First move the files to your webserver then make sure your apache2 config file is set up to use /var/www/ instead of /var/www/html/ or you will have to modify this code.

All you need is the domain name to setup a site. You can even generate a self signed SSL certificate and use the CSR to get the
real SSL certificate once you are ready. 

makewebsite.sh = one script to set up multiple sites on one server and enable them in apache virtual host config

createFTPUser.sh = easily add new FTP users

destroywebsite.sh = easily destroy a websites files and configs then disable from apache

Requirements*
- Root or Sudo Access to system
- Basic Commandline skills
- Ubuntu Server or Desktop edition
- Terminal or SSH access to target System

 If you have questinos or need help you can find my email in the code or email at charlie [aat] cp datadesigns.com and I am
 more than willing to help. I also welcome any Ideas for features anyone would like added. More Linux CLI tools will be 
 uploaded soon.


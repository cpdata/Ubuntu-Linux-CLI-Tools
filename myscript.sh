#!/bin/bash
# myscript.sh
#Description: Creates a new bash script with execution permission
# and opens nano
#AUTHOR: Charles P. Cross
#Usage: -d : option deletes a script   ./newscript.sh -d /home/users/scripts script.sh
# Pass script name optional to create a new script ./newscript.sh myscript.sh
# Script is created in BASE directory which you need to specify
# If file already exists it won't be overwritten
##################################################
BASE=$1
FILE=$2

#Check for option
if [ "$FILE" = "-d" ]
then
FILE=$2

if [[ -z "$FILE" ]]
then
echo "What is the name of the script to DELETE? ex.(myscript.sh): "
read FILE
fi

if [[ -n "$FILE" ]]
then
# Delete file if it exists
if [[ -e "$BASE$FILE" ]]
then
rm $BASE$FILE
echo "$BASE$FILE has been deleted permanently!"
echo "Script is Exiting Now....!"
exit
else
echo "File doesn't exist! $BASE$FILE"
exit
fi

else
echo "No file specified for deletion!"
echo "Script is Exiting Now....!"
exit
fi

fi
#End of delete option

#Get Filename from input
if [[ -z "$FILE" ]]
then
echo "What is the name of your new script? ex.(myscript.sh): "
read FILE
fi

#If File was specified
if [[ -n "$FILE" ]]
then
if [[ ! -e $BASE$FILE ]]
then
# Create Script File
echo "#!/bin/bash
#FILENAME: $FILE
#AUTHOR: 
#EMAIL: 
#LICENSE: GNU GENERAL PUBLIC LICENSE
#USAGE:
#DESCRIPTION:
##############################
" > $BASE$FILE
fi
# Set Permissions for Owner Execution
chmod 700 $BASE$FILE
nano $BASE$FILE
echo "Script Location: $BASE$FILE"
exit
else
echo "No filename was provided FAIL!"
exit
fi

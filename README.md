# User-Group-migration-script
Simple powershell script to move users from one group to another

To use simply place a csv file entitled "users.csv" into the same directory as the script. Add users account details in a list as below. Edit the PS1
and input the group variables at the top of the script page. 

##
$SourceGroup = "Source-Win10-STD"
$Destgroup = "Dest-Win10-STD"
##

Run the powershell script.
Script will confirm users are members of the source directory and provide output. The script then prompts you to continue to the migration loop or exit. 
Script will then provide a post migration output to ensure users accounts are members of the destination groups. 


## Users.csv ##
UserA
UserB
UserC
UserD

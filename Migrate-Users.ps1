
#import users from CSV and variables

$Users = get-content -path $psscriptroot\users.csv
$SourceGroup = "Source-Win10-STD"
$Destgroup = "Dest-Win10-STD"




#DO NOT MODIFY BELOW THIS LINE

Start-Transcript -path $psscriptroot\Migration.txt -append

# Check User is member of group that requires migrating

foreach ($user in $Users) {
$members = Get-AdGroupmember "$SourceGroup" -recursive | select -expandproperty SamAccountname

If ($members -contains $user) {
	Write-Host "$user is a member of $SourceGroup" -ForegroundColor Green
	} Else {
	Write-Host "$user is not a member of $SourceGroup" -ForegroundColor Red
	}
	
}

$ConfirmTask = Read-host -prompt "Do you wish to migrate the users to $DestGroup (Y/N)" 

#Start-Transcript -path $psscriptroot\Migration.txt -append

#User Group Migration block

If ($ConfirmTask -eq "n") {EXIT
} Else {
Foreach ($user in $Users) {
Add-ADgroupMember -identity $DestGroup -Members $user | Out-Host
Remove-ADGroupMember -identity $SourceGroup -members $user -confirm:$false | Out-Host
}
}


#Sleep command to allow AD to complete actions
Write-host "Sleeping script for 10 seconds to allow AD to complete"
Start-Sleep -Seconds 10

#Post Migration Check and output

# Check to ensure user has been removed from source group

Write-host "Check all users have been removed from $SourceGroup , Any Red's will need action!"
foreach ($user in $Users) {
$members = Get-AdGroupmember "$SourceGroup" -recursive | select -expandproperty SamAccountname

If ($members -contains $user) {
	Write-Host "$user has NOT been removed from $SourceGroup" -ForegroundColor Red
	} Else {
	Write-Host "$user has been removed from $SourceGroup" -ForegroundColor Green
	}
	
}


#Check to ensure user has been added to destination group
Write-Host ""
Write-Host ""
Write-host "Check all users have been added to $DestGroup , Any Red's will need action!"

foreach ($user in $Users) {
$members = Get-AdGroupmember "$DestGroup" -recursive | select -expandproperty SamAccountname

If ($members -contains $user) {
	Write-Host "$user is a member of $DestGroup" -ForegroundColor Green
	} Else {
	Write-Host "$user is NOT a member of $DestGroup" -ForegroundColor Red
	}
	
}

Stop-Transcript





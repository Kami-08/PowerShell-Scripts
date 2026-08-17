	# import the Active Directory module in order to be able to use Get-ADUser and Add-ADGroupMember cmdlet
Import-Module ActiveDirectory

	# VVVV enter account name like 'bbroussard' of the Sender user VVVV
$SourceUserID = Read-Host "Please Enter Client being copied ID 'ex: bbroussard'"
$SourceUser = get-aduser -Identity $SourceUserName -properties *

	# VVVV enter login name of the Receiver user VVVV
$DestinationUserID = Read-Host "Please Enter New User ID 'ttesterson'"


" `n These are the values that Shall Be Added to the New User (Identity)"
	# Creates A Hash Table with the user's ID being passed as 'Identity'. The rest of the titles are pulled from the source user variable which holds onto the
        # table of properties currently taken from the source user's active directory profile.
$ADAttributes = @{
    Identity = $DestinationUserID
    Description = $SourceUser.description
    Office = $SourceUser.Office
    Title = $SourceUser.Title
}
echo $adattributes

set-ADUser @ADAttributes



 #Get all groups from the source user and adds the new user to all of the same groups
Get-ADUser -Identity $SourceUserID -Properties MemberOf | 
   Select-Object -ExpandProperty memberof | 
   Add-ADGroupMember -Members $DestinationUserID


"`n prints out the properties of the updated user" 
    #Prints updated info from the destination user to prove that the changes when through. 
Get-ADUser -Identity $DestinationUserID -Properties Description, Office, Title, EmailAddress, Memberof

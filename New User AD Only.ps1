	# import the Active Directory module in order to be able to use Get-ADUser and Add-ADGroupMember cmdlet
Import-Module ActiveDirectory

	# VVVV enter account name like 'bbroussard' of the Sender user VVVV
$SourceUser =""

	# VVVV enter login name of the Receiver user VVVV
$DestinationUser = ""

	# copy-paste process. grabbing all the fields from the source user that will need to be copied.
$Descrip = Get-ADUser -Identity $SourceUser -Properties Description
$Off = Get-ADUser -Identity $SourceUser -Properties Office
$Titl = Get-ADUser -Identity $SourceUser -Properties Title


	
Set-AdUser -Identity $DestinationUser -Description $Descrip.Description
Set-AdUser -Identity $DestinationUser -Office $Off.Office
Set-AdUser -Identity $DestinationUser -Title $Titl.Title
					     #VVVVVVVV input data here VVVVVVV	
Set-AdUser -Identity $DestinationUser -EmailAddress "@imperialhealth.com" 


 #Get all groups from the source user and adds the new user to all of the same groups
Get-ADUser -Identity $SourceUser -Properties MemberOf | 
   Select-Object -ExpandProperty memberof | 
   Add-ADGroupMember -Members $DestinationUser


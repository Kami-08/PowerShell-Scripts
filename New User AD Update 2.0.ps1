
    #Created By Brandon B 8/18/26

    # import the Active Directory module in order to be able to use Get-ADUser and Add-ADGroupMember cmdlet
Import-Module ActiveDirectory

for($i = 0; $i -lt 1;)
{

	    # this takes input from the user to gain the ID for the source user. 
        # once it gains the ID it pulls that data into the variable $SourceUser
    $SourceUserID = Read-Host "Please Enter Client's ID who's being copied 'ex: LFontenot'"
    $SourceUser = get-aduser -Identity $SourceUserID -properties *
    echo $SourceUser.Name

        #after printing out the user ID's full name, it requests the user to varify
        #that this is the correct user by providing them their full name. y,yes,n,no are all acceptable
        #if one of these 4 options are not inputed then the code will loop back to the start
        #and request for the user to input the correct source user ID again
    $CorrectSource =  read-host "`nis this the correct user to copy? (Y/N)"
        
    switch($CorrectSource)
    {
        {$_ -eq "Y" -or $_ -eq "Yes"}
        {
                #laybeled a nested loop as 'checkdestination' to allow the user to go back
                #and input a correct source user if they accidentally input the wrong info
                #the loop allows for the user to try different destination users without
                #having to input the same source user over and over again.   
            :CheckDestination for($x = 0; $x -lt 1;)
            {
                        #similar to the SourceUserID Request, this requests the Destination User's ID
                        #it allso allows the user to input the word 'break' incase they wanted to go back
                        #and input a different source user. it also grabs the destination user's data
                        #and places it in the $DestinationUser variable
                    $DestinationUserID = Read-Host "Please Enter New Users ID to clone data to OR type 'break' to change source user" "("$sourceuser.name")"
                    if($DestinationUserID -eq "break") {break CheckDestination}
                    $DestinationUser = get-aduser -Identity $DestinationUserID -properties *
                    
                     #prints out a list of the basic destination user properties so you can see a before and after window.
                    "`n This is the person who's attributes will be modified $DestinationUserID"
                    get-ADUser $DestinationUser

	                    # Creates A Hash Table with the user's ID being passed as 'Identity'. The rest of the titles are pulled from the source user variable which holds the
                        # properties currently taken from the source user's active directory profile.
                    " `n These are the values that Shall Be Added to the New User (Identity)"
                    $ADAttributes = @{
                        Identity = $DestinationUserID
                        Description = $SourceUser.description
                        Office = $SourceUser.Office
                        Title = $SourceUser.Title
                        Emailaddress = "$DestinationUserID@imperialhealth.com"
                    }
                        #prints out the hashtable to show the user what will be changed in the destination user.
                        #Also gives the user one final chance to deny the overwite or accept it.
                    echo $adattributes
                    $correctDestination = Read-Host "Continue with Overwrite? Y/N"

                        #If the overwrite is accepted, it will perform the splatt and overwrite the data on the destination
                        #user's profile. it will also add the destination user to all the same groups that the source
                        #user is a member of.
                    if($CorrectDestination -eq "Y" -or  $CorrectDestination -eq "Yes")
                    {
                        set-ADUser @ADAttributes
                        Get-ADUser -Identity $SourceUserID -Properties MemberOf | 
                           Select-Object -ExpandProperty memberof | 
                           Add-ADGroupMember -Members $DestinationUserID

                            #Prints updated info from the destination user to prove that the changes when through.
                            #unfortunatly it sometimes comes back inaccurate due to the server taking a few seconds to upate.
                            #Provides a warning about this issue bellow as well.
                        "`n`n the data was updated successfully These are the updated properties`n 
                            IMPORTANT NOTE: Sometimes it takes a few seconds for the data to appear on the server.`n
                            if the printed list doesn't show any updated properties, check AD yourself. Thank you~`n" 
                        Get-ADUser -Identity $DestinationUserID -Properties Description, Office, Title, EmailAddress, Memberof

                            #exits the user out of the two loops and finishes the code.
                        $i++
                        $x++
                    }
                    else
                    {
                            #if anything BUT y or yes was input it cancels the overwrite.
                            #wanted to make sure you were EXTRA SURE before performing overwrite
                        "`nThe Overwrite was canceled"
                    }

                }
            }
            #if no was input, it was either due to two seperate reasons: the id was put in incorrectly or the id has a number at the end of it.
            #because of this I added a disclaimer bellow. if an id SHOULD be correct but the names don't match, then there must be a number
            #at the end of their name. that's becuase multiple people can have similar names, which results in the ID being Identical.
            #Microsoft auto adds an incrementing number at the end of the ID when this is done.
        {$_ -eq "N" -or $_ -eq "No"}
        {
            "`nPlease enter the correct User ID. Or, if multiple people have the same user ID, add a number to the end of the name Ex:LFontenot1`n"
        }
        default{
            "`nIncorrect Input, Please Try again"
        }
    }
}

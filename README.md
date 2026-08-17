several different .ps1 files performing varying tasks. I will list the purpose of each one here as well as leave comments in each code.

New User AD Only- takes the info from one user in active directory 'known as the $SourceUser' and copies over key info to the new user (known as $DestinationUser).
  * copies over the description, the office, and the title. also tells the groups that the source user is a part of to add the destination to them as well.
  * Required inputs: Source User ID, Destination User ID. Input is done during its run.

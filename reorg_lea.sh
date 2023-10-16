#!/usr/bin/bash
#Gregory Sin-Chan
#1947636
#Bash script that can change the names of the student folders, and unzip any .zip or .tar.gz files that it finds
#Duck and mouse test files, contain spaces
if unzip -oq $1 -d ./ 2>/dev/null #2>/dev/null removes any error messages from when no zip files are found
then
	oldIFS=$IFS #stores IFS variable
	IFS=$'\n' #reassigns the IFS variable to look for spaces
	for file in *[0-9][0-9][0-9]* #searches for file/directory names with atleast 3 numbers side by side
	do
		x=$(echo $file | egrep -oh "[0-9]{7}") #looks for just the student id inside the file names and assigns it to x
		mv -fn $file $x 2>/dev/null #renames files to just the student id
		for ((i=0;i<3;i++)) #files are zipped at most, 3 times
		do
			zip=$(find $x -name "*.zip") #finds all the present zip files in directory

			#2>/dev/null is done twice because one is to remove error messages of dirname when there are no more zip files and it is missing an operand, the other is for the unzip error messages
			unzip -oq $zip -d $(dirname $zip 2>/dev/null) 2>/dev/null 

			#deletes the already stored zip files without removing any possible new zip files that were extracted from the other zip files
			#before it was rm -rf $(find $x -name "*.zip") which would remove the zip files that just came from the unzipped file
			
			rm -rf $zip 2>/dev/null 

			tr=$(find $x -name "*.gz") #finds all the present gunzip files in directory
			tar -xzf $tr -C $(dirname $tr 2>/dev/null) 2>/dev/null
			rm -rf $tr 2>/dev/null
		done
	done
	IFS=$oldIFS #resets the IFS to its original value
else
	echo Error $? #notifies user that there is an error and what the return code is
fi



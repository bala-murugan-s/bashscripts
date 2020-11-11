#------------------------------[CNAME_QUERY_USING_BASH]-------------------------------#
"""
:DESCRIPTION:
	To get the answer for CNAME query using Dig command in Bash Script for multiple hostnames
	
:REQUIREMENTS:
	Linux 
	Bash 
    
:INPUTS:
	Create a Text file input_data.txt and the following entries
	
	google.com
	yahoo.com
    
    Note: change the permissions of this script file with executable permissions.   
	
:OUTPUT:
    ====Question===========================
	google.com
	====Answer=============================

	====Question===========================
	yahoo.com
	====Answer=============================
	
:DRAWBACKS:
	- anyother let me know
	
:NOTES:
  Version:        1.0
  Author:         bala-murugan-s
  Creation Date:  NOV-2020
  Purpose/Change: Initial script development
:INSPIRATION:  
    Bash Script
"""
#---------------------------------------------[Code Starts]------------------------------------------------------#

#!/bin/bash

echo "This script is to get the result of CNAME query for the given name"

for url in $(cat input_data.txt);
do
  echo ====Question===========================
  echo $url
  echo ====Answer===========================
  status=$(dig +nocmd $url cname +noall +answer)
  echo $status
done

#---------------------------------------------[Code Ends]------------------------------------------------------#

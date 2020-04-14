#!/bin/bash -       
#title           :ssl_certificate_validity.sh
#description     :Getting validity of SSL Certificates
#author	 :wol-verine
#github user id  :wol-verine
#date            :20200401
#bash_version    :5.0.7(1)-release (x86_64-redhat-linux-gnu)   
#usage		 :bash ssl_certificate_validity.sh or ./ssl_certificate_validity.sh
#notes           :use any editor to modify this script.
#Privilege       :file must have execute permission
#==============================================================================
##Mandatory - Create a text file with the name "data.txt"
##Upload the URL's to the data.txt file such as google.com, gmail.com, yahoo.com
##
###example listing of data.txt file
###cat data.txt
#   google.com
#   gmail.com
#   yahoo.com
##change the username to your machine user id. remove the double quotes""
## Use the correct path of data.txt file in the script
##First reading the entries in data.txt file line by line
##Using the openssl command to connect and pull the certificate information
##Printing the websites listed in data.txt file and validity period

for url in $(cat /home/"username"/data.txt)
do
  echo $url
  echo | openssl s_client -connect $url:443 2>/dev/null | openssl x509 -noout -dates
done

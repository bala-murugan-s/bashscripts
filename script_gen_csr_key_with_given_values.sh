#!/bin/bash
#title           :script_gen_csr_key_with_given_values.sh
#description     :This is a bash based script to generate CSR and KEY by giving the mandatory values to generate offline.
#author	         :spiritrident
#github user id  :spiritrident
#date            :20240624
#bash_version    :5.0.7(1)-release (x86_64-redhat-linux-gnu)   
#usage		       :bash script_gen_csr_key_with_given_values.sh or ./script_gen_csr_key_with_given_values.sh
#notes           :use any editor to modify this script.
#Privilege       :file must have execute permission (chmod 744 script_gen_csr_key_with_given_values.sh )
#==============================================================================
##Mandatory - Read the following sample details and give similar values depends on your certificate parameters to generate csr and keys

#Enter Common Name (CN): example.com
#Enter Country (C): US
#Enter State (ST): Washington
#Enter Location (L): Seatle
#Enter Organization (O): Example Corporation
#Enter Organizational Unit (OU): IT
#Enter a comma-separated list of SAN entries (e.g., DNS:example.com,DNS:www.example.com): DNS:www.example.com,DNS:hr.example.com,DNS:it.example.com,DNS:finance.example.com,DNS:www.service.example.com,DNS:k-12.example.com,DNS:www.k-12.example.com

##run the script - ./script_gen_csr_key_with_given_values.sh
## Enter the values one by one as similar to the sample values above
## CSR and KEYS file will be generated and stored in the folder CSR_and_KEYS
## If csr is not generated, there may be a typo while giving values. re-run the script and give correct values.

#each run will generate 2 or 3 files .cnf/.csr/.key 
##verify##
#to verify the csr run the following commands to test
#openssl req -in generated_csr_name.csr -noout -verify
#openssl req -in generated_csr_name.csr -noout -text | grep -E 'Subject|DNS'




# Prompt user for input
read -p "Enter Common Name (CN): " common_name
read -p "Enter Country (C): " country
read -p "Enter State (ST): " state
read -p "Enter Location (L): " location
read -p "Enter Organization (O): " organization
read -p "Enter Organizational Unit (OU): " organizational_unit
read -p "Enter a comma-separated list of SAN entries (e.g., DNS:example.com,DNS:www.example.com): " san_entries

# Create a directory to store the CSR and key if it doesn't exist
mkdir -p csr_and_keys

# Create a configuration file
config_file="openssl_$common_name.cnf"

cat > $config_file << EOL
[ req ]
default_bits        = 2048
prompt              = no
default_md          = sha256
distinguished_name  = dn
req_extensions      = req_ext

[ dn ]
C                   = $country
ST                  = $state
L                   = $location
O                   = $organization
OU                  = $organizational_unit
CN                  = $common_name

[ req_ext ]
subjectAltName      = $san_entries
EOL

# Generate private key
private_key="csr_and_keys/$common_name.key"
openssl genpkey -algorithm RSA -out $private_key -pkeyopt rsa_keygen_bits:2048

# Generate CSR
csr="csr_and_keys/$common_name.csr"
openssl req -new -key $private_key -out $csr -config $config_file

# Display the output file locations
echo "Private key generated at: $private_key"
echo "CSR generated at: $csr"
echo "OpenSSL configuration file: $config_file"

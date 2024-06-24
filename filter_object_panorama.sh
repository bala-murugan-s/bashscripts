#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <Panorama_IP> <API_Key> <Object_Type> <Object_Name>"
    echo "Object_Type can be 'address', 'service', or 'application'"
    exit 1
}

# Check if the required arguments are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    usage
fi

# Panorama IP, API Key, Object Type, and Object Name
PANORAMA_IP=$1
API_KEY=$2
OBJECT_TYPE=$3
OBJECT_NAME=$4

# Function to check if an object exists
check_object() {
    local object_type=$1
    local object_name=$2
    local xpath=""
    
    case $object_type in
        address)
            xpath="/config/shared/address/entry[@name='$object_name']"
            ;;
        service)
            xpath="/config/shared/service/entry[@name='$object_name']"
            ;;
        application)
            xpath="/config/shared/application/entry[@name='$object_name']"
            ;;
        *)
            echo "Invalid object type: $object_type"
            exit 1
            ;;
    esac
    
    curl -k -s "https://${PANORAMA_IP}/api/?type=config&action=get&key=${API_KEY}&xpath=${xpath}"
}

# Function to find matching security rules
find_matching_rules() {
    local object_name=$1
    local rules_xpath="/config/shared/pre-rulebase/security/rules"
    
    curl -k -s "https://${PANORAMA_IP}/api/?type=config&action=get&key=${API_KEY}&xpath=${rules_xpath}" | grep -B 5 -A 20 "$object_name"
}

# Check if the object exists
echo "Checking if the $OBJECT_TYPE object '$OBJECT_NAME' exists in Panorama..."
object_check_result=$(check_object "$OBJECT_TYPE" "$OBJECT_NAME")

if echo "$object_check_result" | grep -q "<entry name=\"$OBJECT_NAME\">"; then
    echo "$OBJECT_TYPE object '$OBJECT_NAME' exists in Panorama."
    
    # Find matching security rules
    echo "Finding matching security rules for $OBJECT_TYPE object '$OBJECT_NAME'..."
    find_matching_rules "$OBJECT_NAME"
else
    echo "$OBJECT_TYPE object '$OBJECT_NAME' does not exist in Panorama."
fi

<<comment
./filter_object_panorama.sh 10.1.1.1 your_api_key_here address test_address
comment

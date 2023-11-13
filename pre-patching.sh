#!/bin/bash
# created by John Hartman , john.hartman@ibm.com or john.michael.hartman@gmail.com
# the one assumption this script makes is that the patching sfs file is staged in the /store directory

d=`date +%Y-%m-%d`

dir=/store/LOGS/QRadar_Patching_$d

echo "Working on the pre-patching script"


echo "Removing the junk you forgot to clean up"
#removes old deployment_info outputs
rm -rf /store/LOGS/qradar_deploymet_info*


echo "Creating patch files directory"
#Create directory for patching documents
mkdir $dir

echo "Checking the space on all managed hosts"
# Verify you have enough space in the QRadar console
/opt/qradar/support/all_servers.sh -C "df -h" > $dir/diskcheck.txt

echo "Running the drq health check"
# health check
/opt/qradar/support/all_servers.sh -C "drq" > $dir/drq_output.txt

# Get a list of all the managed hosts
/opt/qradar/support/deployment_info.sh 
mv qradar_deployment_info* $dir

echo "Checking the current version of all appliances"
# Confirm all appliances are at the same version
/opt/qradar/support/all_servers.sh -C "/opt/qradar/bin/myver" > $dir/myver_output.txt

echo "Creating the updates directory on all managed hosts"
/opt/qradar/support/all_servers.sh -C "mkdir -p /media/updates" > /dev/null

echo "Verifying no previous patches are mounted"
# verify Unmount of any previous updates:
/opt/qradar/support/all_servers.sh -k "umount /media/updates"

echo "Copying the sfs file to all managed hosts"
#Copy the file down to all managed hosts:
/opt/qradar/support/all_servers.sh -P /store/*.sfs

echo "$dir created with all of your files, have a wonderful day ya filthy animals"

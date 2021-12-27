#!/bin/bash

#Get the script directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

#Set a working directory and choose output paths
WORKING_DIR=${DIR}/tmp
VPN_ARCHIVE_DIR=${WORKING_DIR}/ovpn_files.zip

#Download and unzip the archive
wget -O ${VPN_ARCHIVE_DIR} https://s3-us-west-1.amazonaws.com/heartbleed/windows/New+OVPN+Files.zip
unzip $VPN_ARCHIVE_DIR -d $WORKING_DIR

#Remove old VPN files and create backups
rm -rf {DIR}/TCP_backup
rm -rf {DIR}/UDP_backup
mv ${DIR}/TCP ${DIR}/TCP_backup
mv ${DIR}/UDP ${DIR}/UDP_backup

#Move the new files to the appropriate location
mv ${WORKING_DIR}/New\ OVPN\ Files/TCP $DIR
mv ${WORKING_DIR}/New\ OVPN\ Files/UDP $DIR

#Delete temporary files
rm -rf $WORKING_DIR/New\ OVPN\ Files
rm $WORKING_DIR/ovpn_files.zip

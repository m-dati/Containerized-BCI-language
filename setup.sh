#!/bin/bash
# Container Pre-config# Data and container preparation in bash
#set -x

# common tools
source setup/common.h 

if [ $# -gt 0 ] 
then
    DATAFILE=$1
else
    DATAFILE=setup/data.h
fi
[ ! -f $DATAFILE ] && error $DATAFILE
 
# A - include base data
source $DATAFILE

# B,C - Build images and containers 
source setup/build.sh

# D - Display Containers
cat<<EOF
========================
IMAGE | Reused:$REUSE_EXISTING_IMAGE | $ImgxID | $ImgxNam

CONTAINER | Reused:$REUSE_EXISTING_CONTAINER | $ConxID | $ConxNam

Running container:
$($RUNTIME ps -f "name=$ConxNam")

Binding Port:
$($RUNTIME port ${ConxNam})

- Execute single command or access the container: 
$RUNTIME exec   ${ConxNam} <command>
$RUNTIME attach ${ConxNam}

EOF

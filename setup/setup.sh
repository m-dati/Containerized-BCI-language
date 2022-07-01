#!/bin/bash
# Container Pre-config# Data and container preparation in bash
#set -x

# A- include base data

#  work dir fallback on setup:
[ $(basename $(pwd)) == 'setup' ] && cd .. # go up if in setup dir.
source ./setup/setup.data.h

# B - create container, check if image present already:
ImgxID=`$RUNTIME images -nq ${ImgxNam}`
if [ -z $ImgxID ]
then
    $BUILD  . -t ${ImgxNam}
    ImgxID=`$RUNTIME images -nq ${ImgxNam}`
fi

# C - start the container in detach m.,check if present already:
ConxID=`$RUNTIME ps -qf "name=${ConxNam}"`
if [ -z $ConxID ]
then
    ConxNam2=`$RUNTIME ps --format "{{.Names}} {{.Ports}}" | grep $Port-\>$Port |cut -d' ' -f1`
    if [ -z $ConxNam2 ]
    then
        $RUNTIME run --rm --detach -ti -p $Port:$Port -v $LocalDir:${ConxDir} --name ${ConxNam} ${ImgxNam} bash
        ConxID=`$RUNTIME ps -qf "name=${ConxNam}"`
    else
        ConxID=`$RUNTIME ps -qf "name=${ConxNam2}"`
        ConxNam=$ConxNam2
    fi
fi

# D - from local dir
$RUNTIME exec ${ConxNam} bash -c "chmod 777 etc src bin out ./setup/$Config"
$RUNTIME exec ${ConxNam} bash -c "./setup/$Config $Language $Version $LangRuntime"

### END container preparation ###

$RUNTIME ps

echo "Execute single command:" 
echo " $RUNTIME exec   ${ConxNam} <command>"
echo "or enter into container:"
echo " $RUNTIME attach ${ConxNam}"

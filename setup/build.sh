#!/bin/bash
# Container Pre-config# Data and container preparation in bash

# increment last digit of a string like x.1
incrsubfix() {
# $1 : input string, format "prexif{$separator}subfix"
# $2 : separator
    # reg.exp.for digits
    isnum="^[0-9]+$"; 
    # get subfix
    d=${1##*$2};
    x=${1%$2*};
    [ $d == $x ] && d=0; # separator not found
    [[ $d =~ $isnum ]] && d=$((d+1)) || d=${d}${2}1;
    printf $x$2$d;
}

function build_image_name() {
    # $1 = ImgxNam / return the imageID of $1
    ImgxNam=$1
    ImgxID=`$RUNTIME images -nq $ImgxNam`
    if [ "$ImgxID" ] # already exists
    then
        case $REUSE_EXISTING_IMAGE in
        "n"|"N"|"no"|"NO"|0|false)
            REUSE_EXISTING_IMAGE=false
            MaxLoop=10
            while [ "$ImgxID" -a $((--MaxLoop)) -gt 0 ]
            do
                ImgxNam=$(incrsubfix ${ImgxNam} '.')
                ImgxID=`$RUNTIME images -nq $ImgxNam`
            done        
        ;;
        "y"|"Y"|"yes"|"YES"|1|true) # do nothing, use same names.
            REUSE_EXISTING_IMAGE=true
            return
        ;;
        *) # same as yes
            REUSE_EXISTING_IMAGE=true
            return
        ;;
        esac
    else
        REUSE_EXISTING_IMAGE=false
    fi
    $BUILD . -f $Loc_Setup/Dockerfile -t $ImgxNam
    [ $? -ne 0 ] && error "Container $ConxNam"

    ImgxID=`$RUNTIME images -nq $ImgxNam`
}

function create_container_name() {
# $1 = ConxNam / return the container ID of $1
    ConxNam=$1
    ConxID=`$RUNTIME ps -qf "name=^${ConxNam}$"` # match exact name
    if [ "$ConxID" ] # already exists
    then
        case $REUSE_EXISTING_CONTAINER in
        "n"|"N"|"no"|"NO"|0|false)
            REUSE_EXISTING_CONTAINER=false
            MaxLoop=10
            while [ "$ConxID" -a $((--MaxLoop)) -gt 0 ] 
            do
                ConxNam=$(incrsubfix ${ConxNam} '.')
                ConxID=`$RUNTIME ps -qf "name=^${ConxNam}$"` # match exact name
            done
           
        ;;
        "y"|"Y"|"yes"|"YES"|1|true) # do nothing, use same names.
            REUSE_EXISTING_CONTAINER=true   
            return
        ;;
        *) # same as yes
            REUSE_EXISTING_CONTAINER=true 
            return
        ;;
        esac
    else
        REUSE_EXISTING_CONTAINER=false
    fi
    $RUNTIME run --rm --detach -ti -p :$Port -v $LocxHome/$Loc_Share:$ConxShare --name $ConxNam $ImgxID bash
    [ $? -ne 0 ] && error "Container $ImgxNam"

    ConxID=`$RUNTIME ps -qf "name=^${ConxNam}$"` # match exact name
}

# B - create container, check if image present already:
build_image_name ${ImgxNam}

# C - start the container in detach m.,check if name present already or port already used:
create_container_name ${ConxNam}

### END container preparation ###

#!/bin/bash
# Container Pre-config
#
# input parameters Language, Version, runtime
L=$1 # Language
V=$2 # Version
R=$3 # Language runtime binary

NOTREADY="bci available but CoBCIL project not ready yet"

# error func.
error() {
    echo Error $1
    exit 1;
}


# error func.
notready() {
    echo $1 $NOTREADY
    exit 2;
}

# Python installer upgrade
pip_upgrade() {
    $R -m pip install --upgrade pip >log
    if [ `grep -c "already.satisfied" log` -eq 0 ]
    then
        ln -s `which pip`  /usr/bin/pip
        ln -s `which pip3` /usr/bin/pip3
    fi
    pip --version
    rm log
}

# main #

# parameters check
[ $# -lt 3 ] && error

# per-language setting
case $L in
    'python'|'python3')
        echo $L
        # runtime version
        $R --version
        [ $? -ne 0 ] && error $R
        pip --version
        [ $? -ne 0 ] && error pip
        [ ${V:2} -ge 10 ] && pip_upgrade || true
        pip install tensorflow
    ;;
    'openjdk'|'java')
        notready $L
    ;;
    'golang'|'go')
        notready $L
    ;;
    'ruby')
        notready $L
    ;;
    *)
        error $L 
    ;;
esac

# end #

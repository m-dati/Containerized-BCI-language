# A - Prepare needed parameters for container creation:

# REUSE_IMAGE: on build, if image Name exists :
# "no":  create new image renamed
# "yes": reuse same object
REUSE_EXISTING_IMAGE="no"  

# REUSE_CONTAINER: on run, if container Name exists: 
# "no":  create new cont. renamed
# "yes": reuse same object
REUSE_EXISTING_CONTAINER="no"

# Specific case: new image => new derived container:
[ $REUSE_EXISTING_IMAGE == "no" ] && REUSE_EXISTING_CONTAINER="no"

# Dockerfile create: not empty=create; empty=reuse existing
DOCK_CREATE="yes"

# 1- select RUNTIME:
RUNTIME="podman" # or "docker"
BUILD="$RUNTIME build"  # or "buildah"

# 2- Select Language:
Language=python
Version=3.10
LangRuntime=python3

# Language libbrary installer and build/run for compiled:
Buildoptions="$LangRuntime -m compileall"
InstallerOptions="pip install"

# 3,4 - registry and image/cont. names
Contain=registry.suse.com/bci
bcixNam=$Language:$Version
ImgxNam=${bcixNam}-$USER
ConxNam=${Language}-$USER

# 5a - server work dir:
LocxHome=$(pwd)
Loc_Setup=./setup
Loc_Share=./workdir

# 5b - container work dir
ConxShare=/home/shared
ConxLocal=/home/local

# 6 - data and files
# Config script $1:$Language $2:$Version $3:$LangRuntime 
Config=container_preconfig.sh

# 7 - container data
Port=58123

# 8 - Dockerfile generation
if [ $DOCK_CREATE ]
then
cat <<EOF > $Loc_Setup/Dockerfile
# start Dockerfile
FROM ${Contain}/$bcixNam
EXPOSE $Port
RUN mkdir -p ${ConxLocal}
RUN mkdir -p ${ConxShare}
WORKDIR ${ConxShare}
RUN chmod 775 ${ConxShare} ${ConxLocal}
COPY $Loc_Setup/$Config ${ConxLocal}
RUN chmod 775 ${ConxLocal}/$Config
# container language specific setup
RUN ${ConxLocal}/$Config $Language $Version $LangRuntime 
EOF
# End of Dockerfile #
fi

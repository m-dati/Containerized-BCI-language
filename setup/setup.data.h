# A - Prepare needed parameters for container creation:

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
ImgxNam=$Language:$Version
ConxNam=${Language}-$RANDOM

# 5 - local and container matching dir:
LocalDir=$(pwd);
ConxDir=/home/shared
ConxLocal=/home/local

# 6 - data and files
Config=config.container.sh

# 7 - container data
Port=58123

# 8 - Dockerfile creation:
mv Dockerfile Dockerfile.old
cat <<EOF > Dockerfile

FROM ${Contain}/$ImgxNam
RUN mkdir ${ConxDir}
WORKDIR   ${ConxDir}
RUN mkdir -p etc src bin out
RUN chmod 775 etc src bin out
# COPY setup/$Config etc
# RUN chmod 775 etc/$Config
# RUN etc/$Config $Language $Version $LangRuntime 
EXPOSE $Port

EOF
###

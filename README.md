# Data and container preparation in bash

The setup.sh and related setup.data.h shell scripts in setup subdir, allow to pull and start (run) the container in detached mode.

In those scripts some prefixes are used, for fast identification of data, that is,
parameters related to:

- images,     names have prefix: "Imgx..."
- containers, names have prefix: "Conx..."
- local (*),  names have prefix "Local..."

  (*) machine running the container


The setup steps are:

A) Prepare Input parameters and create Dockerfile:

1) select RUNTIME and BUILD:

Choices: podman, docker, buildah

2) Select Language:

as initial setting we use simple parameters, like:

Language=python3, Version=3:10

Note: in future versions parameters could be organized in JSON structures, like:

```json
{
 "runtimes": {
    "runtime": "podman",  "build": "podman build"
 },
 "images": {
    "languages": [
        {"language": "python",  "version": "3:10"}
        {"language": "openjdk", "version": "1:17"}
    ],
    "registry": "registry.suse.com/bci",
    "imgxname": "bci-python-a",
    "conxname": "bci-python-a-1",
 }
 "directories": [
        {"localdir": "$(pwd)", "conxdir": "/home/shared"}
 ],
}
```

3) set the registry source of the images: registry.suse.com/bci/*

4) Definition of image name and container name for easy execution reference

5) local dir and container dir:

Stucture expected in $LocalDir on the local machine:
```bash
${LocalDir}/etc
${LocalDir}/src
${LocalDir}/bin
${LocalDir}/out
```

as well mounted in the container as WORKDIR $ConxDir:

6) a shell script for container preconfiguration, to be executed during the build:

$LocalDir/$Config

7) An exposed port is also availabe in $Port

8) Dockerfile composition

The Dockerfile can be even created at any time running in the LocalDir:
```bash
   source ./setup/setup.data.h
```

B) Container build

C) Container start

D) container setup

E) Finally the running container $ConxNam is available for:

- build and execution for compiled languages and install the needed libraries:

```bash
  $RUNTIME exec ${ConxNam} bash -c "$Installeroptions <libraries>"
  $RUNTIME exec ${ConxNam} bash -c "$Buildoptions src/<source-code> [-o bin/<binary-code>]"
  $RUNTIME exec ${ConxNam} bash -c "$LangRuntime bin/<object-code> <params>"
  $RUNTIME exec ${ConxNam} bash -c "bin/<binary-code> <params>"
```

- direct execution of code for interpreted languages
  $RUNTIME exec ${ConxNam} bash -c "$LangRuntime src/<file-code>"

F) Sorce code editing allowed on local machines in the shared directory structure.
   
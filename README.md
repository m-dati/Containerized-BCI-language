# Project rel.1.0

Create a selector of BCI-language containers to pull and build the proper SUSE BCI image and compile and run files of the selected language in local shared volume to be used for code development.

**To start working**

- git clone this repo on your machine console, where git and podman or docker is available,
- enter the _repository home directory_,
- edit and check the parameters fitting your need in:
  ```bash
  setup/data.h 
  ``` 
- run:
  ```bash
  ./setup.sh
  ```
- expected: 
  * the named image is built, 
  * a container is running, 
  * a shared folder is available on both local machine and container for
    - code editing on the local server and 
    - code running and debugging in the container.

# Data and container preparation in bash

The setup.sh and related data.h and build.sh shell scripts in setup subdir, allow to pull and start (run) the container in detached mode.

In those scripts some prefixes are used for parameters, for fast identification of data, that is,
parameters related to:

- images,     names have prefix: "Imgx..."
- containers, names have prefix: "Conx..."
- local server (*),  names have prefix "Locx..."

  (*) machine running the container

In future versions the parameters could be organized in JSON structures.


**The setup _steps_ are**:

# A) Data

Prepare Input parameters and create Dockerfile:

## 1) select RUNTIME and BUILD:

Choices: podman, docker, buildah

## 2) Select Language:

as initial setting we use simple parameters, like:

Language=python3, Version=3:10

## 3) Registry

set the registry source of the images: registry.suse.com/bci/*

## 4) Image Name

Definition of image name _ImgxNam_ and container name _ConxNam_ for easy execution reference.

At each _setup.sh_ rerun, based on the _REUSE\_EXISTING\_(IMAGE/CONTAINER)_ parameters, when =NO, an internal algorhytm is able to assign a different name to the new object, simply increasing a numeric subfix in the previous existing container or image name [i.e. python-bob -> python-bob.1 -> python-bob.2 ... ].

But we can always assign any new name editing the name parameters in data.h file saved in a new data{N}.h file (see Rel.1.1)

## 5) Directories

local dir and container dir:

Stucture expected on the local machine:
```bash
${Loc_Share}/src # shared source code storage
${Loc_Share}/bin # compiled executable 
${Loc_Share}/out # data output and logs
```

as well mounted in the container as WORKDIR $ConxShare:

## 6) Container Configure

A shell script for container preconfiguration, to be executed during the build:

$ConxLocal/$Config

## 7) Port

An exposed port is also availabe in $Port

## 8) Dockerfile composition

The Dockerfile is generated in the _setup_ subdir during the data.h preparation, if
DOCK_CREATE not empty; otherwise (empty) an existing Dockerfile is expected.

# B) Image build

The image build is executed using the Dockerfile in the setup subdir, running the function:
```bash
    build_image_name
```

# C) Container start

The container is started running the function:
```bash
    create_container_name
```

# D) Container ready

Finally the running container $ConxNam is available for:

- build and execution for compiled languages and install the needed libraries:

```bash
  $RUNTIME exec ${ConxNam} bash -c "$Installeroptions <libraries>"
  $RUNTIME exec ${ConxNam} bash -c "$Buildoptions src/<source-code> [-o bin/<binary-code>]"
  $RUNTIME exec ${ConxNam} bash -c "$LangRuntime bin/<object-code> <params>"
  $RUNTIME exec ${ConxNam} bash -c "bin/<binary-code> <params>"
```

- direct execution of code for interpreted languages
  ```bash
  $RUNTIME exec ${ConxNam} bash -c "$LangRuntime src/<file-code>"
  ```

- Connection to the container for execution and debugging:
  ```bash
  $RUNTIME attach ${ConxNam}
  ```

# E) Source code editing 
It is possible to edit source code on the local machines in the Loc_Share directory, and run it in the container ConxShare directory.

# Release 1.1

Added an input parameter for the **setup.sh** script, in order to have libraries of different data sets, so that multiple different containers can be started:

Default will use setup/data.sh:
```bash
  ./setup.sh
```
but we can select a different _existing_ data file instead, i.e.:
```bash
  ./setup.sh "setup/data-2.h"
``` 

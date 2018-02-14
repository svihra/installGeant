#!/bin/bash

#------------------------------------------------------------------------
# - made by Peter Svihra, FNSPE CTU in Prague
# - the script needs at least 1 parameter (nCores)
# - first parameter is number of cores for faster execution
# - second parameter is direct link to download the geant file with .tar.gz
# extension (automatically 4.10.03, possible any version supporting cmake)
# - third parameter is shell type used (automatically bash, possible zsh)
#------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    echo "#########################################################################################";
    echo "Add number of the used cores, direct link to download and shell type (automatically bash)";
    echo "bash installRoot.sh nCores directWebLink shellType";
    echo "#########################################################################################";
    exit
fi

if [ $# -eq 2 ]; then
    echo "Will download file from $2";
    WEB=$2;
else
    WEB=https://cern.ch/geant4/support/source/geant4.10.03.p01.tar.gz;
fi

NAME=$WEB;
NAME=${NAME/https\:\/\/cern\.ch\/geant4\/support\/source\//};
NAME=${NAME/\.tar\.gz/};

if [ $# -eq 3 ]; then
    echo "#########################################################################################";
    echo "Using $3 shell";
    echo "#########################################################################################";
    SHELL=$3;
else
    SHELL=bash;
fi

FILE=~/Downloads/$NAME.tar.gz;

if ! wget --show-progress --output-document=$FILE $WEB ; then
    echo "#########################################################################################";
    echo "Could not download the file $WEB";
    echo "#########################################################################################";
    exit;
else
    echo "#########################################################################################";
    echo "File successfuly downloaded";
    echo "#########################################################################################";
fi

if [ $# -eq 0 ]; then
    echo "#########################################################################################";
    echo "Using only one core";
    echo "#########################################################################################";
    CORES=1;
else
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        CORES=$1;
    else
		echo "#########################################################################################";
		echo "Not valid cores count, using only one";
		echo "#########################################################################################";
		CORES=1;
    fi
fi

sudo echo ;
sudo apt-get --ignore-missing --yes --force-yes install libqt4-opengl-dev qtcreator git dpkg-dev gcc g++ make cmake binutils libxmu-dev libx11-dev libxpm-dev libxft-dev libxext-dev libqt4-dev libgl1-mesa-dev python python-dev libxerces-c-dev;

if [ ! -d /opt/$NAME/geant-build ]; then

    if sudo mkdir -p /opt/$NAME/geant-build; then
        echo "#########################################################################################";
		echo "build dir - created";
        echo "#########################################################################################";
	else
        echo "#########################################################################################";
		echo "build dir - creation failed";
		echo "#########################################################################################";
		exit;
    fi
else
    echo "#########################################################################################";
    echo "build dir - already exists";
    echo "#########################################################################################";
fi


if [ ! -d /opt/$NAME/source ]; then
    if sudo mkdir -p /opt/$NAME/source; then
		echo "#########################################################################################";
        echo "source dir - created";
        echo "#########################################################################################";
	else
		echo "#########################################################################################";
        echo "source dir - creation failed";
		echo "#########################################################################################";
        exit;
    fi
else
		echo "#########################################################################################";
        echo "source dir - already exists";
		echo "#########################################################################################";
fi

if sudo tar -C /opt/$NAME/source --strip-components 1 -zxf $FILE; then
    echo "#########################################################################################";
    echo "unpack - successful";
    echo "#########################################################################################";
else
    echo "#########################################################################################";
    echo "unpack - failed";
    echo "#########################################################################################";
    exit;
fi

SOURCE=/opt/$NAME/source
echo "#########################################################################################";
echo "source dir - "$SOURCE;
echo "#########################################################################################";

cd /opt/$NAME/geant-build
echo "#########################################################################################";
echo "build dir - changed directory";
echo "#########################################################################################";

echo "#########################################################################################";
echo "running cmake";
echo "#########################################################################################";
sudo cmake -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_GDML=ON -DGEANT4_BUILD_MULTITHREADED=ON -DGEANT4_USE_QT=ON -DGEANT4_OPENGL_X11=ON -DGEANT4_SYSTEM_EXPAT=OFF -DCMAKE_INSTALL_PREFIX=/opt/$NAME/geant-install -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_LINKER=ld $SOURCE

sudo make -j$CORES
sudo make install

cd /usr/local/bin
sudo ln -sv /opt/$NAME/geant-install/bin/*

#Change the lines if using different shell than bash (such as zsh)
if [ $SHELL == "bash" ]; then 
echo "#########################################################################################";
echo "Using bash";
echo "#########################################################################################";
cat <<EOT >> ~/.bashrc
#
#GEANT sourcing
source /opt/$NAME/geant-install/bin/geant4.sh
EOT
elif [ $SHELL == "zsh" ]; then
echo "Using zsh";
cat <<EOT >> ~/.zshrc
#
#GEANT sourcing
cd /opt/$NAME/geant-install/bin
source geant4.sh
popd > /dev/null
EOT
fi

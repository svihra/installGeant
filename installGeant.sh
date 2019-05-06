#!/bin/bash

#------------------------------------------------------------------------
# - made by Peter Svihra, FNSPE CTU in Prague
# - c parameter is number of cores for faster execution
# - w parameter is direct link to download the root file with .tar.gz
# extension (automatically 6.08.06, possible any version supporting cmake)
# - s parameter is shell type used (automatically bash, possible zsh)
#------------------------------------------------------------------------

CORES=1
WEB=https://cern.ch/geant4-data/releases/geant4.10.05.p01.tar.gz
SHELL=bash

while getopts ":hc:w:s:" opt; do
    case "${opt}" in
        h) echo "./installGeant.sh -c nCores -w directWebLink -s shellType"; exit 1;;
        c) CORES=${OPTARG};;
        w) WEB=${OPTARG};;
        s) SHELL=${OPTARG};;
        \?) echo "Invalid option: -$OPTARG";;
        :) echo "Option -$OPTARG requires an argument."; exit 1;;
    esac
done

echo "#########################################################################################"
echo
echo "Starting Geant4 installation, when asked type in sudo password and go for a coffee"
echo
echo "#########################################################################################"
echo "Downloading file from: $WEB"
echo "Using shell: $SHELL"
echo "Number of cores: $CORES"

NAME=$WEB;
echo $NAME
NAME=${WEB##*/}
NAME=${NAME/\.tar\.gz/};
FILE=~/Downloads/$NAME.tar.gz;

if [ -f $FILE ]; then
    echo "#########################################################################################";
    echo "$FILE already exists -> skipping download"
else
    if ! wget --output-document=$FILE $WEB ; then
        echo "#########################################################################################";
        echo "Could not download the file $WEB";
        exit;
    else
      	echo "#########################################################################################";
      	echo "File successfuly downloaded";
    fi
fi

if [[ ! $CORES =~ ^-?[0-9]+$ ]]; then
  	echo "#########################################################################################";
  	echo "Not valid cores count, using only one";
  	CORES=1;
fi

sudo echo ;
sudo apt-get --ignore-missing --yes --force-yes install libqt4-opengl-dev qtcreator git dpkg-dev gcc g++ make cmake binutils libxmu-dev libx11-dev libxpm-dev libxft-dev libxext-dev libqt4-dev libgl1-mesa-dev python python-dev libxerces-c-dev;

if [ ! -d /opt/$NAME/geant-build ]; then

    if sudo mkdir -p /opt/$NAME/geant-build; then
        echo "#########################################################################################";
        echo "build dir - created";
	else
        echo "#########################################################################################";
    		echo "build dir - creation failed";
    		exit;
    fi
else
    echo "#########################################################################################";
    echo "build dir - already exists";
fi


if [ ! -d /opt/$NAME/source ]; then
    if sudo mkdir -p /opt/$NAME/source; then
		    echo "#########################################################################################";
        echo "source dir - created";
	else
		    echo "#########################################################################################";
        echo "source dir - creation failed";
        exit;
    fi
else
		    echo "#########################################################################################";
        echo "source dir - already exists";
fi

if sudo tar -C /opt/$NAME/source --strip-components 1 -zxf $FILE; then
    echo "#########################################################################################";
    echo "unpack - successful";
else
    echo "#########################################################################################";
    echo "unpack - failed";
    exit;
fi

SOURCE=/opt/$NAME/source
echo "#########################################################################################";
echo "source dir - "$SOURCE;

cd /opt/$NAME/geant-build
echo "#########################################################################################";
echo "build dir - changed directory";

echo "#########################################################################################";
echo "running cmake";
sudo cmake -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_GDML=ON -DGEANT4_BUILD_MULTITHREADED=ON -DGEANT4_USE_QT=ON -DGEANT4_OPENGL_X11=ON -DGEANT4_SYSTEM_EXPAT=OFF -DCMAKE_INSTALL_PREFIX=/opt/$NAME/geant-install -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_LINKER=ld $SOURCE

sudo make -j$CORES
sudo make install

cd /usr/local/bin
sudo ln -sv /opt/$NAME/geant-install/bin/*

#Change the lines if using different shell than bash (such as zsh)
if [ $SHELL == "bash" ]; then
echo "#########################################################################################";
echo "Using bash";
cat <<EOT >> ~/.bashrc
#
#GEANT sourcing
source /opt/$NAME/geant-install/bin/geant4.sh
EOT
elif [ $SHELL == "zsh" ]; then
echo "#########################################################################################";
echo "Using zsh";
cat <<EOT >> ~/.zshrc
#
#GEANT sourcing
cd /opt/$NAME/geant-install/bin
source geant4.sh
popd > /dev/null
EOT
fi

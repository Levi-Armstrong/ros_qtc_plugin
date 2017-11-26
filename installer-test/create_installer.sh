#!/bin/bash

RED=
GREEN=
YELLOW=
NC=

ncolors=$(tput colors)
if test -n "$ncolors" && test $ncolors -ge 8; then
    RED='\033[0;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;93m'
    NC='\033[0m' # No Color
fi

# Log file of all actions
LOG_FILE="/tmp/qtcreator_ros_installer_setup.log"
rm $LOG_FILE

function logP {
    echo -e "${GREEN}$1${NC}"   # Print color to screen
    echo -e "$1" >> "$LOG_FILE" # No color to log file
}

function createInstallerData {
	# Get Major Version
	PVersion=(`echo $QTC_MINOR_VERSION | tr '.' ' '`)
	QTC_MAJOR_VERSION=${PVersion[0]}.${PVersion[1]}

	# Absolute path to this setup.sh script: create_installer.sh
	SCRIPT_FILE_PATH=$(readlink -f $0)
	# Absolute path to this setup.sh script
	INSTALLER_DIR_PATH=`dirname $SCRIPT_FILE_PATH`

    # remove directories that may exist
    rm -rf /tmp/$QTC_MINOR_VERSION
    rm -rf /tmp/ros_qtc_plugin
    rm -rf /tmp/ros_qtc_plugin-build
    rm -rf /tmp/qtcreator
    rm -rf /tmp/qtcreator_dev
    rm -rf /tmp/qtcreator_ros_plugin

	export QTC_SOURCE=/tmp/$QTC_MINOR_VERSION
	export QTC_BUILD=/tmp/$QTC_MINOR_VERSION

	mkdir -p /tmp/$QTC_MINOR_VERSION
	cd /tmp/$QTC_MINOR_VERSION

    # Download the version of Qt Creator from Qt
	wget https://download.qt.io/official_releases/qtcreator/$QTC_MAJOR_VERSION/$QTC_MINOR_VERSION/installer_source/linux_gcc_64_rhel72/qtcreator.7z
	wget https://download.qt.io/official_releases/qtcreator/$QTC_MAJOR_VERSION/$QTC_MINOR_VERSION/installer_source/linux_gcc_64_rhel72/qtcreator_dev.7z

    # Extract the Data
	7zr x -bd qtcreator.7z
	7zr x -y -bd qtcreator_dev.7z
	 
	# Clone the ROS Qt Creator Plugin
	cd /tmp
	git clone --depth 1 --single-branch --branch $QTC_MAJOR_VERSION https://github.com/ros-industrial/ros_qtc_plugin.git
    
    # Build the ROS Qt Creator Plugin
	mkdir ros_qtc_plugin-build
	cd /tmp/ros_qtc_plugin-build
	$QMAKE_PATH ../ros_qtc_plugin/ros_qtc_plugin.pro -r 
	make -j8

	# Next we must change the rpath to use the local Qt Libraries that get copied into the Qt Creator Directory
	chrpath -r \$\ORIGIN:\$\ORIGIN/..:\$\ORIGIN/../lib/qtcreator:\$\ORIGIN/../../Qt/lib /tmp/$QTC_MINOR_VERSION/lib/qtcreator/plugins/libROSProjectManager.so

	# Now to repackage everything for the installer
    
    # Package Qt Creator
    rm $INSTALLER_DIR_PATH/packages/org.rosindustrial.qtros.${PVersion[0]}${PVersion[1]}${PVersion[2]}.qtc/data/qtcreator.7z
	mkdir -p /tmp/qtcreator/$QTC_MINOR_VERSION
	cd /tmp/qtcreator/$QTC_MINOR_VERSION
	cp /tmp/$QTC_MINOR_VERSION/qtcreator.7z .
	7zr x -bd qtcreator.7z
	rm qtcreator.7z
	cd /tmp/qtcreator
	7zr a -r qtcreator.7z $QTC_MINOR_VERSION
	mv qtcreator.7z $INSTALLER_DIR_PATH/packages/org.rosindustrial.qtros.${PVersion[0]}${PVersion[1]}${PVersion[2]}.qtc/data

    # Package Qt Creator Source
    rm $INSTALLER_DIR_PATH/packages/org.rosindustrial.qtros.${PVersion[0]}${PVersion[1]}${PVersion[2]}.qtc/data/qtcreator_dev.7z
	mkdir -p /tmp/qtcreator_dev/$QTC_MINOR_VERSION
	cd /tmp/qtcreator_dev/$QTC_MINOR_VERSION
	cp /tmp/$QTC_MINOR_VERSION/qtcreator_dev.7z .
	7zr x -bd qtcreator_dev.7z
	rm qtcreator_dev.7z
	cd /tmp/qtcreator_dev
	7zr a -r qtcreator_dev.7z $QTC_MINOR_VERSION
	mv qtcreator_dev.7z $INSTALLER_DIR_PATH/packages/org.rosindustrial.qtros.${PVersion[0]}${PVersion[1]}${PVersion[2]}.qtc/data

    # Package ROS Qt Creator Plugin
    rm $INSTALLER_DIR_PATH/packages/org.rosindustrial.qtros.${PVersion[0]}${PVersion[1]}${PVersion[2]}.rqtc/data/qtcreator_ros_plugin.7z
	mkdir -p /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/lib/qtcreator/plugins
	cd /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/lib/qtcreator/plugins
	cp /tmp/$QTC_MINOR_VERSION/lib/qtcreator/plugins/libROSProjectManager.so .
	mkdir -p /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/share/qtcreator
	cd /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/share/qtcreator
	cp -r /tmp/ros_qtc_plugin/share/styles .
	cp -r /tmp/ros_qtc_plugin/share/templates .
	cd /tmp/qtcreator_ros_plugin
	7zr a -r qtcreator_ros_plugin.7z $QTC_MINOR_VERSION
	mv qtcreator_ros_plugin.7z $INSTALLER_DIR_PATH/packages/org.rosindustrial.qtros.${PVersion[0]}${PVersion[1]}${PVersion[2]}.rqtc/data
}

# Create Installer data for version 4.4.1
logP "Create Installer data for version 4.4.1"
QTC_MINOR_VERSION=4.4.1
QMAKE_PATH="/home/larmstrong/Qt5.9.2/5.9.2/gcc_64/bin/qmake" # This must be the same version used for qtcreator.7z and qtcreator_dev.7z
createInstallerData
logP "Finished Creating Installer data for version 4.4.1"

# Create Installer data for version 4.3.1
logP "Create Installer data for version 4.3.1"
QTC_MINOR_VERSION=4.3.1
QMAKE_PATH="/home/larmstrong/Qt5.9.1/5.9.1/gcc_64/bin/qmake" # This must be the same version used for qtcreator.7z and qtcreator_dev.7z
createInstallerData
logP "Finished Creating Installer data for version 4.3.1"

# Create binary 
cd $INSTALLER_DIR_PATH
/home/larmstrong/QtIFW-3.0.2/bin/binarycreator --offline-only -c config/config.xml -p packages qtcreator-ros.run


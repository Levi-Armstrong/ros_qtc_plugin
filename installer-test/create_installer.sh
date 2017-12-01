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

# Absolute path to this setup.sh script: create_installer.sh
SCRIPT_FILE_PATH=$(readlink -f $0)
# Absolute path to this setup.sh script
INSTALLER_DIR_PATH=`dirname $SCRIPT_FILE_PATH`
BASE_PACKAGE_NAME=org.rosindustrial.qtros

function init {
    # Get Major Version
	PVersion=(`echo $QTC_MINOR_VERSION | tr '.' ' '`)
	QTC_MAJOR_VERSION=${PVersion[0]}.${PVersion[1]}

    if [ $QTC_LATEST -eq 1 ]; then
        PACKAGE_NAME=latest
        PACKAGE_DISPLAY_NAME="Qt Creator (latest)"
        QTC_DISPLAY_NAME="Qt Creator ($QTC_MINOR_VERSION)"
        CHECKBOX_DEFAULT=true
    else
        PACKAGE_NAME=${PVersion[0]}${PVersion[1]}${PVersion[2]}
        PACKAGE_DISPLAY_NAME="Qt Creator ($QTC_MINOR_VERSION)"
        QTC_DISPLAY_NAME="Qt Creator"
        CHECKBOX_DEFAULT=false
    fi
    
    # remove directories that may exist
    rm -rf /tmp/$QTC_MINOR_VERSION
    rm -rf /tmp/ros_qtc_plugin
    rm -rf /tmp/ros_qtc_plugin-build
    rm -rf /tmp/qtcreator
    rm -rf /tmp/qtcreator_dev
    rm -rf /tmp/qtcreator_ros_plugin
}

function createConfig {
    mkdir -p $INSTALLER_DIR_PATH/config/
    cp $INSTALLER_DIR_PATH/logo.png $INSTALLER_DIR_PATH/config/logo.png
    cp $INSTALLER_DIR_PATH/watermark.png $INSTALLER_DIR_PATH/config/watermark.png

cat > $INSTALLER_DIR_PATH/config/config.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Installer>
    <Name>Qt Creator with ROS Plug-in</Name>
    <Version>$INSTALLER_VERSION</Version>
    <Title>Qt Creator with ROS Plug-in</Title>
    <Publisher>Qt Project and ROS-Industrial</Publisher>

    <InstallerWindowIcon>logo.png</InstallerWindowIcon>
    <Watermark>watermark.png</Watermark>
    <WizardDefaultHeight>520</WizardDefaultHeight>
    <MaintenanceToolName>QtCreatorUninstaller</MaintenanceToolName>
    <TargetDir>@HomeDir@/QtCreator</TargetDir>
    <RemoteRepositories>
         <Repository>
                 <Url>https://aeswiki.datasys.swri.edu/home/levi/qtcreator_ros/downloads/packages/Updates.xml</Url>
                 <Enabled>1</Enabled>
                 <DisplayName>Qt Creator with ROS Plug-in</DisplayName>
         </Repository>
    </RemoteRepositories>
</Installer>
EOF
}

function createRootPackage {
    mkdir -p $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME/meta
    cp $INSTALLER_DIR_PATH/LICENSE.GPL3-EXCEPT $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME/meta/LICENSE.GPL3-EXCEPT
    cp $INSTALLER_DIR_PATH/LICENSE.APACHE $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME/meta/LICENSE.APACHE
    cp $INSTALLER_DIR_PATH/page.ui $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME/meta/page.ui
 
cat > $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME/meta/package.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Package>
    <DisplayName>Qt Creator for ROS</DisplayName>
    <Description>Install Qt Creator for ROS Development</Description>
    <Version>$INSTALLER_VERSION</Version>
    <ReleaseDate>$INSTALLER_RELEASE_DATE</ReleaseDate>
    <Licenses>
        <License name="GNU GPL version 3 (with exception clauses)" file="LICENSE.GPL3-EXCEPT" />
        <License name="Apache License, Version 2.0" file="LICENSE.APACHE" />
    </Licenses>
    <UserInterfaces>
        <UserInterface>page.ui</UserInterface>
    </UserInterfaces>
    <Checkable>false</Checkable>
</Package>
EOF
}

function createQtCreatorPackage {
    mkdir -p $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc/meta
    mkdir -p $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc/data

cat > $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc/meta/package.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Package>
    <DisplayName>$QTC_DISPLAY_NAME</DisplayName>
    <Description>Installs the Qt Creator IDE</Description>
    <Version>$QTC_MINOR_VERSION</Version>
    <ReleaseDate>$QTC_RELEASE_DATE</ReleaseDate>
    <Name>org.rosindustrial.qtros.$PACKAGE_NAME.qtc</Name>
    <Dependencies>$BASE_PACKAGE_NAME.$PACKAGE_NAME</Dependencies>
    <Script>installscript.qs</Script>
    <Checkable>false</Checkable>
</Package>
EOF
}

function createROSQtCreatorPluginPackage {
    mkdir -p $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.rqtc/meta
    mkdir -p $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.rqtc/data

cat > $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.rqtc/meta/package.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Package>
    <DisplayName>ROS Plug-in ($RQTC_MINOR_VERSION)</DisplayName>
    <Description>Installs the ROS Qt Creator Plug-in</Description>
    <Version>$RQTC_MINOR_VERSION</Version>
    <ReleaseDate>$RQTC_RELEASE_DATE</ReleaseDate>
    <Name>org.rosindustrial.qtros.$PACKAGE_NAME.rqtc</Name>
    <Dependencies>$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc</Dependencies>
    <Checkable>false</Checkable>
</Package>
EOF
}

function createInstallScript {
cat > $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc/meta/installscript.qs << EOF
function Component()
{
}

Component.prototype.createOperations = function()
{
    // Call the base createOperations and afterwards set some registry settings
    component.createOperations();
    if ( installer.value("os") == "x11" )
    {
        component.addOperation( "InstallIcons", "@TargetDir@/$QTC_MINOR_VERSION/share/icons" );
        component.addOperation( "CreateDesktopEntry",
                                "QtProject-qtcreator-ros-$PACKAGE_NAME.desktop",
                                "Type=Application\nExec=" +  installer.value("TargetDir") + "/$QTC_MINOR_VERSION/bin/qtcreator\nPath=@TargetDir@/$QTC_MINOR_VERSION\nName=Qt Creator ($QTC_MINOR_VERSION)\nGenericName=The IDE of choice for Qt development.\nGenericName[de]=Die IDE der Wahl zur Qt Entwicklung\nIcon=QtProject-qtcreator\nTerminal=false\nCategories=Development;IDE;Qt;\nMimeType=text/x-c++src;text/x-c++hdr;text/x-xsrc;application/x-designer;application/vnd.qt.qmakeprofile;application/vnd.qt.xml.resource;text/x-qml;text/x-qt.qml;text/x-qt.qbs;"
                                );
    }
}
EOF
}

function createPackage {
    mkdir -p $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME/meta

cat > $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME/meta/package.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Package>
    <DisplayName>$PACKAGE_DISPLAY_NAME</DisplayName>
    <Description>Installs the Qt Creator IDE with ROS Plug-in</Description>
    <Version>$RQTC_MINOR_VERSION</Version>
    <ReleaseDate>$RQTC_RELEASE_DATE</ReleaseDate>
    <Name>org.rosindustrial.qtros.$PACKAGE_NAME</Name>
    <Dependencies>$BASE_PACKAGE_NAME</Dependencies>
    <SortingPriority>$SortingPriority</SortingPriority>
    <Default>$CHECKBOX_DEFAULT</Default>
</Package>
EOF

    createQtCreatorPackage
    createROSQtCreatorPluginPackage
    createInstallScript
}



function createInstallerData {
	export QTC_SOURCE=/tmp/$QTC_MINOR_VERSION
	export QTC_BUILD=/tmp/$QTC_MINOR_VERSION

	mkdir -p /tmp/$QTC_MINOR_VERSION
	cd /tmp/$QTC_MINOR_VERSION

    # Download the version of Qt Creator from Qt
	wget https://download.qt.io/official_releases/qtcreator/$QTC_MAJOR_VERSION/$QTC_MINOR_VERSION/installer_source/linux_gcc_64_rhel72/qtcreator.7z
	
    # Extract Qt Creator Data
	7zr x -bd qtcreator.7z
    rm qtcreator.7z 

    # May need to create a symbolic link with version of qtcreator binary to allow multiple versions.

    # Package Qt Creator
    rm $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc/data/qtcreator.7z
	cd /tmp
	7zr a -r qtcreator.7z $QTC_MINOR_VERSION
	mv qtcreator.7z $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.qtc/data

    cd /tmp/$QTC_MINOR_VERSION
    wget https://download.qt.io/official_releases/qtcreator/$QTC_MAJOR_VERSION/$QTC_MINOR_VERSION/installer_source/linux_gcc_64_rhel72/qtcreator_dev.7z
	7zr x -y -bd qtcreator_dev.7z
    rm qtcreator_dev.7z
	 
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

    # Package ROS Qt Creator Plugin
    rm $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.rqtc/data/qtcreator_ros_plugin.7z
	mkdir -p /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/lib/qtcreator/plugins
	cd /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/lib/qtcreator/plugins
	cp /tmp/$QTC_MINOR_VERSION/lib/qtcreator/plugins/libROSProjectManager.so .
	mkdir -p /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/share/qtcreator
	cd /tmp/qtcreator_ros_plugin/$QTC_MINOR_VERSION/share/qtcreator
	cp -r /tmp/ros_qtc_plugin/share/styles .
	cp -r /tmp/ros_qtc_plugin/share/templates .
	cd /tmp/qtcreator_ros_plugin
	7zr a -r qtcreator_ros_plugin.7z $QTC_MINOR_VERSION
	mv qtcreator_ros_plugin.7z $INSTALLER_DIR_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME.rqtc/data
}

# Installer Data
INSTALLER_VERSION=1.0.0
INSTALLER_RELEASE_DATE=2018-11-27
createConfig
createRootPackage

# Create Installer data for latest versions
logP "Create Installer data for latest version 4.4.1"
QTC_LATEST=1
QTC_MINOR_VERSION=4.4.1
QTC_RELEASE_DATE=2017-10-04
RQTC_MINOR_VERSION=0.1.8
RQTC_RELEASE_DATE=2018-11-22
SortingPriority=200
QMAKE_PATH="/home/larmstrong/Qt5.9.2/5.9.2/gcc_64/bin/qmake" # This must be the same version used for qtcreator.7z and qtcreator_dev.7z
init
createPackage
createInstallerData
logP "Finished Creating Installer data for latest version 4.4.1"

#################################################################################################
# The package below this point are provided as archives incase someone need a specific version. #
#################################################################################################
QTC_LATEST=0

# Create Installer data for version 4.3.1
logP "Create Installer data for version 4.3.1"
QTC_MINOR_VERSION=4.3.1
QTC_RELEASE_DATE=2017-06-29
RQTC_MINOR_VERSION=0.1.6
RQTC_RELEASE_DATE=2018-11-22
SortingPriority=50
QMAKE_PATH="/home/larmstrong/Qt5.9.1/5.9.1/gcc_64/bin/qmake" # This must be the same version used for qtcreator.7z and qtcreator_dev.7z
init
createPackage
createInstallerData
logP "Finished Creating Installer data for version 4.3.1"

# Create binary 
cd $INSTALLER_DIR_PATH
/home/larmstrong/QtIFW-3.0.2/bin/binarycreator -f -c config/config.xml -p packages qtcreator-ros-offline-installer.run
/home/larmstrong/QtIFW-3.0.2/bin/binarycreator -n -c config/config.xml -p packages qtcreator-ros-online-installer.run

echo "Commands for updating server"
echo "repogen -p /home/larmstrong/qtc_plugins/ros_qtc_plugin/installer-test/packages/ ."

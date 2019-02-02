#!/bin/bash

# Absolute path
FILE_PATH=$(readlink -f $0)

# Absolute directory path 
DIR_PATH=`dirname $FILE_PATH`

source "$DIR_PATH/installer_functions.sh"

# Create Installer data for latest versions
INSTALLER_VERSION=1.0.3 # This must be incremented for every new release
INSTALLER_RELEASE_DATE=2019-02-01

QTC_LATEST=1
QTC_REPO="https://github.com/qt-creator/qt-creator.git"
QTC_VERSION=4.8.1.0
QTC_BRANCH=v4.8.1
QTC_RELEASE_DATE=2018-10-23
RQTC_VERSION=0.3.1.0
RQTC_RELEASE_DATE=2019-02-01
QTERMWIDGET_BRANCH="debian/xenial"
SortingPriority=200

CLANG_FILENAME=libclang-release_60-linux-Rhel7.2-gcc5.3-x86_64-clazy.7z # Name must be located here https://download.qt.io/development_releases/prebuilt/libclang/
YAML_CPP_TAG=yaml-cpp-0.6.2
QT_PATH=/home/Qt5.11.2/5.11.2/gcc_64 # This must be the same version used for qtcreator.7z and qtcreator_dev.7z
QIFW_PATH=/home/QtIFW-3.0.2/bin/binarycreator

createInstaller


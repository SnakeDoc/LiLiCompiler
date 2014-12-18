#!/bin/bash

set -e
set -u

. settings/config
. scripts/utils/utils.sh

# Archives builds

BUILD_DATE=$(date +%Y%m%d)

SHORT_VERSION=$(echo ${VERSION} | cut -d " " -f 1)
ARCHIVE_NAME="${BUILD_DATE}-${COMPILER_NAME,,}-${SHORT_VERSION}-${CLFS_ARM_ARCH}-rpi"

# Ensure builds directory exists
mkdir -pv "${BUILDS}/"

######################################
####   Make archive of compiler   ####
######################################
if [ -d "${CLFS_TOOLS}" ]; then
    echo "Creating archive of compiler build"
    pre="$(pwd)"
    cd "${CLFS_TOOLS}/"

    # make tar.bz2 archive
    tar jcfv "${BUILDS}/${ARCHIVE_NAME}-compiler.tar.bz2" *
    sync

    # make tar.gz archive
    tar cvzf "${BUILDS}/${ARCHIVE_NAME}-compiler.tar.gz" *
    sync

    cd "${pre}/"
fi

echo -n "Archiving compiler build: "
show_status "${OK}"


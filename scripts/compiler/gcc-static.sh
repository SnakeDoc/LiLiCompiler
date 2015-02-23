#!/bin/bash

# gcc (static)

set -e
set -u

. settings/config
. scripts/utils/utils.sh

pkg_dir="$(locate_package 'gcc')"

. "${pkg_dir}/package.mk"

cd ${CLFS_SOURCES}/
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

if [ -d "${CLFS_SOURCES}/${PKG_NAME}-build" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-build"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -xvjf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

patch -Np1 -i "${SOURCES}/${PKG_NAME}-${PKG_VERSION}-musl.diff"

# setup build
. "${pkg_dir}/package.mk"
mkdir -v "${CLFS_SOURCES}/${PKG_NAME}-build"
cd "${CLFS_SOURCES}/${PKG_NAME}-build/"

"${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/configure" "${STATIC_CONFIGURE_OPTS[@]}"
  
make all-gcc all-target-libgcc

make install-gcc install-target-libgcc

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"
rm -rf "${PKG_NAME}-build"

exit 0


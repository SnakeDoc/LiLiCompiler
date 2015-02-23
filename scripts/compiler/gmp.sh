#!/bin/bash

# GMP

set -e
set -u

# build libgmp
sub_pkg_dir="$(locate_package 'gmp')"

. "${sub_pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"

if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}${PKG_SUB_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"

# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

cd "${CLFS_SOURCES}/"

tar -xjvf "${PKG_NAME}-${PKG_VERSION}${PKG_SUB_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

M4="${CLFS_ENV_PATH}/m4" CPPFLAGS=-fexceptions ./configure "${PKG_CONFIGURE_OPTS[@]}"

make

make install

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0


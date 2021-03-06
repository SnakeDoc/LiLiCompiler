#!/bin/bash

# M4

set -e
set -u

. settings/config
. scripts/utils/utils.sh

pkg_dir="$(locate_package 'm4')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.gz" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -zxvf "${PKG_NAME}-${PKG_VERSION}.tar.gz"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

#patch -Np1 -i "${SOURCES}/${PKG_NAME}-${PKG_VERSION}-musl.patch

# setup build

"${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/configure" "${PKG_CONFIGURE_OPTS[@]}"

make

make check

make install

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0


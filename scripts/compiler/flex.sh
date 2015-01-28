#!/bin/bash

# Flex

set -e
set -u

. settings/config
. scripts/utils/utils.sh

pkg_dir="$(locate_package 'flex')"

. "${pkg_dir}/package.mk"

cd "${CLFS_SOURCES}/"
if [ ! -e "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}.tar.bz2" ]; then
    wget --read-timeout=20 "${PKG_URL}"
fi

cd "${CLFS_SOURCES}/"
# make sure things are clean
if [ -d "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}" ]; then
    rm -rf "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}"
fi

# business time
cd "${CLFS_SOURCES}/"
tar -xjvf "${PKG_NAME}-${PKG_VERSION}.tar.bz2"

cd "${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/"

# setup build
export M4="${CLFS_TOOLS}/bin/m4"

# skup regression tests that require bison, since it's not build yet
sed -i -e '/test-bison/d' tests/Makefile.in

"${CLFS_SOURCES}/${PKG_NAME}-${PKG_VERSION}/configure" "${PKG_CONFIGURE_OPTS[@]}"

make

make check

make install

# link lex -> flex because some programs expect lex binary still
OLD_PWD="$(pwd)"
cd "${CLFS_TOOLS}/bin"
ln -svf flex lex
cd "${OLD_PWD}"

# cleanup
cd "${CLFS_SOURCES}/"
rm -rf "${PKG_NAME}-${PKG_VERSION}"

exit 0


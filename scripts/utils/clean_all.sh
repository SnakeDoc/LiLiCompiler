#!/bin/bash

set -e
set -u

. settings/config

# Clean all directories

${SCRIPTS}/utils/clean_sources.sh
${SCRIPTS}/utils/clean_compiler.sh

exit 0


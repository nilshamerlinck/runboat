#!/bin/bash

#
# Install all addons in the test database.
#

set -ex

bash /runboat/runboat-clone-and-install.sh

oca_wait_for_postgres

# Drop database, in case we are reinitializing after failure.
dropdb --if-exists $PGDATABASE

ADDONS=$(addons --addons-dir ${ADDONS_DIR} --include "${INCLUDE}" --exclude "${EXCLUDE}" list)

unbuffer $(which odoo || which openerp-server) \
  -d ${PGDATABASE} \
  -i ${ADDONS:-base} \
  --stop-after-init
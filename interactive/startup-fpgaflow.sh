#!/bin/bash
set -e

# change back to user
su - spinaldev

# needed to run parameters CMD
exec "$@"


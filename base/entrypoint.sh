#!/usr/bin/env bash
set -e

# permissions can be fixed only if running under root, remove USER www-data from Dockerfile to do so
#echo "Fixing permissions on var folder"
#chmod a+rwx /var/www/var/

#echo "Delete content of cache directory to clear all cache"
# problem with too many files: /usr/local/bin/entrypoint.sh: line 9: /bin/rm: Argument list too long
#rm -rf /var/www/var/cache/*

/usr/bin/supervisord

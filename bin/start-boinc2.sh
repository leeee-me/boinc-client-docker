#!/bin/bash

# Configure the GUI RPC
echo $BOINC_GUI_RPC_PASSWORD > /var/lib/boinc/gui_rpc_auth.cfg
echo $BOINC_REMOTE_HOST > /var/lib/boinc/remote_hosts.cfg

# verify container user was set in dockerfile
if [ -z "$USER" ]; then
    USER=boinc
fi

# verify host uid and gid passed in
if [ -z "${HOST_USER_ID}" -a -z "${HOST_USER_GID}" ]; then
    echo "Pass host uid and gid in docker run command" ;
    echo "e.g. -e HOST_USER_ID=$uid -e HOST_USER_GID=$gid" ;
    exit -2
fi

# replace uid and guid in /etc/passwd and /etc/group
sed -i -e "s/^${USER}:\([^:]*\):[0-9]*:[0-9]*/${USER}:\1:${HOST_USER_ID}:${HOST_USER_GID}/"  /etc/passwd
sed -i -e "s/^${USER}:\([^:]*\):[0-9]*/${USER}:\1:${HOST_USER_GID}/"  /etc/group

chown -R boinc.boinc /var/lib/boinc

# Run BOINC. Full path needs for GPU support.
exec start-stop-daemon --start --pidfile /var/run/boinc.pid --user ${HOST_USER_ID} --group ${HOST_USER_GID} --chuid ${HOST_USER_ID}:${HOST_USER_GID} --chdir /var/lib/boinc --exec /usr/bin/boinc -- $BOINC_CMD_LINE_OPTIONS

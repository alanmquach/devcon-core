#!/bin/bash

BOOTSTRAPLOG="/tmp/bootstrap.log"

NEWUSER=$1
AUTHORIZEDKEYS=$2
BOOTSTRAPSH=$3

if [ -z "$NEWUSER" ]; then
    echo "Warning, a user was not provided." | tee -a $BOOTSTRAPLOG
    if [ -z "$AUTHORIZEDKEYS" ]; then
        echo "authorized_keys was not provided, but it would have been ignored anyways."
    else
        echo "Provided authorized_keys was ignored because no user was provided." | tee -a $BOOTSTRAPLOG
    fi
else
    adduser --gecos "" --disabled-password $NEWUSER | tee -a $BOOTSTRAPLOG
    echo "User \"$NEWUSER\" created. Now chown'ing /home/$NEWUSER in case it got mounted in and is owned by root" | tee -a $BOOTSTRAPLOG
    chown $NEWUSER:$NEWUSER /home/$NEWUSER | tee -a $BOOTSTRAPLOG
    if [ -z "$AUTHORIZEDKEYS" ]; then
        echo "authorized_keys was not provided and thus not initialized for $NEWUSER" | tee -a $BOOTSTRAPLOG
    else
        echo "Initializing authorized_keys for $NEWUSER:" | tee -a $BOOTSTRAPLOG
        echo "$AUTHORIZEDKEYS" | tee -a $BOOTSTRAPLOG
        su -c "mkdir ~/.ssh; echo \"$AUTHORIZEDKEYS\" > ~/.ssh/authorized_keys" $NEWUSER
    fi
fi

# This is messy, but it allows extensibility
if [ -f "/tmp/bootstrap2.sh" ]; then
    echo "/tmp/bootstrap2.sh found, executing..." | tee -a $BOOTSTRAPLOG
    /bin/bash /tmp/bootstrap2.sh | tee -a $BOOTSTRAPLOG
fi

if [ -z "$BOOTSTRAPSH" ]; then
    echo "No further customization." | tee -a $BOOTSTRAPLOG
else
    if [ -f "$BOOTSTRAPSH" ]; then
        echo "Executing \"/bin/bash $BOOTSTRAPSH\"" | tee -a $BOOTSTRAPLOG
        /bin/bash $BOOTSTRAPSH | tee -a $BOOTSTRAPLOG
        echo "Extended customization complete." | tee -a $BOOTSTRAPLOG
    else
        echo "Provided bootstrap script did not exist: $BOOTSTRAPSH" | tee -a $BOOTSTRAPLOG
    fi
fi

echo "Bootstrapping complete. Now launching sshd" | tee -a $BOOTSTRAPLOG
/usr/sbin/sshd -D


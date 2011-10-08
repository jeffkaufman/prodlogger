#!/bin/bash

# 2011-10-07  Jeff Kaufman
#
# Released into the public domain.

DIR=~/.prodlog
LOCKDIR=~/.prodlog/lock
PIDFILE=~/.prodlog/lock/pid
PRODLOG=prodlog

mkdir "$DIR" &> /dev/null # fine if it already exists

# locking
if ! mkdir "$LOCKDIR" &> /dev/null
then # we don't have the lock

    # check if the original process is still active
    if kill -0 $(cat "$PIDFILE") &> /dev/null
    then # process is still active
	exit 0
    else # process died

	# remove the pid file and the lock
	rm "$PIDFILE"
	rmdir "$LOCKDIR"

	# restart
	exec "$0" "$@"

	# this line is never reached
	exit 1
    fi
fi

echo "$$" > "$PIDFILE"

function outfile {
    echo "$DIR"/$(($(date "+%s")/10000)).log
}


while [ "$$" = $(cat $PIDFILE) ]
do
    CUR_FNAME="$(outfile)"
    "$PRODLOG" >> "$CUR_FNAME"

    # zip old logs if needed
    for x in "$DIR"/*.log
    do
	if [ $(basename "$x") != $(basename "$CUR_FNAME") ]
	then # old log file
	    gzip "$x"
	fi
    done

    sleep 1
done

#!/bin/sh

if [ -z $1 ]; then
	echo "Usage: startjob.sh <RAILS_ENV>"
	echo "Where <RAILS_ENV> can be: ladev, eems-test, production"
	exit
fi

/usr/bin/env RAILS_ENV=$1 /opt/app/eems/eems/current/script/delayed_job stop

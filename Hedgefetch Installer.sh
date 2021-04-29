#!/bin/bash
set -e
DIR=$(dirname "$0")
if [ -d /usr/local/bin ]; then
	echo "Installing to /usr/local/bin"
	cp "$DIR/hedgefetch" /usr/local/bin/
	INS=$(echo /usr/local/bin)
else
	echo "Creating /usr/local/bin"
	osascript -e 'do shell script "mkdir -p /usr/local/bin" with administrator privileges'
	echo "Installing to /usr/local/bin"
	cp "$DIR/hedgefetch" /usr/local/bin/
	INS=$(echo /usr/local/bin)
fi
echo "Finished!"
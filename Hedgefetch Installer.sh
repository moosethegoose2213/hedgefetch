#!/bin/bash
set -e
DIR=$(dirname "$0")
echo $DIR >> /tmp/dir
if [ -d /usr/local/bin ]; then
	echo "Installing to /usr/local/bin"
	cp "$DIR/hedgefetch" /usr/local/bin/hedgefetch
#osascript -e 'do shell script "cp  " & (quoted form of (do shell script "cat /tmp/dir")) & "/hedgefetch /usr/local/bin/hedgefetch" with administrator privileges'
	INS=$(echo /usr/local/bin)
else
	echo "Installing to /bin"
cp "$DIR/hedgefetch" /bin/hedgefetch
#osascript -e 'do shell script "cp $DIR/hedgefetch /bin/hedgefetch" with administrator privileges'
	INS=$(echo /bin)

fi

if [ -e $INS/hedgefetch ]; then
	echo 'Install successful! Try it out by running "hedgefetch" in terminal.'
else
	echo "Install failed successfully! Please try again, and if that doesn't work report this to GitHub."
	echo "Heres a nice rickroll to cheer you up!"
	open https://www.youtube.com/watch?v=dQw4w9WgXcQ
fi
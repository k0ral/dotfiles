#!/bin/sh

# Options
useragent="Firefox"
target=$HOME

# Try to add URI to running instance of aria
notify-send --icon /usr/share/uzbl/examples/data/uzbl.png "Downloading ($3)" "$2\n$4 bytes"
#aria2rpc addUri "$1" -o "$2"
cd $target
wget --user-agent $useragent $1

# If it failed, aria probably isn't running yet
#if [ $? -gt 0 ]; then
#    # Start new instance of aria
#    aria2c -D -c \
#        -d $target \
#        -U $useragent \
#        --enable-rpc \

#        #>/dev/null 2>&1

#    # Now try again
#    aria2rpc addUri "$1" -o "$2"

#    # If it failed once more, fall back to wget
#    if [ $? -gt 0 ]; then
#        ( cd $target && wget --user-agent $useragent $1 )
#    fi
#fi

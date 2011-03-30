#!/bin/sh

DMENU_SCHEME="bookmarks"
DMENU_OPTIONS="xmms vertical resize"
BOOKMARKS_FILE=$XDG_CONFIG_HOME/uzbl/bookmarks

. "$UZBL_UTIL_DIR"/dmenu.sh
. "$UZBL_UTIL_DIR"/uzbl-dir.sh

[ -d "$UZBL_DATA_DIR" ] || exit 1


scriptfile=$0                            # this script
shift 7
act="$1"

case $act in
    # Add current page to bookmarks
    "add" )
        # Not enough arguments
        if [ $# -lt 2 ]; then
            echo "Not enough argument."
            exit 1
        fi

        tags=$(echo $* | cut -d' ' -f2-)

        echo -e "$UZBL_URI $tags" >> $BOOKMARKS_FILE
    ;;

    # Add all currently opened pages to bookmarks
    "add-all" )
        # Not enough arguments
        if [ $# -lt 2 ]; then
            echo "Not enough argument."
            exit 1
        fi

        tags=$(echo $* | cut -d' ' -f2-)

        for fifo in "$UZBL_FIFO_DIR"/uzbl_fifo_*; do
            echo "spawn $scriptfile add $tags" > "$fifo" &
        done
    ;;

    "delete-tag" )
        tag=$(awk '{for (i = 2; i <= NF; i++) print $i; }' "$BOOKMARKS_FILE" | sort -bfu | $DMENU)

        if [ -n "$tag" ]; then
            sed -i".bak" '/ '$tag'/d' "$BOOKMARKS_FILE"
        fi
    ;;

    # Load a single bookmark
    "load" )
        URI=$(sed -e 's/%/%%/g' "$BOOKMARKS_FILE" | awk '{for (i = 2; i <= NF; i++) printf "[%s] ", $i; printf $1 "\n"}' | sort -bf | $DMENU | awk '{print $NF}')

        [ -n "$URI" ] && echo "uri $URI" > "$UZBL_FIFO"
    ;;

    # Load all bookmarks for a given tag
    "load-tag" )
        tag=$(awk '{for (i = 2; i <= NF; i++) print $i; }' "$BOOKMARKS_FILE" | sort -bfu | $DMENU)
        URIs=$(awk '/'$tag'/ {print $1}' "$BOOKMARKS_FILE" | sort -bfu)

        [ -n "$tag" ] && [ -n "$URIs" ] || exit 2

        for URI in $URIs; do
            echo "event NEW_WINDOW $URI" > "$UZBL_FIFO"
        done
    ;;

    * )
        echo "Bookmarks manager: bad action"
        echo "Usage: $scriptfile [COMMAND] where commands are:"
        echo " add          - Add a new single bookmark."
        echo " add-all      - Add all currently opened pages as bookmarks."
        echo " delete-tag   - Delete all bookmarks with a given tag."
        echo " load         - Load a single bookmark in current uzbl-browser instance."
        echo " load-tag     - Load all bookmarks with a given tag in new uzbl-browser instances."
    ;;
esac

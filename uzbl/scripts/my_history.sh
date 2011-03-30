#!/bin/sh

. $UZBL_UTIL_DIR/uzbl-dir.sh

[ -w "$UZBL_HISTORY_FILE" ] || [ ! -a "$UZBL_HISTORY_FILE" ] || exit 1

echo $(date +'%Y-%m-%d %H:%M:%S')" $UZBL_URI $UZBL_TITLE" >> $UZBL_HISTORY_FILE

# Remove dupes and truncate
tail -100 $UZBL_HISTORY_FILE > history.new
mv history.new $UZBL_HISTORY_FILE

exit 0

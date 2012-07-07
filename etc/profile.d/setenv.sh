# Locales
export LANG='en_US.utf8'
export LANGUAGE='en_US.utf8'
export LC_ADDRESS='en_US.utf8'
export LC_ALL='en_US.utf8'
export LC_COLLATE='en_US.utf8'
export LC_IDENTIFICATION='en_US.utf8'
export LC_MESSAGES='en_US.utf8'
export LC_MEASUREMENT='en_US.utf8'
export LC_MONETARY='en_US.utf8'
export LC_NAME='en_US.utf8'
export LC_NUMERIC='en_US.utf8'
export LC_PAPER='en_US.utf8'
export LC_TELEPHONE='en_US.utf8'
export LC_TIME='en_US.utf8'
export LC_TYPE='en_US.utf8'
 
# Default applications
export BROWSER='/usr/bin/firefox'
export CC='/usr/bin/colorgcc'
export EDITOR='/usr/bin/emacsclient -t'
export PAGER='/usr/bin/less'
#set TERM "rxvt-unicode"
#set XTERM "urxvt"
 
# Misc
export ALTERNATE_EDITOR=''
export COLORTERM='yes'
export MAILCHECK
#set http_proxy "http://localhost:8118"
#set HTTP_PROXY $http_proxy
export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' 
export JAVA_FONTS='/usr/share/fonts/TTF'
export GDK_USE_XFT=1      #   For old gtk applications
export QT_XFT='true'      #   For old qt applicatios
 
eval `dircolors -b`

export PATH=/usr/lib/ccache/bin/:/usr/lib/colorgcc/bin:~/.cabal/bin:$PATH

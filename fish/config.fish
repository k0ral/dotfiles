# {{{ Environment variables
#if status --is-login
#set -q INIT
#
#if [ $status != 0 ];
#    echo "First start => setenv"
#    set -Ux INIT "OK"
#
#    # Locales
#    set -Ux LANG en_US.utf8
#    set -Ux LANGUAGE en_US.utf8
#    set -Ux LC_ADDRESS en_US.utf8
#    set -Ux LC_ALL en_US.utf8
#    set -Ux LC_COLLATE en_US.utf8
#    set -Ux LC_IDENTIFICATION en_US.utf8
#    set -Ux LC_MESSAGES en_US.utf8
#    set -Ux LC_MEASUREMENT en_US.utf8
#    set -Ux LC_MONETARY en_US.utf8
#    set -Ux LC_NAME en_US.utf8
#    set -Ux LC_NUMERIC en_US.utf8
#    set -Ux LC_PAPER en_US.utf8
#    set -Ux LC_TELEPHONE en_US.utf8
#    set -Ux LC_TIME en_US.utf8
#    set -Ux LC_TYPE en_US.utf8
#
#    # Default applications
#    set -Ux BROWSER /usr/bin/firefox
#    set -Ux CC /usr/bin/colorgcc
#    set -Ux EDITOR '/usr/bin/emacsclient -t'
#    set -Ux PAGER /usr/bin/less
#    #set TERM "rxvt-unicode"
#    #set XTERM "urxvt"
#
#    # Misc
#    set -Ux ALTERNATE_EDITOR ""
#    set -Ux COLORTERM "yes"
#    set -Uxe MAILCHECK
#    #set http_proxy "http://localhost:8118"
#    #set HTTP_PROXY $http_proxy
#    set -Ux _JAVA_OPTIONS '-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
#    set -Ux JAVA_FONTS /usr/share/fonts/TTF
#    set -Ux GDK_USE_XFT 1    #   For old gtk applications
#    set -Ux QT_XFT true      #   For old qt applicatios
#
#    #eval `dircolors -b`
#    set -Ux LS_COLORS "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
#end
#
#set PATH /usr/lib/ccache/bin/ /usr/lib/colorgcc/bin ~/.cabal/bin $PATH
# }}}

# {{{ Prompt
function fish_prompt
    set_color $fish_color_cwd

    echo -n (whoami)

    set_color normal
    echo -n '@'
    set_color purple
    echo -n (hostname)
    set_color normal
    echo -n ':'

# Color writeable dirs green, read-only dirs red
    if test -w "."
        set_color green
    else
        set_color red
    end
    echo -n (prompt_pwd)
    set_color normal

# Subversion repository
    if test -d ".svn"
        echo -n ' ['(parse_svn_revision)']'
    end

# Git repository
    if test -d ".git"
        echo -n ' ['(parse_git_branch)']'
    end

# Mercurial repository
    if hg root >/dev/null 2>/dev/null; echo ' [☿]'; return; end

    echo ''
    set_color normal
    echo -n '> '
end
# }}}

# {{{ Aliases: custom options
function chmod
    chmod -c --preserve-root $argv
end

function cp
    command cp -v --strip-trailing-slashes $argv
end

function mkdir
    command mkdir -p -v $argv
end

function mv
    command mv -v $argv
end

function rename
    rename -v $argv
end

function ls
    command ls --tabsize=0 --literal --color=auto --show-control-chars -p -h --group-directories-first -X $argv
end

function df
    command df -hT
end

#alias df="cdf -h"
#alias du='du -chs'

function caly
    cal -y $argv
end

function free
    command free -h $argv
end

function egrep
    command egrep --color=auto $argv
end

function fgrep
    command fgrep --color=auto $argv
end

function locate
    command locate -e $argv
end

function mplayer
    command mplayer -msgcolor $argv
end

function mutt
    command mutt -y $argv
end

function my_indent
    indent -bad -bap -bbo -bc -nbfda -br -brs -cbi0 -cdb -cdw -ce -ncs -di4 -fca -hnl -i4 -ip4 -l120 -lp -nlps -npcs -nprs -npsl -saf -sai -saw -sbi4 -sc -nsob -ss -ts4 -nut $argv
end

function octave
    octave -q $argv
end

function wget
    command wget -c $argv
end
# }}}


# {{{ Aliases: shorter commands
function e
    emacsclient -t -a "" $argv
end

function E
    set SUDO_EDITOR "emacsclient -t"
    sudoedit $argv
end

function f
    find ./ -name $argv
end

function h
    halt
end

function l
    ls -l $argv
end

function la
    ls -la $argv
end

function lsa
    ls -a $argv
end

function m
    mutt
end

function mk
    mkdir $argv
end

function n
    ncmpcpp $argv
end

function o
    open $argv
end

function s
    sudo $argv
end

function vol
    alsamixer
end
# }}}

function cd
    builtin cd $argv; and ls
end

# {{{ Aliases: alternative programs
function diff
    colordiff $argv
end

function gcc
    colorgcc $argv
end

function rm
    safe-rm -v $argv
end

#alias grep='grep --color=auto'
#alias make="colormake"

#alias emacs='emacsclient -c -n -a ""'

function gdb
    cgdb -q $argv
end

#alias -p grep='ack'
#alias more='vimpager'
#alias less='vimpager'

function pacman
    pacman-color $argv
end

#alias ping='mtr'

function top
    htop $argv
end

#function which
#    type --all $argv
#end

#alias openports='sudo netstat --all --numeric --programs --inet'
# }}}

function listening-ports
    sudo netstat -tlnp
end

function openports
    sudo iptstate -o
end

function pg
    mtr www.google.fr
end

function reco
    sudo dhclient eth0
end

alias dlpage='wget -nd -pHEKk'
alias wifiselect='sudo wifi-select wlan0'

function wtf
    dmesg $argv
end

if [ (whoami) != 'root' ];
    function reboot
        s reboot
    end

    function halt
        s halt
    end

    function up
        pak -Syu --aur
    end

    function remove
        s pacman-color -Rs $argv
    end

    function sys
        s systemctl $argv
    end

    function enable
        sys enable $argv
    end

    function disable
        sys disable $argv
    end

    function start
        sys start $argv
    end

    function stop
        sys stop $argv
    end

    function restart
        sys restart $argv
    end
end
# }}}

# {{{ Functions
function sleep-on
    sudo /etc/rc.d/fcron stop
end

function ls-empty
    find . -type d -empty -print0 | xargs --null ls $argv
end

function rm-empty
    find . -type d -empty -print0 | xargs --null rmdir $argv
end

function u
    wget -c (perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' (xclip -o))
end
# }}}

# {{{ Git utilities
set fish_git_dirty_color red
function parse_git_dirty
    git diff --quiet HEAD ^&-
    if test $status = 1
        echo (set_color $fish_git_dirty_color)"Δ"(set_color normal)
    end
end

function parse_git_branch
    set -l branch (git branch --color ^&- | awk '/*/ {print $2}')
    echo $branch (parse_git_dirty)
end
# }}}

# {{{ SVN utilities
function parse_svn_revision
    sh -c 'svn info 2> /dev/null' | sed -n '/^Revision/p' | sed -e 's/^Revision: \(.*\)/\1/'
end
# }}}

set fish_greeting ''

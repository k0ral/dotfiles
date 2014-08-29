# {{{ Prompt
function fish_prompt
# Is it a remote session ?
    if test -z (who -m)
    else
        set_color red
        echo -n "[remotely] "
    end

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
    if hg root >/dev/null 2>/dev/null; echo -n ' [☿]'; end

    echo ''
    set_color normal
    echo -n '> '
end
# }}}

# {{{ Aliases: custom options
function chmod
    command chmod -c --preserve-root $argv
end

#function cp
#    command cp -v --strip-trailing-slashes $argv
#end

function cp
    rsync -av --progress $argv
end

function dmesg
    command dmesg -T $argv
end

function less
    command most $argv
end

function mkcd
    mkdir $argv
    cd $argv
end

function mkdir
    command mkdir -p -v $argv
end

function mv
    command mv -v $argv
end

function rename
    command rename -v $argv
end

function ls
    command ls --tabsize=0 --literal --color=auto --show-control-chars -p -h --group-directories-first -X $argv
end

function df
    # pydf $argv
    dfc $argv
end

function du
    command du -hs $argv
end

function caly
    cal -y $argv
end

function free
    command free -h $argv
end

function grep
    ack $argv
end

function egrep
    command egrep --color=auto $argv
end

function ffmpeg
    command ffmpeg -hide_banner $argv
end

function fgrep
    command fgrep --color=auto $argv
end

function locate
    command locate -e $argv
end

function mutt
    command mutt -y $argv
end

function my_indent
    indent -bad -bap -bbo -bc -nbfda -br -brs -cbi0 -cdb -cdw -ce -ncs -di4 -fca -hnl -i4 -ip4 -l120 -lp -nlps -npcs -nprs -npsl -saf -sai -saw -sbi4 -sc -nsob -ss -ts4 -nut $argv
end

function octave
    command octave -q $argv
end

function sshfs
    command sshfs -o follow_symlinks $argv
end

function wget
    command wget -c $argv
end
# }}}


# {{{ Aliases: shorter commands
function e
    emacsclient -c -n $argv
end

function E
    set SUDO_EDITOR "emacsclient -c -n"
    sudoedit $argv
end

function f
    find ./ -name $argv
end

function g
    sr google $argv
end

function h
    systemctl poweroff
end

function l
    ls -og --time-style=+ $argv
end

function ll
    ls -l $argv
end

function la
    ls -la $argv
end

function lsa
    ls -a $argv
end

function m
    runInTmux main mutt
end

function mk
    mkdir $argv
end

function n
    runInTmux main ncmpcpp
end

function o
    open $argv
end

function r
    systemctl reboot
end

function s
    sudo $argv
end

function v
    runInTmux main alsamixer
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

#function gdb
#    cgdb -q $argv
#end

#alias -p grep='ack'
#alias more='vimpager'
#alias less='vimpager'

function ping
    grc ping $argv
end

function top
    htop $argv
end

function traceroute
    grc traceroute $argv
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

function play
    mpv --hwdec=auto $argv
end

function splay
    mpv --no-audio $argv
end

function reco
    sudo dhclient eth0
end

alias dlpage='wget -nd -pHEKk'

function wifi
    s wifi-select wlan0
end

function bit
    transmission-remote twyk.org $argv
end

function logsu
    journalctl --user-unit $argv
end

function sysu
    systemctl --user $argv
end


if [ (whoami) != 'root' ];
    function up
        yaourt -Syu --aur
    end

    function remove
        s pacman -Rs $argv
    end

    function logs
        s journalctl -u $argv
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
function cutFrom
    echo "> ffmpeg -ss $argv[1] -i $argv[2] -acodec copy -vcodec copy new.$argv[2]"
    ffmpeg -ss $argv[1] -i $argv[2] -acodec copy -vcodec copy new.$argv[2]
end

function cutTo
    echo "> ffmpeg -i $argv[2] -acodec copy -vcodec copy -to $argv[1] new.$argv[2]"
    ffmpeg -i $argv[2] -acodec copy -vcodec copy -to $argv[1] new.$argv[2]
end


function runInTmux
    tmux new -s $argv[1]
    tmux -q findw -N $argv[2]; or tmux neww -n $argv[2] $argv[2]
end

function fade
    # echo "systemctl poweroff" | at now +60 minutes
    watch -n 90 amixer set Master 1-
end

function ls-empty
    find . -type d -empty -print0 | xargs --null ls $argv
end

function sbg
    cd $HOME/images/wallpapers
    /usr/bin/hsetroot -fill (/bin/ls | /usr/bin/shuf -n 1)
end

function rm-empty
    find . -type d -empty -print0 | xargs --null rmdir $argv
end

function u
    echo "> wget -c (perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' (xclip -o))"
    wget -c (perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' (xclip -o))
end

function uu
    wget -c (perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' (xclip -o)) -O $argv
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

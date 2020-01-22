# {{{ Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
# }}}

# {{{ Prompt
set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_newline_cursor yes
set -g theme_use_abbreviated_branch_name yes
# }}}

# {{{ Aliases: custom options
function chmod
    command chmod -c --preserve-root $argv
end

function cp
#    command cp -v --strip-trailing-slashes $argv
    rsync -av --progress $argv
end

function diff
    command diff --color=always $argv
end

function dmesg
    command dmesg -T $argv
end

function ffmpeg
    command ffmpeg -hide_banner $argv
end

function ffprobe
    command ffprobe -hide_banner $argv
end

function less
    command less -R $argv
end

function lsblk
    command lsblk -o NAME,LABEL,UUID,MODEL,SIZE,FSTYPE,MOUNTPOINT $argv
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
    rg $argv
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

function my_indent
    indent -bad -bap -bbo -bc -nbfda -br -brs -cbi0 -cdb -cdw -ce -ncs -di4 -fca -hnl -i4 -ip4 -l120 -lp -nlps -npcs -nprs -npsl -saf -sai -saw -sbi4 -sc -nsob -ss -ts4 -nut $argv
end

function ncdu
    command ncdu --color dark $argv
end

function octave
    command octave -q $argv
end

function pstree
    command pstree -p -T -a
end

function rm
  command rm -v $argv
end

function sshfs
    command sshfs -o follow_symlinks $argv
end

function tree
  command tree -CAFa -I '.hg|.svn|.git' --dirsfirst $argv
end

function wget
    command wget -c $argv
end
# }}}


# {{{ Aliases: shorter commands
function e
    nvim $argv
end

function E
    set EDITOR "nvim"
    sudoedit $argv
end

function g
    sr google $argv
end

function k
    ps ux | sed 1d | fzf -m | awk '{print $2}' | xargs kill $argv
end

function ll
    ls -l --icons $argv
end

function la
    ls -la $argv
end

function lsa
    ls -a $argv
end

function m
    neomutt $argv
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

function v
    alsamixer $argv
end
# }}}

function cd
    builtin cd $argv; and ls
end

# {{{ Aliases: alternative programs
function gcc
    colorgcc $argv
end

#function gdb
#    cgdb -q $argv
#end

function ls
    exa -g --group-directories-first $argv
end

function ping
    prettyping --nolegend $argv
end

function top
    htop $argv
end

function traceroute
    grc traceroute $argv
end

function vim
    nvim $argv
end
# }}}

function listening-ports
    sudo netstat -tlnp
end

function openports
    s lsof -Pan -i tcp -i udp
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

function logsu
    journalctl --user-unit $argv
end

function sys
    systemctl $argv
end

function sysu
    systemctl --user $argv
end

function logs
    journalctl -u $argv
end

function enable
    sys enable $argv
end

function disable
    sys disable $argv
end

function restart
    sys restart $argv
end

function start
    sys start $argv
end

function stop
    sys stop $argv
end

function suspend
    sys suspend
end

function scale_monitor
    swaymsg output HDMI-A-2 scale $argv
end

function scale_laptop
    swaymsg output eDP-1 scale $argv
end
# }}}

# {{{ Functions
function bitrate
    for i in $argv; ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=nw=1:nk=1 -sexagesimal $i | tr -d '\n'; echo " $i"; end
end

function cutFrom
    echo "> ffmpeg -ss $argv[1] -i $argv[2] -acodec copy -vcodec copy new.$argv[2]"
    ffmpeg -ss $argv[1] -i $argv[2] -acodec copy -vcodec copy new.$argv[2]
end

function cutTo
    echo "> ffmpeg -i $argv[2] -acodec copy -vcodec copy -to $argv[1] new.$argv[2]"
    ffmpeg -i $argv[2] -acodec copy -vcodec copy -to $argv[1] new.$argv[2]
end

function duration
    for i in $argv; ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 -sexagesimal $i | tr -d '\n'; echo " $i"; end
end

function hdmi
    echo "> xrandr --output HDMI2 --auto"
    xrandr --output HDMI2 --auto
end

function audio-hdmi
    pactl set-card-profile 0 output:hdmi-stereo-extra1
end

function audio-jack
    pactl set-card-profile 0 output:analog-stereo
end

function fade
    watch -n 90 amixer set Master 1-
end

function sbg
    feh --randomize --recursive --bg-fill /home/koral/images/wallpapers
end

function u
    echo "> wget -c (xclip -o | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | sed -r 's/\\\\(.)/\1/g')"
    wget -c (xclip -o | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | sed -r 's/\\\\(.)/\1/g')
end

function uu
    wget -c (perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' (xclip -o)) -O $argv
end
# }}}

set fish_greeting ''

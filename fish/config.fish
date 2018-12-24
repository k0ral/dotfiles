# {{{ Fuzzy-find history
function reverse_history_search
  history | fzf --tiebreak index | read -l command
  if test $command
    commandline -rb $command
  end
end

function file_search
  fzf | read -l filepath
  if test $filepath
    commandline -a (echo $filepath | string escape)
  end
end

function cd_home
  fd $HOME -type d | fzf | read -l directory
  if test $directory
    cd $directory
  end
end

function fish_user_key_bindings
  bind \cr reverse_history_search
  bind \ct file_search
  bind \ec cd_home
end
# }}}

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

    echo ''
    set_color normal
    echo -n '> '
end
# }}}

set -x LS_COLORS 'no=00:fi=00:di=01;34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:'

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

function wget
    command wget -c $argv
end
# }}}


# {{{ Aliases: shorter commands
function e
    atom $argv
end

function E
    set SUDO_EDITOR "atom"
    sudoedit $argv
end

function f
    find ./ -name $argv
end

function g
    sr google $argv
end

function k
    ps aux | percol | awk '{ print $2 }' | xargs kill $argv
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

function ping
    grc ping $argv
end

function ls
    #command ls --tabsize=0 --literal --color=auto --show-control-chars -p -h --group-directories-first -X $argv
    exa -g --group-directories-first $argv
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
# }}}

function listening-ports
    sudo netstat -tlnp
end

function openports
    s lsof -Pan -i tcp -i udp
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

function fade
    watch -n 90 amixer set Master 1-
end

function ls-empty
    find . -type d -empty -print0 | xargs --null ls $argv
end

function sbg
    feh --randomize --recursive --bg-fill /home/koral/images/wallpapers
end

function rm-empty
    find . -type d -empty -print0 | xargs --null rmdir $argv
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

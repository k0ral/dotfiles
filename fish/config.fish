# {{{ Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
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
    rg --hidden -g '!.git/' $argv
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

function ncdu
    command ncdu --color dark $argv
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

function watch
  command watch -c $argv
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
function cat
    bat $argv
end

function find
    fd $argv
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

function vim
    nvim $argv
end
# }}}

function play
    mpv --hwdec=auto $argv
end

function splay
    mpv --no-audio $argv
end



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
function up
    for i in (seq 1 $argv)
      cd ..
    end
end
# }}}

# {{{ Key bindings
bind \cf '__fzf_search_current_dir'
bind \cr '__fzf_search_history'
bind \e\cv '__fzf_search_shell_variables'
bind \e\cl '__fzf_search_git_log'
bind \e\cs '__fzf_search_git_status'
# }}}

set fish_greeting ''

starship init fish | source
navi widget fish | source

eval (direnv hook fish)

# LS_COLOR
dir_colors=$HOME/Dropbox/src/dotfiles/external/dircolors-solarized/dircolors.256dark
if [ -f $dir_colors ]; then
  eval `TERM=xterm-256color dircolors -b $dir_colors`
fi

# Jump {{{
# autojump
# https://github.com/joelthelion/autojump
aj_version=21.4.6
if [ -s ${HOME}/Dropbox/src/autojump/${aj_version}/etc/autojump.zsh ] ; then
  path=(${HOME}/Dropbox/src/autojump/${aj_version}/bin ${path})
  fpath=(${HOME}/Dropbox/src/autojump/${aj_version}/func ${fpath})
  source ${HOME}/Dropbox/src/autojump/${aj_version}/etc/autojump.zsh
fi
export AUTOJUMP_IGNORE_CASE=1
# z
# https://github.com/rupa/z
#if [ -f $HOME/Dropbox/src/zsh/z/z.sh ]; then
  #_Z_CMD=j
  #source $HOME/Dropbox/src/zsh/z/z.sh
#fi
# }}}

# completion {{{
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
autoload -Uz compinit
compinit -d $HOME/.zcompdump

LISTMAX=10000

#setopt complete_aliases     #aliasを展開せずに補完
#setopt noautoremoveslash    #ディレクトリ補完時に末尾のスラッシュを削除しない
#setopt menu_complete        #
#unsetopt auto_list
setopt no_list_ambiguous
setopt list_packed          #補完候補を詰める
setopt magic_equal_subst    #--prefix=/usrなどで=の後でもパス補完

#sudoの後ろでもコマンド補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
			     /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
#小文字を入力した場合は大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#補完メニューを表示
zstyle ':completion:*:default' menu select

#補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

#マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

#キャッシュを利用
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path $HOME/.zcompcache

#プロセスの取得方法
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

#補完候補をLS_COLORに従って色付きにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

#パス補完を高速にする
#http://lethalman.blogspot.com/2009/10/speeding-up-zsh-completion.html
zstyle ':completion:*' accept-exact '*(N)'
# }}}
# history {{{
#HISTFILE=$HOME/.zsh_histfile
HISTFILE=$ZDOTDIR/HISTFILE
HISTSIZE=15000
SAVEHIST=10000

if [ $UID = 0 ]; then           # root のコマンドはヒストリに追加しない
    unset HISTFILE
    SAVEHIST=0
fi

setopt share_history            #複数の端末で履歴を共有
setopt hist_expire_dups_first   #重複コマンドを優先して削除
setopt hist_ignore_space        #先頭が空白の場合は記録しない
setopt hist_ignore_all_dups     #履歴全体で同じコマンドを重複して記録しない
setopt hist_ignore_dups         #直前と同じコマンドを重複して記録しない
setopt hist_save_no_dups        #重複コマンドを保存しない
setopt hist_allow_clobber       #noclobberでもリダイレクトできるようにする
setopt hist_verify              #!での履歴展開をすぐに実行しない
setopt inc_append_history       #ZSHの終了を待たずに履歴をファイルに書き出す

# 特定のコマンドを履歴に追加しない
# http://d.hatena.ne.jp/mollifier/20090728/p1
# zshaddhistoryが非0を返した場合は履歴に追加されない
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    # 以下の条件をすべて満たすものだけをヒストリに追加する
    [[ ${#line} -ge 5
        && ${cmd} != (l[sal]|lal)
        && ${cmd} != (cd)
        && ${cmd} != (rm)
        && ${cmd} != (j)
        && ${cmd} != (jc)
        && ${cmd} != (h)
        && ${line} != (kill -KILL *)
        #&& ${cmd} != (mv)
        #&& ${cmd} != (cp)
    ]]
}
# }}}
# prompt {{{
autoload -Uz colors         #%{$fg[red]%}%みたいに色を指定出来る
colors
setopt prompt_subst         #プロンプトにエスケープシーケンスを通す
setopt transient_rprompt     #コマンド実行時に右プロンプトを消す

case ${UID} in
  0)
  PROMPT="%{$fg_bold[green]%}%m%{$fg_bold[red]%}%#%{$reset_color%} "
  PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
  ;;
  *)
  PROMPT="[%{$fg[cyan]%}INS%{$reset_color%}]%{$fg_bold[white]%}%#%{$reset_color%} "
  PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
  ;;
esac

SPROMPT="%{$fg_bold[red]%}correct%{$reset_color%}: %R -> %r ? "

#viモードでプロンプトを切り替える
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    PROMPT="[%{$fg_bold[red]%}NOR%{$reset_color%}]%{$fg_bold[white]%}%%%{$reset_color%} "
    ;;
    main|viins)
    PROMPT="[%{$fg[cyan]%}INS%{$reset_color%}]%{$fg_bold[white]%}%%%{$reset_color%} "
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# cd移動で、ホームなら右プロンプトに時刻、それ以外はカレント
_change_rprompt() {
  if [ $PWD = $HOME ]; then
    RPROMPT="[%{$fg_bold[white]%}%T%{$reset_color%}]"
  elif [ ! -s $DISPLAY ]; then
    RPROMPT="[%{$fg[cyan]%}%60<..<%~%{$reset_color%}]"
  else
    RPROMPT="[%60<..<%~]"
  fi
}
_change_rprompt                     #起動時に一度実行
typeset -ga chpwd_functions
chpwd_functions+=_change_rprompt

_reset_prompt() {
  PROMPT="[%{$fg[cyan]%}INS%{$reset_color%}]%{$fg_bold[white]%}%#%{$reset_color%} "
}
typeset -ga precmd_functions
precmd_functions+=_reset_prompt

#case "${TERM}" in
#kterm*|xterm*|mlterm)
#  term_title() {
#    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#  }
#  typeset -ga precmd_functions
#  precmd_functions+=term_title
#  ;;
#esac
# }}}
# function {{{
#cdしたら、ファイル数が多いときに省略するls
#http://qiita.com/items/b10542db482c3ac8b059
ls_abbrev() {
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-AvCF' '--color=always' '--group-directories-first')
  if [ $PWD = $HOME ]; then
    opt_ls=('-vCF' '--color=always' '--group-directories-first')
  fi

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 14 ]; then
    echo "$ls_result" | head -n 7
    echo '...'
    echo "$ls_result" | tail -n 7
    echo "${fg_bold[red]}<<< $(command ls -1 -A | wc -l | tr -d ' ') files exist >>>${reset_color}"
  else
    echo "$ls_result"
  fi
}
typeset -ga chpwd_functions
chpwd_functions+=ls_abbrev

#Google検索
ggl() {
  local str opt
  if [ $# != 0 ]; then # 引数が存在すれば
    for i in $*; do
      str="$str+$i"
    done
    str=`echo $str | sed 's/^\+//'` # 先頭の「+」を削除
    #opt='search?num=50&hl=ja&lr=lang_ja'
    opt='search?num=50&hl=ja'
    opt="${opt}&q=${str}"
  fi
  w3m http://www.google.co.jp/$opt # 引数がなければ $opt は空
}

# alc で辞書引き
alc() {
  if [ $# != 0 ]; then
    w3m "http://eow.alc.co.jp/$*/UTF-8/?ref=sa"
  else
    echo 'usage: alc word'
  fi
}

h() {
  if [[ -f "$1" ]]; then
    case ${(L)1} in
      (*.tar|*.tbz2|*.tgz|*.tar.bz2|*.tar.gz) tar xvf $1 ;;
      (*.tar.xz)  tar Jxvf $1 ;;
      (*.bz2) bunzip2 $1 ;;
      (*.gz)  gunzip $1 ;;
      (*.jar) unzip $1 ;;
      (*.xpi) unzip $1 ;;
      (*.rar) unrar x $1 ;;
      (*.7z)  7z x $1 ;;
      (*.Z) uncompress $1 ;;
      (*.lzh) lha x $1 ;;
      (*.zip)
        case ${DISTRO} in
          ("Arch") unzip -O CP932 $1 ;;
          (*) unzip $1               ;;
        esac
      ;;
      (*.mp3) mplayer -demuxer lavf $1 ;;
      (*.ogg) mplayer -demuxer ogg $1 ;;
    esac
  else
    echo "File ('$1') does not exist!"
  fi
}
_h() {
  _files -g '*.(tar|tbz2|tgz|bz2|gz|xz|jar|xpi|rar|7z|Z|lzh|zip|mp3|ogg)(-.)' && return 0
  return 1
}
compdef _h h

# get flash video
flashvids() { lsof -p `ps x | awk '/libflashplayer.so\ /{print $1}'` -n 2>/dev/null | perl -lne '@F = split(/ +/, $_, 9); print "/proc/$F[1]/fd/${\($F[3] =~ /(^\d+)/)[0]}" if $F[4] eq "REG" && $F[8] =~ /\/tmp\/Flash.*\(deleted\)$/'; }

# UBUNTU
if [ -f /etc/zsh_command_not_found ]; then
  . /etc/zsh_command_not_found
fi

# zmv
autoload -Uz zmv

# }}}
# keybind {{{
#bindkey -e # Emacs
bindkey -v # Vi

#bindkey -a 'q' push-line
#bindkey -a 'q' push-input
bindkey -a 'H' run-help
#bindkey -a '^M' undefined-key #vicmdでのEnterを抑制

bindkey -v '^A' _expand_alias #aliasを展開
bindkey -v '^R' history-incremental-search-backward
bindkey -v '^Y' push-input #コマンドラインスタック

#メニュー選択移動をhjklで
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

#コマンドの履歴補完をCtrl-PとCtrl-Nで
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#単語を'や"で囲む
#http://d.hatena.ne.jp/mollifier/20091220/p1
#autoload -U modify-current-argument
## シングルクォート用
#_quote-previous-word-in-single() {
    #modify-current-argument '${(qq)${(Q)ARG}}'
    #zle vi-forward-blank-word
#}
#zle -N _quote-previous-word-in-single
#bindkey -a 's' _quote-previous-word-in-single
## ダブルクォート用
#_quote-previous-word-in-double() {
    #modify-current-argument '${(qqq)${(Q)ARG}}'
    #zle vi-forward-blank-word
#}
#zle -N _quote-previous-word-in-double
#bindkey -a 'S' _quote-previous-word-in-double

#Ctrl-^で上のディレクトリ
_cdup() {
  echo
  cd ..
  zle reset-prompt
}
zle -N _cdup
bindkey '^\^' _cdup

#こっちの方が使いやすい
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char
zle -A .kill-whole-line vi-kill-line
#zle -A .up-line-or-history vi-up-line-or-history
#zle -A .down-line-or-history vi-down-line-or-history

# viキーバインドでビジュアルモード
# http://zshscreenvimvimpwget.blog27.fc2.com/blog-entry-3.html
. "$ZDOTDIR/zsh_vim_visualmode"

# }}}
#############################################################
# PREDICT 先方予測
#autoload -U predict-on
#zle -N predict-on
#zle -N predict-off
#bindkey '^xp' predict-on
#bindkey '^x^p' predict-off
#############################################################
# misc options
#setopt auto_cd              #ディレクトリ名の入力で移動
setopt auto_pushd           #移動元のディレクトリを自動でスタック
setopt pushd_ignore_dups    #重複してるpushdを無視
setopt correct              #コマンドを修正
unsetopt beep               #ビープ音無効
unsetopt flow_control       #入出力制御を無効にする
setopt brace_ccl            #ブレース展開で{a-z}が可能になる
setopt extended_glob        #拡張グロブ
setopt print_exit_value     #エラー時終了ステータスを表示
#PATHなどから重複しているものを削除
typeset -U path cdpath fpath manpath
#プロセスの実行時間が3秒以上かかった場合は消費時間の統計情報を表示
REPORTTIME=3
#URLに含まれる特殊文字をエスケープする。コピペの時便利
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

. "$ZDOTDIR/aliases.zsh"

# vim: set ft=zsh foldmethod=marker:

alias ls='ls -vCF --color=auto --group-directories-first'
alias ll='ls -l --time-style=long-iso'
alias la='ls -A'
#alias lal='ls -l --time-style=long-iso -A'
alias lal='ll -A'

alias cp='nocorrect cp -i'
alias mv='nocorrect mv -i'
if type trash &>/dev/null; then
  alias rm='trash'
elif type trash-put &>/dev/null; then
  alias rm='trash-put'
else
  alias rm='nocorrect rm -i'
fi
alias mkdir='nocorrect mkdir'
alias touch='nocorrect touch'

alias locate='locate -i'
#alias lv='lv -c -l -T8192' 環境変数LVを設定すればいいのでコメントアウト
alias truecrypt='sudo truecrypt'
alias diff='colordiff'
alias grep='grep --color=auto --binary-files=without-match'
#alias sudo="GTK_IM_MODULE=xim sudo"
alias S=' sudo'
alias mpg123='mpg123 -a hw:0,0'
alias which='which -a'
alias df='df -h'
alias crontab='crontab -i'

# Git
alias g='git'
alias gst='git status'
alias ga='git add'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gp='git push'
alias gmv='git mv'


alias -g L='|& $PAGER'
alias -g G='|grep -i'
#クリップボードにコピー http://d.hatena.ne.jp/mollifier/20100317/p1
#alias -g C='|xsel --input --clipboard'
alias -g C='|xsel --input --primary'

case ${DISTRO} in
  "Ubuntu")
  alias search="apt-cache search"
  #alias unzip="LANG=ja_JP.UTF-8 unzip"
  alias dbst=' python $DROPBOX/src/bin/dropbox.py status'
  alias dpstop=" sudo service dboxd stop"
  alias dpstart=" sudo service dboxd start"
  ;;
  "Arch")
  alias man="LANG=C man"
  alias unzip="unzip -O CP932"
  alias dpstop=" sudo systemctl stop dropboxd.service"
  alias dpstart=" sudo systemctl start dropboxd.service"
  alias dbst=' python2 $DROPBOX/src/bin/dropbox.py status'
  ;;
esac

# vim: set ft=zsh:

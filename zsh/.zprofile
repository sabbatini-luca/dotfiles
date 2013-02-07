# Ubuntu, read this file by ~/.profile

if grep -q "Arch Linux" /etc/issue ; then
  #[ -f /etc/profile ] && . /etc/profile
  # Arch Linux, system zprofile is /etc/profile
  export DISTRO="Arch"
elif grep -q "Ubuntu" /etc/issue ; then
  export skip_global_compinit=1
  export DISTRO="Ubuntu"
  export DEBIAN_BUILDARCH=pentium4
fi

#if ! echo $PATH | /bin/grep -q "/usr/local" ; then
#    PATH="/usr/local/sbin:/usr/local/bin:$PATH"
#fi
#if ! echo $PATH | /bin/grep -q "$HOME/bin" ; then
#    PATH="$HOME/bin:$PATH"
#fi
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
if [ -d $HOME/bin ];then
  export PATH="$HOME/bin:$PATH"
fi

if which lv &>/dev/null; then
  #export PAGER="lv -c -l -T8192"
  export PAGER=lv
  export LV="-c -l -T8192"
else
  export PAGER=less
fi
export EDITOR=vim
export VTE_CJK_WIDTH=1


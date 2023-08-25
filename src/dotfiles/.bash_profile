# .bash_profile

# get the aliases and functions
if [ -f ~/.bashrc ] ; then
	. ~/.bashrc
fi

# user specific environment and startup programs
EDITOR=vim
GOPATH=$HOME/go
PATH=$PATH:/usr/sbin:/usr/local/bin:$GOPATH/bin:$HOME/bin
if [ -x '/usr/local/opt/go/libexec/bin' ] ; then
	PATH=$PATH:/usr/local/opt/go/libexec/bin
fi

RSYNC_RSH=ssh

HISTIGNORE="[	]*:&:bg:fg"
HISTSIZE=100000
HISTFILESIZE=100000

TERM=xterm-color

LSCOLORS=gxfxcxdxbxFgFdabagacad

CLASSPATH=

export CVS_RSH RSYNC_RSH \
	PS1 \
	HISTIGNORE HISTSIZE HISTFILESIZE \
	TERM \
	PATH GOPATH CLASSPATH \
	LSCOLORS EDITOR

umask 022

if [ "$PS1" ] ; then
 	stats
 	xtitle
fi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

[ -f  $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br

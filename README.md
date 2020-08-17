# dotfiles: easy shell environment + automated workstation setup

This dotfiles project is [Marco Olivo](https://olivo.net/)'s personal take on **automatic shell setup** and on **automated setup of a (brand new) personal computer/workstation**.

Being a perfectionist and being used to being highly productive with tools that I know, I grew very tired over the years of losing tens of minutes when not hours in setting up computers and shells on servers: these are very important yet very commodity things that one should take for granted, do once and then forget about.
Also, you may want to have a smooth way of propagating your changes and additions to already-existing servers and shells, without having to start from scratch and without having to incorporate your changes by hand (which leads to [configuration drift](https://dzone.com/articles/configuration-drift)).

I have searched here and there on the internet for the best recipe to setup, with just a couple of commands, an environment where I could feel at home no matter which server or PC I was using: I actually find none.

Well, not exactly true: I found lots of indications, guidelines and snippets that have led me in the direction of creating my personal repo which provides, out-of-the-box:

* an automated setup of a computer (be it Linux, Windows or Mac) with a set of custom tools that I personally tend to use
* a fully, battle-tested setup of a shell with a fancy yet simple prompt, nice colors and visuals, that can properly work under any terminal environment I've tested
* a very simple way of deploying all this to a new server and setting it up

**I don't pretend this setup works for you, as-is**: however, you can start from this repo and fork it to suit your needs, or you can follow the instructions below in order to add a few customizations that can better work for you.

Have fun!

## Repo structure

```.
├── setup <= scripts to setup a new workstation or shell
└── src <= folder where are stored files that are copied/symlinked on target systems
    ├── Library
    │   └── Preferences <= Mac Library/Preferences folder and subfolders
    ├── bin <= these files are copied to $HOME/bin folder
    └── dotfiles <= contains files starting with a dot (.), typical of a shell
```

The repo is made in a way so that the majority of configuration files is kept in the repo and therefore, when adding something new to your main branch, you can just run a `git pull` command in your target shell in order to incorporate the changes.

This is very useful in day-by-day operations, for instance when you find a new shell plugin and you want to add it to all your shells: by committing it to your source git repo, it's easy to propagate that on any given server.

## Setup repo on a new server

On a server you are given access to, the main thing to do is to `git clone` this repo in the `$HOME/dotfiles` folder.

After doing this operation, just run:

`./setup/setup-user.sh`

from the `dotfiles` folder, and in a few seconds you will have a fully-working, fully-featured shell based on [zsh](https://www.zsh.org/), [oh-my-zsh](https://ohmyz.sh/) and several cool plugins.

The main theme used in oh-my-zsh is [powerlevel10k](https://github.com/romkatv/powerlevel10k) which has been customized in order to offer a lean, simple and beautiful prompt.

## Setting up a new workstation

Sometimes, or maybe often, you want to setup a server or a workstation and would like to "feel at home" as soon as possible.

In my experience, this is true both on workstation machines (typically based on Mac or Windows) and on servers, typically based on Linux distributions.

For this reason, the following scripts are provided:

* [setup-linux.sh](/setup/setup-linux.sh), which setups the server with a series of useful tools I tend to use in my day-by-day
* [setup-mac.sh](/setup/setup-mac.sh), which installs several tools and programs on a Mac, and makes several configurations I use
* [setup-windows.bat](/setup/setup-windows.bat), a bat script that installs several utilities on Windows

## Add your own customization

You tipically would like to make two different customizations starting from the current repo:

1) adding more tools when installing a workstation/server or setting up a new shell
2) changing the configuration of your shell or commands

For case 1, you may want to modify the setup scripts provided in the repo and add more commands to them: easy peasy.

For case 2 instead, things could be more complicated: you may want to add more [dotfiles](/src/dotfiles) files, modify them, or maybe change the configurations in the [.ssh](/src/.ssh) folder provided.

These two steps are the steps I have made several times and I tend to repeat them over time when finding a new utility or reading about a new fantastic command that does wonders and that I totally want on my shells.

**IMPORTANT NOTE: if you think your tools or configurations are very useful and could be beneficial to multiple people, please open a pull request so that I can evaluate to incorporate them in the main branch.**

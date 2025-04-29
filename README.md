# Bind sessions to hotkeys

A simple plugin to bind sessions to keys.

## Dependencies

- tmuxinator

## Install

Add this to your .tmux.conf and run Ctrl-I for TPM to install the plugin.

set -g @plugin 'Marat-Gumerov/tmux-session-binder'

## Usage

Add keybindings to your tmuxinator configs:
```yml
# bind: s
name: session-name
root: ~/session/folder
# ...
```

Start plugin using the Alt+d hotkey, then press the binding key, it will start session from tmuxinator or switch to it.

## Configure

Everything is hardcoded, no configuration is supported now. Feel free to post issues, open PRs, etc.

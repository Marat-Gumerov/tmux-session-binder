# session-binder.tmux

# Set the path to your tmuxinator configuration directory
tmux_inator_dir="$HOME/.config/tmuxinator"

# Set the hotkey to trigger the session binder (you can change this)
bind-key -n F1 run-shell -b "bash -c '
  TMUX_INATOR_DIR=\"$tmux_inator_dir\"
  source \"$HOME/.tmux/plugins/tmux-session-binder/scripts/binder.sh\"
  start_session_binder
'"

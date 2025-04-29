#!/bin/bash

# Default tmuxinator directory (can be overridden by TMUX_INATOR_DIR environment variable)
tmuxinator_dir="$HOME/.config/tmuxinator"

# Function to find bindings in tmuxinator files
find_bindings() {
  local bindings=()
  find "$tmuxinator_dir" -name "*.yml" -o -name "*.yaml" -print0 | while IFS= read -r -d $'\0' file; do
    if key=$(grep -oP '# bind: \K\S+' "$file"); then
      project_name=$(basename "$file" .yml | sed 's/\.yaml$//')
      bindings["$key"]="$project_name"
    fi
  done
  echo "${bindings[@]}" # Output the array (though we'll access it directly later)
  declare -g SESSION_BINDINGS
  SESSION_BINDINGS=("${!bindings[@]}") # Store keys globally
  declare -g PROJECT_MAP
  PROJECT_MAP=("${bindings[@]}")    # Store values globally (order matters, corresponds to keys)
}

# Function to handle the key input and session management
handle_key_input() {
  local pressed_key="$1"

  local -n keys=SESSION_BINDINGS
  local -n projects=PROJECT_MAP

  local found=false
  for i in "${!keys[@]}"; do
    if [[ "$pressed_key" == "${keys[$i]}" ]]; then
      local session_name="${projects[$i]}"
      if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux switch-client -t "$session_name"
        tmux display-message "Switched to session: $session_name"
      else
        tmuxinator start "$session_name"
        tmux display-message "Started session: $session_name"
      fi
      found=true
      break
    fi
  done

  if ! "$found"; then
    tmux display-message "No tmuxinator project bound to key '$pressed_key'."
  fi
}

# Main function to start the session binder process
start_session_binder() {
  find_bindings

  tmux display-popup -w 30 -h 3 -x C -y C "Enter session key: " \
    "bind-key -T popup Return run-shell -b '
      pressed_key=\"$(tmux capture-pane -ept '%' -J)\";
      source \"$HOME/.tmux/plugins/session-binder.sh\";
      handle_key_input \"\$pressed_key\";
      tmux kill-window -t %1
    '"
}

start_session_binder

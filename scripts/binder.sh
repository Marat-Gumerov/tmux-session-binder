#!/usr/bin/bash

# Default tmuxinator directory (can be overridden by TMUX_INATOR_DIR environment variable)
tmuxinator_dir="$HOME/.config/tmuxinator/"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


declare -A BINDINGS
# Function to find bindings in tmuxinator files
find_bindings() {
  declare -A bb=([x]="aw")
  local files
  readarray -d $'\0' files < <(find $tmuxinator_dir -name "*.yml" -print0)
  for file in "${files[@]}"; do 
    if key=$(grep -oP '# bind: \K\S+' "$file"); then
      project_name=$(basename "$file" .yml | sed 's/\.yaml$//')
      BINDINGS["$key"]="$project_name"
      bb[$key]="$project_name"
      echo "Binded $key to $project_name"
    fi
  done
  echo "Bindings: ${!BINDINGS[@]}"
}

# Function to handle the key input and session management
handle_key_input() {
  local pressed_key="$1"
  echo "Pressed key is '$pressed_key'"
  echo "Bindings: ${!BINDINGS[@]}"

  local session_name="${BINDINGS[$pressed_key]}"
  echo "Session name is $session_name"
  if [[ -z "$session_name" ]]; then
    tmux display-message "No tmuxinator project bound to key '$pressed_key'."
  elif tmux has-session -t "$session_name" 2>/dev/null; then
    tmux switch-client -t "$session_name"
    tmux display-message "Switched to session: $session_name"
  else
    tmuxinator start "$session_name"
    tmux display-message "Started session: $session_name"
  fi
}

# Main function to start the session binder process
start_session_binder() {
  RESULT=$(tmux command-prompt -1 -p "Press session binding: " "run-shell \"echo '%%'\"")
  handle_key_input "$RESULT"
}

find_bindings
start_session_binder

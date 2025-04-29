#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux bind-key -n M-d run-shell "$CURRENT_DIR/scripts/binder.sh"

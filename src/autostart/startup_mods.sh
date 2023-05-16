#!/bin/bash

# This script checks if there are any .sh scripts in root.d directory, and if there are, it executes them with root privileges using pkexec.
# Then, it runs the user scripts in amnesia.d directory.

autostart_dir="/home/amnesia/.config/autostart"

# Enable nullglob to treat non-matching globs as null strings, not literal strings, to ensure empty array if no matching file.
shopt -s nullglob

# Check if root.d contains any *.sh files
root_scripts=("${autostart_dir}/root.d/"*.sh)
if [ -e "${root_scripts[0]}" ]; then
  # Run root scripts
  pkexec bash -x "${autostart_dir}/run_dir_scripts.sh" root
fi

# Run non-root scripts
bash -x "${autostart_dir}/run_dir_scripts.sh" amnesia
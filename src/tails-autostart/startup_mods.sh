#!/bin/bash

# This script checks if there are any .sh scripts in root.d directory, and if there are, it executes them with root privileges using pkexec.
# Then, it runs the user scripts in amnesia.d directory.

persistence_dir=/live/persistence/TailsData_unlocked
install_dir=${persistence_dir}/tails-autostart

# Check if root.d contains any *.sh files
root_scripts=(/home/amnesia/.config/autostart/root.d/*.sh)
if [ -e "${root_scripts[0]}" ]; then
  # Run root scripts
  pkexec bash -x "${install_dir}/run_dir_scripts.sh" root
fi

# Run non-root scripts
bash -x "${install_dir}/run_dir_scripts.sh" amnesia
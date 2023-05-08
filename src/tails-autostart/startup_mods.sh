#!/bin/bash

persistence_dir=/live/persistence/TailsData_unlocked
install_dir=${persistence_dir}/tails-autostart
persistence_dir=/live/persistence/TailsData_unlocked

# Run root changes if root.d contains any *.sh files
if ls ${HOME}/.config/autostart/root.d/*.sh 1> /dev/null 2>&1
then
  pkexec bash -x ${install_dir}/run_dir_scripts.sh root
fi
# Run non-root changes
bash -x ${install_dir}/run_dir_scripts.sh amnesia

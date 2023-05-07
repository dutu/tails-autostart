#!/bin/bash

# Run root changes if root.d contains any *.sh files
if ls ${HOME}/.config/autostart/root.d/*.sh 1> /dev/null 2>&1
then
  pkexec bash -x ${HOME}/.config/autostart/run_dir_scripts.sh root
fi
# Run non-root changes
bash -x ${HOME}/.config/autostart/run_dir_scripts.sh amnesia

#!/bin/bash

# Run root changes
pkexec bash -x ${HOME}/.config/autostart/run_dir_scripts.sh root
# Run non-root changes
bash -x ${HOME}/.config/autostart/run_dir_scripts.sh amnesia

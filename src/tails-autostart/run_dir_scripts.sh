#!/bin/bash

# This script is used to execute all .sh files present in a user-specific
# directory under home/amnesia/.config/autostart/. The user's name is passed as a parameter.

user=$1  # User's name is passed as the first argument to the script.

# Enable nullglob to treat non-matching globs as null strings, not literal strings, to ensure empty array if no matching file.
shopt -s nullglob

# Iterate over all .sh files in the user's directory.
for file in /home/amnesia/.config/autostart/"${user}".d/*.sh
do
    if [[ -x "$file" ]]; then
        # If the file is executable, Log the execution and execute the file
        logger "Executing ${file}..."
        ./"${file}"
    else
        # If the file is not executable, display an error dialog.
        zenity --error --text="The file ${file} is not executable" --title="Tails-autostart"
    fi
done

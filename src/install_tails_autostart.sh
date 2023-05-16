#!/bin/bash

# This script is used to install the Tails-autostart utility.
# It copies necessary files to their respective directories, and sets the appropriate permissions.

persistence_dir="/live/persistence/TailsData_unlocked"
autostart_dir="${persistence_dir}/dotfiles/.config/autostart"

# Get the directory where the current script resides
src_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Check if ${autostart_dir} contains any files and delete them if it does
mkdir -p "${autostart_dir}"
files=$(find "$autostart_dir" -maxdepth 1 -type f)
if [ -n "$files" ] || [ -e "$autostart_dir/tails-autostart" ]; then
  echo "Files found in installation directory '${autostart_dir}'. Deleting them..."
  rm -f "$files"
  rm -f "$autostart_dir/tails-autostart" 2>/dev/null
fi

echo "Copying files to autostart directory '${autostart_dir}'..."
cp -af "${src_dir}/autostart/". "${autostart_dir}/"
chmod +x "${autostart_dir}/tails-autostart/startup_mods.sh"
chmod +x "${autostart_dir}/tails-autostart/run_dir_scripts.sh"

# Retrieve version from version-*.txt file in ${autostart_dir}/
version_file=$(find "${autostart_dir}/tails-autostart/" -maxdepth 1 -type f -name "version-*.txt" | head -n 1)
version=$(echo "${version_file}" | grep -oP 'version-\K.*(?=\.txt)')

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

echo -e "\n${green}Installed tails-autostart ${version}.${reset}
If you want any scripts to run at startup as root, put them in:
${green}${autostart_dir}/root.d${reset}
If you want any scripts to run at startup as amnesia, put them in:
${green}${autostart_dir}/amnesia.d${reset}"

# Check for *.sh files in ${autostart_dir}/root.d/ and ${autostart_dir}/amnesia.d/
root_files=$(find "${autostart_dir}/root.d/" -maxdepth 1 -type f -name "*.sh")
amnesia_files=$(find "${autostart_dir}/amnesia.d/" -maxdepth 1 -type f -name "*.sh")

if [ -n "$root_files" ] || [ -n "$amnesia_files" ]; then
  echo -e "\n${red}Warning: The following scripts were detected, which will be executed at the next Tails startup. Please review these scripts before restarting Tails:${reset}"
  echo "${red}$root_files${reset}"
  echo "${red}$amnesia_files${reset}"
fi

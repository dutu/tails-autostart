#!/bin/bash

# This script is used to install the Tails-autostart utility.
# It copies necessary files to their respective directories, and sets the appropriate permissions.
# It must be run with root privileges.

persistence_dir="/live/persistence/TailsData_unlocked"
autostart_dir="${persistence_dir}/dotfiles/.config/autostart"
install_dir="${persistence_dir}/tails-autostart"

# Check if Tails has been started with an administration password
if ! sudo -n true 2>/dev/null; then
    echo "Tails must be started with an administration password to run this script."
    exit 1
fi

# Check if the script has been executed as root
if test "$(whoami)" != "root"
then
    echo "You must run this program as root."
    exit 1
fi

echo "Copying files to autostart directory '${autostart_dir}'..."
mkdir -p "${autostart_dir}"
cp -af autostart/. "${autostart_dir}/"

# Check if ${install_dir} contains any files and delete them if it does
if [ "$(ls -A "${install_dir}" 2>/dev/null)" ]
then
  echo "Files found in installation directory '${install_dir}'. Deleting them..."
  rm -rf "${install_dir:?}"/*
fi

echo "Copying files to installation directory '${install_dir}'..."
mkdir -p "${install_dir}"
cp -af tails-autostart/. "${install_dir}/"
cp -af version-* "${install_dir}/"
chmod +x "${install_dir}/startup_mods.sh"
chmod +x "${install_dir}/run_dir_scripts.sh"

version_file=$(find "." -maxdepth 1 -type f -name "*.txt" | head -n 1)
version=$(echo "${version_file}" | grep -oP 'version-\K.*(?=\.txt)')

echo "-----------------"
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
echo "Installed tails-autostart ${version}.
If you want any scripts to run at startup as root, put them in:
${red}${autostart_dir}/root.d${reset}
If you want any script to run at startup as amnesia, put them in:
${red}${autostart_dir}/amnesia.d${reset}"

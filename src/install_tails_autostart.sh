#!/bin/bash

persistence_dir=/live/persistence/TailsData_unlocked
autostart_dir=${persistence_dir}/dotfiles/.config/autostart
install_dir=${persistence_dir}/tails-autostart

if test "$(whoami)" != "root"
then
    echo "You must run this program as root."
    exit 1
fi

echo "Copying files to autostart directory '${autostart_dir}'..."
mkdir -p ${autostart_dir}
rsync -a autostart/ ${autostart_dir}/ > /dev/null

# Check if ${install_dir} contains any files and delete them if it does
if [ "$(ls -A "${install_dir}" 2>/dev/null)" ]
then
  echo "Files found in installation directory '${install_dir}'. Deleting them..."
  rm -rf "${install_dir}"
fi

echo "Copying files to installation directory '${install_dir}'..."
mkdir -p ${install_dir}
rsync -a tails-autostart/ ${install_dir}/ > /dev/null
rsync -a version-* ${install_dir}/ > /dev/null
chmod +x ${install_dir}/startup_mods.sh
chmod +x ${install_dir}/run_dir_scripts.sh

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

#!/bin/bash

persistence_dir=/live/persistence/TailsData_unlocked
persistence_conf=${persistence_dir}/persistence.conf
autostart_dir=${persistence_dir}/dotfiles/.config/autostart
local_autostart_dir=/home/amnesia/.config/autostart
install_dir=/live/persistence/TailsData_unlocked/tails-autostart

# 0. Make sure we are running as root
if test "$(whoami)" != "root"
then
    echo "You must run this program as root."
    exit 1
fi

echo "Moving files to autostart directory '${autostart_dir}'..."
mv -fT autostart ${autostart_dir}/

# Check if ${install_dir} contains any files and delete them if it does
if [ "$(ls -A "${install_dir}")" ]
then
  echo "Files found in installation directory '${install_dir}'. Deleting them..."
  rm "${install_dir}/*"
fi

echo "Moving files to installation directory '${install_dir}'..."
mv -fT tails-autostart ${install_dir}/
mv version-* ${install_dir}/
chmod +x ${install_dir}/startup_mods.sh
chmod +x ${install_dir}/run_dir_scripts.sh

version_file=$(find "." -maxdepth 1 -type f -name "*.txt" | head -n 1)
version=$(echo "${version_file}" | grep -oP 'version-\K[^.]+')

echo "-----------------"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo "Installed tails-autostart ${version}.
If you want any scripts to run at startup as root, put them in:
${red}${local_autostart_dir}/root.d${reset}
If you want any script to run at startup as amnesia, put them in:
${red}${local_autostart_dir}/amnesia.d${reset}"

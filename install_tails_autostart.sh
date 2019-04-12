#!/bin/bash
persistence_dir=/live/persistence/TailsData_unlocked
persistence_conf=${persistence_dir}/persistence.conf
autostart_dir=${persistence_dir}/dotfiles/.config/autostart
local_autostart_dir=/home/amnesia/.config/autostart

# 0. Make sure we are running as root
if test "$(whoami)" != "root"
then
    echo "You must run this program as root."
    exit 1
fi

# 1. Make sure dotfiles are turned on in the persistence conf
grep "source=dotfiles,link" "${persistence_conf}" > /dev/null 2>&1
if test $? -ne 0
then
  # ... dotfiles are not turned on, so... let's turn them on!
  echo "Adding dotfiles to persistence.conf..."
  echo "/home/amnesia   source=dotfiles,link" >> "${persistence_conf}"
  echo "Making ${persistence_dir}/dotfiles directory..."
  mkdir -p "${persistence_dir}/dotfiles"
fi

# 2. Create file: ${autostart_dir}/Startup.desktop
#    - This will execute a script or scripts on startup (as amnesia)
if ! test -d "${autostart_dir}"
then
  echo "Making ${autostart_dir} directory..."
  mkdir -p "${autostart_dir}"
fi

if ! test -f "${autostart_dir}/Startup.desktop"
then
  echo "Making ${autostart_dir}/Startup.desktop..."
  cat > "${autostart_dir}/Startup.desktop" << EOF
[Desktop Entry]
Name=TailsStartup
GenericName=Tails Startup Script
Comment=Run startup things when tails starts
Exec=bash ${local_autostart_dir}/startup_mods.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF
fi

# 3. Create file: ${autostart_dir}/startup_mods.sh
#    - This is needed to give root permissions to root shell scripts
if ! test -f "${autostart_dir}/startup_mods.sh"
then
  echo "Making ${autostart_dir}/startup_mods.sh..."
  cat > "${autostart_dir}/startup_mods.sh" << EOF
#!/bin/bash

# Run root changes
pkexec bash \${HOME}/.config/autostart/run_dir_scripts.sh root
# Run non-root changes
bash \${HOME}/.config/autostart/run_dir_scripts.sh amnesia
EOF
fi

# 4. Create file: ${autostart_dir}/run_dir_scripts.sh
#    - This is used to run all scripts in a given subdirectory
if ! test -f "${autostart_dir}/run_dir_scripts.sh"
then
  echo "Making ${autostart_dir}/run_dir_scripts.sh..."
  cat > "${autostart_dir}/run_dir_scripts.sh" << EOF
#!/bin/bash
SCRIPT_DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

user=\$1
for file in \$(ls \$SCRIPT_DIR/\${user}.d/*.sh)
do
  bash \$file
done

EOF
fi


# 5. Change owner of the dotfiles directory to amnesia
echo "Making amnesia the owner of ${persistence_dir}/dotfiles..."
chown -R amnesia:amnesia "${persistence_dir}/dotfiles"

echo "-----------------"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo "Installed.
If you want any scripts to run at startup as root, put them in:
${red}${local_autostart_dir}/root.d${reset}
If you want any script to run at startup as amnesia, put them in:
${red}${local_autostart_dir}/amnesia.d${reset}"

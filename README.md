# Tails Autostart

## What is it?

Automatically start scripts/applications on tails bootup

## Why make this?

There could be a need for several scripts to run each time Tails boots up, so this is a mechanism for doing so.

## How do I use it?

1. Make sure you have dotfiles feature turned on in your persistence configuration.
2. Clone this repository and move files to autostart
    ```shell
    cd ~/Downloads
    mkdir -p /live/persistence/TailsData_unlocked/dotfiles/.config/autostart
    torify git clone https://github.com/dutu/tails-autostart.git /live/persistence/TailsData_unlocked/dotfiles/.config/autostart
    ```

Done. Now: 

* add any scripts to `/live/persistence/TailsData_unlocked/dotfiles/.config/autostart/amnesia.d` to execute on startup them as amnesia;
* add any scripts to `/live/persistence/TailsData_unlocked/dotfiles/.config/autostart/root.d` to execute them on startup as root.

## How does it work?
`run_dir_scripts.sh` runs all the scripts ending in `.sh` in a particular directory. This way, we use the same script to run `amnesia.d` scripts and `root.d` scripts.

`startup_mods.sh` runs `run_dir_scripts.sh` for each user (root and amnesia). running as root is done using `pkexec` (gui for sudo prompt).

Finally, using Gnome's autostart feature, `Startup.desktop` is run each time Gnome starts up. This `Startup.desktop` runs `bash /home/amnesia/.config/autostart/startup_mods.sh`

So on startup, gnome runs:

```mermaid
graph LR;
  A(Startup.desktop)-->B(startup_mods.sh);
  B(startup_mods.sh)-->C(pkexec run_dir_scripts.sh);
  B(startup_mods.sh)-->D(run_dir_scripts.sh);
  C(pkexec run_dir_scripts.sh)-->E(root.d/*.sh);
  D(run_dir_scripts.sh)-->F(amnesia/*.sh);
```

> Note: `startup_mods.sh` now checks for `.sh` script files in `.config/autostart/root.d`. If no files are found, `pkexec` is not executed. This is to avoid unnecessary prompt to enter admin password after Gnome starts up.     

## Changelog

2023-01-25
* clone repository from https://gitlab.com/tstone2077/tails-autostart
* update installation instruction to work with Tails 5.9
* update `startup_mods.sh` to run `pkexec` only when there are scripts in `.config/autostart/root.d`

#!/bin/bash

user=$1
for file in "${HOME}"/.config/autostart/"${user}".d/*.sh
do
  [[ -e "$file" ]] || break  # handle the case of no files
  bash "${file}"
done


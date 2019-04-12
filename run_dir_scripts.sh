#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

user=$1
for file in $(ls $SCRIPT_DIR/${user}.d/*.sh)
do
  bash $file
done


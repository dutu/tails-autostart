#!/bin/bash
sed -i -e 's/timestamp_timeout=0/timestamp_timeout=2/' /etc/sudoers.d/always-ask-password

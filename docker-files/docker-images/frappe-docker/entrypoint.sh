#!/bin/bash
#set -x
emer() {
   echo "$1"
   exit 1
}

[[ "${USERID:-}" ]] || emer "[ERROR] Please provide USERID environment variable."
[[ "${USERGROUP:-}" ]] || emer "[ERROR] Please provide USERGROUP environment variable."

echo "Setting up user"

NAME='frappe'
groupadd -g "$USERGROUP" $NAME
useradd --no-log-init -r -m -u "$USERID" -g "$USERGROUP" -G sudo -s /usr/bin/zsh "$NAME"
usermod -a -G tty "$NAME"
echo "$NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

chown -R "$USERID":"$USERGROUP" /opt
cat /opt/user/.zshrc >> /home/$NAME/.zshrc
cat /opt/user/.profile >> /home/$NAME/.profile
chown -R "$USERID":"$USERGROUP" /workspace

gosu "${USERID}":"${USERGROUP}" /user-script.sh

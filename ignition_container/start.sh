#!/bin/bash

# this file is executed when starting the container

FILENAME=~/run-`cat /proc/sys/kernel/random/uuid`.sh
REALDIR=$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)
VERSION=1.1.26
FIRST_ARGUMENT="$1"

cat << EOT > $FILENAME
#!/bin/bash

export LANG=en_US.UTF-8

APP_DIR=/visionclientlauncher /visionclientlauncher/runtime/bin/java -jar /visionclientlauncher/app/launcher-vision-client-linux.jar config.json=/vision-client-launcher.json

kill \$PPID #make the window manager exit
EOT

chmod +x $FILENAME

# run window manager
/usr/bin/openbox --startup $FILENAME

rm -f $FILENAME


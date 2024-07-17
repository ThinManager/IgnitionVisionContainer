#!/bin/bash

# this file is executed when starting the container

FILENAME=~/run-`cat /proc/sys/kernel/random/uuid`.sh

cat << EOT > $FILENAME
#!/bin/bash

export LANG=en_US.UTF-8

lxterminal

kill \$PPID #make the window manager exit
EOT

chmod +x $FILENAME

# run window manager
/usr/bin/openbox --startup $FILENAME

rm -f $FILENAME


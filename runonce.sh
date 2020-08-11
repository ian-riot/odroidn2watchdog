#!/bin/bash

# Cleanup
sudo apt-get remove watchdog

#install the watchdog
sudo apt-get install watchdog

# create a log file area
sudo mkdir -p /var/log/watchdog

# edit the main watchdog file
sudo rm /etc/default/watchdog
sudo touch /etc/default/watchdog
sudo cat > /etc/default/watchdog <<- "EOF"
# Start watchdog at boot time? 0 or 1
run_watchdog=1
# Start wd_keepalive after stopping watchdog? 0 or 1
run_wd_keepalive=1
# Load module before starting watchdog
watchdog_module=gxbb_wdt
# Specify additional watchdog options here (see manpage).
watchdog_options="-s -v -c /etc/watchdog.conf"
EOF


# edit the main watchdog conf file
sudo rm /etc/watchdog.conf
sudo touch /etc/watchdog.conf
sudo cat > /etc/watchdog.conf <<- "EOF"
#ping                   = 172.31.14.1
#ping                   = 172.26.1.255
#interface              = eth0
#file                   = /var/log/messages
#change                 = 1407
 
# Uncomment to enable test. Setting one of these values to '0' disables it.
# These values will hopefully never reboot your machine during normal use
# (if your machine is really hung, the loadavg will go much higher than 25)
#max-load-1             = 24
#max-load-5             = 18
#max-load-15            = 12
 
# Note that this is the number of pages!
# To get the real size, check how large the pagesize is on your machine.
#min-memory             = 1
 
#repair-binary          = /usr/sbin/repair
#repair-timeout         =
#test-binary            =
#test-timeout           =
 
watchdog-device = /dev/watchdog
 
# Defaults compiled into the binary
#temperature-device     =
#max-temperature        = 120
 
# Defaults compiled into the binary
admin                   = root
interval                = 1
logtick                = 1
log-dir         = /var/log/watchdog
 
# This greatly decreases the chance that watchdog won't be scheduled before
# your machine is really loaded
realtime                = yes
priority                = 1
 
# Check if rsyslogd is still running by enabling the following line
pidfile         = /var/run/rsyslogd.pid
 
watchdog-timeout        = 15
EOF

sudo ln -s  /lib/systemd/system/watchdog.service /etc/systemd/system/multi-user.target.wants/watchdog.service
sudo systemctl enable watchdog.service
sudo systemctl start watchdog.service


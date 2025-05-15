#!/bin/bash

LOG_FILE="/var/log/nginx_monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
EMAIL="ramtinboreili7@gmail.com"  

[ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"

if systemctl is-active --quiet nginx; then
    echo "$DATE - Nginx is running." >> "$LOG_FILE"
else
    echo "$DATE - Nginx is DOWN. Restarting..." >> "$LOG_FILE"
    RESTART_OUTPUT=$(systemctl restart nginx 2>&1)
    echo "$DATE - Restart output: $RESTART_OUTPUT" >> "$LOG_FILE"

    if systemctl is-active --quiet nginx; then
        echo "$DATE - Restart successful." >> "$LOG_FILE"
    else
        echo "$DATE - Restart FAILED!" >> "$LOG_FILE"
        echo -e "Subject: Nginx Restart Failed\n\nNginx restart failed on server at $DATE.\n\nLog:\n$RESTART_OUTPUT" | sendmail "$EMAIL"
    fi
fi

#!/bin/bash

# تنظیمات
SERVICE_NAME="nginx"  # نام سرویس موردنظر (nginx, mysql, docker, ...)
EMAIL="ramtin.bor7hp@gmail.com"  # ایمیل برای دریافت هشدار
BOT_TOKEN="123456789:ABCDEF-YourBotToken"  # توکن بات تلگرام
CHAT_ID="12345678"  # چت آیدی تلگرام

# بررسی وضعیت سرویس
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is running."
else
    MESSAGE="⚠️ هشدار: سرویس $SERVICE_NAME متوقف شده است!"
    echo "$MESSAGE"

    # ارسال ایمیل نوتیفیکیشن
    echo "$MESSAGE" | mail -s "Service Alert: $SERVICE_NAME Down" "$EMAIL"

    # ارسال پیام تلگرام
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" -d text="$MESSAGE"
    
    # تلاش برای استارت مجدد سرویس
    systemctl restart "$SERVICE_NAME"
fi

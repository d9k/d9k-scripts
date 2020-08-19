#!/bin/bash

APP_PATTERN="Slack"
APP=/snap/bin/slack

if [ ! -f ${APP} ]; then
  APP=/usr/bin/slack
fi

t=$(wmctrl -lp | grep ${APP_PATTERN})
if [ $? -eq 1 ]; then
    $APP &
else
    wmctrl -a ${APP_PATTERN}
fi

#!/bin/bash

APP_PATTERN="Slack"
APP=/$HOME/scripts/slack-fix-suspend

t=$(wmctrl -lp | grep ${APP_PATTERN})
if [ $? -eq 1 ]; then
    $APP &
else
    wmctrl -a ${APP_PATTERN}
fi

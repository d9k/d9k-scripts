#!/bin/bash
gsettings set org.cinnamon.settings-daemon.plugins.power lock-on-suspend true
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-type 'hibernate'
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-battery-type 'hibernate'
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-timeout 5400
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
gsettings set org.cinnamon.settings-daemon.plugins.power critical-battery-action 'hibernate'
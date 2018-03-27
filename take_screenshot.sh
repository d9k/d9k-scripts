#!/bin/bash
scrot --focused '%Y_%m_%d__%H_%M_%S__$wx$h.png' -e 'mv $f ~/screenshots/'

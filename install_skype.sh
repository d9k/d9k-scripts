#!/bin/bash
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get install skype && sudo apt-get -f install
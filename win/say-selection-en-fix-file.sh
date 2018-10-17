#!/bin/bash

# "исправление" файла для озвучивания festival

# sed -i -e 's| ,|,|g' $1

sed -i -e "s|’|'|g" $1

sed -i -e 's|—| — |g' $1

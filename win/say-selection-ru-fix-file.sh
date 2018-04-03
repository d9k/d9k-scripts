#!/bin/bash

# "исправление" файла для озвучивания пакетом festvox-ru

sed -i -e 's| ,|,|g' $1
sed -i -e 's|,|, |g' $1
sed -i -e 's| \.|.|g' $1
sed -i -e 's|…|...|g' $1
sed -i -e 's|\.|. |g' $1
sed -i -e 's|:|: |g' $1
sed -i -e 's|\. \. \.|...|g' $1
sed -i -e 's|–|-|g' $1 # another utf-8 code
sed -i -e 's|—|--|g' $1 # another utf-8 code
#sed -i -e 's|—|-- |g' $1
sed -i -e 's|„|"|g' $1
sed -i -e 's|“|"|g' $1
sed -i -e 's|?|? |g' $1
sed -i -e 's|!|! |g' $1
#sed -i -e 's|\[| [ |g' $1
#sed -i -e 's|\]| ] |g' $1

# temporarily, till problems with creating rules for square brackets fixed
sed -i -e 's|\[| ( |g' $1
sed -i -e 's|\]| )|g' $1

# fix и т. д., -> и т.  д. , => error
sed -i -e 's|\. , |., |g' $1

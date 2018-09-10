#!/bin/sh

wget -O - www.reddit.com/r/EarthPorn > file
#1 Get all the post links from the subreddit r/wallpaper
grep -Po '(?<=href="https://www.reddit.com/r/EarthPorn/comments/)[^"]*' file > links
#2 Fix the links
sed -i -e 's~^~www.reddit.com/r/EarthPorn/comments/~' links
#3 Count the # of posts there are
POST_NUMBER="$(wc -l < links)"
#4 Choose a random number to pick which wallpaper we're going to use
NUMBER=$(shuf -i 1-$POST_NUMBER -n 1)
LINK=$(sed -n ${NUMBER}p < links)
wget -O - "${LINK}" > picture
#5 Get the picture link and save it
PICTURE_LINK=$(grep -m1 -Po '(?<=https://i.redd.it/)[^"]*' picture)
echo $PICTURE_LINK > picturelink
sed -i -e 's~^~i.redd.it/~' picturelink
wget -i picturelink -O wallpaper.jpg
#6 Resize the image to the desktop size and set it as background
#convert -crop 1920X1080 wallpaper.jpg wallpaper.jpg
gsettings set org.gnome.desktop.background picture-uri file://$(pwd)/wallpaper.jpg



#cleanup
rm file links picture picturelink

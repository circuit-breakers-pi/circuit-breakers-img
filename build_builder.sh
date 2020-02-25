#!bin/bash
touch ./main-es2015.js
sudo cat ./build_deel1 > main-es2015.js

echo "Wat is het ip adres van de server?"
read ip

echo "const baselink = 'http://$ip/api/';" > main-es2015.js

sudo cat ./build_deel2 > main-es2015.js

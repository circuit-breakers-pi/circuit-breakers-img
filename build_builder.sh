#!bin/bash
touch ./main-es2015.js
sudo cat ./build_begin_const> main-es2015.js

echo "Wat is het ip adres van de server?"
read ip

echo "      this.iframe = 'http://$ip:3000/d/76B5JFZRz/vinificatie?orgId=1&refresh=5m&from=now-7d&to=now&theme=light&kiosk=tv&var-vat=' + this.id;" >> main-es2015.js

sudo echo cat ./build_baseline_iframe >> main-es2015.js

echo "const baselink = 'http://$ip/api/';" >> main-es2015.js
sudo cat ./build_iframe_proces > main-es2015.js


echo " proces.iframe = "http://192.168.0.105:3000/d-solo/76B5JFZRz/vinificatie?orgId=1&refresh=5m&panelId=10&var-vat=" + proces.vatId;" >> main-es2015.js

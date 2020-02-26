#!bin/bash
touch ./main-es2015.js
sudo cat ./build_begin_const > main-es2015.js

echo "Wat is het ip adres van de server?"
read ip
echo "const baselink = 'http://$ip/api/';" >> main-es2015.js

sudo cat ./build_baselink_iframe >> main-es2015.js
echo "      this.iframe = 'http://$ip:3000/d/76B5JFZRz/vinificatie?orgId=1&refresh=5m&from=now-7d&to=now&theme=light&kiosk=tv&var-vat=' + this.id;" >> main-es2015.js


sudo cat ./build_this_process >> main-es2015.js


echo " proces.iframe = "http://192.168.0.105:3000/d-solo/76B5JFZRz/vinificatie?orgId=1&refresh=5m&panelId=10&var-vat=" + proces.vatId;" >> main-es2015.js
sudo cat ./build_process_einde >> main-es2015.js

touch ./database.php
echo "<?php" > ./database.php
echo "class Database{ " >> ./database.php

echo "private $host = '$ip';" >> ./database.php
sudo cat ./api_deel2 >> ./database.php

sudo mv ./database.php /var/www/html/api/config/database.php

sudo service apache2 restart


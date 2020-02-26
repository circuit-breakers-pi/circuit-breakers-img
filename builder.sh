#!bin/bash
beginmap="$PWD"

cd ~
path=~
map="/download"
pad=$path$map
echo stop 1 $pad
#if [ -d $pad ]; then
  # Control will enter here if $DIRECTORY exists.
#	mkdir $pad
#else
	
#	rm -rf $pad
#fi

mkdir $pad
extra="/*"
#$pad2=$path$map$extra
rm -rf $path$map$extra
echo $pad2


cd $pad
echo $pad
#mkdir /home/pi/project/download/api
#cd /home/pi/project/download/api
#wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/api/*

map="/backend_pcfruit.git"
pad=$path$map
echo $pad
if [ -d $pad ]; then
  # Control will enter here if $DIRECTORY exists.
rm -rf $pad
else

        mkdir $pad
fi


sudo git clone https://github.com/stefmarien95/backend_pcfruit.git


#cd /home/pi/project/download

#mkdir /home/pi/project/download/assets
#cd /home/pi/project/download/assets
#wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/assets/*


map="/BuildCircuitFrontend"
pad=$path$map
echo $pad
if [ -d $pad ]; then
  # Control will enter here if $DIRECTORY exists.
rm -rf $pad
else

        mkdir $pad
fi



sudo git clone https://github.com/maartenschroons/BuildCircuitFrontend

#cd /home/pi/project/download
#wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/*



sudo rm -rf /var/www/html/*

map="/download/backend_pcfruit/*"
pad=$path$map

sudo mv -f $pad /var/www/html/

map="/download/BuildCircuitFrontend/CircuitFrontend/*"
pad=$path$map
sudo mv -f $pad /var/www/html
#sudo mv -f /home/pi/project/download/BuildCircuitFrontend/CircuitFrontend/assets /var/www/html

#sudo mv -f /home/pi/project/download/* /var/www/html/

sudo rm /var/www/html/main-es2015.js



cd $beginmap
touch ./main-es2015.js
sudo cat ./build_begin_const > main-es2015.js

echo "Wat is het ip adres van de server?"
read ip
echo "const baselink = 'http://$ip/api/';" >> main-es2015.js

sudo cat ./build_baselink_iframe >> main-es2015.js
echo "      this.iframe = 'http://$ip:3000/d/76B5JFZRz/vinificatie?orgId=1&refresh=5m&from=now-7d&to=now&theme=light&kiosk=tv&var-vat=' + this.id;" >> main-es$


sudo cat ./build_this_process >> main-es2015.js


echo " proces.iframe = 'http://$ip:3000/d-solo/76B5JFZRz/vinificatie?orgId=1&refresh=5m&panelId=10&var-vat=' + proces.vatId;" >> main-es2015.js
sudo cat ./build_process_einde >> main-es2015.js

sudo mv ./main-es2015.js /var/www/html/main-es2015.js

touch ./database.php
echo "<?php" > ./database.php
echo "class Database{ " >> ./database.php

echo 'private $host ="'$ip'";' >> ./database.php

sudo cat ./api_deel2 >> ./database.php

sudo mv ./database.php /var/www/html/api/config/database.php



sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo service apache2 restart

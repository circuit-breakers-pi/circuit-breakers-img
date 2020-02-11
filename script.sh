#---------webapp bestanden binnenhalen----------------
sudo mkdir /home/pi/project

sudo mkdir /home/pi/project/download

cd /home/pi/project/download
rm -rf /home/pi/project/download/*

mkdir /home/pi/project/download/api
cd /home/pi/project/download/api
wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/api/*


cd /home/pi/project/download

mkdir /home/pi/project/download/assets
cd /home/pi/project/download/assets
wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/assets/*


cd /home/pi/project/download
wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/*



rm -rf /var/www/html/*

mv -f /home/pi/project/download/* /var/www/html/


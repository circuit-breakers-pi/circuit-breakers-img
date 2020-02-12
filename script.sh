cd /home/pi/project/download
rm -rf /home/pi/project/download/*

#mkdir /home/pi/project/download/api
#cd /home/pi/project/download/api
#wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/api/*
sudo git clone https://github.com/stefmarien95/backend_pcfruit.git


#cd /home/pi/project/download

#mkdir /home/pi/project/download/assets
#cd /home/pi/project/download/assets
#wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/assets/*

sudo git clone https://github.com/maartenschroons/BuildCircuitFrontend

#cd /home/pi/project/download
#wget ftp://ftpuser:breakers@192.168.0.77/ftp/project/*



sudo rm -rf /var/www/html/*
sudo mv -f /home/pi/project/download/backend_pcfruit/* /var/www/html/

sudo mv -f /home/pi/project/download/BuildCircuitFrontend/CircuitFrontend/* /var/www/html
#sudo mv -f /home/pi/project/download/BuildCircuitFrontend/CircuitFrontend/assets /var/www/html

#sudo mv -f /home/pi/project/download/* /var/www/html/

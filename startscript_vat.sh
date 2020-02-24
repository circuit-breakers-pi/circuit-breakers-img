sudo rm ./script.sh 
sudo rm ./startscript_server.sh
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y python3-pip

sudo pip3 install spidev
sudo apt-get install -y python3-dev  default-libmysqlclient-dev
sudo pip3 install mysqlclient

sudo pip3 install simplepush

mkdir /home/pi/scripts
mv measurements.py /home/pi/scripts

mkdir /home/pi/log
touch /home/pi/log/errorlog.log

mkdir /home/pi/xml
touch /home/pi/xml/vatid.xml
sudo echo '<?xml version="1.0"?>' >> /home/pi/xml/vatid.xml
sudo echo '<data>' >> /home/pi/xml/vatid.xml
sudo echo '	<vatId></vatId>' >> /home/pi/xml/vatid.xml
sudo echo '</data>' >> /home/pi/xml/vatid.xml

sudo sh -c "echo 'dtparam=spi=on'" >> /boot/config.txt"
sudo sh -c "echo 'dtoverlay=w1-gpio'" >> /boot/config.txt"

sudo touch /lib/systemd/system/measurements.service

sudo chmod a+rwx /lib/systemd/system/measurements.service

sudo sh -c "echo '[Unit]'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo 'Description=Service to measure sensordata and send it to the database.'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo ''" >> /lib/systemd/system/measurements.service
sudo sh -c "echo '[Service]'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo 'Type=idle'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo 'ExecStart=/usr/bin/python3 /home/pi/scripts/measurements.py'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo 'Restart=always'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo ''" >> /lib/systemd/system/measurements.service
sudo sh -c "echo '[Install]'" >> /lib/systemd/system/measurements.service
sudo sh -c "echo 'WantedBy=default.target'" >> /lib/systemd/system/measurements.service

sudo chmod a-rwx /lib/systemd/system/measurements.service
sudo chmod 644 /lib/systemd/system/measurements.service

sudo reboot
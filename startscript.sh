sudo apt-get update
sudo apt-get upgrade -y

sudo bash -c 'echo -e "interface eth0 \n static ip_address=192.168.0.105/24 \n static routers=192.168.0.1 \n static domain_name_servers=192.168.0.77 8.8.8.8"' > /etc/dhcpcd.conf


#--------apache installeren---------
sudo apt-get install -y apache2 


#-----SQL-------
sudo apt-get install -y mariadb-server php-mysql 
sudo service apache2 restart
sudo mysql_secure_installation


#USER INPUT!

#You will be asked Enter current password for root (type a secure password): press Enter
#Type in Y and press Enter to Set root password
#Type in a password at the New password: prompt, and press Enter. Important: remember this root password, as you will need it later
#Type in Y to Remove anonymous users
#Type in Y to Disallow root login remotely
#Type in Y to Remove test database and access to it
#Type in Y to Reload privilege tables now

#verder script

sudo mysql --user=root --password <<MYSQL_SCRIPT
FLUSH PRIVILEGES;
create user admin@localhost identified by 'your_password';
grant all privileges on *.* to admin@localhost;
FLUSH PRIVILEGES;

#database laten maken
MYSQL_SCRIPT;


#----Phpmyadmin-------
sudo apt-get install -y phpmyadmin 


#*user input*
#als server apache2 kiezen
#select yes
#kies database admin paswoord
#confirm password

sudo phpenmod mysqli
sudo systemctl rerstart apache2






#--------grafana-------------
cd /var
sudo wget https://dl.grafana.com/oss/release/grafana-rpi_6.5.1_armhf.deb
sudo apt-get install -y adduser libfontconfig1
sudo dpkg -i grafana-rpi_6.5.1_armhf.deb

sudo grafana-server start
sudo update-rc.d grafana-server defaults

sudo systemctl deamon-reload
sudo systemctl start grafana-server

sudo sed '$d' /etc/rc.local

sudo bash -c 'echo -e "sudo start grafana-server \n exit 0"' > /etc/rc.local









#------firewall--------
#sudo apt-get install -y ufw
#sudo ufw allow 'Apache Full'
sudo apt-get update
sudo apt-get upgrade -y

sudo bash -c 'echo -e "interface eth0 \n static ip_address=192.168.0.105/24 \n static routers=192.168.0.1 \n static domain_name_servers=192.168.0.77 8.8.8.8"


#--------apache installeren---------
sudo apt-get install apache2 -y


#-----SQL-------
sudo apt-get install mariadb-server php-mysql -y
sudo service apache2 restart
sudo mysql_secure_installation


#USER INPUT!

You will be asked Enter current password for root (type a secure password): press Enter
Type in Y and press Enter to Set root password
Type in a password at the New password: prompt, and press Enter. Important: remember this root password, as you will need it later
Type in Y to Remove anonymous users
Type in Y to Disallow root login remotely
Type in Y to Remove test database and access to it
Type in Y to Reload privilege tables now

#verder script

sudo mysql --user=root --password
create user admin@localhost identified by 'your_password'; grant all privileges on *.* to admin@localhost; FLUSH PRIVILEGES; exit;

#----Phpmyadmin-------
sudo apt-get install phpmyadmin -y


#*user input*
#als server apache2 kiezen
#select yes
#kies database admin paswoord
#confirm password

sudo phpenmod mysqli
sudo systemctl rerstart apache2

#script van steven gebruiken voor inladen sql data)




#--------grafana-------------





#------firewall--------
sudo apt-get install ufw -y
sudo ufw allow 'Apache Full'
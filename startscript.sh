sudo apt-get update
sudo apt-get upgrade -y

sudo echo "interface eth0" >> /etc/dhcpcd.conf
sudo echo "static ip_address=192.168.0.105/24" >> /etc/dhcpcd.conf
sudo echo "static routers=192.168.0.1" >> /etc/dhcpcd.conf
sudo echo "static domain_name_servers=192.168.0.77 8.8.8.8" >> /etc/dhcpcd.conf


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
create user admin@localhost identified by 'breakers';
grant all privileges on *.* to admin@localhost;
FLUSH PRIVILEGES;

#database laten maken
--------------------------------------------------------------------------------------
-- Tabellen aanmaken
--------------------------------------------------------------------------------------

-- Tabel Persmethode
CREATE TABLE IF NOT EXISTS Persmethode(
    id INT NOT NULL AUTO_INCREMENT,
    methode varchar(250) NOT NULL,
    CONSTRAINT PK_persmethode PRIMARY KEY (id)
);

-- Tabel Materiaal
CREATE TABLE IF NOT EXISTS Materiaal (
    id INT NOT NULL AUTO_INCREMENT,
    naam Varchar(250),
    CONSTRAINT PK_materiaal PRIMARY KEY (id)
);

-- Tabel Vat
CREATE TABLE IF NOT EXISTS Vat (
    id INT NOT NULL AUTO_INCREMENT,
    materiaalId INT,
    nummer Varchar(250),
    volume FLOAT,
    locatie Varchar(250),
    deksel TINYINT DEFAULT 0,
    koelmantel TINYINT DEFAULT 0,
    mangat TINYINT DEFAULT 0,
    inGebruik TINYINT DEFAULT 0,
    gelinkt TINYINT DEFAULT 1,
    CONSTRAINT PK_vat PRIMARY KEY (id),
    CONSTRAINT AK_nummer UNIQUE KEY(nummer),
    CONSTRAINT FK_vat_materiaal
        FOREIGN KEY (materiaalId)
        REFERENCES Materiaal(id)
);

-- Tabel WijnType
CREATE TABLE IF NOT EXISTS WijnType (
    id INT NOT NULL AUTO_INCREMENT,
    naam Varchar(250),
    CONSTRAINT PK_wijntype PRIMARY KEY (id)
);

-- Tabel Vinificatie
CREATE TABLE IF NOT EXISTS Vinificatie (
    id INT NOT NULL AUTO_INCREMENT,
    vatId INT NOT NULL,
    persmethodeId INT NOT NULL,
    wijnTypeId INT NOT NULL,
    persHoeveelheid float,
    oogst float,
    persDruk float,
    jaargang INT,
    actief TINYINT,
    CONSTRAINT PK_vinificaie PRIMARY KEY (id),
    CONSTRAINT FK_vinificatie_vat
        FOREIGN KEY (vatId)
        REFERENCES Vat(id),
    CONSTRAINT FK_vinificatie_persmethode
        FOREIGN KEY (persmethodeId)
        REFERENCES Persmethode(id),
    CONSTRAINT FK_vinificatie_wijntype
        FOREIGN KEY (wijnTypeId)
        REFERENCES WijnType(id)
);

-- Tabel Rol
CREATE TABLE IF NOT EXISTS Rol (
    id INT NOT NULL AUTO_INCREMENT,
    rolnaam Varchar(250) NOT NULL,
    CONSTRAINT PK_rol PRIMARY KEY (id)
);


-- Tabel Gebruiker
CREATE TABLE IF NOT EXISTS Gebruiker(
    id INT NOT NULL AUTO_INCREMENT,    
    rolId INT NOT NULL,
    voornaam Varchar(250),
    naam Varchar(250),
    gebruikersnaam Varchar(250) NOT NULL,
    wachtwoord Varchar(250) NOT NULL,
    email Varchar(250),
    telefoonnummer Varchar(250),
    CONSTRAINT PK_gebruiker PRIMARY KEY (id),
    CONSTRAINT FK_gebruiker_rol
        FOREIGN KEY (rolId)
        REFERENCES Rol(id)
);

-- Tabel VinificatieGebruiker
CREATE TABLE IF NOT EXISTS VinificatieGebruiker(
    vinificatieId INT NOT NULL,
    gebruikerId INT NOT NULL,
    CONSTRAINT PK_vinificatieGebruiker PRIMARY KEY (vinificatieId, gebruikerId),
    CONSTRAINT FK_vinificatieGebruiker_vat
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id),
    CONSTRAINT FK_vinificatieGebruiker_gebruiker
        FOREIGN KEY (gebruikerId)
        REFERENCES Gebruiker(id)
);

-- Tabel SoortEvent
CREATE TABLE IF NOT EXISTS SoortEvent (
    id INT NOT NULL AUTO_INCREMENT,
    naam Varchar(250) NOT NULL,
    CONSTRAINT PK_soortEvent PRIMARY KEY (id)
);

-- Tabel Event
CREATE TABLE IF NOT EXISTS Event (
    id INT NOT NULL AUTO_INCREMENT,
    soortEventId INT NOT NULL,
    vinificatieId INT NOT NULL,
    gebruikerId INT NOT NULL,
    datum DateTime NOT NULL,
    CONSTRAINT PK_event PRIMARY KEY (id),
    CONSTRAINT FK_event_soortEvent
        FOREIGN KEY (soortEventId)
        REFERENCES SoortEvent(id),
    CONSTRAINT FK_event_vinificatie
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id),
    CONSTRAINT FK_event_gebruiker
        FOREIGN KEY (gebruikerId)
        REFERENCES Gebruiker(id)
);

-- Tabel DruifSoort
CREATE TABLE IF NOT EXISTS Druifsoort (
    id INT NOT NULL AUTO_INCREMENT,
    druifsoort Varchar(250) NOT NULL,
    CONSTRAINT PK_druifsoort PRIMARY KEY (id)
);

-- Tabel VinificatieDruifsoort
CREATE TABLE IF NOT EXISTS VinificatieDruifsoort (
    vinificatieId INT NOT NULL,
    druifsoortId INT NOT NULL,
    CONSTRAINT PK_vinificatieDruifsoort PRIMARY KEY (vinificatieId, druifsoortId),
    CONSTRAINT FK_vinificatieDruifsoort_vinificatie
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id),
    CONSTRAINT FK_vinificatieDruifsoort_druifsoort
        FOREIGN KEY (druifsoortId)
        REFERENCES Druifsoort(id)
);

-- Tabel SoortMeting
CREATE TABLE IF NOT EXISTS SoortMeting(
    id INT NOT NULL AUTO_INCREMENT,
    naam Varchar(250) NOT NULL,
    CONSTRAINT PK_soortMeting PRIMARY KEY (id)
);

-- Tabel HandmatigeMeting
CREATE TABLE IF NOT EXISTS HandmatigeMeting(
    id INT NOT NULL AUTO_INCREMENT,
    soortMetingId INT NOT NULL,
    vinificatieId INT NOT NULL,
    gebruikerId INT NOT NULL,
    meting Float NOT NULL,
    tijd DateTime NOT NULL,
    CONSTRAINT PK_handmatigeMeting PRIMARY KEY (id),
    CONSTRAINT FK_handmatigeMeting_soortMeting
        FOREIGN KEY (soortMetingId)
        REFERENCES SoortMeting(id),
    CONSTRAINT FK_handmatigeMeting_vinificatie
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id),
    CONSTRAINT FK_handmatigeMeting_gebruiker
        FOREIGN KEY (gebruikerId)
        REFERENCES Gebruiker(id)
);

-- Tabel AutomatischeData
CREATE TABLE IF NOT EXISTS AutomatischeData (
    id INT NOT NULL AUTO_INCREMENT,
    vinificatieId INT NOT NULL,
    temperatuur float NOT NULL,
    co2 float NOT NULL,
    alcohol float NOT NULL,
    luchtdruk float NOT NULL,
    troebelheid float NOT NULL,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP, 
    CONSTRAINT PK_automatischeData PRIMARY KEY (id),
    CONSTRAINT FK_automatischeData_vinificatie
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id)
);

-- Tabel SoortAlarm
CREATE TABLE IF NOT EXISTS SoortAlarm(
    id INT NOT NULL AUTO_INCREMENT,
    naam Varchar(250) NOT NULL,
    CONSTRAINT PK_soortAlarm PRIMARY KEY (id)
);

-- Tabel Alarmdata
CREATE TABLE IF NOT EXISTS Alarmdata(
    id INT NOT NULL AUTO_INCREMENT,
    soortAlarmId INT NOT NULL,
    vinificatieId INT NOT NULL,
    minimumwaarde float,
    maximumwaarde float,
    actief BOOLEAN DEFAULT True,
    CONSTRAINT PK_alarmdata PRIMARY KEY (id),
    CONSTRAINT FK_alarmdata_soortAlarm
        FOREIGN KEY (soortAlarmId)
        REFERENCES SoortAlarm(id),
    CONSTRAINT FK_alarmdata_vinificatie
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id)
);

-- Tabel AlarmLog
CREATE TABLE IF NOT EXISTS AlarmLog(
    id INT NOT NULL AUTO_INCREMENT,
    vinificatieId INT NOT NULL,
    bericht Varchar(250),
    datum DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_alarmLog PRIMARY KEY (id),
    CONSTRAINT FK_alarmLog_vinificatie
        FOREIGN KEY (vinificatieId)
        REFERENCES Vinificatie(id)
);

-- Tabel AlarmdataGebruiker
CREATE TABLE IF NOT EXISTS AlarmdataGebruiker(
    gebruikerId INT NOT NULL,
    alarmdataId INT NOT NULL,
    CONSTRAINT PK_alarmdataGebruiker PRIMARY KEY (alarmdataId, gebruikerId),
    CONSTRAINT FK_alarmdataGebruiker_alarm
        FOREIGN KEY (alarmdataId)
        REFERENCES Alarmdata(id),
    CONSTRAINT FK_alarmdataGebruiker_gebruiker
        FOREIGN KEY (gebruikerId)
        REFERENCES Gebruiker(id)
);

--------------------------------------------------------------------------------------
-- DATA
--------------------------------------------------------------------------------------
    
-- Materiaal
INSERT INTO Materiaal (naam)
VALUES
    ('Inox'),
    ('Hout'),
    ('Kunststof'),
    ('Beton');

-- WijnType
INSERT INTO WijnType (naam)
VALUES
    ('Wit'),
    ('Rood'),
    ('Rose'),
    ('Mousserend');

-- Rol
INSERT INTO Rol (rolnaam)
VALUES
    ('admin');

-- Druifsoort
INSERT INTO Druifsoort (druifsoort)
VALUES
    ('Chardonnay'),
    ('Grüner verltiner'),
    ('pinot blanc'),
    ('Merlot'),
    ('Cabernet sauvignon'),
    ('Grenache');
    
-- SoortAlarm
INSERT INTO SoortAlarm (id, naam)
VALUES
    (1, 'Luchtdruk'),    
    (2, 'Alcohol'), 
    (3, 'CO2'),  
    (4, 'Troebelheid'),
    (5, 'Temperatuur');
    
-- SoortMeting
INSERT INTO SoortMeting (naam)
VALUES
    ('Zuur'),
    ('Suiker'),
    ('pH');
    
-- SoortEvent
INSERT INTO SoortEvent (naam)
VALUES
    ('In frigo geplaatst'), 
    ('Verwarming aangezet');


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


#---automatiseren backup SQL
sudo apt-get install -y automysqlbackup autopostgresqlbackup

sudo mkdir /var/automysqlbackup
cd /var/automysqlbackup
sudo wget http://ufpr.dl.sourceforge.net/project/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup%20VER%203.0/automysqlbackup-v3.0_rc6.tar.gz
sudo tar zxf automysqlbackup-v3.0_rc6.tar.gz

sudo bash ./install.sh

sudo mkdir /var/backup
sudo mkdir /var/backup/db


sudo echo "CONFIG_mysql_dump_username='admin'" > /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_mysql_dump_password='breakers'" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_mysql_dump_host='localhost'" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_backup_dir='/var/backup/db'" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_db_names=('wijn')" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_db_month_names=('')" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_do_monthly='01'" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_do_weekly='1'" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_rotation_daily=7" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_rotation_weekly=35" >> /etc/automysqlbackup/myserver.conf
sudo echo "CONFIG_rotation_monthly=150" >> /etc/automysqlbackup/myserver.conf



sudo echo "13 13    * * * /usr/local/bin/automysqlbackup /etc/automysqlbackup/myserver.conf" >> /var/spool/cron/crontab/root


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

sudo echo "sudo start grafana-server \n exit 0" >> /etc/rc.local









#------firewall--------
#sudo apt-get install -y ufw
#sudo ufw allow 'Apache Full'
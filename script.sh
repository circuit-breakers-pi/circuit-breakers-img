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

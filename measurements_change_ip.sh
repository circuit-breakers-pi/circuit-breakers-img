sudo cat ./measurements_part1 > /home/pi/scripts/measurements.py

echo What is the IP address of your server?
read ip

sudo echo "serverIp = '$ip'" >> /home/pi/scripts/measurements.py

sudo cat ./measurements_part2 >> /home/pi/scripts/measurements.py



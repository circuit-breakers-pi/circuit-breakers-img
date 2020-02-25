import os
import glob
import spidev
import datetime
import subprocess
import time
from datetime import timedelta
import MySQLdb
import xml.etree.ElementTree as ET
from simplepush import send

dt = datetime.datetime

# Open file to write logs to
f = open('/home/pi/log/errorlog.log', 'a')

# Declaration of xml variables
xmlpath = '/home/pi/xml/vatid.xml'
tree = ET.parse(xmlpath)
root = tree.getroot()

# Start SPI connection
spi = spidev.SpiDev() # Created an object
spi.open(0,0)

# Ready connection to DS18B20
os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')

base_dir = '/sys/bus/w1/devices/'
device_folder = glob.glob(base_dir + '28*')[0]
device_file = device_folder + '/w1_slave'

# Variable declarations
serverIp = '192.168.0.105'
drukChan = 0
alcChan = 1
co2Chan = 2
troebChan = 3
tempIndex = 4
sensorData = [0,0,0,0,0]
alarmData = [None] * 5
vatId = root[0].text
proces = None
actief = False
intervalStart = dt.now()

# Definition of object Alarm
class Alarm:
	def __init__(self, min, max, id):
		self.min = min
		self.max = max
		self.id = id

def typeData(i):
	switcher={
		0:'Luchtdruk',
		1:'Alcohol',
		2:'CO2',
		3:'Troebelheid',
		4:'Temperatuur',
	}
	return switcher.get(i,"Onbekend")

# Function definitions for DS18B20
def read_temp_raw():
	f = open(device_file, 'r')
	lines = f.readlines()
	f.close()
	return lines

def read_temp():
	lines = read_temp_raw()
	while lines[0].strip()[-3:] != 'YES':
		time.sleep(0.2)
		lines = read_temp_raw()
	equals_pos = lines[1].find('t=')
	if equals_pos != -1:
		temp_string = lines[1][equals_pos+2:]
		temp_c = float(temp_string) / 1000.0
		return temp_c

# Function definitions for MCP3008
def analogInput(channel):
	spi.max_speed_hz = 1350000
	adc = spi.xfer2([1,(8+channel)<<4,0])
	data = ((adc[1]&3) << 8) + adc[2]
	return data

# Function definition for reading all sensors
def readSensors():
	sensorData[drukChan] = round((analogInput(drukChan)/1023)*3 , 1)
	sensorData[alcChan] = round((analogInput(alcChan)/1023)*25)
	sensorData[co2Chan] = round((analogInput(co2Chan)/1023)*100)
	sensorData[troebChan] = round(100-((analogInput(troebChan)/1023)*100))
	sensorData[tempIndex] = round(read_temp(), 1)

# Function definition for ping command
def ping(host):
	# Building the command. Ex: "ping -c 1 google.com"
	command = ['ping', '-c', '1', host]
	
	return subprocess.call(command, stdout=subprocess.DEVNULL) == 0

# Function definitions for MySQLdb
def connectDb():
	if ping(serverIp):
		return MySQLdb.connect(serverIp,"admin","breakers","wijn" )
	else:
		return None

def readDb():
	global proces
	global actief
	
	# Open database connection
	db = connectDb()
	if db is not None:
		# Prepare a cursor object
		cursor = db.cursor()
		
		# execute SQL query using execute() method.
		cursor.execute("SELECT id FROM Vinificatie WHERE actief = true AND  vatId = " + str(vatId))
		
		data = cursor.fetchone()
		
		if data is not None:
			proces = data[0]
			actief = True
		
		else:
			proces = data
			actief = False
		
		cursor.close
		
		# disconnect from server
		db.close()
	else:
		print(str(dt.now()) + " Geen databaseconnectie", file=f)

def readAlarmDb():
	global proces
	global actief
	global alarmData
	
	alarmData = [None] * 5
	# Open database connection
	db = connectDb()
	if db is not None:
		# Prepare a cursor object
		cursor = db.cursor()
		
		# execute SQL query using execute() method.
		cursor.execute("SELECT soortAlarmId, minimumwaarde, maximumwaarde, id FROM Alarmdata WHERE actief = true AND vinificatieId = " + str(proces))
		
		data = cursor.fetchall()
		
		if data is not None:
			for val in data:
				alarmData[val[0] -1] = Alarm(val[1], val[2], val[3])
		
		else:
			proces = data
			actief = False
		
		cursor.close
		# disconnect from server
		db.close()
	else:
		print(str(dt.now()) + " Geen databaseconnectie", file=f)

def updateAlarmLogDb(bericht , type, alarmId):
	# Open database connection
	db = connectDb()
	if db is not None:
		# Prepare a cursor object
		cursor = db.cursor()
		# execute SQL query using execute() method.
		cursor.execute("SELECT id FROM `AlarmLog` WHERE `vinificatieId` = " + str(proces) + " AND `bericht` = '" + bericht + " alarm: waarde te " + type + "' AND `datum` >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 15 MINUTE)")
		
		data = cursor.fetchone()
		
		if data is None:
			cursor.execute("INSERT INTO `AlarmLog` (`vinificatieId`, `bericht`, `datum`) VALUES (" + str(proces) + ", '" + bericht + " alarm: waarde te " + type + "', current_timestamp())")
			db.commit()
			
			cursor.execute("SELECT g.telefoonnummer FROM Gebruiker g WHERE NOT EXISTS (SELECT * FROM Alarmdata a WHERE a.id = " + str(alarmId) + " AND NOT EXISTS (SELECT * FROM AlarmdataGebruiker ag WHERE ag.gebruikerId = g.id AND ag.alarmdataId = a.id))")
			
			data = cursor.fetchall()
			
			for val in data:
				send(val, "Vat" + str(vatId), bericht + " alarm: waarde te " + type, "Testevent")
		
		cursor.close
		# disconnect from server
		db.close()
	else:
		print(str(dt.now()) + " Geen databaseconnectie", file=f)

def writeSensorDb():
	# Open database connection
	db = connectDb()
	if db is not None:
		# Prepare a cursor object
		cursor = db.cursor() 
		
		# Insert sensordata into database
		cursor.execute("INSERT INTO `AutomatischeData` (`vinificatieId`, `temperatuur`, `co2`, `alcohol`, `luchtdruk`, `troebelheid`, `datum`) VALUES ('" + str(proces) + "', '" + str(sensorData[tempIndex]) + "', '" + str(sensorData[co2Chan]) + "', '" + str(sensorData[alcChan]) + "', '" + str(sensorData[drukChan]) + "', '" + str(sensorData[troebChan]) + "', current_timestamp())")
		db.commit()
		cursor.close
		db.close()
	else:
		print(str(dt.now()) + " Geen databaseconnectie", file=f)

# Function definitions for alarms
def checkAlarm():
	for idx, val in enumerate(alarmData):
		if val is not None:
			if sensorData[idx] < val.min:
				updateAlarmLogDb(typeData(idx), 'laag', val.id)
			elif sensorData[idx] > val.max:
				updateAlarmLogDb(typeData(idx), 'hoog', val.id)

# Check if Vat has id assigned and create new database instance if not
while vatId is None:
	print(str(dt.now()) + " Geen vat Id", file=f)
	
	# Open database connection
	db = connectDb()
	if db is not None:
		# Prepare a cursor object
		cursor = db.cursor() 
		
		# Create new vat
		cursor.execute("INSERT INTO `Vat` (`nummer`, `inGebruik`, `gelinkt`) VALUES (NULL, '0', '0')")
		
		# Request id of new vat
		cursor.execute("SELECT id FROM Vat WHERE gelinkt = false")
		data = cursor.fetchone()
		
		# Save id in xml
		root[0].text = str(data[0])
		tree.write(xmlpath)
		
		vatId = data[0]
		
		# Complete vat in database
		cursor.execute("UPDATE Vat SET nummer = 'Vat " + str(vatId) + "', gelinkt = 1 WHERE id = " + str(vatId))
		db.commit()
		cursor.close
		db.close()
		
		print(str(dt.now()) +  " Vat Id set to: " +str(vatId), file=f)
		
	else:
		print(str(dt.now()) + " Geen databaseconnectie", file=f)

print(str(dt.now()) +  " Script gestart, vat Id: " +str(vatId), file=f)

readDb()
if(actief):
	readAlarmDb()

while True:
	if(dt.now() >= intervalStart + timedelta(minutes=5)):
		readDb()
		if(actief):
			readAlarmDb()
			writeSensorDb()
			
		intervalStart = dt.now()
	
	readSensors();
	checkAlarm();
	time.sleep(0.5);


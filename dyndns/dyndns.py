#!/usr/bin/python
import requests
import xml.etree.ElementTree as ET
import json
import datetime
import fnmatch
#import ntpath
import os.path
import socket

import sys, argparse, logging, pif, smtplib, urllib
from pygodaddy import GoDaddyClient
# Import the email modules we'll need
from email.mime.text import MIMEText

# Import domain config file(s) with sensitive data:
import params.GoDaddy as paramsGoDaddy
import params.NameSilo as paramsNameSilo

#Index: 
# 1. Information & Description:
# 2. Setup & Instructions:
#     2a. Dependences:
# 3. Parameters:
# 4. Functions:
# 5. Main:
#     1. Imports & set vars --------------------------------------------------------------------------------------
#     2. Create log file if it doesn't exist ---------------------------------------------------------------------
#     3. 1st URL call: Get our Public IP -------------------------------------------------------------------------
#     4. 2nd URL call: Get NameSilo's IP for our domain name -----------------------------------------------------
#     5. Examine & Compare Responses -----------------------------------------------------------------------------
#     6. 3rd (possible) URL call: Set NameSilo's IP for our domain name ------------------------------------------
# 6. Footer:

# ---------------------------------------------------------------------------------------------------------
# Information & Description:

# dyndns.py is designed to run on a Raspberry Pi to update domain name A records (IPv4) hosted on a multitude of different domain registrars/providers.

# Based on:
# http://vivithemage.com/2018/09/17/namesilo-dns-update-via-python-script-and-cron-job-on-pfsense/

# More setup details, notes, and information at:
# %UserProfile%\Documents\GitHub\python-pi-multi-dyndns\dyndns\setup.sh
#https://github.com/Kerbalnut/python-pi-multi-dyndns

# /Information & Description
# ---------------------------------------------------------------------------------------------------------
# Setup & Instructions:

# To copy this script to Raspberry Pi via PuTTY:
#pscp "%UserProfile%\Documents\GitHub\Python-DynDNS-NameSilo\dyndns\dyndns.py" pi@10.210.69.42:/home/pi/dyndns/dyndns.py

# To run this script: 
#python /home/pi/dyndns/dyndns.py
#python2.7 /home/pi/dyndns/dyndns.py
#python3 /home/pi/dyndns/dyndns.py

# Import Module Dependences: (troubleshooting)
# Must install module packages if you don't have them available for import, if import causes any errors:
#pip install requests
#pip install pif
#pip install pygodaddy

# View log file:
#cat /home/pi/dyndns/dyndns.log

# Delete log file:
#rm /home/pi/dyndns/dyndns.log

# Make script executable:
#cd ~
#cd /home/pi/dyndns/
#ls -l
#chmod +x dyndns.py
#ls -l

# /Setup & Instructions
# ---------------------------------------------------------------------------------------------------------
# Parameters:

# 1
PATH_TO_PRODUCTION_PARAMS = './params/NameSilo.py'
execfile(PATH_TO_PRODUCTION_PARAMS)
# DEPRECATED: Use 'import params.NameSilo as paramsNameSilo' line at top of script instead.

# 2
GODADDY_PARAMS = './params/GoDaddy.py'
execfile(GODADDY_PARAMS)
# DEPRECATED: Use 'import params.GoDaddy as paramsGoDaddy' line at top of script instead.

# 3
STRICT_CHECKING = False
# Use True or False for values. (Default = False)

# 4
FORCE_TESTING = False
# Use True or False for values. (Default = False)
# Will force all the API calls to update the target DNS records on EVERY RUN, even if they already match our public IP.
# DO NOT leave this set as True for a production environment. This is ONLY for troubleshooting & developing new function API calls.
# TO RUN A PROPER TEST: Manually change the DNS record on your domain provider's website to a 'wrong' IP value, then manually run this script with STRICT_CHECKING enabled. BUT DO NOT set this var to True to perform a regular test. If this script updates DNS records on first run, and does not on the second run, the test is complete and the STRICT_CHECKING var can be reverted to whatever value is preferred.

# /Parameters
# ---------------------------------------------------------------------------------------------------------
# Functions:

#email function
def email_update(body):
	global smtplib
	msg = MIMEText(body)
	msg['From'] = paramsGoDaddy.sender
	msg['To'] = paramsGoDaddy.to
	msg['Subject'] = 'IP address updater'
	s = smtplib.SMTP(paramsGoDaddy.smtpserver)
	s.sendmail(paramsGoDaddy.sender, paramsGoDaddy.to, msg.as_string())
	s.quit()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Log file functions:

global VID_TO_CURATE
VID_TO_CURATE = False
# Do not change. Used for log file automation purposes only.

# Initiate log file:
def LogFileInit():
	# This function can be called no matter what state the log file is in: It
	# - automatically creates a new log file if none exists, or 
	# - calls the proper new log operation functions if it does already exist.
	# - adds header to a brand new log file.
	# - adds line separator and timestamp for new logging operation.
	# - names the log file(s) same name as this script calling them.
	# - automatically generates a curated log file for when important tags get called.
	# To call this function / Start a brand new log / Begin a new logging operation with existing file:
	#LOG_FILE_0, LOG_FILE_FULL_PATH, LOG_FILE_CURATED_PATH, VID_TO_CURATE = LogFileInit()
	# To write messages to the log:     (only write to LOG_FILE_0, all the other vars are automated)
	# - LogFileAddUntaggedMsg(LOG_FILE_0,msg)	[]: Untagged message
	# - LogFileAddTimeStamp(LOG_FILE_0)			[TIMESTAMP]: 2023-01-23 04:53:51.411593
	# - LogFileAddURLCall(LOG_FILE_0,msg)		[URL_CALL]: any kind of URL call to an API or public interface
	# - LogFileAddOK(LOG_FILE_0,msg)			[OK]: Good operation/Nominal status/no changes.
	# - LogFileAddTrouble(LOG_FILE_0,msg)		[TROUBLE]: Potential issues.
	# - LogFileAddError(LOG_FILE_0,msg)			[ERROR]: Possible functionality failure.
	# - LogFileAddUpdate(LOG_FILE_0,msg)		[UPDATE]: Dyn-DNS record update command.
	# To end current logging operaton:
	#LogFileEndOp(LOG_FILE_0,LOG_FILE_FULL_PATH,LOG_FILE_CURATED_PATH,VID_TO_CURATE)
	#--------------------------------------------------------------------------------
	# Full details:
	# - Creates 2 main log files, 'this_script_name.log' and 'this_script_name_CURATED.log'
	# - The CURATED log file only contains operations that had a [UPDATE], [TROUBLE], or [ERROR] tag in them:
	#    - See the LogFileTestVid() function to change which tags get counted. I decided to call these tags VIDs for Very Important Data.
	#    - The individual functions LogFileAddUpdate(), LogFileAddTrouble(), and LogFileAddError() still should update the global boolean VID_TO_CURATE var to True on their own.
	# - At the start of each logging operation a 'this_script_name_TEMP.log' file gets created, and all data gets written to it during logging. (This TEMP.log file is the same as the LOG_FILE_0 var.)
	# - At the end of a logging operation, if the global boolean VID_TO_CURATE is set to True or LogFileTestVid() finds any targeted tags, TEMP.log data gets appended to the CURATED.log file.
	# - No matter what, the TEMP.log data always gets written to the main log file 'this_script_name.log'.
	# - 'this_script_name_TEMP.log' is then deleted.
	# - If the script crashes before LogFileEndOp() gets called, LogFileInit() will automatically recover that data and clean it up on next run.
	#--------------------------------------------------------------------------------
	
	THIS_SCRIPT_NAME = os.path.basename(__file__)
	#print('(Verbose) Local script name: "'+THIS_SCRIPT_NAME+'"')
	
	CURRENT_TIMESTAMP = datetime.datetime.now()
	#print('Operation timestamp: %s' % datetime.datetime.now())
	#print('               date: %s' % datetime.datetime.now().date())
	#print('               time: %s' % datetime.datetime.now().time())
	
	# Get log file name & path
	FULL_SCRIPT_PATH = __file__
	#print('(Verbose) Local script path: "'+FULL_SCRIPT_PATH+'"')
	
	SEPARATE_PATH_EXTENTION = os.path.splitext(__file__)
	#print('Log file name: '+str(SEPARATE_PATH_EXTENTION))
	#print('Log file name: '+SEPARATE_PATH_EXTENTION[0])
	
	LOG_FILE_NAME = os.path.basename(SEPARATE_PATH_EXTENTION[0])+'.log'
	#print('Log file name: '+LOG_FILE_NAME)
	
	LOG_FILE_FULL_PATH = SEPARATE_PATH_EXTENTION[0]+'.log'
	#print('Log file path: '+LOG_FILE_FULL_PATH)
	
	LOG_FILE_CURATED_NAME = os.path.basename(SEPARATE_PATH_EXTENTION[0])+'_CURATED.log'
	#print('Curated log file path: '+LOG_FILE_CURATED_NAME)
	
	LOG_FILE_CURATED_PATH = SEPARATE_PATH_EXTENTION[0]+'_CURATED.log'
	#print('Curated log file path: '+LOG_FILE_CURATED_PATH)
	
	LOG_FILE_TEMP = SEPARATE_PATH_EXTENTION[0]+'_TEMP.log'
	#print('Temporary log file path: '+LOG_FILE_TEMP)
	
	# Create log file if it does not exit
	if not (os.path.isfile(LOG_FILE_FULL_PATH)):
		print('Creating new log file:')
		LogFileCreateNewLog(LOG_FILE_FULL_PATH,FULL_SCRIPT_PATH,LOG_FILE_NAME);
	
	# Create curated log file if it does not exit
	if not (os.path.isfile(LOG_FILE_CURATED_PATH)):
		print('Creating new curated log file:')
		LogFileCreateNewLog(LOG_FILE_CURATED_PATH,FULL_SCRIPT_PATH,LOG_FILE_CURATED_NAME);
	
	# In case TEMP log file got left over from failed run, process and clean it up:
	if (os.path.isfile(LOG_FILE_TEMP)):
		print('WARNING: leftover temp file detected! '+LOG_FILE_TEMP)
		msg = "WARNING: Last run did not complete successfully. Script failed to reach the end. Clean-up operation in progress."
		LogFileEndFooter(LOG_FILE_TEMP,msg,False)
		LogFileCleanup(LOG_FILE_TEMP,LOG_FILE_FULL_PATH,LOG_FILE_CURATED_PATH)
	
	# Start new log file operation, Add new timestamp
	LogFileStartOp(LOG_FILE_TEMP)
	
	# Finish setting up remaining vars:
	LOG_FILE_0 = LOG_FILE_TEMP
	
	global VID_TO_CURATE
	VID_TO_CURATE = False
	
	return LOG_FILE_0, LOG_FILE_FULL_PATH, LOG_FILE_CURATED_PATH, VID_TO_CURATE

# Create new log file
def LogFileCreateNewLog(LOG_FILE_FULL_PATH,FULL_SCRIPT_PATH,LOG_FILE_NAME=False):
	# NOT RECOMMENDED to use directly: use LogFileInit() instead, it calls this function and many others.
	#"Creates a new log, prints a file header, for creating new logs."
	# To call this function:
	#LogFileCreateNewLog();
	#--------------------------------------------------------------------------------
	
	# Create log file if it does not exit
	if (os.path.isfile(LOG_FILE_FULL_PATH)):
		if (LOG_FILE_NAME == False):
			#print('Log file exists: '+LOG_FILE_FULL_PATH)
			print('Appending results to log file: '+LOG_FILE_FULL_PATH)
		else:
			#print('Log file exists: '+LOG_FILE_NAME)
			print('Appending results to log file: '+LOG_FILE_NAME)
		# Append existing text file: 
		file = open(LOG_FILE_FULL_PATH,"a") # Here we use "a" for append
	else:
		# Create a new log file
		if (LOG_FILE_NAME == False):
			print('Log file does not exist! = '+LOG_FILE_FULL_PATH)
		else:
			print('Log file does not exist! = '+LOG_FILE_NAME)
		print('Creating: \n"'+LOG_FILE_FULL_PATH+'"')
		# https://www.pythonforbeginners.com/files/reading-and-writing-files-in-python
		# Create new text file: 
		file = open(LOG_FILE_FULL_PATH,"w+") 
		# Here we used "w" letter in our argument, which indicates write and the plus sign that means it will create a file if it does not exist in library
	file.write('\n') 
	file.write("--------------------------------------------------------------------------------\n")
	file.write('Begin log file for: \n') 
	file.write(FULL_SCRIPT_PATH+'\n') 
	file.write('\n') 
	file.write('Creation Timestamp: %s' % datetime.datetime.now())
	file.write('              date: %s' % datetime.datetime.now().date())
	file.write('              time: %s' % datetime.datetime.now().time())
	file.write('\n') 
	file.write('Tags in use: \n')
	file.write('[TIMESTAMP]:  Start of new operation.\n')
	file.write('[URL_CALL]:   Send an HTTP request to a website.\n')
	file.write('[OK]:         Nominal status/no changes.\n')
	file.write('[TROUBLE]:    Potential Trouble.\n')
	file.write('[ERROR]:      Possible functionality breakage.\n')
	file.write('[UPDATE]:     Dyn-DNS record update command.\n')
	file.write('\n') 
	file.close() 
	# Read back newly created file:
	#print('Reading back new log file:')
	#file = open(LOG_FILE_FULL_PATH,"r") # Here we use "r" for read
	#print (file.read())
	#print('End reading new log file.')
	return LOG_FILE_FULL_PATH;

def LogFileTestVid(LOG_FILE_0):
	# Parses a log file to test if it contains Very Important Data, tags of signifigance. Returns a Ture/False value.
	# To call this function:
	#CONTAINS_VID = LogFileTestVid(LOG_FILE_0)
	#--------------------------------------------------------------------------------
	# string(s) to search in file
	vitags = ["[TROUBLE]", "[ERROR]", "[UPDATE]"]
	#print('Testing log file for Very Important Data (VID): '+LOG_FILE_0)
	#print('Searching tags:')
	#for tag in vitags:
	#	print(' - '+tag)
	strcontains = False
	with open(LOG_FILE_0,'r') as fp:
		# read all lines using readline()
		lines = fp.readlines()
		for row in lines:
			# check if string present on a current line
			for tag in vitags:
				#print(row.find(tag))
				# find() method returns -1 if the value is not found,
				# if found it returns index of the first occurrence of the substring
				if row.find(tag) != -1:
					strcontains = True
	vid = strcontains
	if (vid == True):
		print('Important tags detected.')
	else:
		print('No significant tags detected.')
	return vid

def LogFileCleanup(LOG_FILE_0, LOG_FILE_FULL_PATH, LOG_FILE_CURATED_PATH, VID_TO_CURATE=False):
	# Parses a log file to test if it contains Very Important Data, tags of signifigance. Returns a Ture/False value.
	# To call this function:
	#CONTAINS_VID = LogFileCleanup(LOG_FILE_0, LOG_FILE_FULL_PATH, LOG_FILE_CURATED_PATH, VID_TO_CURATE)
	#--------------------------------------------------------------------------------
	LOG_FILE_TEMP = LOG_FILE_0
	# In case TEMP log file got left over from failed run, process and clean it up:
	if (os.path.isfile(LOG_FILE_TEMP)):
		print('Cleaning up leftover temp file: '+LOG_FILE_TEMP)
		if ( VID_TO_CURATE == False):
			# Parse log file for Very Important Data:
			vid = LogFileTestVid(LOG_FILE_TEMP)
		else:
			vid = VID_TO_CURATE
		# Get file's content:
		with open(LOG_FILE_TEMP, 'r') as file:
			# read all content from a file using read()
			content = file.read()
		# Add temp file contents to curated log file, if applicable:
		if (vid == True):
			file = open(LOG_FILE_CURATED_PATH,"a") # Here we use "a" for append
			file.writelines(content)
			file.close()
		# Add temp file contents to log file:
		file = open(LOG_FILE_FULL_PATH,"a") # Here we use "a" for append
		file.writelines(content)
		file.close()
		# Remove temp file:
		os.remove(LOG_FILE_TEMP)
	else:
		print('No temp file to cleanup: '+LOG_FILE_TEMP)
		vid = VID_TO_CURATE
	return vid

# Start a new log file operation
def LogFileStartOp(LOG_FILE_FULL_PATH):
	# NOT RECOMMENDED to use directly: use LogFileInit() instead, it calls this function and many others.
	#PATH_TO_LOG_FILE = "/home/pi/file.log"
	#PATH_TO_LOG_FILE = LOG_FILE_FULL_PATH
	#LogFileAddTimeStamp(PATH_TO_LOG_FILE);
	#LogFileAddTimeStamp(LOG_FILE_FULL_PATH);
	#LogFileAddTimeStamp("/home/pi/file.log");
	#--------------------------------------------------------------------------------
	# Create log file if it does not exit
	if (os.path.isfile(LOG_FILE_FULL_PATH)):
		#print('Log file exists: '+LOG_FILE_FULL_PATH)
		print('Appending results to log file: '+LOG_FILE_FULL_PATH)
		# Append existing text file: 
		file = open(LOG_FILE_FULL_PATH,"a") # Here we use "a" for append
	else:
		print('Log file does not exist = '+LOG_FILE_FULL_PATH)
		print('Creating: \n"'+LOG_FILE_FULL_PATH+'"')
		# https://www.pythonforbeginners.com/files/reading-and-writing-files-in-python
		# Create new text file: 
		file = open(LOG_FILE_FULL_PATH,"w+") 
		# Here we used "w" letter in our argument, which indicates write and the plus sign that means it will create a file if it does not exist in library
	#file.write("\n")
	file.write("--------------------------------------------------------------------------------\n")
	file.close()
	LogFileAddTimeStamp( LOG_FILE_FULL_PATH )
	CURRENT_TIMESTAMP = datetime.datetime.now()
	file = open(LOG_FILE_FULL_PATH,"a") # Here we use "a" for append
	#file.write("[TIMESTAMP]: %s\n" % CURRENT_TIMESTAMP)
	file.write("Starting new operation: %s\n" % CURRENT_TIMESTAMP)
	file.close()
	return;

# Add untagged message to log file.
def LogFileAddUntaggedMsg(LOG_FILE_0,msg):
	#"Adds untagged message to log."
	#PATH_TO_LOG_FILE = "/home/pi/file.log"
	#PATH_TO_LOG_FILE = LOG_FILE_0
	#LogFileAddTimeStamp(PATH_TO_LOG_FILE);
	#LogFileAddTimeStamp(LOG_FILE_0);
	#LogFileAddTimeStamp("/home/pi/file.log");
	#--------------------------------------------------------------------------------
	print("[]: %s\n" % msg)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	file.write("[]: %s\n" % msg)
	file.close() 
	return;

# Add [TIMESTAMP]: to log file.
def LogFileAddTimeStamp(LOG_FILE_0):
	#"Adds current timestamp to log."
	#PATH_TO_LOG_FILE = "/home/pi/file.log"
	#PATH_TO_LOG_FILE = LOG_FILE_0
	#LogFileAddTimeStamp(PATH_TO_LOG_FILE);
	#LogFileAddTimeStamp(LOG_FILE_0);
	#LogFileAddTimeStamp("/home/pi/file.log");
	#--------------------------------------------------------------------------------
	CURRENT_TIMESTAMP = datetime.datetime.now()
	print("[TIMESTAMP]: %s\n" % CURRENT_TIMESTAMP)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	#file.write("\n") 
	#file.write("--------------------------------------------------------------------------------\n")
	#file.write("Start new operation: %s\n" % CURRENT_TIMESTAMP)
	file.write("[TIMESTAMP]: %s\n" % CURRENT_TIMESTAMP)
	file.close() 
	return;

# Add [URL_CALL]: to log file
def LogFileAddURLCall(LOG_FILE_0,msg):
	# "Add URL call to log."
	# LOG_FILE_0
	#PATH_TO_LOG_FILE = "/home/pi/file.log"
	#PATH_TO_LOG_FILE = LOG_FILE_0
	#LogFileAddTimeStamp(PATH_TO_LOG_FILE);
	#LogFileAddTimeStamp(LOG_FILE_0);
	#LogFileAddTimeStamp("/home/pi/file.log");
	#--------------------------------------------------------------------------------
	#print("[URL_CALL]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	print("[URL_CALL]: "+msg)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	#file.write("[URL_CALL]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	file.write("[URL_CALL]: %s\n" % msg)
	file.close()
	return;

# Add [OK]: to log file
def LogFileAddOK(LOG_FILE_0,msg):
	# "Add OK msg to log."
	#--------------------------------------------------------------------------------
	#print("[OK]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	print("[OK]: "+msg)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	#file.write("[OK]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	file.write("[OK]: %s\n" % msg)
	file.close()
	return;

# Add [TROUBLE]: to log file
def LogFileAddTrouble(LOG_FILE_0,msg):
	# "Add Trouble msg to log."
	#--------------------------------------------------------------------------------
	global VID_TO_CURATE
	VID_TO_CURATE = True
	#print("[TROUBLE]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	print("[TROUBLE]: "+msg)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	#file.write("[TROUBLE]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	file.write("\n[TROUBLE]: "+msg+"\n")
	file.close()
	return;

# Add [ERROR]: to log file
def LogFileAddError(LOG_FILE_0,msg):
	# "Add Error msg to log."
	#--------------------------------------------------------------------------------
	global VID_TO_CURATE
	VID_TO_CURATE = True
	#print("[ERROR]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	print("[ERROR]: "+msg)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	#file.write("[ERROR]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	file.write("\n[ERROR]: "+msg+"\n")
	file.close()
	return;

# Add [UPDATE]: to log file
def LogFileAddUpdate(LOG_FILE_0,msg):
	# "Add Update msg for when public IP has changed and host (A) record needs to be updated."
	#--------------------------------------------------------------------------------
	global VID_TO_CURATE
	VID_TO_CURATE = True
	#print("[UPDATE]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	print("[UPDATE]: "+msg)
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	#file.write("[UPDATE]: %s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	file.write("\n[UPDATE]: "+msg+"\n")
	file.close()
	return;

# End current log file operation
def LogFileEndFooter(LOG_FILE_0,msg=False,timestamp=True):
	#--------------------------------------------------------------------------------
	#print('\n')
	print('\nEnding log file operation.')
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	file.write("\nEnd operation: %s\n" % datetime.datetime.now())
	if ( msg != False ):
		file.write("Closing message: %s\n" % msg)
	file.close()
	if ( timestamp == True ):
		LogFileAddTimeStamp( LOG_FILE_0 )
	file = open(LOG_FILE_0,"a") # Here we use "a" for append
	file.write("--------------------------------------------------------------------------------\n")
	file.close()
	return

# End current log file operation
def LogFileEndOp(LOG_FILE_0,LOG_FILE_FULL_PATH,LOG_FILE_CURATED_PATH,VID_TO_CURATE,msg=False):
	# "Add Update msg for when public IP has changed and host (A) record needs to be updated."
	# To call this function:
	#LogFileEndOp(LOG_FILE_0,LOG_FILE_FULL_PATH,LOG_FILE_CURATED_PATH,VID_TO_CURATE)
	#LogFileEndOp(LOG_FILE_0,LOG_FILE_FULL_PATH,LOG_FILE_CURATED_PATH,VID_TO_CURATE,msg)
	#--------------------------------------------------------------------------------
	LogFileEndFooter(LOG_FILE_0,msg)
	
	LOG_FILE_TEMP = LOG_FILE_0
	
	LogFileCleanup(LOG_FILE_TEMP, LOG_FILE_FULL_PATH, LOG_FILE_CURATED_PATH, VID_TO_CURATE)
	
	#global VID_TO_CURATE
	#VID_TO_CURATE = False
	
	return

#/End Log file functions.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Call pif for public ip
def GetPublicIP(LOG_FILE_0):
	# To call this function:
	#public_ip = GetPublicIP(LOG_FILE_0)
	#--------------------------------------------------------------------------------
	
	import pif
	
	#what is my public ip?
	public_ip = pif.get_public_ip()
	
	msg = ("My public ip: {0}".format(public_ip))
	#logging.info(msg)
	LogFileAddURLCall(LOG_FILE_0,msg)
	
	return public_ip

# Call ip.42.pl for public ip
def GetPublicIPip42pl(LOG_FILE_0):
	"Calls ip.42.pl to query our public ip address."
	# To call this function:
	#GetPublicIPip42pl(LOG_FILE_0);
	#--------------------------------------------------------------------------------
	
	# Doesn't work anymore:
	#CURRENT_IP_ADDRESS_URL = 'http://whatismyip.akamai.com/'
	#get current IP address from CURRENT_IP_ADDRESS_URL
	#current = requests.get(CURRENT_IP_ADDRESS_URL).content
	
	# New methods:
	# https://stackoverflow.com/questions/9481419/how-can-i-get-the-public-ip-using-python2-7
	CURRENT_IP_ADDRESS_URL = 'http://ip.42.pl/raw'
	from urllib2 import urlopen
	current = urlopen(CURRENT_IP_ADDRESS_URL).read()
	print('Our Public IP = '+current)
	print('From site = '+CURRENT_IP_ADDRESS_URL)
	
	#msg = ("%s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current))
	LogFileAddURLCall(LOG_FILE_0,("%s Response: %s\n" % (CURRENT_IP_ADDRESS_URL, current)))
	
	print('Public IP address from '+CURRENT_IP_ADDRESS_URL+': %s' % current)
	#print('Public IP address from %s: %s' % (CURRENT_IP_ADDRESS_URL, current))
	return current, CURRENT_IP_ADDRESS_URL;

# Call NameSilo.com API for our public ip and current IP on A record
def GetPublicIPNameSilo(OUR_API_KEY,DOMAIN_NAME_TO_MAINTAIN):
	# To call this function:
	#GetPublicIPNameSilo();
	#--------------------------------------------------------------------------------
	
	OPERATION = 'dnsListRecords'
	print('\n2nd URL call: Sending "'+OPERATION+'" API request to NameSilo.com...')
	
	# Request Formatting:
	# https://www.namesilo.com/api/OPERATION?version=VERSION&type=TYPE&key=YOURAPIKEY
	#    https: All requests to the API must utilize https.
	#    OPERATION: To be replaced by the name of the specific operation you would like to execute.
	#    VERSION: To be replaced by the API version you would like to use. The current version is "1".
	#    TYPE: To be replaced by the format you would like to receive returned. The only current option is "xml".
	#    YOURAPIKEY: To be replaced by your unique API key. Visit the API Manager page within your account for details.
	
	#OPERATION = 'dnsListRecords'
	# View all of the current DNS records associated with the domain. You will need the "record_id" value to perform the dnsUpdateRecord and dnsDeleteRecord functions below. 
	# https://www.namesilo.com/api_reference.php#dnsListRecords
	# Sample Request:
	# https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=12345&domain=namesilo.com
	# Request Parameters:
	#    domain: The domain being requested
	
	RECORD_IP_ADDRESS_URL = 'https://www.namesilo.com/api/'+OPERATION+'?version=1&type=xml&key='+OUR_API_KEY+'&domain='+DOMAIN_NAME_TO_MAINTAIN
	
	#read xml file
	r = requests.get(RECORD_IP_ADDRESS_URL, allow_redirects=True)
	LogFileAddURLCall(LOG_FILE_0,("NameSilo.com API Operation: %s" % OPERATION))
	#LogFileAddUntaggedMsg(LOG_FILE_0,("Request: %s\n" % RECORD_IP_ADDRESS_URL))
	
	# Review HTTP response codes
	#https://2.python-requests.org//en/master/api/#requests.Response
	#https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
	if (r.status_code == 200):
		LogFileAddOK(LOG_FILE_0,('HTTP Response Success: %s %s' % (r.status_code, r.reason)))
		#print('[OK]: HTTP Response Success: 200 OK')
		# Use fnmatchcase for true/false response from fnmatch module. Use str() function for format status code as a string.
		#elif fnmatch.fnmatchcase(str(r.status_code), '2??'):
	elif (r.ok):
		LogFileAddOK(LOG_FILE_0,('HTTP Response Successful; Code: %s (%s)' % (r.status_code, r.reason)))
	else:
		LogFileAddTrouble(LOG_FILE_0,('HTTP Non-Terminating Response; Code: %s (%s)' % (r.status_code, r.reason)))
		#LogFileAddError(LOG_FILE_0,msg)
	
	#print('Namesilo response: %s' % r)
	#print('Any response code other than a 200 should be considered an error.')
	
	#print('(Verbose) Namesilo response:  \n'+r.content)
	print('Parsing XML response...')
	
	xml = ET.fromstring(r.content)
	
	#<namesilo>
	#	<request>
	#		<operation>dnsListRecords</operation>
	#		<ip>72.201.12.215</ip>
	#	</request>
	#	<reply>
	#		<code>300</code>
	#		<detail>success</detail>
	#		<resource_record>
	#			<record_id>4b01b24f13e10e02cf9f1f267c346b6a</record_id>
	#			<type>A</type>
	#			<host>rotteneggspda.com</host>
	#			<value>10.10.0.8</value>
	#			<ttl>3603</ttl>
	#			<distance>0</distance>
	#		</resource_record>
	#		<resource_record>
	#			<record_id>d941c9039afd155638a43ac4ac1f28a0</record_id>
	#			<type>A</type>
	#			<host>www.rotteneggspda.com</host>
	#			<value>72.201.12.215</value>
	#			<ttl>3600</ttl>
	#			<distance>0</distance>
	#		</resource_record>
	#	</reply>
	#</namesilo>
	
	# Get reply code: (300 = Successful API operation)
	for record in xml.iter('reply'):
		namesilo_response_code = record.find('code').text
		namesilo_response_details = record.find('detail').text
	# Use int() function to format var as integer
	if (int(namesilo_response_code) == 300):
		LogFileAddOK(LOG_FILE_0,('NameSilo API operation: '+namesilo_response_code+' ('+namesilo_response_details+')')) # 300 = Successful API operation
	elif fnmatch.fnmatchcase(namesilo_response_code, '30?'):
		LogFileAddOK(LOG_FILE_0,('NameSilo API operation: '+namesilo_response_code+' ('+namesilo_response_details+')')) # 300 = Successful API operation
	else:
		LogFileAddError(LOG_FILE_0,('NameSilo API error. Response code: '+namesilo_response_code+' ('+namesilo_response_details+')'))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Reference: \nhttps://www.namesilo.com/api_reference.php#dnsListRecords\n"))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Request URL: \n%s\n" % RECORD_IP_ADDRESS_URL))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Response: \n%s\n" % r))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Full Response: \n%s\n\n" % r.content))
	
	# Get our Public IP from NameSilo response:
	for record in xml.iter('request'):
		current_namesilo = record.find('ip').text
	
	LogFileAddUntaggedMsg(LOG_FILE_0,('Public IP address from NameSilo.com: %s' % current_namesilo))
	
	return current_namesilo, xml

# Get extra info from the xml object from NameSilo API call
def GetExtraInfoNameSilo(xml):
	# To call this function:
	#GetExtraInfoNameSilo(xml);
	#--------------------------------------------------------------------------------
	
	# Parse XML response to Get domain.tld details (DOMAIN_NAME_TO_MAINTAIN)
	for record in xml.iter('resource_record'):
		#read host, value, and record_id from current record in xml
		if (record.find('host').text.lower() == DOMAIN_NAME_TO_MAINTAIN.lower()):
			shortdomain_host = record.find('host').text
			shortdomain_IPvalue = record.find('value').text
			shortdomain_record_id = record.find('record_id').text
	try:
		shortdomain_host
	except:
		LogFileAddError(LOG_FILE_0,('Find short domain hostname '+shortdomain_host+'+ ('+DOMAIN_NAME_TO_MAINTAIN+') = FAIL'))
	#else:
	#	LogFileAddOK(LOG_FILE_0,('(Verbose) Short domain hostname: '+shortdomain_host))
	
	try:
		shortdomain_IPvalue
	except:
		LogFileAddError(LOG_FILE_0,('Find short domain IP on record ('+shortdomain_IPvalue+') = FAIL'))
	#else:
	#	LogFileAddOK(LOG_FILE_0,('(Verbose) Short domain IP on record: '+shortdomain_IPvalue))
	
	try:
		shortdomain_record_id
	except:
		LogFileAddError(LOG_FILE_0,('Find short domain record ID ('+shortdomain_record_id+') = FAIL'))
	#else:
	#	LogFileAddOK(LOG_FILE_0,('(Verbose) Short domain record ID: '+shortdomain_record_id))
	
	LogFileAddUntaggedMsg(LOG_FILE_0,('==> '+shortdomain_host+' Current IP address on record with NameSilo: %s' % shortdomain_IPvalue))
	
	# Parse XML response to Get sub.domain.tld details (SUB_DOMAIN_TLD)
	for record in xml.iter('resource_record'):
		#read host, value, and record_id from current record in xml
		host = record.find('host').text
		value = record.find('value').text
		record_id = record.find('record_id').text
		if (record.find('host').text.lower() == SUB_DOMAIN_TLD.lower()):
			subdomain_host = record.find('host').text
			subdomain_IPvalue = record.find('value').text
			subdomain_record_id = record.find('record_id').text
	try:
		subdomain_host
	except:
		LogFileAddError(LOG_FILE_0,('Find sub domain hostname '+subdomain_host+' ('+SUB_DOMAIN_TLD+') = FAIL'))
	#else:
	#	LogFileAddOK(LOG_FILE_0,('(Verbose) Sub domain hostname: '+subdomain_host))
	
	try:
		subdomain_IPvalue
	except:
		LogFileAddError(LOG_FILE_0,('Find sub domain IP on record ('+subdomain_IPvalue+') = FAIL'))
	#else:
	#	LogFileAddOK(LOG_FILE_0,('[OK]: (Verbose) Sub domain IP on record: '+subdomain_IPvalue))
	
	try:
		subdomain_record_id
	except:
		LogFileAddError(LOG_FILE_0,('Find sub domain record ID ('+subdomain_record_id+') = FAIL'))
	#else:
	#	LogFileAddOK(LOG_FILE_0,('[OK]: (Verbose) Sub domain record ID: '+subdomain_record_id))
	
	LogFileAddUntaggedMsg(LOG_FILE_0,('==> '+subdomain_host+' Current IP address on record with NameSilo: %s' % subdomain_IPvalue))
	
	return shortdomain_host, shortdomain_IPvalue, shortdomain_record_id, subdomain_host, subdomain_IPvalue, subdomain_record_id;

# Call GoDaddy for public ip & DNS
def GetPublicIPGoDaddy(api_key,secret_key,domain_name,subdomain=False):
	# To call this function:
	#GetPublicIPGoDaddy();
	#--------------------------------------------------------------------------------
	
	return

def DynDNSUpdateNameSilo(LOG_FILE_0,domain_host,IPvalue,record_id,API_KEY,DNS_RECORD_TTL,subdomainname=False):
	# To call this function:
	#DynDNSUpdateNameSilo();
	#--------------------------------------------------------------------------------
	
	OPERATION = 'dnsUpdateRecord'
	
	# Request Formatting:
	# https://www.namesilo.com/api/OPERATION?version=VERSION&type=TYPE&key=YOURAPIKEY
	#    https: All requests to the API must utilize https.
	#    OPERATION: To be replaced by the name of the specific operation you would like to execute.
	#    VERSION: To be replaced by the API version you would like to use. The current version is "1".
	#    TYPE: To be replaced by the format you would like to receive returned. The only current option is "xml".
	#    YOURAPIKEY: To be replaced by your unique API key. Visit the API Manager page within your account for details.
	
	#OPERATION = 'dnsUpdateRecord'
	# Update an existing DNS resource record.
	# https://www.namesilo.com/api_reference.php#dnsUpdateRecord
	# Sample Request:
	# https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=12345&domain=namesilo.com&rrid=1a2b3&rrhost=test&rrvalue=55.55.55.55&rrttl=7207 
	# Request Parameters:
	#    domain: The domain associated with the DNS resource record to modify
	#    rrid: The unique ID of the resource record. You can get this value using dnsListRecords.
	#    rrhost: The hostname to use (there is no need to include the ".DOMAIN")
	#    rrvalue: The value for the resource record
	#        A - The IPV4 Address
	#        AAAA - The IPV6 Address
	#        CNAME - The Target Hostname
	#        MX - The Target Hostname
	#        TXT - The Text
	#    rrdistance: Only used for MX (default is 10 if not provided)
	#    rrttl: The TTL for this record (default is 7207 if not provided)
	
	if (subdomainname == False):
		LogFileAddUpdate(LOG_FILE_0,('Sending '+OPERATION+' API request to update = '+domain_host))
		
		new_URL = 'https://www.namesilo.com/api/'+OPERATION+'?version=1&type=xml&key='+API_KEY+'&domain='+domain_host.lower()+'&rrid='+record_id+'&rrvalue='+IPvalue+'&rrttl=%s' % DNS_RECORD_TTL
	else:
		LogFileAddUpdate(LOG_FILE_0,('Sending '+OPERATION+' API request to update = '+subdomainname+'.'+domain_host))
		
		new_URL = 'https://www.namesilo.com/api/'+OPERATION+'?version=1&type=xml&key='+API_KEY+'&domain='+domain_host.lower()+'&rrid='+record_id+'&rrhost='+subdomainname.lower()+'&rrvalue='+IPvalue+'&rrttl=%s' % DNS_RECORD_TTL
	
	# Bugfix: Use `'It will cost $%d dollars.' % 95` method to concatenate string with TTL to avoid `TypeError: cannot concatenate 'str' and 'int' objects`
	
	print('DNS Update request: %s' % new_URL)
	
	print('Sending update URL.')
	
	LogFileAddURLCall(LOG_FILE_0,("NameSilo.com API Operation: %s" % OPERATION))
	
	#send request to URL
	new = requests.get(new_URL)
	
	# Review HTTP response codes
	#https://2.python-requests.org//en/master/api/#requests.Response
	#https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
	if (new.status_code == 200):
		LogFileAddOK(LOG_FILE_0,('HTTP Response Success: %s %s' % (new.status_code, new.reason)))
		#print('[OK]: HTTP Response Success: 200 OK')
		# Use fnmatchcase for true/false response from fnmatch module. Use str() function for format status code as a string.
		#elif fnmatch.fnmatchcase(str(new.status_code), '2??'):
	elif (new.ok):
		LogFileAddOK(LOG_FILE_0,('HTTP Response Successful; Code: %s (%s)' % (new.status_code, new.reason)))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Request URL: \n%s\n" % new_URL))
	else:
		LogFileAddTrouble(LOG_FILE_0,('HTTP Non-Terminating Response; Code: %s (%s)\n' % (new.status_code, new.reason)))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Request URL: \n%s\n" % new_URL))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Response: \n%s\n" % new))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Full Response: \n%s\n" % new.content))
	
	# Review NameSilo API response
	print('Parsing XML response...')
	
	xml = ET.fromstring(new.content)
	
	#Sample response:
	
	#<namesilo>
	#    <request>
	#        <operation>dnsUpdateRecord</operation>
	#        <ip>55.555.55.55</ip>
	#    </request>
	#    <reply>
	#        <code>300</code>
	#        <detail>success</detail>
	#        <record_id>1a2b3c4d5e</record_id>
	#    </reply>
	#</namesilo>
	
	# Get reply code: (300 = Successful API operation)
	for record in xml.iter('reply'):
		namesilo_response_code = record.find('code').text
		namesilo_response_details = record.find('detail').text
	# Use int() function to format var as integer
	if (int(namesilo_response_code) == 300):
		LogFileAddOK(LOG_FILE_0,('NameSilo API operation: '+namesilo_response_code+' ('+namesilo_response_details+')')) # 300 = Successful API operation
		# Use fnmatchcase for true/false response from fnmatch module. Use str() function for format status code as a string.
	elif fnmatch.fnmatchcase(namesilo_response_code, '30?'):
		LogFileAddOK(LOG_FILE_0,('NameSilo API operation: '+namesilo_response_code+' ('+namesilo_response_details+')')) # 300 = Successful API operation
	else:
		LogFileAddError(LOG_FILE_0,('NameSilo API error. Response code: '+namesilo_response_code+' ('+namesilo_response_details+')\n'))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Reference: \nhttps://www.namesilo.com/api_reference.php#dnsUpdateRecord\n"))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Request URL: \n%s\n" % new_URL))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Response: \n%s\n" % new))
		LogFileAddUntaggedMsg(LOG_FILE_0,("Full Response: \n%s\n\n" % new.content))
	
	return

def DynDNSUpdateGoDaddy(LOG_FILE_0,paramsGoDaddy,public_ip=False):
	# Source: https://github.com/johanreinalda/godaddy_dynamic_dns
	# To call this function:
	#DynDNSUpdateGoDaddy();
	#--------------------------------------------------------------------------------
	#!/usr/bin/python
	#import sys, argparse, logging, pif, smtplib, urllib
	#from pygodaddy import GoDaddyClient
	# Import the email modules we'll need
	#from email.mime.text import MIMEText
	
	#this contain the config file
	#import godaddy
	
	#command line arguments parsing
	#parser = argparse.ArgumentParser('A Python script to do updates to a GoDaddy DNS host A record')
	#parser.add_argument('-v', '--verbose', action='store_true', help="send emails on 'no ip update required'")
	#args = parser.parse_args()
	
	#start log file
	#logging.basicConfig(filename=paramsGoDaddy.logfile, format='%(asctime)s %(message)s', level=logging.INFO)
	
	#--------------------------------------------------------------------------------
	
	#what is my public ip?
	if (public_ip == False):
		public_ip = GetPublicIP(LOG_FILE_0)
	
	#--------------------------------------------------------------------------------
	
	# API keys method:
	
	# Set as either "XML" or "JSON"
	RESPONSE_FORMAT="XML"
	
	#https://developer.godaddy.com/doc/endpoint/domains#/v1/recordGet
	ote_url = "https://api.ote-godaddy.com/"
	prod_url = "https://api.godaddy.com/"
	recordtype = 'A'
	recordlimit = False
	#recordlimit = 7
	
	#api_url = ote_url
	#api_url = prod_url
	# Environment: 'PROD' or 'OTE'
	if (paramsGoDaddy.GODADDY_ENV == 'PROD'):
		api_url = prod_url
	elif (paramsGoDaddy.GODADDY_ENV == 'OTE'):
		api_url = ote_url
	else:
		LogFileAddError(LOG_FILE_0,('Problem choosing paramsGoDaddy.py GODADDY_ENV variable, should be either PROD or OTE:'+paramsGoDaddy.GODADDY_ENV))
		api_url = prod_url
		LogFileAddError(LOG_FILE_0,('Defaulting to GoDaddy PROD API: '+api_url))
	
	#https://api.ote-godaddy.com/v1/domains/domain.com/records/A/%40?limit=7
	#url_encoded = urllib.urlencode(paramsGoDaddy.GODADDY_SUBDOMAIN)
	#url_encoded = urllib.quote(paramsGoDaddy.GODADDY_SUBDOMAIN)
	
	#https://www.w3schools.com/tags/ref_urlencode.asp
	url_encoded = (paramsGoDaddy.GODADDY_SUBDOMAIN).replace('@','%40')
	
	if (recordlimit != False):
		full_url = api_url+'v1/domains/'+paramsGoDaddy.GODADDY_DOMAIN+'/records/'+recordtype+'/'+url_encoded+'?limit='+str(recordlimit)
	else:
		full_url = api_url+'v1/domains/'+paramsGoDaddy.GODADDY_DOMAIN+'/records/'+recordtype+'/'+url_encoded
	#/v1/domains/{domain}/records/{type}/{name}
	#"https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}"
	godaddy_api_auth = ("%s:%s" % (paramsGoDaddy.GODADDY_API_KEY,paramsGoDaddy.GODADDY_API_SECRET))
	#dnsdata=`curl -s -X GET -H "Authorization: sso-key ${gdapikey}" "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}"`
	
	#--------------------------------------------------------------------------------
	
	# Send API request; receive response:
	
	#-H 'accept: application/json' \
	#-H 'Authorization: sso-key UzQxLikm_46KxDFnbjN7cQjmw6wocia:46L26ydpkwMaKZV6uVdDWe'
	#"accept": "application/json"
	#"accept": "application/xml"
	#"accept": "text/xml"
	
	if (RESPONSE_FORMAT == "JSON"):
		#data = {
		#	"Authorization": ("sso-key %s:%s" % (paramsGoDaddy.GODADDY_API_KEY,paramsGoDaddy.GODADDY_API_SECRET)),
		#	"accept": "application/json"
		#}
		data = {
			"Authorization": ("sso-key %s" % (godaddy_api_auth)),
			"accept": "application/json"
		}
		LogFileAddURLCall(LOG_FILE_0,("GoDaddy.com JSON API Operation: %s" % full_url))
		json_response = requests.get(full_url,headers=data)
	elif (RESPONSE_FORMAT == "XML"):
		#data = {
		#	"Authorization": ("sso-key %s:%s" % (paramsGoDaddy.GODADDY_API_KEY,paramsGoDaddy.GODADDY_API_SECRET)),
		#	"accept": "application/xml"
		#}
		data = {
			"Authorization": ("sso-key %s" % (godaddy_api_auth)),
			"accept": "application/xml"
		}
		LogFileAddURLCall(LOG_FILE_0,("GoDaddy.com XML API Operation: %s" % full_url))
		xml_response = requests.get(full_url,headers=data)
	
	#--------------------------------------------------------------------------------
	
	# Review HTTP response codes
	#https://2.python-requests.org//en/master/api/#requests.Response
	#https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
	if (RESPONSE_FORMAT == "JSON"):
		if (json_response.status_code == 200):
			LogFileAddOK(LOG_FILE_0,('GoDaddy HTTP Response Success: %s %s' % (json_response.status_code, json_response.reason)))
			#print('[OK]: HTTP Response Success: 200 OK')
			# Use fnmatchcase for true/false response from fnmatch module. Use str() function for format status code as a string.
			#elif fnmatch.fnmatchcase(str(json_response.status_code), '2??'):
		elif (json_response.ok):
			LogFileAddOK(LOG_FILE_0,('GoDaddy HTTP Response Successful; Code: %s (%s)' % (json_response.status_code, json_response.reason)))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Request URL: \n%s\n" % full_url))
		else:
			LogFileAddTrouble(LOG_FILE_0,('GoDaddy HTTP Non-Terminating Response; Code: %s (%s)\n' % (json_response.status_code, json_response.reason)))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Request URL: \n%s\n" % full_url))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Response: \n%s\n" % json_response))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Full Response: \n%s\n" % json_response.content))
	elif (RESPONSE_FORMAT == "XML"):
		if (xml_response.status_code == 200):
			LogFileAddOK(LOG_FILE_0,('GoDaddy HTTP Response Success: %s %s' % (xml_response.status_code, xml_response.reason)))
			#print('[OK]: HTTP Response Success: 200 OK')
			# Use fnmatchcase for true/false response from fnmatch module. Use str() function for format status code as a string.
			#elif fnmatch.fnmatchcase(str(xml_response.status_code), '2??'):
		elif (xml_response.ok):
			LogFileAddOK(LOG_FILE_0,('GoDaddy HTTP Response Successful; Code: %s (%s)' % (xml_response.status_code, xml_response.reason)))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Request URL: \n%s\n" % full_url))
		else:
			LogFileAddTrouble(LOG_FILE_0,('GoDaddy HTTP Non-Terminating Response; Code: %s (%s)\n' % (xml_response.status_code, xml_response.reason)))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Request URL: \n%s\n" % full_url))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Response: \n%s\n" % xml_response))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Full Response: \n%s\n" % xml_response.content))
		print('xml_response type: ')
		print(type(xml_response))
	
	#--------------------------------------------------------------------------------
	
	# Review GoDaddy API response
	
	if (RESPONSE_FORMAT == "JSON"):
		# Review GoDaddy API response
		print('Parsing JSON response...')
		#json = ET.fromstring(json_response.content)
		print(json.dumps((json_response.content), sort_keys=True, indent=4))
		
		print('Parsing JSON response...')
		print(json.loads((json_response.content)))
		
		print('Parsing JSON response...')
		print(json.JSONDecoder((json_response.content)))
		
	elif (RESPONSE_FORMAT == "XML"):
		# Review GoDaddy API response
		print('Parsing XML response...')
		xml = ET.fromstring(xml_response.content)
		#print('0 :')
		#print(xml_response.content)
		#<response><result><data>455.251.170.100</data><name>@</name><ttl>1800</ttl><type>A</type></result></response>
		#Sample response:
		#<response>
		#	<result>
		#		<data>
		#			455.251.170.100
		#		</data>
		#		<name>
		#			@
		#		</name>
		#		<ttl>
		#			1800
		#		</ttl>
		#		<type>
		#			A
		#		</type>
		#	</result>
		#</response>
		
		#print('4 :')
		for result in xml.iter("result"):
			print (result.find('data').text)
			print (result.find('name').text)
			print (result.find('ttl').text)
			print (result.find('type').text)
			GODADDY_CURRENT_IP = (result.find('data').text)
			GODADDY_CURRENT_TTL = (result.find('ttl').text)
	
	UPDATE_RECORD = "False"
	if ( GODADDY_CURRENT_IP != public_ip ):
		UPDATE_RECORD = "True"
		LogFileAddUpdate(LOG_FILE_0,('Public IP (%s) no longer matches GoDaddy %s domain IP (%s)' % (public_ip, paramsGoDaddy.GODADDY_DOMAIN, GODADDY_CURRENT_IP)))
	else:
		LogFileAddOK(LOG_FILE_0,('IP matches GoDaddy record: %s' % (GODADDY_CURRENT_IP)))
	
	if ( ("%s" % GODADDY_CURRENT_TTL) != ("%s" % paramsGoDaddy.DNS_RECORD_TTL) ):
		UPDATE_RECORD = "True"
		LogFileAddUpdate(LOG_FILE_0,('Set TTL value (%s) does not match the GoDaddy %s domain record TTL (%s)' % (paramsGoDaddy.DNS_RECORD_TTL, paramsGoDaddy.GODADDY_DOMAIN, GODADDY_CURRENT_TTL)))
	else:
		LogFileAddOK(LOG_FILE_0,('TTL matches: %s = %s' % (GODADDY_CURRENT_TTL, paramsGoDaddy.DNS_RECORD_TTL)))
	
	#--------------------------------------------------------------------------------
	
	# Update record via GoDaddy API:
	
	#https://developer.godaddy.com/doc/endpoint/domains#/v1/recordReplaceTypeName
	if ( UPDATE_RECORD == "True" ):
		
		#curl -X 'PUT' \
		#  'https://api.ote-godaddy.com/v1/domains/example.com/records/A/%40' \
		#  -H 'accept: application/json' \
		#  -H 'Content-Type: application/json' \
		#  -H 'Authorization: sso-key UzQxLikm_46KxDFnbjN7cQjmw6wocia:46L26ydpkwMaKZV6uVdDWe' \
		#  -d '[
		#  {
		#    "data": "string",
		#    "port": 65535,
		#    "priority": 0,
		#    "protocol": "string",
		#    "service": "string",
		#    "ttl": 0,
		#    "weight": 0
		#  }
		#]'
		
		headers_dat = {
			'accept': 'application/json',
			'Content-Type': 'application/json',
			'Authorization': ('sso-key %s' % (godaddy_api_auth))
		}
		
		#print(json.dumps(json_dat))
		#print(json.dumps({"data": ("%s" % (public_ip))}))
		#json_dat = json.dumps(json_dat)
		
		# Thanks to this site for finally helping me get the right requests.put() format working:
		#https://curlconverter.com/
		json_data = [
			{
				'data': ('%s' % (public_ip)),
				'ttl': (paramsGoDaddy.DNS_RECORD_TTL),
			},
		]
		
		LogFileAddURLCall(LOG_FILE_0,("GoDaddy.com PUT API call: %s" % full_url))
		
		put_response = requests.put(full_url, headers=headers_dat, json=json_data)
		# Note: json_data will not be serialized by requests
		# exactly as it was in the original request.
		#data = '[\n  {\n    "data": "string"\n  }\n]'
		#response = requests.put('https://api.ote-godaddy.com/v1/domains/rotten-eggs.com/records/A/%40', headers=headers, data=data)
		
		if (put_response.status_code == 200):
			LogFileAddOK(LOG_FILE_0,('GoDaddy HTTP Response Success: %s %s' % (put_response.status_code, put_response.reason)))
			#print('[OK]: HTTP Response Success: 200 OK')
			# Use fnmatchcase for true/false response from fnmatch module. Use str() function for format status code as a string.
			#elif fnmatch.fnmatchcase(str(put_response.status_code), '2??'):
		elif (put_response.ok):
			LogFileAddOK(LOG_FILE_0,('GoDaddy HTTP Response Successful; Code: %s (%s)' % (put_response.status_code, put_response.reason)))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Request URL: \n%s\n" % full_url))
		else:
			LogFileAddTrouble(LOG_FILE_0,('GoDaddy HTTP Non-Terminating Response; Code: %s (%s)\n' % (put_response.status_code, put_response.reason)))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Request URL: \n%s\n" % full_url))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Response: \n%s\n" % put_response))
			LogFileAddUntaggedMsg(LOG_FILE_0,("GoDaddy Full Response: \n%s\n" % put_response.content))
	
	return

# /Functions:
# =========================================================================================================
# Main:

#Index:
# 1. Imports & set vars -----------------------------------------------------------------------------------
# 2. Create log file if it doesn't exist ------------------------------------------------------------------
# 3. 1st URL call: Get our Public IP ----------------------------------------------------------------------
# 4. 2nd URL call: Get NameSilo's IP for our domain name --------------------------------------------------
# 5. Examine & Compare Responses --------------------------------------------------------------------------
# 6. 3rd (possible) URL call: Set NameSilo's IP for our domain name ---------------------------------------
# 7. Check GoDaddy domain DNS record ----------------------------------------------------------------------


# 1. Imports & set vars -----------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------

# 2. Create & setup log file if it doesn't exist ------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------

LOG_FILE_0, LOG_FILE_FULL_PATH, LOG_FILE_CURATED_PATH, VID_TO_CURATE = LogFileInit()

# 3. 1st URL call: Get our Public IP ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------
print('\n1st URL call: Getting current public IP address...')

public_ip = GetPublicIP(LOG_FILE_0)

current, CURRENT_IP_ADDRESS_URL = GetPublicIPip42pl(LOG_FILE_0);

# 3. 1st URL call: Get our Public IP ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------



print('testing socket ....')
addr = 'google.com'
print(addr)
ipv4 = socket.gethostbyname(addr)
print(ipv4)

addr = 'yahoo.com'
print(addr)
ipv4 = socket.gethostbyname(addr)
print(ipv4)


# 4. 2nd URL call: Get NameSilo's IP for our domain name --------------------------------------------------
# ---------------------------------------------------------------------------------------------------------
print('\n2nd URL call: Sending get public IP API request to NameSilo.com...')

current_namesilo, xml = GetPublicIPNameSilo(OUR_API_KEY,DOMAIN_NAME_TO_MAINTAIN);

# 5. Examine & Compare Responses --------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------

# Check we're getting the same IP response from all sources
if (current == current_namesilo):
	LogFileAddOK(LOG_FILE_0,(CURRENT_IP_ADDRESS_URL+' and NameSilo.com public IP responses match.'))
else:
	LogFileAddTrouble(LOG_FILE_0,(CURRENT_IP_ADDRESS_URL+' and NameSilo.com public IP responses do NOT match.'))
	LogFileAddUntaggedMsg(LOG_FILE_0,('         '+current+'   '+CURRENT_IP_ADDRESS_URL))
	LogFileAddUntaggedMsg(LOG_FILE_0,('         '+current_namesilo+'  NameSilo.com\n'))

if (current == public_ip):
	LogFileAddOK(LOG_FILE_0,(CURRENT_IP_ADDRESS_URL+' and pif public IP responses match.'))
else:
	LogFileAddTrouble(LOG_FILE_0,(CURRENT_IP_ADDRESS_URL+' and pif public IP responses do NOT match.'))
	LogFileAddUntaggedMsg(LOG_FILE_0,('         '+current+'   '+CURRENT_IP_ADDRESS_URL))
	LogFileAddUntaggedMsg(LOG_FILE_0,('         '+public_ip+'  pif\n'))

if (public_ip == current_namesilo):
	LogFileAddOK(LOG_FILE_0,('pif and NameSilo.com public IP responses match.'))
else:
	LogFileAddTrouble(LOG_FILE_0,('pif and NameSilo.com public IP responses do NOT match.'))
	LogFileAddUntaggedMsg(LOG_FILE_0,('         '+public_ip+'   pif'))
	LogFileAddUntaggedMsg(LOG_FILE_0,('         '+current_namesilo+'  NameSilo.com\n'))

# 6. 3rd (possible) URL call: Set NameSilo's IP for our domain name ---------------------------------------
# ---------------------------------------------------------------------------------------------------------
print('\n3rd (possible) URL call: Sending API request(s) to NameSilo.com...')

# Get extra info from the XML var returned in the NameSilo API call:
shortdomain_host, shortdomain_IPvalue, shortdomain_record_id, subdomain_host, subdomain_IPvalue, subdomain_record_id = GetExtraInfoNameSilo(xml)

def NameSiloShortDomain():
	LogFileAddUntaggedMsg(LOG_FILE_0,('Current IP:      '+current_namesilo))
	LogFileAddUntaggedMsg(LOG_FILE_0,('NameSilo record: '+shortdomain_IPvalue))
	DynDNSUpdateNameSilo(LOG_FILE_0,shortdomain_host,current_namesilo,shortdomain_record_id,OUR_API_KEY,DNS_RECORD_TTL)

if (FORCE_TESTING == True):
	LogFileAddUpdate(LOG_FILE_0,('FORCE TESTING: Forcing the API call to update DNS record. '+shortdomain_host))
	NameSiloShortDomain()
else:
	LogFileAddUntaggedMsg(LOG_FILE_0,('==> Checking '+shortdomain_host+' ...'))
	if (shortdomain_IPvalue == current_namesilo):
		LogFileAddOK(LOG_FILE_0,('Current IP address matches namesilo record. No need to update.'))
		LogFileAddOK(LOG_FILE_0,(shortdomain_host+' = namesilo record: '+shortdomain_IPvalue+' = public IP (namesilo): '+current_namesilo+' = public IP ('+CURRENT_IP_ADDRESS_URL+'): '+current+'\n'))
	else:
		LogFileAddUpdate(LOG_FILE_0,('IP addresses do not match, generating URL to update.'))
		NameSiloShortDomain()

def NameSiloSubDomain():
	LogFileAddUntaggedMsg(LOG_FILE_0,('Current IP:      '+current_namesilo))
	LogFileAddUntaggedMsg(LOG_FILE_0,('NameSilo record: '+subdomain_IPvalue))
	DynDNSUpdateNameSilo(LOG_FILE_0,shortdomain_host,current_namesilo,subdomain_record_id,OUR_API_KEY,DNS_RECORD_TTL,SUBDOMAIN_NAME)

if (FORCE_TESTING == True):
	LogFileAddUpdate(LOG_FILE_0,('FORCE TESTING: Forcing the API call to update DNS record. '+subdomain_host))
	NameSiloSubDomain()
else:
	LogFileAddUntaggedMsg(LOG_FILE_0,('==> Checking '+subdomain_host+' ...'))
	if (subdomain_IPvalue == current_namesilo):
		LogFileAddOK(LOG_FILE_0,('Current IP address matches namesilo record. No need to update.'))
		LogFileAddOK(LOG_FILE_0,(subdomain_host+' = namesilo record: '+subdomain_IPvalue+' = public IP (namesilo): '+current_namesilo+' = public IP ('+CURRENT_IP_ADDRESS_URL+'): '+current+'\n'))
	else:
		LogFileAddUpdate(LOG_FILE_0,('IP addresses do not match, generating URL to update.'))
		NameSiloSubDomain()

# 7. Check GoDaddy domain DNS record ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------
print('\nCheck GoDaddy domain DNS record against current IP')

DynDNSUpdateGoDaddy(LOG_FILE_0,paramsGoDaddy,public_ip)

# /Main
# ---------------------------------------------------------------------------------------------------------
# Footer:
LogFileEndOp(LOG_FILE_0,LOG_FILE_FULL_PATH,LOG_FILE_CURATED_PATH,VID_TO_CURATE)
print('\nEnd NameSilo dynamic-DNS script.')
# /Footer
# ---------------------------------------------------------------------------------------------------------

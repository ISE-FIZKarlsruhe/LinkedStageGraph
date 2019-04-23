#!/usr/bin/python
# -*- coding: utf-8 -*-

lines = open('origin/labw_2_2039.xml').read().split('\n')

lastline = ""

def doit(text):
	text = text.replace('<eadid mainagencycode="DE-1951" url="http://www.landesarchiv-bw.de">labw-2-2039</eadid>', '<eadid mainagencycode="1951" url="http://www.landesarchiv-bw.de">labw-2-2039</eadid>' ) 	
	text = text.replace('xmlns="urn:isbn:1-931666-22-9"', ' ')
	text = text.replace('<unitid>', '<unitid repositorycode="1951" countrycode="DE">')
	text = text.replace('{E', 'E')		
	text = text.replace('}</unitid>', '</unitid>')	
	text = text.replace('<repository>','<unitid repositorycode="1951" countrycode="DE">Landesarchiv Baden-Württemberg</unitid>\n<repository>')
	return text

for line in lines:	
	print doit(line)
	if lastline.strip()=="<did>" and line.strip().find("<unittitle>")==0:			
		print doit(line.replace("<unittitle>", "<unitid>").replace("</unittitle>", "</unitid>"))
		
	lastline = line
#!/usr/bin/python
# -*- coding: utf-8 -*-
import json,urllib, string, re, os, sys
from sets import Set

# data.json = output of following query
'''  
select distinct * 
where  {
optional {?s <http://purl.org/dc/terms/title> ?t .}
optional {?s <http://purl.org/dc/terms/description> ?d .}
}
'''

url = "http://slod.fiz-karlsruhe.de/sparql?default-graph-uri=&query=select+distinct+*+from+%3Chttp%3A%2F%2Fslod.fiz-karlsruhe.de%2F%3E%0D%0Awhere++%7B%0D%0Aoptional+%7B%3Fs+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2Ftitle%3E+%3Ft+.%7D%0D%0Aoptional+%7B%3Fs+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2Fdescription%3E+%3Fd+.%7D%0D%0A%7D&should-sponge=&format=application%2Fsparql-results%2Bjson&timeout=0&debug=on&run=+Run+Query+"
response = urllib.urlopen(url)


genres = [u'Ballett',u'Bleistiftzeichnung',u'Bühnenbilder',u'Bürgerliches Trauerspiel',u'Dramatische Dichtung',u'Fotografien',u'Fotos ',u'Inszenierungsfotos',u'Intermezzo in einem Akt',u'Komische Oper',u'Komödie',u'Konzert',u'Kriminalkomödie',u'Legendenspiel mit Musik',u'Lobgedicht',u'Lustspiel',u'Lyrische Komödie',u'Lyrisches Drama',u'Märchen',u'Märchenspiel',u'Melodrama',u'Moritat',u'Musikalisches Lustspiel',u'Musikalisches Schauspiel',u'Musikmärchen',u'Oper',u'Opera seria',u'Operette',u'Papierabzug',u'Porträt',u'Posse mit Gesang',u'Postkarten',u'Romantische Komödie',u'Romantische Oper',u'Schauspiel',u'Schwank',u'Singspiel',u'Tragisches Drama',u'Tragödie',u'Trauerspiel',u'Volkssingspiel',u'Volksstück',u'Weihnachtsmärchen',u'Zeitungsausschnitte']

performance = [u'Erstaufführung',u'Gastspiel',u'Neueinstudierung',u'Neuinszenierung',u'Programmzeitschrift',u'Repertoire',u'Repertoirestück',u'Uraufführung',u'Wiederaufnahme']

jobprops = {u'Bühnenbild': u'http://dbpedia.org/ontology/setDesigner', u'Choreographie': u'http://d-nb.info/standards/elementset/gnd#choreographer',  u'Fotograf': u'http://schema.org/creator', u'Inszenierung': u'http://schema.org/producer', u'Regie':u'http://schema.org/director', u'Spielleitung':u'http://schema.org/director', u'Kostüm':u'http://dbpedia.org/ontology/costumeDesigner', u'Tanz':u'http://schema.org/performer', u'Musikalische Leitung':u'http://id.loc.gov/vocabulary/relators/msd', u'Bühnenmusik':u'http://id.loc.gov/vocabulary/relators/msd'}

data = json.loads(response.read())
operasdata = json.loads(open('operas.json').read())

def getPersons():
	p = {}
	
	for f in os.listdir('persons'):
		if f.endswith('json'):
			pdata = json.loads(open('persons/' + f).read())
			#print 'pdata', len(pdata), len(p)
			for item in pdata:
				lkey=""
				rkey=""
				#print item
				for k in item.keys():
					if k != "work"  and k != "title":
						if k.find('label')>-1:
							lkey= k
						else:
							rkey= k
				#print item[rkey],  item[lkey]	
				p[item[lkey]]=item[rkey]
			#break		
	return p

persons = getPersons()
#print "persons:", len(persons)

#exit()

operas = {}

for item in operasdata:
	operas[item['title']]=item['work']

def mapPerson(t):
	if t in persons.keys():
		return persons[t]
	return ""

def mapOpera(t):
	if t in operas.keys():
		return operas[t]
	return ""

titles = {}
addendums = {}
abstracts = {}

def detectAndCleanRole(t):
	if (t.find('Musik')>-1):
		return 'music', t.replace('Musik','').strip().strip(':').strip()
	if (t.find('Texte')>-1):
		return 'text', t.replace('Texte','').strip().strip(':').strip()
	if (t.find('Text')>-1):
		return 'text', t.replace('Text','').strip().strip(':').strip()
	if (t.find('Libretto')>-1):
		return 'libretto', t.replace('Libretto','').strip().strip(':').strip()
	return None, t
	
	
def clearup(s, chars):
	t = re.sub('[%s]' % chars, '', s)			
	return t.strip()

def appendtitle(t, u):
	if t in titles.keys():
		titles[t].append(u)
	else:
		titles[t]=[u]	
		
		
def appendAdd(a, u):
	if a in addendums.keys():
		addendums[a].append(u)
	else:
		addendums[a]=[u]	

def analyze_title(title, uri):
	if not "(" in title:
		appendtitle(clearup(title,  string.punctuation+string.digits), uri)						
	else:
		actual_title = title[:title.find('(')]
		#print actual_title
		appendtitle(clearup(actual_title,  string.punctuation+string.digits), uri)						
		addendum = title[title.find('(')+1:].strip(')')
		#print "--->", addendum
		if "/" in addendum:
			for t in addendum.split('/'):
				appendAdd(t, uri)
		else:
	 		appendAdd(addendum, uri)


for item in data['results']['bindings'][:]:
	resourceURI = item['s']['value']
	title = item['t']['value']
	if 'd' in item.keys():
		abstracts[resourceURI]=item['d']['value']
	
	analyze_title(title, resourceURI)

def getGenres(text):
	G=[]	
	for g in genres:		
		if text.find(g) > -1 :
			G.append(g)
	return G	
	
def getTypeOfPerformance(text):
	P=[]	
	for p in performance:
		if text.find(p) > -1 :
			P.append(p)
	return P	
	
def getJob(text):
	for k in jobprops.keys():
		if text.find(k) > -1 :
			return jobprops[k]
	return None	
	
print "\n\n\n"

with open('results/abstractmappings.nt','w') as am:

### analyze abstracts
  for key in abstracts.keys():
	a = abstracts[key]
	lines = a.split('\n')
	g = getGenres(lines[0])
	for gen in g:				
		am.write('<' + key.encode('utf-8') + '> <http://schema.org/genre> "' + gen.encode('utf-8') + '" . \n' )		

	p = []
	if len(lines)>1:
		p = getTypeOfPerformance(lines[1])
		for top in p:
			am.write('<' + key.encode('utf-8') + '> <http://schema.org/keywords> "' + top.encode('utf-8') + '" . \n' )		
		
	if len(lines)>2:
		tok = lines[2].split(':')
		job = getJob(tok[0].strip(' ').strip(':'))		
		pers = mapPerson(tok[1].strip(' ').strip(':') )
		#print 'l1', tok[0].encode('utf-8'), job ,  pers   ,  tok[1].strip(' ').strip(':').encode('utf-8')
		if job and pers!="":
			am.write('<' + key.encode('utf-8') + '> <' + job.encode('utf-8') + '> <' + pers.encode('utf-8') + '> . \n')
			am.write('<' + pers.encode('utf-8') + '> <http://www.w3.org/2000/01/rdf-schema#> "' + tok[1].strip(' ').strip(':').encode('utf-8') + '" . \n')
	
	if len(lines)>3:
		tok = lines[3].split(':')
		if len(tok)>=2:
			job = getJob(tok[0].strip(' ').strip(':'))
			pers = mapPerson(tok[1].strip(' ').strip(':')) 
			#print 'l2',  tok[0].encode('utf-8'), job ,  pers   ,  tok[1].strip(' ').strip(':').encode('utf-8')
			if job and pers!="":
				am.write('<' + key.encode('utf-8') + '> <' + job.encode('utf-8') + '> <' + pers.encode('utf-8') + '> . \n')
				am.write('<' + pers.encode('utf-8') + '> <http://www.w3.org/2000/01/rdf-schema#> "' + tok[1].strip(' ').strip(':').encode('utf-8') + '" . \n')
	
	if len(lines)>4:
		tok = lines[4].split(':')
		if len(tok)>=2:
			job = getJob(tok[0].strip(' ').strip(':'))
			pers = mapPerson(tok[1].strip(' ').strip(':')) 	
			#print 'l3', tok[0].encode('utf-8'), job ,  pers   ,  tok[1].strip(' ').strip(':').encode('utf-8')
			if job and pers!="":
				am.write('<' + key.encode('utf-8') + '> <' + job.encode('utf-8') + '> <' + pers.encode('utf-8') + '> . \n')
				am.write('<' + pers.encode('utf-8') + '> <http://www.w3.org/2000/01/rdf-schema#> "' + tok[1].strip(' ').strip(':').encode('utf-8') + '" . \n')
	
  am.close()	
	
#sys.exit()

### analyze title addendums (everything in brackets behind the title)

#pers = open('personsmapped.txt', 'w')
#persneg = open('personsnotmapped.txt', 'w')
with open('results/personsmappings.nt','w') as ff:
	for t in addendums.keys():
		role, add = detectAndCleanRole(t)
#		print role , add
		p = mapPerson(add)		
		if p!="":	
#			pers.write(add.encode('utf-8') + " " + str(role) + "\n")
			for u in addendums[t]:
				if role == None:
					role = 'contributor'
				ff.write( "<" + u.encode('utf-8') + "> <http://schema.org/" + role + "> <" + p.encode('utf-8') + "> .\n")
				ff.write( "<" + p.encode('utf-8') + "> <http://www.w3.org/2000/01/rdf-schema#label> \"" + add.encode('utf-8') + "\" .\n")
#		else:
#			persneg.write(add.encode('utf-8') + " " + str(role) + " \n")
	

### analyze title

#open('out-titles.txt','w')
with open('results/titlemappings.nt','w') as tm:
	for t in titles.keys():		
		op = mapOpera(t)
		if op!="":
			#print t.encode('utf-8'),	" ---> " , op
			for u in titles[t]:
				tm.write( "<" + u.encode('utf-8') + "> <http://schema.org/isBasedOn> <" + op.encode('utf-8') + "> .\n")			
				tm.write( "<" + op.encode('utf-8') + "> <http://www.w3.org/2000/01/rdf-schema#label> \"" + t.encode('utf-8') + "\" .\n")
	
		#open('out-titles.txt','a').write(t.encode('utf-8') + " ---> " + op.encode('utf-8') + "\n")
	
	
#open('out-add.txt','w')
#for t in addendums:
	#print t.encode('utf-8')
	#open('out-add.txt','a').write(t.encode('utf-8') + "\n")	
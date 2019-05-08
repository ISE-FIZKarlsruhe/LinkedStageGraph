
### create sameAs links according to similar identifiers
INSERT INTO <http://slod.fiz-karlsruhe.de/> {?r1 owl:sameAs ?r2 .}
WHERE  { 
	SELECT DISTINCT ?r1 ?r2  WHERE{
		?r1 <urn:isbn:1-931666-22-9#did> ?did .
		?did <urn:isbn:1-931666-22-9#unitid> ?uid .
		?uid <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?val .
		?uid <urn:isbn:1-931666-22-9#countrycode> ?cc .
		?r2 <http://purl.org/dc/terms/identifier> ?val .
		?r2 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://data.archiveshub.ac.uk/def/ArchivalResource> .
	}
}

# create sameAs entailments
INSERT INTO <http://slod.fiz-karlsruhe.de/>
{ ?r2 ?p ?o . }
WHERE {	
	SELECT ?r2 ?p ?o WHERE {
		?r2 owl:sameAs ?r1 .
		?r1 ?p ?o .
	}
}

INSERT INTO <http://slod.fiz-karlsruhe.de/>
{ ?r2 ?p ?o . }
WHERE {
	SELECT ?r2 ?p ?o WHERE {
		?r1 owl:sameAs ?r2 .
		?r1 ?p ?o .
	}
}


# create nice abstracts
INSERT INTO <http://http://slod.fiz-karlsruhe.de/> 
{ ?s <http://purl.org/dc/terms/description> ?abstract . } 
WHERE {
	SELECT distinct ?s ?abstract WHERE {
		?s <urn:isbn:1-931666-22-9#did> ?didbl .
		?didbl <urn:isbn:1-931666-22-9#abstract> ?abstract .
	}
}


### DELETE duplicates from sameAs to prefer the "Archivischer Identifikator"
DELETE FROM <http://slod.fiz-karlsruhe.de/>
{?s ?p ?o .} 
WHERE {
	?s ?p ?o .
	FILTER REGEX (str(?s),'http://slod.fiz-karlsruhe.de/archivalresource/de1951-landesarchivbaden-wurttemberg/*' , 'i')
}

DELETE FROM <http://slod.fiz-karlsruhe.de/>
{?s ?p ?o .} 
WHERE {	
	?s ?p ?o .
	FILTER REGEX (str(?o),'http://slod.fiz-karlsruhe.de/archivalresource/de1951-landesarchivbaden-wurttemberg/*' , 'i')
}


#  delete http://archiveshub.ac.uk/data/
DELETE FROM <http://slod.fiz-karlsruhe.de/>
{?s ?p ?o .} WHERE 
{
	?s ?p ?o .
	FILTER REGEX (str(?o),'http://archiveshub.ac.uk/data/*' , 'i')
}
DELETE FROM <http://slod.fiz-karlsruhe.de/>
{?s ?p ?o .} WHERE {
	?s ?p ?o .
	FILTER REGEX (str(?s),'http://archiveshub.ac.uk/data/*' , 'i')
}


# delete useless seeAlso links
DELETE FROM <http://slod.fiz-karlsruhe.de/>
{ ?resource <http://www.w3.org/2000/01/rdf-schema#seeAlso> ?archiveshub . }
WHERE {
	?resource <http://www.w3.org/2000/01/rdf-schema#seeAlso> ?archiveshub .
}

# delete useless foaf:page
DELETE FROM <http://slod.fiz-karlsruhe.de/>
{?resource <http://xmlns.com/foaf/0.1/page> ?page . }
WHERE {
	?resource <http://xmlns.com/foaf/0.1/page> ?page .
}


## insert PLINK 
INSERT INTO <http://slod.fiz-karlsruhe.de/> {
    ?resource <http://www.w3.org/2000/01/rdf-schema#seeAlso> ?plink .
} WHERE {
	SELECT ?resource IRI(CONCAT("http://www.landesarchiv-bw.de/plink/?f=", SUBSTR(STR(?resource),35))) AS ?plink
	WHERE {

		?resource rdf:type <http://data.archiveshub.ac.uk/def/ArchivalResource> .
	}
}

### create hidden GND entities
INSERT INTO <http://slod.fiz-karlsruhe/>{ 
?s <http://slod.fiz-karlsruhe/ontology/relevantPerson> ?gndr .
?gndr <http://www.w3.org/2000/01/rdf-schema#label> ?lab .
}
WHERE {
SELECT distinct ?s iri(concat('http://d-nb.info/gnd/', ?gnd)) as ?gndr ?lab WHERE {
	?s <urn:isbn:1-931666-22-9#index> ?i .
	?i <urn:isbn:1-931666-22-9#indexentry> ?ie .
	?ie <urn:isbn:1-931666-22-9#persname> ?pn .
	?pn <urn:isbn:1-931666-22-9#authfilenumber> ?gnd .
	?pn <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?lab 
	} 
}


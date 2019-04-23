#/bin/bash

#BASE=http://example.org/cdv/
#GRAPH=http://www.example.com/my-graph
#IMGBASE=http://apps.yovisto.com/labs/joerg/cdv/

# before converting the XML to RDF we have to modify the origin XML slightly
python fixXml.py > origin/labw_2_2039-fixed.xml

# push this file to github

#git add origin/labw_2_2039-fixed.xml 
#git commit -m "fixed xml"
#git push origin master


##### XML to RDF Conversion ######
#
# call the rhizomik api to use their XML2RDF Converter with our fixed file ad github
curl http://rhizomik.net/redefer-services/xml2rdf?xml=https://github.com/ISE-FIZKarlsruhe/LinkedStageGraph/raw/master/data/origin/labw_2_2039-fixed.xml > tmp/xml2rdf.rdf

# convert this file to ntriples
rapper  -i rdfxml -o ntriples tmp/xml2rdf.rdf > tmp/tmp1.nt

# replace the stupid uris containing filenames with EAD standard namespace
# this only affects properties, because rhizomik converter produces faulty urls ('http://https_ ......' )
sed 's/http:\/\/https:\/\/github.com\/ISE-FIZKarlsruhe\/LinkedStageGraph\/raw\/master\/data\/origin\/labw_2_2039-fixed.xml/urn:isbn:1-931666-22-9/g' tmp/tmp1.nt > tmp/tmp2.nt

# replace remaining uris with BASE
sed 's/https:\/\/github.com\/ISE-FIZKarlsruhe\/LinkedStageGraph\/raw\/master\/data\/origin\/labw_2_2039-fixed.xml#/http:\/\/example.org\/cdv\//g' tmp/tmp2.nt > tmp/tmp3.nt

# remove faulty rdf:type statements
grep -v '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' tmp/tmp3.nt  > rdf-result/result-xml2rdf.n3


#####  EAD-XML to RDF Conversion ######
#
## convert with EAD XSLT Stylesheet
java -cp /opt/local/share/java/saxon9he.jar net.sf.saxon.Transform -s:origin/labw_2_2039-fixed.xml -xsl:transforms/ead2rdf-nons.xsl -o:tmp/saxon-out.rdf

# replace data URIs to fit BASE
sed 's/http:\/\/data.archiveshub.ac.uk\/id\//http:\/\/example.org\/cdv\//g' tmp/saxon-out.rdf  > tmp/saxon-out2.rdf

# convert  to ntriples
rapper  -i rdfxml -o ntriples tmp/saxon-out2.rdf > rdf-result/result-ead2rdf.n3


##### Handle the images
cat origin/images.txt | awk '{print "<http://example.org/cdv/" $1 "> <http://xmlns.com/foaf/0.1/depiction> <http://apps.yovisto.com/labs/joerg/cdv/" $2 "> ." }' > rdf-result/images.nt


### Now you can upload the result RDF data to the Triplestore








<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%><%@taglib uri="http://www.springframework.org/tags" prefix="sp"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html version="XHTML+RDFa 1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:cc="http://creativecommons.org/ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/">

<head data-color="${colorPair}" profile="http://www.w3.org/1999/xhtml/vocab">
	<title>${results.getTitle()}LinkedStageGraph&mdash;LodView</title>
	<jsp:include page="inc/home_header.jsp"></jsp:include>
</head>

<c:set var="proxy1200" scope="session" value="http://cdv.yovisto.com/imageproxy/1200,q25/" />
<c:set var="proxyThumb" scope="session" value="http://cdv.yovisto.com/imageproxy/150,sc,q25/" />

<body data-uk-filter="target: .js-filter">
	<jsp:include page="inc/custom_menu.jsp"></jsp:include>
	<div class="spacer"></div>
		
		<h1 class="uk-heading-small">About Linked Stage Graph</h2>

        <div class=".uk-text-justify">
                <p>Linked Stage Graph is a Knowledge Graph developed as part of the Coding da Vinci Süd 2019 hackathon taking place from April 06 to May 18, 2019 in southern Germany. The graph was created using a dataset provided by the National Archive of Baden-Wuerttemberg. It contains black and white photographs and metadata about the Stuttgart State Theatre from the 1890s to the 1940s. The nearly 7.000 photographs give vivid insights into on-stage events like theater plays, operas and ballet performances as well as off-stage moments and theater buildings. 
                However, the images and the data set as they are currently organized are hard to use and explore for anyone who is unfamiliar with an achive’s logic to structure information. This project proposes means to explore and understand the data by humans and machines using linked data standards. </p>
        </div>

        <h2 class="uk-heading-small">Goals</h2>
        <div class="uk-child-width-1-3@m uk-grid-small uk-grid-match" uk-grid>
    		<div>
        		<div class="uk-card uk-card-default uk-card-body uk-card-hover">
            	<h3 class="uk-card-title">Creating a Knowledge Graph</h3>
            	<p>Create a linked data knowledge graph (KG) out of the photographs and metadata to enable  means of exploration for (linked) data, web and information enthusiasts via a SPARQL endpoint. Users are then invited to query the data, create their own applications and visualizations out of them or connect the data to other data sources.</p>
        		</div>
    		</div>
    		<div>
        		<div class="uk-card uk-card-default uk-card-body uk-card-hover">
            	<h3 class="uk-card-title">Connecting with Others</h3>
            	<p>Extract named entities from the (often unstructured) textual mentions like persons or performances and connect as many entities as possible to existing KGs, such as Wikidata. This way, we are able to extend the information given in the original graph with new knowledge.</p>
        		</div>
    		</div>
    		<div>
        		<div class="uk-card uk-card-default uk-card-body uk-card-hover">
            	<h3 class="uk-card-title">Explore</h3>
            	<p>Use the data from the KG to create a simple visualization and bring the photographs to life to enable means of exploration for culture, theater, photography and history enthusiasts who want to browse through the timeline of theater in Stuttgart.</p>
        		</div>
    		</div>
		</div>

		<h2 class="uk-heading-medium">Workflow</h2>
        <img src="/staticResources/img/workflow.svg" width="1000" height="" alt="workflow" uk-img>

        <h2 class="uk-heading-small">Knowledge Graph</h2>
        A Knowledge Graph is ...
        And it is used because ... 

        <h3 class="uk-heading-small">From XML (EAD-DDB) to RDF</h3>
        The metadata was provided using the XML EAD standard which is used for encoding descriptive information regarding archival records. In order to create a knowledge graph, the data has to be transformed into the Resource Description Framework (RDF). 
		Many XML to RDF converters already exist, but due to the unique structure of the provided metadata, none of them worked out of the box. In the end, we used the XML2RDF converter by <a href="http://rhizomik.net/html/redefer/">rhizomik</a> and we used and adapted an <a href="http://data.archiveshub.ac.uk/ead2rdf">EADRDF XSLT Stylesheet</a>. We connected both outputs using an <code>owl:sameAs</code> link and merged both separate graphs by semantic reasoning. 

        <h3 class="uk-heading-small">Named Entity Extraction and Linking</h3>
        <p>
        	The provided metadata contained interesting information about the performances and photographs in form of semi-structured or unstructured text. For example, the resource <a href="http://slod.fiz-karlsruhe.de/labw-2-2599390">http://slod.fiz-karlsruhe.de/labw-2-2599390</a> has a title (<code>dcterms:title</code>) and an abstract (<code>dcterms:description</code>): </p>
        	<table class="uk-table-small uk-table-divider uk-table-hover">
			    <tbody>
        			<tr>
            		<td><code>dcterms:title</code></td>
            		<td>Was ihr wollt (William Shakespeare)</td>
        			</tr>
        			<tr>
            		<td><code>dcterms:description</code></td>
            		<td>Schauspiel <br>
        			Art und Datum der Aufführung: Neuinszenierung, 11.03.1923 <br>
        			Inszenierung: Curt Elwenspoek <br>
        			Bühnenbild: Felix Cziossek <br>
        			Kostüme: Ernst Pils</td>
        			</tr>	
    			</tbody>
			</table>
		<p>
			These unstructured textual information can be understood by humans, but not by machines. Therefore they cannot be queried or visualized in a meaningful way. We started to tackle this issue in two steps:
			<ul>
				<li>Extract named entities from semi-structured or unstructured text. In the example above, named entities are e.g. the title "Was ihr wollt" or names like "Ernst Pils". </li>
				<li>If available, map the extracted named entities to an existing knowledge base, like Wikidata</li>
			</ul>
				<table class="uk-table-small uk-table-divider uk-table-hover">
			    	<tbody>
        			<tr>
            		<td><code>schema:isBasedOn</code></td>
            		<td><a href="http://www.wikidata.org/entity/Q221211">http://www.wikidata.org/entity/Q221211</a> </td>
        			</tr>
        			<tr>
            		<td><code>slod:relevantPerson</code></td>
            		<td>Curt Elwenspoek </td>
            		</tr>
            		<tr><td></td><td>Felix Cziossek</td></tr>
        			<tr><td></td><td>Ernst Pils</td></tr>	
    				</tbody>
				</table>

        <h3 class="uk-heading-small">Photographs</h3>
        Even though the provided data set contained nearly 7.000 black and white photographs, only 2.600 of them were actually referenced in the XML document. We added the remaining 4.400 photographs to the graph and connect them to their respective resource.  


        <h2 class="uk-heading-medium">Exploration</h2>

        <h3 class="uk-heading-small">SLOD Viewer</h3>
        <h3 class="uk-heading-small">Vikus Viewer</h3>
        <h3 class="uk-heading-small">AI-Based Image Coloring</h3>
        <p>What breathes more life into photographs than a little bit of color? Using a <a href="https://richzhang.github.io/ideepcolor/">tool</a> based on artificial intelligence, we automatically colorized each photo in the data set with interesting outcomes. While the results aren’t close to perfection, we believe that the color adds a new vibrant dimension to these historical photos. </p>
        <h3 class="uk-heading-small">SPARQL Endpoint</h3>
        <h2 class="uk-heading-medium">Team</h2>

        <div class="uk-child-width-1-4@m uk-grid-small uk-grid-match" uk-grid>
    <div>
        <div class="uk-card-small uk-card-default uk-card-hover">
            <div class="uk-card-media-top">
                <img src="/staticResources/img/tabea.jpg" width="200" height="" alt="">
            </div>
            <div class="uk-card-body">
                <h3 class="uk-card-title">Tabea Tietz</h3>
                <p>Junior Researcher at FIZ Karlsruhe <br>
                	Webpage at <a href="https://fizweb-p.fiz-karlsruhe.de/en/forschung/lebenslauf-und-publikationen-tabea-tietz">FIZ Karlsruhe</a> <br>
                	Twitter: <a href="https://twitter.com/Tabea_T">Tabea_T</a> </p>
            </div>
        </div>
    </div>
    <div>
        <div class="uk-card-small uk-card-default uk-card-hover">
            <div class="uk-card-media-top">
                <img src="/staticResources/img/joerg.jpg" width="200" height="" alt="">
            </div>
            <div class="uk-card-body">
                <h3 class="uk-card-title">Jörg Waitelonis</h3>
                <p>yovisto</p>
            </div>
        </div>
    </div>
    <div>
        <div class="uk-card-small uk-card-default uk-card-hover">
            <div class="uk-card-media-top">
                <img src="/staticResources/img/kanran.jpg" width="200" height="" alt="">
            </div>
            <div class="uk-card-body">
                <h3 class="uk-card-title">Kanran Zhou</h3>
                <p>Student co-worker at FIZ Karlsruhe</p>
            </div>
        </div>
    </div>
    <div>
        <div class="uk-card-small uk-card-default uk-card-hover">
            <div class="uk-card-media-top">
                <img src="/staticResources/img/paul.jpg" width="200" height="" alt="">
            </div>
            <div class="uk-card-body">
                <h3 class="uk-card-title">Paul Felgentreff</h3>
                <p>Design</p>
            </div>
        </div>
    </div>

</div>



	<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	<jsp:include page="inc/footer.jsp"></jsp:include>
</body>

</html>

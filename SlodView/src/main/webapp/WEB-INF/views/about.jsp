<%@page xmlns="http://www.w3.org/1999/xhtml" contentType="text/html" pageEncoding="UTF-8" session="true"%><%@taglib uri="http://www.springframework.org/tags" prefix="sp"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
		
		<h1>About Linked Stage Graph</h2>

        <div class=".uk-text-justify">
                <p>Linked Stage Graph is a Knowledge Graph developed as part of the <a href="https://codingdavinci.de/events/sued/">Coding da Vinci Süd 2019</a> hackathon taking place from April to May 2019. The graph is being created using a dataset provided by the National Archive of Baden-Wuerttemberg. It contains black and white photographs and metadata about the Stuttgart State Theatre from the 1890s to the 1940s. <br>
                The nearly 7.000 photographs give vivid insights into on-stage events like theater plays, operas and ballet performances as well as off-stage moments and theater buildings. However, the images and the data set as they are currently organized are hard to use and explore for anyone who is unfamiliar with an achive’s logic to structure information. This project proposes means to explore and understand the data by humans and machines using linked data and interesting visualizations. </p>
        </div>

        <h2>Goals</h2>
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
            	<h3 class="uk-card-title">Providing Means of Exploration</h3>
            	<p>Use the data from the KG to create a simple visualization and bring the photographs to life to enable means of exploration for culture, theater, photography and history enthusiasts who want to browse through the timeline of theater in Stuttgart.</p>
        		</div>
    		</div>
		</div>

		<h2>Workflow</h2>
        <img src="/staticResources/img/workflow.svg" width="1000" height="" alt="workflow" uk-img>

        <h2>Creating the Knowledge Graph</h2>
        <h3>What is a Knowledge Graph?</h3>
        <p>A knowledge graph is a "graph of data with the intend to compose knowledge". <b>Graph of data</b> refers to a data set viewed  as a set of entities represented as nodes, with their relations represented as edges. <b>Composing knowledge</b> refers to a continual process of extracting and representing knowledge that enhances the interpretability of the resulting knowledge graph. 
        	<br>
        A knowledge graph is therefore a way to create and organize knowledge in a continuing process in a way that it can be interpreted by humans and machines alike.
        <br> <br>
        The presented definition is taken from "Knowledge Graphs: New Directions for Knowledge Representation on the Semantic Web" by Bonatti et al. For a more in depth definition and best practices, <a href="http://drops.dagstuhl.de/opus/volltexte/2019/10328/">read more here</a>.</p> 

        <h3>From XML (EAD-DDB) to RDF</h3>
        The metadata was provided using the XML EAD standard which is used for encoding descriptive information regarding archival records. In order to create a knowledge graph, the data has to be transformed into the Resource Description Framework (RDF). 
		Many XML to RDF converters already exist, but due to the unique structure of the provided metadata, none of them worked out of the box. In the end, we used the XML2RDF converter by <a href="http://rhizomik.net/html/redefer/">rhizomik</a> and we used and adapted an <a href="http://data.archiveshub.ac.uk/ead2rdf">EADRDF XSLT Stylesheet</a>. Both outputs were imported into <a href="https://virtuoso.openlinksw.com/">OpenLink Virtuoso</a> as two separate RDF graphs. We connected both outputs using <code>owl:sameAs</code> and merged both separate graphs by semantic reasoning.

        <h3>Named Entity Extraction and Linking (Connecting with Others)</h3>
        <p>
        	The provided metadata contains interesting information about the performances and photographs in form of semi-structured or unstructured text. For example, the resource <a href="http://slod.fiz-karlsruhe.de/labw-2-2599390">http://slod.fiz-karlsruhe.de/labw-2-2599390</a> has a title (<code>dcterms:title</code>) and an abstract (<code>dcterms:description</code>). These semi-structured textual information as shown in the left hand table below can be interpreted by humans, but not by machines. Therefore they cannot be queried or visualized in a meaningful and useful way. We started to tackle this issue in two steps:
			<ul>
				<li>We extract named entities from semi-structured text. In the example below, named entities are e.g. the title "Was ihr wollt" or names like "Felix Cziossek". </li>
				<li>If available, we mapped the extracted named entities to an existing knowledge base, like Wikidata</li>
			</ul></p>

        	<div class="uk-column-1-2">
        		<h4>Before Linking</h4>
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
				<br> 
				<h4>After Linking</h4>
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
        			<tr>
            		<td><code>schema:isBasedOn</code></td>
            		<td><a href="http://www.wikidata.org/entity/Q221211">&lt;http://www.wikidata.org/entity/Q221211&gt;</a> </td>
        			</tr>
        			<tr>
            		<td><code>slod:relevantPerson</code></td>
            		<td><a href="https://www.wikidata.org/wiki/Q55638867">&lt;https://www.wikidata.org/wiki/Q55638867&gt;</a></td>
            		</tr>
    				</tbody>
				</table>
			</div>

		<p>In this example above (table on the right), two mappings were created. Felix Cziossek was mapped to the respective Item in Wikidata using the property <code>slod:relevantPerson</code>  and the play "Was ihr wollt" was mapped to the respective creative work in Wikidata using the property <code>schema:isBasedOn</code>. </p>

		<h4>What does this mean?</h4>
		<p>In this example, we have now created new knowledge in the form of two human and machine interpretable facts:</p> 
			<ul>
				<li>the fact that the resource <a href="http://slod.fiz-karlsruhe.de/labw-2-2599390">http://slod.fiz-karlsruhe.de/labw-2-2599390</a> with the title "Was ihr wollt" is based on the famous play <a href="https://www.wikidata.org/wiki/Q221211">Twelfth Night</a> by William Shakespeare, and</li>
				<li>the fact that <a href="https://www.wikidata.org/wiki/Q55638867">Felix Cziossek</a> is a relevant person for that play at the Stuttgart Theater.</li>
			</ul>
		<p>These new and structured information can now be queried using SPARQL. Another advantage of linking these entities from our knowledge graph to other knowledge graphs is that we can make use of all data linked to these resources (e.g. in <a href="https://www.wikidata.org/wiki/Q221211">Twelfth Night</a>).</p>

        <h2>Exploration</h2>
        <p>We have created several means of exploration. For non-technical users who simply want to enjoy the photographs along with their descriptions and relevant persons, we have created the SLOD Viewer and we have utilized the Vikus Viewer. For technically advanced users, we provide an endpoint to be queried using SPARQL.</p>

        <h3>Preprocessing: AI-Based Image Coloring</h3>
        <p>What breathes more life into photographs than a little bit of color? Using a <a href="https://richzhang.github.io/ideepcolor/">tool</a> based on artificial intelligence, we automatically colorized each photo in the data set with interesting outcomes. While the results aren’t close to perfection, we believe that the color adds a new vibrant dimension to these historical photos. </p>
        <div class="uk-child-width-1-2" uk-grid>
			<div>
				<h3>Linked Stage Graph Viewer</h3>
				<p class="uk-text-justify">The Linked Stage Graph Viewer is an exploration interface created by us. It enables to explore the images from the data set in (sort of) an instagram feed like fashion. We have cropped the photographs automatically to focus on the most interesting sections in them. 
				The photographs are arranged in a timeline from 1912 to 1943 which can be explored by scrolling up and down. Swiping left and right reveals other performances which have taken place in the same year. For the pictures to really come alive, you simply have to hover them and they instantly turn from their original black and white to colored photographs. By clicking on a title, you are directed to the Lodview interface which shows you all metadata we have for each of the performances. </p>
			</div>
			<div>
				<h3>Vikus Viewer</h3>
				<p class="uk-text-justify">The Vikus Viewer was created by <a href="https://chrispie.com/">Christopher Pietsch</a> in the context of the <a href="https://uclab.fh-potsdam.de/">Urban Complexity Lab</a> at FH Potsdam. We found that the viewer works great with the data and photographs from our knowledge graph. The timeline allows the user to dynamically explore the images and metadata. Users can filter the content, zoom into it and focus on individual images which also reveals some of the metadata we have gathered.</p>
			</div>
		</div>

        <h3>SPARQL Endpoint</h3>

        You can query the Linked Stage Graph using our <a href="/sparql">SPARQL-Endpoint</a>. 

        <p>Use the following prefixes with your query:</p>
		<pre><code>
		PREFIX dcterms: &lt;http://purl.org/dc/terms/&gt;
		PREFIX gnd: &lt;http://d-nb.info/gnd/&gt;
		PREFIX schema: &lt;http://schema.org/&gt;
		PREFIX slod: &lt;http://slod.fiz-karlsruhe.de/&gt;
		PREFIX rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;

</code></pre>

		<h4>Example Query 1</h4>
		<h4>Example Query 2</h4>

        <h2><a name="team"></a>Team</h2>

        <div class="uk-child-width-1-4@m uk-grid-small uk-grid-match" uk-grid>
    <div>
        <div class="uk-card-small uk-card-default uk-card-hover">
            <div class="uk-card-media-top">
                <img src="/staticResources/img/tabea.jpg" width="200" height="" alt="">
            </div>
            <div class="uk-card-body">
                <h3 class="uk-card-title">Tabea Tietz</h3>
                <p>Junior Researcher at FIZ Karlsruhe and Karlsruhe Institute of Technology (AIFB)<br>
                	Webpage at <a href="https://fizweb-p.fiz-karlsruhe.de/en/forschung/lebenslauf-und-publikationen-tabea-tietz">FIZ Karlsruhe</a> <br>
                	Twitter: <a href="https://twitter.com/Tabea_T">Tabea_T</a> </p>
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
                <p>Student of electrical engineering at Karlsruhe Institute of Technology and student co-worker at FIZ Karlsruhe <br>
                	LinkedIn <a href="https://www.linkedin.com/in/kanran-zhou-26608bb0/">Profile</a></p>
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
                <p>yovisto GmbH</p>
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

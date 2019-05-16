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

	<section class="uk-section uk-article">
		<div id="" class="uk-container uk-container-small">
			<h1 class="uk-text-bold uk-h1 uk-margin-remove-adjacent uk-margin-remove-top">
				About Linked Stage Graph
			</h1>
			<div class="uk-text-justify uk-column-1-2">
				<p>Linked Stage Graph is a Knowledge Graph developed during the <a href="https://codingdavinci.de/events/sued/">Coding da Vinci Süd 2019</a> hackathon. The graph is being created using a dataset by the <a href="https://www.landesarchiv-bw.de/web">National Archive of Baden-Wuerttemberg</a>. It contains black and white photographs and metadata about the <a href="https://www.staatstheater-stuttgart.com/home/">Stuttgart State Theatre </a> from the 1890s to the 1940s.<br> 
				The nearly 7.000 photographs give vivid insights into on-stage events like theater plays, operas and ballet performances as well as off-stage moments and theater buildings. However, the images and the data set as they are currently organized are hard to use and explore for anyone who is unfamiliar with an achive’s logic to structure information. <br>
				This project proposes means to explore and understand the data by humans and machines using linked data and interesting visualizations. </p>
			</div>
		</div>
	</section>
	<section class="uk-section">
		<div class="uk-container uk-container-small">
			<h2>Goals</h2>
			<div class="uk-child-width-1-3@m uk-grid-small uk-grid-match" uk-grid>
				<div>
					<div class="uk-card uk-card-default uk-card-body uk-card-hover">
						<h3 class="uk-card-title">Create a Knowledge Graph</h3>
						<p>Create a linked data knowledge graph (KG) out of the photographs and metadata to enable  means of exploration for (linked) data, web and information enthusiasts via a SPARQL endpoint. Users are then invited to query the data, create their own applications and visualizations out of them or connect the data to other data sources.</p>
						<a href="/about#KG" class="uk-button uk-button-primary uk-position-bottom-center uk-margin-small-bottom">Read more</a>
					</div>
				</div>
				<div>
					<div class="uk-card uk-card-default uk-card-body uk-card-hover">
						<h3 class="uk-card-title">Connect with Others</h3>
						<p>Extract named entities from the (often unstructured) textual mentions like persons or performances and connect as many entities as possible to existing KGs, such as Wikidata. This way, we are able to extend the information given in the original graph with new knowledge.</p>
        				<a href="/about#Linking" class="uk-button uk-button-primary uk-position-bottom-center uk-margin-small-bottom">Read more</a>
					</div>
				</div>
				<div>
					<div class="uk-card uk-card-default uk-card-body uk-card-hover">
						<h3 class="uk-card-title">Explore</h3>
						<p>Use the data from the KG to create a simple visualization and bring the photographs to life to enable means of exploration for culture, theater, photography and history enthusiasts who want to browse through the timeline of the Stuttgart State Theater.</p>
						<a href="/about#Exploration" class="uk-button uk-button-primary uk-position-bottom-center uk-margin-small-bottom">Read more</a>
					</div>
				</div>
			</div>
		</div>
	</section>

	<section class="uk-section">
	<div class="uk-container uk-container-small">
	<h2 id="KG">Creating the Knowledge Graph</h2>
			<h3>What is a Knowledge Graph?</h3>
			<p><b>A knowledge graph is a "graph of data with the intend to compose knowledge".</b></p>
			<p class="uk-column-1-2">
				<b>Graph of data</b> refers to a data set viewed  as a set of entities represented as nodes, with their relations represented as edges. <br>
				<b>Composing knowledge</b> refers to a continual process of extracting and representing knowledge that enhances the interpretability of the resulting knowledge graph. </p>
		
			<p>A knowledge graph is therefore a method to create and organize knowledge in a continuing process in a way that it can be interpreted by humans and machines alike.
			<br> <br>
			<i>Source:</i> "<a href="http://drops.dagstuhl.de/opus/volltexte/2019/10328/">Knowledge Graphs: New Directions for Knowledge Representation on the Semantic Web</a>". Bonatti et al.</p> 
	</div>
	</section>
	
	<section class="uk-section">
		<div class="uk-container uk-container-small">
			<h2>Workflow</h2>
			<img src="/staticResources/img/workflow.png" width="800" height="" alt="workflow" uk-svg>
		</div>
	</section>
	
	<section class="uk-section">
		<div class="uk-container uk-container-small">
			<h3>From XML (EAD-DDB) to RDF</h3>
			<p class="uk-column-1-2">The metadata was provided using the XML EAD standard which is used for encoding descriptive information regarding archival records. In order to create a knowledge graph, the data has to be transformed into the Resource Description Framework (RDF).<br/>
			Many XML to RDF converters already exist, but due to the unique structure of the provided metadata, none of them worked out of the box. In the end, we used the XML2RDF converter by <a href="http://rhizomik.net/html/redefer/">rhizomik</a> and we used and adapted an <a href="http://data.archiveshub.ac.uk/ead2rdf">EADRDF XSLT Stylesheet</a>. Both outputs were imported into <a href="https://virtuoso.openlinksw.com/">OpenLink Virtuoso</a>. We connected both outputs using <code>owl:sameAs</code> and the archival unit ids. This enabled us to merge both outputs by semantic reasoning.</p>
		
			<h3 id="Linking">Named Entity Extraction and Linking (Connecting with Others)</h3>
			<p class="uk-column-1-2">
				The provided metadata contains interesting information about the performances and photographs in form of semi-structured or unstructured text. For example, the resource <a href="http://slod.fiz-karlsruhe.de/labw-2-2599390">http://slod.fiz-karlsruhe.de/labw-2-2599390</a> has a title (<code>dcterms:title</code>) and an abstract (<code>dcterms:description</code>). These semi-structured textual information as shown in the first table below can be interpreted by humans, but not by machines. Therefore they cannot be queried or visualized in a meaningful and useful way. We started to tackle this issue in two steps:
				<ul>
					<li>We extract named entities from semi-structured text. In the example below, named entities are e.g. the title "Was ihr wollt" or names like "Felix Cziossek". </li>
					<li>If available, we mapped the extracted named entities to existing knowledge bases, Wikidata and the German National Library (GND)</li>
				</ul>
			</p>
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
				<td><a href="http://www.wikidata.org/entity/Q221211">&lt;http://www.wikidata.org/entity/Q221211&gt;</a> <br>
					<a href="http://d-nb.info/gnd/4316770-6">&lt;http://d-nb.info/gnd/4316770-6&gt;</a> </td>
				</tr>
				<tr>
				<td><code>dbo:setDesigner</code></td>
				<td><a href="https://www.wikidata.org/wiki/Q55638867">&lt;http://www.wikidata.org/wiki/Q55638867&gt;</a></td>
				</tr>
				<tr>
					<td><code>schema:contributor</code></td>
					<td><a href="http://www.wikidata.org/entity/Q692">&lt;http://www.wikidata.org/entity/Q692&gt;</a></td>
				</tr>
				</tbody>
			</table>
			<p>In the second table above, several mappings were created. For instance, Felix Cziossek was mapped to the respective Item in Wikidata using the property <code>dbo:setDesigner</code> and the play "Was ihr wollt" was mapped to the respective creative work in Wikidata and GND using the property <code>schema:isBasedOn</code>. </p>
			<h4>What does this mean?</h4>
			<p>In this example, we have now created new knowledge in the form of human and machine interpretable facts:</p> 
				<ul>
					<li>the fact that the resource <a href="http://slod.fiz-karlsruhe.de/labw-2-2599390">http://slod.fiz-karlsruhe.de/labw-2-2599390</a> with the title "Was ihr wollt" is based on the famous play <a href="https://www.wikidata.org/wiki/Q221211">Twelfth Night</a> by <a href="http://www.wikidata.org/entity/Q692">William Shakespeare</a>, and</li>
				<li>the fact that <a href="https://www.wikidata.org/wiki/Q55638867">Felix Cziossek</a> was the set designer for that play at the Stuttgart Theater.</li>
				</ul>
			<p>These new and structured information can now be queried using SPARQL. Another advantage of linking these entities from our knowledge graph to other knowledge graphs is that we can make use of all data linked to these resources (e.g. in <a href="https://www.wikidata.org/wiki/Q221211">Twelfth Night</a>) as you can see in the <a href="http://slod.fiz-karlsruhe.de/labw-2-2599390.html#lodCloud">Lodview Linked Open Data widget</a>.</p>
			<div><a class="uk-button uk-button-default uk-margin-small-top" href="http://slod.fiz-karlsruhe.de/labw-2-2599390">Show Resource in Lodview</a></div>
		</div>
	</section>
	
	<section class="uk-section">
		<div class="uk-container uk-container-small">
			<h2 id="Exploration">Exploration</h2>
			<p>We have created several means of exploration. For non-technical users who simply want to enjoy the photographs along with their descriptions and relevant persons, we have created the <b>Linked Stage Graph Viewer</b> and we have utilized the <b>Vikus Viewer</b>. For technically advanced users, we provide an endpoint to be queried using SPARQL.</p>

		<div class="uk-container uk-container-small">
			<h3>Preprocessing: AI-Based Image Coloring</h3>
			<div class="uk-grid-small uk-child-width-expand@s uk-text-center" uk-grid>
    			<div>
    				<div uk-lightbox>
        			<div class="uk-card uk-card-default uk-card-body"><a href="/staticResources/img/baby_bw_g.png" data-alt="Baby"><img src="/staticResources/img/baby_bw_g.png" width="300" height="" alt=""></a></div>
        			</div>
    			</div>
    			<div>
    				<div uk-lightbox>
        			<div class="uk-card uk-card-default uk-card-body"><a href="/staticResources/img/beer_bw_g.png" data-alt="Baby"><img src="/staticResources/img/beer_bw_g.png" width="300" height="" alt=""></a></div>
        			</div>
    			</div>
    			<div>
    				<div uk-lightbox>
        			<div class="uk-card uk-card-default uk-card-body"><a href="/staticResources/img/couple_bw_g.png" data-alt="Baby"><img src="/staticResources/img/couple_bw_g.png" width="300" height="" alt=""></a></div>
        			</div>
    			</div>
			</div>
			<div>
			<p class="uk-margin-small-top">What breathes more life into photographs than a little bit of color? Using a <a href="https://richzhang.github.io/ideepcolor/">tool</a> based on artificial intelligence, we automatically colorized each photo in the data set with interesting outcomes. While the results aren’t close to perfection, we believe that the color adds a new vibrant dimension to these historical photos. </p>
			</div>
		</div>
			
			<div>
				<h3>User Interfaces</h3>
			<div class="uk-child-width-1-2" uk-grid>
				<div>
					<h4>Linked Stage Graph Viewer</h4>
					<img src="/staticResources/img/slodviewer.png" width="300" height="" alt=""> 
					<div><a class="uk-button uk-button-default uk-margin-small-top" href="/#Viewer">Demo</a></div>
					<p class="uk-text-justify">The Linked Stage Graph Viewer is an exploration interface created by us. It enables to explore the images from the data set in (sort of) an instagram feed like fashion. We have cropped the photographs automatically to focus on the most interesting sections in them. <br>
					The photographs are arranged in a timeline from 1912 to 1943 which can be explored by scrolling up and down. Swiping left and right reveals other performances which have taken place in the same year. By clicking on a title, you are directed to the Lodview interface which shows you all metadata we have for each of the performances.
				   </p>
				</div>
				<div>
					<h4>Vikus Viewer</h4>
					<img src="/staticResources/img/vikus.png" width="300" height="" alt="">
					<div><a class="uk-button uk-button-default uk-margin-small-top" href="http://slod.fiz-karlsruhe.de/vikus">Demo</a></div>
					<p class="uk-text-justify">The Vikus Viewer was created by <a href="https://chrispie.com/">Christopher Pietsch</a> in the context of the <a href="https://uclab.fh-potsdam.de/">Urban Complexity Lab</a> at FH Potsdam. We found that the viewer works great with the data and photographs from our knowledge graph. The timeline allows the user to dynamically explore the images and metadata. Users can filter the content, zoom into it and focus on individual images which also reveals some of the metadata we have gathered.</p>
				</div>
			</div>
			</div>
		
			<h3>SPARQL Endpoint</h3>
		
			<p>You can query the Linked Stage Graph using our SPARQL-Endpoint.</p>
			<div><a class="uk-button uk-button-default uk-margin-small-top" href="http://slod.fiz-karlsruhe.de/sparql">Go to Endpoint</a></div> 
		
			<p>Use the following prefixes with your query:</p>
			<pre><code>
	PREFIX dcterms: &lt;http://purl.org/dc/terms/&gt;
	PREFIX gnd: &lt;http://d-nb.info/gnd/&gt;
	PREFIX schema: &lt;http://schema.org/&gt;
	PREFIX slod: &lt;http://slod.fiz-karlsruhe.de/&gt;
	PREFIX rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;
			</code></pre>
			<h4>Example Query 1: Query Linked Stage Graph</h4>
			        <p>Select all resources and their labels, for which there is a contributor (<code>schema:contributor</code>) listed in the data set. Optionally, also show the genre of each resource (<code>schema:genre</code>). <br> 
			        	(<a href="https://slod.fiz-karlsruhe.de/sparql?default-graph-uri=&query=PREFIX+schema%3A+%3Chttp%3A%2F%2Fschema.org%2F%3E+%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E++%0D%0APREFIX+wikibase%3A+%3Chttp%3A%2F%2Fwikiba.se%2Fontology%23%3E%0D%0APREFIX+bd%3A+%3Chttp%3A%2F%2Fwww.bigdata.com%2Frdf%23%3E%0D%0A%0D%0ASELECT+DISTINCT+%3Fresource+%3Flabel+%3Fcontributor+%3Fname+%3Fgenre%0D%0A++++WHERE+%7B%0D%0A++++++++%3Fresource+schema%3Acontributor+%3Fcontributor+.%0D%0A++++++++%3Fresource+rdfs%3Alabel+%3Flabel+.%0D%0A++++++++%3Fcontributor+rdfs%3Alabel+%3Fname+.%0D%0A++++++++OPTIONAL+%7B%3Fresource+schema%3Agenre+%3Fgenre+%7D%0D%0A++++++++%7D&should-sponge=&format=text%2Fhtml&timeout=0&debug=on&run=+Run+Query+">Query Demo</a>)</p>

        <pre><code>
    SELECT DISTINCT ?resource ?label ?contributor ?name ?genre
    WHERE {
        ?resource schema:contributor ?contributor .
        ?resource rdfs:label ?label .
        ?contributor rdfs:label ?name .
        OPTIONAL {?resource schema:genre ?genre }
        }

</code></pre>
		<h4>Example Query 2: Federated Query (via Wikidata)</h4>
        <p>Select all resources, each resource label and their respective representation in Wikidata (<code>schema:isBasedOn</code>). Additionally, query Wikidata for these resources and select the publication year for each resource. <br> (<a href="https://slod.fiz-karlsruhe.de/sparql?default-graph-uri=&query=PREFIX+schema%3A+%3Chttp%3A%2F%2Fschema.org%2F%3E+%0D%0APREFIX+foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E++%0D%0APREFIX+wikibase%3A+%3Chttp%3A%2F%2Fwikiba.se%2Fontology%23%3E%0D%0APREFIX+bd%3A+%3Chttp%3A%2F%2Fwww.bigdata.com%2Frdf%23%3E%0D%0A%0D%0ASELECT+distinct+%3Fresource+%3Fresourcelabel+%3Fpublicationdate%0D%0AWHERE+%7B%0D%0A%3Fresource+%3Chttp%3A%2F%2Fschema.org%2FisBasedOn%3E+%3Fwikiresource+.%0D%0A%3Fresource+rdfs%3Alabel+%3Fresourcelabel+.%0D%0A%09SERVICE+%3Chttps%3A%2F%2Fquery.wikidata.org%2Fsparql%3E+%7B%0D%0A%09%09%3Fwikiresource+%3Chttp%3A%2F%2Fwww.wikidata.org%2Fprop%2Fdirect%2FP577%3E+%3Fpublicationdate+.%0D%0A%09%7D%0D%0A%7D&should-sponge=&format=text%2Fhtml&timeout=0&debug=on&run=+Run+Query+">Query Demo</a>)</p>
        <pre><code>
    SELECT distinct ?resource ?resourcelabel ?publicationdate
	WHERE {
		?resource schema:isBasedOn ?wikiresource .
		?resource rdfs:label ?resourcelabel .
	
		SERVICE &lt;https://query.wikidata.org/sparql&gt; {
			?wikiresource &lt;http://www.wikidata.org/prop/direct/P577&gt; ?publicationdate .
				}
		}
</code></pre>
		<p><i>Disclaimer: When the Wikidata server is busy, this federated query may cause a timeout. If this occurs, please try again a few minutes later. Thank you!</i>  </p>
		<h4>Example Query 3: Federated Query (via DBpedia) </h4>
        <p>Select the English language abstracts of each linked resource (e.g. persons and plays). <br> (<a href="http://slod.fiz-karlsruhe.de/sparql?default-graph-uri=&query=PREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+gnd%3A+%3Chttp%3A%2F%2Fd-nb.info%2Fgnd%2F%3E%0D%0APREFIX+schema%3A+%3Chttp%3A%2F%2Fschema.org%2F%3E%0D%0APREFIX+slod%3A+%3Chttp%3A%2F%2Fslod.fiz-karlsruhe.de%2F%3E%0D%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0A%0D%0ASELECT+distinct+%3Fresource+%3Fresourcelabel+%3Fdbp+%3Fabstract%0D%0AWHERE+%7B%0D%0A%3Fresource+schema%3AisBasedOn+%3Fwikiresource+.%0D%0A%3Fresource+rdfs%3Alabel+%3Fresourcelabel+.%0D%0A%0D%0ASERVICE+%3Chttp%3A%2F%2Fdbpedia.org%2Fsparql%3E+%7B%0D%0A%3Fdbp+%3Fp+%3Fwikiresource+.%0D%0Afilter+regex%28%3Fdbp%2C+%27http%3A%2F%2Fdbpedia.org%2F%27%2C+%27i%27%29%0D%0A%3Fdbp+%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2Fabstract%3E+%3Fabstract+.%0D%0Afilter+%28lang%28%3Fabstract%29+%3D+%27en%27%29+.%0D%0A%7D%0D%0A%0D%0A%0D%0A%7D%0D%0A&should-sponge=&format=text%2Fhtml&timeout=0&debug=on&run=+Run+Query+">Query Demo</a>)</p>
        <pre><code>
		
	SELECT DISTINCT ?resource ?resourcelabel ?dbp ?abstract
	WHERE {
		?resource schema:isBasedOn ?wikiresource .
		?resource rdfs:label ?resourcelabel .

		SERVICE &lt;http://dbpedia.org/sparql&gt; {
			?dbp ?p ?wikiresource .
			FILTER regex(?dbp, 'http://dbpedia.org/', 'i')
			?dbp &lt;http://dbpedia.org/ontology/abstract&gt; ?abstract .
			FILTER (lang(?abstract) = 'en') .
		}	
</code></pre>
		<p><i>Disclaimer: When the DBpedia server is busy, this federated query may cause a timeout. If this occurs, please try again a few minutes later. Thank you!</i>  </p>
		</div>
	</section>
	
	
	<section class="uk-section">
		<div class="uk-container uk-container-small">
			<h2 id="team">Team</h2>
			<div class="uk-child-width-1-4@m uk-grid-small uk-grid-match" uk-grid>
				<div class="uk-card-small uk-card-default uk-card-hover">
					<div class="uk-card-media-top">
						<img src="/staticResources/img/tabea.jpg" width="200" height="" alt="Tabea Tietz" uk-img>
					</div>
					<div class="uk-card-header">
        				<h3 class="uk-card-title">Tabea Tietz</h3>
    					</div>
    					<div class="uk-card-body">
						<p>Junior Researcher at FIZ Karlsruhe and Karlsruhe Institute of Technology (AIFB).<br>
							<ul>
								<li><a href="https://fizweb-p.fiz-karlsruhe.de/en/forschung/lebenslauf-und-publikationen-tabea-tietz">Webpage</a></li>
								<li><a href="https://twitter.com/Tabea_T">Twitter</a></li>
								<li><a href="mailto:tabea.tietz@fiz-karlsruhe.de">Email</a>  </li>
							</ul>
							Supervisor:<br><a href="https://www.fiz-karlsruhe.de/en/forschung/lebenslauf-prof-dr-harald-sack">Prof. Harald Sack</a>
						</p>
					</div>
				</div>
		
				<div class="uk-card-small uk-card-default uk-card-hover">
					<div class="uk-card-media-top">
						<img src="/staticResources/img/kanran.jpg" width="200" height="" alt="" uk-img>
					</div>
					<div class="uk-card-header">
						<h3 class="uk-card-title">Kanran Zhou</h3>
					</div>
					<div class="uk-card-body">
						<p>
							Student of electrical engineering at Karlsruhe Institute of Technology and student co-worker at FIZ Karlsruhe.
							<ul>
								<li><a href="https://www.linkedin.com/in/kanran-zhou-26608bb0/">LinkedIn</a></li>
							</ul>
							Supervisor:<br><a href="https://www.fiz-karlsruhe.de/en/forschung/lebenslauf-prof-dr-harald-sack">Prof. Harald Sack</a>
						</p>
				</div>
				</div>
				
				<div>
				<div class="uk-card-small uk-card-default uk-card-hover">
					<div class="uk-card-media-top">
						<img src="/staticResources/img/joerg.jpg" width="200" height="" alt="Jörg Waitelonis" uk-img>
					</div>
						<div class="uk-card-header">
        				<h3 class="uk-card-title">Jörg Waitelonis</h3>
    					</div>
    					<div class="uk-card-body">
						<p>Linked Data enthusiast, <br> yovisto GmbH
							<ul>
								<li><a href="http://yovisto.com">Webpage</a></li>
								<li><a href="https://twitter.com/yovisto">Twitter</a></li>
								<li><a href="mailto:joerg@yovisto.com">Email</a>  </li>
							</ul>
						</p>
					</div>
				</div>
				</div>
				<div>
				<div class="uk-card-small uk-card-default uk-card-hover">
					<div class="uk-card-media-top">
						<img src="/staticResources/img/paul-felgentreff.jpg" width="200" height="" alt="Paul Felgentreff Web Dev" uk-img>
					</div>
						<div class="uk-card-header">
        				<h3 class="uk-card-title">Paul Felgentreff</h3>
    				</div>
    				<div class="uk-card-body">
						<p>Addicted to progress and nature, design & Green Marketing &dash; not green washing but actual good&nbsp;marketing&nbsp;✌
							<ul>
								<li><a href="mailto:paul.felge@pm.me">Email</a></li>
								<li><a href="https://www.linkedin.com/in/paulfelgentreff/">LinkedIn</a></li>
							</ul>
						</p>
					</div>
				</div>
				</div>
			</div>
	</section>

	<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	<jsp:include page="inc/footer.jsp"></jsp:include>
</body>

</html>

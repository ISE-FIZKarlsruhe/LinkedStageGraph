<%@page session="true"%><%@taglib uri="http://www.springframework.org/tags" prefix="sp"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html version="XHTML+RDFa 1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:cc="http://creativecommons.org/ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/">

<head data-color="${colorPair}" profile="http://www.w3.org/1999/xhtml/vocab">
	<title>${results.getTitle()}LinkedStageGraph&mdash;LodView</title>
	<jsp:include page="inc/home_header.jsp"></jsp:include>
	<jsp:include page="inc/vikus_header.jsp"></jsp:include>
</head>

<c:set var="proxy1200" scope="session" value="http://cdv.yovisto.com/imageproxy/1200,q25/" />
<c:set var="proxyThumb" scope="session" value="http://cdv.yovisto.com/imageproxy/150,sc,q25/" />


<!--
<c:forEach items='${images.keySet()}' var="year">
<c:forEach items='${images.get(year)}' var="entry">
</c:forEach>
</c:forEach>
${year}
${entry.getYear()}
${entry.getWorkLabel()}
${entry.getDate()}
${entry.getDateLabel()}
${entry.getLabel()}
${entry.getImageUrl()}
-->

    

	<div id="hiddenreload"></div>

	<div class="browserInfo">
		<p>This visualization is not optimized for mobile phones and needs WebGL enabled.</p>
		<p>Please come back on a Computer.</p>
		<span>💡</span>
	</div>

	<div class="search"></div>

	<div class="page">

		<div class="detailLoader"></div>
		<div class="sideLoader"></div>

		<div class="sidebar detail hide">
			<div class="slidebutton"></div>

			<div class="outer">
				<div id="detail" class="inner">
					<div class="entries" v-if="item">
						<div v-if="item._imagenum > 1" class="entry wide pages">
							<div class="label">Seite</div>
							<div class="content">
								<span v-for="i in parseInt(item._imagenum)" v-bind:key="i" v-on:click="displayPage(i-1)" v-bind:class="{ active: i === page+1, keyword: true }">
									{{ i }}
								</span>
							</div>
						</div>
						<div v-for="entry in structure" v-bind:key="entry.name" v-bind:class="entry.display" class="entry" v-if="hasData(entry)">
							<div class="label">{{ entry.name }}</div>
							<div class="content">
								<span v-if="entry.type === 'keywords'">
									<span v-for="keyword in item[entry.source]" v-bind:key="keyword" class="keyword">
										{{ keyword }}
									</span>
								</span>
								<span v-else-if="entry.type === 'link'">
									<a :href="item[entry.source]" target="_blank">Link</a>
								</span>
								<span v-else-if="entry.type === 'markdown'">
									<span v-html="getContent(entry)"></span>
								</span>
								<span v-else>
									{{ getContent(entry) }}
								</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="navi hide">
			<div class="time button active">time</div>
			<div class="tsne button">tsne</div>
		</div>

		<div class="infobar sneak">
			<div class="infobutton">
				<svg width="16px" height="24px" viewBox="0 0 16 24">
					<path d="M13.6824546,2 L3.7109392,11.9715154 L13.7394238,22" stroke="#FFF" stroke-width="5"></path>
				</svg>
			</div>

			<div class="outer">
				<div class="inner">
					<div id="infobar" class="infosidebar">
						<span v-html="marked(info)"></span>
						<div class="credit">Powered by
							<a href="https://vikusviewer.fh-potsdam.de/" target="_blank">VIKUS Viewer</a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="searchbar">
			<input type="input" name="suche">
			<div class="button">
				<div class="openbutton"></div>
			</div>
		</div>
	</div>

	<script src="${conf.getStaticResourceURL()}vendor/vikusviewer
    /js/sidebars.js"></script>
    <script src="${conf.getStaticResourceURL()}vendor/vikusviewer
    /js/viz.js"></script>
    
	<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	<jsp:include page="inc/footer.jsp"></jsp:include>
</body>

</html>

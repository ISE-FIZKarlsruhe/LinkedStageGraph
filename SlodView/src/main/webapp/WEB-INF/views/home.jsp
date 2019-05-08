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

<c:set var="proxyImg" scope="session" value="http://cdv.yovisto.com/imageproxy/800,q65/" />
<c:set var="proxyThumb" scope="session" value="http://cdv.yovisto.com/imageproxy/150,sc,q25/" />

<body data-uk-filter="target: .js-filter">
	<jsp:include page="inc/custom_menu.jsp"></jsp:include>
	<div class="spacer"></div>
	
	

	<div class="uk-container">

		<div class="uk-child-width-1-2" uk-grid>

			<div>

				<p class="uk-text-justify">Linked Stage Graph is a Knowledge Graph developed as part of the <a href="https://codingdavinci.de/events/sued/">Coding da Vinci Süd 2019</a> hackathon 2019. The graph is being created using a dataset by the National Archive of Baden-Wuerttemberg. It contains black and white photographs and metadata about the Stuttgart State Theatre from the 1890s to the 1940s. <br>
				The nearly 7.000 photographs give vivid insights into on-stage events like theater plays, operas and ballet performances as well as off-stage moments and theater buildings. However, the images and the data set as they are currently organized are hard to use and explore for anyone who is unfamiliar with an achive’s logic to structure information. This project proposes means to <b>explore</b> and <b>understand</b> the data by <b>humans and machines</b> using linked data and interesting visualizations.</p>
			</div>
			<div>
				<p>Find out more about the project's workflow, goals and tools used.</p> <a class="uk-button uk-button-default" href="/about">About Linked Stage Graph</a> <br/>
				<p>Who has been working on this?</p> <a class="uk-button uk-button-default" href="/about#team">Team</a>
				<p>Explore the photographs and metadata using the Vikus Viewer</p> <button class="uk-button uk-button-default">Start Vikus Viewer</button>
			</div>
		</div>

		<h1>Linked Stage Graph Viewer</h1>
		<div class="uk-container">
			<p>
				The photographs are arranged in a timeline from 1912 to 1943 which can be explored by <b>scrolling</b> up and down. <b>Swiping</b> left and right reveals other performances which have taken place in the same year. <b>Hovering</b> each originally black and white photograph instanstly adds color to them. By <b>clicking</b> on a title, you are directed to the Lodview interface which shows you all metadata we have for each of the performances.
			</p>
		</div>
		<div class="" uk-grid>
			<div class="uk-width-5-6">
				<c:forEach items='${images.keySet()}' var="year">
					<h2 id="year${year}">${year}</h2>
					<div class="uk-position-relative uk-visible-toggle" tabindex="-1" uk-slider>

							<ul class="uk-slider-items uk-grid uk-grid-match" uk-height-viewport="offset-top: true; offset-top: 30">
								<c:forEach items='${images.get(year)}' var="entry">
								<li class="uk-width-5-5">
									<div class="uk-cover-container">
										
									<div class="uk-inline-clip uk-transition-toggle" tabindex="0" uk-cover>
										<img src='${proxyImg}${entry.getImageUrl()}' alt="" style="-webkit-filter: grayscale(1); filter: gray; filter: grayscale(1);">
										<img class="uk-transition-fade uk-position-cover" src='${proxyImg}${entry.getImageUrl()}' alt="">
									</div>
									
										<div class="uk-position-small uk-position-bottom uk-overlay uk-overlay-default uk-text-center uk-transition-toggle">
												<ul uk-slider-parallax="x: 200,-200" class="uk-thumbnav">
													<c:forEach items='${entry.getThumbnails()}' var="thumb" end="6">
														<li uk-slideshow-item="0"><a href="#"><img src="${proxyThumb}${thumb}" width="100" alt=""></a></li>
													</c:forEach>
												</ul>
											<h2 uk-slider-parallax="x: 100,-100"><a href='${entry.getResource().replace("http://example.org/cdv/","")}'>${entry.getLabel()}</a></h2>
											<p uk-slider-parallax="x: 200,-200">${entry.getDateLabel()}</p>
										</div>
										
										
									</div>
								</li></c:forEach>
							</ul>
						
							<div class="uk-light">
								<a class="uk-position-center-left uk-position-small uk-slidenav-large" href="#" uk-slidenav-previous uk-slider-item="previous"></a>
								<a class="uk-position-center-right uk-position-small uk-slidenav-large" href="#" uk-slidenav-next uk-slider-item="next"></a>
							</div>

							<ul class="uk-slider-nav uk-dotnav uk-flex-center uk-margin"></ul>

						</div>
				</c:forEach>
			</div>
		
			<div class="uk-width-1-6">
				<div uk-sticky="offset: 100">
				<ul class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; scroll: true">
					<c:forEach items='${images.keySet()}' var="year">
						<li><a href="#year${year}">${year}</a></li>
					</c:forEach>
				</ul>
				</div>
			</div>
		</div>
	</div>

	<!--
${year}
${entry.getYear()}
${entry.getWorkLabel()}
${entry.getDate()}
${entry.getDateLabel()}
${entry.getLabel()}
${entry.getImageUrl()}
-->



	

	<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	<jsp:include page="inc/footer.jsp"></jsp:include>
</body>

</html>

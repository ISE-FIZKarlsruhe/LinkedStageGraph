<%@page session="true"%><%@taglib uri="http://www.springframework.org/tags" prefix="sp"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	

	<div class="uk-container">
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
										<img src='${proxy1200}${entry.getImageUrl()}' alt="" style="-webkit-filter: grayscale(1); filter: gray; filter: grayscale(1);">
										<img class="uk-transition-fade uk-position-cover" src='${proxy1200}${entry.getImageUrl()}' alt="">
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

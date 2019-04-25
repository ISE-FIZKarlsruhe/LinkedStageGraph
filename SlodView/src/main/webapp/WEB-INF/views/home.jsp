<%@page session="true"%><%@taglib uri="http://www.springframework.org/tags" prefix="sp"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><html version="XHTML+RDFa 1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/">
<head data-color="${colorPair}" profile="http://www.w3.org/1999/xhtml/vocab">
<title>${results.getTitle()}LinkedStageGraph&mdash;LodView</title>
<jsp:include page="inc/home_header.jsp"></jsp:include>
</head>
<body data-uk-filter="target: .js-filter">
	<jsp:include page="inc/custom_menu.jsp"></jsp:include>
	<div class="spacer"></div>
	<!--CARDS WRAPPER-->
	<section class="uk-section uk-section-small uk-section-default uk-padding-remove-bottom">
		<div class="uk-container uk-container-expand uk-margin-large-bottom">
			<ul class="uk-subnav uk-subnav-pill">
				<li class="uk-active" data-uk-filter-control><a href="#">Show All</a></li>
				<li data-uk-filter-control="[data-tags*='Sommer']"><a href="#">Ein Sommernachtstraum</a></li>
				<li data-uk-filter-control="[data-tags*='Staatstheater']"><a href="#">Staatstheater</a></li>
				<li data-uk-filter-control=".1912"><a href="#">1912</a></li>
			</ul>
			
<!-- 
${entry.getYear()}
${entry.getWorkLabel()}
${entry.getDate()}
${entry.getDateLabel()}
${entry.getLabel()} 
-->

			<div class="uk-grid" data-ukgrid>
				<div class="uk-width-3-4">
					<div class="uk-grid uk-grid-medium uk-child-width-1-2@s uk-child-width-1-3@m uk-child-width-1-4@l  uk-child-width-1-5@xl uk-grid-match js-filter" data-uk-grid="masonry: true"">
						<!-- card -->
						
						<c:forEach items='${images.keySet()}' var="year">
							----- ${year} -----		
						  <c:forEach items='${images.get(year)}' var="entry" begin="0" end="30">												
							<div class="${entry.getYear()} ${entry.getWorkLabel()}" data-tags="${entry.getYear()} ${entry.getLabel()} ${entry.getWorkLabel()}">	
									<a href='${entry.getResource().replace("http://example.org/cdv/","")}'> 
										<div class="uk-card uk-card-small uk-card-default">
											<div class="uk-card-header">
												<div class="uk-grid uk-grid-small uk-text-small" data-uk-grid>
													<div class="uk-width-expand">
														<span class="cat-txt">${entry.getWorkLabel()}</span>
													</div>
													<div class="uk-width-auto uk-text-right uk-text-muted">
														${entry.getYear()}
													</div>
												</div>
											</div>
											<div class="uk-card-media">
												<div class="uk-inline-clip uk-transition-toggle" tabindex="0">
													<img class="lazy" data-src="${entry.getImageUrl()}" data-width="400" data-height="300" data-uk-img alt="" src="${entry.getImageUrl()}">
													<div class="uk-transition-slide-bottom uk-position-bottom uk-overlay uk-overlay-primary">
														<span data-uk-icon="icon:heart; ratio: 0.8"></span> 12.345 <span data-uk-icon="icon:comment; ratio: 0.8"></span> 12.345
													</div>
												</div>
												
											</div>
											<div class="uk-card-body">
												<h6 class="uk-margin-small-bottom uk-margin-remove-adjacent uk-text-bold">${entry.getLabel()}</h6>
												<p class="uk-text-small uk-text-muted">${entry.getDateLabel()}</p>
											</div>
										</div>
									</a>
								</div>
							</c:forEach>
						</c:forEach> 
						<!-- /card -->
					</div>
				</div>
				<div class="uk-width-1-4">
					<ul class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; scroll: true">
						<li><a href=".1912">1912</a></li>
						<li><a href=".1918">1918</a></li>
					</ul>
				</div> 
			</div>
		</div>
	</section>
	<!--/CARDS WRAPPER-->
					
	<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	<jsp:include page="inc/footer.jsp"></jsp:include>
</body>
</html>

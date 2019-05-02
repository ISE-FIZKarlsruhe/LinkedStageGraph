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
	

	ABOUT
	

	<jsp:include page="inc/custom_footer.jsp"></jsp:include>
	<jsp:include page="inc/footer.jsp"></jsp:include>
</body>

</html>

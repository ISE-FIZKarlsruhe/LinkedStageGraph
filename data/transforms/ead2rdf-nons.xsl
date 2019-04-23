<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet
   version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:owl="http://www.w3.org/2002/07/owl#"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema"
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:dcmitype="http://purl.org/dc/dcmitype/"
   xmlns:bibo="http://purl.org/ontology/bibo/"
   xmlns:foaf="http://xmlns.com/foaf/0.1/"
   xmlns:bio="http://purl.org/vocab/bio/0.1/"
   xmlns:skos="http://www.w3.org/2004/02/skos/core#"
   xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
   xmlns:ore="http://www.openarchives.org/ore/terms/"
   xmlns:lvont="http://lexvo.org/ontology#"
   xmlns:lode = "http://linkedevents.org/ontology/"
   xmlns:event="http://purl.org/NET/c4dm/event.owl#"
   xmlns:time = "http://www.w3.org/2006/time#"
   xmlns:timeline="http://purl.org/NET/c4dm/timeline.owl#"
   xmlns:arch="http://purl.org/archival/vocab/arch#"
   xmlns:crm="http://erlangen-crm.org/current/"
   xmlns:locah="http://data.archiveshub.ac.uk/def/"

>

<!-- 
Extended/amended by Pete Johnston for the Linking Lives project, 2011-2013
-->
<!--
Created by Pete Johnston, Eduserv for the LOCAH project, 2010-2011

Copyright (c) 2011, Eduserv
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Eduserv nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL EDUSERV BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->
<xsl:strip-space elements="*"/>

<xsl:output method="xml" indent="yes"/>

<xsl:param name="root">http://data.archiveshub.ac.uk/</xsl:param>

<!-- Variables for making URIs -->
<xsl:variable name="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:variable>
<xsl:variable name="rdfs">http://www.w3.org/2000/01/rdf-schema#</xsl:variable>
<xsl:variable name="owl">http://www.w3.org/2002/07/owl#</xsl:variable>
<xsl:variable name="xsd">http://www.w3.org/2001/XMLSchema#</xsl:variable>
<xsl:variable name="dcterms">http://purl.org/dc/terms/</xsl:variable>
<xsl:variable name="dcmitype">http://purl.org/dc/dcmitype/</xsl:variable>
<xsl:variable name="bibo">http://purl.org/ontology/bibo/</xsl:variable>
<xsl:variable name="foaf">http://xmlns.com/foaf/0.1/</xsl:variable>
<xsl:variable name="bio">http://purl.org/vocab/bio/0.1/</xsl:variable>
<xsl:variable name="skos">http://www.w3.org/2004/02/skos/core#</xsl:variable>
<xsl:variable name="wg84_pos">http://www.w3.org/2003/01/geo/wgs84_pos#</xsl:variable>
<xsl:variable name="ore">http://www.openarchives.org/ore/terms/</xsl:variable>
<xsl:variable name="lvont">http://lexvo.org/ontology#</xsl:variable>
<xsl:variable name="lode">http://linkedevents.org/ontology/</xsl:variable>
<xsl:variable name="event">http://purl.org/NET/c4dm/event.owl#</xsl:variable>
<xsl:variable name="time">http://www.w3.org/2006/time#</xsl:variable>
<xsl:variable name="timeline">http://purl.org/NET/c4dm/timeline.owl#</xsl:variable>
<xsl:variable name="crm">http://erlangen-crm.org/current/</xsl:variable>
<xsl:variable name="ref">http://reference.data.gov.uk/id/</xsl:variable>
<xsl:variable name="locah">http://data.archiveshub.ac.uk/def/</xsl:variable>

<!-- For making thing URIs -->
<xsl:variable name="id"><xsl:value-of select="concat($root, 'id/')" /></xsl:variable>

<xsl:variable name="hubpageroot">http://archiveshub.ac.uk/data/</xsl:variable>

<xsl:variable name="archonhtmlroot">http://www.nationalarchives.gov.uk/archon/searches/locresult_details.asp?LR=</xsl:variable>

<!-- This version uses the archdesc/did/unitid attributes to generate both the URI of the finding aid (under $hubpageroot) and the URI of the archival resources (under $id). distinguishes the maintenance agency of the EAD doc and the repository providing acccess to the materials -->

<!-- The eadid/@countrycode and eadid/@mainagencycode attribute values are used to construct the URI of the repository that maintains the finding aid -->
<xsl:variable name="macountrycode">
	<xsl:choose>
		<xsl:when test="/ead/eadheader/eadid/@countrycode">
			<xsl:value-of select="upper-case(normalize-space(/ead/eadheader/eadid/@countrycode))" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="matches(normalize-space(/ead/eadheader/eadid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
					<xsl:variable name="eadid" select="tokenize(normalize-space(/ead/eadheader/eadid), ' ')" />
					<xsl:choose>
						<xsl:when test="count($eadid) > 2">
							<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error: @countrycode attribute omitted - parsing content, using <xsl:value-of select="upper-case($eadid[1])"/></xsl:message>
							<xsl:value-of select="upper-case($eadid[1])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error: Unable to determine countrycode</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error: Unable to determine countrycode</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="mainagencycode">
	<xsl:choose>
		<xsl:when test="/ead/eadheader/eadid/@mainagencycode">
			<xsl:value-of select="xsd:integer(/ead/eadheader/eadid/@mainagencycode)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="matches(normalize-space(/ead/eadheader/eadid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
					<xsl:variable name="eadid" select="tokenize(normalize-space(/ead/eadheader/eadid), ' ')" />
					<xsl:choose>
						<xsl:when test="count($eadid) > 2">
							<xsl:choose>
								<xsl:when test="upper-case($eadid[1]) = $macountrycode">
									<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error:  @mainagencycode attribute omitted - parsing content, using <xsl:value-of select="normalize-space($eadid[2])"/></xsl:message>
									<xsl:value-of select="normalize-space($eadid[2])"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error: Unable to determine mainagencycode</xsl:message>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error: Unable to determine mainagencycode</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>eadid: <xsl:value-of select="/ead/eadheader/eadid"/> Error: Unable to determine mainagencycode</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="mainagencyid" select="concat(lower-case($macountrycode), xsd:integer($mainagencycode))" />

<!-- The URIs of the finding aid and of the EAD XML doc are constructed from the archdesc/did/unitid attributes, not from the eadid attributes -->

<xsl:variable name="aui">
	<xsl:choose>
		<xsl:when test="/ead/archdesc/did/unitid[@type='persistent']">
			<xsl:copy-of select="/ead/archdesc/did/unitid[@type='persistent'][1]"/>
		</xsl:when>
		<xsl:when test="/ead/archdesc/did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode and @identifier]">
			<xsl:copy-of select="/ead/archdesc/did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode and @identifier][1]" />
		</xsl:when>
		<xsl:when test="/ead/archdesc/did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode]">
			<xsl:copy-of select="/ead/archdesc/did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode][1]" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="/ead/archdesc/did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][1]" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	
<xsl:variable name="aui-countrycode">
	<xsl:choose>
		<xsl:when test="$aui/unitid/@countrycode">
			<xsl:value-of select="upper-case(normalize-space($aui/unitid/@countrycode))" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="matches(normalize-space($aui/unitid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
					<xsl:variable name="unitid" select="tokenize(normalize-space($aui), ' ')" />
					<xsl:choose>
						<xsl:when test="count($unitid) > 2">
							<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error: @countrycode attribute omitted - parsing content, using <xsl:value-of select="upper-case($unitid[1])"/></xsl:message>
							<xsl:value-of select="upper-case($unitid[1])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error: Unable to determine countrycode</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error: Unable to determine countrycode</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="aui-repositorycode">
	<xsl:choose>
		<xsl:when test="$aui/unitid/@repositorycode">
			<xsl:value-of select="normalize-space($aui/unitid/@repositorycode)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="matches(normalize-space($aui/unitid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
					<xsl:variable name="unitid" select="tokenize(normalize-space($aui), ' ')" />
					<xsl:choose>
						<xsl:when test="count($unitid) > 2">
							<xsl:choose>
								<xsl:when test="upper-case($unitid[1]) = $aui-countrycode">
									<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error:  @repositorycode attribute omitted - parsing content, using <xsl:value-of select="normalize-space($unitid[2])"/></xsl:message>
									<xsl:value-of select="normalize-space($unitid[2])"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error: Unable to determine repositorycode</xsl:message>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error: Unable to determine repositorycode</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>Unitid: <xsl:value-of select="$aui/unitid"/> Error: Unable to determine repositorycode</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="aui-identifier">
	<xsl:choose>
		<xsl:when test="$aui/unitid/@identifier">
			<xsl:value-of select="normalize-space($aui/unitid/@identifier)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="matches(normalize-space($aui/unitid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
					<xsl:variable name="unitid" select="tokenize(normalize-space($aui), ' ')" />
					<xsl:choose>
						<xsl:when test="count($unitid) > 2">
							<xsl:choose>
								<xsl:when test="(upper-case($unitid[1]) = $aui-countrycode) and ($unitid[2] = $aui-repositorycode)">
									<xsl:value-of select="substring-after(substring-after(normalize-space($aui), ' '), ' ')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="normalize-space($aui)" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space($aui/unitid)" />
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($aui/unitid)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	
<xsl:variable name="hub-aui-identifier">
	<xsl:call-template name="new-hubify">
		<xsl:with-param name="text" select="$aui-identifier" />
	</xsl:call-template>
</xsl:variable>

<xsl:variable name="findingaiduri" select="concat($hubpageroot, lower-case($aui-countrycode), $aui-repositorycode, '-', $hub-aui-identifier)" />

<xsl:variable name="units">
	<unit singular="archive box" plural="archive boxes" property="archbox" />
	<unit singular="box" plural="boxes" property="archbox" />
	<unit singular="linear metre" plural="linear metres" property="metre" />
	<unit singular="metre" plural="metres" property="metre" />
	<unit singular="meter" plural="meters" property="metre" />
	<unit singular="m" plural="m" property="metre" />
	<unit singular="cubic metre" plural="cubic metres" property="cubicmetre" />
	<unit singular="cubic meter" plural="cubic meters" property="cubicmetre" />
	<unit singular="folder" plural="folders" property="folder" />
	<unit singular="bundle" plural="bundles" property="bundle" />
	<unit singular="box file" plural="box files" property="boxfile" />
	<unit singular="envelope" plural="envelopes" property="envelope" />
	<unit singular="vol" plural="vols" property="volume" />
	<unit singular="volume" plural="volumes" property="volume" />
	<unit singular="file" plural="files" property="file" />
	<unit singular="item" plural="items" property="item" />
	<unit singular="page" plural="pages" property="page" />
	<unit singular="paper" plural="papers" property="paper" />
</xsl:variable>

<xsl:template match="document-node()">
        <xsl:message>Transforming document: <xsl:value-of select="document-uri(.)" /></xsl:message>
	<xsl:comment>Input document: <xsl:value-of select="document-uri(.)" /></xsl:comment>
	<xsl:comment>XSLT transform: <xsl:value-of select="static-base-uri()" /></xsl:comment>
	<xsl:comment>Time of transform: <xsl:value-of select="current-dateTime()" /></xsl:comment>

	<xsl:apply-templates />
</xsl:template>

<xsl:template match="ead">
	<xsl:element name="rdf:RDF">
		<xsl:apply-templates select="eadheader" />
		<xsl:apply-templates select="archdesc" />
	</xsl:element>
</xsl:template>

<xsl:template match="eadheader">

	<xsl:comment>About the finding aid</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="$findingaiduri" /></xsl:variable>

	<xsl:message>	
		<xsl:value-of select="concat('Finding Aid URI: ', $thing)"/>
	</xsl:message>

	<xsl:element name="locah:FindingAid">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Document')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
		</xsl:element>
		
		<xsl:if test="normalize-space(filedesc/titlestmt/titleproper)">
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:element>
			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:element>
			<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:element>
		</xsl:if>
		
		<xsl:element name="dcterms:identifier"><xsl:value-of select="normalize-space(/ead/eadheader/eadid)" /></xsl:element>
		<xsl:if test="normalize-space(filedesc/notestmt/note[not(lower-case(normalize-space(@audience))='internal')])">
			<xsl:element name="dcterms:description"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/notestmt/note)"/></xsl:element>
		</xsl:if>

		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about">http://dbpedia.org/resource/ISAD%28G%29</xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" />General International Standard for Archival Description</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" />General International Standard for Archival Description</xsl:element>
			</xsl:element>				
		</xsl:element>
		<xsl:element name="locah:maintenanceAgency">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'repository/', $mainagencyid)"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="locah:encodedAs">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($findingaiduri, '.xml')"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

	<xsl:comment>About the finding aid maintenance agency</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'repository/', $mainagencyid)" /></xsl:variable>
<!--	<xsl:variable name="label"><xsl:value-of select="normalize-space(../archdesc/did/repository)" /></xsl:variable> -->

	<xsl:element name="locah:Repository">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Organization')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')" /></xsl:attribute>
		</xsl:element>

<!--		
		<xsl:for-each select="../archdesc/did/repository[not(normalize-space(.) = '')]">
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
			<xsl:element name="foaf:name"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
		</xsl:for-each>
-->		
		<xsl:element name="dcterms:identifier"><xsl:value-of select="$mainagencyid"/></xsl:element>
		<xsl:element name="locah:countryCode"><xsl:value-of select="$macountrycode"/></xsl:element>
		<xsl:element name="locah:maintenanceAgencyCode"><xsl:value-of select="$mainagencycode"/></xsl:element>
		<xsl:element name="locah:isMaintenanceAgencyOf">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$findingaiduri"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="locah:administers">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'place/repository/', $mainagencyid)" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($archonhtmlroot, $mainagencycode)"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>

	</xsl:element>

	<xsl:comment>About the maintenance agency/place</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'place/repository/', $mainagencyid)" /></xsl:variable>
<!--	<xsl:variable name="label"><xsl:value-of select="normalize-space(../archdesc/did/repository)" /></xsl:variable> -->

	<xsl:element name="wgs84_pos:SpatialThing">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
<!--
		<xsl:for-each select="../archdesc/did/repository[not(normalize-space(.) = '')]">
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
			<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
		</xsl:for-each>
-->
		<xsl:element name="locah:isAdministeredBy">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'repository/', $mainagencyid)" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($archonhtmlroot, $mainagencycode)"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:element>

	<xsl:comment>About the EAD XML form of the finding aid</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($findingaiduri, '.xml')"/></xsl:variable>

	<xsl:element name="locah:EAD">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Document')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
		</xsl:element>
		
		<xsl:if test="normalize-space(filedesc/titlestmt/titleproper)">
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:element>
			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:element>
			<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:element>
		</xsl:if>

		<xsl:element name="dcterms:identifier"><xsl:value-of select="normalize-space(/ead/eadheader/eadid)" /></xsl:element>
		<xsl:if test="profiledesc/creation">
			<xsl:element name="dcterms:description"><xsl:value-of select="profiledesc/creation"/></xsl:element>
		</xsl:if>
		<!-- could also pull creator name? -->
		<xsl:if test="profiledesc/creation/date">
			<xsl:element name="dcterms:created">
				<xsl:value-of select="profiledesc/creation/date" />
			</xsl:element>
		</xsl:if>
		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about">http://dbpedia.org/resource/Encoded_Archival_Description</xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" />Encoded Archival Description</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" />Encoded Archival Description</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'standard/ead2002')" /></xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" />Encoded Archival Description (EAD) Version 2002</xsl:element>
				<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" />Encoded Archival Description (EAD) Version 2002</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" />Encoded Archival Description (EAD) Version 2002</xsl:element>
				<xsl:element name="foaf:homepage">
					<xsl:element name="foaf:Document">
						<xsl:attribute name="rdf:about">http://loc.gov/ead/</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>				
		</xsl:element>
		<xsl:element name="locah:encodingOf">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$findingaiduri" /></xsl:attribute>
		</xsl:element>

	</xsl:element>
	
</xsl:template>

<xsl:template match="archdesc">

	<xsl:comment>About the top-level archival resource/unit of description</xsl:comment>

	<xsl:call-template name="make-uod-desc" />

</xsl:template>

<xsl:template match="c01|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12|c">
<xsl:param name="top-identifier" />
<xsl:param name="parent" />

	<xsl:comment>About the <xsl:value-of select="local-name(.)" /> archival resource/unit of description <xsl:value-of select="position()"/></xsl:comment>
	
	<xsl:call-template name="make-uod-desc">
		<xsl:with-param name="top-identifier" select="$top-identifier" />
		<xsl:with-param name="parent" select="$parent" />
	</xsl:call-template>

</xsl:template>

<xsl:template name="make-uod-desc">
<xsl:param name="top-identifier" />
<xsl:param name="parent" />

	<xsl:variable name="selectedunitid">
		<xsl:choose>
			<xsl:when test="did/unitid[@type='persistent']">
				<xsl:copy-of select="did/unitid[@type='persistent'][1]"/>
			</xsl:when>
			<xsl:when test="did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode and @identifier]">
				<xsl:copy-of select="did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode and @identifier][1]" />
			</xsl:when>
			<xsl:when test="did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode]">
				<xsl:copy-of select="did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][@countrycode and @repositorycode][1]" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')][1]" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	
	<xsl:variable name="countrycode">
		<xsl:choose>
			<xsl:when test="$selectedunitid/unitid/@countrycode">
				<xsl:value-of select="upper-case(normalize-space($selectedunitid/unitid/@countrycode))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="matches(normalize-space($selectedunitid/unitid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
						<xsl:variable name="unitid" select="tokenize(normalize-space($selectedunitid), ' ')" />
						<xsl:choose>
							<xsl:when test="count($unitid) > 2">
								<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error: @countrycode attribute omitted - parsing content, using <xsl:value-of select="upper-case($unitid[1])"/></xsl:message>
								<xsl:value-of select="upper-case($unitid[1])"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error: Unable to determine countrycode</xsl:message>
							</xsl:otherwise>
						</xsl:choose>
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error: Unable to determine countrycode</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="repositorycode">
		<xsl:choose>
			<xsl:when test="$selectedunitid/unitid/@repositorycode">
				<xsl:value-of select="normalize-space($selectedunitid/unitid/@repositorycode)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="matches(normalize-space($selectedunitid/unitid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
						<xsl:variable name="unitid" select="tokenize(normalize-space($selectedunitid), ' ')" />
						<xsl:choose>
							<xsl:when test="count($unitid) > 2">
								<xsl:choose>
									<xsl:when test="upper-case($unitid[1]) = $countrycode">
										<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error:  @repositorycode attribute omitted - parsing content, using <xsl:value-of select="normalize-space($unitid[2])"/></xsl:message>
										<xsl:value-of select="normalize-space($unitid[2])"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error: Unable to determine repositorycode</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error: Unable to determine repositorycode</xsl:message>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Unitid: <xsl:value-of select="$selectedunitid/unitid"/> Error: Unable to determine repositorycode</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="identifier">
		<xsl:choose>
			<xsl:when test="$selectedunitid/unitid/@identifier">
				<xsl:value-of select="normalize-space($selectedunitid/unitid/@identifier)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="matches(normalize-space($selectedunitid/unitid), '^\W*?([A-Za-z]{2})\W*?(\d+)(.*)')">
						<xsl:variable name="unitid" select="tokenize(normalize-space($selectedunitid), ' ')" />
						<xsl:choose>
							<xsl:when test="count($unitid) > 2">
								<xsl:choose>
									<xsl:when test="(upper-case($unitid[1]) = $countrycode) and ($unitid[2] = $repositorycode)">
										<xsl:value-of select="substring-after(substring-after(normalize-space($selectedunitid), ' '), ' ')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space($selectedunitid)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space($selectedunitid/unitid)" />
							</xsl:otherwise>
						</xsl:choose>
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space($selectedunitid/unitid)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="hub-identifier">
		<xsl:call-template name="new-hubify">
			<xsl:with-param name="text" select="$identifier" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="thing">
		<xsl:choose>
			<xsl:when test="$top-identifier">
				<xsl:value-of select="concat($id, 'archivalresource/', lower-case($countrycode), $repositorycode, '-', $top-identifier, '/', $hub-identifier)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($id, 'archivalresource/', lower-case($countrycode), $repositorycode, '-', $hub-identifier)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="hubpage">
		<xsl:choose>
			<xsl:when test="$top-identifier">
				<xsl:value-of select="concat($hubpageroot, lower-case($countrycode), $repositorycode, '-', $top-identifier, '/', $hub-identifier)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($hubpageroot, lower-case($countrycode), $repositorycode, '-', $hub-identifier)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	

	<xsl:message>
		<xsl:value-of select="concat('Processing unit: ', normalize-space($selectedunitid))"/>
	</xsl:message>
	<xsl:message>
		<xsl:value-of select="concat('Countrycode: ', normalize-space($countrycode))"/>
	</xsl:message>
	<xsl:message>
		<xsl:value-of select="concat('Repositorycode: ', normalize-space($repositorycode))"/>
	</xsl:message>
	<xsl:message>
		<xsl:value-of select="concat('Identifier: ', normalize-space($identifier))"/>
	</xsl:message>
	<xsl:message>
		<xsl:value-of select="concat('Hub Identifier: ', normalize-space($hub-identifier))"/>
	</xsl:message>
	<xsl:message>
		<xsl:value-of select="concat('Arch Resource URI: ', $thing)"/>
	</xsl:message>
	<xsl:message>
		<xsl:value-of select="concat('Hub Page URI: ', $hubpage)"/>
	</xsl:message>

	<xsl:element name="locah:ArchivalResource">
		
		<xsl:attribute name="rdf:about"><xsl:value-of select="$thing" /></xsl:attribute>

		<xsl:element name="foaf:page">
			<xsl:element name="locah:FindingAid">
				<xsl:attribute name="rdf:about"><xsl:value-of select="$findingaiduri"/></xsl:attribute>
				<xsl:element name="foaf:topic">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="dcterms:subject">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
<!--
		<xsl:element name="locah:accessProvidedBy">
			<xsl:element name="locah:Repository">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'repository/', $repositoryid)" /></xsl:attribute>
				<xsl:element name="locah:providesAccessTo">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
-->
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="@level='otherlevel'">
					<xsl:value-of select="@otherlevel" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@level" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="not($level = '')">
			<xsl:element name="locah:level">
	
				<xsl:comment>About the level of description</xsl:comment>
	
				<xsl:variable name="thing"><xsl:value-of select="concat($id, 'level/', $level)" /></xsl:variable>
				<xsl:variable name="label"><xsl:value-of select="$level" /></xsl:variable>
				
				<xsl:element name="locah:Level">
					<xsl:attribute name="rdf:about"><xsl:value-of select="$thing" /></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($skos, 'Concept')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$level"/></xsl:element>
					<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$level"/></xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>

		<xsl:apply-templates select="did/unitid[not(normalize-space(.) = '')][not(starts-with(lower-case(normalize-space(.)), 'former reference'))][not(lower-case(normalize-space(@label))='former reference')][not(lower-case(normalize-space(@audience))='internal')]">
			<xsl:with-param name="thing" select="$thing" />
			<xsl:with-param name="countrycode" select="$countrycode" />
			<xsl:with-param name="repositorycode" select="$repositorycode" />
		</xsl:apply-templates>
		
		<xsl:apply-templates select="did/repository[not(normalize-space(.) = '')]">
			<xsl:with-param name="thing" select="$thing" />
			<xsl:with-param name="countrycode" select="$countrycode" />
			<xsl:with-param name="repositorycode" select="$repositorycode" />
		</xsl:apply-templates>
		
		<xsl:apply-templates select="did/unittitle[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]"/>

		<xsl:apply-templates select="did/unitdate[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]">
			<xsl:with-param name="thing" select="$thing" />
			<xsl:with-param name="label" select="normalize-space(did/unittitle[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')][1])" />
		</xsl:apply-templates>

		<xsl:apply-templates select="did/physdesc/extent[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]">
			<xsl:with-param name="thing" select="$thing" />
		</xsl:apply-templates>
		<xsl:apply-templates select="did/langmaterial/language"/>
		
		<xsl:apply-templates select="did/dao" >
			<xsl:with-param name="thing"><xsl:value-of select="$thing"/></xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="did/daogrp">
			<xsl:with-param name="thing"><xsl:value-of select="$thing"/></xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="did/origination[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]">
			<xsl:with-param name="unit"><xsl:value-of select="$thing"/></xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="bioghist[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]">
			<xsl:with-param name="unit"><xsl:value-of select="$thing"/></xsl:with-param>
			<xsl:with-param name="label" select="normalize-space(did/unittitle[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')][1])" />
		</xsl:apply-templates>
		
		<xsl:apply-templates select="custodhist[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="acqinfo[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="scopecontent[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="appraisal[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="accruals[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="accessrestrict[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="userestrict[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="phystech[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="otherfindaid[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="originalsloc[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="altformavail[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="relatedmaterial[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="bibliography[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="note[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />
		<xsl:apply-templates select="processinfo[not(normalize-space(.) = '')][not(lower-case(normalize-space(@audience))='internal')]" />

		<xsl:apply-templates select="controlaccess/subject[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/persname[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/famname[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/corpname[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/geogname[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/title[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/genreform[not(normalize-space(.) = '')]" />
		<xsl:apply-templates select="controlaccess/function[not(normalize-space(.) = '')]" />

		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="$hubpage"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:if test="dsc/c01|dsc/c|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12|c">
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($ore, 'Aggregation')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcmitype, 'Collection')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Collection')" /></xsl:attribute>
			</xsl:element>
		</xsl:if>

		<xsl:choose>
		<xsl:when test="$parent">
			<xsl:element name="dcterms:isPartOf">
				<xsl:element name="locah:ArchivalResource">
					<xsl:attribute name="rdf:about" select="$parent" />
					<xsl:element name="dcterms:hasPart">
						<xsl:attribute name="rdf:resource" select="$thing" />
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="ore:isAggregatedBy">
				<xsl:element name="locah:ArchivalResource">
					<xsl:attribute name="rdf:about" select="$parent" />
					<xsl:element name="ore:aggregates">
						<xsl:attribute name="rdf:resource" select="$thing" />
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
		</xsl:choose>
		
<!--
		<xsl:for-each select="dsc/c01|dsc/c|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12|c">
			<xsl:element name="dcterms:hasPart">
				<xsl:element name="locah:ArchivalResource">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($thing, '-', position())" /></xsl:attribute>
					<xsl:element name="dcterms:isPartOf">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing" /></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="ore:aggregates">
				<xsl:element name="locah:ArchivalResource">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($thing, '-', position())" /></xsl:attribute>
					<xsl:element name="ore:isAggregatedBy">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing" /></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
-->		
	</xsl:element>

	<xsl:apply-templates select="dsc/c01|dsc/c" >
		<xsl:with-param name="top-identifier" select="$hub-identifier" />
		<xsl:with-param name="parent" select="$thing" />
	</xsl:apply-templates>

	<xsl:apply-templates select="c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12|c" >
		<xsl:with-param name="top-identifier" select="$top-identifier" />
		<xsl:with-param name="parent" select="$thing" />
	</xsl:apply-templates>

</xsl:template>


<xsl:template match="did/unitid">
<xsl:param name="thing" />
<xsl:param name="countrycode" />
<xsl:param name="repositorycode" />

	<xsl:element name="dcterms:identifier"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:if test="not(normalize-space($countrycode)='') and not(normalize-space($repositorycode)='')">
		
		<xsl:variable name="repositoryid" select="concat(lower-case($countrycode), xsd:integer($repositorycode))" />

		<xsl:element name="locah:accessProvidedBy">
			<xsl:element name="locah:Repository">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'repository/', $repositoryid)" /></xsl:attribute>

				<xsl:element name="locah:providesAccessTo">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>

				<xsl:element name="locah:administers">
					<xsl:element name="wgs84_pos:SpatialThing">
						<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'place/repository/', $repositoryid)" /></xsl:attribute>

						<xsl:element name="locah:isAdministeredBy">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'repository/', $repositoryid)" /></xsl:attribute>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>

	</xsl:if>

</xsl:template>


<xsl:template match="did/repository">
<xsl:param name="thing" />
<xsl:param name="countrycode" />
<xsl:param name="repositorycode" />
		
	<xsl:if test="not(normalize-space($countrycode)='') and not(normalize-space($repositorycode)='')">
		
		<xsl:variable name="repositoryid" select="concat(lower-case($countrycode), xsd:integer($repositorycode))" />

		<xsl:element name="locah:accessProvidedBy">
			<xsl:element name="locah:Repository">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'repository/', $repositoryid)" /></xsl:attribute>

				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
				<xsl:element name="foaf:name"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
				
				<xsl:element name="locah:providesAccessTo">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>

				<xsl:element name="locah:administers">
					<xsl:element name="wgs84_pos:SpatialThing">
						<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'place/repository/', $repositoryid)" /></xsl:attribute>

						<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
						<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>

						<xsl:element name="locah:isAdministeredBy">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'repository/', $repositoryid)" /></xsl:attribute>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>

	</xsl:if>
		
		
</xsl:template>


<xsl:template match="did/unittitle">

	<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
	
</xsl:template>

<!--
<xsl:template match="did/unitdate">
	<xsl:element name="locah:unitdatestring"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>
-->

<xsl:template match="did/unitdate">
<xsl:param name="thing" />
<xsl:param name="label" />

	<xsl:element name="dcterms:date"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="locah:dateCreatedAccumulatedString"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:variable name="indates">
		<xsl:choose>
			<xsl:when test="@normal and not(normalize-space(@normal) = '')">
				<xsl:value-of select="translate(normalize-space(@normal), '-', '/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(normalize-space(.), '-', '/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
<!--
	<xsl:element name="locah:unitdateString"><xsl:value-of select="$indates"/></xsl:element>
-->

	<xsl:call-template name="make-unitdate-event">
		<xsl:with-param name="thing" select="$thing" />
		<xsl:with-param name="label" select="$label" />
		<xsl:with-param name="indates" select="$indates" />
	</xsl:call-template>

</xsl:template>

<xsl:template name="make-unitdate-event">
<xsl:param name="thing" />
<xsl:param name="label" />
<xsl:param name="indates" />


	<xsl:choose>
	<!-- Test for yyyymmdd/yyyymmdd with mm, dd optional -->
	<xsl:when test="matches(translate($indates, ' ', ''), '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?/[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	

		<xsl:variable name="dates" select="tokenize(translate($indates, ' ', ''), '/')"/>
		
		<xsl:variable name="startdate" select="$dates[1]"/>
		<xsl:variable name="enddate" select="$dates[2]"/>
		<xsl:element name="locah:dateCreatedAccumulatedStart">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="locah:dateCreatedAccumulatedEnd">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate" />
			</xsl:call-template>
		</xsl:element>

		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-period">
				<xsl:with-param name="thing" select="$thing" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="startdate" select="$startdate" />
				<xsl:with-param name="enddate" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
	</xsl:when>
	<!-- Test for yyyymmdd with mm, dd optional -->
	<xsl:when test="matches(translate($indates, ' ', ''), '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	

		<xsl:variable name="date" select="translate($indates, ' ', '')"/>
		<xsl:element name="locah:dateCreatedAccumulated">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
				
		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-date">
				<xsl:with-param name="thing" select="$thing" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
				
	</xsl:when>
	<!-- Test for dd MMM yyyy -->
	<xsl:when test="matches($indates, '^(([1-9])|(0[1-9])|([1-2]\d)|(3[0-1]))\s(Jan|January|Feb|February|Mar|March|Apr|April|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December)\s[1-9]\d{3}$')">

		<xsl:variable name="dateparts" select="tokenize($indates, ' ')"/>
		
		<xsl:variable name="dd" select="$dateparts[1]" />
		<xsl:variable name="yyyy" select="$dateparts[3]" />
		
		<xsl:variable name="mm">
			<xsl:variable name="short" select="index-of(('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'), $dateparts[2])" />
			<xsl:choose>
				<xsl:when test="$short">
					<xsl:value-of select="format-number($short, '00')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="long" select="index-of(('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'), $dateparts[2])" />
					<xsl:value-of select="format-number($long, '00')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="date" select="concat($yyyy, $mm, $dd)"/>
		<xsl:element name="locah:dateCreatedAccumulated">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-date">
				<xsl:with-param name="thing" select="$thing" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
	</xsl:when>
	<!-- Test for MMM yyyy -->
	<xsl:when test="matches($indates, '^(Jan|January|Feb|February|Mar|March|Apr|April|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December)\s[1-9]\d{3}$')">

		<xsl:variable name="dateparts" select="tokenize($indates, ' ')"/>
		
		<xsl:variable name="yyyy" select="$dateparts[2]" />

		<xsl:variable name="mm">
			<xsl:variable name="short" select="index-of(('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'), $dateparts[1])" />
			<xsl:choose>
				<xsl:when test="$short">
					<xsl:value-of select="format-number($short, '00')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="long" select="index-of(('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'), $dateparts[1])" />
					<xsl:value-of select="format-number($long, '00')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="date" select="concat($yyyy, $mm)"/>
		<xsl:element name="locah:dateCreatedAccumulated">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-date">
				<xsl:with-param name="thing" select="$thing" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
	</xsl:when>
	<xsl:otherwise />
	</xsl:choose>
</xsl:template>

<xsl:template name="make-creation-event-period">
<xsl:param name="thing" />
<xsl:param name="label" />
<xsl:param name="startdate" />
<xsl:param name="enddate" />
	
	<xsl:comment>About the Creation (Event)</xsl:comment> 

	<xsl:element name="locah:Creation">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($thing, 'archivalresource', 'creation')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="event:product">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involved">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-as-range">
				<xsl:with-param name="uri" select="replace($thing, 'archivalresource', 'creationtime')" />
				<xsl:with-param name="label" select="concat('Time of Creation of ', $label)" />
				<xsl:with-param name="startdate" select="$startdate" />
				<xsl:with-param name="enddate" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($thing, 'archivalresource', 'creationtime')" />
			</xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-creation-event-date">
<xsl:param name="thing" />
<xsl:param name="label" />
<xsl:param name="date" />

	<xsl:comment>About the Creation (Event)</xsl:comment> 

	<xsl:element name="locah:Creation">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($thing, 'archivalresource', 'creation')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="event:product">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involved">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-during-date">
				<xsl:with-param name="uri" select="replace($thing, 'archivalresource', 'creationtime')" />
				<xsl:with-param name="label" select="concat('Time of Creation of ', $label)" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($thing, 'archivalresource', 'creationtime')" />
			</xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>


<xsl:template match="did/physdesc/extent">
<xsl:param name="thing" />
	

	<xsl:element name="locah:extent"><xsl:value-of select="normalize-space(.)"/></xsl:element>
		
	<xsl:variable name="extent" select ="lower-case(normalize-space(.))" />
	
	<xsl:element name="dcterms:extent">
		<xsl:comment>About the Extent</xsl:comment> 
				
		<xsl:variable name="out">
			<xsl:for-each select="$units/unit">
				<xsl:choose>
					<xsl:when test="ends-with($extent, @singular)">
						<xsl:if test="matches(normalize-space(substring-before($extent, @singular)), '(^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)')">
							<xsl:variable name="number" select="xsd:decimal(normalize-space(substring-before($extent, @singular)))" />
							<xsl:element name="locah:Extent">
								<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'extent/', @property, '/', $number)"/></xsl:attribute>
								<xsl:element name="locah:{@property}">
									<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#decimal</xsl:attribute>
									<xsl:value-of select="$number" />
								</xsl:element>
								<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$extent" /></xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="ends-with($extent, @plural)">
						<xsl:if test="matches(normalize-space(substring-before($extent, @plural)), '(^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)')">
							<xsl:variable name="number" select="xsd:decimal(normalize-space(substring-before($extent, @plural)))" />
							<xsl:element name="locah:Extent">
								<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'extent/', @property, '/', $number)"/></xsl:attribute>
								<xsl:element name="locah:{@property}">
									<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#decimal</xsl:attribute>
									<xsl:value-of select="$number" />
								</xsl:element>
								<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$extent" /></xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise />
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
				
		<xsl:choose>
			<xsl:when test="not($out = '')">
				<xsl:copy-of select="$out" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="locah:Extent">
					<xsl:attribute name="rdf:about"><xsl:value-of select="replace($thing, 'archivalresource', 'extent')"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$extent" /></xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	
</xsl:template>

<xsl:template match="did/langmaterial/language">
	<xsl:element name="dcterms:language">
		<xsl:element name="lvont:Language">
			<xsl:attribute name="rdf:about"><xsl:value-of select="concat('http://lexvo.org/id/iso639-3/', @langcode)"/></xsl:attribute>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="did/dao">
<xsl:param name="thing" />
	<xsl:element name="locah:isRepresentedBy">
		<xsl:element name="foaf:Document">
			<xsl:attribute name="rdf:about"><xsl:value-of select="normalize-space(@href)" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="locah:represents">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing" /></xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="did/daogrp">
<xsl:param name="thing" />

	<xsl:variable name="group"><xsl:value-of select="concat(replace($thing, '/archivalresource/', '/group/'), '-', position())" /></xsl:variable>

	<xsl:element name="locah:isRepresentedBy">
		<xsl:element name="ore:Aggregation">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$group" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcmitype, 'Collection')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Collection')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="locah:represents">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing" /></xsl:attribute>
			</xsl:element>
			<xsl:for-each select="daoloc">
				<xsl:element name="ore:aggregates">
					<xsl:element name="foaf:Document">
						<xsl:attribute name="rdf:about"><xsl:value-of select="normalize-space(@href)" /></xsl:attribute>
						<xsl:element name="rdf:type">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
						</xsl:element>
						<xsl:element name="ore:isAggregatedBy">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="$group" /></xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="did/origination">
<xsl:param name="unit" />

	<xsl:variable name="origination">
		<xsl:value-of select="concat($id, 'agent/', $mainagencyid, '/')" /><xsl:call-template name="slugify"><xsl:with-param name="text" select="." /></xsl:call-template>
	</xsl:variable>

	<xsl:element name="locah:origination">
		<xsl:element name="foaf:Agent">	
			<xsl:attribute name="rdf:about"><xsl:value-of select="$origination" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
			<xsl:element name="foaf:name"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="normalize-space(.)"/></xsl:element>
			
			<xsl:for-each select="../../bioghist">
			<!-- <xsl:if test="not($bioghist = '')"> -->
				<xsl:variable name="bioghist">
					<xsl:value-of select="replace($unit, '/archivalresource/', '/bioghist/')" />
				</xsl:variable>

				<xsl:element name="foaf:page">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$bioghist" /></xsl:attribute>
				</xsl:element>
			<!-- </xsl:if> -->
			</xsl:for-each>
			<xsl:element name="locah:isOriginationOf">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$unit" /></xsl:attribute>
			</xsl:element>
			
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template match="bioghist">
<xsl:param name="unit" />
<xsl:param name="label" />

	<xsl:variable name="bioghist">
		<xsl:value-of select="replace($unit, '/archivalresource/', '/bioghist/')" />
	</xsl:variable>

	<xsl:element name="locah:hasBiographicalHistory">
		<xsl:element name="locah:BiographicalHistory">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$bioghist" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Document')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'DocumentPart')" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Biographical History for: ', $label)"/></xsl:element>
			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Biographical History for: ', $label)"/></xsl:element>
			<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Biographical History for: ', $label)"/></xsl:element>

			<xsl:if test="not(normalize-space(.) = '')">
				<xsl:element name="locah:body">
					<xsl:attribute name="xml:lang" select="'en'" />
					<xsl:value-of select="*"/>
				</xsl:element>
			</xsl:if>

			<xsl:for-each select="../did/origination">
			<!--
			<xsl:if test="not($origination = '')">
			-->
				<xsl:variable name="origination">
					<xsl:value-of select="concat($id, 'agent/', $mainagencyid, '/')" /><xsl:call-template name="slugify"><xsl:with-param name="text" select="." /></xsl:call-template>
				</xsl:variable>

				<xsl:element name="foaf:topic">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$origination" /></xsl:attribute>
				</xsl:element>
				<xsl:element name="dcterms:subject">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$origination" /></xsl:attribute>
				</xsl:element>
			<!--
			</xsl:if>
			-->
			</xsl:for-each>
			<xsl:element name="locah:isBiographicalHistoryFor">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$unit" /></xsl:attribute>
			</xsl:element>
			<xsl:element name="dcterms:isPartOf">
				<xsl:element name="locah:FindingAid">
					<xsl:attribute name="rdf:about"><xsl:value-of select="$findingaiduri"/></xsl:attribute>
					<xsl:element name="dcterms:hasPart">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="$bioghist" /></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="custodhist">

	<xsl:element name="locah:custodialHistory">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="acqinfo">

	<xsl:element name="locah:acquisitions">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="scopecontent">

	<xsl:element name="locah:scopecontent">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="appraisal">

	<xsl:element name="locah:appraisal">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>

</xsl:template>

<xsl:template match="accruals">

	<xsl:element name="locah:accruals">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>

</xsl:template>

<xsl:template match="accessrestrict">

	<xsl:element name="locah:accessRestrictions">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>

</xsl:template>

<xsl:template match="userestrict">

	<xsl:element name="locah:useRestrictions">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="phystech">

	<xsl:element name="locah:physicalTechnicalRequirements">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="otherfindaid">

	<xsl:element name="locah:otherFindingAids">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="originalsloc">

	<xsl:element name="locah:locationOfOriginals">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="altformavail">

	<xsl:element name="locah:alternateFormsAvailable">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>

</xsl:template>

<xsl:template match="relatedmaterial">

	<xsl:element name="locah:relatedMaterial">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="bibliography">

	<xsl:element name="locah:bibliography">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="note">

	<xsl:element name="locah:note">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="processinfo">

	<xsl:element name="locah:processing">
		<xsl:attribute name="xml:lang" select="'en'" />
		<xsl:value-of select="*"/>
	</xsl:element>
	
</xsl:template>

<xsl:template match="controlaccess/subject">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/', $prefix, '/', $slug)" /></xsl:variable>
	
	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Subject)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='a'][not(normalize-space(.) = '')]">
	<xsl:element name="locah:name"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='y'][not(normalize-space(.) = '')]">
	<xsl:element name="locah:dates"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='z'][not(normalize-space(.) = '')]">
	<xsl:element name="locah:location"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='x'][not(normalize-space(.) = '')]">
	<xsl:element name="locah:other"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/person/', $prefix, '/', $slug)" /></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'person/', $prefix, '/', $slug)" /></xsl:variable>
	
	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Person)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element> -->
			
			<xsl:apply-templates mode="concept" />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Person</xsl:comment> 
				<xsl:element name="foaf:Person">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus" /></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E21_Person')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
					<xsl:apply-templates mode="person">
						<xsl:with-param name="thing" select="$focus" />
						<xsl:with-param name="label" select="$label" />
					</xsl:apply-templates>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:surname"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />
	<xsl:element name="foaf:familyName"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name">
		<xsl:for-each select="../emph[@altrender='forename'][not(normalize-space(.) = '')]">
			<xsl:value-of select="concat(normalize-space(.), ' ')" />
		</xsl:for-each>
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='surname'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:surname"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='surname'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />
	<xsl:element name="foaf:familyName"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name">
		<xsl:for-each select="../emph[@altrender='forename'][not(normalize-space(.) = '')]">
			<xsl:value-of select="concat(normalize-space(.), ' ')" />
		</xsl:for-each>
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='forename'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:forename"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='forename'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />
	<xsl:element name="foaf:givenName"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />

	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:variable name="indates" select="translate(normalize-space(.), '-.() ', '/')"/>

	<xsl:call-template name="make-life-events">
		<xsl:with-param name="person" select="$thing" />
		<xsl:with-param name="label" select="$label" />
		<xsl:with-param name="indates" select="$indates" />
	</xsl:call-template>

</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='dates'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='dates'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />

	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:variable name="indates" select="translate(normalize-space(.), '-.() ', '/')"/>

	<xsl:call-template name="make-life-events">
		<xsl:with-param name="person" select="$thing" />
		<xsl:with-param name="label" select="$label" />
		<xsl:with-param name="indates" select="$indates" />
	</xsl:call-template>

</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='title'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='title'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />
	<xsl:element name="locah:title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='epithet'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:epithet"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='epithet'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />
	<xsl:element name="locah:epithet"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="person">
<xsl:param name="thing" />
<xsl:param name="label" />
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/family/', $prefix, '/', $slug)" /></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'family/', $prefix, '/', $slug)" /></xsl:variable>
	
	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Family)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates mode="concept" />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Family</xsl:comment> 
				<xsl:element name="locah:Family">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus" /></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Group')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
					<xsl:apply-templates mode="family" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="family">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="family">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='z'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='z'][not(normalize-space(.) = '')]" mode="family">
	<xsl:element name="locah:location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="family">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/organisation/', $prefix, '/', $slug)" /></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'organisation/', $prefix, '/', $slug)" /></xsl:variable>
	
	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Organisation)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates mode="concept" />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Organisation</xsl:comment> 
				<xsl:element name="foaf:Organization">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus" /></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')" /></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')" /></xsl:attribute>
					</xsl:element>
					<xsl:apply-templates mode="organisation" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="organisation">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="organisation">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='z'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='z'][not(normalize-space(.) = '')]" mode="organisation">
	<xsl:element name="locah:location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="organisation">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/place/', $prefix, '/', $slug)" /></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'place/', $prefix, '/', $slug)" /></xsl:variable>
	
	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Place)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates mode="concept" />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Place</xsl:comment> 
				<xsl:element name="wgs84_pos:SpatialThing">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus" /></xsl:attribute>
					<xsl:element name="rdfs:label">
						<xsl:attribute name="xml:lang" select="'en'" />
						<xsl:choose>
							<xsl:when test="emph[@altrender]">
								<xsl:for-each select="emph[@altrender='location' or @altrender='a' or @altrender='z']">
									<xsl:value-of select="normalize-space(.)" />
									<xsl:if test="not(position() = last())">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(.)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:apply-templates mode="place" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='a'][not(normalize-space(.) = '')]" mode="place">
<!--	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element> -->
	<xsl:element name="locah:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='location'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='location'][not(normalize-space(.) = '')]" mode="place">
<!--	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element> -->
	<xsl:element name="locah:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<!-- concept only? -->
<xsl:template match="controlaccess/geogname/emph[@altrender='y'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='z'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='z'][not(normalize-space(.) = '')]" mode="place">
	<xsl:element name="locah:location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="concept">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='x'][not(normalize-space(.) = '')]" mode="place">
	<xsl:element name="locah:other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/genreform">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/', $prefix, '/', $slug)" /></xsl:variable>
	
	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Genre/Form)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($locah, 'GenreForm')"/></xsl:attribute>
			</xsl:element>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>
			
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/genreform/emph[@altrender='genre'][not(normalize-space(.) = '')]">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="skos:prefLabel"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/function">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/', $prefix, '/', $slug)" /></xsl:variable>

	<xsl:element name="locah:associatedWith">
		<xsl:comment>About the Concept (Function)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($locah, 'Function')"/></xsl:attribute>
			</xsl:element>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates />

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/function/emph[@altrender='a'][not(normalize-space(.) = '')]">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="skos:prefLabel"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/title">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)" />
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$mainagencyid" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)" />
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="document"><xsl:value-of select="concat($id, 'document/', $prefix, '/', $slug)" /></xsl:variable>

	<xsl:element name="locah:associatedWith">
		<xsl:element name="foaf:Document">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$document" /></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')" /></xsl:attribute>
			</xsl:element>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->
			<xsl:element name="dcterms:title"><xsl:value-of select="$label"/></xsl:element>

			<xsl:apply-templates />
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/title/emph[@altrender='a'][not(normalize-space(.) = '')]">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
<!--	<xsl:element name="skos:prefLabel"><xsl:value-of select="normalize-space(.)"/></xsl:element> -->
	<xsl:element name="dcterms:title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template name="make-life-events">
<xsl:param name="person" />
<xsl:param name="label" />
<xsl:param name="indates" />

	<xsl:choose>
	<!-- Test for yyyymmdd/yyyymmdd with mm, dd optional -->
	<xsl:when test="matches($indates, '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?/[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	
	<!-- i.e. birth/death -->

		<xsl:variable name="dates" select="tokenize($indates, '/')"/>
		
		<xsl:variable name="startdate" select="$dates[1]"/>
		<xsl:variable name="enddate" select="$dates[2]"/>

		<xsl:element name="locah:dateBirth">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="locah:dateDeath">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
				
		<xsl:element name="bio:event">
			<xsl:call-template name="make-birth-event">
				<xsl:with-param name="person" select="$person" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98i_was_born">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>

		<xsl:element name="bio:event">
			<xsl:call-template name="make-death-event">
				<xsl:with-param name="person" select="$person" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P100i_died_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<!-- Test for yyyymmdd with mm, dd optional -->
	<xsl:when test="matches($indates, '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	
	<!-- i.e. birth only -->

		<xsl:variable name="startdate" select="$indates"/>

		<xsl:element name="locah:dateBirth">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="bio:event">
			<xsl:call-template name="make-birth-event">
				<xsl:with-param name="person" select="$person" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98i_was_born">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<xsl:when test="matches($indates, '^b[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?')">
	<!-- i.e. birth only -->
		<xsl:variable name="startdate" select="substring-after($indates, 'b')"/>
		<xsl:element name="locah:dateBirth">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="bio:event">
			<xsl:call-template name="make-birth-event">
				<xsl:with-param name="person" select="$person" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98i_was_born">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<xsl:when test="matches($indates, '^d[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?')">
	<!-- i.e. death only -->
		<xsl:variable name="enddate" select="substring-after($indates, 'd')"/>
		<xsl:element name="locah:dateDeath">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="bio:event">
			<xsl:call-template name="make-death-event">
				<xsl:with-param name="person" select="$person" />
				<xsl:with-param name="label" select="$label" />
				<xsl:with-param name="date" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P100i_died_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<xsl:when test="matches($indates, '^fl[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?(/[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?)?$')">	
	<!-- i.e. floruit single date or floruit date range-->
		<xsl:variable name="dates" select="tokenize(substring-after($indates, 'fl'), '/')"/>

		<xsl:choose>
			<xsl:when test="count($dates) = 2">
				<xsl:variable name="startdate" select="$dates[1]"/>
				<xsl:variable name="enddate" select="$dates[2]"/>
				
				<xsl:element name="bio:event">
					<xsl:call-template name="make-floruit-event-period">
						<xsl:with-param name="person" select="$person" />
						<xsl:with-param name="label" select="$label" />
						<xsl:with-param name="startdate" select="$startdate" />
						<xsl:with-param name="enddate" select="$enddate" />
					</xsl:call-template>
				</xsl:element>
				<xsl:element name="event:agent_in">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="replace($person, 'person', 'floruit')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:when test="count($dates) = 1">
				<xsl:variable name="startdate" select="$dates[1]"/>
				<xsl:element name="bio:event">
					<xsl:call-template name="make-floruit-event-date">
						<xsl:with-param name="person" select="$person" />
						<xsl:with-param name="label" select="$label" />
						<xsl:with-param name="date" select="$startdate" />
					</xsl:call-template>
				</xsl:element>
				<xsl:element name="event:agent_in">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="replace($person, 'person', 'floruit')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>

	</xsl:when>
	</xsl:choose>

</xsl:template>

<xsl:template name="make-birth-event">
<xsl:param name="person" />
<xsl:param name="label" />
<xsl:param name="date" />

	<xsl:comment>About the Birth (Event)</xsl:comment> 
	<xsl:element name="bio:Birth">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'birth')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E67_Birth')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Birth of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Birth of ', $label)"/></xsl:element>
		<xsl:element name="bio:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="dcterms:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-during-date">
				<xsl:with-param name="uri" select="replace($person, 'person', 'birthtime')" />
				<xsl:with-param name="label" select="concat('Time of Birth of ', $label)" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birthtime')" />
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P4_has_time-span">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birthtime')" />
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98_brought_into_life">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-death-event">
<xsl:param name="person" />
<xsl:param name="label" />
<xsl:param name="date" />

	<xsl:comment>About the Death (Event)</xsl:comment> 
	<xsl:element name="bio:Death">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'death')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E69_Death')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Death of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Death of ', $label)"/></xsl:element>
		<xsl:element name="bio:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="dcterms:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-during-date">
				<xsl:with-param name="uri" select="replace($person, 'person', 'deathtime')" />
				<xsl:with-param name="label" select="concat('Time of Death of ', $label)" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'deathtime')" />
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P4_has_time-span">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'deathtime')" />
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P100_was_death_of">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-floruit-event-period">
<xsl:param name="person" />
<xsl:param name="label" />
<xsl:param name="startdate" />
<xsl:param name="enddate" />
	
	<xsl:comment>About the "Flourishing" (Event)</xsl:comment> 
	<xsl:element name="locah:Floruit">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'floruit')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-as-range">
				<xsl:with-param name="uri" select="replace($person, 'person', 'floruittime')" />
				<xsl:with-param name="label" select="concat('Time of Floruit of ', $label)" />
				<xsl:with-param name="startdate" select="$startdate" />
				<xsl:with-param name="enddate" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'floruittime')" />
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-floruit-event-date">
<xsl:param name="person" />
<xsl:param name="label" />
<xsl:param name="date" />

	<xsl:comment>About the "Flourishing" (Event)</xsl:comment> 
	<xsl:element name="locah:Floruit">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'floruit')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="bio:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="dcterms:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-containing-date">
				<xsl:with-param name="uri" select="replace($person, 'person', 'floruittime')" />
				<xsl:with-param name="label" select="concat('Time of Floruit of ', $label)" />
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'floruittime')" />
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="type-date">
<xsl:param name="date" />

	<xsl:choose>
		<xsl:when test="string-length($date) = 4">
			<xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xsd, 'gYear')" /></xsl:attribute>
			<xsl:value-of select="$date"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 6">
			<xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xsd, 'gYearMonth')" /></xsl:attribute>
			<xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2))"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 8">
			<xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xsd, 'date')" /></xsl:attribute>
			<xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
		</xsl:when>
	</xsl:choose>

</xsl:template>

<xsl:template name="make-refgov-date-uri">
<xsl:param name="date" />

	<xsl:choose>
		<xsl:when test="string-length($date) = 4">
			<xsl:value-of select="concat($ref, 'year/', $date)"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 6">
			<xsl:value-of select="concat($ref, 'month/', substring($date, 1, 4), '-', substring($date, 5, 2))"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 8">
			<xsl:value-of select="concat($ref, 'day/', substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
		</xsl:when>
	</xsl:choose>

</xsl:template>


<xsl:template name="make-interval-as-range">
<xsl:param name="uri" />
<xsl:param name="label" />
<xsl:param name="startdate" />
<xsl:param name="enddate" />

	<xsl:comment>About the Time Interval</xsl:comment> 
	<xsl:element name="time:Interval">
		<xsl:attribute name="rdf:about"><xsl:value-of select="$uri"/></xsl:attribute>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="timeline:timeline">
			<xsl:element name="timeline:TimeLine">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($timeline, 'universaltimeline')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="timeline:start">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalStarts">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$startdate" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86i_contains">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$startdate" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="timeline:end">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalEnds">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$enddate" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86i_contains">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$enddate" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-interval-during-date">
<xsl:param name="uri" />
<xsl:param name="label" />
<xsl:param name="date" />
	
	<xsl:comment>About the Time Interval</xsl:comment> 
	<xsl:element name="time:Interval">
		<xsl:attribute name="rdf:about"><xsl:value-of select="$uri"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E52_Time-Span')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="timeline:timeline">
			<xsl:element name="timeline:TimeLine">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($timeline, 'universaltimeline')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		<!-- Not sure about using tl:at for a "during" relation? -->
		<xsl:comment>Not sure about use of timeline:at for a "during" relation?</xsl:comment> 
		<xsl:element name="timeline:at">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalDuring">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86_falls_within">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-interval-containing-date">
<xsl:param name="uri" />
<xsl:param name="label" />
<xsl:param name="date" />
	
	<xsl:comment>About the Time Interval</xsl:comment> 
	<xsl:element name="time:Interval">
		<xsl:attribute name="rdf:about"><xsl:value-of select="$uri"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E52_Time-Span')" /></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang" select="'en'" /><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="timeline:timeline">
			<xsl:element name="timeline:TimeLine">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($timeline, 'universaltimeline')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		<!-- Not sure about using timeline:at for a "contains" relation? -->
		<xsl:comment>Not sure about use of timeline:at for a "contains" relation?</xsl:comment> 
		<xsl:element name="timeline:at">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalContains">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86i_contains">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>


<xsl:template name="slugify">
<xsl:param name="text" />
<!-- Translates text into URI slug - strips all reserved RFC3986 chars (and some other punctuation) to minimise %-encoding because of Paget issues --> 
	<xsl:variable name="stripped-of-quotes" select="translate(lower-case(normalize-space($text)), '&quot;', '')"/>
	<xsl:value-of select='encode-for-uri(translate($stripped-of-quotes, " :\/?#`[]@!$&amp;&apos;()*+,;=.|&#10;&#160;", ""))'/>
</xsl:template>


<xsl:template name="new-hubify">
<xsl:param name="text" />


	<!-- First, get rid of whitespace (it's already been normalized so all ws = just one blank) -->
	<xsl:variable name="nows-text" select="translate($text, ' ', '')" />
	
	<!-- Second, map simple diacritics -->

	<xsl:variable name="find" select="'ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõö÷øùúûüýÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſƠơƯưǄǅǆǇǈǉǊǋǌǍǎǏǐǑǒǓǔǕǖǗǘǙǚǛǜǞǟǠǡǢǣǦǧǨǩǪǫǬǭǮǯǰǱǲǳǴǵǸǹǺǻǼǽǾǿȀȁȂȃȄȅȆȇȈȉȊȋȌȍȎȏȐȑȒȓȔȕȖȗȘșȚțȞȟȦȧȨȩȪȫȬȭȮȯȰȱȲȳḀḁḂḃḄḅḆḇḈḉḊḋḌḍḎḏḐḑḒḓḔḕḖḗḘḙḚḛḜḝḞḟḠḡḢḣḤḥḦḧḨḩḪḫḬḭḮḯḰḱḲḳḴḵḶḷḸḹḺḻḼḽḾḿṀṁṂṃṄṅṆṇṈṉṊṋṌṍṎṏṐṑṒṓṔṕṖṗṘṙṚṛṜṝṞṟṠṡṢṣṤṥṦṧṨṩṪṫṬṭṮṯṰṱṲṳṴṵṶṷṸṹṺṻṼṽṾṿẀẁẂẃẄẅẆẇẈẉẊẋẌẍẎẏẐẑẒẓẔẕẖẗẘẙẚẛẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặẸẹẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữỰựỲỳỴỵỶỷỸỹ'" />

	<xsl:variable name="replace" select="'AAAAAACEEEEIIIINOOOOOxOUUUUYaaaaaaceeeeiiiinooooo/ouuuuyyAaAaAaCcCcCcCcDdDdEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnʼNnOoOoOoRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuWwYyYZzZzZzsOoUuDDdLLlNNnAaIiOoUuUuUuUuUuAaȦȧÆæGgKkOoOoƷʒjDDdGgNnAaÆæØøAaAaEeEeIiIiOoOoRrRrUuUuSsTtHhAaEeOoOoOoOoYyAaBbBbBbCcDdDdDdDdDdEeEeEeEeEeFfGgHhHhHhHhHhIiIiKkKkKkLlLlLlLlMmMmMmNnNnNnNnOoOoOoOoPpPpRrRrRrRrSsSsSsSsSsTtTtTtTtUuUuUuUuUuVvVvWwWwWwWwWwXxXxYyZzZzZzhtwyaſAaAaAaAaAaAaAaAaAaAaAaAaEeEeEeEeEeEeEeEeIiIiOoOoOoOoOoOoOoOoOoOoOoOoUuUuUuUuUuUuUuYyYyYyYy'" />

	<xsl:variable name="nosimpdia-text" select="translate($nows-text, $find, $replace)" />
	
	<!-- Third, map multichar diacritics -->
	<xsl:variable name="nodia-text">
		<xsl:call-template name="replace-dias">
			<xsl:with-param name="input" select="$nosimpdia-text" />
			<xsl:with-param name="charindex" select="xsd:integer(1)" />
		</xsl:call-template>
	</xsl:variable>

	<!-- Fourth, make lower case -->

	<xsl:value-of select="lower-case($nodia-text)" />
	
</xsl:template>

<xsl:template name="replace-dias">
<xsl:param name="input" />
<xsl:param name="charindex" />

<xsl:variable name="diacriticsmap">
<diacritics>
  <char find="&#x00A7;" replace="Section" />
  <char find="&#x00A9;" replace="(c)" />
  <char find="&#x00C6;" replace="AE" />
  <char find="&#x00DE;" replace="TH" />
  <char find="&#x00DF;" replace="ss" />
  <char find="&#x00E6;" replace="&#x0061;&#x0065;" />
  <char find="&#x00FE;" replace="th" />
  <char find="&#x0152;" replace="OE" />
  <char find="&#x0153;" replace="oe" />
</diacritics>
</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$charindex &lt; count($diacriticsmap/diacritics/char)">
			<xsl:variable name="replaced" select="replace($input, $diacriticsmap/diacritics/char[$charindex]/@find, $diacriticsmap/diacritics/char[$charindex]/@replace)" />
			
			<xsl:call-template name="replace-dias">
				<xsl:with-param name="input" select="$replaced" />
				<xsl:with-param name="charindex" select="$charindex + 1" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$input" />
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>


<xsl:template name="dashify">
<xsl:param name="text" />
<!-- A version of slugify that maps separator chars to dashes -->
<!-- Strip most reserved RFC3986 chars (and some other punctuation), map others to dash - to minimise %-encoding because of Paget issues --> 
	<xsl:variable name="stripped-of-quotes" select="translate(lower-case(normalize-space($text)), '&quot;', '')"/>
	<xsl:variable name="stripped-of-other" select='translate($stripped-of-quotes, " ?#`@!$&amp;&apos;*+=&#10;&#160;", "")'/>
	<xsl:value-of select='encode-for-uri(translate($stripped-of-other, ":\/[](),;", "---------"))'/>
</xsl:template>


<xsl:template match="text()|@*">
</xsl:template>

<xsl:template match="text()|@*" mode="concept">
</xsl:template>

<xsl:template match="text()|@*" mode="person">
</xsl:template>

<xsl:template match="text()|@*" mode="family">
</xsl:template>

<xsl:template match="text()|@*" mode="organisation">
</xsl:template>

<xsl:template match="text()|@*" mode="place">
</xsl:template>

</xsl:stylesheet>


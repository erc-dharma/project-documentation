<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:t="http://www.tei-c.org/ns/1.0"
	xmlns:f="http://example.com/ns/functions"
	xmlns:html="http://www.w3.org/1999/html"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" version="2.0">

  <xsl:template match="t:ptr[not(parent::t:bibl)]">
    <xsl:param name="parm-zoteroUorG" tunnel="yes" required="no"/>
    <xsl:param name="parm-zoteroKey" tunnel="yes" required="no"/>
    <xsl:param name="parm-zoteroStyle" tunnel="yes" required="no"/>
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>

	<xsl:if test="@target and $leiden-style = 'dharma'">
    <xsl:variable name="soughtSiglum" select="@target"/>

    <xsl:variable name="biblentry"
      select="replace(substring-after(@target, ':'), '\+', '%2B')"/>

      <xsl:variable name="zoteroapijson">
        <xsl:value-of
          select="replace(concat('http://195.154.222.146:8024/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=json&amp;style=',$parm-zoteroStyle,'&amp;include=citation'), 'amp;', '')"
        />
      </xsl:variable>

      <xsl:variable name="unparsedtext" select="unparsed-text($zoteroapijson)"/>

      <xsl:variable name="citation">
        <xsl:analyze-string select="$unparsedtext"
          regex="(\s+&quot;citation&quot;:\s&quot;&lt;span&gt;)(.+)(&lt;/span&gt;&quot;)">
          <xsl:matching-substring>
            <xsl:value-of select="regex-group(2)"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:variable>


    <!-- <span class="tooltip-bibl">
        <xsl:value-of select="replace(//t:listBibl/t:bibl[t:ptr/@target=$soughtSiglum]/@n, '\+', '&amp;')"/>
       <span class="tooltiptext-bibl">
          <xsl:choose>
            <xsl:when test="matches(@target, '[A-Z][A-Z]')">
              <xsl:call-template name="journalTitleSiglum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="replace(replace(replace(replace($citation, '^[\(]+([&lt;][a-z][&gt;])*', ''), '([&lt;/][a-z][&gt;])+[\)]+$', ''), '\)', ''), '&lt;/[i]&gt;', '')"/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      </span>-->
	  <xsl:element name="span">
	    <xsl:attribute name="data-toogle">tooltip</xsl:attribute>
	    <xsl:attribute name="data-placement">top</xsl:attribute>
	    <xsl:attribute name="title">
	      <xsl:choose>
	      <xsl:when test="matches(@target, '[A-Z][A-Z]')">
	        <xsl:call-template name="journalTitleSiglum"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="replace(replace(replace(replace($citation, '^[\(]+([&lt;][a-z][&gt;])*', ''), '([&lt;/][a-z][&gt;])+[\)]+$', ''), '\)', ''), '&lt;/[i]&gt;', '')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    </xsl:attribute>
	    <xsl:value-of select="replace(//t:listBibl/t:bibl[t:ptr/@target=$soughtSiglum]/@n, '\+', '&amp;')"/>
	  </xsl:element>

	</xsl:if>

	</xsl:template>

  <xsl:template name="journalTitleSiglum">
  	<xsl:choose>
  		<!-- Handles ARIE1886-1887 or ARIE1890-1891_02 -->
  		<xsl:when test="matches(@target, '[a-z]+:([A][R][I][E])([0-9\-]+)(_[0-9])*')">
  			<xsl:analyze-string select="@target" regex="[a-z]+:([A][R][I][E])([0-9\-]+)(_[0-9])*">
  				<xsl:matching-substring>
  								<i><xsl:value-of select="regex-group(1)"/></i>
  								<xsl:text> </xsl:text>
  								<xsl:value-of select="regex-group(2)"/>
  						</xsl:matching-substring>
  					</xsl:analyze-string>
  		</xsl:when>
  <xsl:when test="matches(@target, '[a-z]+:([A-Z]+)([0-9][0-9])_([0-9\-]+)')">
   <xsl:analyze-string select="@target" regex="[a-z]+:([A-Z]+)([0-9][0-9])_([0-9\-]+)">
  	<xsl:matching-substring>
  					<i><xsl:value-of select="regex-group(1)"/></i>
  					<xsl:text> </xsl:text>
  					<xsl:value-of select="regex-group(2)"/>
  					<xsl:text> (</xsl:text>
  					<xsl:value-of select="regex-group(3)"/>
  					<xsl:text>)</xsl:text>
  			</xsl:matching-substring>
  		</xsl:analyze-string>
  </xsl:when>
  <!-- Handles OV, ROC, ROD -->
  <xsl:when test="matches(@target, '[a-z]+:([A-Z]+)([0-9\-]+)(_[0-9])*')">
   <xsl:analyze-string select="@target" regex="[a-z]+:([A-Z]+)([0-9\-]+)(_[0-9])*">
  	<xsl:matching-substring>
  					<i><xsl:value-of select="regex-group(1)"/></i>
  					<xsl:text> (</xsl:text>
  					<xsl:value-of select="regex-group(2)"/>
  					<xsl:text>)</xsl:text>
  			</xsl:matching-substring>
  		</xsl:analyze-string>
  </xsl:when>
  	<!-- TBG1924_64 -->
  	<xsl:when test="matches(@target, '[a-z]+:([T][G][B])([0-9\-]*)(_[0-9][0-9])')">
  	 <xsl:analyze-string select="@target" regex="[a-z]+:([T][G][B])([0-9\-]*)(_[0-9][0-9])">
  		<xsl:matching-substring>
  						<i><xsl:value-of select="regex-group(1)"/></i>
  						<xsl:text> </xsl:text>
  						<xsl:value-of select="regex-group(3)"/>
  						<xsl:text> (</xsl:text>
  						<xsl:value-of select="regex-group(2)"/>
  						<xsl:text>)</xsl:text>
  				</xsl:matching-substring>
  			</xsl:analyze-string>
  	</xsl:when>
  	<!-- BCAI_1912 and BCAI_1917-1930 / Avanam1993_01   – not tested  -->
  	<xsl:when test="matches(@target, '[a-z]+:([B][C][A][I])(_[0-9\-]*)')">
  	 <xsl:analyze-string select="@target" regex="[a-z]+:([B][C][A][I])(_[0-9\-]*)">
  		<xsl:matching-substring>
  						<i><xsl:value-of select="regex-group(1)"/></i>
  						<xsl:text> (</xsl:text>
  						<xsl:value-of select="regex-group(2)"/>
  						<xsl:text>)</xsl:text>
  				</xsl:matching-substring>
  			</xsl:analyze-string>
  	</xsl:when>
  </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

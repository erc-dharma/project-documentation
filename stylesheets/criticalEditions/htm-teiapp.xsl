<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Contains app and its children rdg, ptr, note and lem -->

   <xsl:template match="t:app">
      <xsl:param name="parm-internal-app-style" tunnel="yes" required="no"></xsl:param>
      <xsl:param name="parm-external-app-style" tunnel="yes" required="no"></xsl:param>
      <xsl:param name="parm-edn-structure" tunnel="yes" required="no"></xsl:param>
      <!-- Found in htm-tpl-apparatus - creates links to footnote in apparatus -->
        <xsl:choose>
          <xsl:when test="./t:lem">
            <xsl:if test="./t:lem[child::t:pb]">
              <span class="tooltipPB">
                <xsl:text>&#9112;</xsl:text>
                <span class="tooltiptextPB">
                     <xsl:text>Witness </xsl:text>
                     <xsl:value-of select="replace(./t:lem/child::t:pb/@ed, '#', '')"/>
                     <xsl:text>:&#x202F;page </xsl:text>
                     <xsl:value-of select="replace(./t:lem/child::t:pb/@n, '#', '')"/>
                   </span>
                 </span>
               </xsl:if>
           <xsl:element name="span">
           <xsl:attribute name="class">lem</xsl:attribute>
           <xsl:value-of select="t:lem"/>
         <xsl:call-template name="app-link">
            <xsl:with-param name="location" select="'text'"/>
         </xsl:call-template>
       </xsl:element>
     </xsl:when>
     <xsl:when test="not(./t:lem)">
       <xsl:text>🥟</xsl:text>
       <xsl:call-template name="app-link">
          <xsl:with-param name="location" select="'text'"/>
       </xsl:call-template>
     </xsl:when>
   </xsl:choose>
  </xsl:template>


</xsl:stylesheet>

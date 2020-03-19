<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teinote.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t xs"                
                version="2.0">
  <!-- Template in teinote.xsl -->
  <xsl:import href="teinote.xsl"/>      
   
  <xsl:template match="t:note">
      <xsl:choose>
         <xsl:when test="$edn-structure='campa' and local-name(..)!='msItem'">
            <xsl:variable name="notepos">
               <xsl:call-template name="campanotenum"/>
            </xsl:variable>
            <a class="noteref" title="{normalize-space(.)}" href="#{$notepos}"><xsl:value-of select="$notepos"/></a>
         </xsl:when>
         <xsl:when test="ancestor::t:p or ancestor::t:l or ancestor::t:ab">
            <i><xsl:apply-imports/></i>
         </xsl:when>
         <xsl:otherwise>
            <p class="note">
               <xsl:apply-imports/>
            </p>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
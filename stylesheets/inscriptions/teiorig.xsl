<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: teiorig.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">  
  
  <xsl:template match="t:orig[not(parent::t:choice)]//text()" priority="1">
      <xsl:value-of select="translate(., $all-grc, $grc-upper-strip)"/>
  </xsl:template>
  
  <xsl:template match="t:orig[not(parent::t:choice) and $leiden-style='campa']">
      <xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
  </xsl:template>
</xsl:stylesheet>
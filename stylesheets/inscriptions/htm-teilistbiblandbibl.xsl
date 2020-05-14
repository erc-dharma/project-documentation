<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:listBibl">
    <xsl:if test="descendant::t:bibl">
    <ul>
    <xsl:if test="@type">
      <h3>
      <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
    </h3>
  </xsl:if>
  <xsl:apply-templates/>
      </ul>
    </xsl:if>
  </xsl:template>

<!-- It seems, it is not display -->
<!-- To be investigted-->
  <xsl:template match="t:listBibl//t:bibl">
      <li>
         <xsl:apply-templates/>
      </li>
  </xsl:template>

</xsl:stylesheet>

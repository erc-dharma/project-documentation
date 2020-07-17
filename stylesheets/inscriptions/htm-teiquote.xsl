<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:quote">
      <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:choose>
    <xsl:when test="$parm-leiden-style='dharma' and @rend='block'">
      <xsl:element name="div">
      <xsl:attribute name="class">block</xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:when>
<xsl:otherwise>
  <xsl:text>"</xsl:text>
<xsl:value-of select="."/>
<xsl:text>" </xsl:text>
</xsl:otherwise>
</xsl:choose>
    </xsl:template>
  </xsl:stylesheet>

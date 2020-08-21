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
<xsl:when test="@type='basetext'">
  <xsl:value-of select="child::t:*[1]"/>
</xsl:when>
<xsl:when test="child::t:lg">
  <xsl:apply-templates/>
</xsl:when>
<xsl:when test="@type='missing'">
  <xsl:if test="@n='śloka'">
    <xsl:element name="div">
      <xsl:attribute name="class">first-line</xsl:attribute>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@n"/>
    <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:if>
</xsl:when>
<xsl:otherwise>
  <xsl:text>"</xsl:text>
<xsl:value-of select="."/>
<xsl:text>" </xsl:text>
</xsl:otherwise>
</xsl:choose>
    </xsl:template>
  </xsl:stylesheet>

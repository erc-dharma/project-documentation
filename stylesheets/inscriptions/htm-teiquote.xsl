<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:quote" mode="#all">
    <xsl:choose>
    <xsl:when test="@rend='block'">
<xsl:apply-templates/>
</xsl:when>
<xsl:when test="parent::t:cit and not(@rend='block')">
<i><xsl:apply-templates/></i>
</xsl:when>
<xsl:otherwise>
  <xsl:text>"</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>" </xsl:text>
</xsl:otherwise>
</xsl:choose>
    </xsl:template>


<xsl:template match="t:cit" mode="#all">
  <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
  <xsl:choose>
<xsl:when test="$parm-leiden-style='dharma' and child::t:quote[@rend='block']">
  <br/>
  <xsl:element name="div">
  <xsl:attribute name="class">block</xsl:attribute>
<xsl:apply-templates select="child::t:quote"/>
  <xsl:if test="child::t:bibl">
      <xsl:element name="span">
        <xsl:attribute name="class">citRef</xsl:attribute>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="child::t:bibl"/>
<xsl:text>)</xsl:text>
</xsl:element>
</xsl:if>
</xsl:element>
<br/>
</xsl:when>
<xsl:otherwise>
  <xsl:apply-templates mode="dharma"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:title" mode="#all">
      <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>

    <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:body">
      <xsl:choose>
      <xsl:when test="t:title[@level='a']">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="t:title[@rend='plain']">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
      <xsl:element name="span">
        <xsl:attribute name="class">italic</xsl:attribute>
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:otherwise>
    </xsl:choose>
    </xsl:if>

    </xsl:template>
  </xsl:stylesheet>

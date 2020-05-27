<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: teiorig.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:orig[not(parent::t:choice)]">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <xsl:choose>
      <xsl:when test="$parm-leiden-style='dharma'">
        <xsl:if test="ancestor::t:div[@type='edition'] or ancestor::t:lem">
        <span class="orig">
        <xsl:text>¡</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>!</xsl:text>
      </span>
    </xsl:if>
    <xsl:if test="not(ancestor::t:div[@type='edition'] or ancestor::t:lem)">
      <xsl:text>¡</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>!</xsl:text>
    </xsl:if>
  </xsl:when>
</xsl:choose>
  </xsl:template>
</xsl:stylesheet>

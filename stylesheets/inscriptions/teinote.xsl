<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Imported from [htm|txt]-teinote.xsl -->

  <xsl:template match="t:note" mode="#all">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <xsl:param name="parm-apparatus-style" tunnel="yes" required="no"></xsl:param>

    <xsl:choose>
      <xsl:when test="ancestor::t:div[@type='translation'] and $leiden-style='dharma' and not(@type='credit')">
        <xsl:call-template name="dharma-app-link">
           <xsl:with-param name="location" select="'text'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ancestor::t:div[@type='translation'] and $leiden-style='dharma' and @type='credit'">
      <p><xsl:apply-templates/></p>
    </xsl:when>
      <xsl:otherwise>
        <xsl:text>(</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>

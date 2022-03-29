<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

<xsl:template match="t:persName">
  <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:div[@type='edition']">
          <xsl:choose>
            <xsl:when test="child::t:*[local-name()=('persName')]">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
              <xsl:element name="sup">
                <xsl:text>👤</xsl:text>
              </xsl:element>
            </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
</xsl:template>

<xsl:template match="t:placeName">
  <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:div[@type='edition']">
        <xsl:choose>
          <xsl:when test="child::t:*[local-name()=('placeName')]">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:apply-templates/>
              <xsl:element name="sup">
                <xsl:text>🧭</xsl:text>
              </xsl:element>
            </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
</xsl:template>
  
  <xsl:template match="t:date">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:div[@type='edition']">
      <xsl:choose>
        <xsl:when test="child::t:*[local-name()=('date')]">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
          <xsl:element name="sup">
            <xsl:text>📅</xsl:text>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

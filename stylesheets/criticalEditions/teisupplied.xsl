<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:EDF="http://epidoc.sourceforge.net/ns/functions"
                exclude-result-prefixes="t EDF"
                version="2.0">

  <xsl:template match="t:supplied[@reason='subaudible']">
    <xsl:choose>
    <xsl:when test="child::t:note[@type='parallels']">
      <xsl:text>[ </xsl:text>
      <xsl:value-of select="child::t:note[@type='parallels']/t:list/t:item/@corresp"/>
      <xsl:text> ]</xsl:text>
    </xsl:when>
    <xsl:when test="child::t:quote[@type='basetext']/descendant::t:note[@type='parallels']">
      <xsl:call-template name="supplied-subaudible"/>
      <xsl:element name="ul">
        <xsl:for-each select="descendant::t:item">
            <xsl:element name="li">
              <xsl:if test="@*">
          <xsl:value-of select="@*"/>
        </xsl:if>
        <xsl:if test="text()">
        <xsl:value-of select="."/>
      </xsl:if>
      </xsl:element>
      </xsl:for-each>
  </xsl:element>
    </xsl:when>
    <xsl:otherwise>
          <xsl:call-template name="supplied-subaudible"/>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

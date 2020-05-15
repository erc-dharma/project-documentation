<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="t" version="2.0">

<!-- Handling e.g. and E.g. -->
<xsl:template match="t:text">
  <!-- Changes normal space for non-breaking space -->
  <xsl:if test="matches=(.,'e.g. ')">
    <xsl:value-of select="replace(., 'e.g. ', 'e.g.&#xA0;')"></xsl:value-of>
  </xsl:if>
  <xsl:if test="matches=(.,'E.g. ')">
    <xsl:value-of select="replace(., 'E.g. ', 'E.g.&#xA0;')"></xsl:value-of>
  </xsl:if>

<!-- Handling c.f. and C.f. -->
<!-- Changes normal space for non-breaking space -->
<xsl:if test="matches=(.,'c.f. ')">
  <xsl:value-of select="replace(., 'c.f. ', 'c.f.&#xA0;')"></xsl:value-of>
</xsl:if>
<xsl:if test="matches=(.,'C.f. ')">
  <xsl:value-of select="replace(., 'C.f. ', 'C.f.&#xA0;')"></xsl:value-of>
</xsl:if>
</xsl:template>

<!--
  p. (although there shouldn't be any of encoders follow the EG)
  n. (although there shouldn't be any of encoders follow the EG) -->

  <xsl:template match="t:text">
    <xsl:if test="matches=(.,'p. ')">
      <xsl:message terminate="yes">Error: p. isn't allowed. Make the necessary change and restart the stylesheet</xsl:message>
      <xsl:value-of select="replace(., 'p. ', 'p.&#xA0;')"></xsl:value-of>
    </xsl:if>

    <xsl:if test="matches=(.,'n. ')">
      <xsl:message terminate="yes">Error: n. isn't allowed. Make the necessary change and restart the stylesheet</xsl:message>
      <xsl:value-of select="replace(., 'n. ', 'n.&#xA0;')"></xsl:value-of>
    </xsl:if>
  </xsl:template>
  </xsl:stylesheet>

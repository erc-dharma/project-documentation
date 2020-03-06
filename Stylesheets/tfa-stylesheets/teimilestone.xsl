<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- General template in [htm|txt]teimilestone.xsl -->

  <xsl:template match="t:milestone">
     <!-- adds pipe for block, flanked by spaces if not within word -->
      <xsl:text>&#8225; </xsl:text>
      <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>

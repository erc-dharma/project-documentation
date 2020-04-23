<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="t" version="2.0">
   <xsl:output method="xml" encoding="UTF-8"/>

<!-- Transform ' to ’ (apostrophe) for div edition, apparatus, commentary and bibliography as well as it doesn't have @xml:lang-->
<xsl:template match="//t:div and not(t:div/@xml:lang)">
  <xsl:if test="matches(.,'\'')">
    <xsl:value-of select="replace(., '\'', '’')"></xsl:value-of>
  </xsl:if>
</xsl:template>

  </xsl:stylesheet>

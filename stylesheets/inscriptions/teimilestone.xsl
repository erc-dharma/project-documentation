<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- General template in [htm|txt]teimilestone.xsl -->


    <xsl:template match="t:label">
        <xsl:if test="not(ancestor::t:lg or ancestor::t:list)">
          <xsl:apply-templates/>
      </xsl:if>
      </xsl:template>

</xsl:stylesheet>

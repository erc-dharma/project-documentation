<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teip.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">

  <xsl:template match="t:p">
     <xsl:choose>
          <xsl:when test="$leiden-style='campa' and ancestor::t:div[@type='edition']">
              <div class="prose-para">
                  <xsl:apply-templates/>
              </div>
          </xsl:when>
          <xsl:otherwise><p>
         <xsl:apply-templates/>
      </p></xsl:otherwise></xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
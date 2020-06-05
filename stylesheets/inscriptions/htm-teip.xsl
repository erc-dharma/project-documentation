<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:p">
      <p>
        <xsl:if test="@n and not(@rend)">
          <sup class="versenumber">
           <xsl:text>(</xsl:text>
           <xsl:value-of select="@n"/>
           <xsl:text>) </xsl:text>
         </sup>
       </xsl:if>
          <xsl:if test="@rend='stanza'">
          <span class="stanzanumber">
              <xsl:if test="@n">
                  <xsl:number value="@n" format="I"/><xsl:text>. </xsl:text>
              </xsl:if>
        </span>
      </xsl:if>
         <xsl:apply-templates/>
      </p>
  </xsl:template>

</xsl:stylesheet>

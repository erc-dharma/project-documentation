<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="#all" version="2.0">

  <xsl:template match="t:p">
      <p>
        <xsl:if test="@n and not(@rend)">
          <sup class="linenumber">
           <!--<xsl:text>(</xsl:text>-->
           <xsl:value-of select="@n"/>
           <!--<xsl:text>) </xsl:text>-->
         </sup>
       </xsl:if>
       <xsl:if test="@rend='stanza'">
         <xsl:choose>
           <xsl:when test="@n='1' and not(following-sibling::t:*)"/>
              <!--<xsl:when test="count(@n) &gt;= 2">-->
              <xsl:otherwise>
       <div class="translated-stanzanumber">
               <xsl:number value="@n" format="I"/><xsl:text>. </xsl:text>
     </div>
  </xsl:otherwise>
  </xsl:choose>
   </xsl:if>
         <xsl:apply-templates mode="dharma"/>

      </p>

  </xsl:template>

</xsl:stylesheet>

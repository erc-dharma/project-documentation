<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:div">
    <!-- div[@type = 'edition']" and div[@type='textpart'] can be found in htm-teidivedition.xsl -->
    <xsl:if test="descendant::*">
        <div>
          <xsl:if test="parent::t:body and @type">
            <xsl:attribute name="id">
              <xsl:value-of select="@type"/>
            </xsl:attribute>
          </xsl:if>
          <!-- Headings are necessary for DHARMA -->
          <xsl:if test="not(t:head)">
            <xsl:choose>
              <xsl:when test="@type='commentary' and @subtype='frontmatter'"><h3>Introduction</h3></xsl:when>
              <xsl:when test="@type='commentary' and @subtype='linebyline'"><h3>Notes</h3></xsl:when>
            
               <xsl:when test="parent::t:body and @type">
                <h2>
                <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
              </h2>
            </xsl:when>
       <xsl:otherwise>
                  <h3>
                     <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
                     <xsl:if test="string(@subtype)">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="@subtype"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@n"/>
                     </xsl:if>
                  </h3>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!--<xsl:if test="t:head">
            <xsl:choose>
            <xsl:when test="parent::t:body and @type">
             <h2>
             <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
             <xsl:call-template name="language"/>
           </h2>
         </xsl:when>
         </xsl:choose>
       </xsl:if>-->
          <!-- Body of the div -->
          <xsl:apply-templates/>

        </div>
</xsl:if>
  </xsl:template>



</xsl:stylesheet>

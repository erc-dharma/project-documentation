<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:EDF="http://epidoc.sourceforge.net/ns/functions"
   exclude-result-prefixes="#all" version="2.0">


<!-- Display the pb for pages-->
    <xsl:template match="//t:pb[not(parent::t:rdg or parent::t:lem)]">
      <xsl:choose>
      <xsl:when test="preceding-sibling::node()[1][local-name() = 'pb' or
                         (normalize-space(.)=''
                                  and preceding-sibling::node()[1][local-name() = 'pb'])]">
           <xsl:if test="EDF:f-wwrap(.) = true()">
             <span class="tooltipPB">
               <xsl:text>&#9112;</xsl:text>
                <span class="tooltiptextPB">
                    <xsl:text>Witness </xsl:text>
                    <xsl:value-of select="replace(@ed, '#', '')"/>
                    <xsl:text>:&#x202F;page </xsl:text>
                    <xsl:value-of select="replace(@n, '#', '')"/>
                  </span>
                </span>
           </xsl:if>
         </xsl:when>
         <xsl:otherwise>
          <span class="tooltipPB">
            <xsl:text>&#9112;</xsl:text>
             <span class="tooltiptextPB">
                 <xsl:text>Witness </xsl:text>
                 <xsl:value-of select="replace(@ed, '#', '')"/>
                 <xsl:text>:&#x202F;page </xsl:text>
                 <xsl:value-of select="replace(@n, '#', '')"/>
               </span>
             </span>
           </xsl:otherwise>
         </xsl:choose>
      </xsl:template>
</xsl:stylesheet>

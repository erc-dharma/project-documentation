<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teiab.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="t" 
                version="2.0">
  
  <xsl:template match="t:ab">
      <xsl:choose>
         <xsl:when test="$edn-structure='campa' and ancestor::t:div[@type='edition']">
            <div class="prose-part">
               <xsl:call-template name="attr-lang">
                  <xsl:with-param name="selective">yes</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:if>
               <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="$edn-structure='campa' and not(ancestor::t:div[@type='edition'])">
            <p class="ab">
               <xsl:call-template name="attr-lang">
                  <xsl:with-param name="selective">yes</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:if>
               <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <div class="textpart">
               <xsl:apply-templates/>
               <!-- if next div or ab begins with lb[break=no], then add hyphen -->
               <xsl:if test="following::t:lb[1][@break='no' or @type='inWord'] and not($edition-type='diplomatic')">
                  <xsl:text>-</xsl:text>
               </xsl:if>
            </div>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
   
   <xsl:template match="t:ab" mode="metadata-campa">
      <p class="ab"><xsl:apply-templates mode="metadata-campa"/></p>
   </xsl:template>

</xsl:stylesheet>
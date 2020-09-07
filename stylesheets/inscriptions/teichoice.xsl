<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="t" version="2.0">

<xsl:template match="t:choice">
       <xsl:param name="parm-apparatus-style" tunnel="yes" required="no"></xsl:param>
       <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
       <xsl:choose>
           <xsl:when test="child::t:sic and child::t:corr and $parm-leiden-style=('edh-names','edh-itx')">
            <xsl:text>&lt;</xsl:text>
            <xsl:apply-templates select="t:corr"/>
            <xsl:text>=</xsl:text>
             <xsl:value-of select="translate(t:sic, $all-grc, $grc-upper-strip)"/>
            <xsl:text>&gt;</xsl:text>
         </xsl:when>
         <xsl:when test="$leiden-style ='dharma' and child::t:unclear[2]">
             <xsl:text>(</xsl:text>
            <xsl:apply-templates select="child::t:unclear[1]" mode="dharma"/>
              <xsl:text>/</xsl:text>
              <xsl:apply-templates select="child::t:unclear[2]" mode="dharma"/>
              <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:when test="$leiden-style ='dharma' and child::t:hi[@rend='grantha'] and descendant::t:unclear">
      <xsl:text>(</xsl:text>
      <xsl:choose>
      <xsl:when test="child::t:hi[@rend='grantha'][1]">
        <xsl:element name="span">
           <xsl:attribute name="class">grantha</xsl:attribute>
     <xsl:apply-templates select="descendant::t:unclear[1]" mode="dharma"/>
   </xsl:element>
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="child::t:unclear[1]" mode="dharma"/>
  </xsl:otherwise>
</xsl:choose>
       <xsl:text>/</xsl:text>
<xsl:choose>
       <xsl:when test="child::t:hi[@rend='grantha'][2]">
         <xsl:element name="span">
            <xsl:attribute name="class">grantha</xsl:attribute>
      <xsl:apply-templates select="child::t:unclear" mode="dharma"/>
    </xsl:element>
  </xsl:when>
  <xsl:otherwise>
 <xsl:apply-templates select="child::t:unclear" mode="dharma"/>
  </xsl:otherwise>
</xsl:choose>
       <xsl:text>)</xsl:text>
    </xsl:when>
       <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>

      <!-- Found in [htm|txt]-tpl-apparatus -->
      <xsl:if
          test="$parm-apparatus-style = 'ddbdp' and ((child::t:sic and child::t:corr) or (child::t:orig and child::t:reg))">
         <xsl:call-template name="app-link">
            <xsl:with-param name="location" select="'text'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <!-- Import templates can be found in teig.xsl -->
  <xsl:import href="teig.xsl"/>

  <xsl:template match="t:g">
      <xsl:param name="parm-edition-type" tunnel="yes" required="no"></xsl:param>
      <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:call-template name="lb-dash"/>
      <xsl:call-template name="w-space"/>

     <xsl:choose>
         <xsl:when test="starts-with($parm-leiden-style, 'edh') or $parm-leiden-style='eagletxt'"/>
         <xsl:when test="($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch')">
        <!-- Found in teig.xsl -->
        <xsl:call-template name="g-ddbdp"/>
         </xsl:when>
         <xsl:when test="$parm-leiden-style = 'london'">
           <xsl:call-template name="g-london"/>
         </xsl:when>
         <xsl:when test="$parm-leiden-style = 'iospe'">
           <xsl:apply-imports/>
           <!--   removed customization of IOSPE from stylesheets   -->
           <!--<xsl:call-template name="g-iospe"/>-->
        </xsl:when>
         <xsl:when test="$parm-leiden-style = 'rib'">
             <xsl:call-template name="g-rib"/>
         </xsl:when>
         <xsl:when test="$parm-edition-type = 'diplomatic'">
            <xsl:text> </xsl:text>
            <em>
               <span class="smaller">
                  <xsl:apply-imports/>
               </span>
            </em>
            <xsl:text> </xsl:text>
         </xsl:when>
         <xsl:when test="$parm-leiden-style = 'dohnicht'">
           <xsl:text>⊂</xsl:text>
           <xsl:apply-imports/>
           <xsl:text>⊃</xsl:text>
        </xsl:when>
      <xsl:when test="$parm-leiden-style = 'dharma' and not(@enjamb='yes')">
        <xsl:call-template name="g-dharma"/>
    </xsl:when>
<xsl:otherwise>
      <xsl:call-template name="w-space"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

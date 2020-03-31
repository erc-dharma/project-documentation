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
        <xsl:when test="@type='symbol'">
          <xsl:element name="span">
            <xsl:attribute name="class">symbol</xsl:attribute>
            <xsl:apply-imports/>
        </xsl:element>
      </xsl:when>
    <xsl:when test="@type='filler'">
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:when test="@type='numeral'">
      <xsl:choose>
        <xsl:when test="matches(., '/')">
          <xsl:call-template name="fraction"/>
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
      </xsl:choose>

      <xsl:call-template name="w-space"/>
  </xsl:template>

<xsl:template name="fraction">
    <!-- Don't get interpreted-->
  <!--<xsl:if test="matches(., '[0-9]+/[0-9]+')">
  <xsl:text disable-output-escaping="yes"><![CDATA[&]]></xsl:text>
  <xsl:value-of select="replace(.,'([0-9]+)/([0-9]+)','frac$1$2;')"/>-->
  <xsl:choose>
    <xsl:when test="matches(., '1/2')">
    <xsl:text>&#189;</xsl:text>
  </xsl:when>
  <xsl:when test="matches(., '1/4')">
  <xsl:text>&#188;</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>Fraction not sustained.</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

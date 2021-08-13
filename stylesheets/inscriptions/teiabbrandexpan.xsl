<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"  version="2.0">
   <!-- Contains templates for expan and abbr -->

  <xsl:template match="t:expan">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <xsl:if test="not(parent::t:choice)">
      <xsl:apply-templates/>
      <!-- Found in tpl-certlow.xsl -->
      <xsl:call-template name="cert-low"/>
    </xsl:if>
    <xsl:if test="parent::t:choice and $parm-leiden-style='dharma'">
      <xsl:apply-templates/>
    </xsl:if>
   </xsl:template>

   <xsl:template match="t:abbr">
       <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
       <xsl:param name="parm-edition-type" tunnel="yes" required="no"></xsl:param>
       <xsl:if test="$parm-leiden-style='dharma'">
         <xsl:if test="(ancestor::t:div[@type='edition'] or ancestor::t:lem) and not(parent::t:choice)">
         <xsl:element name="span">
           <xsl:attribute name="class">abbreviation</xsl:attribute>
       <xsl:apply-templates/>
       </xsl:element>
     </xsl:if>
         <xsl:if test="parent::t:choice">
           <xsl:apply-templates/>
         </xsl:if>
     <xsl:if test="not(ancestor::t:div[@type='edition'] or ancestor::t:lem or parent::t:choice)">
       <xsl:apply-templates/>
     </xsl:if>
       </xsl:if>
       <xsl:if test="not(ancestor::t:expan) and not($parm-edition-type='diplomatic') and not($parm-leiden-style='dharma')">
         <xsl:text>(</xsl:text><xsl:choose>
             <xsl:when test="$parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch'">
               <xsl:text>&#xa0;&#xa0;</xsl:text>
            </xsl:when>
             <xsl:when test="$parm-leiden-style = 'rib'">
               <xsl:text> . . . </xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>- - -</xsl:text>
            </xsl:otherwise>
         </xsl:choose><xsl:text>)</xsl:text>
           <xsl:if test="($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch')">
            <!-- Found in tpl-certlow.xsl -->
            <xsl:call-template name="cert-low"/>
         </xsl:if>
      </xsl:if>
   </xsl:template>

   <xsl:template match="t:ex">
       <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
       <xsl:param name="parm-edition-type" tunnel="yes" required="no"></xsl:param>
       <xsl:choose>
           <xsl:when test="$parm-edition-type = 'diplomatic'"/>
           <xsl:when test="$parm-leiden-style = 'edh-names' and parent::t:w"/>
           <xsl:when test="$parm-leiden-style = 'edh-names'">
            <xsl:text>.</xsl:text>
         </xsl:when>
         <xsl:otherwise>
             <!--<xsl:if test="not(($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch') and ancestor::t:corr[parent::t:choice])">-->

<!--            </xsl:if>-->
            <!-- at one point we wanted to suppress abbreviations inside corrected text; we no longer agree with this,
               but are leaving the code here in case it turns out to have been a good idea after all -->
            <xsl:text>(</xsl:text><xsl:apply-templates/>
            <!-- Found in tpl-certlow.xsl -->
            <xsl:call-template name="cert-low"/>
            <xsl:if
                test="$parm-leiden-style='london' and ancestor::node()[@part='M' or @part='I']
               and position()=last()">
               <xsl:text>-</xsl:text>
            </xsl:if><xsl:text>)</xsl:text>
             <!--            <xsl:if test="not(($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch') and ancestor::t:corr[parent::t:choice])">-->

<!--            </xsl:if>-->
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="t:am">
       <xsl:param name="parm-edition-type" tunnel="yes" required="no"></xsl:param>
       <xsl:choose>
          <xsl:when test="$parm-edition-type = 'interpretive'"/>
          <xsl:when test="$parm-edition-type = 'diplomatic'">
            <xsl:apply-templates/>
         </xsl:when>
      </xsl:choose>

   </xsl:template>

</xsl:stylesheet>

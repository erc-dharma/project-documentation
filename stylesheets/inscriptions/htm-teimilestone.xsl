<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:EDF="http://epidoc.sourceforge.net/ns/functions"
   exclude-result-prefixes="#all" version="2.0">
   <!-- More specific templates in teimilestone.xsl -->

  <xsl:template match="t:milestone">
       <xsl:param name="parm-leiden-style" tunnel="yes" required="no"/>
       <xsl:choose>
         <xsl:when
             test="($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch') and ancestor::t:div[@type = 'translation']">
            <xsl:if test="@rend = 'break'">
               <br/>
            </xsl:if>
            <sup>
               <strong>
                  <xsl:value-of select="@n"/>
               </strong>
            </sup>
            <xsl:text> </xsl:text>
         </xsl:when>
           <xsl:when test="($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch')">
            <xsl:choose>
               <xsl:when test="@rend = 'wavy-line'">
                  <xsl:if test="not(parent::t:supplied)">
                     <br/>
                  </xsl:if>
                  <xsl:text>~~~~~~~~</xsl:text>
               </xsl:when>
               <xsl:when test="@rend = 'paragraphos'">
                  <xsl:if test="following-sibling::node()[not(self::text() and normalize-space(self::text())='')][1]/self::t:lb[@break='no']">-</xsl:if>
                  <xsl:if test="not(parent::t:supplied)">
                     <br/>
                  </xsl:if>
                  <xsl:text>——</xsl:text>
               </xsl:when>
               <xsl:when test="@rend = 'horizontal-rule'">
                  <xsl:if test="not(parent::t:supplied)">
                     <br/>
                  </xsl:if>
                  <xsl:text>————————</xsl:text>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="$parm-leiden-style = 'dharma'">
           <xsl:choose>
             <xsl:when test="ancestor::t:app">
               <xsl:element name="span">
                 <xsl:attribute name="trigger">hover</xsl:attribute>
                 <xsl:attribute name="class">milestone-label</xsl:attribute>
                 <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                 <xsl:attribute name="data-placement">top</xsl:attribute>
                 <xsl:attribute name="title">
                   <xsl:value-of select="concat(upper-case(substring(@unit,1,1)), substring(@unit, 2),' '[not(last())] )"/>
                   <xsl:if test="@n">
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="@n"/>
                   </xsl:if>
                 </xsl:attribute>
                   <xsl:text>&#8225;</xsl:text>
               </xsl:element>
         </xsl:when>
         <xsl:when test="not(ancestor::t:div[@type='translation'])">
           <!--<xsl:text>&#8225; </xsl:text>-->
             <xsl:element name="span">
               <xsl:attribute name="trigger">hover</xsl:attribute>
               <xsl:attribute name="class">milestone-label</xsl:attribute>
               <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
               <xsl:attribute name="data-placement">top</xsl:attribute>
               <xsl:attribute name="title">
                 <xsl:value-of select="following-sibling::t:label[1]"/>
               </xsl:attribute>
             <xsl:element name="sup">
               <xsl:attribute name="class">linenumber</xsl:attribute>
               <!--<xsl:text>[</xsl:text>-->
               <xsl:if test="not(@unit='face')"><xsl:value-of select="concat(upper-case(substring(@unit,1,1)), substring(@unit, 2),' '[not(last())] )"/>
               <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:if test="@n">
               <xsl:value-of select="@n"/>
               </xsl:if>
               <!--<xsl:text>]</xsl:text>-->
             </xsl:element>
             </xsl:element>
           
         </xsl:when>
         <xsl:when test="ancestor::t:div[@type='translation'] and @type='ref'">
           <xsl:if test="@n and @unit='line'">
             <sup class="linenumber">
              <xsl:value-of select="@n"/>
            </sup>
          </xsl:if>
          <xsl:if test="@n and @unit='stanza'">
            <sup class="linenumber">
           <xsl:number value="@n" format="I"/>
         </sup>
       </xsl:if>
         </xsl:when>
       </xsl:choose>
     </xsl:when>
         <xsl:otherwise>
           <xsl:if test="not($parm-leiden-style = 'dharma')">
            <br/>
            <xsl:value-of select="@rend"/>
          </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="t:cb">
      <xsl:param name="parm-leiden-style" tunnel="yes" required="no"/>
      <xsl:if test="$parm-leiden-style='iospe'">
         <xsl:element name="span">
            <xsl:attribute name="class" select="'textpartnumber'"/>
            <xsl:attribute name="style" select="'left: -4em;'"/>
            <xsl:text>Col. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:element name="br"/>
         </xsl:element>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>

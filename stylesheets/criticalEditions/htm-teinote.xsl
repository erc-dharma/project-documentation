<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Template in teinote.xsl -->
  <xsl:import href="teinote.xsl"/>

   <xsl:template match="t:note">
     <xsl:choose>
       <xsl:when test="@type='parallels' and parent::t:supplied"/>
        <xsl:when test="@type='parallels' and not(parent::t:quote[@type='basetext'])">
          <xsl:if test="descendant::t:item/@corresp='unknown'">
            <xsl:text>[The text hasn't been transmitted]</xsl:text>
          </xsl:if>
          <xsl:element name="ul">
            <xsl:for-each select="descendant::t:item">
                <xsl:element name="li">
              <xsl:value-of select="@*"/>
              <xsl:if test="./text()">
                <span class="tooltip">
                  <xsl:text> 💬</xsl:text>
                  <span class="tooltiptext"><i><xsl:value-of select="./text()"/></i></span>
                </span>
              </xsl:if>
          </xsl:element>
          </xsl:for-each>
          </xsl:element>
      </xsl:when>
      <xsl:when test="ancestor::t:app"/>
      <!--<xsl:when test="ancestor::t:app">
        <xsl:apply-templates/>
      </xsl:when>-->
      <xsl:when test="ancestor::t:p or ancestor::t:l or ancestor::t:ab">
        <span class="tooltip">
          <xsl:text>💬</xsl:text>
          <span class="tooltiptext"><i><xsl:value-of select="."/></i></span>
        </span>
        </xsl:when>

         <xsl:otherwise>
            <p class="note">
               <xsl:apply-imports/>
            </p>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

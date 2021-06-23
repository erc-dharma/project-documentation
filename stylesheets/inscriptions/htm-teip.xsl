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
           <xsl:when test="matches(@n, '[rv]+')">
             <xsl:element name="div">
               <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
             <xsl:value-of select="@n"/>
             </xsl:element>
           </xsl:when>
              <!--<xsl:when test="count(@n) &gt;= 2">-->
              <xsl:when test="matches(@n, ',')">
                <xsl:element name="div">
                  <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
                <xsl:number value="substring-before(@n, ',')" format="I"/>
                <xsl:text>, </xsl:text>
                <xsl:number value="substring-after(@n, ',')" format="I"/>
                <xsl:text>. </xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:when test="matches(@n, '-')">
                <xsl:element name="div">
                  <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
                <xsl:number value="substring-before(@n, '-')" format="I"/>
                <xsl:text>, </xsl:text>
                <xsl:number value="substring-after(@n, '-')" format="I"/>
                <xsl:text>. </xsl:text>
                </xsl:element>
              </xsl:when>

              <xsl:otherwise>
                <xsl:element name="div">
                  <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
               <xsl:number value="@n" format="I"/><xsl:text>. </xsl:text>
     </xsl:element>
  </xsl:otherwise>
  </xsl:choose>
   </xsl:if>
   <xsl:choose>
     <xsl:when test="descendant::t:bibl">
       <xsl:apply-templates mode="dharma"/>
         </xsl:when>
         <xsl:otherwise>
         <xsl:apply-templates/>
       </xsl:otherwise>
       </xsl:choose>

      </p>

  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="t" version="2.0">
   <!-- hi imports in teihi.xsl, html span created here -->
   <xsl:import href="teihi.xsl"/>

   <xsl:template match="t:hi">
       <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
  <xsl:choose>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='caps'                                                       -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='caps'">
             <xsl:element name="span">
                 <xsl:attribute name="class">caps</xsl:attribute>
                 <xsl:apply-templates/>
             </xsl:element>
         </xsl:when>

         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='italic'                                                     -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='italic'">
            <xsl:element name="span">
               <xsl:attribute name="class">italic</xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='normal'                                                     -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='normal'">
            <xsl:element name="span">
               <xsl:attribute name="class">normal</xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='plain'                                                      -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='grantha'">
             <xsl:element name="span">
                 <xsl:attribute name="style">color:red;</xsl:attribute>
                 <xsl:apply-templates/>
             </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='strong'                                                     -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='strong'">
            <xsl:element name="strong">
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='subscript'                                                  -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='subscript'">
            <xsl:choose>
               <xsl:when test="$parm-leiden-style = 'iospe'">
                  <xsl:apply-templates/>
               </xsl:when>
                <xsl:when test="$parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch'">
                  <span style="vertical-align:sub;">
                     <xsl:apply-imports/>
                  </span>
               </xsl:when>
               <xsl:otherwise>
                  <!-- To be decided -->
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='superscript'                                                -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='superscript'">
            <xsl:choose>
               <xsl:when test="$parm-leiden-style = 'iospe'">
                  <xsl:apply-templates/>
               </xsl:when>
                <xsl:when test="$parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch'">
                  <span style="vertical-align:super;">
                     <xsl:apply-imports/>
                  </span>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:element name="sup">
                     <xsl:apply-templates/>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='supraline'                                                  -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- I wonder if this should be "overline" to match css practice? TE -->
         <xsl:when test="@rend='supraline'">
            <xsl:element name="span">
               <xsl:attribute name="class">supraline</xsl:attribute>
               <xsl:attribute name="title">line above</xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='tall'                                                       -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='tall'">
            <xsl:element name="span">
               <xsl:attribute name="class">tall</xsl:attribute>
               <xsl:attribute name="title">tall character: <xsl:value-of select="."/>
               </xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- @rend='underline'                                                  -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:when test="@rend='underline'">
            <xsl:element name="span">
               <xsl:attribute name="class">underline</xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <!-- UNTRAPPED REND VALUE                                               -->
         <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
         <xsl:otherwise>
            <xsl:element name="span">
               <xsl:attribute name="class">error</xsl:attribute>
               <xsl:attribute name="title">
                  <xsl:text>hi tag with rend=</xsl:text>
                  <xsl:value-of select="@rend"/>
                  <xsl:text> is not supported!</xsl:text>
               </xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>

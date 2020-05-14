<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="t" version="2.0">

   <xsl:character-map name="myChars">
   <xsl:output-character character="'" string="’"/>
   </xsl:character-map>

   <xsl:output method="xml" encoding="UTF-8" use-character-maps="myChars"/>


   <xsl:template match="t:*">
       <xsl:copy>
           <xsl:apply-templates select="@*"/>
           <xsl:apply-templates select="t:* | comment() | text()"/>
       </xsl:copy>
   </xsl:template>
   <xsl:template match="@*|processing-instruction()|comment()">
       <xsl:copy/>
   </xsl:template>

  </xsl:stylesheet>

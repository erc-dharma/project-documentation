<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0" 
  
   exclude-result-prefixes="t"
   version="2.0">
   <!-- Called from htm-tpl-structure.xsl -->

   <xsl:template name="css-script">
      <xsl:if test="$edn-structure='campa'">
         <link rel="stylesheet" href="../css/yui/reset-fonts-grids.css" type="text/css"
            media="screen" />
         <link rel="stylesheet" href="../css/screen-structure.css" type="text/css" media="screen" />
         <link rel="stylesheet" href="../css/screen-color-compound.css" type="text/css"
            media="screen" />
         <link rel="stylesheet" href="../css/screen-text-styles.css" type="text/css" media="screen" />
         <link rel="stylesheet" href="../css/screen-inscriptions.css" type="text/css" media="screen" />
      </xsl:if>
      <link rel="stylesheet" type="text/css" media="screen, projection">
         <xsl:attribute name="href">
            <xsl:value-of select="$css-loc"/>
         </xsl:attribute>
      </link>
   </xsl:template>
</xsl:stylesheet>

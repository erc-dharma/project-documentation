<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs t"
    version="2.0">
    
    <xsl:output indent="yes" encoding="UTF-8"/>
    
    <!-- Identity template -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Deleting space - must be refined in order to match as best as possible the pipeline -->
    <xsl:template match="t:text/descendant-or-self::*[not(local-name()=('head', 'note', 'app' ))]/text()">
            <xsl:apply-templates select="translate(., ' ', '')"/>
    </xsl:template>
   
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 31, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> Tom Elliott</xd:p>
            <xd:p>handle the TEI quote element</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="t:quote[@rend='block']">
        <blockquote>
            <xsl:choose>
                <xsl:when test="not(t:p)">
                    <p><xsl:apply-templates/></p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </blockquote>
    </xsl:template>
    
    <xsl:template match="t:quote[not(@rend) or not(@rend='block')]">
        <xsl:text>“</xsl:text><span class="quote-inline"><xsl:apply-templates/></span><xsl:text>”</xsl:text>
    </xsl:template>
</xsl:stylesheet>
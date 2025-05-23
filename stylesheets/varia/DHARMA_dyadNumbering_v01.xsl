<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- Written by Axelle Janiak for ERC-DHARMA, 2021-11-17 -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="numerotation">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='dyad']" mode="numerotation">
        <xsl:copy>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:attribute name="n"> 
                <xsl:number count="tei:div[@type='dyad']" level="single" 
                    format="1"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
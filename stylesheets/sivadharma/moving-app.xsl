<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Identity template -->
    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="tei:l"/>
        </xsl:copy>
        <xsl:element name="listApp">
            <xsl:attribute name="type">apparatus</xsl:attribute>
            <xsl:for-each select="tei:app">
                <xsl:element name="app">
                <xsl:attribute name="loc">
                    <xsl:analyze-string select="@loc" regex="([a-z])">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:attribute>
                    <xsl:copy-of select="./child::*"/>
            </xsl:element>
            </xsl:for-each>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:copy-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>
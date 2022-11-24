<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>
    
    <!-- Identity template -->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
  
    
    <xsl:template match="tei:text">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <xsl:copy>
            <xsl:attribute name="corresp">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:element name="p">
            <xsl:attribute name="rend">
                <xsl:text>stanza</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="corresp">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        <xsl:element name="p">
            <xsl:attribute name="corresp">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
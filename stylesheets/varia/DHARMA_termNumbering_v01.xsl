<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for ERC-DHARMA, 2021-04-14 -->
    <!-- Updated for note and app, 2021-09-13 -->
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
    
    <!-- App numbering works for any level: the embedded app element are numbered the same way as the embedding app -->
    <!-- App numbering might need to be updated to a 4-digits pattern -->
    <xsl:template match="tei:app" mode="numerotation">
        <xsl:copy>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:attribute name="xml:id"> 
                <xsl:value-of select="name()"/>
                <xsl:number count="tei:app" level="any" 
                    format="00001"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <!--<xsl:template match="tei:lem" mode="numerotation">
        <xsl:copy>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:attribute name="xml:id"> 
                <xsl:value-of select="name()"/>
                <xsl:number count="tei:lem" level="any" 
                    format="00001"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>-->
    
    <!--<xsl:template match="tei:note" mode="numerotation">
        <xsl:copy>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:attribute name="xml:id"> 
                <xsl:value-of select="name()"/>
                <xsl:number count="tei:note" level="any" 
                    format="001"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>-->
    
    <!--<xsl:template match="tei:rdg" mode="numerotation">
        <xsl:copy>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:attribute name="xml:id"> 
                <xsl:value-of select="name()"/>
                <xsl:number count="tei:rdg" level="any" 
                    format="00001"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>-->
   
    <xsl:template match="tei:term" mode="numerotation">
            <xsl:copy>
                <xsl:if test="@*">
                    <xsl:copy-of select="@*"/>
                </xsl:if>
                <xsl:attribute name="xml:id"> 
                    <xsl:value-of select="name()"/>
                    <xsl:number count="tei:term" level="any" 
                        format="001"/>
                </xsl:attribute>
                <xsl:apply-templates select="node()|@*" mode="numerotation"/>
            </xsl:copy>
    </xsl:template>
   
    
</xsl:stylesheet>
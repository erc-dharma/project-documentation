<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for ERC-DHARMA, 2021-03-25 -->
    <xsl:output method="xml" indent="no"/>
   
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
        
    
    <!-- Numéroter les div en prenant en compte les @type pour les dénominations-->
    
    <xsl:template match="tei:div" mode="numerotation">
        <xsl:for-each select=".">
            <xsl:variable name="numberDiv">
                    <xsl:value-of select="name()"/>
                    <xsl:number format="01" count="tei:div" level="single"/> 
            </xsl:variable>
          <xsl:copy>
              <xsl:if test="@*">
                  <xsl:copy-of select="@*"/>
              </xsl:if>
                <xsl:attribute name="xml:id" select="$numberDiv"/>
              <xsl:call-template name="internal-numbering">
                  <xsl:with-param name="numberDiv" select="$numberDiv"/>
              </xsl:call-template>  
          </xsl:copy>
        </xsl:for-each> 
    </xsl:template>
   
    <xsl:template name="internal-numbering">
        <xsl:param name="numberDiv"/>
        <xsl:for-each select="tei:p | tei:ab | tei:lg">
            <xsl:copy>
                <xsl:attribute name="xml:id">
                <xsl:value-of select="$numberDiv"/>
                <xsl:text>.</xsl:text>
                <!--<xsl:value-of select="name()"/>-->
                <xsl:number count="tei:p | tei:ab | tei:lg" level="multiple" 
                    format="01"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()" mode="numerotation"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>
    
        <!--<xsl:variable name="number">
            <xsl:number format="01" level="multiple" from="//tei:body" count="tei:div | tei:p | tei:ab | tei:lg"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id" select="concat(name(),$number)"/>
            <xsl:apply-templates select="@*|node()" mode="numerotation"/>
        </xsl:copy>
>-->
    
    
    
    
    
</xsl:stylesheet>
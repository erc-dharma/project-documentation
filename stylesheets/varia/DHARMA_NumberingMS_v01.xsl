<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for ERC-DHARMA, 2021-03-25 -->
    <!-- Updates by AJ 2021-09-13 -->
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
    
 
    <xsl:template match="tei:div" mode="numerotation">
        <xsl:variable name="fileId">
            <xsl:value-of select="//tei:TEI/@xml:id"/>
            <xsl:text>-</xsl:text>
        </xsl:variable>
        <xsl:for-each select=".">
          <xsl:copy>
              <xsl:if test="@*">
                  <xsl:copy-of select="@*"/>
              </xsl:if>
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="$fileId"/>
                    <xsl:number from="tei:body" count="tei:div | tei:p | tei:ab | tei:lg |tei:quote" level="multiple" format="01"/>
                </xsl:attribute>
              <xsl:apply-templates select="@*|node()" mode="numerotation"/>
          </xsl:copy>
        </xsl:for-each> 
    </xsl:template>
   
    <xsl:template match="tei:ab[ancestor::tei:body]" mode="numerotation">
        <xsl:variable name="fileId">
            <xsl:value-of select="//tei:TEI/@xml:id"/>
            <xsl:text>-</xsl:text>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$fileId"/>
                <xsl:number from="tei:body" count="tei:div | tei:p | tei:ab | tei:lg |tei:quote" level="multiple" format="01"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:lg[not(ancestor::tei:listApp)]" mode="numerotation">
        <xsl:variable name="fileId">
            <xsl:value-of select="//tei:TEI/@xml:id"/>
            <xsl:text>-</xsl:text>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$fileId"/>
                <xsl:number from="tei:body" count="tei:div | tei:p | tei:ab | tei:lg |tei:quote" level="multiple" format="01"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:quote" mode="numerotation">
        <xsl:variable name="fileId">
            <xsl:value-of select="//tei:TEI/@xml:id"/>
            <xsl:text>-</xsl:text>
        </xsl:variable>
            <xsl:copy>
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="$fileId"/>
                    <xsl:number from="tei:body" count="tei:div | tei:p | tei:ab | tei:lg |tei:quote" level="multiple" format="01"/>
                </xsl:attribute>
                <xsl:apply-templates select="@*|node()" mode="numerotation"/>
            </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p[ancestor::tei:body]" mode="numerotation">
        <xsl:variable name="fileId">
            <xsl:value-of select="//tei:TEI/@xml:id"/>
            <xsl:text>-</xsl:text>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$fileId"/>
                <xsl:number from="tei:body" count="tei:div | tei:p | tei:ab | tei:lg |tei:quote" level="multiple" format="01"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
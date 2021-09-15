<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting September 2021 -->
    
    <xsl:template match="root">
        <xsl:for-each select="doc">
            <xsl:result-document method="xml" href="arie_{./H1/arie/@n}_{substring-before(substring-after(./string(), '('), ')')}.xml">
                <root>
                    <xsl:attribute name="id">
                        <xsl:text>arie_</xsl:text>
                        <xsl:value-of select="./H1/arie/@n"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="substring-before(substring-after(./string(), '('), ')')"/>
                    </xsl:attribute>
                    <xsl:copy-of select="." />
                </root>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template> 
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <!-- Written by Axelle Janiak for ERC-DHARMA, 2021-03-25 -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="removeAttributesNamed" select="'xml:id'"/>
    
    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[ancestor-or-self::tei:body]">
        <xsl:if test="not(name() = $removeAttributesNamed)">
            <xsl:call-template name="identity"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
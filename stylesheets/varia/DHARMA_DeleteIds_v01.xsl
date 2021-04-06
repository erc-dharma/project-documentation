<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- Written by Axelle Janiak for ERC-DHARMA, 2021-03-25 -->
    <xsl:output method="xml" indent="no"/>
    
    <xsl:param name="removeAttributesNamed" select="'xml:id'"/>
    
    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:if test="not(name() = $removeAttributesNamed)">
            <xsl:call-template name="identity"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
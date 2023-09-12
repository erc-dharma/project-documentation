<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting July 2022 --> 
    
    <xsl:template match="File">
        <xsl:for-each select="line">
            <xsl:result-document href="DHARMA_mdt_{./fileDesc/sourceDesc/msDesc/msIdentifier/idno}_{generate-id()}.xml" method="xml" encoding="utf-8">
                <xsl:copy-of select="."/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template> 
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting août 2022 -->
    
    <xsl:template match="File">
        <xsl:for-each select="line">
                <xsl:result-document method="xml" href="DHARMA_mdt{./line/artefactDescription/artefactID}.xml">
                    <metadataAretfact>
                        <xsl:copy-of select="." />
                    </metadataAretfact>
                </xsl:result-document>
        </xsl:for-each>
    </xsl:template> 
    
</xsl:stylesheet>
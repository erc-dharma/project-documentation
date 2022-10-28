<?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xpath-default-namespace="http://www.w3.org/1999/xhtml"
        xmlns="http://www.w3.org/1999/xhtml"
        version="3.0">
        
        <!-- Written by Axelle Janiak for DHARMA, starting July 2022 -->
        <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
        
        <xsl:mode on-no-match="shallow-copy"/>
        
        <xsl:template match="text()">
            <xsl:analyze-string select="." regex="COMMA">
                <xsl:matching-substring>
                    <xsl:text>,</xsl:text>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:apply-templates select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:template>
    </xsl:stylesheet>

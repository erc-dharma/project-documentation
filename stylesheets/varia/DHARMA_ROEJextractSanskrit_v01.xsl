<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei functx"
    version="2.0">
    
    
    <xsl:output method="xml" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*"/>
    
    <!-- /TEI/text[1]/body[1]/div[1] -->
    <xsl:template match="/tei:TEI/tei:teiHeader"/>
    <xsl:template match="/tei:TEI/tei:text/tei:back"/>
    <xsl:template match="/tei:TEI/tei:text/tei:front"/>
    
    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div[@type='chapter']">
        <list>
        <xsl:if test="//tei:cit[descendant-or-self::*[@xml:lang='sk']]">
            <xsl:copy-of select="//tei:cit[descendant-or-self::*[@xml:lang='sk']]"/>
        </xsl:if>
        </list>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="xs"
                version="2.0">

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

    <xsl:template match="tei:div[ancestor::tei:div[@type='edition']] |
        tei:ab[ancestor::tei:div[@type='edition']] |
        tei:lg[ancestor::tei:div[@type='edition'] and not(ancestor::tei:listApp)] |
        tei:quote[ancestor::tei:div[@type='edition'] and not(ancestor-or-self::tei:listApp[@type='parallels'])] |
        tei:p[ancestor::tei:div[@type='edition']]" mode="numerotation">
        <xsl:variable name="fileId">
            <xsl:value-of select="//tei:TEI/@xml:id"/>
            <xsl:text>_</xsl:text>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$fileId"/>
                <xsl:number from="tei:text" count="tei:div[not(@type='edition')] | tei:p | tei:ab | tei:lg | tei:quote" level="multiple" format="01"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[name() != 'xml:id']" mode="numerotation"/>
            <xsl:apply-templates select="node()" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

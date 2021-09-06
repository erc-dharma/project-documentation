<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs t functx"
    version="2.0">
    
    <xsl:output indent="yes" encoding="UTF-8"/>

    <xsl:function name="functx:capitalize-first" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        
        <xsl:sequence select="
            concat(upper-case(substring($arg,1,1)),
            substring($arg,2))"/>
        
    </xsl:function>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template match="t:p/descendant-or-self::text()[1]">
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
        <!--  and functx:capitalize-first(substring-after(., '. ')) -->
    </xsl:template>
    
    <xsl:template match="t:ab/descendant-or-self::text()[1]">
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
        <!--  and functx:capitalize-first(substring-after(., '. ')) -->
    </xsl:template>
    
    <xsl:template match="t:persName/descendant-or-self::text()[1]">
        
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
    </xsl:template>
    
    <xsl:template match="t:placeName/descendant::text()[1]">
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
    </xsl:template>
    
    <xsl:template match="t:lb">
        <xsl:copy-of select="."/>
        <xsl:if test="ends-with(./preceding::text()[1], '.')">
            <xsl:analyze-string select="./following::text()[1]" regex="(^\w)">
                <xsl:matching-substring>
                    <xsl:variable name="firstChar" select="regex-group(1)"/>
                    <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:copy>
                        <xsl:apply-templates select="."/>
                    </xsl:copy>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
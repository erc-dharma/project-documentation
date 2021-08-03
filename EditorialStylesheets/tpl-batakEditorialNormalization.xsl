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
    </xsl:template>
    
    <xsl:template match="t:ab/descendant-or-self::text()[1]">
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
    </xsl:template>
    
    <xsl:template match="t:persName/descendant-or-self::text()[1]">
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
    </xsl:template>
    
    <xsl:template match="t:placeName/descendant::text()[1]">
        <xsl:apply-templates select="functx:capitalize-first(.)"/>
    </xsl:template>
    
    <xsl:template name="caseUp">
        <xsl:param name="data"/>
        <xsl:if test="$data">
            <xsl:choose>
                <xsl:when test="starts-with($data,'. ')"> 
                    <xsl:text> </xsl:text> 
                    <xsl:call-template name="caseDown">
                        <xsl:with-param name="data" select="substring($data,3)"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(substring($data,1,1),
                        'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                    <!-- put all the chars you want to change 
                 into the last two strings -->        
                    <xsl:call-template name="caseDown">
                        <xsl:with-param name="data" select="substring($data,2)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>  
    </xsl:template>
    
    <xsl:template name="caseDown">
        <xsl:param name="data"/>
        <xsl:if test="$data">
            <xsl:value-of select="substring($data,1,1)"/>
            <xsl:call-template name="caseUp"> 
                <xsl:with-param name="data" select="substring($data,2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
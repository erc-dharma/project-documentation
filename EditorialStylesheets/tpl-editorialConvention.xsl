<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs t"
    version="2.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:param name="english-regexes" as="element(regex)*">
        <!-- curly quotes -->
        <regex>
            <find>(\s*)"([\w])</find>
            <change>$1“$2</change>
        </regex>
        <regex>
            <find>([\w])"([\s\.]*)</find>
            <change>$1”$2</change>
        </regex>
        
    </xsl:param>
    <xsl:param name="french-regexes" as="element(regex)*">
        <!-- Non breaking space -->
        <regex>
            <find>[\s]([;\?!»:]+)</find>
            <change>&#160;$1</change>
        </regex>
        <regex>
            <find>([\w])([;\?!»:]+)</find>
            <change>$1&#160;$2</change>
        </regex>
        <regex>
            <find>([«])[\s]</find>
            <change>$1&#160;</change>
        </regex>
        <regex>
            <find>([«])([\w])</find>
            <change>$1&#160;$2</change>
        </regex>
        <regex>
            <find>"([\w])</find>
            <change>«&#160;$1</change>
        </regex>
        <regex>
            <find>([\w\.])"</find>
            <change>$1&#160;»</change>
        </regex>
    </xsl:param>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="t:div[@xml:lang='fra']/descendant::text()[string-length(normalize-space(.))>0]">
        <xsl:call-template name="applyRegexes">
            <xsl:with-param name="nodeText" select="."/>
            <xsl:with-param name="regex" select="$french-regexes"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="t:div[not(@xml:lang='fra')]/descendant::text()[string-length(normalize-space(.))>0]">
            <xsl:call-template name="applyRegexes">
            <xsl:with-param name="nodeText" select="."/>
            <xsl:with-param name="regex" select="$english-regexes"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="applyRegexes">
        <xsl:param name="nodeText"/>
        <xsl:param name="regex"/>
        <xsl:choose>
            <xsl:when test="$regex">
                <xsl:variable name="temp">
                    <xsl:value-of
                        select="replace($nodeText,$regex[1]/find,$regex[1]/change)"/>
                </xsl:variable>
                <xsl:call-template name="applyRegexes">
                    <xsl:with-param name="nodeText" select="$temp"/>
                    <xsl:with-param name="regex"
                        select="$regex[position()>1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nodeText"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
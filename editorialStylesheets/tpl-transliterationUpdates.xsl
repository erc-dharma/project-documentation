<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs t functx"
    version="2.0">
    
    <xsl:output indent="yes" encoding="UTF-8"/>
    
    <!-- pattern to copy-paste
    <regex>
            <find></find>
            <change></change>
        </regex>
    -->
    
    <xsl:param name="batak-regexes" as="element(regex)*">
        <!-- Transformation of consonants -->
        <regex>
            <find>[ṅṁ]</find>
            <change>ng</change>
        </regex>
        <regex>
            <find>(\s+)[k]</find>
            <change>$1h</change>
        </regex>
        <regex>
            <find>[h]([aeiou])</find>
            <change>$2</change>
        </regex>
        
        <!-- complex pattern -->
        <regex>
            <find>[a](\w)([eiou])[·]</find>
            <change>$2$1</change>
        </regex>
        <!--<regex>
            <find>(\.[\n\r\s\t])([a-z])</find>
            <change>$1\u$2</change>
        </regex>-->
    </xsl:param>
    
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="t:text/descendant-or-self::*[not(local-name()=('head', 'note'))]/text()[string-length(.)>0]">
        <xsl:call-template name="applyRegexes">
            <xsl:with-param name="nodeText" select="normalize-space(.)"/>
            <xsl:with-param name="regex" select="$batak-regexes"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="applyRegexes">
        <xsl:param name="nodeText"/>
        <xsl:param name="regex"/>
        <xsl:choose>
            <xsl:when test="$regex">
                <xsl:variable name="temp">
                    <xsl:apply-templates
                        select="lower-case(replace($nodeText,$regex[1]/find,$regex[1]/change))"/>
                </xsl:variable>
                <xsl:call-template name="applyRegexes">
                    <xsl:with-param name="nodeText" select="$temp"/>
                    <xsl:with-param name="regex"
                        select="$regex[position()>1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="lower-case($nodeText)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
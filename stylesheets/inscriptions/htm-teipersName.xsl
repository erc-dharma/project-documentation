<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    xmlns:url="http://whatever/java/java.net.URLEncoder"
    exclude-result-prefixes="xs xd t url"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 9, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> Tom Elliott</xd:p>
            <xd:p><xd:b>Filename:</xd:b> htm-persName.xsl</xd:p>
            <xd:p><xd:b>Copyright:</xd:b> Copyright 2012 New York University</xd:p>
            <xd:p><xd:b>License:</xd:b> GPL 3.0</xd:p>
            <xd:p>This stylesheet was added to the EpiDoc example stylesheets to support the needs of the Campā inscriptions project
            to handle the t:persName element.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="t:persName">
        <xsl:variable name="persname" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="$edn-structure='campa' and not(preceding::t:persName[.=$persname])">
                <xsl:variable name="classstring">
                    <xsl:choose>
                        <xsl:when test="@type">
                            <xsl:text></xsl:text><xsl:value-of select="@type"/>s<xsl:text></xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>persons untyped</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="gen-search">
                    <xsl:with-param name="class" select="$classstring"/>
                    <xsl:with-param name="value" select="normalize-space(.)"/>
                    <xsl:with-param name="text" select="normalize-space(.)"/>
                    <xsl:with-param name="kite">
                        <xsl:text>name of a</xsl:text>
                        <xsl:choose>
                            <xsl:when test="@type">
                                <xsl:text></xsl:text><xsl:if test="starts-with(@type, 'a') or starts-with(@type, 'e') or starts-with(@type, 'i') or starts-with(@type, 'o') or starts-with(@type, 'u')">n</xsl:if><xsl:text> </xsl:text><xsl:value-of select="@type"/><xsl:text></xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>n untyped person</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text> (click for index)</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text><span class="persName"><xsl:apply-templates/></span><xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
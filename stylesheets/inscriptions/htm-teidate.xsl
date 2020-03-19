<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 1, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> Tom Elliott</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="t:date[not(string(.)) and @when and (@calendar='Julian' or not(@calendar))]">
        <xsl:choose>
            <xsl:when test="number(@when) = number(@when) and string-length(@when) = 8">
                <xsl:variable name="year" select="number(substring(@when, 1, 4))"/>
                <xsl:variable name="month" select="number(substring(@when, 5, 2))"/>
                <xsl:variable name="monthstring">
                    <xsl:choose>
                        <xsl:when test="$month = 1">January</xsl:when>
                        <xsl:when test="$month = 2">February</xsl:when>
                        <xsl:when test="$month = 3">March</xsl:when>
                        <xsl:when test="$month = 4">April</xsl:when>
                        <xsl:when test="$month = 5">May</xsl:when>
                        <xsl:when test="$month = 6">June</xsl:when>
                        <xsl:when test="$month = 7">July</xsl:when>
                        <xsl:when test="$month = 8">August</xsl:when>
                        <xsl:when test="$month = 9">September</xsl:when>
                        <xsl:when test="$month = 10">October</xsl:when>
                        <xsl:when test="$month = 11">November</xsl:when>
                        <xsl:when test="$month = 12">December</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="day" select="number(substring(@when, 7, 2))"/>
                <xsl:message>DATE: <xsl:value-of select="@when"/> yields <xsl:value-of select="$year"/> | <xsl:value-of select="$month"/> | <xsl:value-of select="$day"/> (<xsl:value-of select="$monthstring"/>)</xsl:message>
                <span class="date-generated">
                    <xsl:text></xsl:text><xsl:value-of select="$day"/><xsl:text> </xsl:text>
                    <xsl:text></xsl:text><xsl:value-of select="$monthstring"/><xsl:text> </xsl:text>
                    <xsl:text></xsl:text><xsl:value-of select="$year"/><xsl:text></xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="xformerror">not a valid date value: empty "date" element with attribute "when" value of "<xsl:value-of select="@when"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:date">
        <span class="date"><xsl:apply-templates/></span>
    </xsl:template>
    
</xsl:stylesheet>
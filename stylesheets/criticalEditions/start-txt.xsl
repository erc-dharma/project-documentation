<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    <xsl:output method="text" indent="no" encoding="UTF-8" version="4.0"/>
    <xsl:strip-space elements="*"/>
    
   <!-- <xsl:template match="text()">
        <xsl:apply-templates select="normalize-space(.)"/>
    </xsl:template>-->
    
    <xsl:function name="functx:trim" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        
        <xsl:sequence select="
            replace(replace($arg,'\s+$',''),'^\s+','')
            "/>
        
    </xsl:function>
    
    <xsl:template match="tei:del">
        <xsl:text>⟦</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>⟧</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app">
       <xsl:text>*</xsl:text>
        <xsl:apply-templates select="tei:lem"/>
        <xsl:text> (</xsl:text>
        <xsl:for-each select="tei:lem">
            <xsl:choose>
            <xsl:when test="@type">
                <xsl:choose>
                    <xsl:when test="@type='emn'">
                    <xsl:text>em.</xsl:text>
                </xsl:when>
                    <xsl:when test="@type='norm'">
                    <xsl:text>norm.</xsl:text>
                </xsl:when>
                    <xsl:when test="@type='conj'">
                    <xsl:text>conj.</xsl:text>
                </xsl:when>   
        </xsl:choose>
            </xsl:when>
            <xsl:when test="@wit">
                <xsl:value-of select="replace(@wit, '#', 'ms')"/>
            </xsl:when>
        </xsl:choose>
        </xsl:for-each>
        <xsl:if test="tei:lem/following-sibling::tei:rdg">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:for-each select="tei:rdg">
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
            <xsl:if test="@wit">
                <xsl:value-of select="replace(@wit, '#', 'ms')"/>
            </xsl:if>
            <xsl:if test="following-sibling::tei:rdg">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:text>[</xsl:text>
        <xsl:choose>
            <xsl:when test="@reason='omitted'"/>
            <xsl:when test="@reason='lost' and not(@quantity|@unity)"/>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="class">gap</xsl:attribute>
                    <xsl:choose> 
                        <xsl:when test="@quantity and @unit">
                            <xsl:if test="@precision='low'">
                                <xsl:text>ca. </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="@quantity"/>
                            <xsl:if test="@unit='character'">
                                <xsl:choose>
                                    <xsl:when test="@reason='lost'">
                                        <xsl:text>+</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@reason='illegible'">
                                        <xsl:text>×</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@reason='undefined'">
                                        <xsl:text>*</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if> 
                        </xsl:when>
                        <xsl:when test="@extent">
                            <xsl:text>...</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>...</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>         
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:lacunaStart">
        <xsl:text>[...</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:lacunaEnd">
        <xsl:text>...]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:apply-templates/>
        <xsl:text> ||</xsl:text>
        <xsl:choose>
            <xsl:when test="@n">
                <xsl:value-of select="@n"/>
            </xsl:when>
        <xsl:otherwise>
            <xsl:number count="tei:lg" level="any" format="1"/>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:text>|| </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:note"> 
        <xsl:text>•</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:text> [ms</xsl:text>
        <xsl:value-of select="substring-after(@edRef, '#')"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>] </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:sic">
        <xsl:text>†</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>†</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:supplied">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:surplus">
        <xsl:text>{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader"/>
    
    <xsl:template match="tei:unclear">
        <xsl:text>⟨</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>⟩</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
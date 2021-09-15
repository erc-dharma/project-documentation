<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- Written by Axelle Janiak for DHARMA, starting September 2021 -->
    
    <xsl:template match="root">
        <xsl:element name="TEI">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:attribute name="xml:lang">
                <xsl:text>eng</xsl:text>
            </xsl:attribute>
            <xsl:element name="teiHeader">
                <xsl:element name="fileDesc">
                    <xsl:element name="titleStmt">
                        <xsl:element name="title">
                            <xsl:text>ARIE </xsl:text>
                            <xsl:value-of select="substring-after(substring-after(@id, '_'), '_')"/>
                            <xsl:text> [vol. </xsl:text>
                            <xsl:value-of select="substring-before(substring-after(@id, '_'), '_')"/>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="publicationStmt">
                        <xsl:element name="authority">
                            <xsl:text>To Be Filled In</xsl:text>
                        </xsl:element>
                        <xsl:element name="pubPlace">
                            <xsl:text>To Be Filled In</xsl:text>
                        </xsl:element>
                        <xsl:element name="idno">
                            <xsl:attribute name="type">
                                <xsl:text>filename</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="@id"/>
                        </xsl:element>
                        <xsl:element name="availability">
                            <xsl:element name="licence">
                                <xsl:attribute name="target">
                                    <xsl:text>To_Be_Filled_In</xsl:text>
                                </xsl:attribute>
                            </xsl:element>
                            <xsl:element name="p">
                                <xsl:text>Copyright (c) To Be Filled In</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="date">
                            <xsl:text>To Be Filled In</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="sourceDesc">
                        <xsl:element name="p">
                            <xsl:value-of select="descendant::H1"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates/>       
        </xsl:element>    
    </xsl:template>
    
    <xsl:template match="doc">
        <xsl:element name="text">
            <xsl:element name="body">
            <xsl:apply-templates/>
        </xsl:element>
        </xsl:element>
    </xsl:template> 
    
    <xsl:template match="INSCRIPTION">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>inscription</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="./S"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- S -->
    <xsl:template match="S">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>number</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- P -->
    <xsl:template match="P">
        <xsl:element name="div">
            <xsl:attribute name="type">
            <xsl:text>place</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
            <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Y -->
    <xsl:template match="Y">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>dynasty</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- K -->
    <xsl:template match="K">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>king</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- D -->
    <xsl:template match="D">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>date</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- L -->
    <xsl:template match="L">
        <xsl:variable name="volume">
            <xsl:value-of select="substring-before(substring-after(//root/@id, '_'), '_')"/>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="number($volume) gt 16">
                        <xsl:text>language-alphabet</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>language</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- O -->
    <xsl:template match="O">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>origin</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- E -->
    <xsl:template match="E">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>edition</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- R -->
    <xsl:template match="R">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>remarks</xsl:text>
            </xsl:attribute>
            <xsl:element name="p"> 
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Titles -->
    <xsl:template match="H1">
            <xsl:element name="div">
                <xsl:attribute name="n">
                    <xsl:text>h1</xsl:text>
                </xsl:attribute>
                <xsl:element name="title">
                    <xsl:text>ARIE </xsl:text>
                    <xsl:value-of select="substring-after(substring-after(//root/@id, '_'), '_')"/>
                    <xsl:text> [vol. </xsl:text>
                    <xsl:value-of select="substring-before(substring-after(//root/@id, '_'), '_')"/>
                    <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:element>      
    </xsl:template>
    
    <xsl:template match="H2">
        <xsl:for-each select=".">
            <xsl:element name="div">
                <xsl:attribute name="n">
                    <xsl:text>h2</xsl:text>
                </xsl:attribute>
                <xsl:element name="head">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="HC">
        <xsl:element name="title">
            <xsl:attribute name="n">
                <xsl:text>hc</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="HP">
        <xsl:element name="title">
            <xsl:attribute name="n">
                <xsl:text>hp</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Typography -->
    <xsl:template match="i">
        <xsl:element name="hi">
            <xsl:attribute name="rend">
                <xsl:text>italic</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="b">
        <xsl:element name="hi">
            <xsl:attribute name="rend">
                <xsl:text>bold</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Milestones elements -->
    <xsl:template match="lb">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="pb">
        <xsl:copy-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>
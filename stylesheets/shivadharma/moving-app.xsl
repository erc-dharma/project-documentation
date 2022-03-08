<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei">

    <xsl:function name="functx:substring-after-last" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>

        <xsl:sequence select="
            replace ($arg,concat('^.*',functx:escape-for-regex($delim)),'')
            "/>

    </xsl:function>
    
    <xsl:function name="functx:substring-before-last" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>
        
        <xsl:sequence select="
            if (matches($arg, functx:escape-for-regex($delim)))
            then replace($arg,
            concat('^(.*)', functx:escape-for-regex($delim),'.*'),
            '$1')
            else ''
            "/>
        
    </xsl:function>

    <xsl:function name="functx:escape-for-regex" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>

        <xsl:sequence select="
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "/>

    </xsl:function>

    <xsl:output method="xml" indent="yes"/>

    <!-- Identity template -->
    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:attribute name="type">
                <xsl:text>edition</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xml:lang">
                <xsl:text>eng</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="substring-before(functx:substring-after-last(base-uri(.), '/'), '_')"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>

    </xsl:template>

    <!--<xsl:template match="tei:teiHeader">
        <xsl:copy-of select="."/>
    </xsl:template>-->

    <xsl:template match="tei:title">
        <xsl:copy>
                <xsl:attribute name="type">main</xsl:attribute>
                <xsl:value-of select="functx:substring-after-last(substring-before(base-uri(.), '_csaba_kiss'), '/')"/>
        </xsl:copy>
        <!-- Il faudra faire ajouter les editeurs réels, mais pour la moment la mention du projet fera l'affaire -->
        <xsl:element name="editor" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">Projet Shivadharma</xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:authority">
        <xsl:copy>
            <xsl:text>Sivádharma</xsl:text>
        </xsl:copy>
        <xsl:element name="pubPlace" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:text>Naples, Italy</xsl:text>
      </xsl:element>
    </xsl:template>

    <xsl:template match="tei:idno[@type='filename']">
        <xsl:copy>
            <xsl:text>DHARMA_CritED</xsl:text>
            <xsl:value-of select="functx:substring-after-last(substring-before(base-uri(.), '_csaba_kiss'), '/')"/>
        </xsl:copy>
        <xsl:element name="availability" namespace="http://www.tei-c.org/ns/1.0">
        <xsl:element name="licence" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="target">
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
        <xsl:text>This work is licenced under the Creative Commons Attribution 4.0 Unported Licence. To view a copy of the licence, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.</xsl:text>
      </xsl:element>
      <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
        <xsl:text>Copyright (c) 2019-2025 by Shivadharma</xsl:text>
      </xsl:element>
      </xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
        <xsl:attribute name="from">2019</xsl:attribute>
        <xsl:attribute name="to">2025</xsl:attribute>
        <xsl:text>2019-2025</xsl:text>
      </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lg">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="tei:l"/>
        </xsl:copy>
        <xsl:element name="listApp" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">apparatus</xsl:attribute>
            <xsl:choose>
                <xsl:when test="tei:app">
                    <xsl:for-each select="tei:app">
                <xsl:element name="app" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="loc">
                    <xsl:choose>
                        <xsl:when test="ancestor-or-self::tei:lg[@met='anuṣṭubh']">
                                    <xsl:analyze-string select="@loc" regex="([a-z]+)">
                                    <xsl:matching-substring>
                                        <!--<xsl:value-of select="regex-group(1)"/>-->
                                        <xsl:choose>
                                            <xsl:when test="regex-group(1) = 'uvaca'"><xsl:text>uvāca</xsl:text></xsl:when>
                                            <xsl:when test="regex-group(1) = 'a' or regex-group(1) = 'b'"><xsl:text>ab</xsl:text></xsl:when>
                                            <xsl:when test="regex-group(1) = 'c' or regex-group(1) = 'd'"><xsl:text>cd</xsl:text></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="regex-group(1)"/></xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                        <xsl:otherwise>
                            <xsl:analyze-string select="@loc" regex="([a-z])">
                                <xsl:matching-substring>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                    <xsl:if test="child::tei:*">
                        <xsl:for-each select="child::tei:*">
                            <xsl:element name="{name(.)}" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:copy-of select="@*"/>            
                            <xsl:apply-templates select="replace(., '°', '')"/>
                        </xsl:element>
                        </xsl:for-each>
                    </xsl:if>                    
            </xsl:element>
            </xsl:for-each>
            </xsl:when>
                <!-- <xsl:otherwise>
                    <xsl:variable name="filename" select="substring-before(functx:substring-after-last(base-uri(.), '/'), '.xml')"/>
                    <xsl:variable name="path-file" select="functx:substring-before-last(substring-after(base-uri(.), 'tfd-sanskrit-philology/'), '/')"/>
                    <xsl:variable name="apparatus-content">
                        <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-sanskrit-philology/master/', $path-file, $filename, '_apparatus.xml')"/>
                    </xsl:variable>
                    <xsl:copy-of select=""/>
                </xsl:otherwise>-->
            </xsl:choose>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>

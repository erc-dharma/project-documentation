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
    
    <!-- To dos list:
    - [omitted] to be converted in XML
    - acorr and pcorr to be converted  
    -->
    <!-- Not necessary but still have to be resolved on Csaba side 
    - nat apparatus
    - dealing with @met anuṣṭubh => maybe change of structure by Csaba
    - C combining several mss
    -->

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
            <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">Shivadharma Project</xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:authority">
        <xsl:copy>
            <xsl:text>Shivadharma Project</xsl:text>
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

    <!-- PB de namespace -->
    <xsl:template match="tei:sourceDesc">
        <xsl:variable name="filename" select="substring-before(functx:substring-after-last(base-uri(.), '/'), '.xml')"/>
        <xsl:variable name="path-file" select="functx:substring-before-last(substring-after(base-uri(.), 'texts/'), '/')"/>
        <xsl:variable name="listWit-content">
            <!--  -->
            <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-sanskrit-philology/master/texts/', $path-file,'/', $filename, '_listWit.xml')"/>
        </xsl:variable>
        <xsl:message><xsl:value-of select="$filename"/></xsl:message>
        <xsl:message><xsl:value-of select="$path-file"/></xsl:message>
        <xsl:message><xsl:value-of select="$listWit-content"/></xsl:message>
        <xsl:copy-of select="doc($listWit-content)//tei:listWit" copy-namespaces="no"/>      
         
    </xsl:template>
    
    <xsl:template match="tei:div[@type='edition']">
        <xsl:for-each-group select="tei:lg" group-by="substring-before(@n, '.')">
            <xsl:element name="div" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:text>canto</xsl:text>
                </xsl:attribute>
                
                    <xsl:attribute name="n">
                        <xsl:value-of select="substring-before(@n, '.')"/>
                    </xsl:attribute>
                
                <xsl:for-each select="current-group()">
                    <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:copy-of select="tei:l"/>
                    </xsl:copy>
                    <xsl:element name="listApp" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type">apparatus</xsl:attribute>
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
                                                    <xsl:choose>
                                                        <xsl:when test="@wit">
                                                            <xsl:attribute name="wit">
                                                                <xsl:value-of select="replace(replace(@wit, 'acorr', ''), 'pcorr', '')"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:when test="@type">
                                                            <xsl:attribute name="type">
                                                                <xsl:value-of select="replace(@type, '#', '')"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                    <xsl:if test="contains(., '[omitted]')">
                                                        <xsl:analyze-string select="." regex="\[(omitted)\]">
                                                            <xsl:matching-substring>
                                                                <xsl:element name="gap" namespace="http://www.tei-c.org/ns/1.0">
                                                                    <xsl:attribute name="reason">
                                                                        <xsl:value-of select="regex-group(1)"/>
                                                                    </xsl:attribute>
                                                                </xsl:element>
                                                            </xsl:matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:if>
                                                    <xsl:apply-templates select="replace(replace(., '°', ''), '\[omitted\]', '')"/>
                                                </xsl:element>
                                                <xsl:if test="contains(@wit, 'corr')">
                                                    <xsl:call-template name="tokenize-witness-list">
                                                        <xsl:with-param name="string" select="@wit"/>
                                                    </xsl:call-template> 
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>                    
                                    </xsl:element>
                                </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="tokenize-witness-list">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="contains($string, ' ')">
                <xsl:variable name="first-item"
                    select="translate(normalize-space(substring-before($string, ' ')), '#', '')"/>
                <xsl:if test="$first-item">
                    <xsl:call-template name="wit-detail">
                        <xsl:with-param name="list" select="$first-item"/>
                    </xsl:call-template>
                    <xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="substring-after($string, ' ')"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$string = ''">
                        <xsl:text/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="wit-detail">
                            <xsl:with-param name="list" select="translate($string, '#', '')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="wit-detail">
        <xsl:param name="list"/>
            <xsl:if test="contains($list, 'corr')">
            <xsl:element name="witDetail" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="wit">
                    <xsl:value-of select="replace(replace($list, 'acorr', ''), 'pcorr', '')"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:choose>
                        <xsl:when test="ends-with($list, 'acorr')">
                            <xsl:text>ac</xsl:text>
                        </xsl:when>
                        <xsl:when test="ends-with($list, 'pcorr')">
                            <xsl:text>pc</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
            </xsl:if>
    </xsl:template>
    
    <!--<xsl:template match="tei:lg">
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
                                        <!-\-<xsl:value-of select="regex-group(1)"/>-\->
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
                                <xsl:choose>
                                    <xsl:when test="@wit">
                                        <xsl:copy-of select="@wit"/>
                                    </xsl:when>
                                    <xsl:when test="@type">
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="replace(@type, '#', '')"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                </xsl:choose>         
                            <xsl:apply-templates select="replace(., '°', '')"/>
                        </xsl:element>
                        </xsl:for-each>
                    </xsl:if>                    
            </xsl:element>
            </xsl:for-each>
            </xsl:when>
                <!-\- <xsl:otherwise>
                    <xsl:variable name="filename" select="substring-before(functx:substring-after-last(base-uri(.), '/'), '.xml')"/>
                    <xsl:variable name="path-file" select="functx:substring-before-last(substring-after(base-uri(.), 'tfd-sanskrit-philology/'), '/')"/>
                    <xsl:variable name="apparatus-content">
                        <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-sanskrit-philology/master/', $path-file, $filename, '_apparatus.xml')"/>
                    </xsl:variable>
                    <xsl:copy-of select=""/>
                </xsl:otherwise>-\->
            </xsl:choose>
        </xsl:element>
    </xsl:template>-->
</xsl:stylesheet>

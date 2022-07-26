<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    
    <!-- Written by Axelle Janiak for DHARMA, starting July 2022 -->
    
    <xsl:function name="functx:escape-for-regex" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>  
        <xsl:sequence select="replace($arg,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>     
    </xsl:function>
    <xsl:function name="functx:substring-after-last" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>
        <xsl:sequence select="replace($arg,concat('^.*',functx:escape-for-regex($delim)),'')"/>
    </xsl:function>
    
    <xsl:param name="data" as="xs:string" select="uri-collection('https://github.com/erc-dharma/mdt-texts/tree/main/csv/.?select=*.csv')!unparsed-text(.) "/>
    <!-- https://api.github.com/repos/erc-dharma/mdt-texts/contents/csv -->
    <!-- for $uri in uri-collection('https://github.com/erc-dharma/mdt-texts/tree/main/csv') return unparsed-text($uri) -->
    
    <xsl:variable name="lines">
        <xsl:for-each select="tokenize($data, '\r?\n')">
            <xsl:if test="position() >= 6">
            <line>
                <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
                <sourceDesc>
                    <msDesc>
                        <msIdentifier>
                            <repository>DHARMAbase</repository>
                            <idno><xsl:value-of select="$tokens[15]"/></idno>
                            <xsl:if test="$tokens[17]">
                                <altIdentifier>
                                    <idno><xsl:value-of select="$tokens[17]"/></idno>
                                </altIdentifier>
                            </xsl:if>
                            <xsl:if test="$tokens[18]">
                                <altIdentifier>
                                    <idno><xsl:value-of select="$tokens[18]"/></idno>
                                </altIdentifier>
                            </xsl:if>
                            <xsl:if test="$tokens[19]">
                                <altIdentifier>
                                    <idno><xsl:value-of select="$tokens[19]"/></idno>
                                </altIdentifier>
                            </xsl:if>
                        </msIdentifier>
                        <msContents>
                            <xsl:element name="msItem">
                                <xsl:if test="$tokens[22]">
                                    <xsl:attribute name="class">
                                        <xsl:text>#</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[22], ' - ')"/>
                                        <xsl:if test="$tokens[23]">
                                            <xsl:text> #</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[23], ' - ')"/>
                                        </xsl:if>
                                        <xsl:if test="$tokens[24]">
                                            <xsl:text> #</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[24], ' - ')"/>
                                        </xsl:if>
                                        <xsl:if test="$tokens[25]">
                                            <xsl:text> #</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[25], ' - ')"/>
                                        </xsl:if>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="$tokens[16]">
                                    <title><xsl:value-of select="replace(replace($tokens[16], '&quot;', ''), ';', ',')"/></title>
                                </xsl:if>
                                <xsl:element name="textLang">
                                    <xsl:attribute name="mainLang">
                                        <xsl:call-template name="language-tpl">
                                            <xsl:with-param name="language" select="$tokens[26]"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:if test="$tokens[29]">
                                        <xsl:attribute name="otherLangs">
                                            <xsl:call-template name="language-tpl">
                                                <xsl:with-param name="language" select="$tokens[29]"/>
                                            </xsl:call-template>
                                            <xsl:if test="$tokens[32]">
                                                <xsl:attribute name="otherLangs">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:call-template name="language-tpl">
                                                        <xsl:with-param name="language" select="$tokens[32]"/>
                                                    </xsl:call-template>                                  
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="$tokens[35]">
                                                <xsl:attribute name="otherLangs">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:call-template name="language-tpl">
                                                        <xsl:with-param name="language" select="$tokens[35]"/>
                                                    </xsl:call-template>                                  
                                                </xsl:attribute>
                                            </xsl:if>
                                        </xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                                <xsl:if test="$tokens[49] != '' or $tokens[50] != ''">
                                    <xsl:element name="filiation">
                                        <xsl:if test="$tokens[49]">
                                            <xsl:attribute name="type">duplicate</xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="$tokens[50]">
                                            <xsl:attribute name="type">reissue</xsl:attribute>
                                        </xsl:if>
                                        <xsl:element name="ref">
                                            <xsl:attribute name="href"><xsl:choose>
                                                <xsl:when test="$tokens[50]"><xsl:value-of select="$tokens[50]"/></xsl:when>
                                                <xsl:when test="$tokens[49]"><xsl:value-of select="$tokens[49]"/></xsl:when>
                                            </xsl:choose></xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="$tokens[50]">Inscription <xsl:value-of select="$tokens[50]"/> reissue in <xsl:value-of select="$tokens[51]"/></xsl:when>
                                                <xsl:when test="$tokens[49]"><xsl:value-of select="$tokens[49]"/> is a duplicate</xsl:when>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[52] != ''">
                                    <listBibl type="primary">
                                        <xsl:variable name="sources" as="xs:string*" select="tokenize($tokens[52], '\$')"/>
                                        <xsl:for-each select="$sources">
                                            <bibl><xsl:element name="ptr">
                                                <xsl:attribute name="target">
                                                    <xsl:text>bib:</xsl:text><xsl:apply-templates select="."/>
                                                </xsl:attribute>
                                            </xsl:element></bibl>
                                        </xsl:for-each>
                                    </listBibl>
                                </xsl:if>
                                <xsl:if test="$tokens[53] != ''">
                                    <listBibl type="secondary">
                                        <xsl:variable name="biblio" as="xs:string*" select="tokenize($tokens[53], '\$')"/>
                                        <xsl:for-each select="$biblio">
                                            <bibl><xsl:element name="ptr">
                                                <xsl:attribute name="target">
                                                    <xsl:text>bib:</xsl:text><xsl:apply-templates select="."/>
                                                </xsl:attribute>
                                            </xsl:element></bibl>
                                        </xsl:for-each>
                                    </listBibl>
                                </xsl:if>
                            </xsl:element>
                        </msContents>
                        <physDesc>
                            <xsl:element name="objectDesc">
                                <xsl:if test="$tokens[21] !=''"><xsl:attribute name="corresp"><xsl:value-of select="$tokens[21]"/></xsl:attribute></xsl:if>
                                <supportDesc>
                                    <p><xsl:value-of select="$tokens[20]"/></p>
                                </supportDesc>
                                <layoutDesc>
                                    <xsl:element name="layout">
                                        <xsl:attribute name="writtenLines"><xsl:value-of select="$tokens[39]"/> <xsl:if test="$tokens[39] != $tokens[40]"><xsl:value-of select="$tokens[40]"/></xsl:if></xsl:attribute>
                                        <p><xsl:value-of select="$tokens[39]"/> lines are observed/preserved on the artifact. <xsl:if test="not($tokens[39] = $tokens[40])"><xsl:value-of select="$tokens[40]"/> are known or estimated for this text.</xsl:if> <xsl:if test="not(contains($tokens[42], '$')) and $tokens[42] != ''"><dimensions type="inscribed" unit="cm">
                                            <height><xsl:value-of select="substring-before($tokens[42], 'x')"/></height>
                                            <width><xsl:value-of select="substring-after($tokens[42], 'x')"/></width>
                                        </dimensions></xsl:if></p>
                                    </xsl:element>
                                    <xsl:if test="$tokens[41] != ''">
                                        <xsl:if test="$tokens[41] != $tokens[39]">
                                            <xsl:variable name="lines-zones" select="tokenize($tokens[41], '§')"/>
                                            <xsl:variable name="inscribed-zones" select="tokenize($tokens[42], '\$')"/>
                                            <xsl:for-each select="$lines-zones">
                                                <xsl:element name="layout">
                                                    <p>Zone <xsl:value-of select="substring-before(., ':')"/> contains <xsl:value-of select="substring-after(., ':')"/> lines. <xsl:if test="substring-before(., ':') = substring-before($inscribed-zones, ':')"><dimensions type="inscribed" unit="cm">
                                                        <height><xsl:value-of select="substring-before(substring-after($inscribed-zones, ':'), 'x')"/></height>
                                                        <width><xsl:value-of select="substring-after(substring-after($inscribed-zones, ':'), 'x')"/></width>
                                                    </dimensions></xsl:if></p>
                                                </xsl:element>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:if>
                                </layoutDesc>
                            </xsl:element>
                            <!-- je dois importer le HandDesc du fichier pour 27, 28, 30, 31, 33, 34, 36 et 37-->
                            <scriptDesc>
                                <p><xsl:value-of select="$tokens[38]"/>. <xsl:if test="$tokens[43] != ''"><dimensions type="askara" unit="cm">
                                    <height><xsl:value-of select="$tokens[43]"/></height>
                                    <xsl:if test="$tokens[44] != ''"><width><xsl:value-of select="$tokens[44]"/></width></xsl:if>
                                </dimensions></xsl:if></p>
                            </scriptDesc>
                        </physDesc>
                        <history>
                            <origin>
                                <p>Written in <xsl:element name="origDate"><xsl:if test="$tokens[47] != ''"><xsl:attribute name="cert"><xsl:value-of select="$tokens[47]"/></xsl:attribute></xsl:if><xsl:if test="$tokens[48] != ''"><xsl:attribute name="evidence"><xsl:value-of select="$tokens[48]"/></xsl:attribute></xsl:if><xsl:choose>
                                    <xsl:when test="$tokens[46] != ''"><xsl:attribute name="notBefore"><xsl:value-of select="substring-before($tokens[46], '-')"/></xsl:attribute> <xsl:attribute name="notAfter"><xsl:value-of select="substring-after($tokens[46], '-')"/></xsl:attribute><xsl:value-of select="$tokens[46]"/></xsl:when>
                                    <xsl:when test="$tokens[45] != ''">
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[45]"/></xsl:attribute>
                                        <xsl:value-of select="$tokens[45]"/>
                                    </xsl:when>
                                </xsl:choose></xsl:element>.
                                </p>
                            </origin>
                        </history>
                        <xsl:if test="$tokens[58] != '' or $tokens[59] != ''">
                            <additional>
                                <surrogates>
                                    <xsl:variable name="estampes" select="tokenize($tokens[58], '\$')"/>
                                    <xsl:variable name="photos" select="tokenize($tokens[59], '\$')"/>
                                    <xsl:for-each select="$estampes">
                                        <bibl>
                                            <xsl:element name="ptr">
                                                <xsl:attribute name="target">
                                                    <xsl:text>sur:</xsl:text><xsl:apply-templates select="."/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </bibl>
                                    </xsl:for-each>
                                    <xsl:for-each select="$photos">
                                        <bibl>
                                            <xsl:element name="ptr">
                                                <xsl:attribute name="target">
                                                    <xsl:text>dig:</xsl:text><xsl:apply-templates select="."/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </bibl>
                                    </xsl:for-each>
                                </surrogates>
                            </additional>
                        </xsl:if>
                    </msDesc>
                </sourceDesc>
                <profileDesc>
                    <xsl:if test="$tokens[54] != ''">
                        <textClass>
                            <keywords>
                                <xsl:variable name="keywords" as="xs:string*" select="tokenize($tokens[54], '\$')"/>
                                <xsl:for-each select="$keywords">
                                    <term><xsl:apply-templates select="."/></term>
                                </xsl:for-each>
                            </keywords>
                        </textClass>
                    </xsl:if>
                </profileDesc>
            </line>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/" name="xsl:initial-template">
    <xsl:for-each select="$lines/line">
            <File>
                <xsl:copy-of select="$lines/line"/>
            </File>
        </xsl:for-each>
    </xsl:template>
   
    <xsl:template name="language-tpl">
        <xsl:param name="language"/>
        <xsl:if test="$language !=''">
            <xsl:choose>
                <xsl:when test="$language = 'Arabic'">
                    <xsl:text>ara</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Balinese')">
                    <xsl:text>ban</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Batak')">
                    <xsl:text>btk</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Modern Burmese'">
                    <xsl:text>mya</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Burmese'">
                    <xsl:text>obr</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Modern Cham'">
                    <xsl:text>cjm/cja</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Cham'">
                <xsl:text>ocm</xsl:text>
            </xsl:when>
                <xsl:when test="$language = 'Indonesian'">
                    <xsl:text>ind</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Kannada')">
                    <xsl:text>kan</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Middle Khmer'">
                    <xsl:text>xhm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Modern Khmer'">
                    <xsl:text>khm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Khmer'">
                    <xsl:text>okz</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Middle Malay'">
                    <xsl:text>zlm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Malay'">
                    <xsl:text>omy</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Mon'">
                    <xsl:text>omx</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Pali'">
                    <xsl:text>pli</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Prakrit'">
                    <xsl:text>pra</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Pyu'">
                    <xsl:text>pyx</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Sanskrit'">
                    <xsl:text>san</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Sasak'">
                    <xsl:text>sas</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Sundanese'">
                    <xsl:text>osn</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Tagalog')">
                    <xsl:text>tgl</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Tamil')">
                    <xsl:text>tam</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Telugu')">
                    <xsl:text>tel</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Vietnamese')">
                    <xsl:text>vie</xsl:text>
                </xsl:when>
        </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

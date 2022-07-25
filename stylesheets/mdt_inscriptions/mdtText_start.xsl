<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    expand-text="yes"
    xmlns:mf="http://example.com/mf"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:param name="data" as="xs:string" select="unparsed-text('.')"/>
    
   <!-- <xsl:param name="header-ids" as="xs:string*"
        select="'01', '02', '03', '10', '48', '49', '50'"/>
    
    <xsl:param name="header-names" as="xs:string*"
        select="'FileHeader ', 'GroupHeader', 'AccountHeader', 'Details', 'AccountTrailer', 'GroupTrailer', 'FileTrailer'"/>-->
    
    <xsl:variable name="lines">
        <xsl:for-each select="tokenize($data, '\r?\n')">
            <line>
                <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
                <msIdentifier>
                    <repository>DHARMAbase</repository>
                    <idno>{$tokens[15]}</idno>
                    <xsl:if test="$tokens[17]">
                        <altIdentifier>
                            <idno>{$tokens[17]}</idno>
                        </altIdentifier>
                    </xsl:if>
                    <xsl:if test="$tokens[18]">
                        <altIdentifier>
                            <idno>{$tokens[18]}</idno>
                        </altIdentifier>
                    </xsl:if>
                    <xsl:if test="$tokens[19]">
                        <altIdentifier>
                            <idno>{$tokens[19]}</idno>
                        </altIdentifier>
                    </xsl:if>
                </msIdentifier>
                <msContents>
                    <xsl:element name="msItem">
                        <xsl:if test="$tokens[22]">
                            <xsl:attribute name="class">
                                <xsl:text>#</xsl:text>{$tokens[22]}
                                <xsl:if test="$tokens[23]">
                                    <xsl:text> #</xsl:text>{$tokens[23]}
                                </xsl:if>
                                <xsl:if test="$tokens[24]">
                                    <xsl:text> #</xsl:text>{$tokens[24]}
                                </xsl:if>
                                <xsl:if test="$tokens[25]">
                                    <xsl:text> #</xsl:text>{$tokens[25]}
                                </xsl:if>
                        </xsl:attribute>
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
                    </xsl:element>
                </msContents>
                <physDesc>
                    <xsl:element name="objectDesc">
                        <xsl:attribute name="corresp">{$tokens[21]}</xsl:attribute>
                        <supportDesc>
                            <p>{$tokens[20]}</p>
                        </supportDesc>
                        <layoutDesc>
                            <xsl:element name="layout">
                                <xsl:attribute name="writtenLines">{$tokens[39]} <xsl:if test="$tokens[39] != $tokens[40]">{$tokens[40]}</xsl:if></xsl:attribute>
                                <p>{$tokens[39]} lines are observed/preserved on the artifact. <xsl:if test="not($tokens[39] = $tokens[40])">{$tokens[40]} are known or estimated for this text.</xsl:if> <xsl:if test="not(contains($tokens[42], '$')) and $tokens[42] != ''"><dimensions type="inscribed" unit="cm">
                                    <height><xsl:value-of select="substring-before($tokens[42], 'x')"/></height>
                                    <width><xsl:value-of select="substring-after($tokens[42], 'x')"/></width>
                                </dimensions></xsl:if></p>
                            </xsl:element>
                            <xsl:if test="$tokens[41] != ''">
                                <xsl:if test="$tokens[41] != $tokens[39]">
                                    <xsl:variable name="lines-zones" select="tokenize($tokens[41], '§')"/>
                                    <xsl:variable name="inscribed-zones" select="tokenize($tokens[42], '$')"/>
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
                        <p>{$tokens[38]}. <xsl:if test="$tokens[43] != ''"><dimensions type="askara" unit="cm">
                            <height>{$tokens[43]}</height>
                            <xsl:if test="$tokens[44] != ''"><width>{$tokens[44]}</width></xsl:if>
                        </dimensions></xsl:if></p>
                    </scriptDesc>
                </physDesc>

            </line>
        </xsl:for-each>
    </xsl:variable>
    
    <!--<xsl:mode on-no-match="shallow-copy"/>-->
    
    <xsl:output method="xml" indent="yes"/>
    
  <!--  <xsl:template match="/" name="xsl:initial-template">
        <xsl:for-each-group select="$lines/line" group-starting-with="line[id = '01']">
            <File>
                <xsl:apply-templates select="."/>
                <xsl:for-each-group select="current-group() except ." group-ending-with="line[id = '50']">
                    <xsl:for-each-group select="current-group()[position() lt last()]" group-starting-with="line[id = '02']">
                        <GroupRecord>
                            <xsl:apply-templates select="."/>
                            <xsl:for-each-group select="current-group() except ." group-ending-with="line[id = '49']">
                                <xsl:for-each-group select="current-group()[position() lt last()]" group-starting-with="line[id = '03']">
                                    <AccountRecord>
                                        <xsl:apply-templates select="."/>
                                        <AccountDetails>
                                            <xsl:apply-templates select="(current-group() except .)[id != '48']"/>
                                        </AccountDetails>
                                        <xsl:apply-templates select="current-group()[id = '48']"/>
                                    </AccountRecord>
                                </xsl:for-each-group>
                                <xsl:apply-templates select="current-group()[last()]"/>
                            </xsl:for-each-group>
                        </GroupRecord>
                    </xsl:for-each-group>
                    <xsl:apply-templates select="current-group()[last()]"/>
                </xsl:for-each-group>
            </File>
        </xsl:for-each-group>
    </xsl:template>-->
    
    <xsl:template match="line">
        <xsl:result-document method="xml" href="testmdt_{./msIdentifier/idno}.xml">
                <xsl:copy-of select="." />
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="language-tpl">
        <xsl:param name="language"/>
        <xsl:if test="$language !=''">
            <xsl:choose>
                <xsl:when test="$language = 'Old Cham'">
                <xsl:text>ocm</xsl:text>
            </xsl:when>
        </xsl:choose>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>

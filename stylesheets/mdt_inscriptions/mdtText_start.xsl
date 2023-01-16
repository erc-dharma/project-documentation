<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/" version="3.0"
    exclude-result-prefixes="tei xi fn functx saxon">

    <!-- Written by Axelle Janiak for DHARMA, starting July 2022 -->
    <!-- code mise à jour avec le tpl janvier 2023 -->
    <!-- This file retrieve the CSV from the github API since we want to run several at the same time. So the github action runs differently. We launch this xslt in java command line rather than from an ant file as usual -->
    <!-- a cleaning for COMMA as been applied in a second step to avoid issue a looping and hasn't been linked to the 3rd step since we use this file gathering all the data to generate more easily some temporary display -->
    <!-- 3rd step splitting to allow temporary display of each entry. A code has been added at the end of each filename since several beared the same ids. When files are clean enough, it should be deleted -->
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

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

    <xsl:output method="xml" indent="yes"/>

        <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/mdt-texts/contents/csv')"/>
        </xsl:variable>
        <xsl:variable name="json-xml" select="json-to-xml($api-url)"/>
        <xsl:variable name="data">
            <xsl:for-each select="$json-xml/node()//*[@key = 'download_url']">
                <xsl:value-of select="unparsed-text(.)"/>
            </xsl:for-each>
        </xsl:variable>

    <xsl:template match="/" name="xsl:initial-template">
           <!-- <xsl:variable name="data" select="unparsed-text('https://raw.githubusercontent.com/erc-dharma/mdt-texts/main/csv/DHARMA_mdt_Somavamsin.csv')"/>-->

        <xsl:variable name="lines">
                <xsl:for-each select="tokenize($data, '\r?\n')">
                    <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
                    <xsl:choose>
                        <xsl:when test="$tokens[1] = '0'"/>
                        <xsl:when test="$tokens[3] = ''"/>
                    <xsl:otherwise>
                        <line>
                            <fileDesc>
                                <titleStmt>
                                    <title>Metadata elements for <xsl:value-of select="$tokens[3]"/></title>
                                </titleStmt>
                                <editionStmt>
                                    <p>Metadata originated from <xsl:value-of select="$tokens[4]"/></p>
                                </editionStmt>
                                <publicationStmt>
                                    <authority>DHARMA</authority>
                                    <pubPlace>Paris</pubPlace>
                                    <idno type="filename">DHARMA_mdt_<xsl:value-of select="$tokens[3]"/></idno>
                                    <availability>
                                        <licence target="https://creativecommons.org/licenses/by/4.0/">
                                            <p>This work is licensed under the Creative Commons Attribution 4.0 Unported
                                                Licence. To view a copy of the licence, visit
                                                https://creativecommons.org/licenses/by/4.0/ or send a letter to
                                                Creative Commons, 444 Castro Street, Suite 900, Mountain View,
                                                California, 94041, USA.</p>
                                            <p>Copyright (c) 2019-2025 by DHARMA.</p>
                                        </licence>
                                    </availability>
                                    <date from="2019" to="2025">2019-2025</date>
                                </publicationStmt>
                            <sourceDesc>
                                <msDesc>
                                    <msIdentifier>
                                        <repository>DHARMAbase</repository>
                                        <!-- colonne N : id -->
                                        <idno><xsl:value-of select="$tokens[14]"/></idno>
                                        <!-- colonnes P : alt id -->
                                        <xsl:if test="$tokens[16]">
                                            <altIdentifier>
                                                <idno><xsl:value-of select="$tokens[16]"/></idno>
                                            </altIdentifier>
                                        </xsl:if>
                                    </msIdentifier>
                                    <msContents>
                                        <xsl:element name="msItem">
                                            <!-- colonne W = text type 1-->
                                            <xsl:if test="$tokens[23]">
                                                <xsl:attribute name="class">
                                                    <xsl:text>#</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[23], ' - ')"/>
                                                    <!-- colonne X = text type 2-->
                                                    <xsl:if test="$tokens[24]">
                                                        <xsl:text> #</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[24], ' - ')"/>
                                                    </xsl:if>
                                                    <!-- colonne Y = text type 3-->
                                                    <xsl:if test="$tokens[25]">
                                                        <xsl:text> #</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[25], ' - ')"/>
                                                    </xsl:if>
                                                    <!-- colonne Z = text type 4-->
                                                    <xsl:if test="$tokens[26]">
                                                        <xsl:text> #</xsl:text><xsl:value-of select="functx:substring-after-last($tokens[26], ' - ')"/>
                                                    </xsl:if>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <!-- colonne O : description-->
                                            <xsl:if test="$tokens[15]">
                                                <title type="main"><xsl:value-of select="replace(replace($tokens[15], '&quot;', ''), ';', ',')"/></title>
                                            </xsl:if>
                                            <!-- colonne Q : alt description-->
                                            <xsl:if test="$tokens[17]">
                                                <title type="alt"><xsl:value-of select="$tokens[17]"/></title>
                                             </xsl:if>
                                            <!-- colonne R : alt description-->
                                            <xsl:if test="$tokens[18]">
                                                <title type="alt"><xsl:value-of select="$tokens[18]"/></title>
                                            </xsl:if>
                                            <xsl:element name="textLang">
                                                <xsl:attribute name="mainLang">
                                                    <!-- colonne AA = lang 1 -->
                                                    <xsl:call-template name="language-tpl">
                                                        <xsl:with-param name="language" select="$tokens[27]"/>
                                                    </xsl:call-template>
                                                </xsl:attribute>
                                                <!-- colonne AD = lang 2 -->
                                                <xsl:if test="$tokens[30] != ''">
                                                    <xsl:attribute name="otherLangs">
                                                        <xsl:call-template name="language-tpl">
                                                            <xsl:with-param name="language" select="$tokens[30]"/>
                                                        </xsl:call-template>
                                                        <!-- colonne AG = lang 3 -->
                                                        <xsl:if test="$tokens[33] != ''">
                                                            <xsl:attribute name="otherLangs">
                                                                <xsl:text> </xsl:text>
                                                                <xsl:call-template name="language-tpl">
                                                                    <xsl:with-param name="language" select="$tokens[33]"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                        </xsl:if>
                                                        <!-- colonne AJ = lang 4 -->
                                                        <xsl:if test="$tokens[36] != ''">
                                                            <xsl:attribute name="otherLangs">
                                                                <xsl:text> </xsl:text>
                                                                <xsl:call-template name="language-tpl">
                                                                    <xsl:with-param name="language" select="$tokens[36]"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                        </xsl:if>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <!-- colonne AA, AB, AC = lang 1 -->
                                                <xsl:if test="$tokens[27]">
                                                    <xsl:element name="p">Predominantly in <xsl:value-of select="$tokens[27]"/>, script <xsl:call-template name="script-class"><xsl:with-param name="classification" select="$tokens[28]"></xsl:with-param></xsl:call-template> and <xsl:call-template name="script-maturity"><xsl:with-param name="maturity" select="$tokens[29]"></xsl:with-param></xsl:call-template></xsl:element>
                                                </xsl:if>
                                                <!-- colonne AD, AE, AF = lang 2 -->
                                                <xsl:if test="$tokens[30] != ''">
                                                    <xsl:element name="p">Predominantly in <xsl:value-of select="$tokens[30]"/>, script <xsl:call-template name="script-class"><xsl:with-param name="classification" select="$tokens[31]"></xsl:with-param></xsl:call-template> and <xsl:call-template name="script-maturity"><xsl:with-param name="maturity" select="$tokens[32]"></xsl:with-param></xsl:call-template></xsl:element>
                                                </xsl:if>
                                                <!-- colonne AG, AH, AI = lang 3 -->
                                                <xsl:if test="$tokens[33] != ''">
                                                    <xsl:element name="p">Predominantly in <xsl:value-of select="$tokens[33]"/>, script <xsl:call-template name="script-class"><xsl:with-param name="classification" select="$tokens[34]"></xsl:with-param></xsl:call-template> and <xsl:call-template name="script-maturity"><xsl:with-param name="maturity" select="$tokens[35]"></xsl:with-param></xsl:call-template></xsl:element>
                                                </xsl:if>
                                                <!-- colonne AJ, AK, AL = lang 4 -->
                                                <xsl:if test="$tokens[36] != ''">
                                                    <xsl:element name="p">Predominantly in <xsl:value-of select="$tokens[36]"/>, script <xsl:call-template name="script-class"><xsl:with-param name="classification" select="$tokens[37]"></xsl:with-param></xsl:call-template> and <xsl:call-template name="script-maturity"><xsl:with-param name="maturity" select="$tokens[38]"></xsl:with-param></xsl:call-template></xsl:element>
                                                </xsl:if>
                                            </xsl:element>
                                            <!-- filiation: AY (51) id , AZ (52) type & BA(53) date  -->
                                            <xsl:if test="$tokens[51] != ''">
                                                <xsl:element name="filiation">
                                                    <xsl:if test="$tokens[52]">
                                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[52]"/></xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:element name="ref">
                                                        <xsl:attribute name="href">#<xsl:value-of select="$tokens[51]"/></xsl:attribute>
                                                        Inscription <xsl:value-of select="$tokens[51]"/> <xsl:value-of select="$tokens[52]"/> in <xsl:value-of select="$tokens[53]"/>.</xsl:element>
                                                </xsl:element>
                                            </xsl:if>
                                            <!-- colonne BB = sources (54) -->
                                            <xsl:if test="$tokens[54] != ''">
                                                <listBibl type="primary">
                                                    <xsl:variable name="sources" as="xs:string*" select="tokenize($tokens[54], '\$')"/>
                                                    <xsl:for-each select="$sources">
                                                        <bibl><xsl:element name="ptr">
                                                            <xsl:attribute name="target">
                                                                <xsl:text>bib:</xsl:text><xsl:apply-templates select="substring-before(., ':')"/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                            <citedRange><xsl:value-of select="substring-after(., ':')"/></citedRange></bibl>
                                                    </xsl:for-each>
                                                </listBibl>
                                            </xsl:if>
                                            <!-- colonne BC = litterature secondaire (55) -->
                                            <xsl:if test="$tokens[55] != ''">
                                                <listBibl type="secondary">
                                                    <xsl:variable name="biblio" as="xs:string*" select="tokenize($tokens[55], '\$')"/>
                                                    <xsl:for-each select="$biblio">
                                                        <bibl><xsl:element name="ptr">
                                                            <xsl:attribute name="target">
                                                                <xsl:text>bib:</xsl:text><xsl:apply-templates select="substring-before(., ':')"/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                            <citedRange><xsl:value-of select="substring-after(., ':')"/></citedRange></bibl>
                                                    </xsl:for-each>
                                                </listBibl>
                                            </xsl:if>
                                        </xsl:element>
                                    </msContents>
                                    <physDesc>
                                        <xsl:element name="objectDesc">
                                            <xsl:if test="$tokens[20] !='' or $tokens[21] !='' or $tokens[22] !=''"> 
                                                   <xsl:attribute name="corresp">
                                                    <!-- colonne T: id de l'artefact - séparation avec $ -->
                                                    <xsl:if test="$tokens[20] !=''">
                                                <xsl:variable name="id-artefacts" select="tokenize($tokens[20], '§')"/>
                                                <xsl:for-each select="$id-artefacts">
                                                    <xsl:text>#</xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
                                                </xsl:for-each>
                                                    </xsl:if>
                                                    <!--  colonne U: id conglo artefact  - séparation avec $ ?-->
                                                    <xsl:if test="$tokens[21] !=''">
                                                        <xsl:variable name="id-congloart" select="tokenize($tokens[21], '§')"/>
                                                        <xsl:for-each select="$id-congloart">
                                                            <xsl:text>#</xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                    <!--  colonne V: id monumnet   - séparation avec $ ?-->
                                                    <xsl:if test="$tokens[22] !=''">
                                                        <xsl:variable name="id-monu" select="tokenize($tokens[22], '§')"/>
                                                        <xsl:for-each select="$id-monu">
                                                            <xsl:text>#</xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                </xsl:attribute>
                                               </xsl:if>
                                            <supportDesc>
                                                <!-- colonne S: localisation sur l'artefact -->
                                                <p><xsl:value-of select="$tokens[19]"/></p>
                                            </supportDesc>
                                                <layoutDesc>
                                                    <!-- colonne AN: lines observed (40) and colonne AO: lines estimated (41)-->
                                                    <!-- colonne AP: lines per zone (42) colonne AQ: dimensions zones text (43) -->
                                                    <xsl:if test="$tokens[41] != '' or $tokens[40] != ''">
                                                <xsl:element name="layout">
                                                    <xsl:attribute name="writtenLines"><xsl:value-of select="$tokens[40]"/> <xsl:if test="$tokens[40] != $tokens[41]"><xsl:text>-</xsl:text><xsl:value-of select="$tokens[41]"/></xsl:if></xsl:attribute>
                                                    <p><xsl:value-of select="$tokens[40]"/> lines are observed/preserved on the artifact. <xsl:if test="not($tokens[40] = $tokens[41])"><xsl:value-of select="$tokens[41]"/> are known or estimated for this text.</xsl:if> <xsl:if test="not(contains($tokens[43], '$')) and $tokens[43] != ''"><dimensions type="inscribed" unit="cm">
                                                        <height><xsl:value-of select="substring-before($tokens[43], 'x')"/></height>
                                                        <width><xsl:value-of select="substring-after($tokens[43], 'x')"/></width>
                                                    </dimensions></xsl:if></p>
                                                </xsl:element>
                                                    </xsl:if>
                                                <xsl:if test="$tokens[42] != ''">
                                                    <xsl:if test="$tokens[42] != $tokens[40]">
                                                        <xsl:variable name="lines-zones" select="tokenize($tokens[42], '§')"/>
                                                        <xsl:for-each select="$lines-zones">
                                                            <xsl:element name="layout">
                                                                <xsl:attribute name="writtenLines"><xsl:value-of select="substring-after(., ':')"/></xsl:attribute>
                                                                <p>Zone <xsl:value-of select="substring-before(., ':')"/> has <xsl:value-of select="substring-after(., ':')"/> lines.</p></xsl:element></xsl:for-each>


                                                        <xsl:variable name="inscribed-zones" select="tokenize($tokens[43], '\$')"/>
                                                        <xsl:for-each select="$inscribed-zones">
                                                            <xsl:element name="layout">
                                                                <p><xsl:value-of select="substring-before(., ':')"/> is inscribed on <xsl:value-of select="substring-after(normalize-space(.), ':')"/> cm.</p></xsl:element></xsl:for-each>
                                                                    <!--Zone <xsl:value-of select="substring-before($lines-zones/., ':')"/> contains <xsl:value-of select="substring-after($lines-zones, ':')"/> lines. <xsl:if test="substring-before($lines-zones, ':') = substring-before($inscribed-zones, ':')"><dimensions type="inscribed" unit="cm">
                                                                    <height><xsl:value-of select="substring-before(substring-after($inscribed-zones[1], ':'), 'x')"/></height>
                                                                    <width><xsl:value-of select="substring-after(substring-after($inscribed-zones[2], ':'), 'x')"/></width>
                                                                </dimensions></xsl:if>-->
                                                    </xsl:if>
                                                </xsl:if>
                                            </layoutDesc>
                                        </xsl:element>
                                        <scriptDesc>
                                            <!-- colonne AM: lettering technique (39) -->
                                            <!-- colonne AR: height glyph (44) and colonne AS: width glyph (45)  -->
                                            <p><xsl:if test="$tokens[39] != ''"><xsl:value-of select="$tokens[39]"/>.</xsl:if> <xsl:if test="$tokens[44] != ''"><dimensions type="askara" unit="cm">
                                                <height><xsl:value-of select="$tokens[44]"/></height>
                                                <xsl:if test="$tokens[45] != ''"><width><xsl:value-of select="$tokens[45]"/></width></xsl:if>
                                            </dimensions></xsl:if></p>
                                        </scriptDesc>
                                    </physDesc>
                                    <history>
                                        <!-- colonne AT : date ce (46) -->
                                        <!-- colonne AU : date range ce (47) -->
                                        <!-- colonne AV : date certainty (48) -->
                                        <!-- colonne AW : date precision (49) -->
                                        <!-- colonne AX : date evidence (50) -->
                                        <xsl:if test="$tokens[47] != '' or $tokens[46] != ''"><origin>
                                            <p>Written in <xsl:element name="origDate"><xsl:if test="$tokens[48] != ''"><xsl:attribute name="cert"><xsl:value-of select="$tokens[48]"/></xsl:attribute></xsl:if><xsl:if test="$tokens[49] != ''"><xsl:attribute name="precision"><xsl:value-of select="$tokens[49]"/></xsl:attribute></xsl:if><xsl:if test="$tokens[50] != ''"><xsl:attribute name="evidence"><xsl:value-of select="$tokens[50]"/></xsl:attribute></xsl:if><xsl:choose>
                                                <xsl:when test="$tokens[47] != ''"><xsl:attribute name="notBefore"><xsl:value-of select="substring-before($tokens[47], '-')"/></xsl:attribute> <xsl:attribute name="notAfter"><xsl:value-of select="substring-after($tokens[47], '-')"/></xsl:attribute><xsl:value-of select="$tokens[47]"/></xsl:when>
                                                <xsl:when test="$tokens[46] != ''">
                                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[46]"/></xsl:attribute>
                                                    <xsl:value-of select="$tokens[46]"/>
                                                </xsl:when>
                                            </xsl:choose></xsl:element>.
                                            </p>
                                        </origin></xsl:if>
                                    </history>
                                    <xsl:if test="$tokens[57] != '' or $tokens[58] != '' or $tokens[59] != ''">
                                        <additional>
                                            <adminInfo>
                                                <recordHist>
                                                    <!-- colonne BE= remark (57) -->
                                                    <xsl:value-of select="$tokens[57]"/>
                                                </recordHist>
                                                <availability>
                                                    <!-- colonne BF= DHARMA (58) -->
                                                    <p><xsl:value-of select="$tokens[58]"/></p>
                                                    <!-- colonne BG= CC_BY (59) -->
                                                    <licence><xsl:value-of select="$tokens[59]"/></licence>
                                                </availability>
                                            </adminInfo>
                                            <surrogates>
                                                <!-- Colonne BH surrogates (60) -->
                                                <!-- Colonne BI photos (61) -->
                                                <!-- Colonne BJ repositories (62) -->
                                                <xsl:variable name="estampes" select="tokenize($tokens[60], '\$')"/>
                                                <xsl:variable name="photos" select="tokenize($tokens[61], '\$')"/>
                                                <xsl:variable name="repos" select="tokenize($tokens[62], '\$')"/>
                                                <xsl:for-each select="$estampes">
                                                    <bibl>
                                                        <xsl:element name="ptr">
                                                            <xsl:attribute name="target">
                                                                <xsl:text>sur:</xsl:text>
                                                                <xsl:value-of select="."/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </bibl>
                                                </xsl:for-each>
                                                <xsl:for-each select="$photos">
                                                    <bibl>
                                                        <xsl:element name="ptr">
                                                            <xsl:attribute name="target">
                                                                <xsl:text>dig:</xsl:text>
                                                                <xsl:value-of select="."/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </bibl>
                                                </xsl:for-each>
                                                <xsl:for-each select="$repos">
                                                    <!-- aucune iddée de ce à quoi cela peut bien correspondre donc pour le moment - juste valeur vide -->
                                                    <bibl>
                                                        <xsl:element name="ptr">
                                                            <xsl:attribute name="target">
                                                                <xsl:value-of select="."/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </bibl>
                                                </xsl:for-each>
                                            </surrogates>
                                        </additional>
                                    </xsl:if>
                                </msDesc>
                            </sourceDesc>
                            </fileDesc>
                            <profileDesc>
                                <!-- colonne BD = keywords (56) -->
                                <xsl:if test="$tokens[56] != ''">
                                    <textClass>
                                        <keywords>
                                            <xsl:variable name="keywords" as="xs:string*" select="tokenize($tokens[56], '\$')"/>
                                            <xsl:for-each select="$keywords">
                                                <term><xsl:apply-templates select="."/></term>
                                            </xsl:for-each>
                                        </keywords>
                                    </textClass>
                                </xsl:if>
                            </profileDesc>
                            <revisionDesc>
                                <xsl:element name="change">
                                    <!-- colonne I : reviewers (9) -->
                                    <xsl:variable name="reviewers" as="xs:string*" select="tokenize($tokens[9], '\$')"/>
                                    <!-- colonne J : date (10) -->
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[10]"/></xsl:attribute>
                                    <xsl:attribute name="who">
                                        <xsl:for-each select="$reviewers">part:<xsl:value-of select="."/> </xsl:for-each>
                                    </xsl:attribute>
                                    Reviews of medadata
                                </xsl:element>
                                <xsl:element name="change">
                                    <!-- colonne H : contributors (8) -->
                                    <xsl:variable name="contributors" as="xs:string*" select="tokenize($tokens[8], '\$')"/>
                                    <!--colonne G : date - pas très sûre (7) -->
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[7]"/></xsl:attribute>
                                    <xsl:attribute name="who">
                                        <xsl:for-each select="$contributors">part:<xsl:value-of select="."/> </xsl:for-each>
                                    </xsl:attribute>
                                    Contributions made in medadata
                                </xsl:element>
                                <xsl:element name="change">
                                    <!-- colonne F  : editor (6) -->
                                    <xsl:variable name="editors" as="xs:string*" select="tokenize($tokens[6], '\$')"/>
                                    <!-- colonne E  : date import (6) -->
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[5]"/></xsl:attribute>
                                    <xsl:attribute name="who">
                                        <xsl:for-each select="$editors">part:<xsl:value-of select="."/> </xsl:for-each>
                                    </xsl:attribute>
                                    import of medadata
                                </xsl:element>
                            </revisionDesc>
                        </line>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:for-each>

        </xsl:variable>

        <File>
            <xsl:copy-of select="$lines/line"/>
        </File>
            
    </xsl:template>
    
    <xsl:template name="language-tpl">
        <xsl:param name="language"/>
        <xsl:if test="$language !=''">
            <xsl:choose>
                <xsl:when test="$language = 'Arabic'">
                    <xsl:text>ara</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Batak')">
                    <xsl:text>btk</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Kannada')">
                    <xsl:text>kan</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Modern Cham'">
                    <xsl:text>cjm/cja</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Modern Khmer'">
                    <xsl:text>khm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Middle Javanese'">
                    <xsl:text>jav</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Balinese'">
                    <xsl:text>ban</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Burmese'">
                    <xsl:text>obr</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Cham'">
                    <xsl:text>ocm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Javanese'">
                    <xsl:text>kaw</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Khmer'">
                    <xsl:text>okz</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Malay'">
                    <xsl:text>omy</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Sundanese'">
                    <xsl:text>osn</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Tagalog')">
                    <xsl:text>tgl</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Pali'">
                    <xsl:text>pli</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Prakrit'">
                    <xsl:text>pra</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Sanskrit'">
                    <xsl:text>san</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Sasak'">
                    <xsl:text>sas</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Tamil')">
                    <xsl:text>tam</xsl:text>
                </xsl:when>
                <xsl:when test="contains($language, 'Telugu')">
                    <xsl:text>tel</xsl:text>
                </xsl:when>
                <!-- added in the code only -->
                <xsl:when test="contains($language, 'Vietnamese')">
                    <xsl:text>vie</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Indonesian'">
                    <xsl:text>ind</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Middle Khmer'">
                    <xsl:text>xhm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Middle Malay'">
                    <xsl:text>zlm</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Pyu'">
                    <xsl:text>pyx</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Old Mon'">
                    <xsl:text>omx</xsl:text>
                </xsl:when>
                <xsl:when test="$language = 'Modern Burmese'">
                    <xsl:text>mya</xsl:text>
                </xsl:when>
        </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="script-class">
        <xsl:param name="classification"/>
        <xsl:if test="$classification !=''">
            <xsl:choose>
                <xsl:when test="$classification ='brahmi_and_derivatives'">
                    <xsl:text>Brahmi and Derivatives</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - northern_class_brahmi'">
                    <xsl:text>Northern Class Brahmi</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - northern_class_brahmi - siddhamatrika'">
                    <xsl:text>Siddhamatrika</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - northern_class_brahmi - gaudi'">
                    <xsl:text>Gaudi</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - northern_class_brahmi - nagari'">
                    <xsl:text>Nagari</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southern_class_brahmi'">
                    <xsl:text>Southern Class Brahmi</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southern_class_brahmi - tamil_script'">
                    <xsl:text>Tamil Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southern_class_brahmi - grantha'">
                    <xsl:text>Grantha</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southern_class_brahmi - vatteluttu'">
                    <xsl:text>Vatteluttu</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi'">
                    <xsl:text>Southeast Asian Brahmi</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - khmer_script'">
                    <xsl:text>Khmer Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - cam_script'">
                    <xsl:text>Cam Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - mon-burmese_script'">
                    <xsl:text>Mon-Burnese Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - pyu_script'">
                    <xsl:text>Pyu Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - kawi_script'">
                    <xsl:text>Kawi Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - batak_script'">
                    <xsl:text>Batak Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - balinese_script'">
                    <xsl:text>Balinese Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - sundanese_script'">
                    <xsl:text>Sundanese Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='brahmi_and_derivatives - southeast_asian_brahmi - old_west_javanese_script'">
                    <xsl:text>Old West Javanese Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='kharosthi'">
                    <xsl:text>Kharosthi</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='arabic_script'">
                    <xsl:text>Arabic Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='arabic_script - jawi_script'">
                    <xsl:text>Jawi Script</xsl:text>
                </xsl:when>
                <xsl:when test="$classification ='chinese_script'">
                    <xsl:text>Chinese script</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="script-maturity">
        <xsl:param name="maturity"/>
        <xsl:if test="$maturity !=''">
        <xsl:choose>
            <xsl:when test="$maturity='early Brahmi'">
                <xsl:text>early Brahmi</xsl:text>
            </xsl:when>
            <xsl:when test="$maturity='middle Brahmi'">
                <xsl:text>middle Brahmi</xsl:text>
            </xsl:when>
            <xsl:when test="$maturity='late Brahmi'">
                <xsl:text>late Brahmi</xsl:text>
            </xsl:when>
            <xsl:when test="$maturity='regional Brahmi-derived script'">
                <xsl:text>regional Brahmi-derived script</xsl:text>
            </xsl:when>
            <xsl:when test="$maturity='vernacular Brahmi-derived script'">
                <xsl:text>vernacular Brahmi-derived script</xsl:text>
            </xsl:when>
        </xsl:choose>
            </xsl:if>    
    </xsl:template>

</xsl:stylesheet>

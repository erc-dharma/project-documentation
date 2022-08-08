<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/" name="xsl:initial-template">
        <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/mdt-authorities/contents/csv/monuments')"/>
        </xsl:variable>
        <xsl:variable name="json-xml" select="json-to-xml($api-url)"/>
        <xsl:variable name="data">
            <xsl:for-each select="$json-xml/node()//*[@key = 'download_url']">
                <xsl:value-of select="unparsed-text(.)"/>
            </xsl:for-each>
        </xsl:variable>
        
        <!--<xsl:param name="data" select="unparsed-text('https://raw.githubusercontent.com/erc-dharma/mdt-texts/main/csv/DHARMA_mdt_Somavamsin_v01.csv')"/>-->
        
        <xsl:variable name="lines">
            <xsl:for-each select="tokenize($data, '\r?\n')">
                <xsl:if test="position() > 6">
                    <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
                    <xsl:element name="object">
                        <xsl:attribute name="xml:id"><xsl:value-of select="$tokens[13]"/></xsl:attribute>
                        <xsl:attribute name="type"><xsl:value-of select="$tokens[17]"/><xsl:if test="$tokens[18] != ''"><xsl:text> </xsl:text><xsl:value-of select="$tokens[18]"/></xsl:if></xsl:attribute>
                        <resourceManagement>
                            <resourceID><xsl:value-of select="$tokens[2]"/></resourceID>
                            <metadataOrigin><xsl:value-of select="$tokens[3]"/></metadataOrigin>
                            <metadataEditor>
                                <xsl:element name="change">
                                    <xsl:variable name="editors" as="xs:string*" select="tokenize($tokens[5], '\$')"/>
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[4]"/></xsl:attribute>
                                    <xsl:attribute name="who">
                                        <xsl:for-each select="$editors">part:<xsl:value-of select="."/> </xsl:for-each>
                                    </xsl:attribute>
                                    import of medadata
                                </xsl:element>
                            </metadataEditor>
                            <metadataContribution>
                                <xsl:element name="change">
                                    <xsl:variable name="contributors" as="xs:string*" select="tokenize($tokens[7], '\$')"/>
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[6]"/></xsl:attribute>
                                    <xsl:attribute name="who">
                                        <xsl:for-each select="$contributors">part:<xsl:value-of select="."/> </xsl:for-each>
                                    </xsl:attribute>
                                    Contributions made in medadata
                                </xsl:element>
                            </metadataContribution>
                            <metadataReview>
                                <xsl:element name="change">
                                    <xsl:variable name="reviewers" as="xs:string*" select="tokenize($tokens[8], '\$')"/>
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[9]"/></xsl:attribute>
                                    <xsl:attribute name="who">
                                        <xsl:for-each select="$reviewers">part:<xsl:value-of select="."/> </xsl:for-each>
                                    </xsl:attribute>
                                    Reviews of medadata
                                </xsl:element>
                            </metadataReview>
                            <project><xsl:value-of select="$tokens[10]"/></project>
                            <corpus><xsl:value-of select="$tokens[11]"/></corpus>
                            <metadataRights><xsl:value-of select="$tokens[12]"/></metadataRights>
                        </resourceManagement>
                        <xsl:element name="objectIdentifier">
                            <xsl:element name="objectName">
                                <xsl:attribute name="xml:lang">
                                <xsl:call-template name="language-tpl">
                                    <xsl:with-param name="language" select="$tokens[15]"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="xml:id"><xsl:text>n1</xsl:text></xsl:attribute>
                            <xsl:value-of select="$tokens[14]"/>
                            </xsl:element>
                            <xsl:element name="objectName">
                                <xsl:attribute name="type"><xsl:text>normalized</xsl:text></xsl:attribute>
                                <xsl:attribute name="corresp"><xsl:text>#n1</xsl:text></xsl:attribute>
                                <xsl:value-of select="$tokens[16]"/>
                            </xsl:element>
                            <xsl:element name="idno"><xsl:value-of select="$tokens[36]"/></xsl:element>
                            <xsl:if test="$tokens[32] != ''">
                                <xsl:element name="placeName">
                                    <xsl:element name="settlement">
                                    <xsl:attribute name="ref"><xsl:value-of select="$tokens[33]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[32]"/>
                                </xsl:element>
                                    <xsl:if test="$tokens[34] != ''">
                                        <xsl:element name="geo">
                                            <xsl:value-of select="$tokens[34]"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$tokens[35]"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                        <xsl:element name="physDesc">
                            <xsl:element name="objectDesc">
                                <xsl:element name="supportDesc">
                                    <xsl:element name="support">
                                    <xsl:element name="material">
                                    <xsl:value-of select="$tokens[19]"/>
                                </xsl:element>
                                <xsl:if test="$tokens[20] != ''">
                                    <xsl:element name="material">
                                        <xsl:value-of select="$tokens[20]"/>
                                    </xsl:element>
                                </xsl:if>
                                    <xsl:if test="$tokens[22] != '' or $tokens[23] != '' or $tokens[24] != '' or $tokens[25] != '' or $tokens[26] != ''">
                                        <xsl:element name="dimensions">
                                            <xsl:if test="$tokens[22] != ''">
                                                <height><xsl:value-of select="$tokens[22]"/></height>
                                            </xsl:if>
                                            <xsl:if test="$tokens[23] != ''">
                                                <width><xsl:value-of select="$tokens[23]"/></width>
                                            </xsl:if>
                                            <xsl:if test="$tokens[24] != ''">
                                                <depth><xsl:value-of select="$tokens[24]"/></depth>
                                            </xsl:if>
                                            <xsl:if test="$tokens[25] != ''">
                                                <xsl:element name="dim">
                                                    <xsl:attribute name="type">diameter</xsl:attribute>
                                                    <xsl:value-of select="$tokens[25]"/>
                                                </xsl:element>
                                            </xsl:if>
                                            <xsl:if test="$tokens[26] != ''">
                                                <xsl:element name="dim">
                                                    <xsl:attribute name="type">circumference</xsl:attribute>
                                                    <xsl:value-of select="$tokens[26]"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                                    <xsl:element name="condition">
                                        <xsl:value-of select="$tokens[27]"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="decoDesc">
                                <xsl:element name="p">
                                    <xsl:value-of select="$tokens[21]"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="history">
                            <xsl:element name="origin">
                                <xsl:element name="origDate">
                                    <xsl:attribute name="notBefore"><xsl:value-of select="$tokens[28]"/></xsl:attribute>
                                    <xsl:attribute name="notAfter"><xsl:value-of select="$tokens[29]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[28]"/>
                                    <xsl:text>–</xsl:text>
                                    <xsl:value-of select="$tokens[29]"/>
                                </xsl:element>
                                <xsl:element name="p">
                                    <xsl:value-of select="$tokens[30]"/>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="ab">
                                <xsl:attribute name="type">remarks</xsl:attribute>
                                <xsl:value-of select="$tokens[31]"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="additional">
                            <adminInfo>
                                <availability>
                                    <xsl:if test="$tokens[37] != ''"><xsl:element name="p"><xsl:text>Governmental rights holder: </xsl:text><xsl:value-of select="$tokens[37]"/></xsl:element></xsl:if>
                                    <xsl:if test="$tokens[38] != ''"><xsl:element name="p"><xsl:text>Institution or private person right holder: </xsl:text><xsl:value-of select="$tokens[38]"/></xsl:element></xsl:if>
                                    <xsl:element name="licence">
                                        <xsl:element name="p">
                                            <xsl:value-of select="$tokens[39]"/>
                                        </xsl:element>
                                    </xsl:element>
                                </availability>
                            </adminInfo>
                            <xsl:element name="listBibl">
                                <xsl:variable name="references" select="tokenize($tokens[40], '\$')"/>
                                <xsl:for-each select="$references">
                                    <bibl>
                                        <xsl:element name="ptr">
                                            <xsl:attribute name="target">
                                                <xsl:text>bib:</xsl:text>
                                                <xsl:value-of select="."/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </bibl>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>  
        </xsl:variable>
        <File>  
            <listObject>
                <xsl:copy-of select="$lines/object"/>  
            </listObject>
        </File>
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
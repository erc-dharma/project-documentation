<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/" name="xsl:initial-template">
        <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/mdt-authorities/contents/csv/collections')"/>
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
                <xsl:if test="position() >= 7">
                    <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
                    <!-- 
                    <place subtype="institution" type="privateHouse">
                  <placeName xml:id="n1" xml:lang="en">Private Collection of Ato Hayle Bayyana</placeName>
                  <settlement ref="LOC3577Gondar"></settlement>
                  <location>
                     <geo>12.609389 37.468671</geo>
                  </location>
               </place>
               
                    -->
                    <xsl:element name="place">
                        <xsl:attribute name="xml:id"><xsl:value-of select="$tokens[13]"/></xsl:attribute>
                        <xsl:attribute name="type"><xsl:value-of select="$tokens[15]"/></xsl:attribute>
                        <xsl:element name="placeName">
                            <xsl:attribute name="xml:id"><xsl:text>n1</xsl:text></xsl:attribute>
                            <xsl:value-of select="$tokens[14]"/>                            
                        </xsl:element>
                        <xsl:element name="settlement">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="$tokens[20]"/>
                            </xsl:attribute>
                            <xsl:value-of select="$tokens[19]"/>
                        </xsl:element>
                        <!-- Je ne suis pas sûre de comprendre la différence de même que le contenu attendu dans les colonnes 16 à 18. -->
                        <xsl:element name="orgName">
                            <xsl:value-of select="$tokens[16]"/>
                        </xsl:element>
                        <xsl:element name="orgName">
                            <xsl:value-of select="$tokens[17]"/>
                        </xsl:element>
                        <xsl:element name="orgName">
                            <xsl:value-of select="$tokens[18]"/>
                        </xsl:element>
                        <note>
                            <xsl:element name="date">
                                <xsl:attribute name="type">foundation</xsl:attribute>
                                <xsl:attribute name="notBefore"><xsl:value-of select="$tokens[21]"/></xsl:attribute>
                                <xsl:value-of select="$tokens[21]"/>
                            </xsl:element>
                            <ab type="history">
                                <xsl:value-of select="$tokens[22]"/>
                            </ab>
                        </note>
                        <xsl:element name="listBibl">
                            <xsl:variable name="references" select="tokenize($tokens[24], '\$')"/>
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
                        <xsl:element name="note">
                            <xsl:element name="ab">
                                <xsl:attribute name="type">remark</xsl:attribute>
                                <xsl:value-of select="$tokens[23]"/>
                            </xsl:element> 
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>  
        </xsl:variable>
        <File>  
            <listPlace>
                <xsl:copy-of select="$lines/place"/>  
            </listPlace>
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
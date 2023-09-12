<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
    
    <xsl:template match="/" name="xsl:initial-template">
        <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/mdt-surrogates/contents/csv')"/>
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
            <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
            <xsl:choose>
                <xsl:when test="$tokens[1] = '0'"/>
                <xsl:when test="$tokens[3] = ''"/>
                <xsl:otherwise>
                <line>
                    <resourceManagement>
                        <resourceID><xsl:value-of select="$tokens[3]"/></resourceID>
                        <xsl:element name="metadataOrigin">
                            <xsl:variable name="biblio" as="xs:string*" select="tokenize($tokens[4], '\$')"/>
                            <xsl:if test="$tokens[5] != ''">
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[5]"/></xsl:attribute>
                            </xsl:if>
                            <xsl:for-each select="$biblio">
                                <xsl:choose>
                                    <xsl:when test="matches(., '\_\d\d')"> 
                                        <bibl><xsl:element name="ptr">
                                            <xsl:attribute name="target">
                                                <xsl:text>bib:</xsl:text><xsl:apply-templates select="."/>
                                            </xsl:attribute>
                                        </xsl:element>
                                        </bibl>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$tokens[4]"/>
                                    </xsl:otherwise>
                                </xsl:choose> 
                            </xsl:for-each>
                        </xsl:element>
                        <metadataEditor>
                            <xsl:element name="change">
                                <xsl:variable name="editors" as="xs:string*">
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[6], '$')">
                                            <xsl:value-of select="tokenize($tokens[6], '\$')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$tokens[6]"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[7]"/></xsl:attribute>
                                <xsl:attribute name="who">
                                    <xsl:for-each select="$editors">part:<xsl:value-of select="."/> </xsl:for-each>
                                </xsl:attribute>
                                edition of medadata
                            </xsl:element>
                        </metadataEditor>
                        <metadataContribution>
                            <xsl:element name="change">
                                <xsl:variable name="contributors" as="xs:string*">
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[8], '$')">
                                            <xsl:value-of select="tokenize($tokens[8], '\$')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$tokens[8]"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="who">
                                    <xsl:for-each select="$contributors">part:<xsl:value-of select="."/> </xsl:for-each>
                                </xsl:attribute>
                                Contributions made in medadata
                            </xsl:element>
                        </metadataContribution>
                        <metadataReview>
                            <xsl:element name="change">
                                <xsl:variable name="reviewers" as="xs:string*">
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[9], '$')">
                                            <xsl:value-of select="tokenize($tokens[9], '\$')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$tokens[9]"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[10]"/></xsl:attribute>
                                <xsl:attribute name="who">
                                    <xsl:for-each select="$reviewers">part:<xsl:value-of select="."/> </xsl:for-each>
                                </xsl:attribute>
                                Reviews of medadata
                            </xsl:element>
                        </metadataReview>
                        <project><xsl:value-of select="$tokens[11]"/></project>
                        <corpus><xsl:value-of select="$tokens[12]"/></corpus>
                        <metadataRights><xsl:value-of select="$tokens[13]"/></metadataRights>
                    </resourceManagement>
                    <surrogateDescription>
                        <surrogateID><xsl:value-of select="$tokens[14]"/></surrogateID>
                        <surrogateType><xsl:value-of select="$tokens[18]"/></surrogateType>
                        <surrogateCreators>
                            <xsl:variable name="creators" as="xs:string*">
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[19], '$')">
                                        <xsl:value-of select="tokenize($tokens[19], '\$')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$tokens[19]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:for-each select="$creators">
                            <surrogateCreator>
                                <xsl:value-of select="."/>
                            </surrogateCreator>
                        </xsl:for-each>
                        </surrogateCreators>
                        <surrogateCreationDate><xsl:value-of select="$tokens[20]"/></surrogateCreationDate>
                                <material>
                                    <xsl:value-of select="$tokens[21]"/>
                                </material>
                        <surrogateFormat>
                            <xsl:variable name="format" select="tokenize($tokens[22], 'x')"/>
                            <height unit="cm"><xsl:value-of select="$format[1]"/></height>
                            <width unit="cm"><xsl:value-of select="$format[2]"/></width>
                            <linesNumber><xsl:value-of select="$tokens[23]"/></linesNumber>
                            <partOfText><xsl:value-of select="$tokens[24]"/></partOfText>
                        </surrogateFormat>
                        <!--<estampageFormat>
                            <numberSheets></numberSheets>
                            <estampageTechnique value=""/>
                        </estampageFormat>-->
                        <surrogatePreservation>
                            <inventoryNumber><xsl:value-of select="$tokens[25]"/></inventoryNumber><!-- may be repeated -->
                            <surrogateLegends><p><xsl:value-of select="$tokens[26]"/></p></surrogateLegends>
                            <xsl:element name="surrogateCollection">
                                <xsl:attribute name="id"><xsl:value-of select="$tokens[28]"/></xsl:attribute>
                                <xsl:value-of select="$tokens[27]"/>
                            </xsl:element>
                                <preservationLocation><xsl:value-of select="$tokens[28]"/></preservationLocation>
                                <boxLegend><xsl:value-of select="$tokens[29]"/></boxLegend>
                        </surrogatePreservation>
                        <surrogateRights>
                            <rightHolder><xsl:value-of select="$tokens[30]"/></rightHolder>                           
                            <surrogateDistributionRights><xsl:value-of select="$tokens[31]"/></surrogateDistributionRights>
                        </surrogateRights>
                        <relatedEntities>
                            <!-- un peu sale mais ça marche -->
                            <xsl:if test="$tokens[15] !=''">
                                <xsl:element name="textID">
                                    <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[15], '$', ' ')"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$tokens[16] !=''">
                                <xsl:element name="artefactID">
                                    <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[16], '$', ' ')"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$tokens[17] !=''">
                                <xsl:element name="conArtID">
                                    <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[17], '$', ' ')"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$tokens[32] !=''">
                                <xsl:element name="imageID">
                                    <xsl:attribute name="idno">
                                        <xsl:variable name="images-id" select="tokenize($tokens[32], '\$')"/>
                                        <xsl:for-each select="$images-id">
                                            <xsl:value-of select="."/>
                                            <xsl:text> </xsl:text>
                                        </xsl:for-each>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$tokens[33] !=''">
                                <xsl:element name="repoID">
                                    <xsl:attribute name="idno">
                                        <xsl:variable name="repo-id" select="tokenize($tokens[33], '\$')"/>
                                        <xsl:for-each select="$repo-id">
                                            <xsl:value-of select="."/>
                                            <xsl:text> </xsl:text>
                                        </xsl:for-each>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </relatedEntities>
                    </surrogateDescription>
                </line>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>  
    </xsl:variable>
        <File>          
            <xsl:copy-of select="$lines/line"/>  
        </File>
    </xsl:template>  
</xsl:stylesheet>
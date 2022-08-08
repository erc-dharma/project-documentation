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
            <xsl:if test="position() >= 6">
                <line>
                    <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
                    <resourceManagement>
                        <resourceID><xsl:value-of select="$tokens[3]"/></resourceID>
                        <metadataOrigin><xsl:value-of select="$tokens[4]"/></metadataOrigin>
                        <metadataEditor>
                            <xsl:element name="change">
                                <xsl:variable name="editors" as="xs:string*" select="tokenize($tokens[6], '\$')"/>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[5]"/></xsl:attribute>
                                <xsl:attribute name="who">
                                    <xsl:for-each select="$editors">part:<xsl:value-of select="."/> </xsl:for-each>
                                </xsl:attribute>
                                import of medadata
                            </xsl:element>
                        </metadataEditor>
                        <metadataContribution>
                            <xsl:element name="change">
                                <xsl:variable name="contributors" as="xs:string*" select="tokenize($tokens[8], '\$')"/>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[7]"/></xsl:attribute>
                                <xsl:attribute name="who">
                                    <xsl:for-each select="$contributors">part:<xsl:value-of select="."/> </xsl:for-each>
                                </xsl:attribute>
                                Contributions made in medadata
                            </xsl:element>
                        </metadataContribution>
                        <metadataReview>
                            <xsl:element name="change">
                                <xsl:variable name="reviewers" as="xs:string*" select="tokenize($tokens[9], '\$')"/>
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
                            <xsl:variable name="creators" select="tokenize($tokens[19], '\$')"/>
                            <xsl:for-each select="$creators">
                            <surrogateCreator>
                                <xsl:value-of select="."/>
                            </surrogateCreator>
                        </xsl:for-each></surrogateCreators>
                        <surrogateCreationDate><xsl:value-of select="$tokens[20]"/></surrogateCreationDate>
                        <materials>
                            <xsl:variable name="materials" select="tokenize($tokens[21], '\$')"/>
                            <xsl:for-each select="$materials">
                                <material>
                                    <xsl:value-of select="."/>
                                </material>
                            </xsl:for-each>
                        </materials>
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
                            <condition><xsl:value-of select="$tokens[26]"/></condition><!-- may be repeated -->
                            <surrogateLegends><p><xsl:value-of select="$tokens[27]"/></p></surrogateLegends>
                            <surrogateCollection>
                                <collectionName><xsl:value-of select="$tokens[28]"/></collectionName>
                                <collectionID><xsl:value-of select="$tokens[29]"/></collectionID>
                            </surrogateCollection>
                            <surrogatePreservationPlace>
                                <preservationPlaceName><xsl:value-of select="$tokens[30]"/></preservationPlaceName>
                                <preservationPlaceID><xsl:value-of select="$tokens[31]"/></preservationPlaceID>
                                <preservationLocation><xsl:value-of select="$tokens[32]"/></preservationLocation>
                                <boxLegend><p><xsl:value-of select="$tokens[33]"/></p></boxLegend>
                            </surrogatePreservationPlace>
                        </surrogatePreservation>
                        <surrogateRights>
                            <governmentalHolder><xsl:value-of select="$tokens[34]"/></governmentalHolder>
                            <institutionalHolder><xsl:value-of select="$tokens[35]"/></institutionalHolder>
                            <surrogateDistributionRights><xsl:value-of select="$tokens[36]"/></surrogateDistributionRights>
                        </surrogateRights>
                        <relatedEntities>
                            <xsl:if test="$tokens[15] !=''">
                                <xsl:element name="textID">
                                    <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[15], '$', ' #')"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$tokens[16] !=''">
                                <xsl:element name="artefactID">
                                    <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[15], '$', ' #')"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$tokens[17] !=''">
                                <xsl:element name="conArtID">
                                    <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[17], '$', ' #')"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </relatedEntities>
                        <relatedMedia>
                            <xsl:element name="digiID">
                                <xsl:attribute name="idno"><xsl:value-of select="replace($tokens[37], '$', ' #')"/></xsl:attribute>
                            </xsl:element>
                        </relatedMedia>
                    </surrogateDescription>
                </line>
            </xsl:if>
        </xsl:for-each>  
    </xsl:variable>
        <File>          
            <xsl:copy-of select="$lines/line"/>  
        </File>
    </xsl:template>  
</xsl:stylesheet>
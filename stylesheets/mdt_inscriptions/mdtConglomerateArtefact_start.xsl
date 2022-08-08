<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/" name="xsl:initial-template">
        <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/mdt-artefacts/contents/csv/conglomerate-artefacts')"/>
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
                        <compositeArtefactDescription>
                            <compositeArtefactID><xsl:value-of select="$tokens[14]"/></compositeArtefactID>
                            <compositeArtefactDes><xsl:value-of select="$tokens[15]"/></compositeArtefactDes>
                            <alternative>
                                <xsl:if test="$tokens[16] != ''">
                                    <artefactDes><xsl:value-of select="$tokens[16]"/></artefactDes>
                                </xsl:if>
                                <xsl:if test="$tokens[17] != ''">
                                    <artefactDes><xsl:value-of select="$tokens[17]"/></artefactDes>
                                </xsl:if>
                            </alternative>
                            <material><xsl:value-of select="$tokens[23]"/></material>
                            <xsl:if test="$tokens[24] != ''">
                                <material>
                                    <xsl:value-of select="$tokens[24]"/>
                                </material>
                            </xsl:if>
                            <compositeArtefactType><xsl:value-of select="$tokens[21]"/></compositeArtefactType>
                            <xsl:if test="$tokens[22] != ''">
                                <compositeArtefactType><xsl:value-of select="$tokens[22]"/></compositeArtefactType>
                            </xsl:if>
                            <decoDesc>
                                <p><xsl:value-of select="$tokens[25]"/></p>
                            </decoDesc>
                            <compositeArtefactFormat>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[26], '$')">
                                        <xsl:variable name="heights" as="xs:string*" select="tokenize($tokens[26], '\$')"/>
                                        <xsl:element name="height">
                                            <xsl:attribute name="unit">cm</xsl:attribute>
                                            <xsl:attribute name="max"><xsl:value-of select="$heights[1]"/></xsl:attribute>
                                            <xsl:attribute name="min"><xsl:value-of select="$heights[2]"/></xsl:attribute>
                                            <xsl:value-of select="$heights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$heights[2]"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <height unit="cm"><xsl:value-of select="$tokens[26]"/></height>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[27], '$')">
                                        <xsl:variable name="widths" as="xs:string*" select="tokenize($tokens[27], '\$')"/>
                                        <xsl:element name="width">
                                            <xsl:attribute name="unit">cm</xsl:attribute>
                                            <xsl:attribute name="max"><xsl:value-of select="$widths[1]"/></xsl:attribute>
                                            <xsl:attribute name="min"><xsl:value-of select="$widths[2]"/></xsl:attribute>
                                            <xsl:value-of select="$widths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$widths[2]"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <width unit="cm"><xsl:value-of select="$tokens[27]"/></width>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[28], '$')">
                                        <xsl:variable name="depths" as="xs:string*" select="tokenize($tokens[28], '\$')"/>
                                        <xsl:element name="depth">
                                            <xsl:attribute name="unit">cm</xsl:attribute>
                                            <xsl:attribute name="max"><xsl:value-of select="$depths[1]"/></xsl:attribute>
                                            <xsl:attribute name="min"><xsl:value-of select="$depths[2]"/></xsl:attribute>
                                            <xsl:value-of select="$depths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$depths[2]"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <depth unit="cm"><xsl:value-of select="$tokens[28]"/></depth>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[29], '$')">
                                        <xsl:variable name="diameters" as="xs:string*" select="tokenize($tokens[29], '\$')"/>
                                        <xsl:element name="diameter">
                                            <xsl:attribute name="unit">cm</xsl:attribute>
                                            <xsl:attribute name="max"><xsl:value-of select="$diameters[1]"/></xsl:attribute>
                                            <xsl:attribute name="min"><xsl:value-of select="$diameters[2]"/></xsl:attribute>
                                            <xsl:value-of select="$diameters[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$diameters[2]"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <diameter unit="cm"><xsl:value-of select="$tokens[29]"/></diameter>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[30], '$')">
                                        <xsl:variable name="circumferences" as="xs:string*" select="tokenize($tokens[30], '\$')"/>
                                        <xsl:element name="circumference">
                                            <xsl:attribute name="unit">cm</xsl:attribute>
                                            <xsl:attribute name="max"><xsl:value-of select="$circumferences[1]"/></xsl:attribute>
                                            <xsl:attribute name="min"><xsl:value-of select="$circumferences[2]"/></xsl:attribute>
                                            <xsl:value-of select="$circumferences[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$circumferences[2]"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <circumference unit="cm"><xsl:value-of select="$tokens[30]"/></circumference>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[31], '$')">
                                        <xsl:variable name="weights" as="xs:string*" select="tokenize($tokens[31], '\$')"/>
                                        <xsl:element name="weight">
                                            <xsl:attribute name="unit">cm</xsl:attribute>
                                            <xsl:attribute name="max"><xsl:value-of select="$weights[1]"/></xsl:attribute>
                                            <xsl:attribute name="min"><xsl:value-of select="$weights[2]"/></xsl:attribute>
                                            <xsl:value-of select="$weights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$weights[2]"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <weight unit="cm"><xsl:value-of select="$tokens[31]"/></weight>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </compositeArtefactFormat>
                            <xsl:if test="$tokens[32] != '' or $tokens[33] != '' or $tokens[34] != '' or $tokens[35] != '' or $tokens[36] != ''">
                                <copperplateFormat>
                                <!--<copperplatesSetWeight unit=""></copperplatesSetWeight>-->
                                    <xsl:element name="bindingRing">
                                        <xsl:attribute name="value"><xsl:value-of select="$tokens[32]"/></xsl:attribute>
                                    </xsl:element>
                                    <xsl:element name="sealPreservation">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$tokens[33] = 'yes'">
                                                    <xsl:text>yes</xsl:text>  
                                                </xsl:when>
                                                <xsl:otherwise><xsl:text>no</xsl:text></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </xsl:element>
                                    <xsl:element name="sealingTechnique">
                                        <xsl:attribute name="value"><xsl:text>#</xsl:text><xsl:value-of select="$tokens[34]"/></xsl:attribute>
                                    </xsl:element>
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[35], '$')">
                                            <xsl:variable name="sealHeights" as="xs:string*" select="tokenize($tokens[35], '\$')"/>
                                            <xsl:element name="sealHeight">
                                                <xsl:attribute name="unit">cm</xsl:attribute>
                                                <xsl:attribute name="max"><xsl:value-of select="$sealHeights[1]"/></xsl:attribute>
                                                <xsl:attribute name="min"><xsl:value-of select="$sealHeights[2]"/></xsl:attribute>
                                                <xsl:value-of select="$sealHeights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealHeights[2]"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <sealHeight unit="cm"><xsl:value-of select="$tokens[35]"/></sealHeight>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[36], '$')">
                                            <xsl:variable name="sealWidths" as="xs:string*" select="tokenize($tokens[36], '\$')"/>
                                            <xsl:element name="sealWidth">
                                                <xsl:attribute name="unit">cm</xsl:attribute>
                                                <xsl:attribute name="max"><xsl:value-of select="$sealWidths[1]"/></xsl:attribute>
                                                <xsl:attribute name="min"><xsl:value-of select="$sealWidths[2]"/></xsl:attribute>
                                                <xsl:value-of select="$sealWidths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealWidths[2]"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <sealWidth unit="cm"><xsl:value-of select="$tokens[36]"/></sealWidth>
                                        </xsl:otherwise>
                                    </xsl:choose>
                            </copperplateFormat>
                            </xsl:if>
                            <!--<condition value=""/>-->
                            <compositeArtefactHistory>
                                <p><xsl:value-of select="$tokens[39]"/></p>
                                    <xsl:choose>
                                        <xsl:when test="$tokens[38] != ''">
                                            <xsl:element name="origDate">
                                                <xsl:attribute name="from"><xsl:value-of select="substring-before($tokens[38], '-')"/></xsl:attribute>
                                                <xsl:attribute name="tp"><xsl:value-of select="substring-after($tokens[38], '-')"/></xsl:attribute>
                                                <xsl:value-of select="$tokens[38]"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="origDate">
                                                <xsl:attribute name="when"><xsl:value-of select="$tokens[37]"/></xsl:attribute>
                                                <xsl:value-of select="$tokens[37]"/>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                            </compositeArtefactHistory>
                            <originExhib>
                                <originExhibPlace><xsl:value-of select="$tokens[41]"/></originExhibPlace>
                                <xsl:element name="originPlaceID">
                                    <xsl:attribute name="id"><xsl:value-of select="$tokens[42]"/></xsl:attribute>
                                </xsl:element>
                                <!--<originPlaceRemarks><p></p></originPlaceRemarks>-->
                            </originExhib>
                            <discoveryPlace>
                                <discoveryPlaceName><xsl:value-of select="$tokens[43]"/></discoveryPlaceName>
                                <discoveryPlaceID>
                                    <xsl:attribute name="id"><xsl:value-of select="$tokens[44]"/></xsl:attribute>
                                </discoveryPlaceID>
                                <discoveryCoordinates><xsl:value-of select="$tokens[45]"/></discoveryCoordinates>
                                <xsl:if test="$tokens[46] != ''">
                                    <xsl:element name="discoveryEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[46]"/></xsl:attribute>
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[47]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[48] != ''">
                                    <xsl:element name="discoveryEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[48]"/></xsl:attribute>
                                        <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[49]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </discoveryPlace>
                            <preservationPlace>
                                <preservationPlaceName><xsl:value-of select="$tokens[50]"/></preservationPlaceName>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[51], '$')">
                                        <xsl:variable name="inventory" as="xs:string*" select="tokenize($tokens[51], '\$')"/>
                                        <xsl:for-each select="$inventory">
                                            <inventoryNumber><xsl:value-of select="."/></inventoryNumber>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <inventoryNumber><xsl:value-of select="$tokens[51]"/></inventoryNumber>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:element name="preservationPlaceID">
                                    <xsl:attribute name="idno"><xsl:value-of select="$tokens[52]"/></xsl:attribute>
                                </xsl:element>
                                <preservationCoordinates><xsl:value-of select="$tokens[54]"/></preservationCoordinates>
                                <xsl:element name="inSituStatus">
                                    <xsl:attribute name="value"><xsl:value-of select="$tokens[53]"/></xsl:attribute>
                                </xsl:element>
                                <xsl:if test="$tokens[55] != ''">
                                    <xsl:element name="preservationEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[55]"/></xsl:attribute>
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[56]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[57] != ''">
                                    <xsl:element name="preservationEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[57]"/></xsl:attribute>
                                        <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[58]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[59] != ''">
                                    <xsl:element name="preservationEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[59]"/></xsl:attribute>
                                        <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[60]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </preservationPlace>
                            <compositeArtefactRights>
                                <governmentalHolder><xsl:value-of select="$tokens[61]"/></governmentalHolder>
                                <institutionalHolder><xsl:value-of select="$tokens[62]"/></institutionalHolder>
                                <compositeArtefactDistributionRights><xsl:value-of select="$tokens[63]"/></compositeArtefactDistributionRights>
                            </compositeArtefactRights>
                            <relatedResources>
                                <xsl:if test="$tokens[19] !=''">
                                    <xsl:element name="artefactID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="artefacts-id" select="tokenize($tokens[19], '\$')"/>
                                            <xsl:for-each select="$artefacts-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[18] !=''">
                                    <xsl:element name="textID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="texts-id" select="tokenize($tokens[18], '\$')"/>
                                            <xsl:for-each select="$texts-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[20] !=''">
                                    <xsl:element name="monumentID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="monuments-id" select="tokenize($tokens[20], '\$')"/>
                                            <xsl:for-each select="$monuments-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                            </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[64] !=''">
                                    <xsl:element name="surrogateID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="surrogates-id" select="tokenize($tokens[64], '\$')"/>
                                            <xsl:for-each select="$surrogates-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[65] !=''">
                                    <xsl:element name="imageID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="images-id" select="tokenize($tokens[65], '\$')"/>
                                            <xsl:for-each select="$images-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </relatedResources>
                            <remarks>
                                <p><xsl:value-of select="$tokens[40]"/></p>
                            </remarks>
                        </compositeArtefactDescription>
                </line>
            </xsl:if>
        </xsl:for-each>  
    </xsl:variable>
        <File>          
            <xsl:copy-of select="$lines/line"/>  
        </File>
    </xsl:template>  
</xsl:stylesheet>
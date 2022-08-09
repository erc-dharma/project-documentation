<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/" name="xsl:initial-template">
        <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/mdt-artefacts/contents/csv/artefacts')"/>
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
                    <artefactDescription>
                        <artefactID><xsl:value-of select="$tokens[14]"/></artefactID>
                        <artefactDes><xsl:value-of select="$tokens[15]"/></artefactDes>
                        <alternative>
                            <xsl:if test="$tokens[16] != ''">
                                <artefactDes><xsl:value-of select="$tokens[16]"/></artefactDes>
                            </xsl:if>
                            <xsl:if test="$tokens[17] != ''">
                                <artefactDes><xsl:value-of select="$tokens[17]"/></artefactDes>
                            </xsl:if>
                        </alternative>
                        <relationText>
                            <xsl:variable name="texts-id" select="tokenize($tokens[18], '\$')"/>
                            <xsl:for-each select="$texts-id">
                                <textID>
                                    <xsl:apply-templates select="."/>
                                </textID>
                            </xsl:for-each>
                        </relationText>
                        <xsl:if test="$tokens[19] != ''">
                            <relationArtefact>
                                <compositeArtefactID><xsl:value-of select="$tokens[19]"/></compositeArtefactID>
                            </relationArtefact>
                        </xsl:if>
                        <xsl:if test="$tokens[20] != ''">
                            <relationMonument>
                                <monumentID><xsl:value-of select="$tokens[20]"/></monumentID>
                            </relationMonument>
                        </xsl:if>
                        <xsl:if test="$tokens[22] != ''">
                            <material><xsl:value-of select="$tokens[22]"/></material>
                            <xsl:if test="$tokens[25] != ''">
                                <material><xsl:value-of select="$tokens[25]"/></material>
                            </xsl:if>                    
                        </xsl:if>
                        <xsl:if test="$tokens[21] != ''">
                            <artefactType><xsl:value-of select="$tokens[21]"/></artefactType>
                            <xsl:if test="$tokens[24] != ''">
                                <artefactType><xsl:value-of select="$tokens[24]"/></artefactType>
                            </xsl:if>
                        
            </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$tokens[23] != 'yes'">
                            <reuse value="yes"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <reuse value="no"/>
                        </xsl:otherwise>
                        </xsl:choose>
                        <decoDesc>
                            <p><xsl:value-of select="$tokens[26]"/></p>
                        </decoDesc>
                    <artefactFormat>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[27], '$')">
                                <xsl:variable name="heights" as="xs:string*" select="tokenize($tokens[27], '\$')"/>
                                <xsl:element name="height">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$heights[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$heights[2]"/></xsl:attribute>
                                    <xsl:value-of select="$heights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$heights[2]"/>
                                </xsl:element>
                            </xsl:when>
                        <xsl:otherwise>
                            <height unit="cm"><xsl:value-of select="$tokens[27]"/></height>
                        </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[28], '$')">
                                <xsl:variable name="widths" as="xs:string*" select="tokenize($tokens[28], '\$')"/>
                                <xsl:element name="width">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$widths[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$widths[2]"/></xsl:attribute>
                                    <xsl:value-of select="$widths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$widths[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <width unit="cm"><xsl:value-of select="$tokens[28]"/></width>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[29], '$')">
                                <xsl:variable name="depths" as="xs:string*" select="tokenize($tokens[29], '\$')"/>
                                <xsl:element name="depth">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$depths[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$depths[2]"/></xsl:attribute>
                                    <xsl:value-of select="$depths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$depths[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <depth unit="cm"><xsl:value-of select="$tokens[29]"/></depth>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[30], '$')">
                                <xsl:variable name="diameters" as="xs:string*" select="tokenize($tokens[30], '\$')"/>
                                <xsl:element name="diameter">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$diameters[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$diameters[2]"/></xsl:attribute>
                                    <xsl:value-of select="$diameters[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$diameters[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <diameter unit="cm"><xsl:value-of select="$tokens[30]"/></diameter>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[31], '$')">
                                <xsl:variable name="circumferences" as="xs:string*" select="tokenize($tokens[31], '\$')"/>
                                <xsl:element name="circumference">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$circumferences[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$circumferences[2]"/></xsl:attribute>
                                    <xsl:value-of select="$circumferences[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$circumferences[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <circumference unit="cm"><xsl:value-of select="$tokens[31]"/></circumference>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[32], '$')">
                                <xsl:variable name="weights" as="xs:string*" select="tokenize($tokens[32], '\$')"/>
                                <xsl:element name="weight">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$weights[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$weights[2]"/></xsl:attribute>
                                    <xsl:value-of select="$weights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$weights[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <weight unit="cm"><xsl:value-of select="$tokens[32]"/></weight>
                            </xsl:otherwise>
                        </xsl:choose>
                    </artefactFormat>
                   <!-- <lettering>
                        <letteringTechnique value=""/>
                        <textHeight unit=""></textHeight>
                        <textWidth unit=""></textWidth>
                        <linesNumber></linesNumber>
                        <glyphHeight unit=""></glyphHeight>
                        <glyphWidth unit=""></glyphWidth>
                        <letteringRemarks><p></p></letteringRemarks>
                    </lettering>-->
                    <copperplateFormat>
                        <!-- not present in the guide for mdt -->
                        <copperplateWeightOther><p><xsl:value-of select="$tokens[33]"/></p></copperplateWeightOther>
                        <xsl:element name="bindingHole">
                            <xsl:attribute name="value"><xsl:value-of select="$tokens[34]"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="bindingRing">
                            <xsl:attribute name="value"><xsl:value-of select="$tokens[35]"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="sealPreservation">
                            <xsl:attribute name="value">
                        <xsl:choose>
                            <xsl:when test="$tokens[36] = 'yes'">
                                   <xsl:text>yes</xsl:text>  
                            </xsl:when>
                            <xsl:otherwise><xsl:text>no</xsl:text></xsl:otherwise>
                        </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="sealingTechnique">
                            <xsl:attribute name="value"><xsl:text>#</xsl:text><xsl:value-of select="$tokens[37]"/></xsl:attribute>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[38], '$')">
                                <xsl:variable name="sealHeights" as="xs:string*" select="tokenize($tokens[38], '\$')"/>
                                <xsl:element name="sealHeight">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$sealHeights[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$sealHeights[2]"/></xsl:attribute>
                                    <xsl:value-of select="$sealHeights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealHeights[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <sealHeight unit="cm"><xsl:value-of select="$tokens[38]"/></sealHeight>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[39], '$')">
                                <xsl:variable name="sealWidths" as="xs:string*" select="tokenize($tokens[39], '\$')"/>
                                <xsl:element name="sealWidth">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$sealWidths[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$sealWidths[2]"/></xsl:attribute>
                                    <xsl:value-of select="$sealWidths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealWidths[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <sealWidth unit="cm"><xsl:value-of select="$tokens[39]"/></sealWidth>
                            </xsl:otherwise>
                        </xsl:choose>
                    </copperplateFormat>
                    <!--<condition value=""/>-->
                        <xsl:choose>
                            <xsl:when test="$tokens[41] != ''">
                                <xsl:element name="date">
                                    <xsl:attribute name="notBefore"><xsl:value-of select="substring-before($tokens[41], '-')"/></xsl:attribute>
                                    <xsl:attribute name="notAfter"><xsl:value-of select="substring-after($tokens[41], '-')"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[41]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="date">
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[40]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[40]"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <artefactHistory><p><xsl:value-of select="$tokens[42]"/></p></artefactHistory>
                    <originExhib>
                        <originExhibPlace><xsl:value-of select="$tokens[44]"/></originExhibPlace>
                        <xsl:element name="originPlaceID">
                            <xsl:attribute name="id"><xsl:value-of select="$tokens[45]"/></xsl:attribute>
                        </xsl:element>
                        <!--<originPlaceRemarks><p></p></originPlaceRemarks>-->
                    </originExhib>
                    <discoveryPlace>
                        <discoveryPlaceName><xsl:value-of select="$tokens[46]"/></discoveryPlaceName>
                        <discoveryPlaceID>
                            <xsl:attribute name="id"><xsl:value-of select="$tokens[47]"/></xsl:attribute>
                        </discoveryPlaceID>
                        <discoveryCoordinates><xsl:value-of select="$tokens[48]"/></discoveryCoordinates>
                        <xsl:if test="$tokens[49] != ''">
                            <xsl:element name="discoveryEvents">
                                <xsl:attribute name="type"><xsl:value-of select="$tokens[49]"/></xsl:attribute>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[50]"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$tokens[51] != ''">
                            <xsl:element name="discoveryEvents">
                                <xsl:attribute name="type"><xsl:value-of select="$tokens[51]"/></xsl:attribute>
                                <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[52]"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </discoveryPlace>
                    <preservationPlace>
                        <preservationPlaceName><xsl:value-of select="$tokens[53]"/></preservationPlaceName>
                            <xsl:choose>
                                <xsl:when test="contains($tokens[54], '$')">
                                    <xsl:variable name="sealWidths" as="xs:string*" select="tokenize($tokens[54], '\$')"/>
                                    <xsl:for-each select="$sealWidths">
                                        <inventoryNumber><xsl:value-of select="."/></inventoryNumber>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <inventoryNumber><xsl:value-of select="$tokens[54]"/></inventoryNumber>
                                </xsl:otherwise>
                            </xsl:choose>
                        <xsl:element name="preservationPlaceID">
                            <xsl:attribute name="idno"><xsl:value-of select="$tokens[55]"/></xsl:attribute>
                        </xsl:element>
                        <preservationCoordinates><xsl:value-of select="$tokens[57]"/></preservationCoordinates>
                        <xsl:element name="inSituStatus">
                            <xsl:attribute name="value"><xsl:value-of select="$tokens[56]"/></xsl:attribute>
                        </xsl:element>
                        <xsl:if test="$tokens[58] != ''">
                            <xsl:element name="preservationEvents">
                                <xsl:attribute name="type"><xsl:value-of select="$tokens[58]"/></xsl:attribute>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[59]"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$tokens[60] != ''">
                            <xsl:element name="preservationEvents">
                                <xsl:attribute name="type"><xsl:value-of select="$tokens[60]"/></xsl:attribute>
                                <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[61]"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$tokens[62] != ''">
                            <xsl:element name="preservationEvents">
                                <xsl:attribute name="type"><xsl:value-of select="$tokens[62]"/></xsl:attribute>
                                <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[63]"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </preservationPlace>
                    <artefactRights>
                        <governmentalHolder><xsl:value-of select="$tokens[64]"/></governmentalHolder>
                        <institutionalHolder><xsl:value-of select="$tokens[65]"/></institutionalHolder>
                        <artefactDistributionRights><xsl:value-of select="$tokens[66]"/></artefactDistributionRights>
                    </artefactRights>
                    <relatedResources>
                        <xsl:if test="$tokens[67] !=''">
                            <xsl:element name="textID">
                                <xsl:attribute name="idno">
                            <xsl:variable name="texts-id" select="tokenize($tokens[67], '\$')"/>
                            <xsl:for-each select="$texts-id">
                                <xsl:value-of select="."/>
                                <xsl:text> </xsl:text>
                            </xsl:for-each>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$tokens[68] !=''">
                            <xsl:element name="surrogateID">
                                <xsl:attribute name="idno">
                                    <xsl:variable name="surrogates-id" select="tokenize($tokens[68], '\$')"/>
                                    <xsl:for-each select="$surrogates-id">
                                        <xsl:value-of select="."/>
                                        <xsl:text> </xsl:text>
                                    </xsl:for-each>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$tokens[69] !=''">
                            <xsl:element name="imageID">
                                <xsl:attribute name="idno">
                                    <xsl:variable name="images-id" select="tokenize($tokens[69], '\$')"/>
                                    <xsl:for-each select="$images-id">
                                        <xsl:value-of select="."/>
                                        <xsl:text> </xsl:text>
                                    </xsl:for-each>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </relatedResources>
                        <remarks><p><xsl:value-of select="$tokens[43]"/></p></remarks>
                    </artefactDescription>
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
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
                        <!-- colonne N (14) id artefact -->                         
                        <artefactID><xsl:value-of select="$tokens[14]"/></artefactID>
                        <!-- colonne O (15) artefact designation -->
                        <artefactDes type="main"><xsl:value-of select="$tokens[15]"/></artefactDes>
                        <!-- colonne P (16) et Q (17) alt designation  -->
                        <xsl:if test="$tokens[16] != ''">
                        <alternative>
                                <artefactDes type="alt"><xsl:value-of select="$tokens[16]"/></artefactDes>
                            <xsl:if test="$tokens[17] != ''">
                                <artefactDes type="alt"><xsl:value-of select="$tokens[17]"/></artefactDes>
                            </xsl:if>
                        </alternative>
                        </xsl:if>
                        <relationText>
                            <!-- colonne R (18) id texte -->                         
                                <textID>
                                    <xsl:value-of select="$tokens[18]"/>
                                </textID>
                        </relationText>
                        <!-- colonne S (19) id conglomerate artefact -->
                        <xsl:if test="$tokens[19] != ''">
                            <relationArtefact>
                                <compositeArtefactID><xsl:value-of select="$tokens[19]"/></compositeArtefactID>
                            </relationArtefact>
                        </xsl:if>
                            <!-- colonne T (20) id conglomerate artefact -->
                        <xsl:if test="$tokens[20] != ''">
                            <relationMonument>
                                <monumentID><xsl:value-of select="$tokens[20]"/></monumentID>
                            </relationMonument>
                        </xsl:if>
                            <!-- colonne x (24) type 1 -->
                        <xsl:if test="$tokens[24] != ''">
                            <material><xsl:value-of select="$tokens[24]"/></material>
                            <!-- colonne Y (25) type 1 -->
                            <xsl:if test="$tokens[25] != ''">
                                <material><xsl:value-of select="$tokens[25]"/></material>
                            </xsl:if>                    
                        </xsl:if>
                            <!-- colonne U (21) type 1 -->
                        <xsl:if test="$tokens[21] != ''">
                            <artefactType><xsl:value-of select="$tokens[21]"/></artefactType>
                            <!-- colonne W (23) type 1 -->
                            <xsl:if test="$tokens[23] != ''">
                                <artefactType><xsl:value-of select="$tokens[23]"/></artefactType>
                            </xsl:if>
                        
                        </xsl:if>
                            <!-- colonne V (22) reuse-->
                        <xsl:choose>
                            <xsl:when test="$tokens[22] != 'yes'">
                            <reuse value="yes"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <reuse value="no"/>
                        </xsl:otherwise>
                        </xsl:choose>
                            <!-- colonne Z (26) type 1 -->
                        <decoDesc>
                            <p><xsl:value-of select="$tokens[26]"/></p>
                        </decoDesc>
                    <artefactFormat>
                        <!-- colonne AA (27) height  -->
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
                        <!-- colonne AB (28) widht  -->
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
                        <!-- colonne AC (29) Depth  -->
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
                        <!-- colonne AD (30) diameter  -->
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
                        <!-- colonne AE (31) circum  -->
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
                        <!-- colonne AF (32) weight  -->
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
                        <xsl:element name="sealPreservation">
                            <xsl:attribute name="value">
                        <xsl:choose>
                            <xsl:when test="$tokens[35] = 'yes'">
                                   <xsl:text>yes</xsl:text>  
                            </xsl:when>
                            <xsl:otherwise><xsl:text>no</xsl:text></xsl:otherwise>
                        </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="sealingTechnique">
                            <xsl:attribute name="value"><xsl:text>#</xsl:text><xsl:value-of select="$tokens[36]"/></xsl:attribute>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[37], '$')">
                                <xsl:variable name="sealHeights" as="xs:string*" select="tokenize($tokens[37], '\$')"/>
                                <xsl:element name="sealHeight">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$sealHeights[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$sealHeights[2]"/></xsl:attribute>
                                    <xsl:value-of select="$sealHeights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealHeights[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <sealHeight unit="cm"><xsl:value-of select="$tokens[37]"/></sealHeight>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($tokens[38], '$')">
                                <xsl:variable name="sealWidths" as="xs:string*" select="tokenize($tokens[38], '\$')"/>
                                <xsl:element name="sealWidth">
                                    <xsl:attribute name="unit">cm</xsl:attribute>
                                    <xsl:attribute name="max"><xsl:value-of select="$sealWidths[1]"/></xsl:attribute>
                                    <xsl:attribute name="min"><xsl:value-of select="$sealWidths[2]"/></xsl:attribute>
                                    <xsl:value-of select="$sealWidths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealWidths[2]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <sealWidth unit="cm"><xsl:value-of select="$tokens[38]"/></sealWidth>
                            </xsl:otherwise>
                        </xsl:choose>
                    </copperplateFormat>
                    <!--<condition value=""/>-->
                        <xsl:choose>
                            <xsl:when test="$tokens[40] != ''">
                                <xsl:element name="date">
                                    <xsl:attribute name="notBefore"><xsl:value-of select="substring-before($tokens[40], '-')"/></xsl:attribute>
                                    <xsl:attribute name="notAfter"><xsl:value-of select="substring-after($tokens[40], '-')"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[40]"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="date">
                                    <xsl:attribute name="when"><xsl:value-of select="$tokens[39]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[39]"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <artefactHistory><p><xsl:value-of select="$tokens[41]"/></p></artefactHistory>
                        <remarks><p><xsl:value-of select="$tokens[42]"/></p></remarks>
                    <originExhib>
                        <xsl:element name="originExhibPlace">
                            <xsl:attribute name="status"><xsl:value-of select="$tokens[43]"/></xsl:attribute>
                            <xsl:attribute name="id"><xsl:value-of select="$tokens[45]"/></xsl:attribute>
                            <xsl:value-of select="$tokens[44]"/>
                        </xsl:element>
                        <!--<originPlaceRemarks><p></p></originPlaceRemarks>-->
                    </originExhib>
                    <discoveryPlace>
                        <xsl:element name="discoveryPlaceId">
                            <xsl:attribute name="id"><xsl:value-of select="$tokens[47]"/></xsl:attribute>
                            <xsl:value-of select="$tokens[46]"/>
                        </xsl:element>eId>
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
                        <xsl:element name="preservationPlaceId">
                            <xsl:attribute name="id"><xsl:value-of select="$tokens[54]"/></xsl:attribute>
                        <xsl:value-of select="$tokens[53]"/>
                        </xsl:element>
                            <xsl:choose>
                                <xsl:when test="contains($tokens[55], '$')">
                                    <xsl:variable name="sealWidths" as="xs:string*" select="tokenize($tokens[55], '\$')"/>
                                    <xsl:for-each select="$sealWidths">
                                        <inventoryNumber><xsl:value-of select="."/></inventoryNumber>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <inventoryNumber><xsl:value-of select="$tokens[55]"/></inventoryNumber>
                                </xsl:otherwise>
                            </xsl:choose>
                       
                        <xsl:if test="$tokens[56] != ''">
                            <xsl:element name="preservationEvents">
                                <xsl:attribute name="type"><xsl:value-of select="$tokens[56]"/></xsl:attribute>
                                <xsl:attribute name="when"><xsl:value-of select="$tokens[57]"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
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
                    </preservationPlace>
                    <artefactRights>
                        <rightHolder><xsl:value-of select="$tokens[62]"/></rightHolder>
                        <artefactDistributionRights><xsl:value-of select="$tokens[63]"/></artefactDistributionRights>
                    </artefactRights>
                    <relatedResources>
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
                        <xsl:if test="$tokens[66] !=''">
                            <xsl:element name="repoID">
                                <xsl:attribute name="idno">
                                    <xsl:variable name="repo-id" select="tokenize($tokens[66], '\$')"/>
                                    <xsl:for-each select="$repo-id">
                                        <xsl:value-of select="."/>
                                        <xsl:text> </xsl:text>
                                    </xsl:for-each>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </relatedResources>
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
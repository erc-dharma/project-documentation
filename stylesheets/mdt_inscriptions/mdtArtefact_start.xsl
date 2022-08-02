<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
    
    <xsl:param name="data" select="unparsed-text('https://raw.githubusercontent.com/erc-dharma/mdt-artefacts/main/csv/DHARMA_mdt_template_v06-WIP.csv')"/>
    
    <xsl:template match="/" name="main">
        <File>
            <xsl:for-each select="$lines/line">
                <xsl:copy-of select="$lines/line"/>
            </xsl:for-each>
        </File>
    </xsl:template>
    
    <xsl:variable name="lines">
        <xsl:for-each select="tokenize($data, '\r?\n')">
            <xsl:if test="position() >= 6">
                <line>
                    <xsl:variable name="tokens" as="xs:string*" select="tokenize(., ',')"/>
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
                        <artefactType value=""/><!-- may be repeated -->
                        <decoDesc>
                            <decoration value=""/><!-- may be repeated -->
                            <decorationRemarks><p></p></decorationRemarks>
                        </decoDesc>
                    <artefactFormat>
                        <height unit=""></height>
                        <width unit=""></width>
                        <diameter unit=""></diameter>
                        <circumference unit=""></circumference>
                    </artefactFormat>
                    <lettering>
                        <letteringTechnique value=""/>
                        <textHeight unit=""></textHeight>
                        <textWidth unit=""></textWidth>
                        <linesNumber></linesNumber>
                        <glyphHeight unit=""></glyphHeight>
                        <glyphWidth unit=""></glyphWidth>
                        <letteringRemarks><p></p></letteringRemarks>
                    </lettering>
                    <copperplateFormat>
                        <copperplateWeight unit=""></copperplateWeight>
                        <copperplateWeightOther unit=""></copperplateWeightOther>
                        <bindingHole number=""/>
                        <sealPreservation value=""/><!-- only if the seal is on the plate, in case of a set of copper-plates, all the information about the seal has to be describded at the composite artefact level -->
                        <sealingTechnique value=""/>
                        <sealHeight unit=""></sealHeight>
                        <sealWidth unit=""></sealWidth>
                    </copperplateFormat>
                    <condition value=""/>
                    <artefactHistory><p></p></artefactHistory>
                    <originPlace>
                        <originPlaceName></originPlaceName>
                        <originPlaceID idno=""/>
                        <originPlaceRemarks><p></p></originPlaceRemarks>
                    </originPlace>
                    <discoveryPlace>
                        <discoveryPlaceName></discoveryPlaceName>
                        <discoveryPlaceID idno=""/>
                        <discoveryCoordinates></discoveryCoordinates>
                        <discoveryEvents type="" when=""><p></p></discoveryEvents>
                    </discoveryPlace>
                    <preservationPlace>
                        <preservationPlaceName></preservationPlaceName>
                        <inventoryNumber></inventoryNumber><!-- may be repeated -->
                        <preservationPlaceID idno=""/>
                        <preservationCoordinates></preservationCoordinates>
                        <inSituStatus value=""/>
                        <preservationEvents when="" type=""><p></p></preservationEvents>
                    </preservationPlace>
                    <artefactRights>
                        <governmentalHolder></governmentalHolder>
                        <institutionalHolder></institutionalHolder>
                        <artefactDistributionRights target=""/>
                    </artefactRights>
                    <relatedResources>
                        <textID idno=""/><!-- may be repeated -->
                        <surrogateID idno=""/><!-- may be repeated -->
                        <imageID idno=""/><!-- may be repeated -->
                    </relatedResources>
                    </artefactDescription>
                   
                </line>
            </xsl:if>
        </xsl:for-each>  
    </xsl:variable>
    
</xsl:stylesheet>
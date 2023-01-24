<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:functx="http://www.functx.com"
        xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0"
        exclude-result-prefixes="tei xi fn functx">
    <!-- Written by Axelle Janiak for DHARMA, starting Août 2022 -->
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
    <xsl:function name="functx:substring-before-match" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence select="tokenize($arg,$regex)[1]"/>
    </xsl:function>
    
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
        
      <!-- <xsl:param name="data" select="unparsed-text('https://raw.githubusercontent.com/erc-dharma/mdt-artefacts/main/csv/conglomerate-artefacts/DHARMA_mdt_Pallava.csv')"/>-->
        
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
                        <compositeArtefactDescription>
                            <compositeArtefactID><xsl:value-of select="$tokens[14]"/></compositeArtefactID>
                            <compositeArtefactDes type="main"><xsl:value-of select="$tokens[15]"/></compositeArtefactDes>
                                <xsl:if test="$tokens[16] != ''">
                                    <alternative>
                                    <artefactDes type="alt"><xsl:value-of select="$tokens[16]"/></artefactDes>
                                <xsl:if test="$tokens[17] != ''">
                                    <artefactDes type="alt"><xsl:value-of select="$tokens[17]"/></artefactDes>
                                </xsl:if>
                                    </alternative>
                                </xsl:if>
                            <!-- colonne x (24) type 1 -->
                            <xsl:if test="$tokens[24] != ''">
                                <xsl:call-template name="material-type">
                                    <xsl:with-param name="material" select="$tokens[24]"/>
                                </xsl:call-template> 
                                <!-- colonne Y (25) type 1 -->
                                <xsl:if test="$tokens[25] != ''">
                                    <xsl:call-template name="material-type">
                                    <xsl:with-param name="material" select="$tokens[25]"/>
                                    </xsl:call-template> 
                                </xsl:if>                    
                            </xsl:if>
                            <xsl:if test="$tokens[21]!= ''">
                                <xsl:call-template name="artefact-type">
                                    <xsl:with-param name="typology" select="$tokens[21]"/>
                                </xsl:call-template> 
                                
                            <xsl:if test="$tokens[23] != ''">
                                <xsl:call-template name="artefact-type">
                                    <xsl:with-param name="typology" select="$tokens[23]"/>
                                </xsl:call-template>
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
                            <decoDesc>
                                <p><xsl:value-of select="$tokens[26]"/></p>
                            </decoDesc>
                            <compositeArtefactFormat>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[27], '-')">
                                        <xsl:variable name="heights" as="xs:string*" select="tokenize($tokens[27], '\-')"/>
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
                                    <xsl:when test="contains($tokens[28], '-')">
                                        <xsl:variable name="widths" as="xs:string*" select="tokenize($tokens[28], '\-')"/>
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
                                    <xsl:when test="contains($tokens[29], '-')">
                                        <xsl:variable name="depths" as="xs:string*" select="tokenize($tokens[29], '\-')"/>
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
                                    <xsl:when test="contains($tokens[30], '-')">
                                        <xsl:variable name="diameters" as="xs:string*" select="tokenize($tokens[230], '\-')"/>
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
                                    <xsl:when test="contains($tokens[31], '-')">
                                        <xsl:variable name="circumferences" as="xs:string*" select="tokenize($tokens[31], '\-')"/>
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
                                    <xsl:when test="contains($tokens[32], '-')">
                                        <xsl:variable name="weights" as="xs:string*" select="tokenize($tokens[32], '\-')"/>
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
                            </compositeArtefactFormat>
                            <xsl:if test="$tokens[33] != '' or $tokens[34] != ''">
                                <xsl:element name="copperplateFormat">
                                    <xsl:attribute name="observed"><xsl:value-of select="$tokens[33]"/></xsl:attribute>
                                    <xsl:if test="$tokens[34] != ''">
                                        <xsl:attribute name="estimated"><xsl:value-of select="$tokens[34]"/></xsl:attribute>
                                    </xsl:if>
                                <!--<copperplatesSetWeight unit=""></copperplatesSetWeight>-->
                                    <xsl:element name="bindingInfo">
                                        <xsl:value-of select="$tokens[35]"/>
                                    </xsl:element>
                                    <xsl:element name="foliationInfo">
                                        <xsl:value-of select="$tokens[36]"/>
                                    </xsl:element>
                                    <xsl:element name="sealPreservation">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$tokens[37] = 'yes'">
                                                    <xsl:text>yes</xsl:text>  
                                                </xsl:when>
                                                <xsl:otherwise><xsl:text>no</xsl:text></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </xsl:element>
                                    <xsl:element name="sealingTechnique">
                                        <xsl:value-of select="$tokens[38]"/>
                                    </xsl:element>
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[39], '-')">
                                            <xsl:variable name="sealHeights" as="xs:string*" select="tokenize($tokens[39], '\-')"/>
                                            <xsl:element name="sealHeight">
                                                <xsl:attribute name="unit">cm</xsl:attribute>
                                                <xsl:attribute name="max"><xsl:value-of select="$sealHeights[1]"/></xsl:attribute>
                                                <xsl:attribute name="min"><xsl:value-of select="$sealHeights[2]"/></xsl:attribute>
                                                <xsl:value-of select="$sealHeights[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealHeights[2]"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <sealHeight unit="cm"><xsl:value-of select="$tokens[39]"/></sealHeight>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="contains($tokens[40], '-')">
                                            <xsl:variable name="sealWidths" as="xs:string*" select="tokenize($tokens[36], '\-')"/>
                                            <xsl:element name="sealWidth">
                                                <xsl:attribute name="unit">cm</xsl:attribute>
                                                <xsl:attribute name="max"><xsl:value-of select="$sealWidths[1]"/></xsl:attribute>
                                                <xsl:attribute name="min"><xsl:value-of select="$sealWidths[2]"/></xsl:attribute>
                                                <xsl:value-of select="$sealWidths[1]"/><xsl:text>–</xsl:text><xsl:value-of select="$sealWidths[2]"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <sealWidth unit="cm"><xsl:value-of select="$tokens[40]"/></sealWidth>
                                        </xsl:otherwise>
                                    </xsl:choose>
                            </xsl:element>
                            </xsl:if>
                            <!--<condition value=""/>-->
                            <compositeArtefactHistory>
                                <p><xsl:value-of select="$tokens[43]"/></p>
                                    <xsl:choose>
                                        <xsl:when test="$tokens[42] != ''">
                                            <xsl:element name="origDate">
                                                <xsl:attribute name="from"><xsl:value-of select="substring-before($tokens[42], '-')"/></xsl:attribute>
                                                <xsl:attribute name="to"><xsl:value-of select="substring-after($tokens[42], '-')"/></xsl:attribute>
                                                <xsl:value-of select="$tokens[42]"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="origDate">
                                                <xsl:attribute name="when"><xsl:value-of select="$tokens[41]"/></xsl:attribute>
                                                <xsl:value-of select="$tokens[41]"/>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                            </compositeArtefactHistory>
                            <!-- reprendre à la colonne 45 -->
                            <originExhib>
                                <xsl:element name="originExhibPlace">
                                    <xsl:attribute name="status"><xsl:value-of select="$tokens[45]"/></xsl:attribute>
                                    <xsl:attribute name="id"><xsl:value-of select="$tokens[47]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[46]"/>
                                </xsl:element>
                                <!--<originPlaceRemarks><p></p></originPlaceRemarks>-->
                            </originExhib>
                            <discoveryPlace>
                                <xsl:element name="discoveryPlaceId">
                                    <xsl:attribute name="id"><xsl:value-of select="$tokens[49]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[48]"/>
                                </xsl:element>
                                <discoveryCoordinates><xsl:value-of select="$tokens[50]"/></discoveryCoordinates>
                                <xsl:if test="$tokens[51] != ''">
                                    <xsl:element name="discoveryEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[51]"/></xsl:attribute>
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[52]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[53] != ''">
                                    <xsl:element name="discoveryEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[53]"/></xsl:attribute>
                                        <!-- il va falloir affiner le traitement des dates, mais la pratique n'est pas aligné sur ce que l'on trouve ailleurs -->
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[54]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </discoveryPlace>
                            <preservationPlace>
                                <xsl:element name="preservationPlaceId">
                                    <xsl:attribute name="id"><xsl:value-of select="$tokens[56]"/></xsl:attribute>
                                    <xsl:value-of select="$tokens[55]"/>
                                </xsl:element>
                                <xsl:choose>
                                    <xsl:when test="contains($tokens[57], '$')">
                                        <xsl:variable name="inventories" as="xs:string*" select="tokenize($tokens[57], '\$')"/>
                                        <xsl:for-each select="$inventories">
                                            <inventoryNumber><xsl:value-of select="."/></inventoryNumber>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <inventoryNumber><xsl:value-of select="$tokens[57]"/></inventoryNumber>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                                <xsl:if test="$tokens[58] != ''">
                                    <xsl:element name="preservationEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[58]"/></xsl:attribute>
                                        <xsl:attribute name="when"><xsl:value-of select="$tokens[59]"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[60] != ''">
                                    <xsl:element name="preservationEvents">
                                        <xsl:attribute name="type"><xsl:value-of select="$tokens[60]"/></xsl:attribute>
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
                            <compositeArtefactRights>
                                <rightHolder><xsl:value-of select="$tokens[64]"/></rightHolder>
                                <artefactDistributionRights><xsl:value-of select="$tokens[65]"/></artefactDistributionRights>
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
                                <xsl:if test="$tokens[66] !=''">
                                    <xsl:element name="surrogateID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="surrogates-id" select="tokenize($tokens[66], '\$')"/>
                                            <xsl:for-each select="$surrogates-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[67] !=''">
                                    <xsl:element name="imageID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="images-id" select="tokenize($tokens[67], '\$')"/>
                                            <xsl:for-each select="$images-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$tokens[68] !=''">
                                    <xsl:element name="repoID">
                                        <xsl:attribute name="idno">
                                            <xsl:variable name="repo-id" select="tokenize($tokens[68], '\$')"/>
                                            <xsl:for-each select="$repo-id">
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </relatedResources>
                            <remarks>
                                <p><xsl:value-of select="$tokens[44]"/></p>
                            </remarks>
                        </compositeArtefactDescription>
                </line>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>  
    </xsl:variable>
        <File>          
            <xsl:copy-of select="$lines/line"/>  
        </File>
    </xsl:template>  
    
    <xsl:template name="artefact-type">
        <xsl:param name="typology"/>
        <xsl:if test="$typology != ''">
            <xsl:element name="compositeArtefactType">
                <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="contains($typology, ' - ')">
                        <xsl:value-of select="substring-before($typology, ' -')"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:attribute name="class"><xsl:value-of select="$typology"/></xsl:attribute></xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
                <xsl:choose>                 
                    <xsl:when test="$typology ='architectural_element' or $typology = 'documentary' or $typology = 'jewellery' or $typology = 'monument' or $typology = 'natural_object' or $typology = 'sculpture' or $typology = 'unknown' or $typology = 'utensil'">
                    <xsl:value-of select="translate($typology, '_', ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after($typology, '- ')"/>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="material-type">
        <xsl:param name="material"/>
        <xsl:if test="$material != ''">
            <xsl:element name="material">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="contains($material, ' - ')">
                            <xsl:value-of select="functx:substring-before-match($material, ' -')"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:attribute name="class"><xsl:value-of select="$material"/></xsl:attribute></xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>                 
                    <xsl:when test="$material='metal' or $material='mineral-based' or $material='organic' or $material='stone' or $material='unknown'">
                        <xsl:value-of select="$material"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(functx:substring-after-last($material, '- '), '_', ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
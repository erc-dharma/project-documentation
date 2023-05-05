<?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:functx="http://www.functx.com"
        xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
        exclude-result-prefixes="tei xi fn functx">
        <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0"/>
        <xsl:strip-space elements="*"/>
        
        <xsl:function name="functx:non-distinct-values" as="xs:anyAtomicType*"
            xmlns:functx="http://www.functx.com">
            <xsl:param name="seq" as="xs:anyAtomicType*"/>
            
            <xsl:sequence select="
                for $val in distinct-values($seq)
                return $val[count($seq[. = $val]) > 1]
                "/>
            
        </xsl:function>
        
        <xsl:function name="functx:value-intersect" as="xs:anyAtomicType*"
            xmlns:functx="http://www.functx.com">
            <xsl:param name="arg1" as="xs:anyAtomicType*"/>
            <xsl:param name="arg2" as="xs:anyAtomicType*"/>
            
            <xsl:sequence select="
                distinct-values($arg1[.=$arg2])
                "/>
            
        </xsl:function>
        
        <xsl:function name="functx:value-except" as="xs:anyAtomicType*"
            xmlns:functx="http://www.functx.com">
            <xsl:param name="arg1" as="xs:anyAtomicType*"/>
            <xsl:param name="arg2" as="xs:anyAtomicType*"/>
            
            <xsl:sequence select="
                distinct-values($arg1[not(.=$arg2)])
                "/>
            
        </xsl:function>
        
        <xsl:function name="functx:is-node-in-sequence" as="xs:boolean"
            xmlns:functx="http://www.functx.com">
            <xsl:param name="node" as="node()?"/>
            <xsl:param name="seq" as="node()*"/>
            
            <xsl:sequence select="
                some $nodeInSeq in $seq satisfies $nodeInSeq is $node
                "/>
            
        </xsl:function>
        
        <xsl:variable name="numWitnesses" select="count(//tei:listWit/tei:witness/@xml:id)"/>
        <xsl:variable name="listWitnesses" select="//tei:listWit/tei:witness/@xml:id"/>   
        <xsl:variable name="lacunae-nodes" select="functx:value-intersect(//tei:app[descendant-or-self::tei:lacunaStart]/following::* , //tei:app[descendant-or-self::tei:lacunaStart]/following::tei:lacunaEnd[1]/preceding::*)"/>
        <xsl:template match="/">           
                <html>
                    <head>
                        <title>
                            <xsl:choose>
                            <xsl:when test="//tei:titleStmt/tei:title/text()">
                                <xsl:if test="//tei:idno[@type='filename']/text()">
                                    <xsl:value-of select="//tei:idno[@type='filename']"/>
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="//tei:titleStmt/tei:title"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Check witness output, default style</xsl:text>
                            </xsl:otherwise>
                            </xsl:choose>
                        </title>
                        <meta content-type="application/xhtml+xml" content="text/html; charset=UTF-8"></meta>
                        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                            <!-- Bootstrap CSS -->
                            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"></link>
                            
                            <!-- scrollbar CSS -->
                            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                            
                            <!-- site-specific css !-->
                            <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/dharma-ms.css"></link>
                            <!--<link rel="stylesheet" href="./../criticalEditions/dharma-ms.css"></link>-->
                            
                            <!-- Font Awesome JS -->
                            <script src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
                            <script src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js" integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY" crossorigin="anonymous"></script>
                        </meta>
                    </head>
                    <body>
                        <div class="container">
                            <xsl:element name="div">
                                <xsl:element name="h2">Checking the witnesses for the <xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/></xsl:element>
                                <br/>
                                <p><xsl:value-of select="$numWitnesses"/> <xsl:text> witnesses declared in the teiHeader: </xsl:text> 
                                    <xsl:for-each select="//tei:listWit/tei:witness">
                                        <xsl:choose>
                                            <xsl:when test="./tei:abbr">
                                                <xsl:apply-templates select="./tei:abbr"/>
                                        </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@xml:id"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="following-sibling::tei:witness">, </xsl:when>                                            
                                            <xsl:otherwise>.</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </p>
                                <br/>
                                <xsl:element name="table">
                                    <xsl:attribute name="class">table</xsl:attribute>
                                    <xsl:element name="thead">
                                        <xsl:element name="tr">
                                            <xsl:element name="th">
                                                <xsl:attribute name="scope">col</xsl:attribute>
                                                <xsl:text>Apparatus number</xsl:text>
                                            </xsl:element>
                                            <xsl:element name="th">
                                                <xsl:attribute name="scope">col</xsl:attribute>
                                                <xsl:text>Apparatus Content</xsl:text>
                                            </xsl:element>
                                            <xsl:element name="th">
                                                <xsl:attribute name="scope">col</xsl:attribute>
                                                <xsl:text>Identified issue</xsl:text>
                                            </xsl:element>                                        
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="tbody">
                                        
                                        <xsl:call-template name="apparatus"/>
                                  
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="footer">
                                <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                                <xsl:element name="div">
                                    <xsl:text>© DHARMA (2019-2025).</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </div>
                    </body>
                </html>
           
        </xsl:template>
        
        <xsl:template match="tei:teiHeader"/>
        
        <xsl:template name="apparatus">            
            <xsl:for-each select="//tei:app">
                <xsl:variable name="app-content" select="tokenize(translate(string-join(./tei:*[not(tei:witDetail)]/@wit, ' '), '#', ''), '\s')"/>
                <xsl:variable name="current-node" select="current()"/>
                <xsl:variable name="sequence" select="for $node in $lacunae-nodes return $node"/>
                <xsl:choose>
                    <xsl:when test="parent::tei:listApp[@type='parallels']"/>
                    <xsl:when test="@rend='hide'"/> 
                    <xsl:when test="$current-node = $sequence">
                    <!-- need to write the conditions  to check the witnesses inside a lacuna -->
                    </xsl:when>
                    <!--<xsl:when test="child::tei:lem[@type]"/>-->
                    <xsl:when test="parent::tei:lem">
                    <!-- need to write the condition to check the embedded apparatus -->
                    </xsl:when>
                    <xsl:when test=".[descendant-or-self::tei:witDetail]">
                     <xsl:variable name="count-witdetail" select="count(./tei:witDetail) + 1"/>
                        <xsl:if test="count($app-content) - $count-witdetail != $numWitnesses">
                            <xsl:element name="tr">
                                <xsl:call-template name="app-number"/>
                                
                                <xsl:element name="td">
                                    <xsl:call-template name="appchoice"/>
                                </xsl:element>                                
                                
                                <xsl:element name="td">
                                    <xsl:text> The count seems weird in this apparatus entry. You should check</xsl:text>
                                    
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="count(tokenize(string-join(./tei:*[not(tei:witDetail)]/@wit, ' '), '\s')) != $numWitnesses" >
                            <xsl:element name="tr">
                                <xsl:call-template name="app-number"/>
                                
                                <xsl:element name="td">
                                    <xsl:call-template name="appchoice"/>
                                </xsl:element>                                
                               
                                <xsl:element name="td">
                                    
                                    <xsl:value-of select="$numWitnesses - count($app-content)"/> <xsl:text> witnesses are missing in this apparatus entry.</xsl:text>
                                    <br/>
                                    Check for 
                                    <xsl:value-of select="functx:value-except($listWitnesses, $app-content)"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
                
           
        </xsl:template>
        
        <xsl:template name="app-number">
            <xsl:element name="td">
                
                <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])] | //tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(//tei:TEI[@type='translation'])] | //tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart']| .//tei:l[@real] |.//tei:lacunaStart"/>
                
            </xsl:element>
        </xsl:template>
        <!--  hi ! -->
        <xsl:template match="tei:hi">
            <xsl:choose>
                <xsl:when test="@rend='superscript'">
                    <xsl:element name="sup">
                        <xsl:attribute name="class">ed-siglum</xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@rend='subscript'">
                    <xsl:element name="sub">
                        <xsl:attribute name="class">ed-siglum</xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@rend='italic'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-italic</xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@rend='caps'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">small-caps</xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:template>
        
        <!-- lem: render the compound in the apparatus entries -->
        <xsl:template name="lem-type">
            <xsl:choose>
                <xsl:when test="./@rend='hyphenleft' or tei:lem/@rend='hyphenleft'">
                    <xsl:text>hyphenleft</xsl:text>
                </xsl:when>
                <xsl:when test="./@rend='hyphenright' or tei:lem/@rend='hyphenright'">
                    <xsl:text>hyphenright</xsl:text>
                </xsl:when>
                <xsl:when test="./@rend='hyphenaround' or tei:lem/@rend='hyphenaround'">
                    <xsl:text>hyphenaround</xsl:text>
                </xsl:when>
                <xsl:when test="./@rend='circleleft' or tei:lem/@rend='circleleft'">
                    <xsl:text>circleleft</xsl:text>
                </xsl:when>
                <xsl:when test="./@rend='circleright' or tei:lem/@rend='circleright'">
                    <xsl:text>circleright</xsl:text>
                </xsl:when>
                <xsl:when test="./@rend='circlearound' or tei:lem/@rend='circlearound'">
                    <xsl:text>circlearound</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:template>
        
     <xsl:template name="appchoice">

        <xsl:choose>
            <xsl:when test="child::tei:lem or child::tei:rdg">
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:text>bottom-lemma-reading</xsl:text>
                            <xsl:if test="not(tei:lem/following-sibling::tei:note[@type='altLem'])">
                                <xsl:call-template name="lem-type"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="tei:lem/following-sibling::tei:note[@type='altLem']">
                                <xsl:apply-templates select="replace(tei:lem/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')"/>
                            </xsl:when>
                            <xsl:when test="tei:lem[@type='transposition'][not(matches(@xml:id, 'trsp\d\d\d'))]"/>
                            <xsl:otherwise>
                                <xsl:apply-templates select="tei:lem"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:if test="not(tei:lem[@type='transposition'][following-sibling::tei:rdg[descendant::*[@corresp]]])">
                        <xsl:element name="span">
                        <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:text>]</xsl:text>
                    </xsl:element>
                    </xsl:if>
                    <xsl:if test="tei:lem/@type">
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                    <xsl:text> </xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="tei:lem/@type='emn'">
                                            <xsl:text>em.</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="tei:lem/@type='norm'">
                                            <xsl:text>norm.</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="tei:lem/@type='conj'">
                                            <xsl:text>conj.</xsl:text>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:if test="attribute::wit or attribute::source">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:if>
                    <xsl:if test="tei:lem[@type='reformulated_elsewhere'] or .[following-sibling::tei:rdg[@type='paradosis']]"><!-- or .[following-sibling::tei:witDetail[@type='retained']] -->
                            <xsl:text> Thus formulated in </xsl:text>
                            <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>

                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="wit-hand" select="@hand"/>

                                    </xsl:call-template>
                            </xsl:element>
                        </xsl:if>
                    <xsl:if test="tei:lem[@type='transposition'][not(matches(@xml:id, 'trsp\d\d\d'))][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]">
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::tei:rdg/@wit"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:text> presents the lines in order </xsl:text>
                        <xsl:for-each select="following-sibling::tei:rdg/descendant::tei:l">
                            <xsl:variable name="id-corresp" select="substring-after(@corresp, '#')"/>
                            <xsl:value-of select="ancestor::tei:rdg/preceding-sibling::tei:lem[@type='transposition']/descendant::tei:l[@xml:id = $id-corresp]/@n"/>
                        </xsl:for-each>
                    </xsl:if>
                    <!-- case for transposition with parent with xml:if  -->
                    <xsl:if test="tei:lem[contains(@type,'transposition')][matches(@xml:id, 'trsp\d\d\d')]">
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="wit-hand" select="@hand"/>

                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="tei:lem/@type='omitted_elsewhere'">
                        <xsl:text> transmitted in </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>

                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>

                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="tei:lem/@type='lost_elsewhere'">
                        <xsl:text> preserved in </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                
                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                                
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="tei:lem/@wit">
                        <xsl:choose>
                            <xsl:when test="tei:lem[@type='transposition'][not(@xml:id)][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]"/>
                            <xsl:otherwise>
                              <xsl:element name="span">
                                  <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="tei:lem/@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                        <xsl:with-param name="wit-hand" select="@hand"/>
                                    </xsl:call-template>
                                  <xsl:if test="@varSeq">
                                      <xsl:choose>
                                          <xsl:when test="@varSeq='1'">
                                              <xsl:element name="sub">
                                                  <xsl:text>ac</xsl:text>
                                              </xsl:element>
                                          </xsl:when>
                                          <xsl:when test="@varSeq='2'">
                                              <xsl:element name="sub">
                                                  <xsl:text>pc</xsl:text>
                                              </xsl:element>
                                          </xsl:when>
                                      </xsl:choose>
                                  </xsl:if>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                            </xsl:if>

                    <xsl:if test="tei:lem[@type='transposition']">
                        <xsl:choose>
                            <xsl:when test=".[not(@xml:id)][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]"/>
                            <xsl:otherwise>
                                <xsl:text> (transposition)</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                       <!-- <xsl:value-of select="@type"/>
                        <xsl:text>)</xsl:text>-->
                    </xsl:if>
                        <xsl:if test="@source">
                                <xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="@source"/>
                                </xsl:call-template>
                            </xsl:if>

                    <xsl:if test="tei:lem[not(@type='transposition')]">
                        <xsl:text>, </xsl:text>
                    </xsl:if>

                
                <!-- create the fake lem for transposition only containing rdg -->
                <xsl:for-each select="tei:rdg[@cause='transposition'][not(preceding-sibling::tei:lem)]">
                        <xsl:variable name="corresp-id" select="@corresp"/>
                    <xsl:apply-templates select="replace(//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')
                            "/>
                        <!--  adding the bracket since it can't be diplayed without element lem-->
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>

                </xsl:for-each>
                <xsl:for-each select="descendant-or-self::tei:rdg[not(preceding-sibling::tei:lem[@type='transposition'])]">

                    <xsl:element name="span">
                        <xsl:attribute name="class">bottom-reading-line<xsl:choose><xsl:when test="descendant-or-self::tei:lacunaStart"><xsl:text> bottom-lacunaStart</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionStart']"> bottom-omissionStart<xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:lacunaEnd"><xsl:text> bottom-lacunaEnd</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionEnd']"> bottom-omissionEnd<xsl:value-of select="@wit"/></xsl:when></xsl:choose>
                        </xsl:attribute>
                            <xsl:if test="position()!=1">
                        <xsl:text>, </xsl:text>
                    </xsl:if>

                    <xsl:choose>
                        <xsl:when test="child::tei:pb"/>
                        <xsl:when test="child::tei:gap[@reason='omitted']">
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:text>om.</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="child::tei:gap[@reason='lost' and not(@quantity or @unit)]">
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:text>lac.</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="child::tei:lacunaEnd or child::tei:span[@type='omissionEnd']">...]</xsl:when>

                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@rend">
                            <xsl:element name="span">
                                <xsl:attribute name="class">
                                    <xsl:if test="@rend='check'">
                                        <xsl:text>mark</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="@rend='unmetrical'">
                                        <xsl:text>unmetrical</xsl:text>
                                    </xsl:if>
                                </xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>

                            <xsl:choose>
                                <xsl:when test="child::tei:lacunaStart or child::tei:span[@type='omissionStart']">[...</xsl:when>
                            </xsl:choose>

                    <xsl:if test="@*">
                        <xsl:if test="@wit">
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                                <xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="@wit"/>
                                    <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                    <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                    <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                    <xsl:with-param name="wit-hand" select="@hand"/>
                                </xsl:call-template>
                                <xsl:if test="@varSeq">
                                    <xsl:choose>
                                        <xsl:when test="@varSeq='1'">
                                            <xsl:element name="sub">
                                                <xsl:text>ac</xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="@varSeq='2'">
                                            <xsl:element name="sub">
                                                <xsl:text>pc</xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                            <xsl:if test="@source">
                                <xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="@source"/>
                                </xsl:call-template>
                            </xsl:if>
                        <xsl:if test="@cause">
                            <xsl:choose>
                                <xsl:when test="@cause='transposition'">
                                    <xsl:variable name="corresp-id" select="@corresp"/>
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="@cause"/>
                                    <xsl:text>, see </xsl:text>
                                    <xsl:element name="a">
                                        <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/@xml:id"/></xsl:attribute>
                                        <xsl:text>st. </xsl:text>
                                        <xsl:value-of select="//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/child::tei:lg/@n"/>
                                    </xsl:element>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:element name="span">
                                <xsl:attribute name="style">color:black;</xsl:attribute>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="replace(@cause, '_', ' ')"/>
                                <xsl:text>)</xsl:text>
                            </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="@type='paradosis'">
                        <xsl:text> • </xsl:text>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">paradosis-line</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">font-italic</xsl:attribute>
                                        <xsl:text>Paradosis</xsl:text>
                                    </xsl:element>
                                    <xsl:text> of </xsl:text>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">font-weight-bold <xsl:if test="tei:lem/following-sibling::*[local-name()='witDetail'] or tei:lem/@varSeq">supsub</xsl:if>
                                        </xsl:attribute>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                        <xsl:with-param name="wit-hand" select="@hand"/>
                                    </xsl:call-template>
                                    </xsl:element>
                                    <xsl:text>: </xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:element>
                    </xsl:if>
                    </xsl:element>
                </xsl:for-each>
                <!--<xsl:if test="ancestor::*[local-name()='lem'][1]/following-sibling::tei:rdg[1]">
                    <xsl:text>, </xsl:text>
                </xsl:if>-->
                <xsl:for-each select="ancestor::*[local-name()='lem'][not(@type='reformulation' or @type='transposition')][1]/following-sibling::tei:rdg[1]">
                   <xsl:call-template name="rdg-content">
                       <xsl:with-param name="parent-rdg" select="'yes-bottom'"/>
                   </xsl:call-template>
                </xsl:for-each>

                <xsl:for-each select="tei:rdg/following-sibling::tei:note[not(@type='altLem')]"><xsl:element name="span">
                            <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                            <xsl:text> • </xsl:text>
                            <xsl:apply-templates/>
                    </xsl:element>
                    </xsl:for-each>

                <xsl:if test="not(tei:rdg) and tei:lem/following-sibling::tei:note[not(@type='altLem')]">
                    <xsl:text> • </xsl:text>
                    <xsl:element name="span">
                        <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                        <xsl:apply-templates select="tei:lem/following-sibling::tei:note[not(@type='altLem')]"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>

                <!--<xsl:when test="$child=('appalt') or $apptype=('appalt')">
                    <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                        <xsl:with-param name="location" select="'text'"/>
                    </xsl:apply-templates>
                </xsl:when>-->
            <xsl:when test="child::tei:lem and child::tei:note and not(child::tei:rdg)">
                <xsl:for-each select="tei:note">
                <xsl:element name="span">
                    <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                    <xsl:apply-templates select="tei:note"/>
                </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <!--<xsl:when test="$apptype='omission'">
                <xsl:call-template name="omission-content"/>
            </xsl:when>
            <xsl:when test="$apptype='lost'">
                <xsl:call-template name="lost-content"/>
            </xsl:when>
            <xsl:when test="$apptype='reformulation'">
                <xsl:if test="self::tei:span[@type='reformulationStart']">
                    <xsl:variable name="reformulation-id" select="@xml:id"/>
                    <xsl:element name="span">
                        <xsl:attribute name="class">bottom-reformulation</xsl:attribute>
                        <xsl:apply-templates select="self::tei:span/following::node()[1]"/>
                        <xsl:text> &#8230;</xsl:text>
                        <xsl:if test="self::tei:span[@type='reformulationStart'][not(ancestor::tei:*[1][descendant::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')]])]">
                            <xsl:text> (</xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <!-\-<xsl:text>§</xsl:text>-\->
                        <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/ancestor::tei:div[@type='dyad']/@xml:id"/></xsl:attribute><xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/ancestor::tei:div[@type='dyad']/@n"/>
                            <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:*[local-name ()= ('lg', 'ab', 'p')]">
                                <xsl:text>.</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:lg">
                                        <xsl:number count="tei:lg" format="1" level="single"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:ab">
                                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:ab/position()"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:p">
                                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:p/position()"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:element>
                        </xsl:element>
                            <xsl:text>) </xsl:text>
                        </xsl:if>

                        <xsl:apply-templates select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/preceding::node()[1]"/>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:text>]</xsl:text>
                        </xsl:element>
                        <xsl:text> Thus formulated in </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:lem[@type='retained']/@wit"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg">
                        <xsl:text>, </xsl:text>
                    </xsl:if>

                        <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg">
                            <xsl:for-each select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg">
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>bottom-reading-line</xsl:text>
                            </xsl:attribute>
                                <xsl:apply-templates/>
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                                <xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="./@wit"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                        </xsl:for-each>
                    </xsl:if>
                        <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:note[not(@type='altLem')]"> • </xsl:if>
                        <xsl:for-each select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:note[not(@type='altLem')]">
                        <xsl:element name="span">
                            <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </xsl:when>-->
        </xsl:choose>
    </xsl:template>

        
        <xsl:template name="tokenize-witness-list">
            <xsl:param name="string"/>
            <xsl:param name="witdetail-string"/>
            <xsl:param name="witdetail-type"/>
            <xsl:param name="witdetail-text"/>
            <xsl:param name="wit-hand"/>
            <xsl:param name="tpl"/>
            <xsl:choose>
                <xsl:when test="contains($string, ' ')">
                    <xsl:variable name="first-item"
                        select="translate(normalize-space(substring-before($string, ' ')), '#', '')"/>
                    <xsl:if test="$first-item">
                        <xsl:call-template name="make-bibl-link">
                            <xsl:with-param name="target" select="$first-item"/>
                            <xsl:with-param name="witdetail-string" select="translate($witdetail-string, '#', '')"/>
                            <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                            <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
                            <xsl:with-param name="wit-hand" select="$wit-hand"/>
                            <xsl:with-param name="tpl" select="$tpl"/>
                        </xsl:call-template>
                        <xsl:call-template name="tokenize-witness-list">
                            <xsl:with-param name="string" select="substring-after($string, ' ')"/>
                            <xsl:with-param name="witdetail-string" select="$witdetail-string"/>
                            <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                            <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
                            <xsl:with-param name="wit-hand" select="$wit-hand"/>
                            <xsl:with-param name="tpl" select="$tpl"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$string = ''">
                            <xsl:text/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="make-bibl-link">
                                <xsl:with-param name="target" select="translate($string, '#', '')"/>
                                <xsl:with-param name="witdetail-string" select="translate($witdetail-string, '#', '')"/>
                                <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                                <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
                                <xsl:with-param name="wit-hand" select="$wit-hand"/>
                                <xsl:with-param name="tpl" select="$tpl"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:template>
        
        <!--  Make bibliography link ! -->
        <xsl:template name="make-bibl-link">
            <xsl:param name="target"/>
            <xsl:param name="witdetail-string"/>
            <xsl:param name="witdetail-type"/>
            <xsl:param name="witdetail-text"/>
            <xsl:param name="wit-hand"/>
            <xsl:param name="tpl"/>
            <!-- Changement dans la gestion des espaces donc $tpl='content-ptr' n'est plus nécessaire -->
            <xsl:if test="not($tpl='content-pb')">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:element name="a">
                <xsl:attribute name="class">siglum</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="$target"/>
                </xsl:attribute>
                
                <xsl:choose>
                    <xsl:when test="//tei:listWit/tei:witness[@xml:id=$target]/tei:abbr">
                        <xsl:apply-templates select="//tei:listWit/tei:witness[@xml:id=$target]/tei:abbr"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$target"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:element>
            <xsl:if test="$target = $witdetail-string">
                
                <xsl:element name="sub">
                    
                    <xsl:value-of select="$witdetail-type"/>
                    <xsl:if test="$wit-hand !=''">
                        <xsl:choose>
                            <xsl:when test="fn:contains($wit-hand, 'H1')">
                                <xsl:text>-pm</xsl:text>
                            </xsl:when>
                            <xsl:when test="fn:contains($wit-hand, 'H2')">
                                <xsl:text>-sm</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:element>
                <xsl:if test="$witdetail-text != ''">
                    <xsl:element name="span">
                        <xsl:attribute name="class">witDetail-line font-weight-normal</xsl:attribute>
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="$witdetail-text"/>
                        <xsl:text>)</xsl:text>
                    </xsl:element></xsl:if>
            </xsl:if>
        </xsl:template>
        
        <!-- Siglum : fetch the siglum to display -->
        <xsl:template name="source-siglum">
            <xsl:param name="string-to-siglum"/>
            <xsl:element name="span">
                <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                <xsl:text>Ed</xsl:text>
                <xsl:element name="sup">
                    <xsl:attribute name="class">ed-siglum</xsl:attribute>
                    <xsl:value-of select="//tei:listBibl/tei:biblStruct[@xml:id=$string-to-siglum]/tei:author/tei:surname"/>
                </xsl:element>
            </xsl:element>
        </xsl:template>
        
        <xsl:template name="rdg-content">
            <xsl:param name="parent-rdg"/>
            <xsl:element name="span">
                <xsl:choose>
                    <xsl:when test="$parent-rdg='no' or $parent-rdg='yes-inline'">
                        <xsl:attribute name="class">reading-line<xsl:choose><xsl:when test="descendant-or-self::tei:lacunaStart"><xsl:text> rdg-lacunaStart</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionStart']"> rdg-omissionStart<xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:lacunaEnd"><xsl:text> rdg-lacunaEnd</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionEnd']"> rdg-omissionEnd<xsl:value-of select="@wit"/></xsl:when></xsl:choose>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$parent-rdg='yes-bottom'">
                        <xsl:attribute name="class">bottom-reading-line</xsl:attribute>
                        <xsl:text>, </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:element name="span">
                    <xsl:attribute name="class">app-rdg</xsl:attribute>
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:text>translit </xsl:text>
                            <xsl:if test="@rend='check'">
                                <xsl:text> mark</xsl:text>
                            </xsl:if>
                            <xsl:if test="@rend='unmetrical'">
                                <xsl:text> unmetrical</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="tei:gap[@reason='omitted']">
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                    <xsl:attribute name="style">color:black;</xsl:attribute>
                                    <xsl:text>om.</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::tei:gap[@reason='lost'and not(@quantity|@unit)]">
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                    <xsl:attribute name="style">color:black;</xsl:attribute>
                                    <xsl:text>lac.</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::tei:lacunaEnd or child::tei:span[@type='omissionEnd']">...]</xsl:when>
                        </xsl:choose>
                        
                        <xsl:if test="$parent-rdg='no'">
                            <xsl:apply-templates/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="child::tei:lacunaStart or child::tei:span[@type='omissionStart']">[...</xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
                <xsl:text> </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="class">font-weight-bold <xsl:if test="following-sibling::*[local-name()='witDetail'] or ./@varSeq"> supsub</xsl:if></xsl:attribute>
                    <xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="./@wit"/>
                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                        <xsl:with-param name="wit-hand" select="./@hand"/>
                    </xsl:call-template>
                    <xsl:if test="./@varSeq">
                        <xsl:choose>
                            <xsl:when test="./@varSeq='1'">
                                <xsl:element name="sub">
                                    <xsl:text>ac</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="./@varSeq='2'">
                                <xsl:element name="sub">
                                    <xsl:text>pc</xsl:text>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="./@source">
                        <xsl:call-template name="source-siglum">
                            <xsl:with-param name="string-to-siglum" select="./@source"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:element>
                <xsl:if test="./@cause and $parent-rdg='no'">
                    <xsl:element name="span">
                        <xsl:attribute name="style">color:black;</xsl:attribute>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="replace(./@cause, '_', ' ')"/>
                        <xsl:text>)</xsl:text>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$parent-rdg='yes-bottom' or $parent-rdg='yes-inline'">
                    <xsl:element name="span">
                        <xsl:attribute name="style">color:black;</xsl:attribute>
                        <xsl:text> (larger gap)</xsl:text>
                    </xsl:element>
                </xsl:if>
                
                <!--<xsl:if test="./following-sibling::tei:rdg">
                                <xsl:text>; </xsl:text>
                            </xsl:if>-->
                
            </xsl:element>
        </xsl:template>
        
        <!-- vérifier la présence de tous les témoins -->
        <!-- exclusion pour les witDetail, les parallèles et les app "nested" -->
        <!-- tentative de nettoyer le plus rapidement possible les fichiers d'Aditia. Il faudra les faire après -->
        <!-- <sch:pattern>
        <sch:rule context="t:app[not(.[descendant-or-self::lacunaStart]/following-sibling::*|.[descendant-or-self::lacunaStart]/following::lacunaEnd[1]/preceding-sibling::*)]">
            <!-\- on compte les témoins déclarés-\->
            <sch:let name="witnesses-list" value="count(//t:TEI//t:listWit/t:witness/@xml:id)"/>
            <sch:let name="witnesses-app" value="count(tokenize(string-join(./t:*[not(t:witDetail)]/@wit, ' '), '\s'))"/>            
            <sch:assert test="$witnesses-app = $witnesses-list">every apparatus entry should have the same number of witnesses as declared in the teiHeader</sch:assert>
        </sch:rule>
    </sch:pattern>-->
        
        <!-- règles de validation pour les witDetails -->
        <!-- compte le nombre de witDetail + 1. Cet ajout correspond à la prise en compte du dédoublement du même témoin en raison du pc et du ac -->
        <!-- <sch:pattern>
        <sch:rule context="t:app[not(parent::t:listApp[@type='parallels'] or parent::t:lem or child::t:lem[@type] or (descendant-or-self::t:lacunaStart/following-sibling::*|descendant-or-self::t:lacunaStart/following::t:lacunaEnd[1]/preceding-sibling::*)) and child::t:witDetail]">
            <!-\- on compte les témoins déclarés-\->
            <sch:let name="witnesses-list" value="count(//t:TEI//t:listWit/t:witness/@xml:id)"/>
            <sch:let name="count-witdetail" value="count(./t:witDetail) + 1"/>
            <sch:let name="witnesses-app" value="count(tokenize(string-join(./*/@wit, ' '), '\s'))"/>            
            <sch:assert test="$witnesses-app - $count-witdetail = $witnesses-list">This entry with witDetail shouldn't have more than witnesses declared in the teiHeader</sch:assert>
        </sch:rule>
    </sch:pattern>-->
        
        <!-- <sch:pattern>
        <sch:rule context="t:app[descendant-or-self::t:lacunaStart/following-sibling::*|descendant-or-self::t:lacunaStart/following::t:lacunaEnd[1]/preceding-sibling::*]">
            <sch:let name="witnesses-list" value="count(//t:TEI//t:listWit/t:witness/@xml:id)"/>
            <sch:let name="witnesses-app" value="count(tokenize(string-join(./t:*[not(t:witDetail)]/@wit, ' '), '\s'))"/> 
            <sch:assert test="$witnesses-app - 1 = $witnesses-list">This entry inside a lacuna should have one witness less than declared than in the teiHeader</sch:assert>            
        </sch:rule>
    </sch:pattern>-->
        <!-- xpath selecting the content between lacunaStart and lacunaEnd -->
        <!-- .[descendant-or-self::lacunaStart]/following-sibling::*|.[descendant-or-self::lacunaStart]/following::lacunaEnd[1]/preceding-sibling::* -->
        <!-- Xpath selection le point de départ et le point d'arrivée -->
        <!-- .[descendant-or-self::lacunaStart]/following::*/descendant-or-self::lacunaEnd[1]|.[descendant-or-self::lacunaStart]/following::lacunaEnd[1]/preceding::*/descendant-or-self::lacunaStart[1] -->
        
</xsl:stylesheet>
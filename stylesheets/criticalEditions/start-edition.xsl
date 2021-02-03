<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0"
    exclude-result-prefixes="tei xi fn">
    <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0"/>
    
    <!-- Coded initially written by Andrew Ollet, for DHARMA Berlin workshop in septembre 2020 -->
    <!-- Updated and reworked for DHARMA by Axelle Janiak, starting 2021 -->
    
    <xsl:variable name="script">
        <xsl:value-of
            select="substring-after(//tei:profileDesc/tei:langUsage/tei:language/@ident, '-')"/>
    </xsl:variable>
    
    
    <xsl:template name="dharma-head">
        <xsl:variable name="title">
            <xsl:if test="//tei:titleStmt/tei:title/text()">
                <xsl:if test="//tei:idno[@type='filename']/text()">
                    <xsl:value-of select="//tei:idno[@type='filename']"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:value-of select="//tei:titleStmt/tei:title"/>
            </xsl:if>
        </xsl:variable>
            <head>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
               
                <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                    <!-- Bootstrap CSS -->
                    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
                    <!-- site-specific css !-->
                    <link rel="stylesheet" href="https://gitcdn.link/repo/erc-dharma/project-documentation/master/stylesheets/criticalEditions/dharma-ms.css"/>
                </meta>
            </head>
    </xsl:template>
    
    <xsl:template name="dharma-script">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
        <script src="https://gitcdn.link/repo/erc-dharma/project-documentation/master/stylesheets/criticalEditions/loader.js"/>
    </xsl:template>
            
    <xsl:template match="/tei:TEI">
        <xsl:element name="html">
        <xsl:call-template name="dharma-head"/>
        <xsl:element name="body">
        <xsl:apply-templates select="./tei:teiHeader"/>
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col</xsl:attribute>
                <xsl:apply-templates select="./tei:text"/>
                <xsl:apply-templates select=".//tei:listWit"/>
                <xsl:apply-templates select=".//tei:app" mode="modals"/>
                <xsl:call-template name="tpl-apparatus"/>
            </xsl:element>
        </xsl:element>
            <xsl:call-template name="dharma-script"/>
        </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  teiHeader ! -->
    <xsl:template match="tei:teiHeader">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col text-center my-5</xsl:attribute>
                <xsl:element name="h1">
                    <xsl:attribute name="class">display-5</xsl:attribute>
                    <xsl:value-of select="./tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                </xsl:element>
                <xsl:element name="h2">
                    <xsl:attribute name="class">display-5</xsl:attribute>
                    <xsl:value-of select="./tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                </xsl:element>
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:author">
                    <xsl:element name="p">
                        <xsl:attribute name="class">mb-3</xsl:attribute>
                        <xsl:text>of</xsl:text>
                    </xsl:element>
                    <xsl:element name="h1">
                        <xsl:attribute name="class">display-6</xsl:attribute>
                        <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:author"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:editor">
                    <xsl:element name="h1">
                        <xsl:attribute name="class">display-6</xsl:attribute>
                        <xsl:text>Edited by</xsl:text>
                        <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:editor"/>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  text ! -->
    <xsl:template match="tei:text">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col mx-5</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="id">modals</xsl:attribute>
                <xsl:call-template name="build-modals"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  A ! -->
    <!--  add ! -->
    <xsl:template match="tei:add">
        <xsl:element name="a">
            <xsl:attribute name="class">ed-insertion</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">Editorial insertion.</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  app ! -->
    <xsl:template match="tei:app" mode="modals">
        <xsl:variable name="apparatus">
            <xsl:element name="span">
                <xsl:element name="span">
                    <xsl:attribute name="class">mb-1 lemma-line</xsl:attribute>
                    <xsl:element name="span">
                        <xsl:attribute name="class">app-lem</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>translit </xsl:text>
                                <xsl:value-of select="$script"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="tei:lem"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:if test="tei:lem/@*">
                        <!--<xsl:text>] </xsl:text>-->
                        <xsl:choose>
                            <xsl:when test="tei:lem/@type">
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="apparatus-type"/>
                            </xsl:when>
                            <xsl:when test="tei:lem/@wit">
                                <xsl:element name="b">
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="tei:lem/@wit"/>
                                </xsl:call-template>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:element>
                <!--  Variant readings ! -->
                <xsl:if test="tei:rdg">
                    <xsl:element name="hr"/>
                    <xsl:for-each select="tei:rdg">
                        <xsl:element name="span">
                            <xsl:attribute name="class">reading-line</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">app-rdg</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">
                                        <xsl:text>translit </xsl:text>
                                        <xsl:value-of select="$script"/>
                                    </xsl:attribute>  
                                            <xsl:choose>
                                                <xsl:when test="not(text())">
                                                    <xsl:text>om.</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                </xsl:element>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                                <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="./@wit"/>
                            </xsl:call-template></xsl:element>
                            <!--<xsl:if test="./following-sibling::tei:rdg">
                                <xsl:text>; </xsl:text>
                            </xsl:if>-->
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
                <!--  Notes ! -->
                <xsl:if test="tei:note">
                    <xsl:element name="hr"/>
                    <xsl:for-each select="tei:note">
                        <xsl:element name="span">
                            <xsl:attribute name="class">note-line</xsl:attribute>
                            <xsl:apply-templates select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
            </xsl:element>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:app">
        <xsl:param name="location"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="1"/>
        </xsl:variable>
        <xsl:element name="span"> 
            <xsl:attribute name="class">lem</xsl:attribute>
            <xsl:element name="a">
            <xsl:attribute name="tabindex">0</xsl:attribute>
            <xsl:attribute name="data-toggle">popover</xsl:attribute>
            <xsl:attribute name="data-html">true</xsl:attribute>
            <xsl:attribute name="data-target">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="title">Apparatus <xsl:value-of select="substring-after($app-num, 'app')"/></xsl:attribute>
            <xsl:apply-templates select="tei:lem"/>    
                    
                    </xsl:element>
        </xsl:element>
        
        <xsl:element name="div">
            <xsl:attribute name="class">float-right</xsl:attribute>
        <xsl:element name="span">
            <xsl:attribute name="class">tooltipApp</xsl:attribute>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>#to-app-</xsl:text>
                    <xsl:value-of select="$app-num"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>from-app-</xsl:text>
                    <xsl:value-of select="$app-num"/>
                </xsl:attribute>           
                    <xsl:text>&#128172;</xsl:text>
            </a>
        </xsl:element>
        </xsl:element>
        
    </xsl:template>
    <!--  C ! -->
    <!--  caesura ! -->
    <xsl:template match="tei:caesura">
        <xsl:element name="span">
            <xsl:attribute name="class">caesura</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!--  choice ! -->
    <xsl:template match="tei:choice[@type = 'chaya']">
        <xsl:element name="span">
            <xsl:attribute name="class">prakritword san</xsl:attribute>
            <xsl:apply-templates select="tei:orig"/>
        </xsl:element>
        <xsl:element name="span">
            <xsl:attribute name="class">sanskritword san</xsl:attribute>
            <xsl:apply-templates select="tei:reg"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:choice[@type = 'chaya']" mode="in-modal">
        <xsl:element name="span">
            <xsl:attribute name="class">prakritword san</xsl:attribute>
            <xsl:apply-templates select="tei:orig"/>
        </xsl:element>
    </xsl:template>
    <!--  D ! -->
    <!--  div ! -->
    <xsl:template match="tei:div[@type = 'chapter']">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-1 text-center</xsl:attribute>
                <xsl:element name="p">
                    <xsl:value-of select="@n"/>
                    <xsl:text>. </xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-11</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="./following-sibling::tei:div">
            <xsl:element name="hr"/>
        </xsl:if>
    </xsl:template>
    <!--  F ! -->
    <!--  foreign ! -->
    <xsl:template match="tei:foreign">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>translit </xsl:text>
                <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  G ! -->
    <xsl:template match="tei:gap">
        <xsl:element name="span">
            <xsl:attribute name="class">gap</xsl:attribute>
            <xsl:if test="@quantity > 6">
                <xsl:text> — — — </xsl:text>
                <xsl:value-of select="@quantity"/>
                <xsl:choose>
                    <xsl:when test="@unit = 'character'">
                        <xsl:element name="i">
                            <xsl:text> akṣaras</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> — — — </xsl:text>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!--  H ! -->
    <!--  head ! -->
    <xsl:template match="tei:head">
        <xsl:element name="p">
            <xsl:attribute name="class">
                <xsl:text>translit </xsl:text>
                <xsl:value-of select="$script"/>
            </xsl:attribute>
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  L ! -->
    <!--  l ! -->
    <xsl:template match="tei:l">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>l translit </xsl:text>
                <xsl:value-of select="$script"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  lb ! -->
    <xsl:template match="tei:lb">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted lineation</xsl:attribute>
            <xsl:value-of select="@n"/>
        </xsl:element>
    </xsl:template>
    <!--  lg ! -->
    <xsl:template match="tei:lg">
        <xsl:element name="div">
            <xsl:attribute name="class">row mt-2</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col</xsl:attribute>
                <xsl:if test="@met">
                    <xsl:element name="div">
                        <xsl:attribute name="class">float-center</xsl:attribute>
                        <xsl:element name="small">
                            <xsl:element name="span">
                                <xsl:attribute name="class">text-muted</xsl:attribute>
                                <xsl:value-of select="@met"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="ancestor::tei:item">
                    <xsl:element name="div">
                        <xsl:attribute name="class">float-center</xsl:attribute>
                        <xsl:element name="small">
                            <xsl:element name="span">
                                <xsl:attribute name="class">text-muted</xsl:attribute>
                                <xsl:value-of select="substring-after(ancestor::tei:item/@corresp, 'txt:')"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="div">
                    <xsl:attribute name="class">lg</xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:lg" mode="in-modal">
        <xsl:element name="div">
            <xsl:attribute name="class">lg</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  listWit ! -->
    <xsl:template match="tei:listWit">
        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">List of Witnesses</xsl:element>
            <xsl:element name="ul">
                <xsl:for-each select="tei:witness">
                    <xsl:element name="li">
                        <xsl:element name="a">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="b">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:element>
                        <xsl:text>: </xsl:text>
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  N ! -->
    <!--  name ! -->
    <xsl:template match="tei:name">
        <xsl:element name="span">
            <xsl:attribute name="class">name san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  note ! -->
    <xsl:template match="tei:note[@type = 'reference']">
        <xsl:element name="span">
            <xsl:attribute name="class">san reference</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  P ! -->
    <!--  p ! -->
    <xsl:template match="tei:p">
        <xsl:variable name="p-num">
            <xsl:number level="single" format="1"/>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:attribute name="class">float-left</xsl:attribute>
            <xsl:element name="span">
                <xsl:attribute name="class">text-muted</xsl:attribute>
                <xsl:value-of select="ancestor::tei:div[@type = 'chapter']/@n"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$p-num"/>
            </xsl:element>
            </xsl:element>
        <br/>
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
        
    </xsl:template>
    <xsl:template match="tei:pb">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted foliation</xsl:attribute>
            <xsl:value-of select="@n"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:pc">
        <xsl:element name="span">
            <xsl:attribute name="class">danda</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  Q ! -->
    <!--  q ! -->
    <xsl:template match="tei:q[@type = 'lemma']">
        <xsl:element name="b">
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:text>translit </xsl:text>
                    <xsl:value-of select="$script"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  quote ! -->
    <xsl:template match="tei:quote">
        <xsl:choose>
            <!-- A priori pas dans DHARMA -->
            <xsl:when test="tei:quote[@type = 'base-text']">
                <xsl:element name="div">
            <xsl:attribute name="class">base-text</xsl:attribute>
            <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="tei:quote[ancestor::tei:list]">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:app">
                <xsl:text>“</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>” </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:q">
        <xsl:text>‘</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>’</xsl:text>
    </xsl:template>
    <!--  R ! -->
    <xsl:template match="tei:text[@xml:id = 'RaMa']//tei:ref">
        <xsl:element name="span">
            <xsl:attribute name="class">ref san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:teiHeader//tei:ref">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  S ! -->
    <!--  s ! -->
    <xsl:template match="tei:s">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>s translit </xsl:text>
                <xsl:value-of select="$script"/>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:s" mode="in-modal">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <!--  sp ! -->
    <xsl:template match="tei:sp">
        <xsl:element name="div">
            <xsl:attribute name="class">row sp</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-sm-3</xsl:attribute>
                <xsl:apply-templates mode="bypass" select="tei:speaker"/>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-sm-9</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  speaker ! -->
    <xsl:template match="tei:speaker"/>
    <xsl:template match="tei:speaker" mode="bypass">
        <xsl:element name="span">
            <xsl:attribute name="class">speaker san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  stage ! -->
    <!--  case one: it is not contained within a character’s
       lines ! -->
    <xsl:template match="tei:stage[not(ancestor::tei:sp)]">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-sm-12 clearfix</xsl:attribute>
                <xsl:call-template name="button-group">
                    <xsl:with-param name="id" select="@xml:id"/>
                </xsl:call-template>
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>stage san text-center</xsl:text>
                        <xsl:if test="@type = 'division'"> stage-division</xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  case two: it is contained within a characters’ lines ! -->
    <xsl:template match="tei:sp//tei:stage">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>stage san stage-sp</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:stage" mode="in-modal">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <!--  SUPPLIED ! -->
    <xsl:template match="tei:supplied">
        <xsl:element name="a">
            <xsl:attribute name="class">text-muted supplied</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">Supplied by the editor.</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  T ! -->
    <!--  TEI ! -->
    <xsl:template match="tei:TEI">
        <xsl:element name="div">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  title ! -->
    <xsl:template match="tei:title">
        <xsl:element name="span">
            <xsl:attribute name="class">title san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  W ! -->
    <xsl:template match="tei:w">
        <xsl:element name="span">
            <xsl:attribute name="class">word</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  BUTTON-GROUP ! -->
    <!--  button group to the right of each verse or paragraph ! -->
    <xsl:template name="button-group">
        <xsl:param name="id"/>
        <!--  the ID of the verse or paragraph ! -->
        <xsl:param name="met"/>
        <!--  the meter, if identified ! -->
        <xsl:element name="div">
            <xsl:attribute name="class">float-right</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">btn-group</xsl:attribute>
                <!--  if the button refers to a meter ! -->
                <xsl:if test="$met != ''">
                    <xsl:variable name="target">
                        <xsl:value-of
                            select="//tei:TEI//tei:metDecl/tei:p[@xml:id = $met]/tei:ptr/@target"/>
                    </xsl:variable>
                    <xsl:element name="a">     
                        <xsl:attribute name="href">javascript:void(0)</xsl:attribute>
                        <xsl:attribute name="role">button</xsl:attribute>
                        <xsl:attribute name="class">btn btn-secondary btn-sm met-btn</xsl:attribute>
                        <xsl:attribute name="data-toggle">popover</xsl:attribute>
                        <xsl:attribute name="data-title">Meter</xsl:attribute>
                        <xsl:attribute name="data-trigger">hover</xsl:attribute>
                        <xsl:attribute name="data-placement">left</xsl:attribute>
                        <xsl:attribute name="data-content">
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$target"/>
                                </xsl:attribute>
                                <xsl:value-of select="$met"/>
                            </xsl:element>
                            <!--<xsl:text><a href="</xsl:text>
                            <xsl:value-of select="$target"/>
                            <xsl:text>"></xsl:text>
                            <xsl:value-of select="$met"/>
                            <xsl:text></a></xsl:text>-->
                        </xsl:attribute>
                        <xsl:text>M</xsl:text>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="//tei:text[@xml:id = 'RaMa']//*[@corresp = $id]">
                    <xsl:variable name="target">
                        <xsl:text>#modal-</xsl:text>
                        <xsl:value-of select="translate(translate($id, 'ā', 'a'), '.', '-')"/>
                        <xsl:text>-rasamanjari</xsl:text>
                    </xsl:variable>
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$target"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-toggle">modal</xsl:attribute>
                        <xsl:attribute name="class">btn btn-default btn-sm
                            modal-toggle</xsl:attribute>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="$target"/>
                        </xsl:attribute>
                        <xsl:text>R</xsl:text>
                    </xsl:element>
                </xsl:if>
                <!--  if ... ! -->
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  BUILD-MODALS ! -->
    <xsl:template name="build-modals">
        <!--  i assume for these purposes that every modal
	 will have its own separate division in the document.
	 the rasamañjarī will be divided into divisions
	 that each have a @corresp attribute. ! -->
        <xsl:for-each select="//tei:text[@xml:id = 'RaMa']//tei:div[@corresp]">
            <xsl:variable name="corresp">
                <xsl:value-of select="@corresp"/>
            </xsl:variable>
            <xsl:variable name="reference">
                <xsl:value-of select="translate(translate(@corresp, 'ā', 'a'), '.', '-')"/>
            </xsl:variable>
            <xsl:variable name="number-citation">
                <xsl:value-of select="substring-after(@corresp, '.')"/>
            </xsl:variable>
            <xsl:variable name="this-modal-name">
                <xsl:text>modal-</xsl:text>
                <xsl:value-of select="$reference"/>
                <xsl:text>-rasamanjari</xsl:text>
            </xsl:variable>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$this-modal-name"/>
                </xsl:attribute>
                <xsl:attribute name="class">modal fade text-left</xsl:attribute>
                <xsl:attribute name="tabindex">-1</xsl:attribute>
                <xsl:attribute name="role">dialog</xsl:attribute>
                <xsl:attribute name="aria-labelledby">
                    <xsl:text>modal-</xsl:text>
                    <xsl:value-of select="$reference"/>
                    <xsl:text>-label</xsl:text>
                </xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">modal-dialog modal-lg</xsl:attribute>
                    <xsl:attribute name="role">document</xsl:attribute>
                    <!--  MODAL CONTENT ! -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">modal-content</xsl:attribute>
                        <!--  MODAL HEADER ! -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">modal-header</xsl:attribute>
                            <button type="button" class="close modal-close" aria-label="Close">
                                <span aria-hidden="true">
                                    <xsl:text>×</xsl:text>
                                </span>
                            </button>
                            <h3 id="modal-{$reference}-label">
                                <em>Rasamañjarī</em>
                                <xsl:text> on </xsl:text>
                                <em>Mālatīmādhava</em>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$number-citation"/>
                            </h3>
                        </xsl:element>
                        <!--  MODAL BODY ! -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">modal-body</xsl:attribute>
                            <!--  the verse or paragraph or stage direction
		   to which this modal is attached. ! -->
                            <xsl:element name="div">
                                <xsl:attribute name="class"> modal-quote san <xsl:value-of
                                    select="local-name()"/> </xsl:attribute>
                                <xsl:apply-templates
                                    select="//tei:text[@xml:id = 'MāMā']//tei:*[@xml:id = $corresp]"
                                    mode="in-modal"/>
                            </xsl:element>
                            <!--  THE CONTENT OF EACH TAB ! -->
                            <xsl:apply-templates select="." mode="bypass"/>
                        </xsl:element>
                        <!--  MODAL FOOTER ! -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">modal-footer</xsl:attribute>
                            <button type="button" class="btn btn-primary modal-close">Close</button>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!--  REFERENCE ! -->
    <xsl:template name="reference">
        <xsl:param name="n1"/>
        <xsl:param name="n2"/>
        <xsl:param name="n3"/>
        <xsl:param name="style"/>
        <xsl:variable name="separator">
            <xsl:choose>
                <xsl:when test="$style = 'dashes'">
                    <xsl:text>-</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="workTitle">
            <xsl:choose>
                <xsl:when test="$style = 'dashes'">
                    <xsl:call-template name="work-abbrev">
                        <xsl:with-param name="encoding" select="'ASCII'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="work-abbrev">
                        <xsl:with-param name="encoding" select="'UTF8'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--  construct the reference starting backwards ! -->
        <xsl:value-of select="$workTitle"/>
        <xsl:if test="$n1 != ''">
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="translate($n1, '.', $separator)"/>
        </xsl:if>
        <xsl:if test="$n2 != ''">
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="translate($n2, '.', $separator)"/>
        </xsl:if>
        <xsl:if test="$n3 != ''">
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="translate($n3, '.', $separator)"/>
        </xsl:if>
    </xsl:template>
    <!--  WORK-ABBREV ! -->
    <xsl:template name="work-abbrev">
        <xsl:param name="encoding"/>
        <xsl:choose>
            <xsl:when test="$encoding = 'ASCII'">
                <xsl:text>MaMa</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>MāMā</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--  NAMED TEMPLATES ! -->
    <xsl:template name="tokenize-witness-list">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="contains($string, ' ')">
                <xsl:variable name="first-item"
                    select="translate(normalize-space(substring-before($string, ' ')), '#', '')"/>
                <xsl:if test="$first-item">
                    <xsl:call-template name="make-bibl-link">
                        <xsl:with-param name="target" select="$first-item"/>
                    </xsl:call-template>
                    <xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="substring-after($string, ' ')"/>
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
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--  Make bibliography link ! -->
    <xsl:template name="make-bibl-link">
        <xsl:param name="target"/>
        <xsl:element name="a">
            <xsl:attribute name="class">siglum</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$target"/>
            </xsl:attribute>
            <xsl:value-of select="$target"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@* | text() | comment()" mode="copy">
        <xsl:copy/>
    </xsl:template>
    

  <xsl:template name="tpl-apparatus">
    <!-- An apparatus is only created if one of the following is true -->
    <xsl:if
      test=".//tei:choice | .//tei:subst | .//tei:app">

        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">Apparatus</xsl:element>
                
      <div id="apparatus">
        <!-- An entry is created for-each of the following instances
                  * choice, subst or app not nested in another;
                  * hi not nested in the app part of an app;
                  * del or milestone.
        -->
        <xsl:for-each
          select="(.//tei:choice | .//tei:subst | .//tei:app)[not(ancestor::tei:*[local-name()=('choice','subst','app')])] |.//tei:hi[not(ancestor::tei:*[local-name()=('orig','reg','sic','corr','lem','rdg')
               or self::tei:del
               or self::tei:add][1][local-name()=('reg','corr','rdg')
               or self::tei:del])]| .//tei:del | .//tei:milestone">

          <!-- Found in tpl-apparatus.xsl -->
          <xsl:call-template name="dharma-app">
            <xsl:with-param name="apptype">
              <xsl:choose>
                <xsl:when test="self::tei:choice[child::tei:orig and child::tei:reg]">
                  <xsl:text>origreg</xsl:text>
                </xsl:when>
                <xsl:when test="self::tei:choice[child::tei:sic and child::tei:corr]">
                  <xsl:text>siccorr</xsl:text>
                </xsl:when>
                <xsl:when test="self::tei:subst">
                  <xsl:text>subst</xsl:text>
                </xsl:when>
                <xsl:when test="self::tei:app">
                  <xsl:text>app</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </div>
        </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- called from tpl-apparatus.xsl -->
  <xsl:template name="lbrk-app">
    <br/>
  </xsl:template>

  <!-- Used in htm-{element} and above to add linking to and from apparatus -->
  <xsl:template name="app-link">
    <!-- location defines the direction of linking -->
    <xsl:param name="location"/>
    <!-- Does not produce links for translations -->
     <xsl:if
        test="not((local-name() = 'choice' or local-name() = 'subst' or local-name() = 'app')
         and (ancestor::tei:choice or ancestor::tei:subst or ancestor::tei:app))">
        <xsl:variable name="app-num">
        <xsl:value-of select="name()"/>
          <xsl:number level="any" format="1"/>
        </xsl:variable>
         <a>
             <xsl:attribute name="id">
                 <xsl:text>to-app-</xsl:text>
                 <xsl:value-of select="$app-num"/>
             </xsl:attribute>
             <xsl:attribute name="href">
                 <xsl:text>#from-app-</xsl:text>
                 <xsl:value-of select="$app-num"/>
             </xsl:attribute>
             <xsl:text>^</xsl:text>
             <xsl:value-of select="substring-after($app-num, 'app')"/>
         </a>
    </xsl:if>
  </xsl:template>

    <xsl:template name="dharma-app">
        <xsl:param name="apptype"/>
        <xsl:variable name="childtype">
            <xsl:choose>
                <xsl:when test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice[child::tei:orig and child::tei:reg]">
                    <xsl:text>origreg</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice[child::tei:sic and child::tei:corr]">
                    <xsl:text>siccorr</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:subst">
                    <xsl:text>subst</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:app">
                    <xsl:text>app</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('note')]/tei:app"/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="div-loc">
            <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
                <xsl:value-of select="@n"/>
                <xsl:text>.</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(ancestor::tei:choice or ancestor::tei:subst or ancestor::tei:app)">
                <!-- either <br/> in htm-tpl-apparatus or \r\n in txt-tpl-apparatus -->
                <xsl:call-template name="lbrk-app"/>
                <!-- in htm-tpl-apparatus.xsl or txt-tpl-apparatus.xsl -->
                <xsl:call-template name="app-link">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:call-template>
                <xsl:value-of select="$div-loc"/>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>:&#x202F;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <span class="app">
            <xsl:choose>
                <xsl:when test="local-name()=('choice','subst','app')">
                    <!-- if there are more app elements inside the text part of the element, deal with them here -->
                    <xsl:variable name="part1">
                        <xsl:if
                            test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:*[local-name()=('choice','subst','app')]">
                            <!-- <xsl:call-template name="txPtchild"> -->
                            <xsl:call-template name="appcontent">
                                <!-- template txPtchild below -->
                                <xsl:with-param name="apptype" select="$apptype"/>
                                <xsl:with-param name="childtype" select="$childtype" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="part2">
                        <xsl:if
                            test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:*[local-name()=('choice','subst','app')]">
                            <xsl:call-template name="nonTxPtchild">
                                <!-- template nonTxPtchild below -->
                                <xsl:with-param name="apptype" select="$apptype"/>
                                <xsl:with-param name="childtype" select="$childtype" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:variable>
                    <!-- generate the main content of the app here -->
                    <xsl:variable name="part3">
                        <xsl:call-template name="appcontent">
                            <xsl:with-param name="apptype" select="$apptype"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="part4">
                        <xsl:call-template name="nonTxPtchild">
                            <xsl:with-param name="apptype" select="$apptype"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="titleagg">
                        
                        <xsl:choose>
                            <xsl:when test="$apptype='app'">
                                
                                <xsl:choose>
                                    <xsl:when test="($childtype = '' and normalize-space($part4) = '') or ($childtype != '' and normalize-space($part2) = '')"><xsl:call-template name="fnord-seperator">
                                        <xsl:with-param name="part"><xsl:value-of select="$part3" /></xsl:with-param>
                                        <xsl:with-param name="pos">first</xsl:with-param>
                                    </xsl:call-template></xsl:when>
                                    <xsl:when test="contains($part3, ' : ') and lem/@resp"><xsl:value-of select="substring-before($part3, ' :')"/></xsl:when>
                                    <xsl:otherwise>Current edition</xsl:otherwise>
                                </xsl:choose>
                                
                                <!-- <xsl:if test="starts-with(normalize-space($part3), 'cf.')"> which</xsl:if> -->
                                
                                <xsl:choose>
                                    <xsl:when test="$childtype='subst'"> reports </xsl:when>
                                    <xsl:otherwise> gives </xsl:otherwise>
                                </xsl:choose>
                                
                                
                                <xsl:choose>
                                    <xsl:when test="$childtype = 'subst'"><xsl:value-of select="normalize-space($part1)" />, then changed to <xsl:value-of select="normalize-space($part2)" /></xsl:when>
                                    <xsl:when test="$childtype != ''"><xsl:value-of select="normalize-space($part2)" /><xsl:text>, </xsl:text><xsl:value-of select="normalize-space($part1)" /></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="normalize-space($part4)"/></xsl:otherwise>
                                </xsl:choose><xsl:call-template name="fnord-seperator">
                                    <xsl:with-param name="part"><xsl:value-of select="$part3" /></xsl:with-param>
                                    <xsl:with-param name="pos">second</xsl:with-param>
                                </xsl:call-template>
                                
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains($part3, 'FNORD-SPLIT') and contains($part1, 'FNORD-SPLIT') and $childtype != ''">
                                        <xsl:call-template name="childpart">
                                            <xsl:with-param name="childtype"><xsl:value-of select="$childtype" /></xsl:with-param>
                                            <xsl:with-param name="apptype"><xsl:value-of select="$apptype" /></xsl:with-param>
                                            <xsl:with-param name="part1"><xsl:value-of select="$part1" /></xsl:with-param>
                                            <xsl:with-param name="part2"><xsl:value-of select="$part2" /></xsl:with-param>
                                        </xsl:call-template><xsl:call-template name="fnord-seperator">
                                            <xsl:with-param name="part"><xsl:value-of select="$part3" /></xsl:with-param>
                                            <xsl:with-param name="pos">second</xsl:with-param>
                                        </xsl:call-template>
                                        
                                    </xsl:when>
                                    <xsl:when test="contains($part3, 'FNORD-SPLIT')">
                                        <xsl:choose>
                                            <xsl:when test="$childtype != ''"><xsl:value-of select="normalize-space($part2)" /><xsl:text> </xsl:text><xsl:value-of select="normalize-space($part1)" /><xsl:if test="not(ends-with(normalize-space($part1), ',')) and not($apptype = 'app' and $childtype = '')">,</xsl:if></xsl:when>
                                            <xsl:otherwise><xsl:if test="$apptype = 'app' and $childtype = ''">Scribe wrote</xsl:if> <xsl:value-of select="normalize-space($part4)"/><xsl:if test="not(ends-with(normalize-space($part4), ',')) and not($apptype = 'app' and $childtype = '')">,</xsl:if></xsl:otherwise>
                                        </xsl:choose><xsl:text> </xsl:text>
                                        
                                        
                                        <xsl:variable name="pt3">
                                            <xsl:call-template name="fnord-seperator">
                                                <xsl:with-param name="part"><xsl:value-of select="$part3" /></xsl:with-param>
                                                <xsl:with-param name="pos">first</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        
                                        <xsl:choose>
                                            <xsl:when test="$apptype = 'app'">
                                                <xsl:choose>
                                                    <xsl:when test="contains($part3, 'l.')"><xsl:text>, </xsl:text><xsl:value-of select="normalize-space(substring-after(substring-before($part3, ')(*)'), ' ('))"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(substring-before($part3, ' ('))"/></xsl:when>
                                                    <xsl:otherwise><xsl:value-of select="normalize-space($part3)"/></xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise><xsl:if test="$apptype='origreg'">for which </xsl:if><xsl:value-of select="$pt3" /></xsl:otherwise>
                                        </xsl:choose>
                                        
                                        
                                    </xsl:when>
                                    <xsl:when test="contains($part1, 'FNORD-SPLIT')">
                                        <xsl:call-template name="childpart">
                                            <xsl:with-param name="childtype"><xsl:value-of select="$childtype" /></xsl:with-param>
                                            <xsl:with-param name="apptype"><xsl:value-of select="$apptype" /></xsl:with-param>
                                            <xsl:with-param name="part1"><xsl:value-of select="$part1" /></xsl:with-param>
                                            <xsl:with-param name="part2"><xsl:value-of select="$part2" /></xsl:with-param>
                                        </xsl:call-template>
                                        
                                        <xsl:choose>
                                            <xsl:when test="contains($part3, 'l.') and $apptype = 'app'"><xsl:text>, </xsl:text><xsl:value-of select="normalize-space(substring-after(substring-before($part3, ')(*)'), ' ('))"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(substring-before($part3, ' ('))"/></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="normalize-space($part3)"/></xsl:otherwise>
                                        </xsl:choose>
                                        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="($apptype = ('app') and $childtype = '') or $childtype = ('app')">Scribe wrote </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="$childtype='subst'"><xsl:value-of select="normalize-space($part1)" />, then changed to <xsl:value-of select="normalize-space($part2)" /><xsl:if test="(not(ends-with(normalize-space($part2), ',')))">,</xsl:if></xsl:when>
                                            <xsl:when test="$childtype != ''"><xsl:value-of select="normalize-space($part2)" /><xsl:text> </xsl:text><xsl:value-of select="normalize-space($part1)" /><xsl:if test="(not(ends-with(normalize-space($part1), ',')) and $apptype != 'app')">,</xsl:if></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="normalize-space($part4)"/><xsl:if test="(not(ends-with(normalize-space($part4), ',')) and $apptype != 'app')">,</xsl:if></xsl:otherwise>
                                        </xsl:choose><xsl:text> </xsl:text>
                                        
                                        <xsl:choose>
                                            <xsl:when test="contains($part3, 'l.') and ($apptype = 'app' and $childtype != '')"><xsl:text>, </xsl:text><xsl:value-of select="normalize-space(substring-before($part3, ' ('))"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(substring-after(substring-before($part3, ')(*)'), ' ('))"/></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="normalize-space($part3)"/></xsl:otherwise>
                                        </xsl:choose>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  </xsl:if>  -->
                    </xsl:variable>
                   
                    <xsl:value-of select="normalize-space(replace(replace($part1, 'FNORD(\S)*', ''), '\(\*\)', ''))"/>
                    <xsl:if test="normalize-space($part1) != '' and (not(ends-with(normalize-space($part1), ','))) and (not(ends-with(normalize-space($part1), '.')))">,</xsl:if> <!--  --><xsl:text> </xsl:text><xsl:value-of select="normalize-space(replace(replace($part3, 'FNORD(\S)*', ''), '\(\*\)', ''))"/>
                   
                </xsl:when>
                <!-- hi -->
            </xsl:choose>
        </span>
    </xsl:template>
 
    <xsl:template name="appcontent">
        <!-- prints the content of apparatus; called by ddb-apparatus or by individual elements if nested -->
        <xsl:param name="apptype"/>
        <xsl:param name="childtype"/>
        <xsl:variable name="path">
            <xsl:choose>
                <xsl:when test="$childtype='origreg' or $childtype=('siccorr')">
                    <xsl:copy-of select="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice/child::*"/>
                </xsl:when>
                <xsl:when test="$childtype='subst'">
                    <xsl:copy-of select="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:subst/child::*"/>
                </xsl:when>
                <xsl:when test="$childtype='app'">
                    <xsl:copy-of select="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:app/child::*"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="parent-lang">
            <xsl:if test="(child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice/child::tei:reg[@xml:lang] and $childtype = 'origreg') or (child::tei:reg[@xml:lang] and $apptype = 'origreg')">
                <xsl:if test="$childtype = 'origreg'">
                    <xsl:value-of select="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice/child::tei:reg/ancestor::tei:*[@xml:lang][1]/@xml:lang" />
                </xsl:if>
                <xsl:if test="$apptype = 'origreg'">
                    <xsl:value-of select="child::tei:reg/ancestor::tei:*[@xml:lang][1]/@xml:lang" />
                </xsl:if>
            </xsl:if>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$childtype != '' and $apptype != $childtype">
                <xsl:call-template name="appchoice">
                    <xsl:with-param name="apptype"><xsl:value-of select="$childtype"/></xsl:with-param>
                    <xsl:with-param name="path">
                        <xsl:copy-of select="$path"/>
                    </xsl:with-param>
                    <xsl:with-param name="parent-lang"><xsl:value-of select="$parent-lang" /></xsl:with-param>
                </xsl:call-template><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="appchoice">
                    <xsl:with-param name="apptype"><xsl:value-of select="$apptype"/></xsl:with-param>
                    <xsl:with-param name="child"><xsl:if test="$childtype != ''">true</xsl:if></xsl:with-param>
                    <xsl:with-param name="path">
                        <xsl:copy-of select="$path"/>
                    </xsl:with-param>
                    <xsl:with-param name="parent-lang"><xsl:value-of select="$parent-lang" /></xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="nonTxPtchild">
        <!-- prints the other bit of apparatus content for apps nested in the part of an app not normally printed in edition -->
        <xsl:param name="apptype"/>
        <xsl:param name="childtype"/>
        
        <xsl:choose>
            <!-- *APPED* -->
            <xsl:when test="$apptype=('appbl','apppn','apped')">
                <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- *ORIG*  (repeatable) -->
            <xsl:when test="$childtype='origreg' or ($apptype='origreg' and $childtype='')">
                <xsl:text>for which read </xsl:text>
                <xsl:if test="$childtype != ''">
                    <xsl:for-each select="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice/tei:orig">
                        <xsl:sort select="position()" order="descending"/>
                        <!-- <xsl:value-of select="."/> -->
                        <xsl:apply-templates>
                            <xsl:with-param name="location" select="'apparatus'"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="$childtype = ''">
                    <xsl:for-each select="tei:orig">
                        <xsl:sort select="position()" order="descending"/>
                        <!-- <xsl:value-of select="."/> -->
                        <xsl:apply-templates>
                            <xsl:with-param name="location" select="'apparatus'"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <!-- *SIC* -->
            <xsl:when test="$childtype=('siccorr') or $apptype=('siccorr')">
                <xsl:text>((for which read)) </xsl:text>
                <xsl:choose>
                    <xsl:when test="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice/tei:sic/node()">
                        <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]/tei:choice/tei:sic/node()">
                            <xsl:with-param name="location" select="'apparatus'"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                            <xsl:with-param name="location" select="'apparatus'"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- *SUBST* -->
            <xsl:when test="$childtype=('subst') or $apptype=('subst')">
                <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- *APPALT* -->
            <xsl:when test="$childtype=('app') or $apptype=('app')">
                <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- *APPED* -->
            <xsl:when test="$childtype=('app')">
                <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:apply-templates>
            </xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text> <!---->
    </xsl:template>

    <xsl:template name="fnord-seperator">
        <xsl:param name="part" />
        <xsl:param name="pos" /><xsl:choose>
            <xsl:when test="contains($part, 'FNORD-SPLIT') and contains($part, ' :') and contains($part, ' FNORD-DELIM') and starts-with($part, 'l. ')">
                <xsl:for-each select="tokenize(substring-after($part, 'l. '), ' : ')">
                    <xsl:for-each select="tokenize(., ' FNORD-DELIM ')"><xsl:call-template name="fnord-spliter">
                        <xsl:with-param name="line">
                            <xsl:choose>
                                <xsl:when test="starts-with(normalize-space(.), 'FNORD-SPLIT')"><xsl:value-of select="substring-after(. , 'FNORD-SPLIT')" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="delim"><xsl:if test="$pos='second' or position() != 1">—</xsl:if></xsl:with-param>
                    </xsl:call-template></xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($part, 'FNORD-SPLIT') and contains($part, ' :') and starts-with($part, 'l. ')">
                <xsl:for-each select="tokenize(substring-after($part, 'l. '), ' : ')"><xsl:call-template name="fnord-spliter">
                    <xsl:with-param name="line">
                        <xsl:choose>
                            <xsl:when test="starts-with(normalize-space(.), 'FNORD-SPLIT')"><xsl:value-of select="substring-after(. , 'FNORD-SPLIT')" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="delim"><xsl:if test="$pos='second' or position() != 1">—</xsl:if></xsl:with-param>
                    <xsl:with-param name="tail">true</xsl:with-param></xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($part, 'FNORD-SPLIT') and contains($part, ' :') and contains($part, ' FNORD-DELIM')">
                <xsl:for-each select="tokenize($part, ' : ')"><xsl:for-each select="tokenize(., ' FNORD-DELIM ')"><xsl:call-template name="fnord-spliter">
                    <xsl:with-param name="line">
                        <xsl:choose>
                            <xsl:when test="starts-with(normalize-space(.), 'FNORD-SPLIT')"><xsl:value-of select="substring-after(. , 'FNORD-SPLIT')" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="delim"><xsl:if test="$pos='second' or position() != 1">—</xsl:if></xsl:with-param>
                </xsl:call-template></xsl:for-each></xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($part, 'FNORD-SPLIT') and contains($part, ' :')"><xsl:for-each select="tokenize($part, ' : ')"><xsl:call-template name="fnord-spliter">
                <xsl:with-param name="line">
                    <xsl:choose>
                        <xsl:when test="starts-with(normalize-space(.), 'FNORD-SPLIT')"><xsl:value-of select="substring-after(. , 'FNORD-SPLIT')" /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="delim"><xsl:if test="$pos='second' or position() != 1">—</xsl:if></xsl:with-param>
            </xsl:call-template></xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($part, 'FNORD-SPLIT') and contains($part, ' FNORD-DELIM') and starts-with($part, 'l. ')">
                <xsl:for-each select="tokenize(substring-after($part, 'l. '), ' FNORD-DELIM ')"><xsl:call-template name="fnord-spliter">
                    <xsl:with-param name="line">
                        <xsl:choose>
                            <xsl:when test="starts-with(normalize-space(.), 'FNORD-SPLIT')"><xsl:value-of select="substring-after(. , 'FNORD-SPLIT')" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="delim"><xsl:if test="$pos='second' or position() != 1">—</xsl:if></xsl:with-param>
                    <xsl:with-param name="tail">true</xsl:with-param>
                </xsl:call-template></xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($part, 'FNORD-SPLIT') and contains($part, ' FNORD-DELIM')">
                <xsl:for-each select="tokenize($part, ' FNORD-DELIM ')"><xsl:call-template name="fnord-spliter">
                    <xsl:with-param name="line">
                        <xsl:choose>
                            <xsl:when test="starts-with(normalize-space(.), 'FNORD-SPLIT')"><xsl:value-of select="substring-after(. , 'FNORD-SPLIT')" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="delim"><xsl:if test="$pos='second' or position() != 1">—</xsl:if></xsl:with-param>
                </xsl:call-template></xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($part, 'FNORD-SPLIT')"><xsl:call-template name="fnord-spliter">
                <xsl:with-param name="line">
                    <xsl:choose>
                        <xsl:when test="starts-with(normalize-space($part), 'FNORD-SPLIT')"><xsl:value-of select="substring-after($part , 'FNORD-SPLIT')" /></xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$part" /></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="delim"><xsl:if test="$pos='second'">—</xsl:if></xsl:with-param>
            </xsl:call-template></xsl:when>
            <xsl:when test="second">previous edition gave <xsl:value-of select="substring-after($part, ' :')"/></xsl:when>
        </xsl:choose></xsl:template>
    
    <xsl:template name="childpart">
        <xsl:param name="part2" />
        <xsl:param name="part1" />
        <xsl:param name="childtype" />
        <xsl:param name="apptype" />
        
        <xsl:choose><xsl:when test="normalize-space($part2) = ''"><xsl:call-template name="fnord-seperator">
            <xsl:with-param name="part"><xsl:value-of select="$part1" /></xsl:with-param>
            <xsl:with-param name="pos">first</xsl:with-param>
        </xsl:call-template></xsl:when>
            <xsl:when test="contains($part1, ' : ')"><xsl:value-of select="substring-before($part1, ' :')"/></xsl:when>
            <xsl:otherwise>Current edition</xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="normalize-space($part2) != ''">
            <xsl:if test="starts-with(normalize-space($part1), 'cf.')"> which</xsl:if>  gives <xsl:value-of select="normalize-space($part2)"/><xsl:text> </xsl:text>
        </xsl:if>
        
        <xsl:variable name="pt1"><xsl:call-template name="fnord-seperator">
            <xsl:with-param name="part"><xsl:value-of select="$part1" /></xsl:with-param>
            <xsl:with-param name="pos">second</xsl:with-param>
        </xsl:call-template>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="not($apptype = ('apped', 'appbl', 'apppn', 'app')) and $childtype = ('apped', 'appbl', 'apppn') and starts-with(normalize-space($pt1), '—')"><xsl:value-of select="normalize-space(substring-after($pt1, '—'))" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$pt1" /></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="appchoice">
        <xsl:param name="apptype" />
        <xsl:param name="child" />
        <xsl:param name="path" />
        <xsl:param name="parent-lang" />
        <xsl:choose>
            <!-- *REG*  (repeatable) -->
            <xsl:when test="$apptype='origreg'">
                <!-- **REG - <xsl:value-of select="$path/tei:reg"/>** -->
                <xsl:for-each select="$path/tei:reg">
                    <xsl:sort select="position()" order="descending"/>
                    <!-- <xsl:value-of select="."/> -->
                    <xsl:call-template name="multreg">
                        <xsl:with-param name="parent-lang"><xsl:value-of select="$parent-lang" /></xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:if test="$child != ''">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- *CORR* -->
            <xsl:when test="$apptype=('siccorr')">
                <!-- **CORR - <xsl:value-of select="$path/tei:corr/node()"/>** -->
                <xsl:text>l. </xsl:text>
                <xsl:apply-templates select="$path/tei:corr/node()"/>
                <xsl:text> (corr)</xsl:text>
            </xsl:when>
           <!-- *ALT* (repeatable) -->
            <xsl:when test="$apptype='app'">
                <!-- **ALT - <xsl:value-of select="$path/tei:rdg"/>** -->
                <xsl:for-each select="$path/tei:lem">
                    <xsl:value-of select="$path/tei:lem"/>
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:text>] </xsl:text>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="@wit">
                            <xsl:variable name="witnesses" select="tokenize(@wit, '#')"/>
                            <xsl:for-each select="$witnesses">
                                <xsl:apply-templates select="replace(., ' ', '')"/>
                                <xsl:choose>
                                    <xsl:when test="position()=last()[1]"/>
                                    <xsl:when test="position()!=1">
                                        <xsl:text>, </xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="@type">
                        <xsl:call-template name="apparatus-type"/>
                    </xsl:if>
                    <xsl:if test="$path/tei:lem[following-sibling::tei:rdg]">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                
                <xsl:for-each select="tei:rdg">
                    <xsl:if test="position()!=1">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                   
                    <xsl:choose>
                        <xsl:when test="child::tei:pb"/>
                        <xsl:when test="(not(.//text())) and (not(.//tei:gap))">
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:text>om.</xsl:text> 
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates/>
                    <xsl:if test="@wit">
                        <xsl:variable name="witnesses" select="tokenize(@wit, '#')"/>
                        <xsl:for-each select="$witnesses">
                            <xsl:apply-templates select="replace(., ' ', '')"/>
                            <xsl:choose>
                                <xsl:when test="position()=last()[1]"/>
                                <xsl:when test="position()!=1">
                                    <xsl:text>, </xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="following-sibling::tei:note and not(following-sibling::tei:rdg)">
                        <xsl:text> • </xsl:text>
                        <xsl:value-of select="following-sibling::tei:note"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="not(tei:rdg) and tei:note">
                    <xsl:text> • </xsl:text>
                    <xsl:value-of select="tei:note"/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="fnord-spliter">
        <xsl:param name="line" />
        <xsl:param name="delim" />
        <xsl:param name="tail" /><xsl:choose>
            <xsl:when test="$tail and not(contains($line, 'FNORD-SPLIT'))"><xsl:value-of select="$delim" /> <xsl:choose>
                <xsl:when test="contains($line,'prev. ed.') and not(starts-with(normalize-space($line), 'prev. ed.'))">
                    previous edition gave <xsl:value-of select="normalize-space(substring-before($line, 'prev. ed.'))" /><xsl:value-of select="normalize-space(substring-after($line, 'prev. ed.'))" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="normalize-space($line)" /></xsl:otherwise>
            </xsl:choose></xsl:when>
            <xsl:otherwise><xsl:if test="contains($line, 'FNORD-SPLIT')">
                <xsl:value-of select="$delim" /><xsl:text> </xsl:text><xsl:choose>
                    <xsl:when test="contains(normalize-space($line), '(corr')">
                        <xsl:value-of select="normalize-space(substring-after($line, 'FNORD-SPLIT'))"/> reports scribe wrote
                        <xsl:value-of select="normalize-space(substring-before(substring-after(substring-before(normalize-space($line), 'FNORD-SPLIT'), '(corr. ex'), ')'))"/>, then changed to
                        <xsl:value-of select="normalize-space(substring-before(substring-before(normalize-space($line), 'FNORD-SPLIT'), '(corr. ex'))"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="normalize-space(substring-after($line, 'FNORD-SPLIT'))"/> gave <xsl:value-of select="normalize-space(substring-before($line, 'FNORD-SPLIT'))"/></xsl:otherwise></xsl:choose></xsl:if></xsl:otherwise>
        </xsl:choose></xsl:template>
    
    <xsl:template name="multreg">
        <xsl:param name="parent-lang" />
        <!-- prints multiple regs in a single choice in sequence -->
        <xsl:choose>
            <xsl:when test="position()!=1">
                <xsl:text>i.e. </xsl:text>
            </xsl:when>
            <xsl:when test="@xml:lang != ancestor::tei:*[@xml:lang][1]/@xml:lang or ($parent-lang != '' and @xml:lang != $parent-lang)">
                <xsl:text>i.e. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>l. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
        <xsl:if test="position()!=last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="apparatus-type">
        <xsl:choose>
            <xsl:when test="./@type='emn' or tei:lem/@type='emn'">
                <xsl:text>em.</xsl:text>
            </xsl:when>
            <xsl:when test="./@type='norm' or tei:lem/@type='norm'">
                <xsl:text>norm.</xsl:text>
            </xsl:when>
            <xsl:when test="./@type='conj' or tei:lem/@type='conj'">
                <xsl:text>conj.</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>

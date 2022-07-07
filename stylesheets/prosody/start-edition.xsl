<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">

    <xsl:output indent="no" encoding="UTF-8"/>

    <!-- Written by Axelle Janiak for DHARMA, starting February 2021 -->

    <xsl:template match="tei:text">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                
                <xsl:call-template name="nav-bar"/>
                <xsl:element name="div">
                    <xsl:attribute name="class">container</xsl:attribute>
                    <xsl:element name="h1">
                        <xsl:attribute name="class">text-center</xsl:attribute>
                        <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title"/>
                    </xsl:element>
                    <xsl:element name="h2">
                        <xsl:attribute name="class">text-center</xsl:attribute>
                        <xsl:text>by </xsl:text>
                            <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:author[1]">
                                
                                <xsl:apply-templates select="//tei:fileDesc/tei:titleStmt/tei:author[1]"/>
                                <xsl:text>&amp; </xsl:text>
                            </xsl:if>
                            <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:author[2]">
                                <xsl:apply-templates select="//tei:fileDesc/tei:titleStmt/tei:author[2]"/>
                            </xsl:if>                                         
                    </xsl:element>
                    <xsl:apply-templates/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>©DHARMA (2019-2025).</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:call-template name="dharma-script"/>
                </xsl:element>
                </xsl:element>
            </xsl:element>
    </xsl:template>
    
    <!--  B ! -->
    <xsl:template match="tei:bibl">
        <xsl:analyze-string select="./tei:ptr/@target"
            regex="[a-z]+:(\w+)(\d\d\d\d)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
            <xsl:if test="./tei:citedRange">
                <xsl:text>, </xsl:text>
            </xsl:if>
        <xsl:if test="./tei:citedRange"> 
            <xsl:for-each select="./tei:citedRange">
                <xsl:call-template name="citedRange-unit"/>
                <xsl:apply-templates select="replace(normalize-space(.), '-', '–')"/>
                <xsl:if test="following-sibling::tei:citedRange[1]">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="./tei:note">
            <xsl:apply-templates select="tei:note"/>
        </xsl:if>
        <xsl:if test="following::tei:bibl[1]">
            <xsl:text>.</xsl:text>
            <br/>
        </xsl:if>
    </xsl:template>
    
    <!--<xsl:template match="tei:bibl">
        <xsl:choose>
            <xsl:when test=".[tei:ptr]">
                <xsl:variable name="biblentry" select="replace(substring-after(./tei:ptr/@target, 'bib:'), '\+', '%2B')"/>
                <xsl:variable name="zoteroStyle">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/bibliography/DHARMA_modified-Chicago-Author-Date_v01.csl</xsl:variable>
                <xsl:variable name="zoteroapijson">
                    <xsl:value-of
                        select="replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=json&amp;style=',$zoteroStyle,'&amp;include=citation'), 'amp;', '')"/>
                </xsl:variable>
                
                    <xsl:analyze-string select="unparsed-text($zoteroapijson)"
                        regex="(\s+&quot;citation&quot;:\s&quot;&lt;span&gt;)(.+)(&lt;/span&gt;&quot;)">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(2)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                
                        <!-\-<xsl:copy-of
                            select="document(replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$zoteroStyle), 'amp;', ''))/div"/>-\->
                
                   
                <xsl:if test="tei:citedRange"> 
                    <xsl:for-each select="tei:citedRange">
                        <xsl:call-template name="citedRange-unit"/>
                        <xsl:apply-templates select="replace(normalize-space(.), '-', '–')"/>
                        <xsl:if test="following-sibling::tei:citedRange[1]">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="ancestor::tei:listBibl and ancestor-or-self::tei:bibl/@n"> <!-\- [@type='primary'] -\->
                    <xsl:element name="span">
                        <xsl:attribute name="class">siglum</xsl:attribute>
                        <xsl:if test="ancestor-or-self::tei:bibl/@n">
                            <xsl:text> [siglum </xsl:text>
                            <strong><xsl:value-of select="ancestor-or-self::tei:bibl/@n"/></strong>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <!-\- if there is no ptr, print simply what is inside bibl and a warning message-\->
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>		
        </xsl:choose>
    </xsl:template>-->
    
    <!-- body -->
    <xsl:template match="tei:body">
     <xsl:element name="div">
         <xsl:element name="h2">Prosody Tables</xsl:element>
         <br/>
         <xsl:apply-templates/>
     </xsl:element>
    </xsl:template>

    <!-- cell -->
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- front -->
    <xsl:template match="tei:front">
        <xsl:element name="h2">Introduction</xsl:element>
        <xsl:apply-templates/>   
    </xsl:template>
    
    <!-- head -->
    <xsl:template match="tei:head">
        <xsl:element name="h3">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- item -->
    <xsl:template match="tei:item">
        <xsl:element name="tr">
            <xsl:element name="td">
            <xsl:if test="tei:measure">           
                    <xsl:apply-templates select="tei:measure"/>
            </xsl:if>
                <xsl:if test="following::tei:*[1][local-name() ='note']">
                    <xsl:apply-templates select="following::tei:note[1]"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="td">
            <xsl:if test="tei:label">
                    <xsl:apply-templates select="tei:label"/>
            </xsl:if>
                <xsl:if test="following::tei:*[1][local-name() ='note']">
                    <xsl:apply-templates select="following::tei:note[1]"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="td">
            <xsl:if test="tei:name">
                    <xsl:element name="ul">
                        <xsl:attribute name="class">list-unstyled</xsl:attribute>
                        <xsl:for-each select="tei:name">
                            <xsl:element name="li">
                                <xsl:apply-templates select="."/>
                                <xsl:choose>
                                    <xsl:when test="@xml:lang='san-Latn'">
                                        <xsl:text> (san)</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@xml:lang='kaw-Latn'">
                                        <xsl:text> (kaw)</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:if test="following::tei:*[1][local-name() ='note']">
                                    <xsl:apply-templates select="following::tei:note[1]"/>
                                </xsl:if>
                            </xsl:element>                                      
                        </xsl:for-each>
                    </xsl:element>
            </xsl:if>
            </xsl:element>
            <xsl:if test="tei:seg">
                <xsl:for-each select="tei:seg">
                    <xsl:element name="td">
                    <xsl:apply-templates/>
                        <xsl:if test="following::tei:*[1][local-name() ='note']">
                            <xsl:apply-templates select="following::tei:note[1]"/>
                        </xsl:if>
                    </xsl:element>
                </xsl:for-each> 
            </xsl:if>   
            <xsl:element name="td">
            <xsl:if test="tei:listBibl">
                    <xsl:apply-templates select="tei:listBibl"/>
            </xsl:if>
        </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- label -->
    <!--<xsl:template match="tei:label">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->

    <!-- list -->
    <xsl:template match="tei:list">
        <xsl:element name="table">
            <xsl:attribute name="class">table</xsl:attribute>
            <xsl:element name="thead">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>Syllable</xsl:text>
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>Class</xsl:text>
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>Name(s)</xsl:text>
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>XML</xsl:text>
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>Prosody</xsl:text>
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>Gana</xsl:text>
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="scope">col</xsl:attribute>
                        <xsl:text>Bibliography</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
        <xsl:call-template name="tpl-dharma-apparatus"/>
        <br/>
    </xsl:template>

    <!-- n -->
    <xsl:template match="tei:note">
        <xsl:call-template name="dharma-app-link">
            <xsl:with-param name="location" select="'text'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- p -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
    <!-- row -->
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- teiHeader -->
    <xsl:template match="tei:teiHeader"/>

    <!-- table -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">table</xsl:attribute>
            <xsl:element name="tbody">
            <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Named templates -->
     <xsl:template name="dharma-head">
        <head>
            <title>
                <xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/>
            </title>

            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous"></link>
                <!-- scrollbar CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                <!-- site-specific css !-->
                <!--<link rel="stylesheet" href=""></link>-->
                <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Serif"></link>
            </meta>
        </head>
    </xsl:template>

    <!-- Nav bar template -->
    <xsl:template name="nav-bar">
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="https://erc-dharma.github.io/">ERC-DHARMA</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="https://erc-dharma.github.io/">Home <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Collections
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfa-collection">Task-Force A</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfb-collection">Task-Force B</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfc-collection">Task-Force C</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfd-collection">Task-Force D</a>
                            <a class="dropdown-item" href="https://github.com/erc-dharma">All the repositories</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownConv" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Conventions
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="editorial">Editorial Conventions</a>
                            <a class="dropdown-item" href="">Prosodic Conventions</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Documentation
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/encoding-diplomatic/DHARMA%20EGD%20v1%20release.pdf">Encoding Guide for Diplomatic editions</a>
                            <a class="dropdown-item" href="critEd_elements">Critical Editions Memo</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/FNC/DHARMA_FNC_v01.1.pdf">File Naming Conventions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/open-access/DHARMA_GuideOpenAccess_March2022.pdf">Guide Open-Access</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/transliteration/DHARMA%20Transliteration%20Guide%20v3%20release.pdf">Transliteration Guide</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/zotero/DHARMA_ZoteroGuide_v01.1.1.pdf">Zotero Guide</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactControlledVoc">Artefacts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactClosedLists">Artefacts – Closed List</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textControlledVoc">Texts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textClosedLists">Texts – Closed List for texts</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtom_v01">Starting with Atom</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtomGit_v01">Starting with Atom &amp; Git</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtomTeletype_v01">Starting with Atom Teletype</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/git/DHARMA_git_guide_v01">Starting with git</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/github-issuetracker/UsingGitHubIssueTracker.pdf">Starting with GitHub issues</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/github-issuetracker/UsingMarkdownSyntax_v01">Starting with markdown</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/digital-areal/">Starting with XML in French</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Epigraphical Publications
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="nav-link" href="https://erc-dharma.github.io/arie">ARIE</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/tfb-ec-epigraphy/">Epigraphia Carnatica</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/tfa-sii-epigraphy/index-sii.html">South-Indian Inscriptions</a>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://github.com/erc-dharma">GitHub</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://www.zotero.org/groups/1633743/erc-dharma/library">Zotero Library</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://dharma.hypotheses.org/">Blog</a>
                    </li>
                </ul>
            </div>
        </nav>
    </xsl:template>

    <xsl:template name="dharma-script">
        <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.min.js" integrity="sha384-VHvPCCyXqtD5DqJeNxl2dtTyhF78xXNXdkwX1CZeRusQfRKp+tA7hAShOK/B/fQ2" crossorigin="anonymous"></script>
        <!-- jQuery Custom Scroller CDN -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        <!--<script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/loader.js"></script>-->
        <script src="../criticalEditions/loader.js"></script>
    </xsl:template>

    <xsl:template name="dharma-app-link">
        <!-- location defines the direction of linking -->
        <xsl:param name="location"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="01"/>
        </xsl:variable>
        
        <xsl:call-template name="dharma-generate-app-link">
            <xsl:with-param name="location" select="$location"/>
            <xsl:with-param name="app-num" select="$app-num"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="dharma-generate-app-link">
        <xsl:param name="location"/>
        <xsl:param name="app-num"/>
        <xsl:variable name="number">
            <xsl:number format="1" from="//tei:list" count="//tei:note" level="any"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$location = 'text'">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>#to-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:text>from-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                    <xsl:attribute name="data-placement">top</xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:if test="@resp">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="substring-after(./@resp, ':')"/>
                        <xsl:text>) </xsl:text>
                    </xsl:if>
                        <xsl:apply-templates/></xsl:attribute>
                    <span class="tooltip-notes">
                        <sup>
                            <xsl:text>↓</xsl:text>
                            <xsl:value-of select="$number"/>
                        </sup>
                    </span>
                </a>
            </xsl:when>
            <xsl:when test="$location = 'apparatus'">
                <a>
                    <xsl:attribute name="id">
                        <xsl:text>to-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:text>#from-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:text>↑</xsl:text>
                    <xsl:value-of select="$number"/>
                    <xsl:text>.</xsl:text>
                </a>
                <xsl:text> </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="tpl-dharma-apparatus">
        <!-- An apparatus is only created if one of the following is true -->
        <xsl:if test=".//tei:note">
            <xsl:element name="div">
                <xsl:attribute name="class">bloc-notes</xsl:attribute>
                <xsl:element name="h3">
                    <xsl:text>Notes</xsl:text>
                </xsl:element>
                    <!-- An entry is created for-each of the following instances
                  * notes.  -->
                    <xsl:for-each select=".//tei:note">
                        <xsl:element name="span">
                            <xsl:attribute name="class">tooltiptext-notes</xsl:attribute>
                            <xsl:call-template name="dharma-app-link">
                                <xsl:with-param name="location" select="'apparatus'"/>
                            </xsl:call-template>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <br/>
                    </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="citedRange-unit">
        <xsl:variable name="CurPosition" select="position()"/>
        <xsl:variable name="unit-value">
            <xsl:choose>
                <xsl:when test="@unit='page' and following-sibling::tei:citedRange[1]">
                    <xsl:choose>
                        <xsl:when test="matches(., '[–\-]+')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(., ',')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>page </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@unit='part'">
                    <xsl:text>part </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='volume'">
                    <xsl:text>volume </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='note'">
                    <xsl:text>note </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='item'">
                    <xsl:text>&#8470; </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='entry'">
                    <xsl:text>s.v. </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='figure'">
                    <xsl:text>figure </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='plate'">
                    <xsl:text>plate </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='table'">
                    <xsl:text>table </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='appendix'">
                    <xsl:text>appendix </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='line'">
                    <xsl:choose>
                        <xsl:when test="matches(., '[–\-]+')">
                            <xsl:text>lines </xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(., ',')">
                            <xsl:text>lines </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>line </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@unit='section'">
                    <xsl:choose>
                        <xsl:when test="matches(., '[–\-]+')">
                            <xsl:text>§§</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>§</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(., '[\-]+')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(., ',')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>page </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise> -->
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$CurPosition = 1 and not(ancestor::tei:p or ancestor::tei:note)">
                <xsl:value-of select="concat(upper-case(substring($unit-value,1,1)), substring($unit-value, 2),' '[not(last())] )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$unit-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>

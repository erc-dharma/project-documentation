<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">

    <xsl:output indent="no" encoding="UTF-8"/>

    <!-- Written by Axelle Janiak for DHARMA, starting February 2021 -->

    <xsl:template match="tei:TEI">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                <xsl:attribute name="data-spy">scroll</xsl:attribute>
                <xsl:attribute name="data-target">#myScrollspy</xsl:attribute>
                <xsl:call-template name="nav-bar"/>
                <xsl:call-template name="table-contents"/>
                <a class="btn btn-info" data-toggle="collapse" href="#sidebar-wrapper" role="button" aria-expanded="false" aria-controls="sidebar-wrapper" id="sidebarCollapse">☰ Index</a>

                <xsl:element name="div">
                    <xsl:attribute name="class">container</xsl:attribute>
                    <xsl:element name="h1">
                        <xsl:attribute name="class">text-center</xsl:attribute>
                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                        <xsl:text> by </xsl:text>
                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
                    </xsl:element>
                    <br/>
                    <xsl:apply-templates/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>©RODE. Online display made available by DHARMA (2019-2025), digitization made by Word Pro.</xsl:text><!-- vérifier le nom de la compagnie -->
                        </xsl:element>
                    </xsl:element>
                    <xsl:call-template name="dharma-script"/>
                </xsl:element>
                </xsl:element>
            </xsl:element>
    </xsl:template>

    <!-- back -->
    <xsl:template match="tei:back">
        <xsl:for-each select="tei:div[@type='chapter']">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">text col-12</xsl:attribute>
                    <xsl:element name="a">
                        <xsl:attribute name="class">btn btn-outline-dark btn-block</xsl:attribute>
                        <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                        <xsl:attribute name="href">#<xsl:value-of select="generate-id()"/></xsl:attribute>
                        <xsl:attribute name="role">button</xsl:attribute>
                        <xsl:attribute name="aria-expanded">false</xsl:attribute>
                        <xsl:attribute name="aria-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                        
                        <xsl:element name="small">
                            <xsl:apply-templates select="tei:head/text()"/>
                        </xsl:element>
                        
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="id">
                            <xsl:value-of select="generate-id()"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">collapse</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="class">card card-body border-dark</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:element>
                
            </xsl:element>
        </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!-- cell -->
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- cit -->
    <xsl:template match="tei:cit">
        <xsl:element name="div">
            <xsl:attribute name="class">col-10</xsl:attribute>
            <xsl:apply-templates/>
            <xsl:if test="descendant::tei:note">
                <xsl:call-template name="tpl-dharma-apparatus"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <!-- div -->
    <xsl:template match="tei:div">
        <!-- @type chapter, section, sub-section and alpha -->
        <xsl:choose>
            <xsl:when test="@type='chapter'">
                <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type='section'">
                <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test=".[not(ancestor::tei:front)]/@type='sub-section'">
                    <xsl:element name="div">
                        <xsl:attribute name="class">row</xsl:attribute>               
                                <xsl:apply-templates select="node()"/>
                                <xsl:choose>
                                    <xsl:when test="following::tei:div[@type='sub-section']">
                                        <hr></hr>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <br></br>
                                    </xsl:otherwise>
                                </xsl:choose>
                    </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- e -->
    <xsl:template match="tei:entry">
        <xsl:element name="div">
            <xsl:attribute name="class">col-12</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- form -->
    <xsl:template match="tei:form">
        <xsl:element name="div">
            <xsl:attribute name="class">col-2</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- front -->
    <xsl:template match="tei:front">
            <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
                <xsl:for-each select="tei:div[@type='chapter']">
            <xsl:element name="div">
                <xsl:attribute name="class">col-12</xsl:attribute>
                    <xsl:element name="a">
                        <xsl:attribute name="class">btn btn-outline-dark btn-block</xsl:attribute>
                        <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                        <xsl:attribute name="href">#<xsl:value-of select="generate-id()"/></xsl:attribute>
                        <xsl:attribute name="role">button</xsl:attribute>
                        <xsl:attribute name="aria-expanded">false</xsl:attribute>
                        <xsl:attribute name="aria-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                        
                        <xsl:element name="small">
                            <xsl:choose>
                                <xsl:when test="child::tei:head[1]">
                                    <xsl:apply-templates select="tei:head/string()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Preface</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="id">
                            <xsl:value-of select="generate-id()"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">collapse</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="class">card card-body border-dark</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:element>
            </xsl:element>
                    <br/>
                </xsl:for-each>
               
        </xsl:element>
        
    </xsl:template>
    
    <!-- Head -->
    <xsl:template match="tei:head[parent::tei:div[@type='chapter']]">
        <xsl:element name="h2">
            <xsl:attribute name="class">text-center</xsl:attribute>
        <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[@type='section']]">
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[@type='sub-section']]">
        <br/>
        <xsl:element name="h4">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>

    <!-- hi -->
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='it'">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                        <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='sup'">
                <xsl:element name="sup">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='sub'">
                <xsl:element name="sub">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='sc'">
                <xsl:element name="small">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- item -->
    <xsl:template match="tei:item">
        <xsl:element name="li">
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <!-- lbl -->
    <xsl:template match="tei:lbl">
            <xsl:apply-templates/>
    </xsl:template>

    <!-- label -->
    <xsl:template match="tei:label">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- lb -->
    <xsl:template match="tei:lb">
       <xsl:choose>
           <xsl:when test="count(preceding-sibling::tei:lb) = 0"/>
           <xsl:otherwise>
           <br/>
           </xsl:otherwise>
       </xsl:choose>
    </xsl:template>

    <!-- list -->
    <xsl:template match="tei:list">
        <xsl:element name="ul">
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <!-- n -->
    <xsl:template match="tei:note">
        <xsl:choose><xsl:when test="ancestor::tei:div[@type='section']">
            <xsl:call-template name="dharma-app-link">
                <xsl:with-param name="location" select="'text'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- num -->
    <xsl:template match="tei:num">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- oRef -->
    <xsl:template match="tei:oRef">
        <xsl:element name="a">
            <xsl:attribute name="href">#<xsl:value-of select="@target"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- orth -->
    <xsl:template match="tei:orth[@xml:id]">
        <xsl:element name="a">
            <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:orth[@type='lemma']">
        <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- p -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- pb -->
    <xsl:template match="tei:pb">
            <xsl:element name="span">
                <xsl:attribute name="class">pagination text-muted float-right</xsl:attribute>
                <xsl:text>[page </xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>]</xsl:text>
             </xsl:element>
    </xsl:template>

    <!-- quote -->
    <xsl:template match="tei:quote">
        <xsl:text>“</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>”</xsl:text>
    </xsl:template>

    <!-- row -->
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- s -->
    <xsl:template match="tei:s">
        <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- sic -->
    <xsl:template match="tei:sic">
        <xsl:element name="span">
            <xsl:attribute name="class">sic</xsl:attribute>
            <xsl:text>¿</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>?</xsl:text>
        </xsl:element>
    </xsl:template>

    <!-- supplied -->
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!-- table -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">table</xsl:attribute>
            <xsl:element name="tbody">
            <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- teiHeader -->
    <xsl:template match="tei:teiHeader"/>

    <!-- unclear -->
    <xsl:template match="tei:unclear">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
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
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/ec/ec-css.css"></link>
                <!--<link rel="stylesheet" href="../ec/ec-css.css"></link>-->

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
                            <a class="dropdown-item" href="https://erc-dharma.github.io/output/display-prosody.html">Prosodic Conventions</a>
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
                        <a class="nav-link dropdown-toggle" id="navbarDropdownConv" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Authorities
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://opentheso.huma-num.fr/opentheso/?idt=th347">Controlled Vocabularies</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="">Documentation for metadata and authorities - coming</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_places.html">Places</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_persons.html">Persons</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_monuments.html">Monuments</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_collections.html">Collections</a>
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
        <!-- loader ec -->
        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/ec/ec-loader.js"></script>
        <!--<script rel="stylesheet" src="../ec/ec-loader.js"></script>-->
    </xsl:template>

    <!-- side bar -->
    <!-- side bar - table of contents -->
    <xsl:template name="table-contents">
        <xsl:element name="div">
            <xsl:attribute name="class">collapse</xsl:attribute>
            <xsl:attribute name="id">sidebar-wrapper</xsl:attribute>
            <xsl:element name="nav">
                <xsl:attribute name="id">myScrollspy</xsl:attribute>
                <xsl:element name="ul">
                    <xsl:attribute name="class">nav nav-pills flex-column</xsl:attribute>
                    <xsl:for-each select="//tei:div[@type='section']">
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link text-align-justify</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="generate-id()"/>
                                </xsl:attribute>
                                <xsl:call-template name="ecid"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- side number id -->
    <!-- issue with the string in which we found pb and lb -->
    <xsl:template name="number">
        <xsl:element name="div">
            <xsl:attribute name="class">col-2</xsl:attribute>
            <xsl:element name="span">
                <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                <xsl:call-template name="ecid"/>
            </xsl:element>
            <br/>
            <xsl:text>DHARMA ID: </xsl:text>
            <xsl:call-template name="dharmaid"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="dharmaid">
    <xsl:element name="span">
        <xsl:attribute name="class">dharmaid</xsl:attribute>
        <xsl:text>RODE</xsl:text>
        <xsl:value-of select="substring-before(substring-after(base-uri(.), 'DHARMA_INSEC'), '.xml')"/>
        <!--<xsl:call-template name="taluqabbr"/>-->
        <!--<xsl:number level="any" count="tei:div[@type='section']" format="00001"/>-->
        <xsl:choose>
          <xsl:when test="matches(./tei:head, '\d\d\d')">
            <xsl:analyze-string regex="^\s*(\d\d\d[a-c]*)" select="./tei:head/string()">
              <xsl:matching-substring>
              <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:when>
            <xsl:when test="matches(./tei:head, '\d\d')">
                <xsl:text>0</xsl:text>
                <xsl:analyze-string regex="^\s*(\d\d[a-c]*)" select="./tei:head/string()">
                  <xsl:matching-substring>
                  <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches(./tei:head, '\d')">
                <xsl:text>00</xsl:text>
                <xsl:analyze-string regex="^\s*(\d[a-c]*)" select="./tei:head/string()">
                  <xsl:matching-substring>
                  <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:element>
</xsl:template>

    <xsl:template name="ecid">
        <xsl:text>RODE </xsl:text>
        <xsl:value-of select="substring-before(substring-after(base-uri(.), 'DHARMA_INSEC'), '.xml')"/>
        <xsl:text> </xsl:text>
        <!--<xsl:call-template name="taluqabbr"/>-->
        <xsl:text> </xsl:text>
              <xsl:analyze-string regex="^\s*(\d+[a-c]*)" select="./tei:head/string()">
                <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
              </xsl:matching-substring>
              </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="tpl-dharma-apparatus">
        <!-- An apparatus is only created if one of the following is true -->
        <xsl:if test=".//tei:note[ancestor::tei:div]">
            <xsl:element name="div">
                <xsl:attribute name="class">bloc-notes</xsl:attribute>
            <!--<xsl:element name="h5">
                <xsl:text>Notes</xsl:text>
            </xsl:element>-->
                <hr></hr>
            <xsl:element name="span">
                <xsl:attribute name="class">notes</xsl:attribute>
                <!-- An entry is created for-each of the following instances
                  * notes.  -->
                <xsl:for-each select=".//tei:note">
                    <xsl:element name="span">
                        <xsl:attribute name="class">tooltiptext-notes</xsl:attribute>
                        <xsl:call-template name="dharma-app-link">
                            <xsl:with-param name="location" select="'apparatus'"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="child::tei:p/node()"/>
                    </xsl:element>
                    <br/>
                </xsl:for-each>
            </xsl:element>
            </xsl:element>
            <br/>
        </xsl:if>
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
            <xsl:number format="1" from="//tei:div" count="tei:note" level="any"/>
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
</xsl:stylesheet>

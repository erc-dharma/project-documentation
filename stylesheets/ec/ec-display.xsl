<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>
    
    <!-- Written by Axelle Janiak for DHARMA, starting February 2021 -->
    
    <xsl:template match="tei:text">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                <xsl:attribute name="data-spy">scroll</xsl:attribute>
                <xsl:attribute name="data-target">#myScrollspy</xsl:attribute>
                <xsl:call-template name="nav-bar"/>
                <xsl:call-template name="table-contents"/>
                <a class="btn btn-info" data-toggle="collapse" href="#sidebar-wrapper" role="button" aria-expanded="false" aria-controls="sidebar-wrapper" id="toggle-table-contents">☰ Index</a>
                <xsl:element name="div">
                    <xsl:attribute name="class">container</xsl:attribute>
                    <xsl:element name="h1">
                        <xsl:attribute name="class">text-center</xsl:attribute>
                        <xsl:value-of select="//tei:sourceDesc/tei:bibl/tei:title[@type='main']"/>
                        <xsl:text> by </xsl:text>
                        <xsl:value-of select="//tei:sourceDesc/tei:bibl/tei:author"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="//tei:sourceDesc/tei:bibl/tei:date"/>
                    </xsl:element>
                <xsl:apply-templates/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>©EC. Online display made available by DHARMA (2019-2025), digitization made by Word Pro.</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:call-template name="dharma-script"/>            
                </xsl:element>  
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- div -->
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="@type='section'">
                    <xsl:element name="div">
                        <xsl:attribute name="class">row justify-content-md-center</xsl:attribute>
                        <xsl:attribute name="id">
                            <xsl:value-of select="generate-id()"/>
                        </xsl:attribute>
                        <xsl:call-template name="number"/>
                        <xsl:element name="div">
                            <xsl:attribute name="class">col-10</xsl:attribute>
                            <xsl:element name="dl">
                                <xsl:apply-templates select="node()"/>
                                <xsl:choose>
                                    <xsl:when test="not(following::tei:div[@type='section'])">
                                        <br/>
                                    </xsl:when>
                                    <xsl:otherwise><hr/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Head -->
    <xsl:template match="tei:head[parent::tei:div[@type='book']]">
        <xsl:element name="h2">
        <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[@type='chapter']]">
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[@type='section']]">
        <xsl:element name="h4">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- hi -->
    <xsl:template match="tei:hi[@rend='it']">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                        <xsl:apply-templates/>
                </xsl:element>
    </xsl:template>
    
    <!-- l -->
    <xsl:template match="tei:l">
        <xsl:element name="div">
            <xsl:attribute name="class">verseline</xsl:attribute>
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
    
    <!-- lg -->
    <xsl:template match="tei:lg">
        <xsl:element name="div">
            <xsl:attribute name="class">stanza</xsl:attribute>
            <xsl:element name="span">
                <xsl:number count="tei:lg" format="I" level="any" from="tei:div[@type='section']"/>
                <xsl:text>. </xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- n -->
    <xsl:template match="tei:note">
        
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
                <xsl:attribute name="class">text-muted float-right</xsl:attribute>
                <xsl:text>[page </xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>]</xsl:text>
             </xsl:element>
    </xsl:template>
    
    <!-- quote -->
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- supplied -->
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <!-- teiHeader -->
    <xsl:template match="tei:teiHeader"/>

     <xsl:template name="dharma-head">
        <head>
            <title>
                <xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/>
            </title>
            
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
                <!-- scrollbar CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                <!-- site-specific css !-->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/ec/ec-css.css"></link>
                <!--<link rel="stylesheet" href="./../ec/ec-css.css"></link>-->
                
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
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://erc-dharma.github.io/editorial">Editorial Conventions</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Controlled Vocabularies
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactControlledVoc">Artefacts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactClosedLists">Artefacts – Closed List</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textControlledVoc">Texts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textClosedLists">Texts – Closed List for texts</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Documentation
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtom_v01">Starting with Atom</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtomGit_v01">Starting with Atom &amp; Git</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtomTeletype_v01">Starting with Atom Teletype</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/git/DHARMA_git_guide_v01">Starting with git</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/github-issuetracker/UsingGitHubIssueTracker.pdf">Starting with GitHub issues</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/github-issuetracker/UsingMarkdownSyntax_v01">Starting with markdown</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/encoding-diplomatic/DHARMA%20EGD%20v1%20release.pdf">Encoding Guide for Diplomatic editions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/FNC/DHARMA_FNC_v01.1.pdf">File Naming Conventions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/transliteration/DHARMA%20Transliteration%20Guide%20v3%20release.pdf">Transliteration Guide</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/zotero/DHARMA_ZoteroGuide_v01.1.1.pdf">Zotero Guide</a>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://erc-dharma.github.io/arie">ARIE</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://www.zotero.org/groups/1633743/erc-dharma/library">Zotero Library</a>
                    </li>
                </ul> 
            </div>
        </nav>
    </xsl:template>
    
    <xsl:template name="dharma-script">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
        <!-- scrollbar -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        <!-- loader arie -->
        <script rel="stylesheet" src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/ec/ec-loader.js"></script>
        <!--<script rel="stylesheet" src="./../ec/ec-loader.js"></script>-->
    </xsl:template>
    
    <!-- side bar -->
    <!-- side bar - table of contents -->
    <xsl:template name="table-contents">
        <xsl:element name="div">
            <xsl:attribute name="id">sidebar-wrapper</xsl:attribute>
            <xsl:attribute name="class">collapse</xsl:attribute>
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
                                <xsl:text>INSEC11</xsl:text>
                                <!--<xsl:number level="any" count="tei:div[@type='section']" format="00001"/>-->
                                <xsl:choose>
                                    <xsl:when test="matches(substring-before(./tei:head, ' '), '^\d')">
                                        <xsl:text>0000</xsl:text>
                                        <xsl:value-of select="substring-before(./tei:head, ' ')"/>
                                    </xsl:when>
                                    <xsl:when test="matches(substring-before(./tei:head, ' '), '^\d\d')">
                                        <xsl:text>000</xsl:text>
                                        <xsl:value-of select="substring-before(./tei:head, ' ')"/>
                                    </xsl:when>
                                    <xsl:when test="matches(substring-before(./tei:head, ' '), '^\d\d\d')">
                                        <xsl:text>00</xsl:text>
                                        <xsl:value-of select="substring-before(./tei:head, ' ')"/>
                                    </xsl:when>
                                </xsl:choose>
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
            <xsl:attribute name="class">col-2 font-weight-bold</xsl:attribute>
            <xsl:value-of select="ancestor-or-self::tei:div[@type='chapter']/tei:head[1]"/>
            <br/>
            <xsl:text>INSEC11</xsl:text>
            <!--<xsl:number level="any" count="tei:div[@type='section']" format="00001"/>-->
            <xsl:choose>
                <xsl:when test="matches(substring-before(./tei:head, ' '), '^\d')">
                    <xsl:text>0000</xsl:text>
                    <xsl:value-of select="substring-before(./tei:head, ' ')"/>
                </xsl:when>
                <xsl:when test="matches(substring-before(./tei:head, ' '), '^\d\d')">
                    <xsl:text>000</xsl:text>
                    <xsl:value-of select="substring-before(./tei:head, ' ')"/>
                </xsl:when>
                <xsl:when test="matches(substring-before(./tei:head, ' '), '^\d\d\d')">
                    <xsl:text>00</xsl:text>
                    <xsl:value-of select="substring-before(./tei:head, ' ')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
   
</xsl:stylesheet>
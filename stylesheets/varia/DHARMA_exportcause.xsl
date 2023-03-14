<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">

    <xsl:output indent="no" encoding="UTF-8"/>

    <!-- Written by Axelle Janiak for DHARMA, starting February 2021 -->

    <xsl:template match="/">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                
                <xsl:call-template name="nav-bar"/>
                <div class="container">
                    <xsl:apply-templates select="./tei:TEI/tei:teiHeader"/>
                <xsl:apply-templates select="./tei:TEI/tei:text"/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>©DHARMA (2019-2025).</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </div>
                    <xsl:call-template name="dharma-script"/>
                </xsl:element>
                </xsl:element>
    </xsl:template>

    <!-- body -->
    <xsl:template match="tei:body">
     <xsl:element name="div">
         <xsl:element name="h2">Cause Tables</xsl:element>
         <br/>
         <xsl:element name="table">
             <xsl:attribute name="class">table</xsl:attribute>
             <xsl:element name="thead">
                 <xsl:element name="tr">
                     <xsl:element name="th">
                         <xsl:attribute name="scope">col</xsl:attribute>
                         <xsl:text>cause</xsl:text>
                     </xsl:element>
                     <xsl:element name="th">
                         <xsl:attribute name="scope">col</xsl:attribute>
                         <xsl:text>Lem</xsl:text>
                     </xsl:element>
                     <xsl:element name="th">
                         <xsl:attribute name="scope">col</xsl:attribute>
                         <xsl:text>Variants</xsl:text>
                     </xsl:element> 
                 </xsl:element>
             </xsl:element>
             <xsl:element name="tbody">
                 <xsl:apply-templates select=".//tei:app[child::tei:rdg[@cause]]"/>
             </xsl:element>
         </xsl:element>
     </xsl:element>
    </xsl:template>

    <!-- item -->
    <xsl:template match="tei:app[child::tei:rdg[@cause]]">
        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:apply-templates select="tei:rdg/@cause"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:element name="span">
                    <xsl:attribute name="class"><xsl:call-template name="lem-type"/></xsl:attribute>
                    <xsl:apply-templates select="tei:lem"/>
                </xsl:element>
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="tei:lem/@wit"/>
                <xsl:if test="tei:lem/@type">
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-italic</xsl:attribute>
                        <xsl:call-template name="apparatus-type"/>
                    </xsl:element>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:element>
            <xsl:element name="td">
                <xsl:for-each select="tei:rdg">
                    <xsl:apply-templates select="."/>
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="./@wit"/>
                    <xsl:text>)</xsl:text>
                    <br/>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- teiHeader -->
    <!--  teiHeader ! -->
    <xsl:template match="tei:teiHeader">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col text-center my-5</xsl:attribute>
                <xsl:element name="h1">
                    <xsl:attribute name="class">display-5</xsl:attribute>
                    <xsl:text>The </xsl:text>
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-italic</xsl:attribute>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                    </xsl:element>
                    <xsl:if test="tei:fileDesc/tei:titleStmt/tei:title[@type='alt']">
                        <xsl:text> or ‘</xsl:text>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='alt']"/>
                        <xsl:text>’</xsl:text>
                    </xsl:if>
                    <xsl:if test="tei:fileDesc/tei:titleStmt/tei:author">
                        <xsl:text> by </xsl:text>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:author"/>
                    </xsl:if>
                </xsl:element>
                
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                    <xsl:element name="h2">
                        <xsl:attribute name="class">display-5</xsl:attribute>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:editor">
                    <xsl:element name="h3">
                        <xsl:attribute name="class">display-6</xsl:attribute>
                        <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:editor">
                            <xsl:choose>
                                <xsl:when test="position()= 1">
                                    <xsl:text>edited by </xsl:text>
                                </xsl:when>
                                <xsl:when test="position()=last()">
                                    <xsl:text> &amp; </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>, </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="child::tei:forename">
                                    <xsl:apply-templates select="tei:forename"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="tei:surname"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="normalize-space(.)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:text>Current Version: </xsl:text>
                <xsl:choose>
                    <xsl:when test="tei:fileDesc/following-sibling::tei:revisionDesc/tei:change[1]/@status">
                        <xsl:value-of select="tei:fileDesc/following-sibling::tei:revisionDesc/tei:change[1]/@status"/>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>draft</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="current-date()"/>
                <br/>
                <xsl:text>Still in progress – do not quote without permission.</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:abbr">
        <xsl:apply-templates/>
    </xsl:template>
        
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason='omitted'">
                <span class="font-italic">om.</span>
            </xsl:when>
            <xsl:when test="@reason='lost'">
                <span class="font-italic">lac.</span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:supplied">
        <xsl:choose>
            <xsl:when test="@reason='omitted'">
                <xsl:text>⟨</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>⟩</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:span">
        <xsl:choose>
            <xsl:when test="@type='omissionStart'">
                <xsl:text>[...</xsl:text>
            </xsl:when>
            <xsl:when test="@type='omissionEnd'">
                <xsl:text>...]</xsl:text>
            </xsl:when>
        </xsl:choose>
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
                            <a class="dropdown-item" href="https://erc-dharma.github.io/editorial">Editorial Conventions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/output-prosody/display-prosody.html">Prosodic Conventions</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Documentation
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/critEd_elements">Critical Editions Memo</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/DiplEd_elements">Diplomatic Editions Memo</a>
                            <div class="dropdown-divider"></div>
                            
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/encoding-diplomatic/DHARMA%20EGD%20v1%20release.pdf">Encoding Guide for Diplomatic editions</a>
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
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/visual-code/UsingVS_v01">Starting with Visual Studio Code</a>
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
                            <a class="nav-link" href="https://erc-dharma.github.io/output-roej/display-roej.html">Répertoire Onomastique Java</a>
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

    <!-- DHARMA html JS scripts  -->
    <xsl:template name="dharma-script">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <!-- Popper.JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <!-- Bootstrap JS -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        <!-- jQuery Custom Scroller CDN -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/loader.js"></script>
        <!--<script src="../criticalEditions/loader.js"></script>-->
    </xsl:template>
    
    <!-- Apparatus: type to display -->
    <xsl:template name="apparatus-type">
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
    </xsl:template>
    
    <xsl:template name="lem-type">
        <xsl:choose>
            <xsl:when test="tei:lem/@rend='hyphenleft'">
                <xsl:text>hyphenleft</xsl:text>
            </xsl:when>
            <xsl:when test="tei:lem/@rend='hyphenright'">
                <xsl:text>hyphenright</xsl:text>
            </xsl:when>
            <xsl:when test="tei:lem/@rend='hyphenaround'">
                <xsl:text>hyphenaround</xsl:text>
            </xsl:when>
            <xsl:when test="tei:lem/@rend='circleleft'">
                <xsl:text>circleleft</xsl:text>
            </xsl:when>
            <xsl:when test="tei:lem/@rend='circleright'">
                <xsl:text>circleright</xsl:text>
            </xsl:when>
            <xsl:when test="tei:lem/@rend='circlearound'">
                <xsl:text>circlearound</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>

﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">

    <xsl:output method="html" indent="no" encoding="UTF-8"/>

    <!-- Written by Axelle Janiak for DHARMA, starting Juin 2022 -->

    <xsl:template match="doc">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                <xsl:attribute name="data-spy">scroll</xsl:attribute>
                <xsl:attribute name="data-target">#myScrollspy</xsl:attribute>
                <xsl:call-template name="nav-bar"/>
                <a class="btn btn-info" data-toggle="collapse" href="#sidebar-wrapper" role="button" aria-expanded="false" aria-controls="sidebar-wrapper" id="toggle-table-contents">☰ Index</a>
                <xsl:element name="div">
                    <xsl:attribute name="class">container</xsl:attribute>
                <xsl:apply-templates/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>©SII. Online display made available by DHARMA</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:call-template name="dharma-script"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="h1">
        <br/>
        <xsl:element name="h1">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>

    <xsl:template match="h2">
        <br/>
        <xsl:element name="h2">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>

    <xsl:template match="h3">
        <br/>
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>

    <xsl:template match="h4">
        <br/>
        <xsl:element name="h4">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>

    <xsl:template match="em | gr">
        <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="i | ta | de">
        <xsl:element name="span">
            <xsl:attribute name="class">font-italic</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="ins">
            <xsl:apply-templates/>
    </xsl:template>

    <!-- l -->
    <xsl:template match="l">
        <xsl:element name="div">
            <xsl:attribute name="class">verseline</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- lb -->
    <xsl:template match="lb"/>

    <!-- lg -->
    <xsl:template match="lg">
        <xsl:element name="div">
            <xsl:attribute name="class">stanza</xsl:attribute>
            <xsl:element name="span">
                <xsl:number count="tei:lg" format="I" level="any" from="tei:div[@type='section']"/>
                <xsl:text>. </xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- P -->
    <xsl:template match="p | hi">
        <xsl:element name="div">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- pb -->
    <xsl:template match="pb">
        <xsl:element name="span">
            <xsl:attribute name="class">pagination text-muted float-right</xsl:attribute>
            <xsl:text>[page </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table">
        <xsl:variable name="path-file">https://raw.githubusercontent.com/erc-dharma/tfa-sii-epigraphy/master/sii-corpus/sii01-04_tables.xml</xsl:variable>
       <xsl:variable name="table-name" select="@n"/>
        <xsl:apply-templates select="doc($path-file)//table[@n = $table-name]/*"/>
    </xsl:template>

    <!-- ch et tlka -->
    <xsl:template match="ch |tlka | TL">
        <xsl:element name="span">
            <xsl:attribute name="style">background-color: yellow;</xsl:attribute>
            <xsl:text>[?]</xsl:text>
        </xsl:element>
    </xsl:template>
    <!-- <dt class="col">Description lists</dt>
  <dd class="col">A description list is perfect for defining terms.</dd> -->
     <xsl:template name="dharma-head">
        <head>
            <title>
                <xsl:value-of select="H1"/>
            </title>

            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
                <!-- scrollbar CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                <!-- site-specific css !-->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/sii/sii-css.css"></link>
                <!--<link rel="stylesheet" href="../sii/sii-css.css"></link>-->


                <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Serif"></link>
            </meta>
        </head>
    </xsl:template>

    <xsl:template match="lb">
      <xsl:choose>
          <xsl:when test="not(@break='no')">
              <xsl:text> </xsl:text>
          </xsl:when>
      </xsl:choose>
    </xsl:template>

    <xsl:template match="ref">
        <xsl:variable name="path-file">https://raw.githubusercontent.com/erc-dharma/tfa-sii-epigraphy/master/sii-corpus/sii01-04_footnotes.xml</xsl:variable>
       <xsl:variable name="ref-name" select="@t"/>
        <xsl:element name="a">
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="title"><xsl:choose><xsl:when test="doc($path-file)//note[@n = $ref-name]"><xsl:apply-templates select="doc($path-file)//note[@n = $ref-name]/p"/></xsl:when><xsl:otherwise><xsl:apply-templates/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:element name="sup">
                <xsl:attribute name="class">footnote</xsl:attribute>
                <xsl:number count="ref" format="1" level="any"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Supprimer dans la nouvelle livraison des fichiers -->
    <!-- <xsl:template match="fnr">
        <xsl:element name="a">
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="title"><xsl:apply-templates/></xsl:attribute>
            <xsl:element name="sup">
                <xsl:value-of select="@n"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>-->

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

    <xsl:template name="dharma-script">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
        <!-- scrollbar -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        <!-- loader sii -->
        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/sii/sii-loader.js"></script>

    </xsl:template>


</xsl:stylesheet>

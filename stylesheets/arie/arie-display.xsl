<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="html" indent="no" encoding="UTF-8"/>
    
    <!-- Written by Axelle Janiak for DHARMA, starting September 2021 -->
    
    <xsl:template match="doc">
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
                <xsl:apply-templates/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>©ARIE. Online display made available by DHARMA</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:call-template name="dharma-script"/>            
                </xsl:element>  
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="H">
        <xsl:variable name="biblentry" select="replace(./arie/@ref, '\+', '%2B')"/>
            <xsl:variable name="zoteroStyle">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/bibliography/DHARMA_modified-Chicago-Author-Date_v01.csl</xsl:variable>
            <xsl:variable name="bibref">
                <xsl:value-of select="replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=', $zoteroStyle), 'amp;', '')"/>
            </xsl:variable>
        <xsl:element name="h1">
            <xsl:attribute name="class">text-center</xsl:attribute>
            <xsl:text>ARIE </xsl:text>
            <xsl:value-of select="substring-before(substring-after(./string(), '('), ')')"/>
            <xsl:text> [vol. </xsl:text>
            <xsl:value-of select="arie/@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
        <xsl:element name="p">
            <xsl:attribute name="class">text-center</xsl:attribute>
        <xsl:copy-of
            select="document($bibref)/div"/>
            </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="H1">
        <xsl:variable name="biblentry" select="replace(./arie/@ref, '\+', '%2B')"/>
        <xsl:variable name="zoteroStyle">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/bibliography/DHARMA_modified-Chicago-Author-Date_v01.csl</xsl:variable>
        <xsl:variable name="bibref">
            <xsl:value-of select="replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=', $zoteroStyle), 'amp;', '')"/>
        </xsl:variable>
        <xsl:element name="h1">
            <xsl:attribute name="class">text-center</xsl:attribute>
            <xsl:text>ARIE </xsl:text>
            <xsl:value-of select="substring-before(substring-after(./string(), '('), ')')"/>
            <xsl:text> [ARIE </xsl:text>
            <xsl:value-of select="arie/@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
            <xsl:if test="substring-after(., '_go')">
                <xsl:element name="h1">
                    <xsl:attribute name="class">text-center</xsl:attribute>
                <xsl:text> G.O. No. </xsl:text>
                <xsl:value-of select="substring-before(substring-after(./string(), '_go'), '_')"/>
                </xsl:element>
            </xsl:if>
        <xsl:element name="p">
            <xsl:attribute name="class">text-center</xsl:attribute>
            <xsl:copy-of
                select="document($bibref)/div"/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="H2">
        <xsl:element name="h2">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="H3">
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="H4">
        <xsl:element name="h4">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="HC">
        <xsl:element name="h2">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="HD">
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="HP">
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="HT">
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="b">
        <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="i">
        <xsl:element name="span">
            <xsl:attribute name="class">font-italic</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="INSCRIPTION | MANUSCRIPT">
        <xsl:for-each select=".">
            <xsl:element name="div">
                <xsl:attribute name="class">row justify-content-md-center</xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:call-template name="number"/>
                <xsl:element name="div">
                    <xsl:attribute name="class">col-7</xsl:attribute>
                    <xsl:element name="dl">
                        <xsl:apply-templates select="node() except S"/>
                        <xsl:choose>
                            <xsl:when test="not(following::*[1][local-name() = ('INSCRIPTION','MANUSCRIPT')])">
                                <br/>
                            </xsl:when>
                            <xsl:otherwise><hr/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
            </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template name="number">
        <xsl:element name="div">
            <xsl:attribute name="class">col-5 font-weight-bold</xsl:attribute>
            <xsl:text>ARIE/</xsl:text>
            <xsl:value-of select="substring-before(substring-after(//H1/string(), '('), ')')"/>
            <xsl:text>/</xsl:text>
            <xsl:choose>
                <xsl:when test="preceding::H2[1]">
                    <xsl:value-of select="replace(replace(substring-before(preceding::H2[1], '.'), 'Appendix ', ''), 'APPENDIX ', '')"/>
                </xsl:when>
            <!-- substring-before(preceding::HC[1], '.') -->
            <xsl:otherwise>
                <xsl:value-of select="replace(replace(substring-before(preceding::HC[1], '.'), 'Appendix ', ''), 'APPENDIX ', '')"/>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:text>/</xsl:text>
            <xsl:choose>
                <xsl:when test="matches(preceding::H2[1], '[0-9\-]+')">
                <xsl:analyze-string select="preceding::H2[1]/string()" regex="([0-9]+[0-9\-]*)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
                <xsl:when test="matches(preceding::HC[1], '[0-9\-]+')">
                    <xsl:analyze-string select="preceding::HC[1]/string()" regex="([0-9]+[0-9\-]*)">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                    <xsl:otherwise>
                        <xsl:analyze-string select="preceding::arie[1]/@ref/string()" regex="([0-9]+[0-9\-]*)">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:otherwise>
            </xsl:choose>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="S"/>
            <xsl:text> (page </xsl:text>
            <xsl:choose>
                <xsl:when test="starts-with(substring-after(preceding::pb[1]/@n, ':'), '0')">
                    <xsl:value-of select="substring-after(preceding::pb[1]/@n, ':0')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(preceding::pb[1]/@n, ':')"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text>)</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <!-- P -->
    <xsl:template match="P">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Place</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Y -->
    <xsl:template match="Y">
    <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:text>Dynasty</xsl:text>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
    </xsl:template>
    
    <!-- K -->
    <xsl:template match="K">
    <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:text>King</xsl:text>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
    </xsl:template>
    
    <!-- D -->
    <xsl:template match="D">
    <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:text>Date</xsl:text>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
    </xsl:template>
    
    <!-- L -->
    <xsl:template match="L">
        <xsl:variable name="volume">
            <xsl:value-of select="substring-before(substring-after(//root/@id, '_'), '_')"/>
        </xsl:variable>
    <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:choose>
            <xsl:when test="number($volume) gt 16">
                <xsl:text>Language &amp; Alphabet</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Language</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
    </xsl:template>
    
    <!-- MST -->
    <xsl:template match="MST">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Manuscript's Title</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>   
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- MSL -->
    <xsl:template match="MSL">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Manuscript's Language</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>   
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- MM -->
    <xsl:template match="MM">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Madras Map Survey Number</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>   
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- MSE -->
    <xsl:template match="MSE">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Manuscript's extent</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>   
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- O -->
    <xsl:template match="O">
    <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:text>Origin</xsl:text>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>   
                <xsl:apply-templates/>
    </xsl:element>
    </xsl:template>
    
    <!-- E -->
    <xsl:template match="E">
        <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:text>Edition</xsl:text>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>
                <xsl:apply-templates/>    
    </xsl:element>
    </xsl:template>
    
    <!-- R -->
    <xsl:template match="R">
    <xsl:element name="dt">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:text>Remarks</xsl:text>
    </xsl:element>
    <xsl:element name="dd">
        <xsl:attribute name="class">col</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
    </xsl:template>

    <!-- R -->
    <xsl:template match="RY">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Regnal Year</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- SY -->
    <xsl:template match="SY">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Sáka Year</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- JY -->
    <xsl:template match="JY">
        <xsl:element name="dt">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:text>Jovian Year</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
            <xsl:attribute name="class">col</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- supplied -->
    <xsl:template match="supplied">
        <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
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
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/arie/arie-css.css"></link>
                
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
                    <li class="nav-item">
                        <a class="nav-link" href="https://erc-dharma.github.io/editorial">Editorial Conventions</a>
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
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Epigraphical Publications
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="nav-link" href="https://erc-dharma.github.io/arie">ARIE</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/tfb-ec-epigraphy/">Epigraphia Carnatica</a>
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
        <!-- loader arie -->
        <script rel="stylesheet" src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/arie/arie-loader.js"></script>
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
                    <xsl:for-each select="INSCRIPTION | MANUSCRIPT">
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link text-align-justify</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="generate-id()"/>
                                </xsl:attribute>
                                <xsl:call-template name="number"/>
                                <!--<xsl:choose>
                                    <xsl:when test="@type">
                                        <xsl:value-of select="@type"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="child::tei:ab[1]">
                                                <xsl:value-of select="child::tei:ab/@type"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="name()"/>  
                                            </xsl:otherwise>
                                        </xsl:choose>                     
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@n"/>-->
                            </xsl:element>
                            <!--<xsl:if test="descendant::tei:div">
                                <xsl:element name="ul">
                                    <xsl:attribute name="class">navbar-nav nav-second</xsl:attribute>
                                    <xsl:for-each select="descendant::tei:div">
                                        
                                        <xsl:element name="li">
                                            <xsl:attribute name="class">nav-item-second nav-item</xsl:attribute>
                                            <xsl:element name="a">
                                                <xsl:attribute name="class">nav-link-second nav-link</xsl:attribute>
                                                <xsl:attribute name="href">
                                                    <xsl:text>#</xsl:text>
                                                    <xsl:value-of select="@xml:id"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                    <xsl:when test="@type">
                                                        <xsl:value-of select="@type"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:choose>
                                                            <xsl:when test="child::tei:ab[1]">
                                                                <xsl:value-of select="child::tei:ab/@type"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="name()"/>  
                                                            </xsl:otherwise>
                                                        </xsl:choose>                     
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="@n"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:if>-->
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
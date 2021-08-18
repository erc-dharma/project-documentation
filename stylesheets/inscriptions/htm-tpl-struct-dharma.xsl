<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Contains named templates for EDH file structure (aka "metadata" aka "supporting data") -->

   <!-- Called from htm-tpl-structure.xsl -->

   <xsl:template name="dharma-body-structure">
     <!-- Main text output : (replace(. , '([a-z\)\]])/\s+([a-z\)\]])', '$1/$2')-->
                <xsl:element name="div">
              <xsl:attribute name="id">metadatadiv</xsl:attribute>
            <h2>Metadata</h2>
            <xsl:if test="//t:fileDesc/t:publicationStmt/t:idno[@type='filename'][1]">
            <h3>Identifier: </h3>
            <xsl:element name="p">
            <xsl:value-of select="replace(//t:fileDesc/t:publicationStmt/t:idno[@type='filename'], 'DHARMA_', '')"/>
            </xsl:element>
          </xsl:if>
               <xsl:if test="//t:msContents//t:summary/text()">
                  <h3>Summary: </h3>
                 <xsl:element name="p">
                  <xsl:apply-templates select="//t:msContents/t:summary" mode="dharma"/>
                </xsl:element>
               </xsl:if>
               <xsl:if test="//t:handDesc//text()">
                  <h3>Hands: </h3>
                 <xsl:choose>
                   <xsl:when test="//t:handDesc/t:handNote/t:p">
                     <xsl:for-each select="//t:handDesc/t:handNote/t:p">
                       <p>
                     <xsl:apply-templates mode="dharma"/>
                   </p>
                   </xsl:for-each>
                    <xsl:apply-templates select="//t:handDesc/t:handNote/t:p" mode="dharma"/>
                   </xsl:when>
                   <xsl:otherwise>
                     <xsl:for-each select="//t:handDesc/t:p">
                       <p>
                     <xsl:apply-templates mode="dharma"/>
                   </p>
                   </xsl:for-each>
                     </xsl:otherwise>
                 </xsl:choose>
               </xsl:if>
               <xsl:if test="//t:sourceDesc/t:biblFull/t:editionStmt/t:p">
                 <xsl:text>First edition of the file: </xsl:text>
                 <xsl:apply-templates select="//t:sourceDesc/t:biblFull/t:editionStmt/t:p" mode="dharma"/>
               </xsl:if>
          </xsl:element>
          <xsl:variable name="maintxt">
            <xsl:apply-templates/>
         </xsl:variable>
     <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
     <xsl:variable name="maintxt2">
     <xsl:apply-templates select="$maintxt" mode="sqbrackets"/>
     </xsl:variable>
     <xsl:apply-templates select="$maintxt2" mode="sqbrackets"/>

     <!-- Found in htm-tpl-license.xsl -->
     <xsl:call-template name="license"/>
  </xsl:template>

   <!-- Called from htm-tpl-structure.xsl -->
   <xsl:template name="dharma-structure">
      <xsl:variable name="title">
         <xsl:call-template name="dharma-title" />
      </xsl:variable>

      <html>
         <head>
            <title>
               <xsl:value-of select="$title"/>
            </title>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <!-- Found in htm-tpl-cssandscripts.xsl -->
            <xsl:call-template name="css-script"/>
         </head>

         <body>
           <xsl:call-template name="nav-bar"/>
            <h1>
              <xsl:value-of select="//t:teiHeader//t:title"/>
            </h1>
            <xsl:call-template name="dharma-body-structure"/>
           <xsl:call-template name="dharma-script"/>    
         </body>
      </html>
   </xsl:template>

   <xsl:template name="dharma-title">
         <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
         <xsl:choose>
            <xsl:when test="//t:titleStmt/t:title/text()">
               <xsl:if test="//t:idno[@type='filename']/text()">
                  <xsl:value-of select="//t:idno[@type='filename']"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:value-of select="//t:titleStmt/t:title"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>EpiDoc encoding inscription output, ERC-DHARMA</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:template>
  
  <xsl:template name="dharma-script">    
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
    <!--<script src="https://gitcdn.link/repo/erc-dharma/project-documentation/master/stylesheets/criticalEditions/loader.js"/>-->
    <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@master/stylesheets/criticalEditions/loader.js"/>
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
            <a class="nav-link" href="https://www.zotero.org/groups/1633743/erc-dharma/library">Zotero Library</a>
          </li>
        </ul> 
      </div>
    </nav>
  </xsl:template>
   </xsl:stylesheet>

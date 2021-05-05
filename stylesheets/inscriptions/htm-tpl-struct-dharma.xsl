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
           <nav class="navbar navbar-expand-lg navbar-light bg-light">
             <!--<img src="logo.png" alt="DHARMA" class="img-fluid"/>-->
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
                     <a class="dropdown-item" href="#tfa-collection">Task-Force A</a>
                     <a class="dropdown-item" href="#tfb-collection">Task-Force B</a>
                     <a class="dropdown-item" href="#tfc-collection">Task-Force C</a>
                     <a class="dropdown-item" href="#tfd-collection">Task-Force D</a>
                   </div>
                 </li>
                 <li class="nav-item">
                   <a class="nav-link" href="editorial">Editorial Conventions</a>
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
               </ul>
               <!--<form id="search_form" class="form-inline my-2 my-lg-0">
                 <input id="search_input" class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
                 <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
               </form>-->
             </div>
           </nav>
           
            <h1>
              <xsl:value-of select="//t:teiHeader//t:title"/>
            </h1>
            <xsl:call-template name="dharma-body-structure"/>
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




   </xsl:stylesheet>

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

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Contains named templates for EDH file structure (aka "metadata" aka "supporting data") -->

   <!-- Called from htm-tpl-structure.xsl -->

   <xsl:template name="dharma-body-structure">
     <!-- Main text output : (replace(. , '([a-z\)\]])/\s+([a-z\)\]])', '$1/$2')-->
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
              <xsl:text> (</xsl:text>
              <xsl:value-of select="//t:idno[@type='filename']"/>
              <xsl:text>) 🇧🇪 🍺</xsl:text>

            </h1>

            <xsl:element name="div">
          <xsl:attribute name="id">metadatadiv</xsl:attribute>
        <h2>Metadata</h2>
           <xsl:if test="//t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:summary">
             <xsl:text>Summary: </xsl:text>
              <xsl:value-of select="//t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:summary"/>
           </xsl:if>
           <xsl:if test="//t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:handDesc">
             <p><xsl:text>Hands: </xsl:text>
             <xsl:choose>
               <xsl:when test="//t:handDesc/t:handNote/t:p">
                 <xsl:value-of select="//t:handDesc/t:handNote/t:p"/>
               </xsl:when>
               <xsl:when test="//t:handDesc/t:p">
                   <xsl:value-of select="//t:handDesc/t:p"/>
                 </xsl:when>
             </xsl:choose>
             </p>
           </xsl:if>
      </xsl:element>
            <xsl:call-template name="dharma-body-structure" />
         </body>
      </html>
   </xsl:template>


   <xsl:template name="dharma-title">
         <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
         <xsl:choose>
            <xsl:when test="($parm-leiden-style = 'ddbdp' or $parm-leiden-style = 'sammelbuch')">
               <xsl:choose>
                  <xsl:when test="//t:sourceDesc//t:bibl/text()">
                     <xsl:value-of select="//t:sourceDesc//t:bibl"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="//t:idno[@type='filename']"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="//t:titleStmt/t:title/text()">
               <xsl:if test="//t:idno[@type='filename']/text()">
                  <xsl:value-of select="//t:idno[@type='filename']"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:value-of select="//t:titleStmt/t:title"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>EpiDoc example output, default style</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:template>

   </xsl:stylesheet>

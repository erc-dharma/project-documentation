<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-tpl-lang.xsl 1434 2011-05-31 18:23:56Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">
  <!-- Contains all language related named templates -->
    
   
   <xsl:template name="london-structure">
      <xsl:call-template name="default-structure"/>
   </xsl:template>
   
   
   <xsl:template name="hgv-structure">
      <html>
         <head>
            <title>
               <xsl:choose>
                  <xsl:when test="//t:sourceDesc//t:bibl/text()">
                     <xsl:value-of select="//t:sourceDesc//t:bibl"/>
                  </xsl:when>
                  <xsl:when test="//t:idno[@type='filename']/text()">
                     <xsl:value-of select="//t:idno[@type='filename']"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text></xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </title>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <!-- Found in htm-tpl-cssandscripts.xsl -->
            <xsl:call-template name="css-script"/>
         </head>
         <body>
            
            <!-- Heading for a ddb style file -->
            <xsl:if test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
               <h1>
                  <xsl:choose>
                     <xsl:when test="//t:sourceDesc//t:bibl/text()">
                        <xsl:value-of select="//t:sourceDesc//t:bibl"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="//t:idno[@type='filename']"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </h1>
            </xsl:if>         
            
            <!-- Main text output -->
            <xsl:apply-templates/>
            
            <!-- Found in htm-tpl-license.xsl -->
            <xsl:call-template name="license"/>
            
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="campa-structure">
      <!-- I would like to apply the namespace here, but this would require making every single xsl file namespace aware -->
      <!-- <html  xmlns="http://www.w3.org/1999/xhtml"> -->
      <html>
         <xsl:variable name="doctitle">
            <xsl:text></xsl:text><xsl:value-of select="//t:msIdentifier[t:institution='EFEO']/t:idno"/><xsl:text></xsl:text>
            <xsl:text> </xsl:text><xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title)"/><xsl:text></xsl:text>
         </xsl:variable>
         <head>
            <title><xsl:value-of select="$doctitle"/></title>
            <xsl:call-template name="css-script"/> <!-- in htm-tpl-cssandscripts.xsl -->
         </head>
         <body>
            <div id="container-outer">
               <div id="container-inner">
                  <div id="header">
                      <h1>Corpus of the Inscriptions of Campā</h1>
                     <div id="navmain">
                        <ul class="hnav">
                           <li><a href="../index.html">home</a></li>
                           <li><a href="../about.html">about</a></li>
                           <li><a href="../credits.html">credits</a></li>
                           <li class="selected"><a href="index.html">inscriptions</a></li>
                           <li><a href="../bibliography/index.html">bibliography</a></li>
                           <li><a href="../search.html">search</a></li>
                        </ul>
                     </div>
                  </div>
                   <xsl:if test="//t:facsimile">
                       <div id="images">
                           <xsl:for-each select="//t:facsimile/t:graphic">
                               <xsl:variable name="fname">
                                   <xsl:choose>
                                       <xsl:when test="ends-with(@url, '.JPG')">
                                           <xsl:value-of select="substring-before(@url, '.JPG')"/>
                                       </xsl:when>
                                       <xsl:when test="ends-with(@url, '.jpg')">
                                           <xsl:value-of select="substring-before(@url, '.jpg')"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <xsl:value-of select="@uri"/>
                                       </xsl:otherwise>
                                   </xsl:choose>
                               </xsl:variable>
                               <div class="iframe">
                                   <div class="ismall">
                                       <img src="{$fname}-small.jpg" alt="{normalize-space(.)}"/>
                                       <div class="imedium">
                                           <img src="{$fname}-medium.jpg" alt="{normalize-space(.)}"/>
                                       </div>
                                   </div>
                                   <xsl:if test="t:desc">
                                       <div class="icaption"><xsl:apply-templates select="t:desc/node()"/></div>
                                   </xsl:if>
                               </div>
                           </xsl:for-each>
                       </div>
                   </xsl:if>
                  <div id="pagebody">
                     
                     <h2><xsl:value-of select="$doctitle"/></h2>
                      <p class="caveat">Please note: you are reviewing a preprint version of this publication. Contents here may change significantly in future versions. 
                      Scholars with specific interests are urged to consult all cited bibliography before using our texts and translations or drawing
                      other significant conclusions.</p>
                     <xsl:call-template name="metadata-campa"/>
                     <h3>The following text was edited by 
                        <xsl:for-each select="//t:fileDesc/t:titleStmt/t:editor">
                           <xsl:text></xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:if test="count(following-sibling::t:editor) &gt; 1"><xsl:text>, </xsl:text></xsl:if><xsl:if test="count(following-sibling::t:editor)=1"><xsl:if test="count(../t:editor) &gt; 2"><xsl:text>,</xsl:text></xsl:if><xsl:text> and </xsl:text></xsl:if></xsl:for-each><xsl:text></xsl:text>
                           <xsl:if test="//t:fileDesc/t:titleStmt/t:respStmt">
                              <xsl:text> </xsl:text>
                              <xsl:for-each select="//t:fileDesc/t:titleStmt/t:respStmt">
                                 <xsl:text></xsl:text><xsl:value-of select="normalize-space(t:resp)"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(t:name)"/><xsl:text></xsl:text>
                              </xsl:for-each>
                           </xsl:if>.</h3>
                     <xsl:apply-templates select="//t:div[@type='edition']"/>
                     <xsl:call-template name="campa-app"/>
                      <xsl:if test="//t:div[@type='translation']">
                          <h3><strong>Translation<xsl:if test="count(//t:div[@type='translation']) &gt; 1">s</xsl:if></strong></h3>
                          <xsl:apply-templates select="//t:div[@type='translation']"/>
                      </xsl:if>
                     <xsl:if test="//t:div[@type='commentary']"><h3><strong>Commentary</strong></h3>                     
                        <xsl:apply-templates select="//t:div[@type='commentary']"/></xsl:if>
                     <xsl:if test="//t:div[@type='bibliography' and @subtype='secondary']">
                        <h3><strong>Secondary Bibliography</strong></h3>
                        <xsl:apply-templates select="//t:div[@type='bibliography' and @subtype='secondary']"/>
                     </xsl:if>
                     <xsl:if test="//t:note[not(ancestor::t:msItem) and not(ancestor::t:app)]">
                        <h3><strong>Notes</strong></h3>
                        <div id="notes">
                           <ol class="footnotes">
                              <!--
                              <xsl:for-each select="//t:physDesc//t:note, //t:msContents//t:note[not(ancestor::t:msItem)], //t:origDate//t:note, //t:origPlace//t:note, //t:msIdentifier//t:note, //t:provenance//t:note, //t:div[@type='bibliography' and @subtype='edition']//t:note, //t:surrogates//t:note, //t:div[@type='translation']//t:note, //t:div[@type='commentary']//t:note, //t:div[@type='bibliography' and @subtype='secondary']//t:note">
                                 <li id="{position()}"><xsl:apply-templates select="./node()"/></li>
                              </xsl:for-each> -->
                              
                              <xsl:for-each select="//t:physDesc//node(), //t:msContents//node()[not(ancestor::t:msItem)], //t:origDate//node(), //t:origPlace//node(), //t:provenance//node(), //t:div[@type='bibliography' and @subtype='edition']//node(), //t:surrogates//node(), //t:div[@type='translation']//node(), //t:div[@type='commentary']//node(), //t:div[@type='bibliography' and @subtype='secondary']//node()">
                                 <xsl:choose>
                                    <xsl:when test="local-name()='note'">
                                        <xsl:variable name="notepos">
                                            <xsl:call-template name="campanotenum"/>
                                        </xsl:variable>                                        
                                        <li id="{$notepos}"><xsl:apply-templates select="./node()"/></li>
                                    </xsl:when>
                                    <xsl:when test="local-name()='ptr' and starts-with(@target, '#')">
                                       <xsl:variable name="sought" select="substring-after(@target, '#')"/>
                                        <xsl:variable name="notepos">
                                            <xsl:call-template name="campanotenum"/>
                                        </xsl:variable>
                                        <xsl:for-each select="//*[@xml:id=$sought and descendant::t:note][1]">
                                          <li id="{$notepos}"><xsl:apply-templates select="./node()"/></li>
                                       </xsl:for-each>
                                       <xsl:for-each select="//t:idno[@xml:id=$sought]/following-sibling::t:note[1]">
                                           <li id="{$notepos}"><xsl:apply-templates select="./node()"/></li>
                                       </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                 </xsl:choose>
                              </xsl:for-each>
                           </ol>
                        </div>
                     </xsl:if>
                  </div>
                  <div id="footer">
                     <p><a href="./xml/{normalize-space(//t:idno[@type='filename'][1])}.xml">Download this inscription in EpiDoc XML format</a>.</p>
                     <xsl:apply-templates select="//t:publicationStmt" mode="license"/>
                  </div>
               </div>
               <div id="container-logos">
                  <div id="isaw-logo-small"><a href="http://isaw.nyu.edu" title="Visit the homepage of ISAW"><img src="../images/index/isaw-logo.jpg" alt="ISAW Logo" /></a><p><a href="http://isaw.nyu.edu" title="Visit the homepage of ISAW">Institute for the Study of the Ancient World<br />New York University</a></p>
                  </div>
                  <div id="efeo-logo-small"><a href="http://www.efeo.fr" title="Visit the homepage of EFEO"><img src="../images/index/efeo-logo.gif" alt="EFEO Logo" /></a><p><a href="http://www.efeo.fr" title="Visit the homepage of EFEO">École française d'Extrême-Orient (EFEO)</a></p>
                  </div>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="default-structure">
      <html>
         <head>
            <title>
               <xsl:choose>
                  <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
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
            </title>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <!-- Found in htm-tpl-cssandscripts.xsl -->
            <xsl:call-template name="css-script"/>
         </head>
         <body>
           <xsl:call-template name="default-body-structure"/>
         </body>
      </html>
   </xsl:template>

   <xsl:template name="default-body-structure">
      <!-- Heading for a ddb style file -->
      <xsl:if test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
         <h1>
            <xsl:choose>
               <xsl:when test="//t:sourceDesc//t:bibl/text()">
                  <xsl:value-of select="//t:sourceDesc//t:bibl"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="//t:idno[@type='filename']"/>
               </xsl:otherwise>
            </xsl:choose>
         </h1>
      </xsl:if>         
      
      <!-- Main text output -->
      <xsl:variable name="maintxt">
         <xsl:apply-templates/>
      </xsl:variable>
      
      <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
      <xsl:apply-templates select="$maintxt" mode="sqbrackets"/>
      
      <!-- Found in htm-tpl-license.xsl -->
      <xsl:call-template name="license"/>
   </xsl:template>
   
</xsl:stylesheet>

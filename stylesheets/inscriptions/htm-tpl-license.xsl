<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">
  
  <xsl:template name="license">
      <xsl:apply-templates select="//t:publicationStmt" mode="license"/>
  </xsl:template>
  
  <xsl:template match="t:publicationStmt" mode="license">
      <div id="license">
         <xsl:choose>
            <xsl:when test="p">
               <xsl:if test="contains(t:p/t:ref[@type='license']/@href,'creativecommons')">
                  <img src="http://i.creativecommons.org/l/{substring-after(t:p/t:ref[@type='license']/@href, 'licenses/')}88x31.png"
                       alt="{t:p/t:ref[@type='license']}"
                       align="left"/>
               </xsl:if>
               <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="t:availability/t:licence[contains(@target, 'http://creativecommons.org')]">
               <xsl:for-each select="t:availability/t:licence[1]">
                     
                  <xsl:variable name="lstring" select="substring-after(@target, 'http://creativecommons.org/licenses/')"/>
                  <xsl:variable name="lsplits" select="tokenize($lstring, '/')"/>
                  <xsl:variable name="ltype" select="$lsplits[1]"/>
                  <xsl:variable name="lnum" select="$lsplits[2]"/>
                  <xsl:variable name="ljuris" select="$lsplits[3]"/>
                  
                  <p>
                  <span xmlns:dct="http://purl.org/dc/terms/" property="dct:title" class="title"><xsl:value-of select="//t:idno[@xml:id='inv-general'][1]"/><xsl:text> </xsl:text><xsl:value-of select="//t:titleStmt/t:title[1]"/></span><xsl:text>: </xsl:text> 
                   <xsl:apply-templates select="t:p[1]/node()"/>
                     <br /><a rel="license" href="{@target}deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/{$ltype}/{$lnum}/80x15.png" /></a><xsl:text> </xsl:text>Licensed under a <a rel="license" href="http://creativecommons.org/licenses/{$ltype}/{$lnum}/deed.en_US">Creative Commons 
                     <xsl:choose>
                        <xsl:when test="$ltype='by'">Attribution</xsl:when>
                        <xsl:when test="$ltype='by-sa'">Attribution-ShareAlike</xsl:when>
                        <xsl:when test="$ltype='by-nc'">Attribution-NonCommercial</xsl:when>
                        <xsl:when test="$ltype='by-nc-nd'">Attribution-NonCommercial-NoDerivs</xsl:when>
                        <xsl:when test="$ltype='by-nc-sa'">Attribution-NonCommercial-ShareAlike</xsl:when>
                        <xsl:when test="$ltype='by-nd'">Attribution-NoDerivs</xsl:when>
                     </xsl:choose>
                     <xsl:text> </xsl:text><xsl:value-of select="$lnum"/><xsl:text> </xsl:text> 
                     <xsl:choose>
                        <xsl:when test="$ljuris=''">Unported</xsl:when>
                        <xsl:otherwise><xsl:value-of select="$ljuris"/></xsl:otherwise>
                     </xsl:choose>
                     License</a>.</p>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:if test="contains(t:availability/t:ref[@type='license']/@href,'creativecommons')">
                  <img src="http://i.creativecommons.org/l/{substring-after(t:availability/t:ref[@type='license']/@href, 'licenses/')}88x31.png"
                       alt="{t:availability/t:ref[@type='license']}"
                       align="left"/>
               </xsl:if>
               <xsl:apply-templates select="t:availability"/>
            </xsl:otherwise>
         </xsl:choose>
      </div>
  </xsl:template>
  
  <xsl:template match="t:ref[@type='license']">
      <a rel="license" href="{@href}">
         <xsl:apply-templates/>
      </a>
  </xsl:template>
  
</xsl:stylesheet>
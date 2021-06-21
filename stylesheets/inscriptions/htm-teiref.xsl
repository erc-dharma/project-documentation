<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                xmlns:functx="http://www.functx.com"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="t xsl functx xs"
                version="2.0">
  <xsl:include href="teiref.xsl"/>

  <xsl:function name="functx:substring-before-last-match" as="xs:string?">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:param name="regex" as="xs:string"/>
    <xsl:sequence select="replace($arg,concat('^(.*)',$regex,'.*'),'$1')"/>
  </xsl:function>

  <xsl:template match="t:ref" mode="#all">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"/>
      <xsl:choose>
         <xsl:when test="@type = 'reprint-from'">
            <br/>
            <!-- Found in teiref.xsl -->
        <xsl:call-template name="reprint-text">
               <xsl:with-param name="direction" select="'from'"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type = 'reprint-in'">
            <br/>
            <!-- Found in teiref.xsl -->
        <xsl:call-template name="reprint-text">
               <xsl:with-param name="direction" select="'in'"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type = 'Perseus'">
            <xsl:variable name="col" select="substring-before(@href, ';')"/>
            <xsl:variable name="vol" select="substring-before(substring-after(@href,';'),';')"/>
            <xsl:variable name="no" select="substring-after(substring-after(@href,';'),';')"/>
            <a href="http://www.perseus.tufts.edu/cgi-bin/ptext?doc=Perseus:text:1999.05.{$col}:volume={$vol}:document={$no}">
               <xsl:apply-templates/>
            </a>
         </xsl:when>
         <!-- Beginning of the code for ref for DHARMA -->
         <!-- https://github.com/erc-dharma/tfc-nusantara-epigraphy/blob/master/provisional/Java04Balitung2Sindok/Guntur.xml -->
         <!-- fileloc = file:/Users/axellejaniak/Documents/github/tfc-nusantara-epigraphy/provisional/Java04Balitung2Sindok/Guntur.xml -->
        <!-- <xsl:when test="$parm-leiden-style = 'dharma' and parent::t:note[ancestor::t:div[@type='translation']]"/>-->
         <xsl:when test="$parm-leiden-style = 'dharma'">
             <!-- Retriving the path from the launcher computer. -->
           <xsl:variable name="fileLoc" >
             <xsl:choose>
               <xsl:when test="./@n"/>
        <!--  fetching the name of the current repository, e.g. tfc-nusantara-epigraphy-->
               <xsl:otherwise>
             <xsl:value-of select="base-uri(.)"/>
           </xsl:otherwise>
         </xsl:choose>
           </xsl:variable>
           <xsl:variable name="identityRepository">
             <xsl:choose>
                <!--fetching the others repositories-->
               <xsl:when test="./@n">
               <xsl:value-of select="@n"/>
             </xsl:when>
        <!--  fetching the name of the current repository, e.g. tfc-nusantara-epigraphy-->
               <xsl:otherwise>
             <xsl:value-of select="concat('tf', concat(substring-before(substring-after($fileLoc, 'tf'), 'epigraphy/'), 'epigraphy'))"/>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:variable>

       <!--<xsl:variable name="pathTree" select="functx:substring-before-last-match(substring-after($fileLoc, '-epigraphy'), '/')"/>-->

           <!-- file we are looking for -->
          <!-- <xsl:variable name="fileFetched" select="./@target"/>-->

           <!-- only work if the file is in the same repository -->
           <!--<xsl:variable name="pathTree">
             <xsl:choose>-->
               <!-- files not in the repository -->
               <!-- <xsl:when test="./@n">
                   <xsl:value-of select="base-uri($fileFetched)"/>
               </xsl:when>
               <xsl:otherwise>
             <xsl:value-of select="functx:substring-before-last-match(substring-after($fileLoc, '-epigraphy'), '/')"/>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:variable>-->
           <!--Debugging messages -->
  <!--<xsl:message>fileloc = <xsl:value-of select="$fileLoc"/></xsl:message>
         <xsl:message>repository = <xsl:value-of select="$identityRepository"/></xsl:message>
               <xsl:message>filefetched = <xsl:value-of select="$fileFetched"/></xsl:message>
         <xsl:message>pathTree = <xsl:value-of select="$pathTree"/></xsl:message>-->
         <xsl:variable name="pointerGithub" select="concat('https://github.com/erc-dharma/',$identityRepository)"/><!-- ,'/blob/master',$pathTree, '/', $fileFetched -->
         <!--<xsl:message>pointerGithub = <xsl:value-of select="$pointerGithub"/></xsl:message>-->

         <a href="{$pointerGithub}">
           <xsl:apply-templates/>
         </a>
         </xsl:when>
         <xsl:otherwise>
           <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


  <xsl:template name="link-text">
      <xsl:param name="href-link"/>
      <xsl:param name="val-doc"/>

      <a href="{$href-link}">
         <xsl:apply-templates select="$val-doc"/>
      </a>
  </xsl:template>

</xsl:stylesheet>

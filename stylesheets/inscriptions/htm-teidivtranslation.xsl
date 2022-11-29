<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:EDF="http://epidoc.sourceforge.net/ns/functions" exclude-result-prefixes="t EDF" version="2.0">

   <!-- Other div matches can be found in htm-teidiv*.xsl -->

   <!-- Text edition div -->
    <xsl:template match="t:div[@type = 'translation']" priority="1">
        <xsl:param name="parm-internal-app-style" tunnel="yes" required="no"/>
        <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
       <div id="translation">


<!-- Found in htm-tpl-lang.xsl -->
         <xsl:call-template name="attr-lang"/>
             <h2>
               <!-- Changing the first letter of @ref in uppercase-->
               <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
               <xsl:call-template name="language"/>
               <xsl:call-template name="responsability"/>
             </h2>
         <xsl:apply-templates/>


           <!--<xsl:choose>
               <!-\- Apparatus creation: look in tpl-apparatus.xsl for documentation and templates -\->
               <xsl:when test="$parm-internal-app-style = 'dharma'">
                   <!-\- Framework found in htm-tpl-apparatus.xsl -\->
                   <xsl:call-template name="tpl-dharma-apparatus"/>
               </xsl:when>
           </xsl:choose>-->
         </div>
   </xsl:template>

   <xsl:template name="language">
     <xsl:if test="@xml:lang and not(@xml:lang='eng')">
       <xsl:text> into </xsl:text>
       <xsl:value-of select="/t:TEI/t:teiHeader/t:profileDesc/t:langUsage/t:language[@ident = current()/@xml:lang]"/>
       <xsl:if test="not(/t:TEI/t:teiHeader/t:profileDesc/t:langUsage/t:language[@ident = current()/@xml:lang])">
         <xsl:choose>
           <!--  <xsl:when test="@xml:lang='eng'">
             <xsl:text>English</xsl:text>
           </xsl:when>-->
           <xsl:when test="@xml:lang='fra'">
           <xsl:text>French</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:lang='ndl'">
         <xsl:text>Dutch</xsl:text>
       </xsl:when>
         </xsl:choose>
       </xsl:if>
       </xsl:if>
   </xsl:template>

 <!-- CURRENTLY reworking the code for @source, effective  if only one author-->
   <xsl:template name="responsability">
  <xsl:param name="parm-zoteroUorG" tunnel="yes" required="no"/>
      	<xsl:param name="parm-zoteroKey" tunnel="yes" required="no"/>
     <!-- The responsability template could probably be used in several part, rather than repeating the code. Need to be cleaned at some point-->
      <xsl:variable name="biblresp"
        select="replace(substring-after(@source, ':'), '\+', '%2B')"/>


  <xsl:variable name="zoteroapijsonresp">
       <xsl:value-of
         select="replace(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblresp, '&amp;format=json'), 'amp;', '')"
       />
     </xsl:variable>
     <xsl:variable name="unparsedresp" select="unparsed-text($zoteroapijsonresp)"/>


            <xsl:if test="@source">
         <xsl:text> by </xsl:text>
         <xsl:element name="span">
           <xsl:attribute name="class">resp</xsl:attribute>
           <xsl:choose>
              <xsl:when test="matches(@source, '\+[a][l]')">
                  <xsl:analyze-string select="$unparsedresp"
                    regex="(^\s+&quot;lastName&quot;:\s&quot;)(.+)(&quot;)">
                    <xsl:matching-substring>
                      <xsl:value-of select="regex-group(2)"/>
                    </xsl:matching-substring>
                  </xsl:analyze-string>
                  <xsl:text> &amp; al </xsl:text>
              </xsl:when>
               <xsl:when test="matches(@source, '\+[A-Z]')">
                 <xsl:analyze-string select="$unparsedresp"
                   regex="(^\s+&quot;lastName&quot;:\s&quot;)(.+)(&quot;)">
                   <xsl:matching-substring>
                     <xsl:value-of select="regex-group(2)"/>
                   </xsl:matching-substring>
                 </xsl:analyze-string>
               </xsl:when>
               <xsl:otherwise>
         <xsl:analyze-string select="$unparsedresp"
           regex="(\s+&quot;lastName&quot;:\s&quot;)(.+)(&quot;)">
           <xsl:matching-substring>
             <xsl:value-of select="regex-group(2)"/>
           </xsl:matching-substring>
         </xsl:analyze-string>
       </xsl:otherwise>
       </xsl:choose>
       </xsl:element>
         <xsl:text> </xsl:text>
         <xsl:analyze-string select="$unparsedresp"
           regex="(\s+&quot;date&quot;:\s&quot;)(.+)(&quot;)">
           <xsl:matching-substring>
             <xsl:value-of select="regex-group(2)"/>
           </xsl:matching-substring>
         </xsl:analyze-string>
       </xsl:if>
  <!--  <xsl:if test="@source">
       <xsl:text> by </xsl:text>
       <xsl:choose>
         <xsl:when test="matches(@source, '\+[a][l]')">
             <xsl:value-of select="replace(replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '\+', ' &amp; '), '([a-z])([0-9])', '$1 $2'), ' bib:', ' '), '([0-9\-]+)', '($1)')"/>
         </xsl:when>
         <xsl:when test="matches(@source, '\+[A-Z]')">
             <xsl:value-of select="replace(replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '\+', ' &amp; '), '([a-z])([0-9])', '$1 $2'), ' bib:', ' '), '([0-9\-]+)', '($1)')"/>
         </xsl:when>
         <xsl:otherwise>
        <xsl:value-of select="replace(replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '([a-z])([A-Z])', '$1 $2'), '([a-z])([0-9])', '$1 $2'), ' bib:', ' '), '([0-9\-]+)', '($1)')"/>
      </xsl:otherwise>
        </xsl:choose>
      </xsl:if>-->
      <xsl:if test="@resp">
        <xsl:call-template name="respID"/>
      </xsl:if>
   </xsl:template>


 <!-- Template to display members of the project when they use their ID inside a @resp-->
 <!-- The code has been adapted from a part of a code written by Tom Elliot for Campa-->
   <xsl:template name="respID">
      <xsl:variable name="referrer" select="."/>
      <xsl:variable name="sought" select="for $token in tokenize(@resp, ' ') return substring($token, 6)"/>
     <!-- <xsl:message>sought = <xsl:value-of select="$sought"/> and <xsl:value-of select="count($sought)"/></xsl:message>-->
      <xsl:variable name="dharma-path">
         <xsl:choose>
            <xsl:when test="$edn-structure='default'">../../DHARMA_idListMembers_v01.xml</xsl:when>
            <xsl:otherwise>https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_idListMembers_v01.xml</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
                    	<!-- Debugging message-->
            <!--<xsl:message>prefix = <xsl:value-of select="$prefix"/></xsl:message>
            <xsl:message>sought = <xsl:value-of select="$sought"/></xsl:message>-->
            <!-- Pb ne prend en compte qu'un seul resp. -->
                  <xsl:choose>
                     <xsl:when test="count(document($dharma-path)/*/descendant-or-self::*[@xml:id=$sought]) &gt; 0">
                        <xsl:for-each select="document($dharma-path)/*/descendant-or-self::*[@xml:id=$sought]">
                          <xsl:sort data-type="text" order="ascending"
                                  select="./child::*[1]/child::node()[1]/following-sibling::*[2]"/>
                                  <xsl:choose>
                              <xsl:when test="local-name()='person'">
                                <xsl:choose>
                                  <xsl:when test="position()= 1">
                                    <xsl:text> by </xsl:text>
                                  </xsl:when>
                                  <xsl:when test="position()=last()">
                                     <xsl:text> and </xsl:text>
                                     </xsl:when>
                                     <xsl:otherwise>
                                     <xsl:text> , </xsl:text>
                                   </xsl:otherwise>
                                   </xsl:choose>
                                <xsl:value-of select="./child::*[1]/child::node()[1]/following-sibling::*[1]"/>
                                <xsl:text> </xsl:text>
                                <xsl:element name="span">
                                  <xsl:attribute name="class">resp</xsl:attribute>
                                  <xsl:value-of select="./child::*[1]/child::node()[1]/following-sibling::*[2]"/>
                                </xsl:element>
                             <!--  <xsl:value-of select="./child::*/node()[2]"/>-->
                            </xsl:when>
                              <xsl:otherwise>
                              <xsl:text>Error at this level</xsl:text>
                            </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <span class="xformerror">failed to find content in file for xml:id='<xsl:value-of select="$sought"/>'</span>
                     </xsl:otherwise>
                  </xsl:choose>
   </xsl:template>

</xsl:stylesheet>

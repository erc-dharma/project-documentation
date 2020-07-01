<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:div">
    <!-- div[@type = 'edition']" and div[@type='textpart'] can be found in htm-teidivedition.xsl -->
    <xsl:if test="descendant::*">
        <div>
          <xsl:if test="parent::t:body and @type">
            <xsl:attribute name="id">
              <xsl:value-of select="@type"/>
            </xsl:attribute>
          </xsl:if>
          <!-- Headings are necessary for DHARMA -->
          <xsl:if test="not(t:head)">
            <xsl:choose>
              <xsl:when test="@type='commentary' and @subtype='frontmatter'"><h3>Introduction</h3></xsl:when>
              <xsl:when test="@type='commentary' and @subtype='linebyline'"><h3>Notes</h3></xsl:when>
              <xsl:when test="@type = 'translation'">
                  <h2>
                    <!-- Changing the first letter of @ref in uppercase-->
                    <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
                    <xsl:call-template name="language"/>
                    <xsl:call-template name="responsability"/>
                  </h2>
              </xsl:when>
               <xsl:when test="parent::t:body and @type">
                <h2>
                <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
              </h2>
            </xsl:when>
       <xsl:otherwise>
                  <h3>
                     <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
                     <xsl:if test="string(@subtype)">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="@subtype"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@n"/>
                     </xsl:if>
                  </h3>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!--<xsl:if test="t:head">
            <xsl:choose>
            <xsl:when test="parent::t:body and @type">
             <h2>
             <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
             <xsl:call-template name="language"/>
           </h2>
         </xsl:when>
         </xsl:choose>
       </xsl:if>-->
          <!-- Body of the div -->
          <xsl:apply-templates/>

        </div>
</xsl:if>
  </xsl:template>

  <xsl:template name="language">
    <xsl:if test="@xml:lang">
      <xsl:text> into </xsl:text>
      <xsl:value-of select="/t:TEI/t:teiHeader/t:profileDesc/t:langUsage/t:language[@ident = current()/@xml:lang]"/>
      <xsl:if test="not(/t:TEI/t:teiHeader/t:profileDesc/t:langUsage/t:language[@ident = current()/@xml:lang])">
        <xsl:choose>
            <xsl:when test="@xml:lang='eng'">
            <xsl:text>English</xsl:text>
          </xsl:when>
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

  <xsl:template name="responsability">
    <!-- The responsability template could probably be used in several part, rather than repeating the code. Need to be cleaned at some point-->
    <xsl:if test="@source">
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
     </xsl:if>
     <xsl:if test="@resp">
       <xsl:call-template name="respID"/>
     </xsl:if>
  </xsl:template>


<!-- Template to display members of the project when they use their ID inside a @resp-->
<!-- The code has been adapted from a part of a code written by Tom Elliot for Campa-->
  <xsl:template name="respID">
     <xsl:variable name="referrer" select="."/>
     <xsl:variable name="sought" select="for $token in tokenize(@resp, ' ') return substring($token, 6)"/>
     <xsl:message>sought = <xsl:value-of select="$sought"/> and <xsl:value-of select="count($sought)"/></xsl:message>
     <xsl:variable name="dharma-path">
        <xsl:choose>
           <xsl:when test="$edn-structure='default'">../../DHARMA_IdListMembers_v01.xml</xsl:when>
           <xsl:otherwise>https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_IdListMembers_v01.xml</xsl:otherwise>
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

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teiref.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">
  <xsl:include href="teiref.xsl"/>
  
  <xsl:template match="t:ref">
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
         <xsl:when test="@target">
            <xsl:choose>
               <xsl:when test="starts-with(@target, '#')">
                  <xsl:call-template name="ref-internal"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="ref-external"/>
               </xsl:otherwise>
            </xsl:choose>
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
         <xsl:value-of select="$val-doc"/>
      </a>
  </xsl:template>
   
   <xsl:template name="ref-internal">
      <xsl:variable name="referrer" select="."/>
      <xsl:variable name="sought" select="substring-after(@target, '#')"/>
      <xsl:element name="a"><xsl:for-each select="//*[@xml:id=$sought][1]">
         <xsl:attribute name="href">#<xsl:value-of select="$sought"/></xsl:attribute>
         <xsl:apply-templates select="./node()"/>
      </xsl:for-each></xsl:element>
   </xsl:template>
   
   <xsl:template name="ref-external">
      <xsl:variable name="referrer" select="."/>
      <xsl:choose>
         <xsl:when test="contains(@target, ':')">
            <xsl:variable name="prefix" select="substring-before(@target, ':')"/>
            <xsl:variable name="sought" select="substring-after(@target, ':')"/>
            <xsl:message>prefix = <xsl:value-of select="$prefix"/></xsl:message>
            <xsl:message>sought = <xsl:value-of select="$sought"/></xsl:message>
            <xsl:choose>
               <xsl:when test="$edn-structure='campa'">
                  <xsl:variable name="cic-path">
                     <xsl:choose>
                        <xsl:when test="$prefix = 'cic-bibl'">../../bibliography/biblio.xml</xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:choose>
                     <xsl:when test="count(document($cic-path, .)/*/descendant-or-self::*[@xml:id=$sought]) &gt; 0">
                        <xsl:for-each select="document($cic-path, .)/*/descendant-or-self::*[@xml:id=$sought][1]">
                           <xsl:choose>
                              <xsl:when test="local-name()='biblStruct'">
                                 <xsl:text></xsl:text><a href="../biblio#{$sought}"><xsl:apply-templates select="$referrer/node()"/></a><xsl:text></xsl:text>
                              </xsl:when>
                           </xsl:choose>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <span class="xformerror">failed to find content in biblio.xml for xml:id='<xsl:value-of select="$sought"/>'</span>                        
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <span class="xformerror">external pointers not implemented for $edn-structure != 'campa' (target='<xsl:value-of select="@target"/>')</span>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="starts-with(@target, 'C') and ends-with(@target, '.xml')">
            <xsl:variable name="cic-path">./<xsl:value-of select="@target"/></xsl:variable>
            <xsl:variable name="targeted" select="document($cic-path, .)"/>
            <xsl:choose>
               <xsl:when test="count($targeted) &gt; 0">
                  <xsl:text></xsl:text><a href="{substring-before(@target, '.xml')}.html"><xsl:apply-templates select="$referrer/node()"/></a><xsl:text></xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <span class="check"><a href="{substring-before(@target, '.xml')}.html"><xsl:apply-templates select="$referrer/node()"/></a></span>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <span class="xformerror">external pointers not implemented for targets like '<xsl:value-of select="@target"/>'</span>
         </xsl:otherwise>
      </xsl:choose>      
   </xsl:template>
  
</xsl:stylesheet>
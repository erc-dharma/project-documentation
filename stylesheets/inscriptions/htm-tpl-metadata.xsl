<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-tpl-metadata.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" 
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:url="http://whatever/java/java.net.URLEncoder"
                exclude-result-prefixes="t url" 
                version="2.0">
  <!-- Called from start-edition.xsl -->

  <xsl:template name="metadata">
      <p>
         <strong>Publikation: </strong>
         <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
            /t:listBibl/t:bibl[@type = 'publication' and @subtype = 'principal']/t:title[@type = 'abbreviated']"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
            /t:listBibl/t:bibl[@type = 'publication' and @subtype = 'principal']/t:biblScope[@type='volume']"/>
         <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
            /t:listBibl/t:bibl[@type = 'publication' and @subtype = 'principal']/t:biblScope[@type='fascicle']"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
            /t:listBibl/t:bibl[@type = 'publication' and @subtype = 'principal']/t:biblScope[@type='numbers']"/>
      </p>
      <xsl:if test="//t:div[@type = 'bibliography' and @subtype = 'otherPublications']">
         <p>
            <strong>Andere Publikationen: </strong>
            <xsl:for-each select="//t:div[@type = 'bibliography' and @subtype = 'otherPublications']//t:bibl">
               <xsl:value-of select="."/>
               <xsl:if test="following-sibling::t:bibl">
                  <xsl:text>; </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </p>
      </xsl:if>
      <p>
         <strong>Datierung: </strong>
         <xsl:value-of select="//t:div[@type = 'commentary' and @subtype = 'textDate']
            /t:p/t:date[@type = 'textDate']"/>
      </p>
      <p>
         <strong>Ort: </strong>
         <xsl:value-of select="//t:div[@type = 'history' and @subtype = 'locations']/t:p"/>
      </p>
      <p>
         <strong>Originaltitel: </strong>
         <xsl:value-of select="//t:teiHeader/t:fileDesc/t:titleStmt/t:title"/>
      </p>
      <p>
         <strong>Material: </strong>
         <xsl:value-of select="//t:div[@type = 'description']//t:rs[@type = 'material']"/>
      </p>
      <p>
         <strong>Abbildung: </strong>
         <xsl:choose>
            <xsl:when test="//t:div[@type='bibliography' and @subtype='illustrations']//t:bibl[@type = 'illustration']">
               <xsl:for-each select="//t:div[@type='bibliography' and @subtype='illustrations']//t:bibl[@type = 'illustration']">
                  <xsl:if test="preceding-sibling::t:bibl[@type = 'illustration']">
                     <xsl:text>, </xsl:text>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>keiner</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="string(//t:div[@type='figure']//t:figure/@href)">
            <xsl:for-each select="//t:div[@type='figure']//t:figure[string(@href)]">
               <br/>
               <a href="{@href}">
                  <xsl:value-of select="t:figDesc"/>
               </a>
            </xsl:for-each>
         </xsl:if>
      </p>
      <xsl:if test="//t:div[@type = 'bibliography' and @subtype = 'corrections']">
         <p>
            <strong>
               <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'corrections']/t:head"/>
               <xsl:text>: </xsl:text>
            </strong>
            <xsl:for-each select="//t:div[@type = 'bibliography' and @subtype = 'corrections']//t:bibl">
               <xsl:if test="preceding-sibling::t:bibl">
                  <xsl:text>, </xsl:text>
               </xsl:if>
               <xsl:value-of select="."/>
            </xsl:for-each>
         </p>
      </xsl:if>
      <p>
         <strong>Text der DDBDP: </strong>
         <xsl:variable name="db-link">
            <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
               /t:listBibl/t:bibl[@type = 'DDbDP']/t:series"/>
            <xsl:text>:volume=</xsl:text>
            <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
               /t:listBibl/t:bibl[@type = 'DDbDP']/t:biblScope[@type = 'volume']"/>
            <xsl:text>:document=</xsl:text>
            <xsl:value-of select="//t:div[@type = 'bibliography' and @subtype = 'principalEdition']
               /t:listBibl/t:bibl[@type = 'DDbDP']/t:biblScope[@type = 'numbers']"/>
         </xsl:variable>
         <a>
            <xsl:attribute name="href">
               <xsl:text>http://www.perseus.tufts.edu/cgi-bin/ptext?doc=Perseus:text:1999.05.</xsl:text>
               <xsl:value-of select="$db-link"/>
            </xsl:attribute>
            <xsl:text>Server in Somerville</xsl:text>
         </a>
         <xsl:text> </xsl:text>
         <a>
            <xsl:attribute name="href">
               <xsl:text>http://perseus.mpiwg-berlin.mpg.de/cgi-bin/ptext?doc=Perseus:text:1999.05.</xsl:text>
               <xsl:value-of select="$db-link"/>
            </xsl:attribute>
            <xsl:text>Server in Berlin</xsl:text>
         </a>
      </p>
      <p>
         <strong>Bemerkungen: </strong>
         <xsl:value-of select="//t:div[@type = 'commentary' and @subtype = 'general']/t:p"/>
      </p>
      <xsl:if test="//t:div[@type='bibliography' and @subtype='translations']">
         <p>
            <strong>Übersetzungen: </strong>
            <xsl:for-each select="//t:div[@type='bibliography' and @subtype='translations']/t:listBibl">
               <xsl:value-of select="t:head"/>
               <xsl:text> </xsl:text>
               <xsl:for-each select="t:bibl[@type = 'translations']">
                  <xsl:if test="preceding-sibling::t:bibl[@type = 'translations']">
                     <xsl:text>, </xsl:text>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:for-each>
            </xsl:for-each>
         </p>
      </xsl:if>
      <p>
         <strong>Inhalt: </strong>
         <xsl:for-each select="//t:teiHeader/t:profileDesc//t:keywords/t:term/t:rs[@type = 'textType']">
            <xsl:if test="preceding-sibling::t:rs">
               <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
         </xsl:for-each>
      </p>
      <xsl:if test="//t:div[@type = 'commentary' and @subtype = 'mentionedDates']//t:date[@type = 'mentioned']">
         <p>
            <strong>
               <xsl:value-of select="//t:div[@type = 'commentary' and @subtype = 'mentionedDates']/t:head"/>
               <xsl:text>: </xsl:text>
            </strong>
            <xsl:for-each select="//t:div[@type = 'commentary' and @subtype = 'mentionedDates']/t:p">
               <xsl:value-of select="."/>
               <xsl:if test="following-sibling::t:p">
                  <xsl:text>; </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </p>
      </xsl:if>

  </xsl:template>
   
   <xsl:template name="metadata-campa">
      
      <div id="metadata">
         <div id="support-desc">
            <xsl:apply-templates select="//t:physDesc" mode="metadata-campa"/>
         </div>
         <div id="text-desc">
            <xsl:apply-templates select="//t:msContents" mode="metadata-campa"/>
         </div>
         <div id="date">
            <xsl:choose>
               <xsl:when test="//t:history/t:origin/t:origDate">
                  <p><strong>Date</strong><xsl:text> </xsl:text><xsl:apply-templates select="//t:history/t:origin/t:origDate" mode="metadata-campa"/></p>
               </xsl:when>
            </xsl:choose>
         </div>
         <div id="origin">
            <p><strong>Origin</strong><xsl:text> </xsl:text><xsl:apply-templates select="//t:history/t:origin/t:origPlace/*" mode="metadata-campa"/></p>
         </div>
         <div id="observation">
            <p><xsl:apply-templates select="//t:history/t:provenance" mode="metadata-campa"/></p>
         </div>
         <xsl:if test="//t:div[@type='bibliography' and @subtype='edition']"><div id="editions">
            <p><strong>Edition(s)</strong><xsl:text> </xsl:text>
               <xsl:apply-templates select="//t:div[@type='bibliography' and @subtype='edition']/t:*[local-name()='p' or local-name()='ab']/node() | //t:div[@type='bibliography' and @subtype='edition']/t:bibl" mode="metadata-campa"/></p>
         </div></xsl:if>
         <xsl:if test="//t:msDesc/t:additional/t:surrogates"><div id="facsimiles">
            <p><strong>Facsimile<xsl:if test="count(//t:msDesc/t:additional/t:surrogates/*) &gt; 1">s</xsl:if></strong></p>
            <xsl:apply-templates select="//t:msDesc/t:additional/t:surrogates" mode="metadata-campa"/>
         </div></xsl:if>
      </div>
   </xsl:template>
   
   <xsl:template match="t:physDesc" mode="metadata-campa">
      <xsl:comment>handling t:physDesc</xsl:comment>
       <xsl:if test="t:objectDesc">
           <xsl:choose>
               <xsl:when test="(not(descendant::t:support/t:p) or count(descendant::t:support/t:p)=1) and (not(descendant::t:layout/t:p) or count(descendant::t:layout/t:p)=1)">
                   <p><strong>Support</strong><xsl:text> </xsl:text>
                   <xsl:for-each select="descendant::t:support/t:p | descendant::t:support[not(t:p)] | descendant::t:layout/t:p | descendant::t:layout[not(t:p)]">
                       <xsl:apply-templates mode="metadata-campa"/>
                   </xsl:for-each>
                   </p>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:for-each select="descendant::t:support[not(t:p)] | descendant::t:support/t:p | descendant::t:layout[not(t:p)] | descendant::t:layout/t:p">
                       <p>
                           <xsl:if test="self::t:support or (parent::t:support and self::t:p and not(preceding-sibling::t:p))">
                               <strong>Support</strong>
                               <xsl:text> </xsl:text>
                           </xsl:if>
                           <xsl:apply-templates mode="metadata-campa"/>
                       </p>
                   </xsl:for-each>
               </xsl:otherwise>
           </xsl:choose>
           
       </xsl:if>
   </xsl:template>
    
    <xsl:template match="t:rs" mode="metadata-campa">
        <xsl:text></xsl:text><xsl:apply-templates mode="metadata-campa"/><xsl:text></xsl:text>
    </xsl:template>
   
   <xsl:template match="t:objectType | t:material" mode="metadata-campa">
      <xsl:call-template name="gen-search">
         <xsl:with-param name="class">
            <xsl:choose>
               <xsl:when test="local-name()='objectType'">
                  <xsl:text>objects</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text></xsl:text><xsl:value-of select="local-name()"/><xsl:text>s</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
         <xsl:with-param name="value" select="."/>
         <xsl:with-param name="text" select="."/>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="gen-search">
      <xsl:param name="class">search</xsl:param>
      <xsl:param name="value"/>
      <xsl:param name="text"/>
      <xsl:param name="kite"/>
      
      <xsl:message>***** gen-search *****</xsl:message>
      <xsl:message>class = "<xsl:value-of select="$class"/>"</xsl:message>
      <xsl:message>value = "<xsl:value-of select="$value"/>"</xsl:message>
      <xsl:message>text = "<xsl:value-of select="$text"/>"</xsl:message>
      <xsl:element name="a">
         <xsl:attribute name="class" select="lower-case(normalize-space($class))"/>
         <xsl:attribute name="href">
            <xsl:choose>
               <xsl:when test="function-available('url:encode')">
                  <xsl:text></xsl:text><xsl:value-of select="$search-base"/>/<xsl:value-of select="url:encode(lower-case(normalize-space(replace($class, ' ', '-'))))"/>/<xsl:value-of select="url:encode(lower-case(normalize-space($value)))" /><xsl:text></xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:message>url:encode is not available in template gen-search (htm-tpl-metadata.xsl) so search links are BUSTED</xsl:message>
               </xsl:otherwise>
            </xsl:choose><xsl:text></xsl:text>
         </xsl:attribute>
         <xsl:if test="$kite != ''">
            <xsl:attribute name="title"><xsl:value-of select="normalize-space($kite)"/></xsl:attribute>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$text instance of text()">
               <xsl:message>it's text!!</xsl:message>
               <xsl:text></xsl:text><xsl:value-of select="$text"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="$text instance of node()">
               <xsl:message>it's a NODE!!! localname="<xsl:value-of select="local-name($text)"/>"</xsl:message>
               <xsl:text></xsl:text><xsl:apply-templates select="$text/node()"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message>what the?</xsl:message>
               <xsl:text></xsl:text><xsl:value-of select="$text"/><xsl:text></xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element><xsl:text></xsl:text> 
   </xsl:template>
   
   <xsl:template match="t:dimensions" mode="metadata-campa">
      <!-- <xsl:text></xsl:text><span class="dimensions"><xsl:text></xsl:text><xsl:if test="t:width">W. <xsl:apply-templates select="t:width"/></xsl:if><xsl:if test="t:height">
         <xsl:if test="t:width"><xsl:text> × </xsl:text></xsl:if>H. <xsl:apply-templates select="t:height"/></xsl:if><xsl:if test="t:depth">
         <xsl:if test="t:width or t:height"> × </xsl:if>D. <xsl:value-of select="t:depth"/></xsl:if><xsl:if test="@unit"><xsl:text> </xsl:text><xsl:value-of select="@unit"/></xsl:if></span><xsl:text></xsl:text>
         -->
       <xsl:text></xsl:text><span class="dimensions"><xsl:apply-templates select="*" mode="metadata-campa"/></span><xsl:text></xsl:text>
   </xsl:template>
   
   <xsl:template match="t:height[not(ancestor::t:dimensions)] | t:width[not(ancestor::t:dimensions)] | t:depth[not(ancestor::t:dimensions)]" mode="metadata-campa"><xsl:apply-templates/><xsl:if test="@unit"><xsl:text> </xsl:text><xsl:value-of select="@unit"/></xsl:if></xsl:template>
   
    <xsl:template match="t:*[parent::t:dimensions and not(self::t:dim)]"  mode="metadata-campa">
        <xsl:choose>
            <xsl:when test="preceding-sibling::t:*[1][not(self::t:dim)]">
                <xsl:text> × </xsl:text>
            </xsl:when>
            <xsl:when test="preceding-sibling::t:*[1][self::t:dim]">
                <xsl:text>, </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="not(ancestor-or-self::t:*[@rend='none'])">
            <xsl:text></xsl:text><xsl:value-of select="lower-case(substring(local-name(), 1, 1))"/><xsl:text>. </xsl:text>
        </xsl:if>       
        <xsl:variable name="textcontent" select="normalize-space()"/>
        <xsl:variable name="extentcontent" select="normalize-space(./@extent)"/>        
        <xsl:choose>
            <xsl:when test="./@extent and number($textcontent)!=number($extentcontent)">
                <xsl:text></xsl:text><xsl:value-of select="$textcontent"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@scope and not(ancestor-or-self::t:*[@rend='none'])">
                    <xsl:text>(</xsl:text><xsl:value-of select="@scope"/><xsl:text>) </xsl:text>
                </xsl:if>
                <xsl:if test="@precision='low'">
                    <xsl:text>ca. </xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$textcontent!= '' and string(number($textcontent))!=$textcontent">
                        <xsl:text></xsl:text><xsl:value-of select="$textcontent"/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="not(@atLeast) and not(@atMost) and not(@quantity) and (string-length(.) &gt; 0 or count(./*) &gt; 0)">
                        <xsl:text></xsl:text><xsl:apply-templates/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="@atLeast and @atMost">
                        <xsl:text></xsl:text><xsl:value-of select="@atLeast"/>-<xsl:value-of select="@atMost"/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="@quantity">
                        <xsl:text></xsl:text><xsl:value-of select="@quantity"/><xsl:text></xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@unit and not(ancestor-or-self::t:*[@rend='none'])">
                <xsl:text> </xsl:text><xsl:value-of select="@unit"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="../@unit and not(preceding-sibling::t:*) and not(ancestor-or-self::t:*[@rend='none'])">
                <xsl:text> </xsl:text><xsl:value-of select="../@unit"/><xsl:text></xsl:text>
            </xsl:when>
        </xsl:choose>
        

   </xsl:template>
    
    <xsl:template match="t:dim[@type and parent::t:dimensions]" mode="metadata-campa">
        <xsl:message>processing a dim under a dimensions</xsl:message>
        <xsl:text></xsl:text><xsl:if test="preceding-sibling::t:*"><xsl:text>, </xsl:text></xsl:if><xsl:value-of select="@type"/><xsl:text> </xsl:text>
        <xsl:variable name="textcontent" select="normalize-space()"/>
        <xsl:variable name="extentcontent" select="normalize-space(./@extent)"/>
        <xsl:message>textcontent: <xsl:value-of select="$textcontent"/></xsl:message>
        <xsl:message>extentcontent: <xsl:value-of select="$extentcontent"/></xsl:message>
        <xsl:choose>
            <xsl:when test="./@extent and number($textcontent)!=number($extentcontent)">
                <xsl:message>going with text content</xsl:message>
                <xsl:text></xsl:text><xsl:value-of select="$textcontent"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@scope and not(ancestor-or-self::t:*[@rend='none'])">
                    <xsl:text>(</xsl:text><xsl:value-of select="@scope"/><xsl:text>) </xsl:text>
                </xsl:if>
                <xsl:if test="@precision='low'">
                    <xsl:text>ca. </xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$textcontent!= '' and string(number($textcontent))!=$textcontent">
                        <xsl:text></xsl:text><xsl:value-of select="$textcontent"/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="not(@atLeast) and not(@atMost) and not(@quantity) and (string-length(.) &gt; 0 or count(./*) &gt; 0)">
                        <xsl:text></xsl:text><xsl:apply-templates/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="@atLeast and @atMost">
                        <xsl:text></xsl:text><xsl:value-of select="@atLeast"/>-<xsl:value-of select="@atMost"/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="@quantity">
                        <xsl:text></xsl:text><xsl:value-of select="@quantity"/><xsl:text></xsl:text>
                    </xsl:when>
                </xsl:choose>
                
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@unit and not(ancestor-or-self::t:*[@rend='none'])">
                <xsl:text> </xsl:text><xsl:value-of select="@unit"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="../@unit and not(preceding-sibling::t:*) and not(ancestor-or-self::t:*[@rend='none'])">
                <xsl:text> </xsl:text><xsl:value-of select="../@unit"/><xsl:text></xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
   
   <xsl:template match="t:msContents" mode="metadata-campa">
      <xsl:comment>handling t:msContents</xsl:comment>
      <xsl:choose>
         <xsl:when test="not(t:msItem)">
            <span class="xformerror">did not find t:msItem inside t:msContents</span>
         </xsl:when>
         <xsl:when test="count(t:msItem) = 1">
            <xsl:text></xsl:text><p><strong>Text</strong><xsl:text> </xsl:text><xsl:apply-templates select="t:msItem" mode="metadata-campa"/><xsl:text></xsl:text></p>
         </xsl:when>
         <xsl:otherwise>
            <p><strong><xsl:value-of select="count(t:msItem)"/> texts appear on this object:</strong></p>
            <ul>
               <xsl:for-each select="t:msItem">
                  <li><xsl:apply-templates select="." mode="metadata-campa"/></li>
               </xsl:for-each>
            </ul>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="t:msItem" mode="metadata-campa">
      <xsl:text></xsl:text><xsl:apply-templates select="*" mode="metadata-campa"/><xsl:text></xsl:text>
      <xsl:text></xsl:text><xsl:for-each select="t:locus">
         <xsl:call-template name="do-locus"/>
      </xsl:for-each><xsl:text>.</xsl:text>
   </xsl:template>
   
   <xsl:template match="t:surrogates" mode="metadata-campa">
      <ul>
         <xsl:for-each select="*">
            <li><xsl:choose>
               <xsl:when test="local-name()='msDesc' and starts-with(@n, 'estampage')">
                  <xsl:text>Estampage: </xsl:text><xsl:value-of select="t:msIdentifier/t:repository"/><xsl:text> </xsl:text><xsl:value-of select="t:msIdentifier/t:idno"/><xsl:text></xsl:text>
               </xsl:when>
               <xsl:when test="local-name()='msDesc'">
                  <xsl:text></xsl:text><xsl:value-of select="concat(upper-case(substring(@n, 1, 1)), substring(@n, 2))"/><xsl:text>: </xsl:text><xsl:value-of select="t:msIdentifier/t:repository"/><xsl:text> n. </xsl:text><xsl:value-of select="t:msIdentifier/t:idno"/><xsl:text></xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text></xsl:text><xsl:apply-templates select="./node()"/><xsl:text></xsl:text>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="local-name()='msDesc' and t:ab">
                  <xsl:choose>
                     <xsl:when test="t:ab/t:note and not(t:ab/text())">
                        <xsl:text>.</xsl:text><xsl:apply-templates select="t:ab/t:note"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text> (</xsl:text><xsl:apply-templates select="t:ab/node() | t:p/node()"/><xsl:text>).</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <!-- <xsl:text>.</xsl:text> -->
               </xsl:otherwise>
            </xsl:choose>
            </li>
         </xsl:for-each>
      </ul>
   </xsl:template>
   
   <xsl:template match="t:note[ancestor::t:msItem]" mode="metadata-campa">
      <xsl:text></xsl:text><xsl:apply-templates mode="metadata-campa"/><xsl:text></xsl:text>
   </xsl:template>
   
   <xsl:template match="t:textLang" mode="metadata-campa">
      <xsl:text> </xsl:text><xsl:choose>
         <xsl:when test="preceding-sibling::*[position()=1 and local-name()='note' and substring(., string-length(normalize-space(.)), 1)='.']">W</xsl:when>
         <xsl:otherwise>w</xsl:otherwise>
      </xsl:choose><xsl:text>ritten in </xsl:text><xsl:call-template name="gen-search">
         <xsl:with-param name="class">languages</xsl:with-param>
         <xsl:with-param name="value" select="./@mainLang"/>
         <xsl:with-param name="text">
            <xsl:choose>
               <xsl:when test="contains(., ' in Old Cam script')">
                  <xsl:text></xsl:text><xsl:value-of select="substring-before(., ' in Old Cam script')"/><xsl:text></xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text></xsl:text><xsl:value-of select="."/><xsl:text></xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
      </xsl:call-template><xsl:text></xsl:text>
   </xsl:template>
   
   <xsl:template match="t:origDate" mode="metadata-campa">
      <xsl:text></xsl:text><xsl:apply-templates mode="metadata-campa"/><xsl:text></xsl:text>
   </xsl:template>
   
   <xsl:template match="t:date[not(@calendar='Julian') and not(@calendar!='Śaka')]" mode="metadata-campa">
      <xsl:text></xsl:text><span class="xformerror"><xsl:value-of select="."/><xsl:text> </xsl:text>unknown era, @calendar value of '<xsl:value-of select="@calendar"/>'</span><xsl:text></xsl:text>
   </xsl:template>
   
   <xsl:template match="t:date[@calendar='Śaka']" mode="metadata-campa">
      <xsl:message>note that currently nothing is done to make dates searchable</xsl:message>
      <xsl:comment>note that currently nothing is done to make dates searchable</xsl:comment>
      <xsl:text></xsl:text><xsl:choose>
         <xsl:when test="ends-with(., 'th')">
            <xsl:text></xsl:text><xsl:value-of select="."/><xsl:text> century Śaka</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text></xsl:text><xsl:value-of select="."/><xsl:text> Śaka</xsl:text>
         </xsl:otherwise>
      </xsl:choose><xsl:text></xsl:text>
   </xsl:template>
   
   <xsl:template match="t:date[@calendar='Julian' and preceding-sibling::t:date[@calendar='Śaka']]" mode="metadata-campa">
      <xsl:text>(</xsl:text><xsl:value-of select="."/><xsl:text> CE).</xsl:text>      
   </xsl:template>
   
   <xsl:template match="t:date[@calendar='Julian' and not(preceding-sibling::t:date[@calendar='Śaka'])]" mode="metadata-campa">
      <xsl:text></xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text><xsl:if test="ends-with(., 'th')">century<xsl:text> </xsl:text></xsl:if><xsl:text>CE.</xsl:text>      
   </xsl:template>
   
   
   <xsl:template match="t:origPlace" mode="metadata-campa">
      <xsl:text></xsl:text><xsl:apply-templates mode="metadata-campa"/><xsl:text></xsl:text>
   </xsl:template>
    
   
   <xsl:template match="t:placeName[ancestor::t:origPlace]" mode="metadata-campa">
      <xsl:variable name="cic-geog-path">../../geography/geography.xml</xsl:variable>
      <xsl:comment>value <xsl:value-of select="."/></xsl:comment>
      <xsl:variable name="placename" select="normalize-space(.)"/>
      <xsl:variable name="placenametype" select="@type"/>
      <xsl:message>Placename!</xsl:message>
      <xsl:message>variable placename is "<xsl:value-of select="$placename"/>"</xsl:message>
      <xsl:message>variable placenametype is "<xsl:value-of select="$placenametype"/>"</xsl:message>
      <xsl:if test="@ref">
         <xsl:message>got a ref = <xsl:value-of select="@ref"/></xsl:message>
         <xsl:choose>
            <xsl:when test="starts-with(./@ref, 'cic-geo:')">
               <xsl:variable name="sought" select="substring-after(@ref, 'cic-geo:')"/>
               <xsl:message>variable sought is "<xsl:value-of select="$sought"/>"</xsl:message>
               <xsl:choose>
                  <xsl:when test="count(document($cic-geog-path, .)/descendant-or-self::t:listPlace/descendant::t:place[@xml:id=$sought]) &gt; 0">
                      <xsl:for-each select="document($cic-geog-path, .)/descendant-or-self::t:listPlace/descendant::t:place[@xml:id=$sought]">
                        <xsl:value-of select="upper-case(substring(@type, 1, 1))"/><xsl:value-of select="substring(@type, 2)"/> of 
                           <xsl:call-template name="gen-search">
                              <xsl:with-param name="class">geography</xsl:with-param>
                              <xsl:with-param name="value" select="$sought"/>
                              <xsl:with-param name="text">
                                  <xsl:choose>
                                      <xsl:when test="$placename!=''"><xsl:value-of select="$placename"/></xsl:when>
                                      <xsl:otherwise><xsl:value-of select="t:placeName[1]"/></xsl:otherwise>
                                  </xsl:choose>
                              </xsl:with-param>
                           </xsl:call-template>
                           <xsl:if test="ancestor::t:place">
                           <xsl:text> (</xsl:text><xsl:call-template name="list-ancestor-places">
                              <xsl:with-param name="child" select=".."/>
                           </xsl:call-template><xsl:text>)</xsl:text>
                        </xsl:if>
                     </xsl:for-each><xsl:text>.</xsl:text>                  
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:message>match fail</xsl:message>
                     <span class="xformerror">No matching place found in <xsl:value-of select="$cic-geog-path"/> for placeName with @ref='<xsl:value-of select="@ref"/>'</span>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise><span class="xformerror">unrecognized ref prefix on placename: '<xsl:value-of select="@ref"/>'</span></xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
      
   <xsl:template name="list-ancestor-places">
      <xsl:param name="child"/>
      <xsl:param name="delim">, </xsl:param>
      <xsl:value-of select="$child/t:placeName[1]"/><xsl:if test="$child/ancestor::t:place"><xsl:value-of select="$delim"/><xsl:call-template name="list-ancestor-places">
         <xsl:with-param name="child" select="$child/.."/>
      </xsl:call-template></xsl:if>
   </xsl:template>
   
   <xsl:template match="t:provenance" mode="metadata-campa">
      <xsl:for-each select="t:ab | t:p"><xsl:message>handling <xsl:value-of select="local-name()"/></xsl:message><xsl:text> </xsl:text><xsl:apply-templates/><xsl:text></xsl:text></xsl:for-each>
   </xsl:template>
   
   <xsl:template match="t:bibl | t:p | t:ptr | t:note | t:hi | t:seg | t:quote | t:foreign | t:ref" mode="metadata-campa">
      <xsl:apply-templates select="."/>
   </xsl:template>
   
   <xsl:template match="t:locus" mode="metadata-campa"/>
   
   <xsl:template name="do-locus">
      <xsl:variable name="sought"><xsl:value-of select="substring-after(@target, '#')"/></xsl:variable>
      <xsl:choose>
         <xsl:when test="count(//t:*[@xml:id=$sought]) &gt; 0">
            <xsl:text> (see: </xsl:text>
            <xsl:for-each select="//t:*[@xml:id=$sought]">
               <a>
                  <xsl:attribute name="href">#<xsl:value-of select="$sought"/></xsl:attribute>
                  <xsl:choose>
                  <xsl:when test="t:head">
                     <xsl:text></xsl:text><xsl:value-of select="t:head"/><xsl:text></xsl:text>
                  </xsl:when>
                     <xsl:when test="@n">
                        <xsl:text></xsl:text><xsl:value-of select="@n"/><xsl:text></xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:attribute name="class">xformerror</xsl:attribute>
                        <xsl:text></xsl:text>could not find head element or n attribute on target <xsl:value-of select="$sought"/><xsl:text></xsl:text>
                     </xsl:otherwise>
               </xsl:choose></a>
            </xsl:for-each><xsl:text>)</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <span class="xformerror">could not find an element in this file with xml:id=<xsl:value-of select="substring-after(@target, '#')"/>, which was
            found in a locus element</span>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="t:*" mode="metadata-campa">
      <xsl:text></xsl:text><span class="xformerror">there is no template for the element "<xsl:value-of select="local-name(.)"/>" with mode="metadata-campa"</span><xsl:text></xsl:text>
   </xsl:template>
   
   
</xsl:stylesheet>
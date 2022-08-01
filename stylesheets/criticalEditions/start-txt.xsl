<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    <xsl:output method="text"  indent="no"/>
    <xsl:strip-space elements="tei:*"/>
    
    <xsl:function name="functx:trim" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        
        <xsl:sequence select="
            replace(replace($arg,'\s+$',''),'^\s+','')
            "/>
        
    </xsl:function>
    
   <!-- <xsl:variable name="vAllowed" select=
        "concat('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'aābcdefghḥiījklmnṅñṇopqrr̥ṣstuvwxyz',
        '0123456789.,-')"/>
    <xsl:variable name="vSpaces" select="'                                        '"/>-->

    
<!--    <xsl:template match="*[not(text()[3])]/text()">
        <xsl:value-of select=
            "normalize-space(translate(., translate(.,$vAllowed,''), $vSpaces))"/>
    </xsl:template>
-->    
    <xsl:template match="text()">        
        <xsl:if test="matches(., '^\s+') and not(matches(., '^\s+$'))">
               <xsl:text> </xsl:text>
            </xsl:if>
        <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="matches(.,'\s$')">
               <xsl:text> </xsl:text>
            </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        <xsl:text>&#xA;</xsl:text>
        <xsl:if test="@type">
            <xsl:value-of select="@type"/>
            <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
   
    <!--<xsl:template match="tei:app[not(@rend='hide')]">
        <xsl:apply-templates select="child::tei:lem"/>
        <xsl:text> (</xsl:text>
        <xsl:for-each select="tei:lem">
            <xsl:choose>
            <xsl:when test="@type">
                <xsl:choose>
                    <xsl:when test="@type='emn'">
                    <xsl:text>em.</xsl:text>
                </xsl:when>
                    <xsl:when test="@type='norm'">
                    <xsl:text>norm.</xsl:text>
                </xsl:when>
                    <xsl:when test="@type='conj'">
                    <xsl:text>conj.</xsl:text>
                </xsl:when>   
        </xsl:choose>
            </xsl:when>
            <xsl:when test="@wit">
                <xsl:value-of select="replace(@wit, '#', 'ms')"/>
            </xsl:when>
        </xsl:choose>
        </xsl:for-each>
        <xsl:if test="tei:lem/following-sibling::tei:rdg">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:for-each select="tei:rdg">
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
            <xsl:if test="@wit">
                <xsl:value-of select="replace(@wit, '#', 'ms')"/>
            </xsl:if>
            <xsl:if test="following-sibling::tei:rdg">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="tei:lem/following-sibling::tei:note">
            <xsl:text> • </xsl:text>
        </xsl:if>
        <xsl:for-each select="tei:note">
            <xsl:apply-templates/>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:template>-->
    
    <xsl:template match="tei:bibl">
        <xsl:choose>
            <xsl:when test=".[tei:ptr]">
                <xsl:variable name="biblentry" select="replace(substring-after(./tei:ptr/@target, 'bib:'), '\+', '%2B')"/>
                <xsl:variable name="zoteroStyle">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/bibliography/DHARMA_modified-Chicago-Author-Date_v01.csl</xsl:variable>
                <xsl:variable name="zoteroomitname">
                    <xsl:value-of
                        select="unparsed-text(replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=json'), 'amp;', ''))"
                    />
                </xsl:variable>
                <xsl:variable name="zoteroapitei">
                    <xsl:value-of
                        select="replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=tei'), 'amp;', '')"/>
                </xsl:variable>
                <xsl:variable name="zoteroapijson">
                    <xsl:value-of
                        select="replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=json&amp;style=',$zoteroStyle,'&amp;include=citation'), 'amp;', '')"/>
                </xsl:variable>
                <xsl:variable name="unparsedtext" select="unparsed-text($zoteroapijson)"/>
                <xsl:variable name="pointerurl">
                    <xsl:value-of select="document($zoteroapitei)//tei:idno[@type = 'url']"/>
                </xsl:variable>
                <xsl:variable name="bibwitness">
                    <xsl:value-of select="replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=', $zoteroStyle), 'amp;', '')"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="parent::tei:witness">
                        <xsl:apply-templates
                            select="document($bibwitness)/div"/>
                    </xsl:when>
                    <xsl:when test="parent::tei:listBibl"/>
                    <xsl:when test="parent::tei:p or parent::tei:note">			
                        <a href="{$pointerurl}">
                            <xsl:variable name="citation">
                                <xsl:analyze-string select="$unparsedtext"
                                    regex="(\s+&quot;citation&quot;:\s&quot;&lt;span&gt;)(.+)(&lt;/span&gt;&quot;)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(2)"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="@rend='omitname'">
                                    <xsl:analyze-string select="$zoteroomitname"
                                        regex="(\s+&quot;date&quot;:\s&quot;)(.+)(&quot;)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(2)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:when test="@rend='ibid'">
                                    <xsl:element name="i">
                                        <xsl:text>ibid.</xsl:text>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="matches(./child::tei:ptr/@target, '[A-Z][A-Z]')">
                                    <xsl:call-template name="journalTitle"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="replace(replace(replace(replace($citation, '^[\(]+([&lt;][a-z][&gt;])*', ''), '([&lt;/][a-z][&gt;])+[\)]+$', ''), '\)', ''), '&lt;/[i]&gt;', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                        <xsl:if test="tei:citedRange">
                            <xsl:choose>
                                <xsl:when test="tei:citedRange and not(ancestor::tei:cit)">
                                    <xsl:text>: </xsl:text>
                                </xsl:when>
                                <xsl:when test="tei:citedRange and ancestor::tei:cit">
                                    <xsl:text>, </xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:for-each select="tei:citedRange">
                                <xsl:call-template name="citedRange-unit"/>
                                <xsl:apply-templates select="replace(normalize-space(.), '-', '–')"/>
                                <xsl:if test="following-sibling::tei:citedRange[1]">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                        <!-- Display for t:cit  -->
                        <xsl:if test="following::tei:quote[1] and ancestor::tei:cit">
                            <xsl:text>: </xsl:text>
                        </xsl:if>
                        <!--	if it is in the bibliography print styled reference-->	
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of
                            select="document(replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$zoteroStyle), 'amp;', ''))/div"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="ancestor::tei:listBibl and ancestor-or-self::tei:bibl/@n"> <!-- [@type='primary'] -->
                    <xsl:element name="span">
                        <xsl:attribute name="class">siglum</xsl:attribute>
                        <xsl:if test="ancestor-or-self::tei:bibl/@n">
                            <xsl:text> [siglum </xsl:text>
                            <strong><xsl:value-of select="ancestor-or-self::tei:bibl/@n"/></strong>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <!-- if there is no ptr, print simply what is inside bibl and a warning message-->
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>		
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <xsl:text>⟦</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>⟧</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <xsl:if test="@type='dyad' or @type='chapter'">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
        <xsl:if test="@type and not(@type='metrical')">
            <xsl:value-of select="@type"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>: </xsl:text>
            <xsl:if test="not(@type='dyad')">
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="following::tei:head[1]">
            <xsl:apply-templates select="tei:head"/>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="@type='dyad'">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason='omitted'">
                <xsl:text>om.</xsl:text>
            </xsl:when>
            <xsl:when test="@reason='lost' and not(@quantity|@unity)"/>
            <xsl:otherwise>
                <xsl:text>[</xsl:text>
                    <xsl:choose> 
                        <xsl:when test="@quantity and @unit">
                            <xsl:if test="@precision='low'">
                                <xsl:text>ca. </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="@quantity"/>
                            <xsl:if test="@unit='character'">
                                <xsl:choose>
                                    <xsl:when test="@reason='lost'">
                                        <xsl:text>+</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@reason='illegible'">
                                        <xsl:text>×</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@reason='undefined'">
                                        <xsl:text>*</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if> 
                        </xsl:when>
                        <xsl:when test="@extent">
                            <xsl:text>...</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>...</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>         
                <xsl:text>]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="tei:head"/>
    
    <xsl:template match="tei:hi">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:lacunaStart"/>
    <xsl:template match="tei:lacunaEnd"/>
    
<xsl:template match="tei:lem">
    <xsl:apply-templates/>
</xsl:template>    
    
    <xsl:template match="tei:listApp[@type='parallels' or @type='apparatus']"/>
        <!--<xsl:text>&#xA;</xsl:text>
        <xsl:text>parallels: </xsl:text>
        <xsl:for-each select="tei:app/tei:note">
               <xsl:choose>
                   <xsl:when test="@*">
                       <xsl:apply-templates select="replace(@* except @xml:lang, 'txt:', '')"/>
                   </xsl:when>
               <xsl:otherwise>
                   <xsl:apply-templates/>
               </xsl:otherwise>
               </xsl:choose>
           </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>-->
   
   <xsl:template match="tei:l">
      <xsl:apply-templates/>
      <xsl:if test="not(following-sibling::tei:l)">
          <xsl:text>[</xsl:text>
                  <xsl:choose>
                      <xsl:when test="ancestor::tei:div[@type='chapter']">
                              <xsl:value-of select="ancestor::tei:div[@type='chapter'][1]/@n"/>
                       <xsl:text>.</xsl:text>
                          <xsl:if test="ancestor::tei:div[@type='dyad']">
                              <xsl:value-of select="ancestor::tei:div[@type='dyad'][1]/@n"/>
                              <xsl:text>.</xsl:text>
                          </xsl:if>
                       </xsl:when>      
                      <xsl:otherwise>
                          
                              <xsl:value-of select="ancestor::tei:div[1]/@n"/>
                              <xsl:text>.</xsl:text>
                          
                      </xsl:otherwise>
                  </xsl:choose>
               
               <xsl:choose>
                   <xsl:when test="parent::tei:lg/@n">
                       <xsl:value-of select="parent::tei:lg/@n"/>
                   </xsl:when>
                   <xsl:otherwise>
                       <xsl:number count="//tei:div[@type='chapter'][descendant::tei:lg[1]]/descendant-or-self::tei:lg" level="multiple" format="1"/>
                   </xsl:otherwise>
               </xsl:choose>
       <xsl:text>]</xsl:text></xsl:if>
       <xsl:text>&#xA;</xsl:text>
   </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:apply-templates/>    
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:note"/>
    
    <xsl:template match="tei:p">
        <xsl:text>[</xsl:text>
        <xsl:if test="parent::tei:div[1]">
            <xsl:value-of select="parent::tei:div[1]/@n"/>
            <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:number level="single" format="1"/>
        <xsl:text>]</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
   <!-- <xsl:template match="tei:pb">
        <xsl:text>[ms</xsl:text>
        <xsl:value-of select="substring-after(@edRef, '#')"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]</xsl:text>
    </xsl:template>-->
    
    <xsl:template match="tei:ptr[@target]">
        <xsl:choose>
            <xsl:when test="fn:starts-with(@target, '#')">
            <xsl:text>ms</xsl:text>
                <xsl:value-of select="replace(@target, '#', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:rdg"/>
    
    <xsl:template match="tei:sic">
        <xsl:text>†</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>†</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:quote[@type='base-text']">
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>base text: </xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates select="./tei:supplied/tei:lg"/>
    </xsl:template>
    
    <xsl:template match="tei:supplied[not(@reason='implied')]">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:surplus">
        <xsl:text>{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:text>The </xsl:text>
        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
        <xsl:text>. </xsl:text>
        <xsl:if test="tei:fileDesc/tei:titleStmt/tei:title[@type='alt']">
             <xsl:text> or ‘</xsl:text>
             <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='alt']"/>
             <xsl:text>’</xsl:text>
         </xsl:if>
          <xsl:if test="tei:fileDesc/tei:titleStmt/tei:author">
          <xsl:text> by </xsl:text>
          <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:author"/>                   
          </xsl:if>  
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                </xsl:if>
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:editor">
                        <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:editor">
                            <xsl:choose>
                                <xsl:when test="position()= 1">
                                    <xsl:text> edited by </xsl:text>
                                </xsl:when>
                                <xsl:when test="position()=last()">
                                    <xsl:text> &amp; </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>, </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="child::tei:forename">
                                    <xsl:apply-templates select="tei:forename"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="tei:surname"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="normalize-space(.)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
        
            <xsl:text>Witnesses:&#xA;</xsl:text>
        <xsl:for-each select="tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness">
            <xsl:text>ms</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>: </xsl:text>
            <xsl:choose>
                <xsl:when test="tei:msDesc/tei:msIdentifier/tei:settlement">
                <xsl:if test="tei:msDesc/tei:msIdentifier/tei:institution">
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:institution"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:settlement">
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:settlement"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:repository">
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:repository"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:idno">                           
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:idno"/>
            </xsl:if>
            </xsl:when>
                <xsl:when test="child::tei:bibl">
                    <xsl:apply-templates select="tei:bibl"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
                <xsl:text>&#xA;Current Version: </xsl:text>
                <xsl:choose>
                    <xsl:when test="tei:fileDesc/following-sibling::tei:revisionDesc/tei:change[1]/@status">
                        <xsl:value-of select="tei:fileDesc/following-sibling::tei:revisionDesc/tei:change[1]/@status"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>draft</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="current-date()"/>
                <br/>
                <xsl:text>&#xA;Still in progress – do not quote without permission.</xsl:text>
                <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/tei:p[2]"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:unclear">
        <xsl:text>⟨</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>⟩</xsl:text>
    </xsl:template>
    
    <xsl:template name="citedRange-unit">
        <xsl:variable name="CurPosition" select="position()"/>
        <xsl:variable name="unit-value">
            <xsl:choose>
                <xsl:when test="@unit='page' and following-sibling::tei:citedRange[1]">
                    <xsl:choose>
                        <xsl:when test="matches(., '[–\-]+')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(., ',')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>page </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@unit='part'">
                    <xsl:text>part </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='volume'">
                    <xsl:text>volume </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='note'">
                    <xsl:text>note </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='item'">
                    <xsl:text>&#8470; </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='entry'">
                    <xsl:text>s.v. </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='figure'">
                    <xsl:text>figure </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='plate'">
                    <xsl:text>plate </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='table'">
                    <xsl:text>table </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='appendix'">
                    <xsl:text>appendix </xsl:text>
                </xsl:when>
                <xsl:when test="@unit='line'">
                    <xsl:choose>
                        <xsl:when test="matches(., '[–\-]+')">
                            <xsl:text>lines </xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(., ',')">
                            <xsl:text>lines </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>line </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@unit='section'">
                    <xsl:choose>
                        <xsl:when test="matches(., '[–\-]+')">
                            <xsl:text>§§</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>§</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="matches(., '[\-]+')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(., ',')">
                            <xsl:text>pages </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>page </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise> -->
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$CurPosition = 1 and not(ancestor::tei:p or ancestor::tei:note)">
                <xsl:value-of select="concat(upper-case(substring($unit-value,1,1)), substring($unit-value, 2),' '[not(last())] )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$unit-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="journalTitle">
        <xsl:choose>
            <!-- Handles ARIE1886-1887 or ARIE1890-1891_02 -->
            <xsl:when test="matches(./child::tei:ptr/@target, '[a-z]+:([A][R][I][E])([0-9\-]+)(_[0-9])*')">
                <xsl:analyze-string select="./child::tei:ptr/@target" regex="[a-z]+:([A][R][I][E])([0-9\-]+)(_[0-9])*">
                    <xsl:matching-substring>
                        <i><xsl:value-of select="regex-group(1)"/></i>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches(./child::tei:ptr/@target, '[a-z]+:([A-Z]+)([0-9][0-9]+[0-9\-]*)_([0-9]+[\-]*)')">
                <xsl:analyze-string select="./child::tei:ptr/@target" regex="[a-z]+:([A-Z]+)([0-9][0-9]+[0-9\-]*)_([0-9]+[\-]*)">
                    <xsl:matching-substring>
                        <i><xsl:value-of select="regex-group(1)"/></i>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="regex-group(2)"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="regex-group(3)"/>
                        <xsl:text>)</xsl:text>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <!-- Handles OV, ROC, ROD -->
            <xsl:when test="matches(./child::tei:ptr/@target, '[a-z]+:([A-Z]+)([0-9\-]+)(_[0-9])*')">
                <xsl:analyze-string select="./child::tei:ptr/@target" regex="[a-z]+:([A-Z]+)([0-9\-]+)(_[0-9])*">
                    <xsl:matching-substring>
                        <i><xsl:value-of select="regex-group(1)"/></i>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="regex-group(2)"/>
                        <xsl:text>)</xsl:text>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
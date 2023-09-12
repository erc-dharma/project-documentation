<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">

<!-- addition to run the xslt locally, to be commenting before pushing files otherwise the pipeline won't run for diplEd -->
    <!--<xsl:param name="edition-type" as="xs:string" select="'physical'"/>
    <xsl:param name="corpus-type" as="xs:string" select="'nusantara'"/>-->

    <xsl:param name="edition-type" as="xs:string"/>
    <xsl:param name="corpus-type" as="xs:string"/>
    
    <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0"/>

    <xsl:function name="functx:escape-for-regex" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="replace($arg,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>
    </xsl:function>
    <xsl:function name="functx:substring-after-last" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>
        <xsl:sequence select="replace($arg,concat('^.*',functx:escape-for-regex($delim)),'')"/>
    </xsl:function>
    <xsl:function name="functx:substring-before-last-match" as="xs:string?"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence select="replace($arg,concat('^(.*)',$regex,'.*'),'$1')"/>
    </xsl:function>
    <xsl:function name="functx:sort" as="item()*"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="seq" as="item()*"/>
        <xsl:for-each select="$seq">
            <xsl:sort select="."/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="functx:capitalize-first" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="
            concat(upper-case(substring($arg,1,1)),
            substring($arg,2))"/>
    </xsl:function>
    <xsl:function name="functx:trim" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="
            replace(replace($arg,'\s+$',''),'^\s+','')
            "/>
    </xsl:function>

    <!-- Coded initially written by Andrew Ollet, for DHARMA Berlin workshop in septembre 2020 -->
    <!-- Updated and reworked for DHARMA by Axelle Janiak, starting 2021 -->
       <!-- Updated and reworked For DHARMA diplomatic edition by Axelle Janiak, starting summer 2021 -->

    <xsl:variable name="script">
        <xsl:for-each select="//tei:profileDesc/tei:langUsage/tei:language">
           <xsl:value-of select="substring-after(@ident, '-')"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="edition-id">
        <xsl:value-of select="tei:TEI/@xml:id"/>
    </xsl:variable>

    <xsl:template match="/tei:TEI">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                <xsl:attribute name="data-spy">scroll</xsl:attribute>
                <xsl:attribute name="data-target">#myScrollspy</xsl:attribute>
                <xsl:attribute name="data-offset">5</xsl:attribute>
                <xsl:call-template name="nav-bar"/>
                <xsl:element name="div">
                    <xsl:attribute name="class">content</xsl:attribute>
                    <xsl:call-template name="table-contents"/>
                    <a class="btn btn-info" data-toggle="collapse" href="#sidebar-wrapper" role="button" aria-expanded="false" aria-controls="sidebar-wrapper" id="toggle-table-contents">☰ Document Outline</a>
                    <xsl:apply-templates select="./tei:teiHeader"/>
                <xsl:element name="div">
                    <xsl:attribute name="class">row wrapper</xsl:attribute>
                    <xsl:element name="ul">
                        <xsl:attribute name="class">nav nav-tabs nav-justified</xsl:attribute>
                        <xsl:attribute name="id">tab</xsl:attribute>
                        <xsl:attribute name="role">tablist</xsl:attribute>
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item</xsl:attribute>
                            <xsl:attribute name="role">presentation</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link active</xsl:attribute>
                                <xsl:attribute name="id">witnesses-tab</xsl:attribute>
                                <xsl:attribute name="data-toggle">tab</xsl:attribute>
                                <xsl:attribute name="href">#witnesses</xsl:attribute>
                                <xsl:attribute name="role">tab</xsl:attribute>
                                <xsl:attribute name="aria-controls">witnesses</xsl:attribute>
                                <xsl:attribute name="aria-selected">true</xsl:attribute>
                                <xsl:element name="div">
                                    <xsl:attribute name="class">panel</xsl:attribute>
                                    <xsl:text>Witness</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item</xsl:attribute>
                            <xsl:attribute name="role">presentation</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link</xsl:attribute>
                                <xsl:attribute name="id">metadata-tab</xsl:attribute>
                                <xsl:attribute name="data-toggle">tab</xsl:attribute>
                                <xsl:attribute name="href">#metadata</xsl:attribute>
                                <xsl:attribute name="role">tab</xsl:attribute>
                                <xsl:attribute name="aria-controls">metadata</xsl:attribute>
                                <xsl:attribute name="aria-selected">false</xsl:attribute>
                                <xsl:element name="div">
                                    <xsl:attribute name="class">panel</xsl:attribute>
                                    <xsl:text>Metadata</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="class">tab-content</xsl:attribute>
                        <xsl:call-template name="tab-witness"/>
                        <xsl:call-template name="tab-metadata"/>
                    </xsl:element>
                </xsl:element>
                <xsl:apply-templates select="./tei:text">
                    <xsl:with-param name="edition-type"/>
                </xsl:apply-templates>
            <xsl:apply-templates select=".//tei:app | .//tei:choice[child::tei:sic and child::tei:corr]" mode="modals"/>
                <xsl:apply-templates select=".//tei:note" mode="modals"/>
                <xsl:call-template name="tpl-apparatus"/>
                <xsl:call-template name="tpl-translation"/>
                <xsl:call-template name="tpl-com"/>
                <xsl:call-template name="tpl-biblio"/>
                </xsl:element>
                <xsl:element name="footer">
                    <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                    <xsl:element name="div">
                        <xsl:value-of select="replace(//tei:fileDesc/tei:publicationStmt//tei:licence/tei:p[2], '\(c\)', '©')"/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="dharma-script"/>
        </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  teiHeader ! -->
    <!--  teiHeader ! -->
    <xsl:template match="tei:teiHeader">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col text-center my-5</xsl:attribute>
                <xsl:element name="h1">
                    <xsl:attribute name="class">display-5</xsl:attribute>
                    <xsl:text>The </xsl:text>
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-italic</xsl:attribute>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                    </xsl:element>
                    <xsl:if test="tei:fileDesc/tei:titleStmt/tei:title[@type='alt']">
                        <xsl:text> or ‘</xsl:text>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='alt']"/>
                        <xsl:text>’</xsl:text>
                    </xsl:if>
                    <xsl:if test="tei:fileDesc/tei:titleStmt/tei:author">
                        <xsl:text> by </xsl:text>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:author"/>
                    </xsl:if>
                </xsl:element>
                
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                    <xsl:element name="h2">
                        <xsl:attribute name="class">display-5</xsl:attribute>
                        <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="tei:fileDesc/tei:titleStmt/tei:editor">
                    <xsl:element name="h3">
                        <xsl:attribute name="class">display-6</xsl:attribute>
                        <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:editor">
                            <xsl:choose>
                                <xsl:when test="position()= 1">
                                    <xsl:text>edited by </xsl:text>
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
                    </xsl:element>
                </xsl:if>
                <xsl:text>Current Version: </xsl:text>
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
                <xsl:text>Still in progress – do not quote without permission.</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  text ! -->
    <xsl:template match="tei:text">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col mx-5</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
            <!--<xsl:element name="div">
                <xsl:attribute name="id">modals</xsl:attribute>
                <xsl:call-template name="build-modals"/>
            </xsl:element>-->
        </xsl:element>
    </xsl:template>
    <!--  A ! -->
    <!--  add ! -->
    <xsl:template match="tei:add">
                    <xsl:element name="a">
            <xsl:attribute name="class">ed-insertion</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                    <xsl:text>Editorial insertion</xsl:text>
            <xsl:choose>
                <xsl:when test="@place='above'">
                    <xsl:text> suprascr.</xsl:text>
                </xsl:when>
                <xsl:when test="@place='below'">
                    <xsl:text> subscr.</xsl:text>
                </xsl:when>
                <xsl:when test="@place='right' or @place='left'">
                    <xsl:text> in mg.</xsl:text>
                </xsl:when>
            </xsl:choose>
                </xsl:element>
            </xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">scribe-insertion</xsl:attribute>
                            <xsl:text>⟨⟨</xsl:text>
                            <xsl:apply-templates/>
                            <xsl:text>⟩⟩</xsl:text>
                        </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--  app ! -->
    <xsl:template match="tei:app" mode="modals">
        <xsl:param name="line-break"/>
        <xsl:variable name="apparatus">
            <xsl:element name="span">
                <xsl:element name="span">
                    <xsl:attribute name="class">mb-1 lemma-line</xsl:attribute>
                    <xsl:element name="span">
                        <xsl:attribute name="class">app-lem</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>translit </xsl:text>
                                <xsl:value-of select="$script"/>
                                    <xsl:if test="not(child::tei:lem/following-sibling::tei:note[@type='altLem'])">

                                        <xsl:text> </xsl:text>
                                        <xsl:call-template name="lem-type"/>
                            </xsl:if>

                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="tei:lem/following-sibling::tei:note[@type='altLem']">
                                    <xsl:apply-templates select="replace(tei:lem/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="tei:lem">
                                        <xsl:with-param name="line-break">
                                            <xsl:value-of select="'no-break'"/>
                                        </xsl:with-param>
                                    </xsl:apply-templates>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                    <xsl:if test="tei:lem/@*">
                        <!--<xsl:text>] </xsl:text>-->
                            <xsl:if test="tei:lem/@type">
                                <xsl:text> </xsl:text>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:call-template name="apparatus-type"/>
                                </xsl:element>
                                <!--<xsl:if test="tei:lem/attribute::source">
                                    <xsl:text> </xsl:text>
                                </xsl:if>-->
                            </xsl:if>
                            <xsl:if test="tei:lem/@wit">
                                <xsl:if test="tei:lem/@ana='#absent_elsewhere'">
                                    <xsl:text> only in </xsl:text>
                                </xsl:if>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-weight-bold supsub</xsl:attribute>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="tei:lem/@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                </xsl:call-template>
                                </xsl:element>
                                <!--<xsl:if test="tei:lem/attribute::source">
                                    <xsl:text> </xsl:text>
                                </xsl:if>-->
                            </xsl:if>
                           <xsl:if test="tei:lem/@source">
                                <xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="tei:lem/@source"/>
                                </xsl:call-template>
                            </xsl:if>
                    </xsl:if>
                </xsl:element>
                <!--  Variant readings ! -->
                <xsl:if test="tei:rdg">
                    <xsl:choose>
                        <xsl:when test="tei:rdg/preceding-sibling::*[local-name()='lem'][1]/@ana='#absent_elsewhere'"/>
                        <xsl:otherwise>
                            <xsl:element name="hr"/>
                    <xsl:for-each select="tei:rdg">
                        <xsl:element name="span">
                            <xsl:attribute name="class">reading-line</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">app-rdg</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">
                                        <xsl:text>translit </xsl:text>
                                        <xsl:value-of select="$script"/>
                                    </xsl:attribute>
                                         <xsl:choose>
                                                <xsl:when test="tei:gap[@reason='omitted']">
                                                    <xsl:element name="span">
                                                        <xsl:attribute name="class">font-italic</xsl:attribute>
                                                        <xsl:attribute name="style">color:black;</xsl:attribute>
                                                        <xsl:text>om.</xsl:text>
                                                    </xsl:element>
                                                </xsl:when>
                                             <xsl:when test="child::tei:gap[@reason='lost'and not(@quantity or @unit)]">
                                                 <xsl:element name="span">
                                                     <xsl:attribute name="class">font-italic</xsl:attribute>
                                                     <xsl:attribute name="style">color:black;</xsl:attribute>
                                                     <xsl:text>lac.</xsl:text>
                                                 </xsl:element>
                                             </xsl:when>
                                             <xsl:when test="child::tei:lacunaEnd">
                                                 <xsl:text>...]</xsl:text>
                                             </xsl:when>
                                            </xsl:choose>

                                    <xsl:apply-templates/>
                                    <xsl:choose>
                                        <xsl:when test="child::tei:lacunaStart">
                                        <xsl:text>[...</xsl:text>
                                    </xsl:when>

                                    </xsl:choose>

                                </xsl:element>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-weight-bold supsub</xsl:attribute>
                                <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="./@wit"/>
                                    <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                    <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                            </xsl:call-template>
                                <xsl:if test="tei:gap[@ana='#eyeskip']">
                                    <xsl:element name="span">
                                        <xsl:attribute name="style">color:black;</xsl:attribute>
                                        <xsl:text> (eye-skip)</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="child::tei:gap[@ana='#line_omission']">
                                    <xsl:element name="span">
                                        <xsl:text> (line omission)</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                                <!--<xsl:if test="attribute::source">
                                    <xsl:text> </xsl:text>
                                </xsl:if>-->
                                <xsl:if test="./@source">
                                    <xsl:call-template name="source-siglum">
                                        <xsl:with-param name="string-to-siglum" select="./@source"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:element>
                            <!--<xsl:if test="./following-sibling::tei:rdg">
                                <xsl:text>; </xsl:text>
                            </xsl:if>-->
                        </xsl:element>
                    </xsl:for-each></xsl:otherwise></xsl:choose>
                </xsl:if>
                <!--  Notes ! -->
                <xsl:if test="tei:note[fn:not(@type='altLem') or ancestor::tei:listApp]">
                    <xsl:element name="hr"/>
                    <xsl:for-each select="tei:note[fn:not(@type='altLem')]">
                        <xsl:element name="span">
                            <xsl:attribute name="class">note-line</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
            </xsl:element>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus"/>
        </span>
    </xsl:template>

    <xsl:template match="tei:app[not(parent::tei:listApp)]">
        <xsl:param name="location"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
            <xsl:element name="a">
                <xsl:attribute name="data-toggle">popover</xsl:attribute>
                <xsl:attribute name="data-html">true</xsl:attribute>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                    <xsl:value-of select="$app-num"/></xsl:attribute>
                <xsl:attribute name="title">Apparatus <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:choice[child::tei:sic and child::tei:corr]"/></xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>from-app-</xsl:text>
                    <xsl:value-of select="$app-num"/>
                </xsl:attribute>
                <xsl:attribute name="data-app">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>

                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>lem </xsl:text>
                    </xsl:attribute>
                <xsl:apply-templates select="tei:lem"/>
                        <xsl:element name="sup">
                            <xsl:attribute name="class">float-right</xsl:attribute>
                            <xsl:text>(</xsl:text>
                        <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg]"/>
                        <xsl:text>)</xsl:text>
                        </xsl:element>

            </xsl:element>
            </xsl:element>
    </xsl:template>
    <!--  B ! -->
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
                    <xsl:when test="ancestor-or-self::tei:witness">
                        <xsl:value-of
                            select="document($bibwitness)/div"/>
                    </xsl:when>
                    <xsl:when test="not(ancestor::tei:listBibl) or ancestor::tei:p or ancestor::tei:note">
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
    <!--  C ! -->
    <!--  choice ! -->
  <xsl:template match="tei:choice[child::tei:orig and child::tei:reg]">
        <xsl:choose>
            <xsl:when test="$edition-type='physical'">
                <xsl:element name="span">
            <xsl:attribute name="class">orig</xsl:attribute>
                    <xsl:apply-templates select="child::tei:orig"/>
        </xsl:element>
            </xsl:when>
            <xsl:when test="$edition-type='logical'">
           <xsl:element name="span">
            <xsl:attribute name="class">reg</xsl:attribute>
               <xsl:apply-templates select="child::tei:reg"/>
        </xsl:element>
       </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:choice[child::tei:sic and child::tei:corr]">
        <xsl:param name="location"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
        <xsl:element name="a">
            <xsl:attribute name="data-toggle">popover</xsl:attribute>
            <xsl:attribute name="data-html">true</xsl:attribute>
            <xsl:attribute name="data-target">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                <xsl:value-of select="$app-num"/></xsl:attribute>
            <xsl:attribute name="title">Apparatus <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:choice[child::tei:sic and child::tei:corr]"/></xsl:attribute>
            <xsl:attribute name="id">
                <xsl:text>from-app-</xsl:text>
                <xsl:value-of select="$app-num"/>
            </xsl:attribute>
            <xsl:attribute name="data-app">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            
            <xsl:element name="span">
                <xsl:attribute name="class">lem sic</xsl:attribute>
                <xsl:apply-templates select="tei:sic"/>
                <xsl:element name="sup">
                    <xsl:attribute name="class">float-right</xsl:attribute>
                    <xsl:text>(</xsl:text>
                    <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | //tei:note[last()][parent::tei:p or parent::tei:lg] | //tei:choice[child::tei:sic and child::tei:corr]"/>
                    <xsl:text>)</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:choice[child::tei:sic and child::tei:corr]" mode="modals">
        <xsl:variable name="apparatus">
            <xsl:element name="span">
                <xsl:element name="span">
                    <xsl:attribute name="class">mb-1 lemma-line</xsl:attribute>
                    <xsl:element name="span">
                        <xsl:attribute name="class">app-corr</xsl:attribute>
                        <xsl:apply-templates select="child::tei:corr"/>
                        <xsl:text> (corr)</xsl:text>
            </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus"/>
        </span>
    </xsl:template>
    <!-- choice with two unclears -->
    <xsl:template match="tei:choice[child::tei:unclear]">
        <xsl:element name="span">
            <xsl:attribute name="class">unclear</xsl:attribute>
            <xsl:apply-templates select="child::tei:unclear[1]"/>
            <xsl:text>/</xsl:text>
            <xsl:apply-templates select="child::tei:unclear[2]"/>
        </xsl:element>
    </xsl:template>
    <!-- citedRange -->
    <xsl:template match="tei:citedRange">
        <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:call-template name="citedRange-unit"/>
            <xsl:apply-templates select="replace(normalize-space(.), '-', '–')"/>
        </xsl:element>
        <xsl:if test="following-sibling::tei:citedRange">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <!--  D ! -->
    <!--  del ! -->
    <xsl:template match="tei:del">
            <xsl:element name="span">
                <xsl:attribute name="class">scribe-deletion</xsl:attribute>
                <xsl:text>⟦</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>⟧</xsl:text>
            </xsl:element>
    </xsl:template>
    <!-- dimensions -->
    <xsl:template match="tei:dimensions">
        <xsl:if test="preceding::text()">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="child::tei:height"/>
        <xsl:value-of select="@unit"/>
        <xsl:text> x </xsl:text>
        <xsl:value-of select="child::tei:width"/>
        <xsl:value-of select="@unit"/>
    </xsl:template>
    <!--  div ! -->
    <xsl:template match="tei:div">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-1 text-center</xsl:attribute>
                <xsl:element name="p">
                    <xsl:value-of select="@n"/>
                    <xsl:text>. </xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-10</xsl:attribute>
                <xsl:if test="not(child::tei:head)">
                    <xsl:element name="p">
                        <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@type='generalOmen'">
                                <xsl:text>General Omen</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="functx:capitalize-first(@type)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="./following-sibling::tei:div">
            <xsl:element name="hr"/>
        </xsl:if>
    </xsl:template>
    <!--  F ! -->
    <!--  foreign ! -->
    <xsl:template match="tei:foreign">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>translit </xsl:text>
                <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
            <xsl:attribute name="class">font-italic</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!--  fw ! -->
    <xsl:template match="tei:fw">
        <xsl:choose>
            <xsl:when test="@n">
                <xsl:variable name="refnum" select="@n"/>
                <xsl:for-each select=".">
                    <xsl:text> #</xsl:text>
                    <xsl:value-of select="(count(preceding-sibling::tei:*[@n =$refnum][local-name() ='fw']) + 1)"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates/>
                </xsl:for-each>
            </xsl:when>
           <!-- <xsl:when test="@place='left'">
                <xsl:element name="span">
                    <xsl:attribute name="class">text-muted</xsl:attribute>
                <xsl:if test="not(preceding-sibling::tei:*[1][local-name()=('pb')])">
                    <xsl:text>[</xsl:text>
                </xsl:if>
                <xsl:text>fw </xsl:text>
                <xsl:apply-templates/>
                <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@place='right'">
                <xsl:element name="span">
                    <xsl:attribute name="class">text-muted form-work float-right</xsl:attribute>
                        <xsl:text>[fw </xsl:text>
                        <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </xsl:element> 
            </xsl:when>-->
            <xsl:when test="child::tei:choice">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--  G ! -->
    <xsl:template match="tei:g">
        <xsl:element name="span">
            <xsl:attribute name="class">symbol</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@ref">
                    <xsl:value-of select="substring-after(@ref, '#')"/>
                </xsl:when>
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason='omitted'"/>
            <xsl:when test="@reason='lost' and not(@quantity or @unity)"/>
            <xsl:otherwise>
                <xsl:element name="span">
            <xsl:attribute name="class">gap</xsl:attribute>
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
        </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!--  H ! -->
    <!--  head ! -->
    <xsl:template match="tei:head">
        <xsl:element name="p">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  hi ! -->
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='superscript'">
                <xsl:element name="sup">
                    <xsl:attribute name="class">ed-siglum</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='subscript'">
                <xsl:element name="sub">
                    <xsl:attribute name="class">ed-siglum</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='italic'">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--  L ! -->
    <!--  l ! -->
    <xsl:template match="tei:l">
          <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>l translit </xsl:text>
                <xsl:value-of select="$script"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  lb ! -->
    <xsl:template match="tei:lb">
        <xsl:param name="line-break"/>
        <xsl:choose>
            <xsl:when test="$edition-type='logical' and @break='no'"/>
            <xsl:when test="$line-break='no-break'"/>
            <xsl:otherwise>
                <xsl:call-template name="lbrk-app"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:for-each-group select="*" group-starting-with="tei:lb">
            
                <xsl:for-each select="current-group()">
                    <xsl:copy>
                        <xsl:element name="div">
                            <xsl:attribute name="class">col-10 structural-grid</xsl:attribute>-->
                        <xsl:element name="span">
                            <xsl:attribute name="class">text-muted lineation</xsl:attribute>
                            <xsl:value-of select="@n"/>
                        </xsl:element>
                        <xsl:apply-templates/>
                        <!--</xsl:element>
                        <xsl:element name="div">
                            <xsl:attribute name="class">col-2 structural-grid</xsl:attribute>
                            <!-\- déclencher les appels de notes à partir d'ici -\->
                        </xsl:element>
                    </xsl:copy>
                </xsl:for-each>
        </xsl:for-each-group>-->
    </xsl:template>
    <!--  lg ! -->
    <xsl:template match="tei:lg">
        <xsl:element name="div">
            <xsl:attribute name="class">row mt-2</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">testconteneur col</xsl:attribute>
                <xsl:if test="@met">
                    <xsl:element name="div">
                        <xsl:attribute name="class">float-center</xsl:attribute>
                        <xsl:element name="small">
                            <xsl:element name="span">
                                <xsl:attribute name="class">text-muted</xsl:attribute>
                                <xsl:value-of select="replace(replace(replace(@met, '-', '⏑&#160;'), '=', '⏓&#160;'), '+', '–&#160;')"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <!--<xsl:if test="ancestor::tei:item">
                    <xsl:element name="div">
                        <xsl:attribute name="class">float-center</xsl:attribute>
                        <xsl:element name="small">
                            <xsl:element name="span">
                                <xsl:attribute name="class">text-muted</xsl:attribute>
                                <xsl:value-of select="substring-after(ancestor::tei:item/@corresp, 'txt:')"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>-->
                <xsl:element name="div">
                    <xsl:attribute name="class">
                        <xsl:text>lg</xsl:text>
                    <xsl:if test="@met='anuṣṭubh'"><xsl:text> anustubh</xsl:text></xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:lg" mode="in-modal">
        <xsl:element name="div">
            <xsl:attribute name="class">lg</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  List -->
    <xsl:template match="tei:list">
        <xsl:element name="ul">
            <xsl:attribute name="class">list-unstyle</xsl:attribute>
            <xsl:for-each select="child::tei:item">
                <xsl:element name="li">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each>

        </xsl:element>
    </xsl:template>
    <!--  listApp ! -->
    <xsl:template match="tei:listApp[@type = 'parallels']">
        <xsl:element name="div">
            <xsl:attribute name="class">parallels</xsl:attribute>
            <xsl:if test="descendant::tei:note">
                <xsl:element name="div">
                    <xsl:attribute name="class">card</xsl:attribute>
                    <xsl:element name="div">
                        <xsl:attribute name="class">card-header</xsl:attribute>
                        <xsl:element name="h5">
                            <xsl:attribute name="class">mb-0</xsl:attribute>
                            <xsl:element name="button">
                                <xsl:attribute name="class">btn btn-link</xsl:attribute>
                                <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                <xsl:attribute name="data-target"><xsl:value-of select="concat( '#', generate-id())"/></xsl:attribute>
                                <xsl:attribute name="aria-expanded">false</xsl:attribute>
                                <xsl:attribute name="arial-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                                <xsl:text>Parallels</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>

                    <xsl:element name="div">
                        <xsl:attribute name="id"><xsl:value-of select="generate-id()"/></xsl:attribute>
                        <xsl:attribute name="class">collapse</xsl:attribute>
                        <xsl:attribute name="aria-labelledby">heading</xsl:attribute>
                        <xsl:attribute name="data-parent">#accordion</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="class">card-body</xsl:attribute>
                            <xsl:call-template name="parallels-content"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:element>

    </xsl:template>
    <!--  listBibl -->
    <!-- Must be reworked -->
    <xsl:template match="tei:listBibl">
       <xsl:apply-templates/>
    </xsl:template>
    <!--  listWit ! -->
    <xsl:template match="tei:listWit">
        <xsl:element name="div">
            <xsl:attribute name="class">tab-pane active</xsl:attribute>
            <xsl:attribute name="id">witnesses</xsl:attribute>
        <xsl:attribute name="role">tabpanel</xsl:attribute>
        <xsl:attribute name="aria-labelledby">witnesses-tab</xsl:attribute>
            <xsl:element name="h4">List of Witnesses</xsl:element>
            <xsl:element name="ul">
                <xsl:for-each select="tei:witness">
                    <xsl:element name="li">
                        <xsl:element name="a">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="b">
                            <xsl:choose>
                                <xsl:when test="child::tei:abbr[1]">
                                    <xsl:apply-templates select="child::tei:abbr[1]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:text>: </xsl:text>
                        <xsl:choose>
                            <xsl:when test="child::tei:abbr[1]">
                                <xsl:apply-templates select="child::tei:*[position() > 1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  N ! -->
    <xsl:template match="tei:note">
        <xsl:choose>
                <xsl:when test="tei:note[@type='prosody']"/>
                <xsl:when test="tei:note[ancestor::tei:colophon]"/>
                <xsl:when test="self::tei:note[//tei:TEI[@type='translation']]"/>
                <xsl:when test="self::tei:note[parent::tei:p or parent::tei:lg or parent::tei:l][position() = last()] or self::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]"/>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
   <xsl:template match="tei:note" mode="modals">
        <xsl:variable name="apparatus-note">
            <xsl:if test="self::tei:note[position() = last()][not(@type='parallels' or parent::tei:app or @type='altLem')][parent::tei:p or parent::tei:lg or parent::tei:l] or self::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]">
                <xsl:element name="span">
                    <xsl:element name="span">
                        <xsl:attribute name="class">mb-1 lemma-line</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">fake-lem</xsl:attribute>
                                       <xsl:call-template name="fake-lem-making"/>
                        </xsl:element>
                        <xsl:element name="hr"/>
                        <xsl:for-each select="self::tei:note">
                            <xsl:element name="span">
                                <xsl:attribute name="class">note-line</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:variable>
       <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-note"/>
        </span>
    </xsl:template>
   
    <!--  P ! -->
    <!--  p ! -->
    <xsl:template match="tei:p">
        <xsl:variable name="p-num">
            <xsl:number level="single" format="1"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="ancestor::tei:projectDesc">
                <xsl:element name="p">
                    <xsl:attribute name="class">text-justify</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="not(ancestor-or-self::tei:note |ancestor-or-self::tei:handDesc)">
        <xsl:element name="div">
            <xsl:attribute name="class">text-container</xsl:attribute>
            <xsl:element name="span">
                <xsl:attribute name="class">text-muted</xsl:attribute>
                <xsl:if test="ancestor::tei:div[@type = 'chapter'] and not(ancestor::tei:div[@type = 'dyad' or @type ='interpolation'])">
                    <xsl:value-of select="ancestor::tei:div[@type = 'chapter']/@n"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="parent::tei:div[@type = 'dyad']">
                    <xsl:value-of select="parent::tei:div[@type = 'dyad']/@n"/>
                <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="parent::tei:div[@type = 'interpolation']">
                    <xsl:value-of select="parent::tei:div[@type = 'interpolation']/@n"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>

                    <xsl:value-of select="$p-num"/>

            </xsl:element>
            </xsl:element>
        <!--<br/>-->
        <xsl:element name="p">
            <xsl:attribute name="class">textContent</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p">
                    <xsl:attribute name="class">p-note</xsl:attribute>
                <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  pb ! -->
    <xsl:template match="tei:pb">
        <xsl:choose>
            <xsl:when test="tei:pb[not(preceding::node()/text())]"/>
            <xsl:when test="$corpus-type='batak' or $edition-type='logical'"/>
            <xsl:otherwise>
                <xsl:call-template name="lbrk-app"/>
            </xsl:otherwise>
        </xsl:choose>
                <xsl:element name="span">
                    <xsl:attribute name="class">text-muted</xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:text>[Folio </xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>]</xsl:text>
                    <!--<xsl:choose>
                        <xsl:when test="following-sibling::tei:*[1][local-name()=('fw')][not(@place='right')]">
                            <xsl:text>: </xsl:text>
                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>]</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>-->
                </xsl:element>     
    </xsl:template>

    <!-- ptr -->
    <xsl:template match="tei:ptr[not(parent::tei:bibl)]">
            <xsl:element name="span">
                <xsl:attribute name="class">ref-siglum</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="fn:contains(@target, 'txt:')">
                        <xsl:variable name="IdListTexts"> https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_idListTexts_v01.xml
                        </xsl:variable>
                        <xsl:variable name="MSlink" select="substring-after(./@target, 'txt:')"/>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink]/child::tei:ptr[1]/@target"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink]/child::tei:abbr[@type='siglum']"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="fn:contains(@target, '_')">
                        <xsl:variable name="hand-id" select="substring-after(./@target, '#')"/>
                        <xsl:apply-templates select="//tei:listWit/tei:witness/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote[@xml:id = $hand-id]/tei:abbr"/>
                    </xsl:when>
                    <xsl:when test="fn:contains(@target, 'bib:')">
                        <xsl:call-template name="source-siglum">
                            <xsl:with-param name="string-to-siglum" select="@target"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(./@target, '#')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
    </xsl:template>
    <!--  Q ! -->
    <!--  q ! -->
    <xsl:template match="tei:q">
        <xsl:choose>
            <xsl:when test="@rend='block'">
                <xsl:element name="span">
                    <xsl:attribute name="class">block</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>‘</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>’</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:q[@type = 'lemma']">
        <xsl:element name="b">
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:text>translit </xsl:text>
                    <xsl:value-of select="$script"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  quote ! -->
    <xsl:template match="tei:quote">
        <xsl:choose>
            <xsl:when test="tei:quote[@type = 'basetext']">
                <xsl:element name="div">
            <xsl:attribute name="class">basetext</xsl:attribute>
            <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="tei:quote[descendant::tei:list]">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:app">
                <xsl:text>“</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>” </xsl:text>
            </xsl:when>
            <xsl:when test="@rend='block'">
                <xsl:element name="span">
                    <xsl:attribute name="class">block</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  R ! -->
    <xsl:template match="tei:text//tei:ref">
        <xsl:element name="span">
            <xsl:attribute name="class">ref san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:teiHeader//tei:ref">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  S ! -->
    <!--  s ! -->
    <xsl:template match="tei:s">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>s translit </xsl:text>
                <xsl:value-of select="$script"/>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:s" mode="in-modal">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <!--  sic ! -->
    <xsl:template match="tei:sic[not(parent::tei:choice)]">
        <xsl:element name="span">
            <xsl:attribute name="class">sic-crux</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  sp ! -->
    <xsl:template match="tei:sp">
        <xsl:element name="div">
            <xsl:attribute name="class">row sp</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-sm-3</xsl:attribute>
                <xsl:apply-templates mode="bypass" select="tei:speaker"/>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-sm-9</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  speaker ! -->
    <xsl:template match="tei:speaker"/>
    <xsl:template match="tei:speaker" mode="bypass">
        <xsl:element name="span">
            <xsl:attribute name="class">speaker san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  stage ! -->
    <!--  case one: it is not contained within a character’s
       lines ! -->
    <xsl:template match="tei:stage[not(ancestor::tei:sp)]">
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-sm-12 clearfix</xsl:attribute>
                <xsl:call-template name="button-group">
                    <xsl:with-param name="id" select="@xml:id"/>
                </xsl:call-template>
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>stage san text-center</xsl:text>
                        <xsl:if test="@type = 'division'"> stage-division</xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  case two: it is contained within a characters’ lines ! -->
    <xsl:template match="tei:sp//tei:stage">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>stage san stage-sp</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:stage" mode="in-modal">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <!-- space ! -->
    <xsl:template match="tei:space">
        <xsl:choose>
            <xsl:when test="@type='binding-hole'">
                <xsl:text>◯</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>_SPACE_</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--  subst ! -->
    <!--<xsl:template match="tei:subst">
            <xsl:element name="span">
                <!-\-<xsl:attribute name="class">ed-insertion</xsl:attribute>-\->
                <xsl:apply-templates/>
            </xsl:element>
    </xsl:template>-->
    <!--  supplied ! -->
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted supplied</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">Supplied by the editor.</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@reason='omitted'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">omitted</xsl:attribute>
                    <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@reason='lost' or @reason='illegible'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">lost-illegible</xsl:attribute>
                        <xsl:apply-templates/>
                        <xsl:if test="@cert='low'">
                            <xsl:text>?</xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@reason='subaudible'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">subaudible</xsl:attribute>
                        <xsl:apply-templates/>
                        <xsl:if test="@cert='low'">
                            <xsl:text>?</xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@reason='explanation'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">explanation</xsl:attribute>
                        <xsl:apply-templates/>
                        <xsl:if test="@cert='low'">
                            <xsl:text>?</xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
               <!-- <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>-->
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!--  surplus ! -->
    <xsl:template match="tei:surplus">
        <xsl:element name="span">
            <xsl:attribute name="class">surplus</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  T ! -->
    <!--  TEI ! -->
    <xsl:template match="tei:TEI">
        <xsl:element name="div">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  term ! -->
    <xsl:template match="tei:term">
        <xsl:element name="span">
            <xsl:attribute name="class">term font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  title ! -->
    <xsl:template match="tei:title">
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="@rend='plain'">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="@level='a'">
                    <xsl:text>‘</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>’</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">title san</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!--  U ! -->
    <!--  unclear -->
    <xsl:template match="tei:unclear">
        <xsl:element name="span">
            <xsl:attribute name="class">unclear</xsl:attribute>
            <xsl:apply-templates/>
            <xsl:if test="@cert='low'">
                <xsl:text>?</xsl:text>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!--  W ! -->
    <xsl:template match="tei:w">
        <xsl:element name="span">
            <xsl:attribute name="class">word</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  BUTTON-GROUP ! -->
    <!--  button group to the right of each verse or paragraph ! -->
    <xsl:template name="button-group">
        <xsl:param name="id"/>
        <!--  the ID of the verse or paragraph ! -->
        <xsl:param name="met"/>
        <!--  the meter, if identified ! -->
        <xsl:element name="div">
            <xsl:attribute name="class">float-right</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">btn-group</xsl:attribute>
                <!--  if the button refers to a meter ! -->
                <xsl:if test="$met != ''">
                    <xsl:variable name="target">
                        <xsl:value-of
                            select="//tei:TEI//tei:metDecl/tei:p[@xml:id = $met]/tei:ptr/@target"/>
                    </xsl:variable>
                    <xsl:element name="a">
                        <xsl:attribute name="href">javascript:void(0)</xsl:attribute>
                        <xsl:attribute name="role">button</xsl:attribute>
                        <xsl:attribute name="class">btn btn-secondary btn-sm met-btn</xsl:attribute>
                        <xsl:attribute name="data-toggle">popover</xsl:attribute>
                        <xsl:attribute name="data-title">Meter</xsl:attribute>
                        <xsl:attribute name="data-trigger">hover</xsl:attribute>
                        <xsl:attribute name="data-placement">right</xsl:attribute>
                        <xsl:attribute name="data-content">
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$target"/>
                                </xsl:attribute>
                                <xsl:value-of select="$met"/>
                            </xsl:element>
                            <!--<xsl:text><a href="</xsl:text>
                            <xsl:value-of select="$target"/>
                            <xsl:text>"></xsl:text>
                            <xsl:value-of select="$met"/>
                            <xsl:text></a></xsl:text>-->
                        </xsl:attribute>
                        <xsl:text>M</xsl:text>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="//tei:text[@xml:id = 'RaMa']//*[@corresp = $id]">
                    <xsl:variable name="target">
                        <xsl:text>#modal-</xsl:text>
                        <xsl:value-of select="translate(translate($id, 'ā', 'a'), '.', '-')"/>
                        <xsl:text>-rasamanjari</xsl:text>
                    </xsl:variable>
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$target"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-toggle">modal</xsl:attribute>
                        <xsl:attribute name="class">btn btn-default btn-sm
                            modal-toggle</xsl:attribute>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="$target"/>
                        </xsl:attribute>
                        <xsl:text>R</xsl:text>
                    </xsl:element>
                </xsl:if>
                <!--  if ... ! -->
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  BUILD-MODALS ! -->
    <xsl:template name="build-modals">
        <!--  i assume for these purposes that every modal
	 will have its own separate division in the document.
	 the rasamañjarī will be divided into divisions
	 that each have a @corresp attribute. ! -->
        <xsl:for-each select="//tei:text[@xml:id = 'RaMa']//tei:div[@corresp]">
            <xsl:variable name="corresp">
                <xsl:value-of select="@corresp"/>
            </xsl:variable>
            <xsl:variable name="reference">
                <xsl:value-of select="translate(translate(@corresp, 'ā', 'a'), '.', '-')"/>
            </xsl:variable>
            <xsl:variable name="number-citation">
                <xsl:value-of select="substring-after(@corresp, '.')"/>
            </xsl:variable>
            <xsl:variable name="this-modal-name">
                <xsl:text>modal-</xsl:text>
                <xsl:value-of select="$reference"/>
                <xsl:text>-rasamanjari</xsl:text>
            </xsl:variable>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$this-modal-name"/>
                </xsl:attribute>
                <xsl:attribute name="class">modal fade text-left</xsl:attribute>
                <xsl:attribute name="tabindex">-1</xsl:attribute>
                <xsl:attribute name="role">dialog</xsl:attribute>
                <xsl:attribute name="aria-labelledby">
                    <xsl:text>modal-</xsl:text>
                    <xsl:value-of select="$reference"/>
                    <xsl:text>-label</xsl:text>
                </xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">modal-dialog modal-lg</xsl:attribute>
                    <xsl:attribute name="role">document</xsl:attribute>
                    <!--  MODAL CONTENT ! -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">modal-content</xsl:attribute>
                        <!--  MODAL HEADER ! -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">modal-header</xsl:attribute>
                            <button type="button" class="close modal-close" aria-label="Close">
                                <span aria-hidden="true">
                                    <xsl:text>×</xsl:text>
                                </span>
                            </button>
                            <h3 id="modal-{$reference}-label">
                                <em>Rasamañjarī</em>
                                <xsl:text> on </xsl:text>
                                <em>Mālatīmādhava</em>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$number-citation"/>
                            </h3>
                        </xsl:element>
                        <!--  MODAL BODY ! -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">modal-body</xsl:attribute>
                            <!--  the verse or paragraph or stage direction
		   to which this modal is attached. ! -->
                            <xsl:element name="div">
                                <xsl:attribute name="class"> modal-quote san <xsl:value-of
                                    select="local-name()"/> </xsl:attribute>
                                <xsl:apply-templates
                                    select="//tei:text[@xml:id = 'MāMā']//tei:*[@xml:id = $corresp]"
                                    mode="in-modal"/>
                            </xsl:element>
                            <!--  THE CONTENT OF EACH TAB ! -->
                            <xsl:apply-templates select="." mode="bypass"/>
                        </xsl:element>
                        <!--  MODAL FOOTER ! -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">modal-footer</xsl:attribute>
                            <button type="button" class="btn btn-primary modal-close">Close</button>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!--  REFERENCE ! -->
    <xsl:template name="reference">
        <xsl:param name="n1"/>
        <xsl:param name="n2"/>
        <xsl:param name="n3"/>
        <xsl:param name="style"/>
        <xsl:variable name="separator">
            <xsl:choose>
                <xsl:when test="$style = 'dashes'">
                    <xsl:text>-</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="workTitle">
            <xsl:choose>
                <xsl:when test="$style = 'dashes'">
                    <xsl:call-template name="work-abbrev">
                        <xsl:with-param name="encoding" select="'ASCII'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="work-abbrev">
                        <xsl:with-param name="encoding" select="'UTF8'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--  construct the reference starting backwards ! -->
        <xsl:value-of select="$workTitle"/>
        <xsl:if test="$n1 != ''">
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="translate($n1, '.', $separator)"/>
        </xsl:if>
        <xsl:if test="$n2 != ''">
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="translate($n2, '.', $separator)"/>
        </xsl:if>
        <xsl:if test="$n3 != ''">
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="translate($n3, '.', $separator)"/>
        </xsl:if>
    </xsl:template>
    <!--  WORK-ABBREV ! -->
    <xsl:template name="work-abbrev">
        <xsl:param name="encoding"/>
        <xsl:choose>
            <xsl:when test="$encoding = 'ASCII'">
                <xsl:text>MaMa</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>MāMā</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--  NAMED TEMPLATES ! -->

    <xsl:template name="tokenize-witness-list">
        <xsl:param name="string"/>
        <xsl:param name="witdetail-string"/>
        <xsl:param name="witdetail-type"/>
        <xsl:choose>
            <xsl:when test="contains($string, ' ')">
                <xsl:variable name="first-item"
                    select="translate(normalize-space(substring-before($string, ' ')), '#', '')"/>
                <xsl:if test="$first-item">
                    <xsl:call-template name="make-bibl-link">
                        <xsl:with-param name="target" select="$first-item"/>
                        <xsl:with-param name="witdetail-string" select="translate($witdetail-string, '#', '')"/>
                        <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                    </xsl:call-template>
                    <xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="substring-after($string, ' ')"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$string = ''">
                       <xsl:text/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="make-bibl-link">
                            <xsl:with-param name="target" select="translate($string, '#', '')"/>
                            <xsl:with-param name="witdetail-string" select="translate($witdetail-string, '#', '')"/>
                            <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--  Make bibliography link ! -->
    <xsl:template name="make-bibl-link">
        <xsl:param name="target"/>
        <xsl:param name="witdetail-string"/>
        <xsl:param name="witdetail-type"/>
        <xsl:element name="a">
            <xsl:attribute name="class">siglum</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$target"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="//tei:listWit/tei:witness[@xml:id=$target]/tei:abbr">
                    <xsl:apply-templates select="//tei:listWit/tei:witness[@xml:id=$target]/tei:abbr"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$target"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:if test="$target = $witdetail-string">
            <xsl:element name="sub">
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space($witdetail-type)"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- Identity template -->
    <xsl:template match="@* | text() | comment()" mode="copy">
        <xsl:copy/>
    </xsl:template>

    <!-- Check feature -->
    <xsl:template match="tei:*[@rend='check']">
        <xsl:element name="span">
            <xsl:attribute name="class">mark</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- DHARMA html prolog -->
    <xsl:template name="dharma-head">
        <xsl:variable name="title">
            <xsl:if test="//tei:titleStmt/tei:title/text()">
                <xsl:if test="//tei:idno[@type='filename']/text()">
                    <xsl:value-of select="//tei:idno[@type='filename']"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:value-of select="//tei:titleStmt/tei:title"/>
            </xsl:if>
        </xsl:variable>
        <head>
            <title>
                <xsl:value-of select="$title"/>
            </title>

            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"></link>
                <!-- site-specific css !-->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/diplomaticEditions/dharma-diplEd-css.css"></link>
                <!--<link rel="stylesheet" href="./../diplomaticEditions/dharma-diplEd-css.css"></link>-->
                <!-- scrollbar CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Serif"></link>
            </meta>
        </head>
    </xsl:template>

    <!-- DHARMA html JS scripts  -->
    <xsl:template name="dharma-script">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
        <!-- jQuery Custom Scroller CDN -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/diplomaticEditions/loader-diplEd.js"/>
        <!--<script src="./../diplomaticEditions/loader-diplEd.js"/>-->

    </xsl:template>

    <!-- Templates for Apparatus at the botton of the page -->
  <xsl:template name="tpl-apparatus">
    <!-- An apparatus is only created if one of the following is true -->
    <xsl:if
        test=".//tei:app[not(parent::tei:listApp)] | .//tei:note |.//tei:choice[child::tei:sic and child::tei:corr]"> <!--  | .//tei:subst |  -->

        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">Apparatus</xsl:element>

      <div id="apparatus">
        <xsl:for-each
            select=".//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:choice[child::tei:sic and child::tei:corr]">

          <!-- Found in tpl-apparatus.xsl -->
          <xsl:call-template name="dharma-app">
            <xsl:with-param name="apptype">
              <xsl:choose>
                <xsl:when test="self::tei:app">
                  <xsl:text>app</xsl:text>
                </xsl:when>
                <xsl:when test="self::tei:choice[child::tei:sic and child::tei:corr]">
                  <xsl:text>siccorr</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </div>
        </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="lbrk-app">
    <br/>
  </xsl:template>

    <xsl:template name="app-link">
        <!-- location defines the direction of linking -->
        <xsl:param name="location"/>
            <!-- Only produces a link if it is not nested in an element that would be in apparatus -->
            <xsl:if
                test="not((local-name() = 'subst')
                and (ancestor::tei:choice or ancestor::tei:subst or ancestor::tei:app))">
                <xsl:variable name="app-num">
                    <xsl:value-of select="name()"/>
                    <xsl:number level="any" format="0001"/>
                </xsl:variable>
                <xsl:call-template name="generate-app-link">
                    <xsl:with-param name="location" select="$location"/>
                    <xsl:with-param name="app-num" select="$app-num"/>
                </xsl:call-template>
            </xsl:if>
    </xsl:template>

    <xsl:template name="generate-app-link">
        <xsl:param name="location"/>
        <xsl:param name="app-num"/>
            <xsl:if test="$location = 'apparatus'">
                <a>
                    <xsl:attribute name="id">
                        <xsl:text>to-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:text>#from-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:text>^</xsl:text>
                   <!-- <xsl:value-of select="$app-num"/>-->
                    <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | //tei:note[last()][parent::tei:p or parent::tei:lg] | //tei:choice[child::tei:sic and child::tei:corr]"/>
                </a>
            </xsl:if>
    </xsl:template>

    <xsl:template name="dharma-app">
        <xsl:param name="apptype"/>
       <xsl:variable name="childtype">
            <xsl:choose>
                <!--<xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice[child::tei:orig and child::tei:reg]">
                    <xsl:text>origreg</xsl:text>
                </xsl:when>-->
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice[child::tei:sic and child::tei:corr]">
                    <xsl:text>siccorr</xsl:text>
                </xsl:when>
               <!-- <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:subst">
                    <xsl:text>subst</xsl:text>
                </xsl:when>-->
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:app">
                    <xsl:text>app</xsl:text>
                </xsl:when>
              <!--<xsl:when test="child::tei:*[local-name()=('note')]/tei:app"/>-->
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="div-loc">
            <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
                <xsl:value-of select="@n"/>
                <xsl:text>.</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(ancestor::tei:subst)">
                <!-- either <br/> in htm-tpl-apparatus or \r\n in txt-tpl-apparatus -->
                <xsl:call-template name="lbrk-app"/>
                <!-- in htm-tpl-apparatus.xsl or txt-tpl-apparatus.xsl -->
                <xsl:call-template name="app-link">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:call-template>
                <xsl:value-of select="$div-loc"/>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>:&#x202F;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
          <xsl:choose>
                  <xsl:when test="local-name() = 'note'">
                      <xsl:call-template name="fake-lem-making"/>
                      <xsl:element name="span">
                          <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                          <xsl:text>] </xsl:text>
                      </xsl:element>
                      <xsl:apply-templates/>
                  </xsl:when>

              <xsl:otherwise>
                  <xsl:element name="span">
              <xsl:attribute name="class">app</xsl:attribute>
              <xsl:call-template name="appcontent">
                <xsl:with-param name="apptype" select="$apptype"/>
                <!--<xsl:with-param name="childtype" select="$childtype" />-->
            </xsl:call-template>
          </xsl:element>
              </xsl:otherwise>
          </xsl:choose>
    </xsl:template>

    <!-- prints the content of apparatus-->
    <xsl:template name="appcontent">
        <xsl:param name="apptype"/>
     <xsl:param name="childtype"/>
        <xsl:variable name="path">
           <xsl:choose>
                <xsl:when test="$childtype='origreg' or $childtype='siccorr'">
                    <xsl:copy-of select="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice/child::*"/>
                </xsl:when>
                <xsl:when test="$childtype='subst'">
                    <xsl:copy-of select="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:subst/child::*"/>
                </xsl:when>
               <xsl:when test="$childtype='app'">
                    <xsl:copy-of select="child::*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:app/child::*"/>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:copy-of select="node()"/>
               </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
       <xsl:variable name="parent-lang">
            <xsl:if test="(child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice/child::tei:reg[@xml:lang] and $childtype = 'origreg') or (child::tei:reg[@xml:lang] and $apptype = 'origreg')">
                <xsl:if test="$childtype = 'origreg'">
                    <xsl:value-of select="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice/child::tei:reg/ancestor::tei:*[@xml:lang][1]/@xml:lang" />
                </xsl:if>
                <xsl:if test="$apptype = 'origreg'">
                    <xsl:value-of select="child::tei:reg/ancestor::tei:*[@xml:lang][1]/@xml:lang" />
                </xsl:if>
            </xsl:if>
        </xsl:variable>
       <xsl:choose>
           <xsl:when test="$childtype != '' and $apptype != $childtype">
                <xsl:call-template name="appchoice">
                    <xsl:with-param name="apptype">
                        <xsl:value-of select="$childtype"/>
                    </xsl:with-param>
                    <xsl:with-param name="path">
                        <xsl:copy-of select="$path"/>
                    </xsl:with-param>
                   <xsl:with-param name="parent-lang">
                       <xsl:value-of select="$parent-lang" />
                   </xsl:with-param>
                </xsl:call-template>
               <xsl:text> </xsl:text>
            </xsl:when>
             <xsl:otherwise>
                <xsl:call-template name="appchoice">
                    <xsl:with-param name="apptype"><xsl:value-of select="$apptype"/></xsl:with-param>
                    <xsl:with-param name="child"><xsl:if test="$childtype != ''">true</xsl:if></xsl:with-param>
                    <xsl:with-param name="path"><xsl:copy-of select="$path"/></xsl:with-param>
                   <xsl:with-param name="parent-lang"><xsl:value-of select="$parent-lang"/></xsl:with-param>
                </xsl:call-template>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="appchoice">
        <xsl:param name="apptype" />
       <xsl:param name="child" />
        <xsl:param name="path" />
       <xsl:param name="parent-lang"/>
        <xsl:param name="line-break"/>
        <xsl:choose>
            <xsl:when test="$apptype='app'">
                <!-- **ALT - <xsl:value-of select="$path/tei:rdg"/>** -->
                <xsl:for-each select="$path/tei:lem">
                    <xsl:element name="span">
                        <xsl:attribute name="class">lem</xsl:attribute>
                                <xsl:apply-templates select="$path/tei:lem">
                                    <xsl:with-param name="line-break">
                                        <xsl:value-of select="'no-break'"/>
                                    </xsl:with-param>
                                </xsl:apply-templates>
                    </xsl:element>
                    <xsl:if test="following-sibling::tei:rdg">
                        <xsl:element name="span">
                        <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:text>] </xsl:text>
                    </xsl:element>  </xsl:if>
                    <xsl:if test="$path/tei:lem[following-sibling::tei:rdg and not(@ana='#absent_elsewhere')]">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="tei:rdg">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*[local-name()='lem'][1]/@ana='#absent_elsewhere'"/>
                        <xsl:otherwise>
                            <xsl:if test="position()!=1">
                        <xsl:text>, </xsl:text>
                    </xsl:if>

                    <xsl:choose>
                        <xsl:when test="child::tei:pb | child::tei:lb"/>
                        <xsl:when test="child::tei:gap[@reason='omitted']">
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:text>om.</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="child::tei:gap[@reason='lost' and not(@quantity or @unit)]">
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:text>lac.</xsl:text>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>

                    <xsl:apply-templates/>

                    <xsl:text> </xsl:text>
                    <xsl:if test="@*">
                        <xsl:if test="child::tei:gap[@ana='#eyeskip']">
                            <xsl:element name="span">
                                <xsl:text> (eye-skip)</xsl:text>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="child::tei:gap[@ana='#line_omission']">
                            <xsl:element name="span">
                                <xsl:text> (line omission)</xsl:text>
                            </xsl:element>
                        </xsl:if>
                            <xsl:if test="@source">
                                <xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="@source"/>
                                </xsl:call-template>
                            </xsl:if>
                    </xsl:if>
                    </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="tei:lem/following-sibling::tei:note and not(following-sibling::tei:rdg)">
                        <xsl:text> • </xsl:text>
                        <xsl:apply-templates select="tei:lem/following-sibling::tei:note"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="not(tei:rdg) and tei:lem/following-sibling::tei:note">
                    <xsl:text> • </xsl:text>
                    <xsl:apply-templates select="tei:lem/following-sibling::tei:note"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$apptype='note'">
                <xsl:for-each select="$path/tei:note">
                <xsl:apply-templates/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$apptype='siccorr'">
                <!-- **CORR - <xsl:value-of select="$path/t:corr/node()"/>** -->
                <xsl:apply-templates select="$path/tei:corr/node()"/>
                <xsl:text> (corr)</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Apparatus: type to display -->
    <xsl:template name="apparatus-type">
        <xsl:choose>
            <xsl:when test="./@type='emn' or tei:lem/@type='emn'">
                <xsl:text>em.</xsl:text>
            </xsl:when>
            <xsl:when test="./@type='norm' or tei:lem/@type='norm'">
                <xsl:text>norm.</xsl:text>
            </xsl:when>
            <xsl:when test="./@type='conj' or tei:lem/@type='conj'">
                <xsl:text>conj.</xsl:text>
           </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Siglum : fetch the siglum to display -->
    <xsl:template name="source-siglum">
        <xsl:param name="string-to-siglum"/>
            <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                <xsl:text>Ed</xsl:text>
                <xsl:element name="sup">
                    <xsl:attribute name="class">ed-siglum</xsl:attribute>
                <xsl:value-of select="//tei:listBibl/tei:biblStruct[@corresp=$string-to-siglum]/@xml:id"/>
            </xsl:element>
            </xsl:element>
    </xsl:template>

    <!-- Parallels: generate the content  -->
    <xsl:template name="parallels-content">
       <!--<xsl:element name="dl">
           <xsl:for-each select="descendant-or-self::tei:item">
            <xsl:element name="dt">
                <xsl:value-of select="replace(descendant-or-self::tei:item/@corresp, 'txt:', '')"/>
            </xsl:element>
               <xsl:element name="dd">
                   <xsl:apply-templates/>
               </xsl:element>
        </xsl:for-each>
       </xsl:element>-->

        <xsl:variable name="IdListTexts"> https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_idListTexts_v01.xml
        </xsl:variable>

        <xsl:element name="ul">
            <xsl:attribute name="class">list-unstyled</xsl:attribute>
            <xsl:for-each select="descendant-or-self::tei:note">
                <xsl:element name="li">
                    <xsl:choose>
                        <xsl:when test="@*">
                            <xsl:variable name="soughtMS" select="substring-before(substring-after(@*, 'txt:'), '_')"/>
                            <xsl:variable name="refMS" select="substring-after(@*, '_')"/>
                            <xsl:element name="blockquote">
                        <xsl:attribute name="class">blockquote text-center</xsl:attribute>
                        <xsl:element name="p">
                            <xsl:attribute name="class">mb-0</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                        <xsl:element name="footer">
                            <xsl:attribute name="class">blockquote-footer</xsl:attribute>
                            <xsl:element name="cite">
                                <xsl:choose>
                                    <xsl:when test="document($IdListTexts)//tei:bibl[@xml:id=$soughtMS]">
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="document($IdListTexts)//tei:bibl[@xml:id=$soughtMS]/child::tei:ptr[1]/@target"/>
                                            </xsl:attribute>
                                        <xsl:apply-templates select="document($IdListTexts)//tei:bibl[@xml:id=$soughtMS]/child::tei:abbr[@type='siglum']"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$refMS"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="replace(descendant-or-self::tei:note/@*, 'txt:', '')"/></xsl:otherwise></xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="p">
                                <xsl:attribute name="class">mb-0</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!-- lem: render the compound in the apparatus entries -->
    <xsl:template name="lem-type">
        <xsl:choose>
            <xsl:when test="./@rend='hyphenfront' or tei:lem/@rend='hyphenfront'">
                <xsl:text>hyphenfront</xsl:text>
            </xsl:when>
            <xsl:when test="./@rend='hyphenback' or tei:lem/@rend='hyphenback'">
                <xsl:text>hyphenback</xsl:text>
            </xsl:when>
            <xsl:when test="./@rend='hyphenaround' or tei:lem/@rend='hyphenaround'">
                <xsl:text>hyphenaround</xsl:text>
            </xsl:when>
            <xsl:when test="./@rend='circlefront' or tei:lem/@rend='circlefront'">
                <xsl:text>circlefront</xsl:text>
            </xsl:when>
            <xsl:when test="./@rend='circleback' or tei:lem/@rend='circleback'">
                <xsl:text>circleback</xsl:text>
            </xsl:when>
            <xsl:when test="./@rend='circlearound' or tei:lem/@rend='circlearound'">
                <xsl:text>circlearound</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Metadata tab - special template in order to avoid the conflict with an apply-templates on teiHeader -->
    <xsl:template name="tab-metadata">
        <xsl:element name="div">
            <xsl:attribute name="class">tab-pane fade</xsl:attribute>
            <xsl:attribute name="id">metadata</xsl:attribute>
            <xsl:attribute name="role">tabpanel</xsl:attribute>
            <xsl:attribute name="aria-labelledby">metadata-tab</xsl:attribute>
            <xsl:element name="h4">Metadata of the Edition</xsl:element>
            <xsl:element name="ul">
                    <xsl:element name="li">
                        <xsl:element name="b">
                            <xsl:text>Title</xsl:text>
                        </xsl:element>
                        <xsl:text>: </xsl:text>
                        <xsl:apply-templates select="//tei:title[@type='main']"/>
                        <xsl:text>. </xsl:text>
                        <xsl:apply-templates select="//tei:title[@type='sub']"/>
                    </xsl:element>
                <xsl:element name="li">
                    <xsl:element name="b">
                        <xsl:text>Text Identifier</xsl:text>
                    </xsl:element>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="//tei:idno[@type='filename']"/>
                </xsl:element>
                    <xsl:element name="li">
                        <xsl:choose>
                            <xsl:when test="//tei:titleStmt[1]/tei:editor">
                                <xsl:for-each select="//tei:titleStmt[1]/tei:editor">
                            <xsl:choose>
                                <xsl:when test="position()= 1">
                                    <xsl:element name="b">
                                    <xsl:text>Edited by </xsl:text>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="position()=last()">
                                    <xsl:text> &amp; </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>, </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:apply-templates select="fn:normalize-space(.)"/>
                        </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="not(//tei:titleStmt[1]/tei:editor)">
                                <xsl:for-each select="//tei:titleStmt[1]/tei:respStmt/tei:persName">
                                    <xsl:choose>
                                        <xsl:when test="position()= 1">
                                            <xsl:element name="b">
                                                <xsl:text>Edited by </xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="position()=last()">
                                            <xsl:text> &amp; </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:apply-templates select="fn:normalize-space(.)"/>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                </xsl:element>
                <xsl:element name="li">
                    <xsl:value-of select="replace(//tei:fileDesc/tei:publicationStmt//tei:licence/tei:p[2], '\(c\)', '©')"/>
                </xsl:element>
            </xsl:element>
            <xsl:if test="//tei:projectDesc/tei:p">
                <xsl:apply-templates select="//tei:projectDesc/tei:p"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="tab-witness">
        <xsl:element name="div">
            <xsl:attribute name="class">tab-pane active</xsl:attribute>
            <xsl:attribute name="id">witnesses</xsl:attribute>
            <xsl:attribute name="role">tabpanel</xsl:attribute>
            <xsl:attribute name="aria-labelledby">witnesses-tab</xsl:attribute>
                <xsl:element name="h4">Description of the witness</xsl:element>
                <xsl:element name="ul">
                    <xsl:if test="//tei:msDesc/tei:msIdentifier//text()">
                        <xsl:element name="li">
                                <xsl:element name="b">
                                    <xsl:text>Manuscript Identity</xsl:text>
                                </xsl:element>
                                <xsl:text>: </xsl:text>
                            <xsl:element name="ul">
                                <xsl:if test="//tei:msDesc/tei:msIdentifier/tei:settlement">
                                    <xsl:element name="li">
                                    <xsl:element name="b">
                                        <xsl:text>Settlement</xsl:text>
                                    </xsl:element>
                                    <xsl:text>: </xsl:text>
                                        <xsl:apply-templates select="//tei:msDesc/tei:msIdentifier/tei:settlement"/>
                            </xsl:element>
                                </xsl:if>
                                <xsl:if test="//tei:msDesc/tei:msIdentifier/tei:institution">
                                    <xsl:element name="li">
                                        <xsl:element name="b">
                                            <xsl:text>Institution</xsl:text>
                                        </xsl:element>
                                        <xsl:text>: </xsl:text>
                                        <xsl:apply-templates select="//tei:msDesc/tei:msIdentifier/tei:institution"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="//tei:msDesc/tei:msIdentifier/tei:repository">
                                    <xsl:element name="li">
                                        <xsl:element name="b">
                                            <xsl:text>Repository</xsl:text>
                                        </xsl:element>
                                        <xsl:text>: </xsl:text>
                                        <xsl:apply-templates select="//tei:msDesc/tei:msIdentifier/tei:repository"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="//tei:msDesc/tei:msIdentifier/tei:idno">
                                    <xsl:element name="li">
                                        <xsl:element name="b">
                                            <xsl:text>Identifier</xsl:text>
                                        </xsl:element>
                                        <xsl:text>: </xsl:text>
                                        <xsl:apply-templates select="//tei:msDesc/tei:msIdentifier/tei:idno"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="//tei:msContents/tei:msItem//text()">
                        <xsl:element name="li">
                            <xsl:element name="b">
                                <xsl:text>Work</xsl:text>
                            </xsl:element>
                            <xsl:text>: </xsl:text>
                            <xsl:if test="//tei:msContents/tei:msItem/tei:title">
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                    <xsl:apply-templates select="//tei:msContents/tei:msItem/tei:title"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="//tei:msContents/tei:msItem/tei:author">
                                <xsl:text> by </xsl:text>
                                <xsl:apply-templates select="//tei:msContents/tei:msItem/tei:author"/>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="//tei:objectDesc//text()">
                        <xsl:element name="li">
                            <xsl:element name="b">
                                <xsl:text>Physical Description</xsl:text>
                            </xsl:element>
                            <xsl:text>: </xsl:text>
                            <xsl:choose>
                                <xsl:when test="not(child::tei:p)">
                                    <xsl:element name="ul">
                                        <xsl:if test="//tei:objectDesc/tei:supportDesc/tei:support">
                                            <xsl:element name="li">
                                                <xsl:element name="b">
                                                    <xsl:text>Support</xsl:text>
                                                </xsl:element>
                                                <xsl:text>: </xsl:text>
                                                <xsl:apply-templates select="//tei:objectDesc/tei:supportDesc/tei:support"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="//tei:objectDesc/tei:supportDesc/tei:extent">
                                            <xsl:element name="li">
                                            <xsl:element name="b">
                                                <xsl:text>Extent</xsl:text>
                                            </xsl:element>
                                            <xsl:text>: </xsl:text>
                                            <xsl:apply-templates select="//tei:objectDesc/tei:supportDesc/tei:extent"/>
                                    </xsl:element>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="normalize-space(//tei:objectDesc)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="//tei:layoutDesc//text()">
                        <xsl:element name="li">
                            <xsl:element name="b">
                                <xsl:text>Layout Description</xsl:text>
                            </xsl:element>
                            <xsl:text>: </xsl:text>
                            <xsl:apply-templates select="//tei:layoutDesc/child::*"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="//tei:handDesc//text()">
            <xsl:element name="li">
                <xsl:element name="b">
                    <xsl:text>Hand Description</xsl:text>
                </xsl:element>
                <xsl:text>: </xsl:text>
                <xsl:apply-templates select="//tei:handDesc/child::*"/>
            </xsl:element>
        </xsl:if>
                    <xsl:if test="//tei:history//text()">
                        <xsl:element name="li">
                            <xsl:element name="b">
                                <xsl:text>History</xsl:text>
                            </xsl:element>
                            <xsl:text>: </xsl:text>
                            <xsl:apply-templates select="normalize-space(//tei:history)"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:element>
    </xsl:template>

<xsl:template name="fake-lem-making">
    <xsl:choose>
        <xsl:when test="parent::tei:p">
            <xsl:value-of select="substring-before(parent::tei:p, ' ')"/>
            <xsl:text> [&#8230;] </xsl:text>
            <xsl:choose>
                <xsl:when test="parent::tei:p/tei:*[last()-1]/not(text())">
                    <xsl:choose>
                        <xsl:when test="parent::tei:p/tei:*[last()-1][local-name() ='app']"><xsl:value-of select="parent::tei:p/tei:*[last()-1]/tei:lem"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="parent::tei:p/tei:*[last()-1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="functx:substring-after-last(parent::tei:p, ' ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="parent::tei:lg">
            <xsl:value-of select="substring-before(parent::tei:lg/child::tei:l[1], ' ')"/>
            <xsl:text> [&#8230;] </xsl:text>
            <xsl:choose>
                <xsl:when test="ends-with(parent::tei:lg/child::tei:l[last()], '|')">
                    <xsl:value-of select="functx:substring-after-last(functx:substring-before-last-match(parent::tei:lg/child::tei:l[last()], '\s\|'), ' ')"/>
                </xsl:when><xsl:otherwise><xsl:value-of select="functx:substring-after-last(parent::tei:lg/child::tei:l[last()], ' ')"/></xsl:otherwise></xsl:choose>
        </xsl:when>
    </xsl:choose>
</xsl:template>

    <xsl:template name="app-tooltip-content">
        <xsl:param name="location"/>
        <xsl:param name="line-break"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
            <xsl:element name="span">
                <xsl:attribute name="class">tooltipApp</xsl:attribute>
                <xsl:element name="a">
                    <xsl:attribute name="tabindex">0</xsl:attribute>
                    <xsl:attribute name="data-toggle">popover</xsl:attribute>
                    <xsl:attribute name="data-html">true</xsl:attribute>
                    <xsl:attribute name="data-target">
                        <xsl:value-of select="generate-id()"/>
                    </xsl:attribute>
                    <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                        <xsl:value-of select="$app-num"/></xsl:attribute>
                    <xsl:attribute name="title">Apparatus <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | //tei:choice[child::tei:sic and child::tei:corr]"/></xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:text>from-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$location = 'apparatus' and tei:app[ancestor-or-self::tei:lem]"/>
                        <xsl:when test="$location = 'apparatus' and tei:app[ancestor-or-self::tei:listApp]"/>
                        <xsl:otherwise>
                            <xsl:text>(</xsl:text>
                            <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | //tei:choice[child::tei:sic and child::tei:corr]"/>
                        <xsl:text>)</xsl:text></xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>

            <!-- Version without the tooltip display in the body-->
           <!-- <xsl:element name="span">
                <xsl:attribute name="class">lem</xsl:attribute>
                <xsl:apply-templates select="tei:lem"/>
            </xsl:element>-->
    </xsl:template>

    <!-- tpl-translation -->
    <xsl:template name="tpl-translation">
        <xsl:variable name="filename">
            <xsl:value-of select="//tei:idno[@type='filename']"/>
        </xsl:variable>
        <xsl:variable name="document-trans">
            <xsl:choose>
                <xsl:when test="$corpus-type='nusantara'">
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename, '_transEng01.xml')"/>
                </xsl:when>
                <xsl:when test="$corpus-type='batak'">
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/batak/', $filename, '_transEng01.xml')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">Translation</xsl:element>
            <xsl:choose>
                <xsl:when test="document($document-trans)">
                    <xsl:apply-templates select="document($document-trans)//tei:text"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="p">
                        <xsl:attribute name="class">textContent</xsl:attribute>
                        <xsl:text>No translation available yet for </xsl:text>
                        <xsl:value-of select="$filename"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
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
                <!--<xsl:otherwise>
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
                </xsl:otherwise>-->
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

    <!-- Nav bar template -->
    <xsl:template name="nav-bar">
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="https://erc-dharma.github.io/">ERC-DHARMA</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="https://erc-dharma.github.io/">Home <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Collections
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfa-collection">Task-Force A</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfb-collection">Task-Force B</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfc-collection">Task-Force C</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#tfd-collection">Task-Force D</a>
                            <a class="dropdown-item" href="https://github.com/erc-dharma">All the repositories</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownConv" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Conventions
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/editorial">Editorial Conventions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/output-prosody/display-prosody.html">Prosodic Conventions</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Documentation
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/critEd_elements">Critical Editions Memo</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/DiplEd_elements">Diplomatic Editions Memo</a>
                            <div class="dropdown-divider"></div>
                            
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/encoding-diplomatic/DHARMA%20EGD%20v1%20release.pdf">Encoding Guide for Diplomatic editions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/FNC/DHARMA_FNC_v01.1.pdf">File Naming Conventions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/transliteration/DHARMA%20Transliteration%20Guide%20v3%20release.pdf">Transliteration Guide</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/zotero/DHARMA_ZoteroGuide_v01.1.1.pdf">Zotero Guide</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactControlledVoc">Artefacts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactClosedLists">Artefacts – Closed List</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textControlledVoc">Texts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textClosedLists">Texts – Closed List for texts</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/visual-code/UsingVS_v01">Starting with Visual Studio Code</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtom_v01">Starting with Atom</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtomGit_v01">Starting with Atom &amp; Git</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/atom/UsingAtomTeletype_v01">Starting with Atom Teletype</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/git/DHARMA_git_guide_v01">Starting with git</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/github-issuetracker/UsingGitHubIssueTracker.pdf">Starting with GitHub issues</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/github-issuetracker/UsingMarkdownSyntax_v01">Starting with markdown</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/digital-areal/">Starting with XML in French</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownConv" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Authorities
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://opentheso.huma-num.fr/opentheso/?idt=th347">Controlled Vocabularies</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="">Documentation for metadata and authorities - coming</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_places.html">Places</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_persons.html">Persons</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_monuments.html">Monuments</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/mdt-authorities/output/DHARMA_collections.html">Collections</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Epigraphical Publications
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="nav-link" href="https://erc-dharma.github.io/arie">ARIE</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/tfb-ec-epigraphy/">Epigraphia Carnatica</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/output-roej/display-roej.html">Répertoire Onomastique Java</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/tfa-sii-epigraphy/index-sii.html">South-Indian Inscriptions</a>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://github.com/erc-dharma">GitHub</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://www.zotero.org/groups/1633743/erc-dharma/library">Zotero Library</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="https://dharma.hypotheses.org/">Blog</a>
                    </li>
                </ul>
            </div>
        </nav>
    </xsl:template>

    <!-- tpl-com -->
    <xsl:template name="tpl-com">
        <xsl:variable name="filename">
            <xsl:value-of select="//tei:idno[@type='filename']"/>
        </xsl:variable>
        <xsl:variable name="document-com">
            <xsl:choose>
                <xsl:when test="$corpus-type='nusantara'">
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename, '_com.xml')"/>
                </xsl:when>
                <xsl:when test="$corpus-type='batak'">
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/batak/', $filename, '_com.xml')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">Commentary</xsl:element>
            <xsl:choose>
                <xsl:when test="document($document-com)">
                    <xsl:apply-templates select="document($document-com)//tei:text"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="p">
                        <xsl:attribute name="class">textContent</xsl:attribute>
                        <xsl:text>No commentary available yet for </xsl:text>
                        <xsl:value-of select="$filename"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!-- tpl-biblio -->
    <xsl:template name="tpl-biblio">
        <xsl:variable name="filename">
            <xsl:value-of select="//tei:idno[@type='filename']"/>
        </xsl:variable>
        <xsl:variable name="document-biblio">
            <xsl:choose>
                <xsl:when test="$corpus-type='nusantara'">
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename, '_biblio.xml')"/>
                </xsl:when>
                <xsl:when test="$corpus-type='batak'">
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/batak/', $filename, '_biblio.xml')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">Bibliography</xsl:element>
            <xsl:choose>
                <xsl:when test="document($document-biblio)">
                    <xsl:apply-templates select="document($document-biblio)//tei:text"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="p">
                        <xsl:attribute name="class">textContent</xsl:attribute>
                        <xsl:text>No bibliography available yet for </xsl:text>
                        <xsl:value-of select="$filename"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!-- side bar - table of contents -->
    <xsl:template name="table-contents">
        <xsl:element name="div">
            <xsl:attribute name="id">sidebar-wrapper</xsl:attribute>
            <xsl:attribute name="class">collapse</xsl:attribute>
            <!--<xsl:element name="h4">
                <xsl:attribute name="class">text-align-center</xsl:attribute>
                <xsl:text>Document Outline</xsl:text>
            </xsl:element>-->
            <xsl:element name="nav">
                <xsl:attribute name="id">myScrollspy</xsl:attribute>
                <xsl:element name="ul">
                    <xsl:attribute name="class">nav nav-pills flex-column</xsl:attribute>
                    <xsl:for-each select="//tei:pb">
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:text>Folio </xsl:text>
                                <xsl:value-of select="@n"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>

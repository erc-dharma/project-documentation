<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" use-character-maps="htmlDoc"/>
    
    <xsl:character-map name="htmlDoc">
        <xsl:output-character character="&apos;" string="&amp;rsquo;" />
    </xsl:character-map>
    
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
    
    
    <!-- Coded initially written by Andrew Ollet, for DHARMA Berlin workshop in septembre 2020 -->
    <!-- Updated and reworked for DHARMA by Axelle Janiak, starting 2021 -->
    
    <xsl:variable name="script">
        <xsl:for-each select="//tei:profileDesc/tei:langUsage/tei:language">
           <xsl:value-of select="substring-after(@ident, '-')"/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="edition-id">
        <xsl:value-of select="tei:TEI[@type='edition']/@xml:id"/>
    </xsl:variable>
   
    <xsl:template match="/tei:TEI">
        <xsl:element name="html">
        <xsl:call-template name="dharma-head"/>
        <xsl:element name="body">
            <xsl:attribute name="class">font-weight-light</xsl:attribute>
            <xsl:attribute name="data-spy">scroll</xsl:attribute>
            <xsl:attribute name="data-target">#myScrollspy</xsl:attribute>
            <xsl:attribute name="data-offset">5</xsl:attribute>
           
            <xsl:element name="div">
                <xsl:attribute name="class">wrapper-content</xsl:attribute>
                <xsl:call-template name="table-contents"/>
              
            
            <xsl:element name="div">
                <xsl:attribute name="id">content</xsl:attribute>
                <xsl:call-template name="nav-bar"/>
                
                <a class="btn btn-info" data-toggle="collapse" href="#sidebar-wrapper" role="button" aria-expanded="false" aria-controls="sidebar-wrapper" id="sidebarCollapse">
                    <span>☰ Document Outline</span>
                </a>
                
                <!-- <button type="button" id="sidebarCollapse" class="btn btn-info">
                        <i class="fas fa-align-left"></i>
                        <span>Toggle Sidebar</span>
                    </button>
                    <button class="btn btn-dark d-inline-block d-lg-none ml-auto" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <i class="fas fa-align-justify"></i>
                    </button> -->
            <xsl:apply-templates select="./tei:teiHeader"/>
                            <xsl:element name="div">
                                <xsl:attribute name="class">row wrapper text-break</xsl:attribute>
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
                            <xsl:text>Witnesses</xsl:text>
                            </xsl:element>
                        </xsl:element> 
                    </xsl:element>
                   <!-- <xsl:element name="li">
                        <xsl:attribute name="class">nav-item</xsl:attribute>
                        <xsl:attribute name="role">presentation</xsl:attribute>
                        <xsl:element name="a">
                            <xsl:attribute name="class">nav-link</xsl:attribute>
                            <xsl:attribute name="id">sources-tab</xsl:attribute>
                            <xsl:attribute name="data-toggle">tab</xsl:attribute>
                            <xsl:attribute name="href">#sources</xsl:attribute>
                            <xsl:attribute name="role">tab</xsl:attribute>
                            <xsl:attribute name="aria-controls">sources</xsl:attribute>
                            <xsl:attribute name="aria-selected">false</xsl:attribute>
                            <xsl:element name="div">
                                <xsl:attribute name="class">panel</xsl:attribute>
                                    <xsl:text>Sources</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>-->
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
                    <!--<xsl:apply-templates select=".//tei:listBibl"/>-->
                    <xsl:apply-templates select=".//tei:listWit"/>
                    <xsl:call-template name="tab-metadata"/>
                </xsl:element>
                        </xsl:element>
                 <xsl:apply-templates select="./tei:text"/>
            <xsl:apply-templates select=".//tei:app" mode="modals"/>
                <xsl:apply-templates select=".//tei:note" mode="modals"/>
                <xsl:apply-templates select=".//tei:span[@type='omissionStart']" mode="modals"/>
                <xsl:call-template name="tpl-apparatus"/>
                <!--<xsl:call-template name="tpl-translation"/>-->
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
        </xsl:element>
    </xsl:template>
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
                        <xsl:apply-templates select="normalize-space(.)"/>
                    </xsl:for-each>
                    </xsl:element>
                </xsl:if>
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
    <!--  ab ! -->
    <xsl:template match="tei:ab">
        <xsl:if test="@type">
            <xsl:element name="p">
                <xsl:attribute name="class">float-center</xsl:attribute>
                <xsl:element name="small">
                    <xsl:element name="span">
                        <xsl:attribute name="class">text-muted</xsl:attribute>
                        <xsl:value-of select="@type"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:element name="div">
            <xsl:attribute name="class">row mt-2</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col text-col</xsl:attribute>
                <xsl:element name="p">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-2 apparat-col text-right</xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  add ! -->
    <xsl:template match="tei:add">
        <xsl:element name="a">
            <xsl:attribute name="class">ed-insertion</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">Editorial insertion.</xsl:attribute>
            <xsl:if test="@hand">
                <xsl:text>H</xsl:text>
                <xsl:element name="sub">
                <xsl:value-of select="substring-after(@hand, '_H')"/>
                </xsl:element>
                <xsl:if test="@place">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="@place and not(@place='unspecified')">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@place='inline'">
                                <xsl:text>in textu </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='below'">
                            <xsl:text>subscr. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='above'">
                            <xsl:text>suprascr. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='top'">
                            <xsl:text>in mg. sup. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='bottom'">
                            <xsl:text>in mg. inf. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='left'">
                            <xsl:text>in mg. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='right'">
                            <xsl:text>in mg. </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place='overstrike'">
                            <xsl:text>in ras. </xsl:text>
                        </xsl:when>
            </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    <!--  app ! -->
    <xsl:template match="tei:app" mode="modals">
        <xsl:variable name="apparatus">
            <!--<xsl:element name="span">-->
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
                                    <xsl:apply-templates select="tei:lem"/>
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
                                <xsl:if test="tei:lem/@type='absent_elsewhere'">
                                    <xsl:text> only in </xsl:text>
                                </xsl:if>
                                <xsl:if test="tei:lem/@type='reformulated_elsewhere'">
                                    <xsl:text> thus formulated in </xsl:text>
                                </xsl:if>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-weight-bold <xsl:if test="tei:lem/following-sibling::*[local-name()='witDetail'] or tei:lem/@varSeq">supsub</xsl:if>
                                    </xsl:attribute>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="tei:lem/@wit"/>
                                        <xsl:with-param name="witdetail-string" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                </xsl:call-template>
                                    <xsl:if test="tei:lem/@varSeq">
                                        <xsl:choose>
                                            <xsl:when test="tei:lem/@varSeq='1'">
                                                <xsl:element name="sub">
                                                    <xsl:text>ac</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when test="tei:lem/@varSeq='2'">
                                                <xsl:element name="sub">
                                                    <xsl:text>pc</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:if>
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
                <xsl:if test="tei:rdg[not(@type='paradosis')]">
                    <xsl:choose>
                        <xsl:when test="tei:rdg/preceding-sibling::*[local-name()='lem'][1]/@type='absent_elsewhere'"/>
                        <xsl:otherwise>
                            <xsl:element name="hr"/>
                    <xsl:for-each select="tei:rdg">
                        <xsl:element name="span">
                            <xsl:attribute name="class">reading-line<xsl:choose><xsl:when test="descendant-or-self::tei:lacunaStart"><xsl:text> lacunaStart</xsl:text></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionStart']"> omissionStart</xsl:when><xsl:when test="descendant-or-self::tei:lacunaEnd"><xsl:text> lacunaEnd</xsl:text></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionEnd']"> omissionEnd</xsl:when></xsl:choose>
                            </xsl:attribute>
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
                                             <xsl:when test="child::tei:gap[@reason='lost'and not(@quantity|@unit)]">
                                                 <xsl:element name="span">
                                                     <xsl:attribute name="class">font-italic</xsl:attribute>
                                                     <xsl:attribute name="style">color:black;</xsl:attribute>
                                                     <xsl:text>lac.</xsl:text> 
                                                 </xsl:element>
                                             </xsl:when>
                                             <xsl:when test="child::tei:lacunaEnd or child::tei:span[@type='omissionEnd']">...]</xsl:when>
                                            </xsl:choose> 
                                    
                                    <xsl:apply-templates/>
                                    <xsl:choose>
                                        <xsl:when test="child::tei:lacunaStart or child::tei:span[@type='omissionStart']">[...</xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-weight-bold <xsl:if test="following-sibling::*[local-name()='witDetail'] or ./@varSeq"> supsub</xsl:if></xsl:attribute>
                                <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="./@wit"/>
                                    <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                    <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                    <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                            </xsl:call-template>
                                <xsl:if test="./@varSeq">
                                    <xsl:choose>
                                        <xsl:when test="./@varSeq='1'">
                                            <xsl:element name="sub">
                                                <xsl:text>ac</xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="./@varSeq='2'">
                                            <xsl:element name="sub">
                                                <xsl:text>pc</xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:if test="./@source">
                                    <xsl:call-template name="source-siglum">
                                        <xsl:with-param name="string-to-siglum" select="./@source"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:element>
                                <xsl:if test="./@cause">
                                    <xsl:element name="span">
                                        <xsl:attribute name="style">color:black;</xsl:attribute>
                                        <xsl:text> (</xsl:text>
                                        <xsl:value-of select="replace(./@cause, '_', ' ')"/>
                                        <xsl:text>)</xsl:text>
                                    </xsl:element>
                                </xsl:if>
                            
                            <!--<xsl:if test="./following-sibling::tei:rdg">
                                <xsl:text>; </xsl:text>
                            </xsl:if>-->
                        </xsl:element>              
                    </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                 <xsl:if test="tei:rdg[@type='paradosis']">
                    <xsl:element name="hr"/>
                    <xsl:for-each select="tei:rdg[@type='paradosis']">
                        <xsl:element name="span">
                            <xsl:attribute name="class">paradosis-line</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:text>Paradosis</xsl:text>
                            </xsl:element>
                            <xsl:text> of </xsl:text>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="@wit"/>
                                <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                            </xsl:call-template>
                            <xsl:text>: </xsl:text>                            
                            <!--<xsl:apply-templates select="node() except child::tei:span[@type='omissionStart']"/>-->
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
                <!--  Notes ! -->
                <xsl:if test="tei:note[not(@type='altLem') or ancestor::tei:listApp]">
                    <xsl:element name="hr"/>
                    <xsl:for-each select="tei:note[not(@type='altLem')]">
                        <xsl:element name="span">
                            <xsl:attribute name="class">note-line</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>           
            <!--</xsl:element>-->
        </xsl:variable>
        
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus"/>
        </span>
        
    </xsl:template>
    
    <xsl:template match="tei:app[not(parent::tei:listApp[@type='parallels'])]">
        <xsl:param name="location"/>
        <xsl:param name="app-num"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
            <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>lem</xsl:text>
                <xsl:if test="descendant::tei:span[@type='omissionStart']"> omissionStart</xsl:if>
                <xsl:if test="descendant::tei:span[@type='omissionEnd']"> omissionEnd</xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-app">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            
            <!--<xsl:attribute name="tabindex">0</xsl:attribute>
            <xsl:attribute name="data-toggle">popover</xsl:attribute>
            <xsl:attribute name="data-html">true</xsl:attribute>
            <xsl:attribute name="data-target">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                <xsl:value-of select="$app-num"/></xsl:attribute>
            <xsl:attribute name="title">Apparatus <xsl:number level="any" count="//tei:app[not(parent::tei:listApp)] | .//tei:note[last()][parent::tei:p or parent::tei:lg]"/></xsl:attribute>
            <xsl:attribute name="id">
                <xsl:text>from-app-</xsl:text>
                <xsl:value-of select="$app-num"/>
            </xsl:attribute>-->
              
                <xsl:apply-templates select="tei:lem"/>
                <xsl:choose>
                    <xsl:when test="$location='text'"/>
                    <xsl:otherwise>
                        <xsl:call-template name="app-link">
                    <xsl:with-param name="location" select="'apparatus'"/>
                </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>   
        </xsl:element>
        
        <xsl:if test="descendant::tei:span[@type='omissionStart']">
            <xsl:apply-templates select="descendant::tei:span[@type='omissionStart']" mode="omission-number"/>
        </xsl:if>
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
    <!--  caesura ! -->
    <xsl:template match="tei:caesura">
        <xsl:element name="span">
            <xsl:attribute name="class">caesura</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!--  choice ! -->
    <xsl:template match="tei:choice[child::tei:unclear]">
        <xsl:element name="span">
            <xsl:attribute name="class">unclear</xsl:attribute>
            <xsl:apply-templates select="child::tei:unclear[1]"/>
            <xsl:text>/</xsl:text>
            <xsl:apply-templates select="child::tei:unclear[2]"/>
        </xsl:element>
    </xsl:template>
    <!--<xsl:template match="tei:choice[@type = 'chaya']">
        <xsl:element name="span">
            <xsl:attribute name="class">prakritword san</xsl:attribute>
            <xsl:apply-templates select="tei:orig"/>
        </xsl:element>
        <xsl:element name="span">
            <xsl:attribute name="class">sanskritword san</xsl:attribute>
            <xsl:apply-templates select="tei:reg"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:choice[@type = 'chaya']" mode="in-modal">
        <xsl:element name="span">
            <xsl:attribute name="class">prakritword san</xsl:attribute>
            <xsl:apply-templates select="tei:orig"/>
        </xsl:element>
    </xsl:template>-->
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
    <!-- colophon -->
   <!-- <xsl:template name="colophon">
        <xsl:if test="//tei:colophon">
            <xsl:element name="hr"/>
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col-1 text-center</xsl:attribute>   
                        <xsl:value-of select="number(//tei:div[@type='chapter'][last()]/@n) + 1"/>
                        <xsl:text>. </xsl:text>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-11</xsl:attribute>
                <xsl:element name="p">
                    <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                    <xsl:text>Colophon</xsl:text>
                </xsl:element>
                <xsl:for-each select="//tei:colophon">
                    <xsl:element name="p">
                        <xsl:element name="span">
                            <xsl:attribute name="class">text-muted foliation</xsl:attribute>
                            <xsl:value-of select="./ancestor::tei:witness/@xml:id"/>
                        </xsl:element>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element></xsl:if>
    </xsl:template>-->
    <!--  D ! -->
    <!--  del ! -->
    <xsl:template match="tei:del">
        <xsl:element name="a">
            <xsl:attribute name="class">ed-deletion</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">Editorial deletion.</xsl:attribute>
            <xsl:element name="span">
                <xsl:attribute name="class">scribe-deletion</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--  div ! -->
    <xsl:template match="tei:div">
        <xsl:variable name="prosody" select="document('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_prosodicPatterns_v01.xml')"/>
        <!-- https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_prosodicPatterns_v01.xml 
       https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/DHARMA_prosodicPatterns_v01.xml
        -->
        <xsl:variable name="metrical" select="@met"/>
        <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>
            <xsl:element name="div">
                <!--<xsl:choose>
                    <xsl:when test="@type='canto'">
                        <xsl:attribute name="class">col-2</xsl:attribute>
                    </xsl:when>
                <xsl:otherwise>-->
                <xsl:attribute name="class">col-1 text-center</xsl:attribute>
                <!--</xsl:otherwise>
            </xsl:choose>-->
                <xsl:choose>
                    <xsl:when test="@type='interpolation'">
                        <xsl:value-of select="preceding::tei:div[1]/@n"/>
                        <xsl:text>*. </xsl:text>
                    </xsl:when>
                    <xsl:when test="@type='canto'"/>
                    <xsl:otherwise>
                        <xsl:element name="p">
                            <xsl:choose>                              
                                <xsl:when test="@n">
                                    <xsl:value-of select="@n"/>
                                    <xsl:text>. </xsl:text>
                                </xsl:when>
                            </xsl:choose>
                </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="div">
                        <xsl:attribute name="class">col-10</xsl:attribute>
                <xsl:if test="@xml:id">
                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="@type='canto'">
                    <xsl:element name="p">
                    <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                    <xsl:text>Canto </xsl:text>
                    <xsl:value-of select="@n"/>
                </xsl:element>
                    <xsl:if test="@met">
                    <xsl:element name="p">
                    <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="matches(@met,'[=\+\-]+')">
                            <xsl:call-template name="scansion">
                                <xsl:with-param name="met-string" select="translate(@met, '-=+', '⏑⏓–')"/>
                                <xsl:with-param name="string-len" select="string-length(@met)"/>
                                <xsl:with-param name="string-pos" select="string-length(@met) - 1"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(upper-case(substring(@met,1,1)), substring(@met, 2),' '[not(last())] )"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$prosody//tei:item[tei:name =$metrical]">
                            <xsl:variable name="prosody-and-met" select="$prosody//tei:item[tei:name = $metrical]/child::tei:seg[@type='xml']/node()"/>
                        <xsl:text>: </xsl:text>
                            <xsl:call-template name="scansion">
                                <xsl:with-param name="met-string" select="translate($prosody-and-met, '-=+', '⏑⏓–')"/>
                                <xsl:with-param name="string-len" select="string-length($prosody-and-met)"/>
                                <xsl:with-param name="string-pos" select="string-length($prosody-and-met) - 1"/>
                            </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                        <xsl:call-template name="scansion">
                            <xsl:with-param name="met-string" select="translate(@real, '-=+', '⏑⏓–')"/>
                            <xsl:with-param name="string-len" select="string-length(@real)"/>
                            <xsl:with-param name="string-pos" select="string-length(@real) - 1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                </xsl:if>
                </xsl:if>
                <xsl:apply-templates/>
                <!--<xsl:if test="@xml:id">
                    <xsl:element name="div">
                    <xsl:attribute name="class">col-10</xsl:attribute>
                    <xsl:element name="a">
                    <xsl:attribute name="class">btn btn-outline-dark btn-block</xsl:attribute>
                    <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                    <xsl:attribute name="href">#<xsl:value-of select="generate-id()"/></xsl:attribute>
                    <xsl:attribute name="role">button</xsl:attribute>
                    <xsl:attribute name="aria-expanded">false</xsl:attribute>
                    <xsl:attribute name="aria-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                    
                    <xsl:element name="small"><xsl:text>Translation</xsl:text></xsl:element>
                        <!-\- need to add the language -\->
                </xsl:element>
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:value-of select="generate-id()"/>
                    </xsl:attribute>
                    <xsl:attribute name="class">collapse</xsl:attribute>
                    <xsl:element name="div">
                        <xsl:attribute name="class">card card-body border-dark</xsl:attribute>
                        <xsl:call-template name="tpl-translation">
                            <xsl:with-param name="textpart-id" select="@xml:id"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:element> 
                </xsl:if>-->
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
    <!--  G ! -->
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason='omitted'"/>
            <xsl:when test="@reason='lost' and not(@quantity|@unity)"/>
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
            <xsl:attribute name="class">
                <xsl:text>translit </xsl:text>
                <xsl:value-of select="$script"/>
            </xsl:attribute>
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
                <xsl:text>l translit</xsl:text>
                <!--<xsl:text> </xsl:text>
                    <xsl:value-of select="$script"/>-->
            </xsl:attribute>
                <xsl:if test="@real">
                    <xsl:text>[</xsl:text>
                    <xsl:choose>
                        <xsl:when test="matches(@real, '[\-\+=]')">
                            <xsl:call-template name="scansion">
                                <xsl:with-param name="met-string" select="translate(@real, '-=+', '⏑⏓–')"/>
                                <xsl:with-param name="string-len" select="string-length(@real)"/>
                                <xsl:with-param name="string-pos" select="string-length(@real) - 1"/>
                    </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@real"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>] </xsl:text>
                </xsl:if>
            <xsl:apply-templates/> 
        </xsl:element>
    </xsl:template>
    <!-- lacunaEnd & lacunaStart -->    
<!-- <xsl:template match="tei:lacunaStart">
           <xsl:text>[...</xsl:text>
    </xsl:template>    
    <xsl:template match="tei:lacunaEnd">
        <xsl:text>...]</xsl:text>
    </xsl:template>-->
    <!--  lb ! -->
    <xsl:template match="tei:lb">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted lineation</xsl:attribute>
            <xsl:value-of select="@n"/>
        </xsl:element>
    </xsl:template>
    <!--  lg ! -->
    <xsl:template match="tei:lg">
        <xsl:if test="@n | @met">
            <xsl:element name="p">
                <xsl:attribute name="class">float-center</xsl:attribute>
                <xsl:element name="small">
                    <xsl:element name="span">
                        <xsl:attribute name="class">text-muted</xsl:attribute>
                        <!--<xsl:if test="parent::tei:div[@type='canto']">
                            <xsl:value-of select="parent::tei:div[@type='canto']/@n"/>
                            <xsl:text>.</xsl:text>
                        </xsl:if>-->
                        <!--<xsl:if test="@n">
                            <xsl:number format="I" value="@n"/>
                        </xsl:if>
                        <xsl:if test="@n and @rend='met'">
                            <xsl:text> </xsl:text>
                        </xsl:if>-->
                        <xsl:if test="@rend='met'">
                            <xsl:choose>
                                <xsl:when test="matches(@met,'[\+\-]+')">
                                    <xsl:call-template name="scansion">
                                        <xsl:with-param name="met-string" select="translate(@met, '-=+', '⏑⏓–')"/>
                                        <xsl:with-param name="string-len" select="string-length(@met)"/>
                                        <xsl:with-param name="string-pos" select="string-length(@met) - 1"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(upper-case(substring(@met,1,1)), substring(@met, 2),' '[not(last())] )"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:element name="div">
            <xsl:attribute name="class">row mt-2</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col text-col</xsl:attribute><!-- testconteneur -->
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
                        <xsl:if test="ancestor-or-self::tei:supplied[@reason='omitted']"> lg-omitted</xsl:if>
                    </xsl:attribute>
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    </xsl:if>
                    <!--<xsl:if test="ancestor-or-self::tei:supplied[@reason='omitted']">⟨</xsl:if>-->
                        <xsl:apply-templates/>
                    <!--<xsl:if test="ancestor-or-self::tei:supplied[@reason='omitted']">⟩</xsl:if>-->
                    <xsl:if test="@n">
                        <xsl:element name="span">
                            <xsl:attribute name="class">text-muted lg-number</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="contains(@n, '.')">
                                <xsl:value-of select="functx:substring-after-last(@n, '.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@n"/>
                            </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="class">col-2 apparat-col text-right</xsl:attribute>
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
    <xsl:template match="tei:listApp[@type = 'apparatus']">
        <xsl:element name="div">
            <xsl:attribute name="class">col-10</xsl:attribute>
                    <xsl:element name="a">
                        <xsl:attribute name="class">btn btn-outline-dark btn-block</xsl:attribute>
                        <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                        <xsl:attribute name="data-target"><xsl:value-of select="concat( '#', generate-id())"/></xsl:attribute>
                        <xsl:attribute name="role">button</xsl:attribute>
                        <xsl:attribute name="aria-expanded">false</xsl:attribute>
                        <xsl:attribute name="aria-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                       
                            <xsl:element name="small">
                                <xsl:text>Apparatus</xsl:text>
                            </xsl:element>
                    </xsl:element>
            <xsl:element name="div">
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:attribute name="class">collapse</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">card-body border-dark</xsl:attribute>
                            <xsl:for-each select="tei:app">
                            <xsl:call-template name="dharma-app">
                                <xsl:with-param name="apptype">
                                    <xsl:choose>
                                        <xsl:when test="self::tei:app">
                                            <xsl:text>app</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="self::tei:note">
                                            <xsl:text>note</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="self::tei:span[@type='omissionStart']">
                                            <xsl:text>omission</xsl:text>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:with-param>
                            </xsl:call-template>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--<xsl:template match="tei:listApp[@type='apparatus']">
        <xsl:variable name="lem-external-app" select="tei"/>
       <xsl:for-each select="tei:app[@loc]">
           <xsl:call-template name="apparatus-making">
               <xsl:with-param name="lem" select="tei:lem/text()"/>
               <xsl:with-param name="preceding-text" select="preceding::tei:*[1]/text()"/>
           </xsl:call-template>
       </xsl:for-each>

    </xsl:template>-->
    
    
    <xsl:template match="tei:listApp[@type='parallels']">
        <xsl:element name="div">
            <xsl:attribute name="class">parallels
             <xsl:choose>
                 <xsl:when test="ancestor::tei:p | ancestor::tei:ab"/>
                 <xsl:otherwise>
                     <xsl:text>col-10</xsl:text>
                 </xsl:otherwise>
             </xsl:choose>
            </xsl:attribute>
        <xsl:if test="descendant::tei:note">
                <xsl:element name="a">
                    <xsl:attribute name="class">btn btn-outline-dark btn-block</xsl:attribute>
                    <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                    <xsl:attribute name="href">#<xsl:value-of select="generate-id()"/></xsl:attribute>
                    <xsl:attribute name="role">button</xsl:attribute>
                    <xsl:attribute name="aria-expanded">false</xsl:attribute>
                    <xsl:attribute name="aria-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                    
                        <xsl:element name="small"><xsl:text>Parallels</xsl:text></xsl:element>
                    
                </xsl:element>
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:value-of select="generate-id()"/>
                    </xsl:attribute>
                    <xsl:attribute name="class">collapse</xsl:attribute>
                    <xsl:element name="div">
                        <xsl:attribute name="class">card card-body border-dark</xsl:attribute>
                        <xsl:call-template name="parallels-content"/>
                    </xsl:element>
                </xsl:element>
        </xsl:if>
                <!--<xsl:element name="div">
                    <xsl:attribute name="class">card h-80</xsl:attribute>
                    <xsl:element name="div">
                        <xsl:attribute name="class">card-header</xsl:attribute>
                            <xsl:element name="button">
                                <xsl:attribute name="class">btn btn-link</xsl:attribute>
                                <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                <xsl:attribute name="data-target"><xsl:value-of select="concat( '#', generate-id())"/></xsl:attribute>
                                <xsl:attribute name="aria-expanded">false</xsl:attribute>
                                <xsl:attribute name="arial-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                                <xsl:element name="small">
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
                </xsl:element>-->
            
        </xsl:element>
    </xsl:template>
    
    <!--  listBibl -->
    <!-- Must be reworked -->
    <xsl:template match="tei:listBibl">
        <xsl:choose>
            <xsl:when test="ancestor::tei:teiHeader">
            <xsl:element name="ul">
                <xsl:choose>
                    <xsl:when test="tei:biblStruct">
                        <xsl:for-each select="tei:biblStruct">
                    <xsl:element name="li">
                        <xsl:element name="a">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="b">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:element>
                        <xsl:text>: </xsl:text>
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:bibl">
                            <xsl:element name="li">
                                <xsl:apply-templates select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
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
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
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
                            <xsl:when test="child::tei:msDesc">
                                <!--<xsl:apply-templates select="child::tei:*[position() > 1]"/>-->
                                
                                    <xsl:if test="./tei:msDesc/tei:msIdentifier//text()">
                                        <xsl:if test="./tei:msDesc/tei:msIdentifier/tei:institution">
                                            
                                            <xsl:apply-templates select="./tei:msDesc/tei:msIdentifier/tei:institution"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                                <xsl:if test="./tei:msDesc/tei:msIdentifier/tei:settlement">
                                                        <xsl:apply-templates select="./tei:msDesc/tei:msIdentifier/tei:settlement"/>
                                                    <xsl:text>, </xsl:text>
                                                </xsl:if>
                                                
                                                <xsl:if test="./tei:msDesc/tei:msIdentifier/tei:repository">
                                                        <xsl:apply-templates select="./tei:msDesc/tei:msIdentifier/tei:repository"/>
                                                    <xsl:text>, </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="./tei:msDesc/tei:msIdentifier/tei:idno">
                                                    
                                                        <xsl:apply-templates select="./tei:msDesc/tei:msIdentifier/tei:idno"/>
                                                    
                                                </xsl:if>
                                    </xsl:if>
                                    <xsl:element name="ul">
                                        <xsl:if test="./tei:msDesc/tei:msContents/tei:msItem[child::*/text()]">
                                        <xsl:element name="li">
                                            <xsl:element name="b">
                                                <xsl:text>Content</xsl:text>
                                            </xsl:element>
                                            <xsl:text>: </xsl:text>
                                            <xsl:element name="ul">
                                                <xsl:for-each select="./tei:msDesc/tei:msContents/tei:msItem[child::tei:locus|child::tei:author|child::tei:title/text()]">
                                                    <xsl:element name="li">
                                                    <xsl:if test="./tei:locus">
                                                        <xsl:apply-templates select="./tei:locus"/>
                                                        <xsl:text>: </xsl:text>
                                                    </xsl:if>
                                                    <xsl:element name="span">
                                                        <xsl:attribute name="class">font-italic</xsl:attribute>
                                                        <xsl:apply-templates select="./tei:title"/>
                                                    </xsl:element>
                                                    <xsl:if test="./tei:author">
                                                        <xsl:text> by </xsl:text>
                                                        <xsl:apply-templates select="./tei:author"/>
                                                    </xsl:if>                                                        
                                                </xsl:element> 
                                                </xsl:for-each>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="li">
                                            <xsl:element name="b">
                                                <xsl:text>Colophon</xsl:text>
                                            </xsl:element>
                                            <xsl:text>: </xsl:text>
                                            <xsl:element name="ul">
                                                <xsl:for-each select="./tei:msDesc/tei:msContents/tei:msItem[child::tei:colophon/text()]">
                                                <xsl:element name="li">
                                                    <xsl:element name="span">
                                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                            <xsl:apply-templates select="./tei:colophon"/>
                                                    </xsl:element>
                                                </xsl:element>
                                                </xsl:for-each>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="./tei:msDesc/tei:physDesc//text()">
                                        <xsl:element name="li">
                                            <xsl:element name="b">
                                                <xsl:text>Physical Description</xsl:text>
                                            </xsl:element>
                                            <xsl:text>: </xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="./tei:msDesc/tei:physDesc/tei:objectDesc">
                                                    <xsl:element name="ul">
                                                        <xsl:if test="./tei:objectDesc/tei:supportDesc/tei:support">
                                                            <xsl:element name="li">
                                                                <xsl:element name="b">
                                                                    <xsl:text>Support</xsl:text>
                                                                </xsl:element>
                                                                <xsl:text>: </xsl:text>
                                                                <xsl:apply-templates select="./tei:objectDesc/tei:supportDesc/tei:support"/>
                                                            </xsl:element>
                                                        </xsl:if>
                                                        <xsl:if test="./tei:objectDesc/tei:supportDesc/tei:extent">
                                                            <xsl:element name="li">
                                                                <xsl:element name="b">
                                                                    <xsl:text>Extent</xsl:text>
                                                                </xsl:element>
                                                                <xsl:text>: </xsl:text>
                                                                <xsl:apply-templates select="./tei:objectDesc/tei:supportDesc/tei:extent"/>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select="normalize-space(./tei:msDesc/tei:physDesc/tei:p)"/>
                                               </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="./tei:msDesc/tei:physDesc/tei:handDesc//text()">
                                        <xsl:element name="li">
                                            <xsl:element name="b">
                                                <xsl:text>Hand Description</xsl:text>
                                            </xsl:element>
                                            <xsl:text>: </xsl:text>
                                            <xsl:apply-templates select="./tei:msDesc/tei:physDesc/tei:handDesc/child::*"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="./tei:msDesc/tei:history//text()">
                                        <xsl:element name="li">
                                            <xsl:element name="b">
                                                <xsl:text>History</xsl:text>
                                            </xsl:element>
                                            <xsl:text>: </xsl:text>
                                            <xsl:apply-templates select="normalize-space(./tei:msDesc/tei:history)"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::tei:bibl">
                                <xsl:apply-templates select="tei:bibl"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="node() except child::tei:abbr"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- locus -->
    <xsl:template match="tei:locus[not(ancestor-or-self::tei:teiHeader)]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:text> from </xsl:text>
            <xsl:value-of select="@from"/>
            <xsl:text> to </xsl:text>
            <xsl:value-of select="@to"/>
            <xsl:text>]</xsl:text>
    </xsl:template>
    
    <!--  N ! -->
    <!--  name ! -->
    <xsl:template match="tei:name">
        <xsl:element name="span">
            <xsl:attribute name="class">name san</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:note[@type='prosody']"/>
    
    <xsl:template match="tei:note">
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="tei:note[@type='prosody']"/>
            <xsl:when test="self::tei:note[position() = last()][parent::tei:p or parent::tei:lg] or self::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]">
                        <xsl:call-template name="app-link">
                            <xsl:with-param name="location" select="'apparatus'"/>
                        </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:note" mode="modals">
        <xsl:variable name="apparatus-note">
            <xsl:if test="self::tei:note[position()=last()][parent::tei:p or parent::tei:lg or not(@type='parallels' or parent::tei:app or @type='altLem')] or self::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]">
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
            <xsl:when test="//tei:TEI[@type='translation']">
                <xsl:element name="p">
                    <xsl:attribute name="class">text-justify</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="ancestor::tei:projectDesc">
                    <xsl:element name="p">
                        <xsl:attribute name="class">text-justify</xsl:attribute> 
                        <xsl:apply-templates/>
                    </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p">
            <xsl:attribute name="class">float-center</xsl:attribute><!--text-container -->
            <xsl:element name="small">
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
                    <xsl:if test="parent::tei:div[@type = 'liminal']">
                        <xsl:value-of select="parent::tei:div[@type = 'liminal']/@n"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::tei:div[@type = 'interpolation']">
                        <xsl:choose>
                            <xsl:when test="ancestor-or-self::tei:div[@type = 'interpolation']/@n">
                                <xsl:value-of select="ancestor-or-self::tei:div[@type = 'interpolation']/@n"/>
                                <xsl:text>.</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="ancestor-or-self::tei:div[@type = 'interpolation']/preceding::tei:div[1]/@n"/>
                                <xsl:text>*.</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="parent::tei:div[not(@type = 'chapter' or @type = 'dyad' or @type ='interpolation' or @type = 'liminal')]">
                        <xsl:value-of select="ancestor-or-self::tei:div/@n"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$p-num"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="//tei:TEI[@type='edition'] and ancestor::tei:body">
            <xsl:element name="div">
            <xsl:attribute name="class">row mt-2</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">col text-col</xsl:attribute>
            <xsl:element name="p">
            <!--<xsl:attribute name="class">textContent</xsl:attribute>-->
            <xsl:apply-templates/>
                <xsl:if test="@xml:id">
                    <xsl:element name="div">
                        <!--<xsl:attribute name="class">col-10</xsl:attribute>-->
                        <xsl:element name="a">
                            <xsl:attribute name="class">btn btn-outline-dark btn-block</xsl:attribute>
                            <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                            <xsl:attribute name="href">#<xsl:value-of select="generate-id()"/></xsl:attribute>
                            <xsl:attribute name="role">button</xsl:attribute>
                            <xsl:attribute name="aria-expanded">false</xsl:attribute>
                            <xsl:attribute name="aria-controls"><xsl:value-of select="generate-id()"/></xsl:attribute>
                            
                            <xsl:element name="small"><xsl:text>Translation</xsl:text></xsl:element>
                            <!-- need to add the language -->
                        </xsl:element>
                        <xsl:element name="div">
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id()"/>
                            </xsl:attribute>
                            <xsl:attribute name="class">collapse</xsl:attribute>
                            <xsl:element name="div">
                                <xsl:attribute name="class">card card-body border-dark</xsl:attribute>
                                <xsl:call-template name="tpl-translation">
                                    <xsl:with-param name="textpart-id" select="@xml:id"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element> 
                </xsl:if>
        </xsl:element>
            </xsl:element>
                <xsl:element name="div">
                    <xsl:attribute name="class">col-2 apparat-col text-right</xsl:attribute>
                </xsl:element>
        </xsl:element></xsl:if>
    </xsl:template>
    
    <!--  pb ! -->
    <xsl:template match="tei:pb">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:lem|ancestor-or-self::tei:rdg"/>
            <xsl:otherwise>
                <xsl:element name="span">
            <xsl:attribute name="class">text-muted foliation</xsl:attribute>
                <!--<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                <xsl:attribute name="data-placement">top</xsl:attribute>
                <xsl:attribute name="title"><xsl:value-of select="substring-after(@edRef, '#')"/></xsl:attribute>-->
            <!--<xsl:call-template name="tokenize-witness-list">
                <xsl:with-param name="string" select="@edRef"/>
            </xsl:call-template>-->
              <xsl:value-of select="substring-after(@edRef, '#')"/>
                    <xsl:text>:</xsl:text>
                <xsl:value-of select="@n"/>
        </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
    <!--  pc ! -->
    <xsl:template match="tei:pc">
        <xsl:element name="span">
            <xsl:attribute name="class">danda</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- ptr -->
    <xsl:template match="tei:ptr[not(parent::tei:bibl)]">
        <xsl:variable name="MSlink" select="@target"/>
        <xsl:element name="span">
            <xsl:attribute name="class">ref-siglum</xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains($MSlink, ' ')">
                    <xsl:variable name="first-item"
                        select="normalize-space(substring-before($MSlink, ' '))"/>
                    <xsl:if test="$first-item">
                        <xsl:call-template name="content-ptr">
                            <xsl:with-param name="MSlink" select="$first-item"/>
                        </xsl:call-template>
                        <xsl:call-template name="content-ptr">
                            <xsl:with-param name="MSlink" select="substring-after($MSlink, ' ')"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="content-ptr">
                          <xsl:with-param name="MSlink" select="$MSlink"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="content-ptr">
        <xsl:param name="MSlink"/>
        <xsl:variable name="rootId" select="//tei:TEI/@xml:id"/>
        <xsl:variable name="rootHand" select="//tei:handDesc"/>
        <xsl:variable name="IdListTexts">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_idListTexts_v01.xml</xsl:variable>
               <xsl:choose>
                   <xsl:when test="contains($MSlink, 'txt:')">
                       <xsl:variable name="MSlink-part" select="substring-after($MSlink, 'txt:')"/>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink-part]/child::tei:ptr[1]/@target"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink-part]/child::tei:abbr[@type='siglum']"/>
                        </xsl:element>
                    </xsl:when>
                   <xsl:when test="contains($MSlink, 'bib:')">
                       <xsl:call-template name="source-siglum">
                           <xsl:with-param name="string-to-siglum" select="$MSlink"/>
                       </xsl:call-template>
                   </xsl:when>
                   <xsl:when test="contains($MSlink, $rootId)">
                       <xsl:variable name="MSlink-id" select="substring-after($MSlink, '#')"/>
                       <xsl:element name="a">
                           <xsl:attribute name="href">
                               <xsl:value-of select="$MSlink"/>
                           </xsl:attribute>
                           <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                           <xsl:choose>
                               <xsl:when test="//tei:*[@xml:id =$MSlink-id]/@type">
                                   <xsl:value-of select="//tei:*[@xml:id =$MSlink-id]/@type"/>
                               </xsl:when>
                               <xsl:otherwise>
                                   <xsl:value-of select="//tei:*[@xml:id =$MSlink-id]/name()"/>                               
                               </xsl:otherwise>
                           </xsl:choose>
                           <xsl:text> </xsl:text>
                           <xsl:value-of select="//tei:*[@xml:id =$MSlink-id]/@n"/>
                       </xsl:element>
                   </xsl:when>
                   <xsl:when test="contains($MSlink, '_')">
                       <xsl:variable name="hand-id" select="substring-after($MSlink, '#')"/>
                       <xsl:apply-templates select="$rootHand/tei:handNote[@xml:id = $hand-id]/tei:abbr"/>
                    </xsl:when>
                   <xsl:otherwise>
                       <xsl:element name="span">
                           <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                       <xsl:call-template name="tokenize-witness-list">
                           <xsl:with-param name="string" select="$MSlink"/>
                       </xsl:call-template>
                       </xsl:element>
                   </xsl:otherwise>
                </xsl:choose>
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
            <xsl:when test="tei:quote[@type = 'base-text']">
                <xsl:element name="div">
            <xsl:attribute name="class">basetext</xsl:attribute>
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    </xsl:if>
            <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="tei:quote[descendant::tei:listApp]">
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
    <!--  seg ! -->
    <xsl:template match="tei:seg">
        <xsl:choose>
            <xsl:when test="@type='highlight'">
                <xsl:element name="span">
            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
            </xsl:when>
            <xsl:when test="@type='interpolation'">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
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
        </xsl:choose>
    </xsl:template>
    
    <!-- span ! -->
<!--    <xsl:template match="tei:span">
        <xsl:choose>
        <xsl:when test="@type='omissionEnd'">
                <xsl:text>...]</xsl:text>
            </xsl:when>
            <xsl:when test="@type='omissionStart'">
                <xsl:text>[...</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    
    <xsl:template match="tei:span[@type='omissionStart']" mode="omission-number">
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="self::tei:span[@type='omissionStart']">
                <xsl:element name="a">
                    <xsl:attribute name="class">lem-omissionStart move-to-right</xsl:attribute>
                    <!--<xsl:attribute name="tabindex">0</xsl:attribute>-->
                    <xsl:attribute name="data-toggle">popover</xsl:attribute>
                    <xsl:attribute name="data-html">true</xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:text>from-app-</xsl:text>
                        <xsl:value-of select="$app-num"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-target">
                        <xsl:value-of select="generate-id()"/>
                    </xsl:attribute>
                    <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                        <xsl:value-of select="$app-num"/></xsl:attribute>
                    <xsl:attribute name="title">Apparatus <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'])] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] | .//tei:span[@type='omissionStart']"/></xsl:attribute>
                    
                    <xsl:text>(</xsl:text>
                    <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'])] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] | .//tei:span[@type='omissionStart'] "/>
                    <xsl:text>)</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="omission-content">
        <xsl:if test="self::tei:span[@type='omissionStart']">
                    <xsl:element name="span">
                        <xsl:attribute name="class">fake-lem</xsl:attribute>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/preceding::tei:lem[1]"/>
                        <xsl:text>&#8230;</xsl:text>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/following::tei:span[@type='omissionEnd'][1]/preceding::tei:lem[1]"/>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:text>]</xsl:text>
                        </xsl:element> 
                        <xsl:text> an omission</xsl:text> 
                        <xsl:if test="self::tei:span[@type='omissionStart']/parent::tei:rdg/@cause">
                            <xsl:text> due to </xsl:text>
                            <xsl:value-of select="self::tei:span[@type='omissionStart']/parent::tei:rdg/@cause"/>
                        </xsl:if>
                        <xsl:text> intervenes in </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:call-template name="tokenize-witness-list">
                            <xsl:with-param name="string" select="self::tei:span[@type='omissionStart']/parent::tei:rdg/@wit"/>
                        </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <!-- span - modals -->
    <xsl:template match="tei:span[@type='omissionStart']" mode="modals">
        <xsl:variable name="apparatus-omission">
            <xsl:element name="span">
                <xsl:element name="span">
                    <xsl:attribute name="class">mb-1 lemma-line</xsl:attribute>
                    <xsl:element name="span">
                        <xsl:attribute name="class">fake-lem</xsl:attribute>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/preceding::tei:lem[1]"/>
                        <xsl:text>&#8230;</xsl:text>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/following::tei:span[@type='omissionEnd'][1]/preceding::tei:lem[1]"/>
                    </xsl:element>
                    <hr/>
                        <xsl:element name="span">
                            <xsl:attribute name="class">note-line</xsl:attribute>
                            <xsl:attribute name="style">color:black;</xsl:attribute>
                        <xsl:text>An omission</xsl:text> 
                        <xsl:if test="self::tei:span[@type='omissionStart']/parent::tei:rdg/@cause">
                            <xsl:text> due to </xsl:text>
                            <xsl:value-of select="self::tei:span[@type='omissionStart']/parent::tei:rdg/@cause"/>
                        </xsl:if>
                        <xsl:text> intervenes in </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="self::tei:span[@type='omissionStart']/parent::tei:rdg/@wit"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                </xsl:element>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-omission"/>
        </span>      
    </xsl:template>
    
    <!--  subst ! -->
    <xsl:template match="tei:subst">
            <xsl:element name="span">
                <xsl:attribute name="class">ed-insertion</xsl:attribute>
                <xsl:apply-templates select="child::tei:del"/>
                <xsl:value-of select="child::tei:add"/>
            </xsl:element>
    </xsl:template>
    
    <!--  supplied ! -->
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:attribute name="class">text-muted supplied</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
            <xsl:attribute name="data-placement">top</xsl:attribute>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@reason='unknown'">
                        <xsl:element name="span">
                            <xsl:attribute name="class">subaudible</xsl:attribute>
                            <xsl:text>Text to be supplied unknown to editor.</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>Supplied by the editor.</xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@reason='omitted' and not(child::tei:lg)">
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
                    <xsl:choose>  
                        <xsl:when test="not(parent::tei:quote[@type='base-text'])">
                                    <xsl:element name="span">
                                <xsl:attribute name="class">subaudible</xsl:attribute>
                                <xsl:apply-templates/>
                                <xsl:if test="@cert='low'">
                                    <xsl:text>?</xsl:text>
                                </xsl:if>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="span">
                                <xsl:attribute name="class">text-muted</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
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
                <xsl:when test="@reason='unknown'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">subaudible</xsl:attribute>
                        <xsl:text> </xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
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
                <xsl:when test="ancestor-or-self::tei:teiHeader">
                    <xsl:apply-templates/>
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
        <xsl:param name="witdetail-text"/>
        <xsl:choose>
            <xsl:when test="contains($string, ' ')">
                <xsl:variable name="first-item"
                    select="translate(normalize-space(substring-before($string, ' ')), '#', '')"/>
                <xsl:if test="$first-item">
                    <xsl:call-template name="make-bibl-link">
                        <xsl:with-param name="target" select="$first-item"/>
                        <xsl:with-param name="witdetail-string" select="translate($witdetail-string, '#', '')"/>
                        <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                        <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
                    </xsl:call-template>
                    <xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="substring-after($string, ' ')"/>
                        <xsl:with-param name="witdetail-string" select="$witdetail-string"/>
                        <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                        <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
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
                            <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
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
        <xsl:param name="witdetail-text"/>
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
                <xsl:choose>
                    <xsl:when test="$witdetail-text != ''">
                        <xsl:value-of select="$witdetail-text"/>
                    </xsl:when>
                    <xsl:otherwise>
                    <xsl:value-of select="$witdetail-type"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        
    </xsl:template>
    
    <!-- Identity template -->
    <xsl:template match="@* | text() | comment()">
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
                
                <!-- scrollbar CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                
                <!-- site-specific css !-->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/dharma-ms.css"/>
                <!--<link rel="stylesheet" href="./../criticalEditions/dharma-ms.css"></link>-->
                <!--<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Serif"/>-->
                
                <!-- Font Awesome JS -->
                <script src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
                <script src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js" integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY" crossorigin="anonymous"></script>
                
            </meta>
        </head>
    </xsl:template>
    
    <!-- DHARMA html JS scripts  -->
    <xsl:template name="dharma-script">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
        <!-- Popper.JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"/>
        <!-- Bootstrap JS -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"/>
        <!-- jQuery Custom Scroller CDN -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        
        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/loader.js"/>
        <!--<script src="./../criticalEditions/loader.js"></script>-->
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
            <xsl:for-each select="//tei:div[not(ancestor::tei:div)]">
                <xsl:element name="li">
                    <xsl:attribute name="class">nav-item</xsl:attribute>
                    <xsl:element name="a">
                        <xsl:attribute name="class">nav-link</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@type">
                                <xsl:value-of select="@type"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="child::tei:ab[1]">
                                        <xsl:value-of select="child::tei:ab/@type"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="name()"/>  
                                    </xsl:otherwise>
                                </xsl:choose>                     
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@n"/>
                    </xsl:element>
                    <xsl:if test="descendant::tei:div">
                        <xsl:element name="ul">
                            <xsl:attribute name="class">navbar-nav nav-second</xsl:attribute>
                    <xsl:for-each select="descendant::tei:div">
                        
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item-second nav-item</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link-second nav-link</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="@type">
                                        <xsl:value-of select="@type"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="child::tei:ab[1]">
                                                <xsl:value-of select="child::tei:ab/@type"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="name()"/>  
                                            </xsl:otherwise>
                                        </xsl:choose>                     
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@n"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:for-each>
            </xsl:element>
            </xsl:element>
        </xsl:element>
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
                    <li class="nav-item">
                        <a class="nav-link" href="https://erc-dharma.github.io/editorial">Editorial Conventions</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Documentation
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/encoding-diplomatic/DHARMA%20EGD%20v1%20release.pdf">Encoding Guide for Diplomatic editions</a>
                            <a class="dropdown-item" href="critEd_elements">Critical Editions Memo</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/FNC/DHARMA_FNC_v01.1.pdf">File Naming Conventions</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/transliteration/DHARMA%20Transliteration%20Guide%20v3%20release.pdf">Transliteration Guide</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/project-documentation/zotero/DHARMA_ZoteroGuide_v01.1.1.pdf">Zotero Guide</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactControlledVoc">Artefacts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_artefactClosedLists">Artefacts – Closed List</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textControlledVoc">Texts – Controlled Vocabularies</a>
                            <a class="dropdown-item" href="https://erc-dharma.github.io/controlled-vocabularies/DHARMA_mdt_textClosedLists">Texts – Closed List for texts</a>
                            <div class="dropdown-divider"></div>
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
                        <a class="nav-link dropdown-toggle" id="navbarDropdownDoc" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Epigraphical Publications
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="nav-link" href="https://erc-dharma.github.io/arie">ARIE</a>
                            <a class="nav-link" href="https://erc-dharma.github.io/tfb-ec-epigraphy/">Epigraphia Carnatica</a>
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
    
    <!-- Templates for Apparatus at the botton of the page -->
  <xsl:template name="tpl-apparatus">
    <!-- An apparatus is only created if one of the following is true -->
    <xsl:if
        test=".//tei:app[not(parent::tei:listApp[@type='parallels'])]| .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:span[@type='omissionStart']"> <!-- .//tei:choice | .//tei:subst |  -->

        <xsl:element name="div">
            <xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>
            <xsl:element name="h4">Apparatus</xsl:element>
                
      <div id="apparatus">
        <xsl:for-each
            select=".//tei:app[not(parent::tei:listApp[@type='parallels'])]| .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:span[@type='omissionStart']">

          <!-- Found in tpl-apparatus.xsl -->
          <xsl:call-template name="dharma-app">
            <xsl:with-param name="apptype">
              <xsl:choose>
                <xsl:when test="self::tei:app">
                  <xsl:text>app</xsl:text>
                </xsl:when>
                  <xsl:when test="self::tei:note">
                      <xsl:text>note</xsl:text>
                  </xsl:when>
                  <xsl:when test="self::tei:span[@type='omissionStart']">
                      <xsl:text>omission</xsl:text>
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
        
        <xsl:if test="not((local-name() = 'choice' or local-name() = 'subst')
            and (ancestor::tei:choice or ancestor::tei:subst))">
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
            <xsl:if test="$location = 'bottom'">
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
                    <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'])] | //tei:note[last()][parent::tei:p or parent::tei:lg] | //tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] | .//tei:span[@type='omissionStart']"/>
                </a>
            </xsl:if>
        <xsl:if test="$location = 'apparatus'">
            <xsl:element name="a">
                <xsl:attribute name="class">
                    <xsl:text>move-to-right</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-toggle">popover</xsl:attribute>
                <xsl:attribute name="data-html">true</xsl:attribute>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                    <xsl:value-of select="$app-num"/></xsl:attribute>
                <xsl:attribute name="title">Apparatus <xsl:number level="any" count=" //tei:app[not(parent::tei:listApp[@type='parallels'])]| .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] |.//tei:span[@type='omissionStart']"></xsl:number></xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>from-app-</xsl:text>
                    <xsl:value-of select="$app-num"/>
                </xsl:attribute>
                <xsl:attribute name="data-app">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:text>(</xsl:text>
                <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'])] | .//tei:note[last()][parent::tei:p or parent::tei:lg] | .//tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]| .//tei:span[@type='omissionStart']"/>
                <xsl:text>)</xsl:text>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$location = 'text'"/>
    </xsl:template>

    <xsl:template name="dharma-app">
        <xsl:param name="apptype"/>
       <xsl:variable name="childtype">
            <xsl:choose>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice[child::tei:orig and child::tei:reg]">
                    <xsl:text>origreg</xsl:text>
                </xsl:when>
                <!--<xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice[child::tei:sic and child::tei:corr]">
                    <xsl:text>siccorr</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:subst">
                    <xsl:text>subst</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:app">
                    <xsl:text>app</xsl:text>
                </xsl:when>-->
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
            <xsl:when test="not(ancestor::tei:choice or ancestor::tei:subst) or //tei:note[last()][parent::tei:p or parent::tei:lg] ">
                <!-- either <br/> in htm-tpl-apparatus or \r\n in txt-tpl-apparatus -->
                <xsl:call-template name="lbrk-app"/>
                <!-- in htm-tpl-apparatus.xsl or txt-tpl-apparatus.xsl -->
                <xsl:call-template name="app-link">
                    <xsl:with-param name="location" select="'bottom'"/>
                </xsl:call-template>
                <xsl:value-of select="$div-loc"/>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>:&#x202F;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="span">  
            <xsl:attribute name="class">app</xsl:attribute>
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
              <xsl:call-template name="appcontent">
                <xsl:with-param name="apptype" select="$apptype"/>
                <xsl:with-param name="childtype" select="$childtype" />
            </xsl:call-template>
              </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
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
               <xsl:when test="$childtype='appEm'">
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
                   <xsl:with-param name="parent-lang"><xsl:value-of select="$parent-lang" /></xsl:with-param>
                </xsl:call-template>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="appchoice">
        <xsl:param name="apptype" />
       <xsl:param name="child" />
        <xsl:param name="path" />
       <xsl:param name="parent-lang"/>
        <xsl:choose>
            <xsl:when test="$apptype='app'">
                <!-- **ALT - <xsl:value-of select="$path/tei:rdg"/>** -->
                <xsl:for-each select="tei:lem">
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:text>bottom-lemma-reading</xsl:text>
                            <xsl:if test="not($path/tei:lem/following-sibling::tei:note[@type='altLem'])">
                                <xsl:call-template name="lem-type"/>
                            </xsl:if></xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$path/tei:lem/following-sibling::tei:note[@type='altLem']">
                                <xsl:apply-templates select="replace($path/tei:lem/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$path/tei:lem"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:text>] </xsl:text>
                    </xsl:element>                
                    <xsl:if test="@*">
                            <xsl:if test="@type">
                                <xsl:element name="span">
                                    <xsl:attribute name="class">font-italic</xsl:attribute>
                                    <xsl:call-template name="apparatus-type"/>
                                </xsl:element>
                                <xsl:if test="attribute::wit or attribute::source">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:if>
                            
                        <xsl:if test="@wit">
                            <xsl:if test="@type='absent_elsewhere'">
                                <xsl:text>only in </xsl:text>
                                </xsl:if>
                            <xsl:if test="@type='reformulated_elsewhere'">
                                <xsl:text>Thus formulated in </xsl:text>
                            </xsl:if>
                              <xsl:element name="span">
                                  <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                    </xsl:call-template>
                                  <xsl:if test="@varSeq">
                                      <xsl:choose>
                                          <xsl:when test="@varSeq='1'">
                                              <xsl:element name="sub">
                                                  <xsl:text>ac</xsl:text>
                                              </xsl:element>
                                          </xsl:when>
                                          <xsl:when test="@varSeq='2'">
                                              <xsl:element name="sub">
                                                  <xsl:text>pc</xsl:text>
                                              </xsl:element>
                                          </xsl:when>
                                      </xsl:choose>
                                  </xsl:if>
                                </xsl:element>
                            </xsl:if>
                        <xsl:if test="@source">
                                <xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="@source"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                    <xsl:if test="$path/tei:lem[following-sibling::tei:rdg and not(@type='absent_elsewhere')]">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                
                <xsl:for-each select="tei:rdg">
                    <xsl:element name="span">
                        <xsl:attribute name="class">bottom-reading-line<xsl:choose><xsl:when test="descendant-or-self::tei:lacunaStart"><xsl:text> bottom-lacunaStart</xsl:text></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionStart']"> bottom-omissionStart</xsl:when><xsl:when test="descendant-or-self::tei:lacunaEnd"><xsl:text> bottom-lacunaEnd</xsl:text></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionEnd']"> bottom-omissionEnd</xsl:when></xsl:choose>
                        </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*[local-name()='lem'][1]/@type='absent_elsewhere'"/>
                        <xsl:otherwise>
                            <xsl:if test="position()!=1">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                   
                    <xsl:choose>
                        <xsl:when test="child::tei:pb"/>
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
                        <xsl:when test="child::tei:lacunaEnd or child::tei:span[@type='omissionEnd']">...]</xsl:when>
                       
                    </xsl:choose>
                    
                    <xsl:apply-templates/>
                            <xsl:choose>
                                <xsl:when test="child::tei:lacunaStart or child::tei:span[@type='omissionStart']">[...</xsl:when> 
                            </xsl:choose>
              
                    <xsl:if test="@*">
                        <xsl:if test="@wit">                       
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail'] or @varSeq"> supsub</xsl:if></xsl:attribute>
                                <xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="@wit"/>
                                    <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                    <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                    <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                </xsl:call-template>
                                <xsl:if test="@varSeq">
                                    <xsl:choose>
                                        <xsl:when test="@varSeq='1'">
                                            <xsl:element name="sub">
                                                <xsl:text>ac</xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="@varSeq='2'">
                                            <xsl:element name="sub">
                                                <xsl:text>pc</xsl:text>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                            <xsl:if test="@source">
                                <xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="@source"/>
                                </xsl:call-template>
                            </xsl:if>
                        <xsl:if test="./@cause">
                            <xsl:element name="span">
                                <xsl:attribute name="style">color:black;</xsl:attribute>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="replace(@cause, '_', ' ')"/>
                                <xsl:text>)</xsl:text>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                          
                    </xsl:otherwise>
                    </xsl:choose>                   
                    <xsl:if test="@type='paradosis'">
                        <xsl:text> • </xsl:text>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">paradosis-line</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">font-italic</xsl:attribute>
                                        <xsl:text>Paradosis</xsl:text>
                                    </xsl:element>
                                    <xsl:text> of </xsl:text>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                    </xsl:call-template>
                                    <xsl:text>: </xsl:text>                            
                                    <xsl:apply-templates/>
                                </xsl:element>
                    </xsl:if>
                    </xsl:element>
                </xsl:for-each>
                
                    <xsl:for-each select="tei:rdg/following-sibling::tei:note"><xsl:element name="span">
                            <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                            <xsl:text> • </xsl:text>
                            <xsl:apply-templates/>
                    </xsl:element>
                    </xsl:for-each>
                
                <xsl:if test="not(tei:rdg) and tei:lem/following-sibling::tei:note">
                    <xsl:text> • </xsl:text>
                    <xsl:element name="span">
                        <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                        <xsl:apply-templates select="tei:lem/following-sibling::tei:note"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
                <!--<xsl:when test="$child=('appalt') or $apptype=('appalt')">
                    <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                        <xsl:with-param name="location" select="'text'"/>
                    </xsl:apply-templates>
                </xsl:when>-->
            <xsl:when test="$apptype='note'">
                <xsl:for-each select="$path/tei:note">
                <xsl:element name="span">
                    <xsl:attribute name="class">bottom-note-line</xsl:attribute>
                    <xsl:apply-templates select="$path/tei:note"/>
                </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$apptype='omission'">
                <xsl:call-template name="omission-content"/>
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
                    <xsl:for-each select="descendant-or-self::tei:app">             
                        <xsl:if test="@type">
                            <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                        <xsl:value-of select="@type"/>
                        </xsl:element>
                        </xsl:if>
        <xsl:element name="ul">
            <xsl:attribute name="class">list-unstyled</xsl:attribute>
            <xsl:if test="descendant-or-self::tei:lem">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                    <xsl:apply-templates select="descendant-or-self::tei:lem"/>
                </xsl:element>
            </xsl:if>
            <xsl:for-each select="descendant-or-self::tei:note">
                <xsl:element name="li">
                    <xsl:attribute name="class">text-muted</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@* except @type">
                            <xsl:variable name="soughtMS" select="substring-before(substring-after(@* except @xml:lang, 'txt:'), '_')"/>
                            <xsl:variable name="refMS" select="substring-after(@* except @xml:lang, '_')"/>
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
                                    <xsl:value-of select="replace(descendant-or-self::tei:note/@* except @xml:lang, 'txt:', '')"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="span">
                                <xsl:attribute name="class">parallel-text</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="@type='unknown'">
                            <xsl:element name="span">
                                <xsl:attribute name="class">parallel-text</xsl:attribute>
                            <xsl:text>No text has been identified by the editor.</xsl:text></xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="span">
                                <xsl:attribute name="class">parallel-text</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
                    </xsl:for-each>
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
                        <xsl:for-each select="//tei:title[@type='main']">
                            <xsl:text>The </xsl:text>
                            <xsl:element name="span">
                                <xsl:attribute name="class">font-italic</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:for-each>
                        <xsl:if test="//tei:title[@type='alt']">
                            <xsl:text> or ‘</xsl:text>
                        <xsl:apply-templates select="//tei:title[@type='alt']"/>
                        <xsl:text>’</xsl:text>
                        </xsl:if>
                        <xsl:if test="//tei:title[@type='sub']">
                            <xsl:text>. </xsl:text>
                            <xsl:apply-templates select="//tei:title[@type='sub']"/>
                        </xsl:if>
                    </xsl:element>
                <xsl:element name="li">
                    <xsl:element name="b">
                        <xsl:text>Text Identifier</xsl:text>
                    </xsl:element>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="//tei:idno[@type='filename']"/>
                </xsl:element>
                    <xsl:element name="li">
                        <xsl:for-each select="//tei:titleStmt/tei:editor">
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
                            <xsl:apply-templates select="normalize-space(.)"/>
                        </xsl:for-each>
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
    
<xsl:template name="fake-lem-making">
    <xsl:choose>
        <xsl:when test="parent::tei:p">
            <xsl:value-of select="substring-before(parent::tei:p, ' ')"/>       
            <xsl:text> [&#8230;] </xsl:text>
            <xsl:choose>
                <xsl:when test="parent::tei:p/tei:*[last()-1]/not(text())">
                    <xsl:choose>
                        <xsl:when test="parent::tei:p/tei:*[last()-1][local-name() ='app']">
                            <xsl:apply-templates select="parent::tei:p/tei:*[last()-1]/tei:lem"/>
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
        <xsl:when test="parent::tei:ab">
            <xsl:value-of select="."/>
        </xsl:when>
    </xsl:choose>
</xsl:template>
    
    <!-- tpl-translation -->
    <xsl:template name="tpl-translation">
        <xsl:param name="textpart-id"/>
        <!-- https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/ -->
        <xsl:variable name="filename">
            <xsl:value-of select="//tei:idno[@type='filename']"/>
        </xsl:variable>
        <xsl:variable name="document-trans">
            <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename, '_transEng01.xml')"/>
        </xsl:variable>
        <xsl:element name="div">
            <!--<xsl:attribute name="class">mx-5 mt-3 mb-4</xsl:attribute>-->
            <xsl:choose>
                <xsl:when test="document($document-trans)//tei:*[substring-after(@corresp, '#') = $textpart-id]">
                    <xsl:apply-templates select="document($document-trans)//tei:*[substring-after(@corresp, '#') = $textpart-id]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="p">
                        <xsl:attribute name="class">textContent</xsl:attribute>
                        <xsl:text>No translation available yet for this part of the edition </xsl:text>
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
    
    <!-- tpl-com -->
    <xsl:template name="tpl-com">
        <xsl:variable name="filename">
            <xsl:value-of select="//tei:idno[@type='filename']"/>
        </xsl:variable>
        <xsl:variable name="document-com">git
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename, '_com.xml')"/>
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
                    <xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename, '_biblio.xml')"/>
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
    
    <xsl:template name="scansion">
        <xsl:param name="met-string"/>
        <xsl:param name="string-len"/>
        <xsl:param name="string-pos"/>
        <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
        <xsl:if test="$string-pos > -1">     
            <xsl:text>&#xa0;</xsl:text>
            <xsl:value-of select="substring($met-string, number($string-len - $string-pos), 1)"/>
            <xsl:text>&#xa0;</xsl:text>
            <xsl:call-template name="scansion">
                <xsl:with-param name="met-string" select="$met-string"/>
                <xsl:with-param name="string-len" select="$string-len"/>
                <xsl:with-param name="string-pos" select="$string-pos - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
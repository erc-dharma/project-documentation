<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="html" indent="no" encoding="UTF-8"/>
    
    <!-- Written by Axelle Janiak for DHARMA, starting mai 2023 -->
    
    <!--  B ! -->
    <xsl:template match="tei:bibl">
        <xsl:choose>
            <xsl:when test=".[tei:ptr]">
                <xsl:variable name="biblentry" select="replace(substring-after(./tei:ptr/@target, 'bib:'), '\+', '%2B')"/>
                <xsl:variable name="zoteroStyle">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/bibliography/DHARMA_modified-Chicago-Author-Date_v01.csl</xsl:variable>
                <xsl:variable name="zoteroomitname">
                    <xsl:value-of
                        select="unparsed-text(replace(concat('http://195.154.222.146:8024/groups/1633743/items?tag=', $biblentry, '&amp;format=json'), 'amp;', ''))"
                    />
                </xsl:variable>
                <xsl:variable name="zoteroapitei">
                    <xsl:value-of
                        select="replace(concat('http://195.154.222.146:8024/groups/1633743/items?tag=', $biblentry, '&amp;format=tei'), 'amp;', '')"/>
                </xsl:variable>
                <xsl:variable name="zoteroapijson">
                    <xsl:value-of
                        select="replace(concat('http://195.154.222.146:8024/groups/1633743/items?tag=', $biblentry, '&amp;format=json&amp;style=',$zoteroStyle,'&amp;include=citation'), 'amp;', '')"/>
                </xsl:variable>
                <xsl:variable name="unparsedtext" select="unparsed-text($zoteroapijson)"/>
                <xsl:variable name="pointerurl">
                    <xsl:value-of select="document($zoteroapitei)//tei:idno[@type = 'url']"/>
                </xsl:variable>
                <xsl:variable name="bibwitness">
                    <xsl:value-of select="replace(concat('http://195.154.222.146:8024/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=', $zoteroStyle), 'amp;', '')"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="ancestor::tei:p or ancestor::tei:note">
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
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of
                            select="document(replace(concat('http://195.154.222.146:8024/groups/1633743/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$zoteroStyle), 'amp;', ''))/div"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- if there is no ptr, print simply what is inside bibl and a warning message-->
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- div -->
    <xsl:template match="tei:div[@xml:id]"> 
            <xsl:element name="div">
                <xsl:attribute name="class">row justify-content</xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">col-2 font-weight-bold</xsl:attribute>
                    <xsl:value-of select="replace(@xml:id, '_', ' ')"/>
                </xsl:element>
                <xsl:element name="div">
                    <xsl:attribute name="class">col-10</xsl:attribute>
                        <xsl:apply-templates/>
                        <xsl:choose>
                            <xsl:when test="not(following::*[1][local-name() = ('div')][@xml:id])">
                                <br/>
                            </xsl:when>
                            <xsl:otherwise>
                                <hr/>
                            </xsl:otherwise>
                        </xsl:choose>
                    
                </xsl:element>
            </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:div[@type][not(@type='occurences' or @type='text')]">

                <xsl:element name="div">
                    
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute> 
                        <xsl:call-template name="langague"/>
                        <xsl:choose>                            
                            <xsl:when test="@type='inscriptions'">
                                <xsl:text>Inscriptions</xsl:text> 
                            </xsl:when>  
                            <xsl:when test="@type='notes'">
                                <xsl:text>Sircar's notes</xsl:text> 
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(upper-case(substring(@type,1,1)), substring(@type, 2),' '[not(last())] )"/>
                             </xsl:otherwise>
                        </xsl:choose>
                        </xsl:element>
                    
                    <br/>
                    <xsl:choose>
                        <xsl:when test="@type='inscriptions'">
                            <xsl:element name="p">
                                <xsl:text>Appart for the spelling differences, this stanza identically appears in : </xsl:text>
                                
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="(@type='purāṇas' or @type='dharmaśāśtras')">
                            <p>This stanza occurs in : </p>
                            
                        </xsl:when>
                        <xsl:when test="@type='variation'">
                            <p>This stanza appears with the following modifications here:</p>
                        </xsl:when>
                        <xsl:when test="@type='authorship'">
                            <p>The authorship of this stanza is attributed to the following sources:</p>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::text() = ''">
                            <p>No data currently available</p>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
        </xsl:element>
            
    </xsl:template>
    
    <!--  foreign ! -->
    <xsl:template match="tei:foreign">
        <xsl:element name="span">
            <xsl:attribute name="class">font-italic</xsl:attribute>
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
            <xsl:when test="@rend='bold'">
                <xsl:element name="span">
                    <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:l">
           
            <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>l</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
    <!--  lg ! -->
    <xsl:template match="tei:lg">
        <xsl:element name="p">
            <xsl:attribute name="class">float-center</xsl:attribute>
            
                <xsl:element name="span">
                    <xsl:attribute name="class">font-weight-bold</xsl:attribute>                 
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
                </xsl:element>
            
        </xsl:element>
        
            <xsl:element name="div">
                <xsl:attribute name="class">text-col</xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">
                        <xsl:text>lg</xsl:text>
                    </xsl:attribute>
                        <xsl:apply-templates/>
                </xsl:element>
                <br></br>
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
    
    <!--  listBibl -->
    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
    <!-- p -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
           
                <xsl:if test="@rend='stanza'"> 
                        <xsl:choose>
                            <xsl:when test="@n='1' and not(following-sibling::tei:*)"/>
                            <xsl:when test="matches(@n, '[rv]+')">
                                <xsl:element name="div">
                                    <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
                                    <xsl:value-of select="@n"/>
                                </xsl:element>
                            </xsl:when>
                            <!--<xsl:when test="count(@n) &gt;= 2">-->
                            <xsl:when test="matches(@n, ',')">
                                <xsl:element name="div">
                                    <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
                                    <xsl:number value="substring-before(@n, ',')" format="I"/>
                                    <xsl:text>, </xsl:text>
                                    <xsl:number value="substring-after(@n, ',')" format="I"/>
                                    <xsl:text>. </xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="matches(@n, '-')">
                                <xsl:element name="div">
                                    <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
                                    <xsl:number value="substring-before(@n, '-')" format="I"/>
                                    <xsl:text>, </xsl:text>
                                    <xsl:number value="substring-after(@n, '-')" format="I"/>
                                    <xsl:text>. </xsl:text>
                                </xsl:element>
                            </xsl:when>
                            
                            <!-- deleting the default since Amandine 's hasn't added any @n -->
                           <!-- <xsl:otherwise>
                                <xsl:element name="div">
                                    <xsl:attribute name="class">translated-stanzanumber</xsl:attribute>
                                    <xsl:number value="@n" format="I"/><xsl:text>. </xsl:text>
                                </xsl:element>
                            </xsl:otherwise>-->
                
            </xsl:choose>
                </xsl:if>
                <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- ref -->
        <!--  -->
        <xsl:template match="tei:text//tei:ref">
            <xsl:variable name="url-somavamsin" select="'https://erc-dharma.github.io/tfb-somavamsin-epigraphy/workflow-output/html/'"/>
            <xsl:variable name="url-bengalCharters" select="'https://erc-dharma.github.io/tfb-bengalcharters-epigraphy/workflow-output/html/'"/>
            <xsl:variable name="url-maitraka" select="'https://erc-dharma.github.io/tfb-maitraka-epigraphy/workflow-output/html/'"/>
            <xsl:variable name="url-pallava" select="'https://erc-dharma.github.io/tfa-pallava-epigraphy/texts/htmloutput/'"/>
            <xsl:element name="a">
                <xsl:attribute name="class">ref</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <!-- link to the epigraphy -->
                        <xsl:when test="matches(@target, 'Somavamsin')">
                            <xsl:value-of select="concat($url-somavamsin , @target)"/>
                        </xsl:when>
                        <xsl:when test="matches(@target, 'BengalCharters')">
                            <xsl:value-of select="concat($url-bengalCharters , @target)"/>
                        </xsl:when>
                        <xsl:when test="matches(@target, 'Maitraka')">
                            <xsl:value-of select="concat($url-maitraka , @target)"/>
                        </xsl:when>
                        <xsl:when test="matches(@target, 'Pallava')">
                            <xsl:value-of select="concat($url-pallava , @target)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@target"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
    <!-- teiHeader -->
    <xsl:template match="tei:teiHeader"/>
    
    <xsl:template match="tei:text">
        <xsl:element name="html">
            <xsl:call-template name="dharma-head"/>
            <xsl:element name="body">
                <xsl:attribute name="class">font-weight-light</xsl:attribute>
                <xsl:attribute name="data-spy">scroll</xsl:attribute>
                <xsl:attribute name="data-target">#myScrollspy</xsl:attribute>
                <xsl:call-template name="nav-bar"/>
                <xsl:call-template name="table-contents"/>
                <a class="btn btn-info" data-toggle="collapse" href="#sidebar-wrapper" role="button" aria-expanded="false" aria-controls="sidebar-wrapper" id="toggle-table-contents">☰ Index</a>
                <xsl:element name="div">
                    <xsl:attribute name="class">container</xsl:attribute>
                    <xsl:element name="h1">
                        <xsl:attribute name="class">text-center</xsl:attribute>
                        <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title"/>
                    </xsl:element>
                    <xsl:element name="h2">
                        <xsl:attribute name="class">text-center</xsl:attribute>
                        <xsl:text>by </xsl:text>
                        <xsl:if test="//tei:fileDesc/tei:titleStmt/tei:editor">
                            
                            <xsl:apply-templates select="//tei:fileDesc/tei:titleStmt/tei:editor"/>
                        </xsl:if> 
                    </xsl:element>
                    <xsl:apply-templates/>
                    <xsl:element name="footer">
                        <xsl:attribute name="class">footer mt-auto py-3</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:text>© DHARMA (2023-2025).</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:call-template name="dharma-script"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Named templates -->
    <xsl:template name="dharma-head">
        <head>
            <title>
                <xsl:value-of select="//tei:titleStmt/tei:title"/>
            </title>
            
            <meta content-type="application/xhtml+xml" content="text/html; charset=UTF-8"></meta>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"></link>
                
                <!-- scrollbar CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"></link>
                
                <!-- site-specific css !-->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/dharma-ms.css"></link>
                <!--<link rel="stylesheet" href="./../criticalEditions/dharma-ms.css"></link>-->
                <!--<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Serif"/>-->
                
                <!-- Font Awesome JS -->
                <script src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
                <script src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js" integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY" crossorigin="anonymous"></script>
                
            </meta>
        </head>
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
                    <xsl:attribute name="class">font-italic</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
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
                            <a class="dropdown-item" href="https://erc-dharma.github.io/#postdoc-collection">Task-Force D</a>
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
    
    <xsl:template name="dharma-script">
        <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
        
        <!-- scrollbar -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
        <!-- loader crit Ed -->
        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@latest/stylesheets/criticalEditions/loader.js"></script>
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
    
    <xsl:template name="langague">
        <xsl:param name="lang"/>
        <xsl:choose>
            <xsl:when test="@xml:lang='eng'"><xsl:text>English </xsl:text></xsl:when>
            <xsl:when test="@xml:lang='fra'"><xsl:text>French </xsl:text></xsl:when>
        </xsl:choose>
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
    
    <!-- side bar -->
    <!-- side bar - table of contents -->
    <xsl:template name="table-contents">
        <xsl:element name="div">
            <xsl:attribute name="id">sidebar-wrapper</xsl:attribute>
            <xsl:attribute name="class">collapse</xsl:attribute>
            <xsl:element name="nav">
                <xsl:attribute name="id">myScrollspy</xsl:attribute>
                <xsl:element name="ul">
                    <xsl:attribute name="class">nav nav-pills flex-column</xsl:attribute>
                    <xsl:for-each select="//tei:div[@xml:id]">
                        <xsl:element name="li">
                            <xsl:attribute name="class">nav-item</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="class">nav-link text-align-justify</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="generate-id()"/>
                                </xsl:attribute>
                               <xsl:value-of select="@xml:id"/>
          
                            </xsl:element>
                            
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
       
</xsl:stylesheet>
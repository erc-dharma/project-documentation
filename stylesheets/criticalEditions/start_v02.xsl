<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    <xsl:output method="html" indent="yes" encoding="UTF-8" version="4.0" use-character-maps="htmlDoc"/>
    
    <!-- Coded initially written by Andrew Ollet, for DHARMA Berlin workshop in septembre 2020 -->
    <!-- Updated and reworked for DHARMA by Axelle Janiak, starting 2021–2023, then april-mai 2025 -->

    <xsl:character-map name="htmlDoc">
        <xsl:output-character character="&apos;" string="&amp;rsquo;" />
    </xsl:character-map>

        <!-- Functions -->
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
    <xsl:function name="functx:substring-before-match" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence select="tokenize($arg,$regex)[1]"/>
    </xsl:function>
    <xsl:function name="functx:sort" as="item()*"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="seq" as="item()*"/>
        <xsl:for-each select="$seq">
            <xsl:sort select="."/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="functx:first-node" as="node()?"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:sequence select="($nodes/.)[1] "/>
    </xsl:function>
    <xsl:function name="functx:trim" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="replace(replace($arg,'\s+$',''),'^\s+','')"/>
    </xsl:function>
    <xsl:function name="functx:repeat" as="item()+">
        <xsl:param name="pThis" as="item()"/>
        <xsl:param name="pTimes" as="xs:integer"/>     
        <xsl:for-each select="1 to $pTimes">
            <xsl:sequence select="$pThis"/>
        </xsl:for-each>
    </xsl:function>

    <!-- Paramètre contexte de développement pour intégration à Dharmalekha-->
    <xsl:variable name="viz-context">
        <xsl:value-of select="'github'"/>
        <!--<xsl:value-of select="'dharmalekha'"/>-->
    </xsl:variable>
    
    <!-- Variables -->
    <!-- $filename; use to generate the link for external files -->
    <xsl:variable name="filename">
        <xsl:value-of select="//tei:idno[@type='filename']"/>
    </xsl:variable>
    
    <!-- uri of the document -->
    <xsl:variable name="fileuri">
        <xsl:value-of select="base-uri(.)"/>
    </xsl:variable>
    
    <!-- repository name -->
    <xsl:variable name="repository-name">
        <xsl:choose>
            <xsl:when test="contains($fileuri, 'tfd-nusantara')">tfd-nusantara-philology</xsl:when>
            <xsl:when test="contains($fileuri, 'tfd-sanskrit')">tfd-sanskrit-philology</xsl:when>
        </xsl:choose> 
    </xsl:variable>
    
    <!-- edition-type -->
    <xsl:variable name="edition-type">
        <xsl:choose>
            <xsl:when test="contains(document-uri(.), 'DiplEd')">
                <xsl:value-of select="'diplomatic'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'critical'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- Language -->
    <xsl:variable name="language">
        <!-- critère un peu verbeux, mais sinon undetermined ne passe pas à la comparaison avec le TSV -->
        <xsl:choose>
            <xsl:when test="contains(/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/@xml:lang, '-')">
                <xsl:value-of select="substring-before(/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/@xml:lang, '-')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/@xml:lang"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:variable>
    
    <!-- variable= chemin vers prosody -->
    <xsl:variable name="prosody" select="document('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_prosodicPatterns_v01.xml')"/>
    
    <!-- varaible = chemin vers les ids des texts -->
    <xsl:variable name="IdListTexts">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_idListTexts_v01.xml</xsl:variable>
    
    <!--  variable = vers le ids des participants du projet-->
    <xsl:variable name="list-members" select="document('https://raw.githubusercontent.com/erc-dharma/project-documentation/refs/heads/master/DHARMA_idListMembers_v01.xml')//tei:listPerson"/>
    
    <!--  variable= chemin vers les langages utilisés dans le project-->
    <xsl:variable name="list-languages">
        <xsl:value-of select="unparsed-text('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_languages.tsv')"/>
    </xsl:variable>
    
    <!-- variable = chemin vers les symboles -->
    <xsl:variable name="list-symbol">
        <xsl:value-of select="unparsed-text('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/gaiji/DHARMA_gaiji.tsv')"/>
    </xsl:variable>
    
    <!-- editions id -->
    <xsl:variable name="edition-id">
        <xsl:value-of select="/tei:TEI/@xml:id"/>
    </xsl:variable>
    
    <!-- main display structure - appelle les templates et les modes-->
    <xsl:template match="/tei:TEI">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <xsl:call-template name="dharma-head"/>
            <body>
                <div id="contents">
                    <xsl:call-template name="header"/>
                    <main>
                        <h1>
                            <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]"/>
                           
                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='alt']">
                                <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='alt']">
                                    <xsl:text> — </xsl:text>
                                <xsl:apply-templates/></xsl:for-each>
                            </xsl:if>
                            <!-- no mention of author -->
                        </h1>
                        <div id="inscription-display">
                            
                            <xsl:apply-templates select="tei:teiHeader/tei:fileDesc"/>
                            <xsl:if test="tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p[2]/text() or tei:teiHeader/tei:encodingDesc/tei:editorialDecl//tei:p/text()"><xsl:apply-templates select="tei:teiHeader/tei:encodingDesc"/></xsl:if>
                            <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc"/>
                            
                            <div class="edition">
                                <h2 id="edition">Edition</h2>

                                        <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='edition']"/>                                                            
                            </div>
                            <!-- condition pour n'afficher que si l'édition contient des app -->
                            <xsl:if test="tei:text/tei:body/tei:div[@type='edition']//descendant::tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide')]"><div class="apparatus">
                                <h2 id="apparatus" class="collapsible">Apparatus <i class="fa-solid fa-angles-down"></i></h2>
                                <div class="collapsible-content">
                                <xsl:call-template name="tpl-apparatus"/>
                                </div>
                            </div></xsl:if>
                            <!-- condition pour n'afficher que si des traductions sont disponibles -->
                            <xsl:if test="tei:text/tei:body/tei:div[@type='translation']//tei:p/text()">
                                <xsl:for-each select="tei:text/tei:body/tei:div[@type='translation']">
                                    <div class="translation">
                                        <h2 id="translation{generate-id()}">Translation<xsl:if test="@xml:lang or @resp or @source"><xsl:call-template name="translation-title">
                                                <xsl:with-param name="language-title" select="@xml:lang"/>
                                                <xsl:with-param name="responsability" select="@resp"/>
                                                <xsl:with-param name="source" select="@source"/>
                                            </xsl:call-template></xsl:if></h2>
                                        <xsl:apply-templates select="."/>
                                    </div>
                                </xsl:for-each>
                            </xsl:if>
                            <!-- condition pour n'afficher que si commentary contient du text -->
                            <xsl:if test="tei:text/tei:body/tei:div[@type='commentary']/tei:p/text()"><div class="commentary">
                                <h2 id="commentary">Commentary</h2>
                                <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='commentary']"/>
                            </div></xsl:if>
                            <!-- condition pour n'afficher que si bibliography contient du text -->
                            <xsl:if test="tei:text/tei:body/tei:div[@type='bibliography']/tei:p/text() or tei:text/tei:body/tei:div[@type='bibliography']/tei:listBibl/tei:bibl/text()">
                                
                            <div class="bibliography">
                                <h2 id="bibliography">Bibliography</h2>
                                <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='bibliography']"/>
                            </div>
                            </xsl:if>
                            <!-- notes pour les translations -->
                            <xsl:if test="tei:text/tei:body/tei:div[@type='translation']/descendant-or-self::tei:note">
                                <div class="notes">
                                    <h2 id="notes">Notes</h2>
                                    <xsl:call-template name="translation-bottom-notes"/>
                                </div>
                            </xsl:if> 
                        </div>  
                        <!-- inscription source -->
                        <!-- tpl incomplet, mais suffisant pour une 1er viz.-->
                        <xsl:call-template name="source-display"/>
                    </main>
                    <!-- app modals -->
                    <xsl:apply-templates select=".//tei:app[not(@rend='hide')] | .//tei:lacunaStart | .//tei:note | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart'] | .//tei:l[@real]" mode="modals"/>
                </div>
                <div id="tip-box" class="hidden">
                    <div id="tip-contents"></div>
                    <div id="tip-arrow"></div>
                </div>
            </body>
            <xsl:call-template name="dharma-script"/>
        </html>
    </xsl:template>
    

    <!--  teiHeader – matching metadata in dharmalekha ! -->
    <xsl:template match="tei:fileDesc">
        <p>Author<xsl:if test="count(tei:titleStmt/tei:respStmt[tei:resp[text()='author of digital edition']]/tei:persName) gt 1">s</xsl:if> of digital edition: 
            <xsl:if test="tei:titleStmt/tei:respStmt/tei:resp[text()='author of digital edition']">
                <xsl:call-template name="editors">
                    <xsl:with-param name="list-editors" select="tei:titleStmt/tei:respStmt[tei:resp[text()='author of digital edition']]/tei:persName"/>
                </xsl:call-template>
            </xsl:if>
        </p>
        <p>
            <xsl:text>Filename: </xsl:text>
            <span class="text-id">
                <xsl:apply-templates select="$filename"/>
            </span>
        </p>
        <p>
            <xsl:text>Language: </xsl:text>
            <xsl:call-template name="language-interpretation">
                <xsl:with-param name="language" select="$language"/>
            </xsl:call-template>
        </p>
        <p>
            <xsl:text>Repository: </xsl:text>
            
               <xsl:choose>
                   <xsl:when test="contains($repository-name, 'tfd-nusantara')">Nusantara Philology <span class="text-id">(<xsl:value-of select="$repository-name"/>)</span></xsl:when>
                   <xsl:when test="contains($repository-name, 'tfd-sanskrit')">Sanskrit Philology <span class="text-id">(<xsl:value-of select="$repository-name"/>)</span></xsl:when>
               </xsl:choose> 
        </p>
        <p>
            <xsl:text>Version:  part commented since without access_token with github actions api calls are limited – still working on it</xsl:text>
            <!--<xsl:call-template name="api-rest-github-history"/>-->
        </p>
    </xsl:template>
   
 <!-- call to api github -->
    <xsl:template name="api-rest-github-history">
        <xsl:variable name="api-github-path" select="concat('https://api.github.com/repos/erc-dharma/', $repository-name,'/commits')"/>
        <xsl:variable name="path-file">
            <xsl:choose>
                <xsl:when test="contains($repository-name, 'tfd-nusantara')">
                    <xsl:value-of select="concat('editions/', $filename )"/>
                </xsl:when>
                <xsl:when test="contains($repository-name, 'tfd-sanskrit')">
                    <xsl:value-of select="concat('editions/texts/xml', $filename )"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
            <xsl:variable name="path-to-blob" select="concat('https://github.com/erc-dharma/', $repository-name, '/blob/')"/>
        <!-- retrieving sha and date for the latest commit on the file-->
        <xsl:variable name="call-to-log-file" select="json-to-xml(unparsed-text(concat($api-github-path, '?path=', $path-file)))//*"/>
        <xsl:variable name="sha-commit-file">
            <xsl:value-of select="$call-to-log-file//*[@key='sha'][1]"/>
        </xsl:variable>
        <!-- récupérer en séquence tous les sha, donc on assume que le premier est le dernier -->
        <xsl:variable name="last-time-file">
            <xsl:value-of select="$call-to-log-file//*[@key='date'][1]"/>
        </xsl:variable>
        <!-- retrieving sha and date for the latest commit on the file-->
        <xsl:variable name="call-to-log-repository" select="json-to-xml(unparsed-text($api-github-path))//*"/>
        <xsl:variable name="sha-commit-repository">
            <xsl:value-of select="$call-to-log-repository//*[@key='sha'][1]"/>
        </xsl:variable>
        <xsl:variable name="last-time-repository">
            <xsl:value-of select="$call-to-log-repository//*[@key='date'][1]"/>
        </xsl:variable>
        <!-- Ajouter le substring-before pour isoler la première valeur de la séquence -->
        <time datetime="{substring-before($last-time-repository, ' ')}"> </time>
        (<xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="concat($path-to-blob, substring-before($sha-commit-repository, ' '))"/></xsl:attribute><span class="commit-hash"><xsl:value-of select="substring($sha-commit-repository,1,7)"/></span>
        </xsl:element>), last modified 
        <time datetime="{substring-before($last-time-file, ' ')}"> </time>
        (<xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="concat($path-to-blob, substring-before($sha-commit-file, ' '), '/', $path-file)"/></xsl:attribute><span class="commit-hash"><xsl:value-of select="substring($sha-commit-file,1,7)"/></span>
        </xsl:element>).
    </xsl:template>
    
    <xsl:template name="translation-title">
        <xsl:param name="language-title"/>
        <xsl:param name="responsability"/>
        <xsl:param name="source"/>
            <xsl:if test="$language-title">
                <xsl:text> into </xsl:text>
                <xsl:call-template name="language-interpretation">
                    <xsl:with-param name="language" select="$language-title"/>
                </xsl:call-template>
            </xsl:if>
        <xsl:if test="$responsability">
            <xsl:text> by </xsl:text>
            <xsl:call-template name="responsability-display">
                <xsl:with-param name="responsability" select="$responsability"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$source">
            <xsl:text> in </xsl:text>
            <xsl:call-template name="bibliography">
                <xsl:with-param name="biblentry" select="substring-after($source, 'bib:')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="responsability-display">
        <xsl:param name="responsability"/>
        <xsl:param name="display-behaviour"/>
        <!-- param pour éviter la redondance de tpl pour établir la différence de traitement attendu dans les noms de familles occidentaux  -->
        <!-- //tei:bibl[@xml:id=$MSlink-part] -->
            <xsl:choose>
                <xsl:when test="contains($responsability, ' ')">
                    <xsl:variable name="first-id"
                        select="substring-after(normalize-space(substring-before($responsability, ' ')), 'part:')"/>
                    <xsl:if test="$first-id">
                        <xsl:choose>
                            <!-- ligne pénible pour vérifier, si j'ai un nom de famille occidental -->
                            <xsl:when test="$display-behaviour='western-surname-only' and $list-members//tei:person[@xml:id = $first-id]/tei:persName/tei:surname"><xsl:apply-templates select="$list-members//tei:person[@xml:id = $first-id]/tei:persName/tei:surname"/></xsl:when>
                            <!-- ligne pour le western display, pour les noms non occidentaux -->
                            <xsl:when test="$display-behaviour='western-surname-only' and $list-members//tei:person[@xml:id = $first-id]/tei:persName/tei:name">
                                <xsl:apply-templates select="$list-members//tei:person[@xml:id = $first-id]/tei:persName/tei:name"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:apply-templates select="$list-members//tei:person[@xml:id = $first-id]/child::tei:persName"/></xsl:otherwise></xsl:choose>
                        <xsl:choose>
                            <xsl:when test="substring-after(substring-after($responsability, ' '), ' ')">
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text> and </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="responsability-display">
                            <xsl:with-param name="responsability" select="substring-after($responsability, ' ')"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$responsability = ''">
                            <xsl:text/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose><xsl:when test="$display-behaviour='western-surname-only'"><xsl:apply-templates select="$list-members//tei:person[@xml:id = substring-after($responsability, 'part:')]/tei:persName/tei:surname"/></xsl:when>  
                            <xsl:otherwise><xsl:apply-templates select="$list-members//tei:person[@xml:id = substring-after($responsability, 'part:')]/child::tei:persName"/>
</xsl:otherwise></xsl:choose>                        
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <!-- I have based my code on the lg file kept in project-documentation -->
    <!-- Attention: ce fichier n'est pas exhaustif, il pourrait donc y avoir des lg manquantes -->
    <xsl:template name="language-interpretation">
        <xsl:param name="language"/>
        <xsl:variable name="lines">
            <xsl:for-each select="tokenize($list-languages, '\r?\n')">            <xsl:variable name="tokens" as="xs:string*" select="tokenize(., '\t+')"/>
                <!-- je ne cherche pas à tokenizer le contenu du premier token -->
                <xsl:if test="$language = $tokens[1]"><xsl:value-of select="$tokens[2]"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$lines"/>
    </xsl:template>
    
    <!-- Header imported from Dharmalekha -->
    <xsl:template name="header">
        <header><div id="menu-bar">
            <a id="dharma-logo" href="/"><img alt="DHARMA Logo" src="https://dharmalekha.info/dharma_bar_logo.svg"/></a>
            <a id="menu-toggle"><i class="fa-solid fa-caret-down fa-fw"></i></a>
            <ul id="menu" class="hidden">
                <li>
                    <a href="https://dharmalekha.info/repositories">
                        <i class="fa-brands fa-git-alt"></i> Repositories</a>
                </li>
                <li>
                    <a href="https://dharmalekha.info/texts">
                        <i class="fa-regular fa-file-lines"></i> Texts</a>
                </li>
                <li class="submenu">
                    <a>Conventions <i class="fa-solid fa-caret-down"></i></a>
                    <ul class="hidden">
                        <li><a href="https://dharmalekha.info/editorial-conventions">Editorial Conventions</a></li>
                        <li><a href="https://dharmalekha.info/prosody">Prosodic Patterns</a></li>
                    </ul>
                </li>
                    <li>
                        <a href="https://dharmalekha.info/parallels">
                            <i class="fa-solid fa-grip-lines-vertical"></i> Parallels</a>
                    </li>
                    <li class="submenu">
                        <a>Project Internal <i class="fa-solid fa-caret-down"></i></a>
                        <ul class="hidden">
                            <li>
                                <a href="https://dharmalekha.info/errors">
                                    <i class="fa-solid fa-bug"></i> Texts Errors</a>
                            </li>
                            <li>
                                <a href="https://dharmalekha.info/bibliography-errors">
                                    <i class="fa-solid fa-bug"></i> Bibliography Errors</a>
                            </li>
                            <li>
                                <a href="https://dharmalekha.info/display">Display List</a>
                            </li>
                        </ul>
                    </li>
            </ul>
        </div>
        </header>

        <div id="sidebar">
            <div id="toc">
                <div id="toc-heading" class="toc-heading">Contents</div>
                <nav id="toc-contents">
                </nav>
            </div>
            <div class="toc-heading">Display</div>
            <label>Source view
                <input id="toggle-xml-display" type="checkbox"></input>
            </label>
            <div class="toc-heading">External Links</div>
            <nav>
                <ul>
                    <li>
                        <xsl:element name="a">
                            <xsl:attribute name="class">nav-link</xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $filename)"/></xsl:attribute><i class="fa-solid fa-code"></i> XML File
                        </xsl:element>
                    </li>
                </ul>
            </nav>
        </div>
    </xsl:template>
    
    <!--  text ! -->
    <xsl:template match="tei:text">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--  A ! -->
    <!--  ab ! -->
    <xsl:template match="tei:ab">
        <xsl:variable name="textpart-id" select="@xml:id"/>
        <xsl:variable name="ab-line">
            <xsl:for-each select=".">
                <xsl:variable name="context-root" select="."/>
                <xsl:choose>
                    <xsl:when test=".[following::tei:listApp[1][@type='apparatus']/tei:app] and ./following::tei:*[1][local-name() = 'listApp']">
                        <xsl:variable name="app-context" select="following::tei:listApp[1][@type='apparatus']/tei:app"/>
                        <xsl:call-template name="search-and-replace-lemma">
                            <xsl:with-param name="input" select="$context-root"/>
                            <xsl:with-param name="search-string" select="$app-context/tei:lem"/>
                            <xsl:with-param name="replace-node" select="$app-context"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>   
        <!--<xsl:choose>
            <xsl:when test="$edition-type='diplomatic'">
                <!-\- group sur pb pour faire des row pour aligner plus précisement l'apparat -\->
              
                <xsl:if test="tei:pb">
                    <xsl:for-each-group select="node()" group-starting-with="tei:pb">
                    <div class="row">
                        <div class="col-10 text-col">
                            <xsl:element name="span">
                    <xsl:for-each select="current-group()">
                        <xsl:apply-templates select="."/>
                        </xsl:for-each>
                            </xsl:element>    
                        </div>      
                        <xsl:if test="current-group()/descendant-or-self::node()[local-name()='app']">
                            <xsl:call-template name="launch-app"/>
                        </xsl:if>      
                    </div>
                </xsl:for-each-group>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>--><xsl:if test="@type"> 
                        <xsl:if test="@type">
                            <span class="lb" data-tip="{@type}">
                            <xsl:value-of select="@type"/>
                            </span>
                        </xsl:if>
                        <xsl:if test="@n and not(@type='invocation' or @type='colophon')">
                            <b class="lb" data-tip="Paragraph number">§<xsl:value-of select="@n"/><xsl:text> </xsl:text></b>
                        </xsl:if>
                    </xsl:if>
                    <div class="row">
                        <div class="col-10 text-col">
                            <xsl:element name="p">
                                <xsl:if test="@xml:id">
                                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                                </xsl:if>
                                <xsl:copy-of select="$ab-line"/>
                                <xsl:call-template name="lbrk-app"/>
                            </xsl:element>
                        </div>
                        <xsl:call-template name="launch-app"/>
                    </div><!--</xsl:otherwise>
        </xsl:choose>-->
        <xsl:if test="//tei:div[@type='translation']/descendant-or-self::tei:*[substring-after(@corresp, '#') = $textpart-id]"><xsl:call-template name="translation-button">
            <xsl:with-param name="textpart-id" select="$textpart-id "/>
        </xsl:call-template>
        </xsl:if>
</xsl:template>
    
    <!-- Abbr -->
    <!-- updated -->
    <xsl:template match="tei:abbr">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:div[@type='edition']">
                <span class="abbr" data-tip="Abbreviated text">
                <xsl:apply-templates/>
            </span>
        </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--  add ! -->
    <!-- Changer le placement pour le mettre dans la tooltip? -->
    <xsl:template match="tei:add">
        <xsl:choose>
            <!-- si parent subst, pour la particularité de la tooltip -->
           <xsl:when test="parent::tei:subst">
               <xsl:element name="span">
                   <xsl:attribute name="class">add</xsl:attribute>
                   <xsl:attribute name="data-tip">Scribal addition made in the space where a previous string of text has been erased (overwritten text: &lt;span class&quot;del&quot;&gt;⟦<xsl:value-of select="preceding-sibling::tei:del[1]"/>⟧&lt;span&gt;
                   <xsl:if test="@hand">
                       <xsl:text> H</xsl:text>
                       <xsl:element name="sub">
                           <xsl:value-of select="substring-after(@hand, '_H')"/>
                       </xsl:element>
                   </xsl:if>
                   <xsl:if test="@resp">
                       <xsl:call-template name="responsability-display">
                           <xsl:with-param name="responsability" select="@resp"/>
                           <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                       </xsl:call-template>
                   </xsl:if>
                   <xsl:if test="@source">
                       <xsl:call-template name="bibliography">
                           <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                       </xsl:call-template>
                   </xsl:if></xsl:attribute>
                   ⟨⟨<xsl:apply-templates/>⟩⟩
               </xsl:element>
           </xsl:when>
           <!-- condition en dehors de subst -->
            <xsl:otherwise>
                <xsl:element name="span">
            <xsl:attribute name="class">add</xsl:attribute>
            <xsl:attribute name="data-tip">Scribal addition: 
            <xsl:if test="@hand">
                <xsl:text>H</xsl:text>
                <xsl:element name="sub">
                <xsl:value-of select="substring-after(@hand, '_H')"/>
                </xsl:element>
                <xsl:if test="@place">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="@place and not(@place='unspecified' and parent::tei:subst)">
                <i><xsl:choose>
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
                </i>
                        </xsl:if>
                <xsl:if test="@resp">
                    <xsl:call-template name="responsability-display">
                        <xsl:with-param name="responsability" select="@resp"/>
                        <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="@source">
                    <xsl:call-template name="bibliography">
                        <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:attribute>
            ⟨⟨<xsl:apply-templates/>⟩⟩
        </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  app ! -->
    <xsl:template match="tei:app[not(@rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])]" mode="modals">
        <xsl:variable name="apparatus">
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
                        <xsl:when test="self::tei:span[@type='reformulationStart']">
                            <xsl:text>reformulation</xsl:text>
                        </xsl:when>
                        <xsl:when test="self::tei:lacunaStart">
                            <xsl:text>lost</xsl:text>
                        </xsl:when>
                        <xsl:when test="self::tei:note[ancestor::tei:div[@type='translation']]">
                            <xsl:text>trans</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="display-context" select="'modalapp'"/>
            </xsl:call-template>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus"/>
        </span>

    </xsl:template>
    
    <!--<xsl:template name="app-content">
            <span class="mb-1 lemma-line">
                <span class="app-lem">
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="not(child::tei:lem/following-sibling::tei:note[@type='altLem'])">
                                    
                                    <xsl:call-template name="lem-type"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>lem</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="tei:lem/following-sibling::tei:note[@type='altLem']">
                                <xsl:apply-templates select="replace(tei:lem/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')"/>
                            </xsl:when>
                            <xsl:when test="tei:lem[@type='transposition'][not(matches(@xml:id, 'trsp\d\d\d'))]"/>
                            <xsl:when test="tei:rdg[@type='transposition'][not(preceding-sibling::tei:lem)]">
                                <xsl:variable name="corresp-id" select="tei:rdg[@cause='transposition']/@corresp"/>
                                <xsl:apply-templates select="replace(//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')
                                    "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="tei:lem"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </span>
                <xsl:if test="tei:lem">
                    <xsl:if test="tei:lem/@type">
                        <xsl:text> </xsl:text>
                        <i><xsl:call-template name="apparatus-type">
                            <xsl:with-param name="type-app" select="tei:lem/@type"/>
                        </xsl:call-template>
                        </i>
                    </xsl:if>
                    <!-\- @resp and @source -\->
                    <xsl:if test="tei:lem/@resp">
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="responsability-display">
                            <xsl:with-param name="responsability" select="tei:lem/@resp"/>
                            <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                        </xsl:call-template>
                    </xsl:if>          
                    <xsl:if test="tei:lem/@source">
                        <xsl:text> </xsl:text>
                        <xsl:choose>
                            <xsl:when test="contains(tei:lem/@source, '#')"><xsl:call-template name="source-siglum">
                                <xsl:with-param name="string-to-siglum" select="tei:lem/@source"/>
                            </xsl:call-template></xsl:when>
                            <xsl:when test="contains(tei:lem/@source, 'bib:')">
                                <xsl:call-template name="bibliography">
                                    <xsl:with-param name="biblentry" select="substring-after(tei:lem/@source, 'bib:')"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>
                <!-\-<xsl:if test="tei:lem/@type='absent_elsewhere'">
                                    <xsl:text> only in </xsl:text>
                                </xsl:if>-\->
                <xsl:if test="tei:lem[@type='reformulated_elsewhere'] or tei:lem[following-sibling::tei:rdg[@type='paradosis']] "> <!-\- or tei:lem[following-sibling::tei:witDetail[@type='retained']] -\->
                    <xsl:text> Thus formulated in </xsl:text>
                    <xsl:element name="span">
                        <xsl:attribute name="class">font-weight-bold<xsl:if test="following-sibling::*[local-name()='witDetail']"> supsub</xsl:if></xsl:attribute>
                        <xsl:call-template name="tokenize-witness-list">
                            <xsl:with-param name="string" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                            
                            <xsl:with-param name="witdetail-type" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@type"/>
                            <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                            
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="tei:lem[@type='transposition'][not(matches(@xml:id, 'trsp\d\d\d'))][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]">
                    
                    <b><xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="tei:lem[@type='transposition']/following-sibling::tei:rdg/@wit"/>
                        <xsl:with-param name="wit-hand" select="tei:lem[@type='transposition']/following-sibling::tei:rdg/@hand"/>
                    </xsl:call-template></b>
                    
                    <xsl:text> presents the lines in order </xsl:text>
                    <xsl:for-each select="tei:lem[@type='transposition']/following-sibling::tei:rdg/descendant-or-self::tei:l">
                        <xsl:variable name="id-corresp" select="substring-after(@corresp, '#')"/>
                        <xsl:value-of select="ancestor-or-self::tei:rdg/preceding-sibling::tei:lem/descendant-or-self::tei:l[@xml:id = $id-corresp]/@n"/>
                    </xsl:for-each>
                </xsl:if>
                <!-\- witness display for transposition section 5.8.4 -\->
                <xsl:if test="tei:lem[@type='transposition'][matches(@xml:id, 'trsp\d\d\d')]">
                    
                    
                    <b><xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                        
                        <xsl:with-param name="witdetail-type" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@type"/>
                        <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                    </xsl:call-template></b>
                    
                </xsl:if>
                <xsl:if test="tei:lem[@type='omitted_elsewhere']">
                    <xsl:text> transmitted in </xsl:text>
                    <xsl:element name="b">
                        <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                        <xsl:call-template name="tokenize-witness-list">
                            <xsl:with-param name="string" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                            
                            <xsl:with-param name="witdetail-type" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@type"/>
                            <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                            
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="tei:lem[@type='lost_elsewhere']">
                    <xsl:text> preserved in </xsl:text>
                    <xsl:element name="b">
                        <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                        <xsl:call-template name="tokenize-witness-list">
                            <xsl:with-param name="string" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                            
                            <xsl:with-param name="witdetail-type" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@type"/>
                            <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                            
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="tei:lem/@wit">
                    <xsl:choose>
                        <xsl:when test="tei:lem[@type='transposition'][not(@xml:id)][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]"/>
                        <xsl:otherwise>
                            <xsl:element name="b">
                                <xsl:if test="tei:lem/following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                                <xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="tei:lem/@wit"/>
                                    <xsl:with-param name="witdetail-string" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                    <xsl:with-param name="witdetail-type" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                    <xsl:with-param name="witdetail-text" select="tei:lem/following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                    <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                                </xsl:call-template>                           
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="tei:lem[@type='transposition']">
                    <xsl:choose>
                        <xsl:when test="tei:lem[not(@xml:id)][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]"></xsl:when>
                        <xsl:otherwise>
                            <xsl:text> (transposition)</xsl:text>
                        </xsl:otherwise></xsl:choose>
                </xsl:if> 
                <!-\- witnesses pour la transposition  -\->
                <xsl:if test="tei:rdg[@cause='transposition'][not(preceding-sibling::tei:lem)]">
                    <xsl:variable name="corresp-id" select="tei:rdg[@cause='transposition']/@corresp"/>
                    
                    <b><xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="tei:rdg[1]/@wit"/>
                        <xsl:with-param name="wit-hand" select="tei:rdg/@hand"/>
                    </xsl:call-template></b>
                    
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="tei:rdg/@cause"/>
                    <xsl:text>, see </xsl:text>
                    <xsl:element name="a">
                        <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/@xml:id"/></xsl:attribute>
                        <xsl:text>st. </xsl:text>
                        <xsl:choose>
                            <xsl:when test="@n">
                                <xsl:value-of select="//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/child::tei:lg/@n"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:number from="tei:body" count="tei:div[not(@type='metrical' or child::tei:ab[@type])] | tei:p | tei:ab[not(@type='invocation' or @type='colophon')] | tei:lg[not(ancestor::tei:listApp)] | tei:quote[not(@type='base-text')]" level="multiple" format="1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </span>
            
            <!-\-  Variant readings ! -\->
            <xsl:if test="descendant-or-self::tei:rdg[not(@type='paradosis' or  @cause='transposition')][not(preceding-sibling::tei:lem[@type='transposition'])]">
                <xsl:element name="hr"/>
                <!-\-<xsl:if test="ancestor::*[local-name()='lem'][1][@type='absent_elsewhere']">
                                <xsl:apply-templates select="ancestor::*[local-name()='lem'][1][@type='absent_elsewhere']/following-sibling::tei:rdg[1]"/>
                            </xsl:if>-\->
                <xsl:for-each select="descendant-or-self::tei:rdg">
                    <xsl:call-template name="rdg-content">
                        <xsl:with-param name="parent-rdg" select="'no'"/>
                    </xsl:call-template>
                </xsl:for-each>
                
                <xsl:for-each select="ancestor::*[local-name()='lem'][not(@type='reformulated_elsewhere' or @type='transposition')][1]/following-sibling::tei:rdg[1]">
                    <xsl:call-template name="rdg-content">
                        <xsl:with-param name="display-context" select="'modalapp'"/>
                    </xsl:call-template>
                </xsl:for-each>
                
            </xsl:if>
            <xsl:if test="descendant-or-self::tei:rdg[@type='paradosis']">
                <xsl:element name="hr"/>
                <xsl:for-each select="descendant-or-self::tei:rdg[@type='paradosis']">
                    <xsl:element name="span">
                        <xsl:attribute name="class">paradosis-line</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-italic</xsl:attribute>
                            <xsl:text>Paradosis</xsl:text>
                        </xsl:element>
                        <xsl:text> of </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold <xsl:if test="tei:lem/following-sibling::*[local-name()='witDetail']">supsub</xsl:if>
                            </xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="@wit"/>
                                <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:text>: </xsl:text>
                        <!-\-<xsl:apply-templates select="node() except child::tei:span[@type='omissionStart']"/>-\->
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
            <!-\-  Notes ! -\->
            <xsl:if test="tei:note[not(@type='altLem') or ancestor::tei:listApp]">
                <xsl:element name="hr"/>
                <xsl:for-each select="tei:note[not(@type='altLem')]">
                    <span class="note-line"> 
                        <xsl:apply-templates/>
                    </span>
                </xsl:for-each>
            </xsl:if>
            <!-\- commentaire du witDetail -\->
            <!-\- temporary disabled, waiting for Arlo's answer on where to place it -\->
            <!-\-<xsl:if test="ancestor-or-self::tei:app[1]/descendant-or-self::tei:witDetail/text()">
                <xsl:for-each select="ancestor-or-self::tei:app[1]/descendant-or-self::tei:witDetail/text()">
                    <xsl:element name="hr"/>
                    <xsl:element name="span">
                        <xsl:attribute name="class">witDetail-line</xsl:attribute>
                        <!-\\-<xsl:element name="span">
                               <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="parent::tei:witDetail/@wit"/>
                                <xsl:with-param name="witdetail-type" select="parent::tei:witDetail/@type"/>
                                <xsl:with-param name="wit-hand" select="parent::tei:witDetail/preceding-sibling::tei:*[1]/@hand"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:text>: </xsl:text>-\\->
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>-\->
    </xsl:template>-->

    <!-- le param pour parent-rdg a été conservé pour le moment en raison de la valeur no; pour laquelle je n'arrive pas à retrouver l'intention initiale que j'avais -->
    <xsl:template name="rdg-content">
        <xsl:param name="parent-rdg"/>
        <xsl:param name="display-context"/>
        <xsl:element name="span">
            <xsl:choose>
            <xsl:when test="$parent-rdg='no' or $display-context='modalapp'">
                <xsl:attribute name="class">reading reading-line<xsl:choose><xsl:when test="descendant-or-self::tei:lacunaStart"><xsl:text> rdg-lacunaStart</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionStart']"> rdg-omissionStart<xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:lacunaEnd"><xsl:text> rdg-lacunaEnd</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionEnd']"> rdg-omissionEnd<xsl:value-of select="@wit"/></xsl:when></xsl:choose>
            </xsl:attribute>
            </xsl:when>
                <xsl:when test="$display-context='printedapp'">
                    <xsl:attribute name="class">reading bottom-reading-line</xsl:attribute>
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:otherwise><xsl:call-template name="lbrk-app"/></xsl:otherwise>
            </xsl:choose>
            <span class="app-rdg">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:if test="@rend='check'">
                            <xsl:text> mark</xsl:text>
                        </xsl:if>
                        <xsl:if test="@rend='unmetrical'">
                            <xsl:text> unmetrical</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="tei:gap[@reason='omitted']">
                            <i>om.</i>
                        </xsl:when>
                        <xsl:when test="child::tei:gap[@reason='lost'and not(@quantity|@unit)]">
                            <i>lac.</i>
                        </xsl:when>
                        <xsl:when test="child::tei:lacunaEnd or child::tei:span[@type='omissionEnd']">...]</xsl:when>
                    </xsl:choose>

                    <xsl:if test="$parent-rdg='no'">
                        <xsl:apply-templates/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="child::tei:lacunaStart or child::tei:span[@type='omissionStart']">[...</xsl:when>
                    </xsl:choose>
                </xsl:element>
            </span>
        </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:element name="b">
                <xsl:if test="following-sibling::*[local-name()='witDetail']"> <xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                <xsl:call-template name="tokenize-witness-list">
                    <xsl:with-param name="string" select="./@wit"/>
                    <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                    <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                    <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                    <xsl:with-param name="wit-hand" select="./@hand"/>
                </xsl:call-template>
            </xsl:element>
                <xsl:if test="./@type">
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="apparatus-type">
                        <xsl:with-param name="type-app" select="./@type"/>
                    </xsl:call-template>
                </xsl:if>
                <!-- @resp and @source -->
                <xsl:if test="./@resp">
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="responsability-display">
                        <xsl:with-param name="responsability" select="./@resp"/>
                        <xsl:with-param name="display-behaviour" select="''"/>
                    </xsl:call-template>
                </xsl:if>    
            <xsl:if test="./@source">
                <xsl:text> </xsl:text>                
                <xsl:choose>
                    <xsl:when test="contains(./@source, '#')"><xsl:call-template name="source-siglum">
                        <xsl:with-param name="string-to-siglum" select="./@source"/>
                    </xsl:call-template></xsl:when>
                    <xsl:when test="contains(./@source, 'bib:')">
                        <xsl:call-template name="bibliography">
                            <xsl:with-param name="biblentry" select="substring-after(./@source, 'bib:')"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="./@cause and $parent-rdg='no'">
                <xsl:element name="span">
                    <xsl:attribute name="style">color:black;</xsl:attribute>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="replace(./@cause, '_', ' ')"/>
                    <xsl:text>)</xsl:text>
                </xsl:element>
            </xsl:if>
        <xsl:if test="$display-context='modalapp' or $display-context='printedapp'">
                <xsl:element name="span">
                    <xsl:attribute name="style">color:black;</xsl:attribute>
                    <xsl:text> (larger gap)</xsl:text>
                </xsl:element>
            </xsl:if>
    </xsl:template>

    <xsl:template match="tei:app[not(parent::tei:listApp[@type='parallels'] or preceding-sibling::tei:span[@type='reformulationEnd'][1])]">
        <xsl:param name="location"/>
        <xsl:param name="app-num"/>
        <xsl:param name="app-type"/>
        <xsl:variable name="app-num">
            <xsl:value-of select="name()"/>
            <xsl:number level="any" format="0001"/>
        </xsl:variable>
            <xsl:choose>
                <xsl:when test="@rend='hide'">
                    <xsl:apply-templates select="tei:lem"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="descendant::tei:span[@type='omissionStart']">
                        <xsl:element name="span">
                            <xsl:attribute name="class">omissionAnchor-start</xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="descendant::tei:lacunaStart">
                        <xsl:element name="span">
                            <xsl:attribute name="class">lostAnchor-start</xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>lem</xsl:text>
                <xsl:if test="descendant::tei:span[@type='omissionStart']"> lem-omissionStart</xsl:if>
                <xsl:if test="descendant::tei:span[@type='omissionEnd']"> lem-omissionEnd</xsl:if>
                <xsl:if test="descendant::tei:lacunaStart"> lem-lostStart</xsl:if>
                <xsl:if test="descendant::tei:lacunaEnd"> lem-lostEnd</xsl:if>
                <xsl:if test="@type='transposed_elsewhere'"> transposed</xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-app">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
             <xsl:choose>
                 <xsl:when test="not(tei:lem) and tei:rdg[@cause='transposition'] or tei:rdgGrp[@cause='transposition']">
                     <xsl:text>[transposed segment]</xsl:text>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:apply-templates select="tei:lem"/>
                 </xsl:otherwise>
                 </xsl:choose>

                    </xsl:element>
                    <xsl:if test="descendant::tei:span[@type='omissionEnd']">
                        <xsl:element name="span">
                            <xsl:attribute name="class">omissionAnchor-end</xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>


    <!--  B ! -->
    <xsl:template match="tei:bibl">
        <xsl:variable name="biblentry" select="substring-after(./tei:ptr/@target, 'bib:')"/>
        <xsl:choose>
            <xsl:when test="tei:ptr"> 
               <xsl:call-template name="bibliography">
            <xsl:with-param name="biblentry" select="$biblentry"/>
        </xsl:call-template>
           </xsl:when>
            <xsl:otherwise>
                <p class="bib-entry"><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- à retravailler: display incomplet -->
    <xsl:template name="bibliography">
        <xsl:param name="biblentry"/>
        <xsl:variable name="zoteroapi" select="json-to-xml(unparsed-text(concat('https://dharmalekha.info/zotero-proxy/extra?shortTitle=',encode-for-uri($biblentry))))/*"/>
        <xsl:variable name="zoteroapitei" select="replace(concat('https://dharmalekha.info/zotero-proxy/extra?shortTitle=', encode-for-uri($biblentry), '&amp;format=tei'), 'amp;', '')"/>        
            <xsl:variable name="key-item" select="$zoteroapi//(*[@key='key'][1])"/>
        <xsl:variable name="tei-bib" select="document($zoteroapitei)//tei:listBibl"/>
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::tei:listBibl">
                        <p class="bib-entry" id="bib-key-{$key-item[1]}">
                            <xsl:call-template name="biblio-tei">
                                <xsl:with-param name="bib-type" select="$tei-bib//tei:biblStruct/@type"/>
                                <xsl:with-param name="bib-content" select="$tei-bib//tei:biblStruct"/>
                            </xsl:call-template>
                            <xsl:call-template name="tpl-citedRange"/>
                            <a href="https://www.zotero.org/groups/erc-dharma/items/{$key-item[1]}">
                            <i class="fas fa-edit" style="display:inline;" data-tip="Edit on zotero.org"> </i></a>
                        </p>
                    </xsl:when>
                    <xsl:when test="not(ancestor-or-self::tei:listBibl)">
                        <a class="bib-ref" href="#bib-key-{$key-item[1]}">
                            <xsl:choose>
                                <xsl:when test="@rend='omitname'">
                                    <xsl:apply-templates select="$zoteroapi//(*[@key='parsedDate'][1])"/>
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
                                    <xsl:choose>
                                        <xsl:when test="$zoteroapi//(*[@key='creatorSummary'][1])">
                                            <xsl:apply-templates select="$zoteroapi//(*[@key='creatorSummary'][1])"/><xsl:text> </xsl:text><xsl:apply-templates select="$zoteroapi//(*[@key='parsedDate'][1])"/>
                                            
                                        </xsl:when>
                                            <xsl:otherwise>
                                                <span class="bib-entry" data-tip="Zotero's routine not working or ShortTitle not found"><xsl:value-of select="$biblentry"/></span>
                                            </xsl:otherwise>
                                    </xsl:choose>    
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                                <xsl:call-template name="tpl-citedRange"/>
                            
                        
                        <!--	if it is in the bibliography print styled reference-->
                        
                        </xsl:when>
                    <xsl:otherwise>
                        <span class="bib-entry" data-tip="Zotero's routine not working or ShortTitle not found"><xsl:value-of select="$biblentry"/></span>
                    </xsl:otherwise>
                </xsl:choose>
    </xsl:template>
    
    <xsl:template name="biblio-tei">
        <xsl:param name="bib-type"/>
        <xsl:param name="bib-content"/>
        <xsl:choose>
            <xsl:when test="$bib-type='book'">
                <xsl:for-each select="$bib-content//tei:monogr/tei:author">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$bib-content//tei:monogr/tei:editor">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> (ed.)</xsl:text>
                </xsl:for-each>
                
                <xsl:text>. </xsl:text>
                <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:date"/><xsl:text>. </xsl:text>
                <i><xsl:apply-templates select="$bib-content//tei:monogr/tei:title[@level='m']"/>
                </i><xsl:text>. </xsl:text>
                <xsl:if test="$bib-content//tei:monogr/tei:edition"><xsl:text> </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:edition"/><xsl:text>. </xsl:text></xsl:if>
                <xsl:if test="$bib-content//tei:series">
                    <xsl:apply-templates select="$bib-content//tei:series/tei:title[@level='s']"/><xsl:if test="$bib-content//tei:series/tei:biblScope"><xsl:text>, </xsl:text> <xsl:apply-templates select="$bib-content//tei:series/tei:biblScope"/></xsl:if>.</xsl:if> <xsl:text> </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:pubPlace"/>: <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:publisher"/>. <xsl:if test="$bib-content//tei:monogr/tei:imprint/tei:note[@type='url']"><xsl:element name="a"><xsl:attribute name="href"><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:note[@type='url']"/></xsl:attribute>[URL]</xsl:element>. </xsl:if>
            </xsl:when>
            <xsl:when test="$bib-type='bookSection'">
                <!-- Bosch, Frederik David Kan. 1961. “Buddhist Data from Balinese Texts.” In Selected Studies in Indonesian Archaeology, 109–33. Koninklijk Instituut Voor Taal-, Land- En Volkenkunde Translation Series 5. The Hague: Martinus Nijhoff. -->
                <xsl:for-each select="$bib-content//tei:analytic/tei:author">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>. </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:date"/>.<xsl:text> “</xsl:text><xsl:apply-templates select="$bib-content//tei:analytic/tei:title[@level='a']"/>.” In <i><xsl:apply-templates select="$bib-content//tei:monogr/tei:title[@level='m']"/></i><xsl:if test="$bib-content//tei:monogr/tei:author">, by <xsl:for-each select="$bib-content//tei:monogr/tei:author">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                </xsl:if>
                <xsl:if test="$bib-content//tei:monogr/tei:editor">, <xsl:for-each select="$bib-content//tei:monogr/tei:editor">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> (ed.)</xsl:text>
                </xsl:for-each></xsl:if>. <xsl:if test="$bib-content//tei:series"><xsl:text> </xsl:text>
                    <xsl:apply-templates select="$bib-content//tei:series/tei:title[@level='s']"/> <xsl:apply-templates select="$bib-content//tei:series/tei:biblScope[@unit='volume']"/>. </xsl:if> 
               <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:pubPlace"/>: <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:publisher"/>, pp. <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/><xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:when test="$bib-type='journalArticle'">
                <xsl:for-each select="$bib-content//tei:analytic/tei:author">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>. </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:date"/>.<xsl:text> “</xsl:text><xsl:apply-templates select="$bib-content//tei:analytic/tei:title[@level='a']"/><xsl:text>.”</xsl:text>
                <!-- partially implemented --><xsl:text> </xsl:text><xsl:element name="abbr">
                    <xsl:attribute name="data-tip">&lt;i&gt;<xsl:apply-templates select="$bib-content//tei:monogr/tei:title[@level='j']"/>&lt;/i&gt;</xsl:attribute><i><xsl:apply-templates select="$bib-content//tei:monogr/tei:title[@level='j']"/></i></xsl:element><xsl:text> </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/><xsl:if test="$bib-content//tei:monogr/tei:imprint/tei:biblScope[@unit='issue']"> <xsl:text> </xsl:text>(<xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:biblScope[@unit='issue']"/>)</xsl:if> <xsl:text>, pp. </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/><xsl:text>.</xsl:text><xsl:if test="$bib-content//tei:analytic/tei:idno[@type='DOI']"><xsl:element name="a"><xsl:attribute name="class">url</xsl:attribute><xsl:attribute name="href">https://doi.org/<xsl:apply-templates select="$bib-content//tei:analytic/tei:idno[@type='DOI']"/></xsl:attribute>[DOI]</xsl:element>. </xsl:if><xsl:if test="$bib-content//tei:monogr/tei:imprint/tei:note[@type='url']"><xsl:element name="a"><xsl:attribute name="class">url</xsl:attribute><xsl:attribute name="href"><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:note[@type='url']"/></xsl:attribute>[URL]</xsl:element>. </xsl:if>
                       
            </xsl:when>
            <xsl:when test="$bib-type='thesis'">
                <xsl:for-each select="$bib-content//tei:monogr/tei:author">
                    <xsl:choose>
                        <xsl:when test="position()[1]">
                            <xsl:call-template name="first-author"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="following-authors"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>. </xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:date"/>.<xsl:text> “</xsl:text><xsl:apply-templates select="$bib-content//tei:monogr/tei:title[@level='m']"/>.” PhD Dissertation, <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:pubPlace"/>: <xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:publisher"/>. <xsl:if test="$bib-content//tei:monogr/tei:imprint/tei:note[@type='url']"><xsl:element name="a"><xsl:attribute name="href"><xsl:apply-templates select="$bib-content//tei:monogr/tei:imprint/tei:note[@type='url']"/></xsl:attribute>[URL]</xsl:element>. </xsl:if> 
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="first-author">
        <xsl:choose><xsl:when test="tei:name"><xsl:apply-templates select="tei:name"/></xsl:when><xsl:otherwise><xsl:apply-templates select="tei:surname"/>, <xsl:apply-templates select="tei:forename"/></xsl:otherwise></xsl:choose>
    </xsl:template>
    
    <xsl:template name="following-authors">
        <xsl:choose><xsl:when test="tei:name"><xsl:apply-templates/></xsl:when><xsl:otherwise><xsl:apply-templates select="tei:forename"/> <xsl:apply-templates select="tei:surname"/> </xsl:otherwise></xsl:choose>
        <xsl:choose>
            <xsl:when test="position()[last()-1]">
                <xsl:text> &amp; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="position()[last() -1]">&amp;</xsl:when>
            <xsl:otherwise>, </xsl:otherwise>
        </xsl:choose>
        <xsl:text>. </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--  C ! -->
    <!--  caesura ! -->
    <xsl:template match="tei:caesura">
        <span class="caesura"><xsl:apply-templates/></span>
    </xsl:template>

    <!--  choice ! -->
    <!-- updated -->
    <xsl:template match="tei:choice">
        <xsl:choose>
            <!-- un peu redondant à voir si je ne peux pag gérér tous les unclear ensembles -->
            <xsl:when test="tei:unclear">
                <span class="choice-unclear" data-tip="'Unclear (several possible readings)'">(<xsl:apply-templates select="tei:unclear[1]"/><xsl:if test="@cert='low'">?</xsl:if>
                    <xsl:text>/</xsl:text>
                    <xsl:apply-templates select="tei:unclear[2]"/><xsl:if test="@cert='low'">?</xsl:if>)</span>
            </xsl:when>
            <!-- <span class="orig" data-tip="Non-standard text (standardisation: <span class=&quot;reg&quot;>⟨celeṁ⟩</span>)">¡coloṁ!</span> -->
            <xsl:when test="tei:orig">
                <xsl:element name="span">
                    <xsl:attribute name="class">orig</xsl:attribute>
                    <xsl:attribute name="data-tip">Non-standard text<xsl:if test="tei:reg"> (standardisation: <span class="reg">⟨<xsl:apply-templates select="tei:reg"/>⟩)</span></xsl:if></xsl:attribute>¡<xsl:apply-templates select="tei:orig"/>!</xsl:element>
            </xsl:when>
            <!-- <span class="reg" data-tip="Standardised text (original: <span class=&quot;orig&quot;>¡coloṁ!</span>)">⟨celeṁ⟩</span> -->
            <xsl:when test="tei:reg">
                <xsl:element name="span">
                    <xsl:attribute name="class">reg</xsl:attribute>
                    <xsl:attribute name="data-tip">Standardised text<xsl:if test="tei:orig"> (original: <span class="orig">¡<xsl:apply-templates select="tei:orig"/>!)</span></xsl:if></xsl:attribute>⟨<xsl:apply-templates select="tei:reg"/>⟩</xsl:element>
            </xsl:when>
            <!-- <span class="sic" data-tip="Incorrect text (emendation: <span class=&quot;corr&quot;>⟨kh⟩</span>)">¿l?</span> -->
            <xsl:when test="tei:sic">
                <xsl:element name="span">
                    <xsl:attribute name="class">sic</xsl:attribute>
                    <xsl:attribute name="data-tip">Incorrect text<xsl:if test="tei:corr">  (emendation: <span class="corr">⟨<xsl:apply-templates select="tei:corr"/>⟩)</span></xsl:if></xsl:attribute>¿<xsl:apply-templates select="tei:sic"/>?</xsl:element>
            </xsl:when>
            <!-- <span class="corr" data-tip="Emended text (original: <span class=&quot;sic&quot;>¿l?</span>)">⟨kh⟩</span> -->
            <xsl:when test="tei:corr">
                <xsl:element name="span">
                    <xsl:attribute name="class">corr</xsl:attribute>
                    <xsl:attribute name="data-tip">Emended text<xsl:if test="tei:sic">  (original: <span class="sic">¿<xsl:apply-templates/>?</span></xsl:if></xsl:attribute>⟨<xsl:apply-templates select="tei:corr"/>⟩</xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- à voir si stable - pour diplEd -->
    <!-- préparation pour intégrer les choice, si j'ai le temps -->
   <!-- <xsl:template match="tei:choice[child::tei:sic and child::tei:corr]" mode="modals">
        <xsl:variable name="apparatus">
                <span class="mb-1 lemma-line">
                    <span class="app-corr">
                        <xsl:apply-templates select="child::tei:corr"/>
                        <xsl:text> (corr)</xsl:text>
                    </span>
                </span>
        </xsl:variable>
        <xsl:if test="$edition-type='diplomatic'">
            <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus"/>
        </span></xsl:if>
    </xsl:template>-->
    
    <!-- citedRange -->
    <xsl:template name="tpl-citedRange">  
            <xsl:choose>
                <xsl:when test="tei:citedRange and not(ancestor::tei:cit or ancestor::tei:listBibl)">
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
        <xsl:text>. </xsl:text>
    </xsl:template>
    
    <!-- colophon -->
    <xsl:template match="tei:colophon">
        <xsl:apply-templates/>
        <xsl:if test="descendant-or-self::tei:note">
            <xsl:apply-templates select="tei:note"/>
        </xsl:if>
    </xsl:template>

    <!--  D ! -->
    <!--  del ! -->
    <xsl:template match="tei:del">
        <xsl:choose>
            <!-- si parent subst, pour la particularité de la tooltip -->
            <xsl:when test="parent::tei:subst">
                <xsl:element name="span">
                    <xsl:attribute name="class">del</xsl:attribute>
                    <xsl:attribute name="data-tip">Scribal deletion: corrected text (replacement text: &lt;span class=&quot;add&quot;&gt;⟨⟨<xsl:value-of select="following-sibling::tei:add[1]"/>⟩⟩&lt;/span&gt;
                    <xsl:if test="@hand">
                        <xsl:text> H</xsl:text>
                        <xsl:element name="sub">
                            <xsl:value-of select="substring-after(@hand, '_H')"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="@resp">
                        <xsl:call-template name="responsability-display">
                            <xsl:with-param name="responsability" select="@resp"/>
                            <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="@source">
                        <xsl:call-template name="bibliography">
                            <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                        </xsl:call-template>
                    </xsl:if></xsl:attribute>
                    ⟦<xsl:apply-templates/>⟧
                </xsl:element>
            </xsl:when>
            <!-- Characters deleted by premodern scribe and no longer legible -->
            <xsl:when test="child::tei:gap">
                <xsl:element name="span">
                    <xsl:attribute name="class">del</xsl:attribute>
                    <xsl:attribute name="data-tip">Scribal deletion
                        <xsl:if test="@hand">
                            <xsl:text> H</xsl:text>
                            <xsl:element name="sub">
                                <xsl:value-of select="substring-after(@hand, '_H')"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="@resp">
                            <xsl:call-template name="responsability-display">
                                <xsl:with-param name="responsability" select="@resp"/>
                                <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="@source">
                            <xsl:call-template name="bibliography">
                                <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:attribute>
                    ⟦<xsl:apply-templates/>⟧
                </xsl:element>
            </xsl:when>
            <!-- condition en dehors de subst -->
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="class">del</xsl:attribute>
                    <xsl:attribute name="data-tip">Scribal deletion: text struck through or cross-hatched
            <xsl:if test="@hand">
                <xsl:text> H</xsl:text>
                <xsl:element name="sub">
                    <xsl:value-of select="substring-after(@hand, '_H')"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="@resp">
                <xsl:call-template name="responsability-display">
                    <xsl:with-param name="responsability" select="@resp"/>
                    <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="@source">
                <xsl:call-template name="bibliography">
                    <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                </xsl:call-template>
            </xsl:if></xsl:attribute>
            ⟦<xsl:apply-templates/>⟧</xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:desc">
        <xsl:apply-templates/>
    </xsl:template>

    <!--  div ! -->
    <xsl:template match="tei:div">
        <xsl:variable name="divtype" select="@type"/>
        <xsl:variable name="metrical" select="@met"/>
        <xsl:if test="@type='chapter' or @type='subchapter'"><h3 class="ed-heading" id="toc{generate-id(.)}"><xsl:choose>
                <xsl:when test="@type='interpolation'">
                    <xsl:choose>
                        <xsl:when test="preceding::tei:div[not(@type='metrical'or @type='section')][1]/@n">
                            <xsl:text>*. </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:number from="tei:div[@type='edition']" count="tei:div[not(@type='metrical' or child::tei:ab[@type])] | tei:p | tei:ab[not(@type='invocation' or @type='colophon')] | tei:lg[not(ancestor::tei:listApp)] | tei:quote[not(@type='base-text')]" level="multiple" format="1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            <xsl:when test="@type='chapter'">Chapter <xsl:value-of select="@n"/></xsl:when>
                <xsl:when test="@type='canto'"/>
                <xsl:otherwise>
                    <xsl:value-of select="@n"/>
                </xsl:otherwise>
            </xsl:choose>
                <xsl:if test="child::*[1][local-name()= 'head']">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="tei:head"/>
                </xsl:if>
            </h3></xsl:if>
        <xsl:choose>
            <xsl:when test="@type='section'">
                <h4 class="ed-heading" id="toc{generate-id(.)}">
                    <xsl:if test="@n">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@n"/>
                    </xsl:if>
                    <xsl:if test="tei:head">
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="child::*[1][local-name() = 'head']"/>
                    </xsl:if>
                </h4>
            </xsl:when>
            <xsl:when test="@type">
                <div>
                    <xsl:attribute name="class">col-10</xsl:attribute>
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@type='canto' or @type='dyad'">
                        <xsl:variable name="type-div" select="@type"/>
                        <h4 class="ed-heading" id="toc{generate-id(.)}"><xsl:choose><xsl:when test="@type='canto'"><xsl:value-of select="concat(upper-case(substring($type-div,1,1)), substring($type-div, 2),' '[not(last())] )"/><xsl:text> </xsl:text><xsl:number count="tei:div[@type=$type-div]" level="multiple" format="1"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(upper-case(substring($type-div,1,1)), substring($type-div, 2),' '[not(last())] )"/><xsl:text> </xsl:text><xsl:value-of select="@n"/></xsl:otherwise></xsl:choose>
                            <xsl:if test="@rend='met'">
                                <xsl:call-template name="metrical-list">
                                    <xsl:with-param name="metrical" select="$metrical"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="tei:head">
                                <xsl:text> </xsl:text>
                                <xsl:apply-templates select="child::*[1][local-name() = 'head']"/>
                            </xsl:if>
                        </h4>
                    </xsl:if>
                    
                </div>
            </xsl:when>
            
            <!--<xsl:when test="@type='section'">
                <h4><xsl:if test="@n">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@n"/>
                </xsl:if>
                <xsl:if test="tei:head">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="child::*[1][local-name() = 'head']"/>
                </xsl:if>
                </h4>
            </xsl:when>-->
        </xsl:choose>
        <xsl:apply-templates select="* except tei:head"/>
        <xsl:if test="./following::tei:div[@type='chapter'][1]">
            <xsl:element name="br"/>
        </xsl:if>
        <xsl:if test="./following-sibling::tei:div[child::tei:ab[@type='colophon']][1]">
            <xsl:element name="hr"/>
        </xsl:if>               
    </xsl:template>

    <xsl:template name="metrical-list">
        <xsl:param name="metrical"/>
        <xsl:param name="line-context"/>
        <xsl:choose>
            <xsl:when test="matches($metrical,'[=\+\-]+')">
                <xsl:choose>
                    <xsl:when test="$prosody//tei:item[tei:seg[@type='xml'] =$metrical][1]">
                        <xsl:variable name="label-group" select="$prosody//tei:item[tei:seg[@type='xml'] =$metrical]/child::tei:label"/>
                        <span data-tip=" &lt;span class=&quot;prosody&quot;&gt;{$prosody//tei:item[tei:seg[@type='xml']]/tei:seg[@type='prosody']}&lt;/span&gt;">
                            Name unknown <xsl:if test="$label-group = ' '">(<i><xsl:value-of select="concat(upper-case(substring($label-group,1,1)), substring($label-group, 2),' '[not(last())] )"/></i>)</xsl:if>
                         class</span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="span">
                            <xsl:attribute name="data-tip">&lt;span class=&quot;prosody&quot;&gt;<xsl:value-of select="translate($metrical, '-=+', '⏑⏓–')"/>&lt;/span&gt;</xsl:attribute>
                            <xsl:text> Name unknown</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- to be deleted? -->
            <xsl:when test="contains($metrical, 'free')">
                <xsl:text> Free</xsl:text>
            </xsl:when>
            <xsl:when test="$prosody//tei:item[tei:name =$metrical]">
                <xsl:variable name="prosody-numb">
                    <xsl:if test="$prosody//tei:item[tei:name =$metrical]">
                        <xsl:value-of select="$prosody//tei:item[tei:name =$metrical]/count(preceding::tei:item)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="prosody-segment"><xsl:value-of select="$prosody//tei:item[tei:name =$metrical]/tei:seg[@type='prosody']"/></xsl:variable>
                
                <xsl:element name="a">
                    <xsl:attribute name="href">                                <xsl:value-of select="concat('https://dharmalekha.info/prosody#prosody-', $prosody-numb)"/>
                    </xsl:attribute>
                    <!-- pb de l'ajout des balises dans la data-tip -->
                    <span data-tip="&lt;span class=&quot;prosody&quot;&gt;{$prosody-segment}&lt;/span&gt;">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="concat(upper-case(substring($prosody//tei:item/tei:name[text() =$metrical],1,1)), substring($prosody//tei:item/tei:name[text() =$metrical], 2),' '[not(last())] )"/>
                    </span>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(upper-case(substring(@met,1,1)), substring(@met, 2),' '[not(last())] )"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--  F ! -->
    <!--  foreign ! -->
    <!-- updated -->
    <xsl:template match="tei:foreign">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <xsl:template match="tei:encodingDesc">
        <hr/>
        <div class="editorial">
            <h2 id="editorial" class="collapsible">Editorial <i class="fa-solid fa-angles-down"></i></h2>
        <div class="collapsible-content"><xsl:if test="tei:projectDesc/tei:p[2]/text()">
            <ul><li><b>Project</b>: 
                <ul><xsl:for-each select="tei:projectDesc/tei:p">
                    <li><xsl:apply-templates select="."/></li>
                </xsl:for-each></ul></li></ul>
        </xsl:if>
        
        <xsl:if test="tei:editorialDecl//tei:p/text()">
            <ul><li><b>Editorial declaration</b>: 
            <ul><xsl:if test="tei:editorialDecl/tei:correction/tei:p/text()">
                <li>correction: 
                    <ul><xsl:for-each select="tei:editorialDecl/tei:correction/tei:p">
                        <li><xsl:apply-templates select="."/></li>
                    </xsl:for-each>
                    </ul>
                    </li>
            </xsl:if>
                <xsl:if test="tei:editorialDecl/tei:normalization/tei:p/text()">
                    <li>normalization: 
                        <ul><xsl:for-each select="tei:editorialDecl/tei:normalization/tei:p">
                            <li><xsl:apply-templates select="."/></li>
                        </xsl:for-each>
                        </ul>
                    </li>
                </xsl:if>
                <xsl:if test="tei:editorialDecl/tei:interpretation/tei:p/text()">
                    <li>interpretation: 
                        <ul><xsl:for-each select="tei:editorialDecl/tei:interpretation/tei:p">
                            <li><xsl:apply-templates select="."/></li>
                        </xsl:for-each>
                        </ul>
                    </li>
                </xsl:if>
                <xsl:if test="tei:samplingDecl/tei:p/text()">
                    <li>Text sample: 
                        <ul><xsl:for-each select="tei:samplingDecl/tei:p">
                            <li><xsl:apply-templates select="."/></li>
                        </xsl:for-each>
                        </ul>
                    </li>
                </xsl:if></ul></li>
        </ul>
         </xsl:if></div>
        </div>
    </xsl:template>
    
    <!--  fw ! -->
    <!-- <span class="fw" data-tip="Foliation">⟨left: <span class="fw-contents"><span class="num">6</span></span>⟩</span>-->
    <xsl:template match="tei:fw">
        <span class="fw" data-tip="Foliation">⟨<xsl:value-of select="@place"/>: <span class="fw-contents"><xsl:apply-templates/></span>⟩</span>
    </xsl:template>

    <!--  G ! -->
    <!-- <span class="symbol" data-tip="Punctuation symbol: double vertical bar with a hook on top of one or both bars">||</span> -->
    <!-- vérifier la stabilité des display!  -->
    <xsl:template match="tei:g">
        <xsl:variable name="type-symbol" select="@type"/>        
        <xsl:variable name="lines">
            <xsl:for-each select="tokenize($list-symbol, '\r?\n')">            <xsl:variable name="tokens" as="xs:string*" select="tokenize(., '\t+')"/>
            <xsl:choose>
                <!-- condition pour gérer l'espace; seulement un espace pris en compte pour éviter l'itération -->
                <xsl:when test="contains($tokens[1], ' ')">                       
                    <xsl:if test="substring-before($tokens[1], ' ') = $type-symbol">
                            <xsl:element name="span">
                                <xsl:attribute name="class">symbol</xsl:attribute>
                                <xsl:attribute name="data-tip">Symbol: <xsl:value-of select="$tokens[3]"/></xsl:attribute>
                                <xsl:value-of select="$tokens[2]"/>
                            </xsl:element>
                        </xsl:if>
                    <xsl:if test="substring-after($tokens[1], ' ') = $type-symbol">
                        <xsl:element name="span">
                            <xsl:attribute name="class">symbol</xsl:attribute>
                            <xsl:attribute name="data-tip">Symbol: <xsl:value-of select="$tokens[3]"/></xsl:attribute>
                            <xsl:value-of select="$tokens[2]"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$tokens[1] =$type-symbol">
                     <xsl:element name="span">
                            <xsl:attribute name="class">symbol</xsl:attribute>
                            <xsl:attribute name="data-tip">Symbol: <xsl:value-of select="$tokens[3]"/></xsl:attribute>
                            <xsl:value-of select="$tokens[2]"/>
                        </xsl:element>
                </xsl:when>
            </xsl:choose>  
            </xsl:for-each>
                    </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="@type='numeral'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="matches(., '..')">
                <span class="symbol" data-tip="Punctuation symbol: plain double vertical bar">||</span>
            </xsl:when>
            <xsl:when test="matches(., '.') and @type='danda'">
                <span class="symbol" data-tip="Punctuation symbol: plain vertical bar">|</span>
            </xsl:when>
            <xsl:when test="matches(., '.') and @type='dash'">
                <span class="symbol" data-tip="Punctuation symbol: short and quite straight horizontal line">~</span>
            </xsl:when>
            <xsl:when test="matches(., ',')">
                <span class="symbol" data-tip="Punctuation symbol"><xsl:apply-templates/></span>
            </xsl:when>
                <xsl:when test="matches(., '§')">
                <span class="symbol" data-tip="Space-filler symbol"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="matches(., 'Ø')">
                <span class="symbol" data-tip="Space-filler symbol"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@type='symbol'">
                <span class="symbol" data-tip="Symbol undocumented by the editor"><xsl:apply-templates/></span>
            </xsl:when>
           <xsl:otherwise>
               <xsl:copy-of select="$lines/span"/>
            </xsl:otherwise>
        </xsl:choose>
                     
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:choose>
            <!-- gérer dans seg -->
            <xsl:when test="parent::tei:seg"/>
            <xsl:when test="@reason='ellipsis'">
                <span class="ellipsis" data-tip="Untranslated segment">…</span>
            </xsl:when>
            <xsl:when test="@reason='omitted'"/>
            <xsl:when test="@reason='lost' and not(@quantity|@unit)"/>
            <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="@quantity and @unit and not(@unit='component')">
                    <xsl:element name="span">
                        <xsl:attribute name="class">gap</xsl:attribute>
                        <xsl:attribute name="data-tip"><xsl:if test="@precision='low'"><xsl:text>About </xsl:text></xsl:if> <xsl:value-of select="@quantity"/><xsl:text> </xsl:text><xsl:value-of select="@reason"/><xsl:if test=" @unit='character' and @quantity"><xsl:choose><xsl:when test="@quantity &gt; 1"><xsl:text> characters</xsl:text></xsl:when><xsl:otherwise> character</xsl:otherwise></xsl:choose></xsl:if><xsl:if test="@unit='line' and @quantity"><xsl:choose><xsl:when test="@quantity &gt; 1 "><xsl:text> lines</xsl:text></xsl:when><xsl:otherwise> line</xsl:otherwise></xsl:choose></xsl:if></xsl:attribute>
                    <xsl:text>[</xsl:text><xsl:if test="@precision='low'">
                    <xsl:text>ca. </xsl:text>
                    </xsl:if><xsl:value-of select="@quantity"/><xsl:if test="@unit='character'">
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
                        <xsl:if test="@unit='line'">
                            <xsl:value-of select="@reason"/>
                            <xsl:choose><xsl:when test="@quantity &gt; 1"> lines</xsl:when><xsl:otherwise> line</xsl:otherwise></xsl:choose>
                        </xsl:if><xsl:text>]</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@extent and @reason='lost' and @unit='character'">
                    <span class="gap" data-tip="Unknown number of lost characters">[…]</span>
                </xsl:when>
                <xsl:when test="@extent and @reason='illegible' and @unit='character'">
                    <span class="gap" data-tip="Unknown number of illegible characters">[…]</span>
                </xsl:when>
                <xsl:when test="@extent and @reason='undefined' and @unit='character'">
                    <span class="gap" data-tip="Unknown number of lost or illegible characters">[…]</span>
                </xsl:when>
                <xsl:when test="@extent and @reason='lost' and @unit='line'">
                    <span class="gap" data-tip="Unknown number of lost lines">[…]</span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="gap" data-tip="Unknown number of lost or illegible characters">[…]</span>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:gloss">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:idno">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- i -->
    <xsl:template match="tei:institution">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:head">
                <xsl:apply-templates/>
        <xsl:if test="following-sibling::tei:desc[1]">: </xsl:if>
    </xsl:template>
    <!--  hi ! -->
    <!-- Small caps par la CSS property! -->
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='superscript'">
                <sup class="ed-siglum"><xsl:apply-templates/></sup>
            </xsl:when>
            <xsl:when test="@rend='subscript'">
                <sub class="ed-siglum"><xsl:apply-templates/></sub> 
            </xsl:when>
            <xsl:when test="@rend='italic'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:when test="@rend='caps'">
                <span class="smallcaps"><xsl:apply-templates/></span> 
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--  L ! -->
    <!--  l ! -->
    <xsl:template match="tei:l">
        <xsl:variable name="verse-line">
            <xsl:for-each select=".">
                <xsl:variable name="context-root" select="."/>
                <xsl:variable name="verse-number" select="./@n"/>
                <xsl:choose>
                    <xsl:when test=".[parent::tei:lg/following::tei:listApp[1][@type='apparatus']/tei:app[@loc = $verse-number]] and ./parent::tei:lg/following::tei:*[1][local-name() = 'listApp']">
                        <xsl:variable name="app-context" select="parent::tei:lg/following::tei:listApp[1][@type='apparatus']/tei:app[@loc = $verse-number]"/>
                        <xsl:call-template name="search-and-replace-lemma">
                            <xsl:with-param name="input" select="$context-root"/>
                            <xsl:with-param name="search-string" select="$app-context/tei:lem"/>
                            <xsl:with-param name="replace-node" select="$app-context"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>

        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>verseline</xsl:text>
                <xsl:if test="child::tei:note">
                    <xsl:text> l-last-note-verseline</xsl:text>
                </xsl:if>
                <xsl:if test="@real">
                    <xsl:text> lem-verseline-real</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <p><xsl:choose>
                <xsl:when test="matches(@n, '\d+') and ancestor::tei:*[local-name() = ('div', 'lg')]/@met='anuṣṭubh'">
                    <xsl:element name="span">
                        <xsl:attribute name="class">lb</xsl:attribute>
                        <xsl:attribute name="data-tip">Line start</xsl:attribute>
                        <xsl:if test="@n='1' or @n='3' or @n='5' or @n='7'">
                            <xsl:text>[</xsl:text>
                            <xsl:value-of select="@n"/>
                            <xsl:text> &amp; </xsl:text>
                            <xsl:value-of select="following::tei:l[1]/@n"/>
                            <!-- not display for even-->
                            <xsl:text>]  </xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="matches(@n, '\d+') and not(ancestor::tei:*[local-name() = ('div', 'lg')]/@met='anuṣṭubh')">
                    <xsl:element name="span">
                        <xsl:attribute name="class">lb</xsl:attribute>
                        <xsl:attribute name="data-tip">Line start</xsl:attribute>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="@n"/>
                        <xsl:text>] </xsl:text>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
                <xsl:copy-of select="$verse-line"/><xsl:if test="@enjamb='yes'">-</xsl:if></p>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:l[@real][not(child::tei:note=last())]" mode="modals">
        <xsl:variable name="apparatus-unmetrical">
            <xsl:if test="self::tei:l[@real]">
                    <span class="mb-1 lemma-line">
                        <span class="fake-lem">
                          <xsl:call-template name="fake-lem-making"/>
                        </span>
                        <xsl:element name="hr"/>
                        <xsl:text>Unmetrical line. The observed pattern is not </xsl:text>
                        <i>
                            <xsl:value-of select="ancestor::tei:*[@met][1]/@met"/>
                            <xsl:call-template name="metrical-list">
                                <xsl:with-param name="metrical" select="ancestor::tei:*[@met][1]/@met"/>
                                <xsl:with-param name="line-context" select="'real'"/>
                            </xsl:call-template>
                        </i>
                        <xsl:text> but </xsl:text>
                        <span class="prosody"><xsl:value-of select="translate(@real, '-=+', '⏑⏓–')"/></span><xsl:text>.</xsl:text>
                    </span>
                
            </xsl:if>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-unmetrical"/>
        </span>
    </xsl:template>

    <xsl:template name="search-and-replace-lemma">
        <xsl:param name="input"/>
        <xsl:param name="search-string"/>
        <xsl:param name="replace-node"/>
        <xsl:choose>
            <xsl:when test="$search-string">
                <xsl:apply-templates select="substring-before($input, $search-string[1])"/>
                <xsl:apply-templates select="$replace-node[tei:lem = $search-string[1]]"/>

                <xsl:if test="substring-after($input, $search-string[1])">
                    <xsl:call-template name="search-and-replace-lemma">
                        <xsl:with-param name="input"
                            select="substring-after($input, $search-string[1])"/>
                        <xsl:with-param name="search-string"
                            select="$search-string[position() != 1]"/>
                        <xsl:with-param name="replace-node"
                            select="$replace-node"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <!-- There are no more occurences of the search string so
                    just return the current input string -->
                <xsl:apply-templates select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- lacunaEnd & lacunaStart -->
    <!-- span - modals -->
    <xsl:template match="tei:lacunaStart" mode="modals">
        <xsl:variable name="wit-lost" select="self::tei:lacunaStart/parent::tei:*[1]/@wit"/>
        <xsl:variable name="apparatus-lost">
            <span class="mb-1 lemma-line modal-omissionStart">
                <span class="fake-lem">
                    <xsl:apply-templates select="self::tei:lacunaStart/parent::tei:*[@wit = $wit-lost]/preceding::tei:lem[1]"/>
                    <xsl:text> &#8230; </xsl:text>
                    <xsl:if test="self::tei:lacunaStart[not(ancestor::tei:app/ancestor::tei:*[1][descendant::tei:lacunaEnd])]">
                        <xsl:text> (</xsl:text>
                            <b><xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text><xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][child::tei:lacunaEnd][1]/ancestor::tei:div[1]/@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][child::tei:lacunaEnd][1]/ancestor::tei:div[1]/@n"/>
                                <xsl:if test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:*[1][local-name ()= ('lg', 'ab', 'p')]">
                                    <xsl:text>.</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:lg[1]">
                                            <xsl:number count="tei:lg" format="1" level="multiple"/>
                                        </xsl:when>
                                        <xsl:when test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:ab[1][not(child::tei:supplied)]">
                                            <xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:ab[1][not(child::tei:supplied)]/position()"/>
                                        </xsl:when>
                                        <xsl:when test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:p[1]">
                                            <xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:p[1]/position()"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:element></b>
                        <xsl:text>) </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][child::tei:lacunaEnd][1]/preceding::tei:lem[1]"/>
                </span>
                <hr/>
                <span class="note-line">
                    <!--<xsl:attribute name="style">color:black;</xsl:attribute>-->
                    <xsl:text>A gap due to loss intervenes in </xsl:text>
                        <b><xsl:call-template name="tokenize-witness-list">
                            <xsl:with-param name="string" select="self::tei:lacunaStart/parent::tei:rdg[@wit = $wit-lost][1]/@wit"/>
                        </xsl:call-template></b>
                    
                    <xsl:if test="self::tei:lacunaStart/parent::tei:rdg[@wit = $wit-lost]/@cause">
                        <xsl:text> caused by </xsl:text>
                        <xsl:value-of select="self::tei:lacunaStart/parent::tei:rdg[@wit = $wit-lost]/@cause"/>
                    </xsl:if>
                    <xsl:text>.</xsl:text>
                </span>
            </span>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-lost"/>
        </span>
    </xsl:template>

    <xsl:template match="tei:label">
                <b><xsl:apply-templates/></b>
    </xsl:template>
    
    <!--  lb ! -->
    <!-- <span class="lb" data-tip="Line start">⟨1r5⟩</span> -->
    <!-- <span class="hyphen-break" data-tip="Hyphen break">-</span> -->
    <!-- updated -->
    <xsl:template match="tei:lb">
        <xsl:if test="@break='no'"><span class="hyphen-break" data-tip="Hyphen break">-</span></xsl:if>
        <xsl:choose>
            <xsl:when test="$edition-type='critical'"/>
            <xsl:otherwise>
                <xsl:call-template name="lbrk-app"/>
            </xsl:otherwise>
        </xsl:choose>
        <span class="lb" data-tip="Line Start">⟨<xsl:choose><xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when><xsl:otherwise>lb</xsl:otherwise></xsl:choose>⟩</span>
            </xsl:template>
    
    <xsl:template match="tei:lg[not(ancestor::tei:rdg)]">
        <xsl:variable name="textpart-id" select="@xml:id"/>
        <xsl:variable name="metrical">
            <xsl:choose>
                <xsl:when test="@rend='met'"><xsl:value-of select="@met"/></xsl:when>
                <xsl:when test="parent::tei:div[@type='metrical'][1]/@rend='met'"><xsl:value-of select="parent::tei:div[@type='metrical']/@met"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- condition pour éviter le bruit généré par les base-text -->
        <xsl:if test="not(parent::tei:quote[@type='base-text'])">  
            <h6 class="ed-heading">
                        <xsl:if test="@n">
                            <xsl:number format="I" value="@n"/>.
                        </xsl:if>               
                <xsl:if test="@rend='met' or parent::tei:div[@type='metrical'][1]/@rend='met'">
                    <xsl:call-template name="metrical-list">
                        <xsl:with-param name="metrical" select="$metrical"/>
                    </xsl:call-template>
                </xsl:if> 
        </h6></xsl:if>
        <div class="row">
            <div class="col-10 text-col">                
                       <xsl:call-template name="lg-content"/>
                       <xsl:call-template name="lbrk-app"/>
            </div>    
        <xsl:if test="descendant-or-self::tei:app and not(parent::tei:p) or following-sibling::tei:*[1][local-name() ='listApp'][@type='apparatus'] or ancestor::tei:app"> <!-- not(ancestor::tei:quote[@type='base-text']) or -->
            <xsl:call-template name="launch-app"/>          
        </xsl:if>
        </div>
        <xsl:if test="//tei:div[@type='translation']/descendant-or-self::tei:*[substring-after(@corresp, '#') = $textpart-id]"><xsl:call-template name="translation-button">
            <xsl:with-param name="textpart-id" select="$textpart-id "/>
        </xsl:call-template></xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:lg[ancestor::tei:rdg]">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template name="lg-content">
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>verse</xsl:text>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:if test="contains(@met, 'free') or contains(parent::tei:div[@type='metrical']/@met, 'free')">
        </xsl:if>
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

    <xsl:template match="tei:listApp[@type = 'apparatus']"/>

    <xsl:template match="tei:listApp[@type='parallels']">
        <div class="row">
            <div class="col-10 text-col">
                    <xsl:if test="descendant::tei:note">
                        <a class="btn btn-outline-dark btn-block" data-toggle="collapse" href="#{generate-id()}" role="button" aria-expanded="false" aria-controls="{generate-id()}"><span class="smallcaps">Parallels</span></a>
                        <div id="{generate-id()}" class="collapse">                    
                            <div class="card-body">
                        <xsl:call-template name="parallels-content"/>
                    </div>
                </div>
        </xsl:if>
       </div>
        </div>
        <xsl:call-template name="lbrk-app"/>
    </xsl:template>

    <!--  listBibl -->
    <xsl:template match="tei:listBibl">
        <div class="ed-section"><xsl:apply-templates/></div>
    </xsl:template>

    <!--  listWit ! -->
    <xsl:template match="tei:listWit">
        <xsl:apply-templates/>
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
    
    <xsl:template match="tei:milestone">
        <!-- <span class="pagelike" data-tip="Zone start">⟨Zone A⟩</span> -->
        <span class="pagelike" datatip="{@unit} {@n}">⟨<xsl:value-of select="@unit"/><xsl:text> </xsl:text><xsl:value-of select="@n"/>⟩</span>
    </xsl:template>
    
    <!--  N ! -->
    <!--  name ! -->
    <xsl:template match="tei:name">
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="generate-trans-link">
        <xsl:param name="situation"/>
        <xsl:variable name="trans-num">
            <xsl:number level="any" count="//tei:note[ancestor::tei:div[@type='translation']]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$situation = 'text'">
                <a href="#to-trans-num-{$trans-num}" id="from-trans-num-{$trans-num}">
                    <span class="tooltip-notes">
                        <sup>↓<xsl:value-of select="$trans-num"/></sup>
                    </span>
                </a>
            </xsl:when>
            <xsl:when test="$situation = 'apparatus-internal'">
                <a id="no-fonctional-trans-num-{$trans-num}" href="#from-trans-num-{$trans-num}">↑<xsl:value-of select="$trans-num"/>. </a>
            </xsl:when>
            <xsl:when test="$situation = 'apparatus-bottom'">
                <a id="to-trans-num-{$trans-num}" href="#from-trans-num-{$trans-num}">^<xsl:value-of select="$trans-num"/>. </a>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:div[@type='translation']">
                <xsl:call-template name="generate-trans-link">
                    <xsl:with-param name="situation" select="'text'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="self::tei:note[parent::tei:p or parent::tei:lg or parent::tei:l][position() = last()] or self::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]"/>
                        <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:note" mode="modals">
        <xsl:variable name="apparatus-note">
            <xsl:if test="self::tei:note[position() = last()][not(@type='parallels' or parent::tei:app or @type='altLem')][parent::tei:p or parent::tei:lg or parent::tei:l] or self::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]">
                <span class="mb-1 lemma-line note-line">
                        <span class="fake-lem">
                        <xsl:call-template name="fake-lem-making"/>
                        </span>
                        <xsl:element name="hr"/>
                        <xsl:for-each select="self::tei:note">
                            <span class="note-line">
                                <xsl:apply-templates/>
                            </span>
                        </xsl:for-each>
                    </span>
            </xsl:if>
        </xsl:variable>
       <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-note"/>
        </span>
    </xsl:template>
    
    <!-- num -->
    <xsl:template match="tei:num">
        <span class="num"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:orig[not(parent::tei:choice)]">
        <span class="orig standalone" data-tip="Non-standard text">¡<xsl:apply-templates/>!</span>
    </xsl:template>

    <!--  P ! -->
    <!--  p ! -->
    <xsl:template match="tei:p">
        <xsl:variable name="textpart-id" select="@xml:id"/>
        <xsl:variable name="p-line">
            <xsl:for-each select=".">
                <xsl:variable name="context-root" select="."/>
                <xsl:choose>
                    <xsl:when test=".[following::tei:listApp[1][@type='apparatus']/tei:app] and ./following::tei:*[1][local-name() = 'listApp']">
                        <xsl:variable name="app-context" select="following::tei:listApp[1][@type='apparatus']/tei:app"/>
                        <xsl:call-template name="search-and-replace-lemma">
                            <xsl:with-param name="input" select="$context-root"/>
                            <xsl:with-param name="search-string" select="$app-context/tei:lem"/>
                            <xsl:with-param name="replace-node" select="$app-context"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>              
        <xsl:choose>
            <!-- special display pour le premier paragraphe dans dans les éléments du teiHeader -->
            <xsl:when test="not(ancestor-or-self::tei:text/tei:body/tei:div[@type='edition'])">
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::tei:p) = 0">
                        <span><xsl:apply-templates/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <p><xsl:apply-templates/></p>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:div[@type='bibliography']">
                <p><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test=".[ancestor-or-self::tei:div[@type='translation']]">
                <xsl:choose>
                    <xsl:when test="@rend='stanza'">
                        <xsl:if test="@n">
                            <h6 class="ed-heading">
                                <xsl:number format="I" value="@n"/>.</h6>
                        </xsl:if>  
                        <div class="verse"><xsl:apply-templates/></div>
                    </xsl:when>
                    <xsl:otherwise>
                        <p><xsl:if test="@n">
                            <span class="lb" data-tip="Line start">⟨<xsl:value-of select="@n"/>⟩</span>
                        </xsl:if>
                            <xsl:apply-templates/></p>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <div class="row">
                <div class="col-10 text-col">
                    <p><xsl:if test="@n">
                        <b class="lb" data-tip="Paragraph number">§<xsl:value-of select="@n"/><xsl:text> </xsl:text></b></xsl:if>
                        <xsl:copy-of select="$p-line"/></p>
                </div>
                <xsl:call-template name="launch-app"/>
                </div>
        <xsl:if test="//tei:div[@type='translation']/descendant-or-self::tei:*[substring-after(@corresp, '#') = $textpart-id]"><xsl:call-template name="translation-button">
            <xsl:with-param name="textpart-id" select="$textpart-id "/>
        </xsl:call-template></xsl:if></xsl:otherwise></xsl:choose>
    </xsl:template>

    <!--  pb ! -->    
    <xsl:template match="tei:pb">
        <xsl:choose>
            <!--<xsl:when test="ancestor-or-self::tei:lem|ancestor-or-self::tei:rdg and $edition-type='critical'"/>-->
            <xsl:when test="tei:pb[not(preceding::node()/text())] and $edition-type='diplomatic'"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$edition-type='diplomatic'">
                        <xsl:call-template name="lbrk-app"/>
                        <span class="pagelike" data-tip="Page start" id="{@xml:id}">
                            <xsl:text>⟨</xsl:text>
                                <xsl:if test="count(//tei:witness) gt 1"><xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="@edRef"/>
                                <xsl:with-param name="witdetail-string"/>
                                <xsl:with-param name="witdetail-type"/>
                                <xsl:with-param name="witdetail-text"/>
                                <xsl:with-param name="tpl" select="'content-pb'"/>
                            </xsl:call-template> 
                            <xsl:text>: </xsl:text>
                                    </xsl:if>
                                <xsl:text>Folio </xsl:text>
                            <xsl:value-of select="@n"/>
                            <xsl:text>⟩</xsl:text>
                        </span>
                       </xsl:when>
                    <xsl:when test="$edition-type='critical'">
                        <span class="pagelike" data-tip="Page start">
                            <xsl:text>⟨</xsl:text>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="@edRef"/>
                                <xsl:with-param name="witdetail-string"/>
                                <xsl:with-param name="witdetail-type"/>
                                <xsl:with-param name="witdetail-text"/>
                                <xsl:with-param name="tpl" select="'content-pb'"/>
                            </xsl:call-template> 
                            <xsl:text>: </xsl:text>
                            <xsl:value-of select="@n"/>
                            <xsl:text>⟩</xsl:text>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  pc ! -->
    <!-- deleted -->
    
    <!-- persName -->
    <xsl:template match="tei:persName">
        <xsl:apply-templates select="tei:forename"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="tei:surname"/>
    </xsl:template>

    <!-- ptr -->
    <xsl:template match="tei:ptr[not(parent::tei:bibl)]">
        <xsl:variable name="MSlink" select="@target"/>
        <xsl:variable name="rendcontent" select="@rend"/>
            <xsl:choose>
                <xsl:when test="contains($MSlink, ' ')">
                    <xsl:variable name="first-item"
                        select="normalize-space(substring-before($MSlink, ' '))"/>
                    <xsl:if test="$first-item">
                        <xsl:call-template name="content-ptr">
                            <xsl:with-param name="MSlink" select="$first-item"/>
                            <xsl:with-param name="rendcontent" select="$rendcontent"/>
                        </xsl:call-template>
                        <xsl:call-template name="content-ptr">
                            <xsl:with-param name="MSlink" select="substring-after($MSlink, ' ')"/>
                            <xsl:with-param name="rendcontent" select="$rendcontent"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="content-ptr">
                          <xsl:with-param name="MSlink" select="$MSlink"/>
                          <xsl:with-param name="rendcontent" select="$rendcontent"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template name="launch-app">
        <xsl:param name="context-diplomatic-app"/>
        <div class="col-2 apparat-col text-center">
            <xsl:choose>
                <xsl:when test="$edition-type='diplomatic'">
                    <!-- difference pour ajouter les choice et les subst? to be added -->
                    <xsl:for-each select="descendant-or-self::tei:app[not(parent::tei:listApp) or not(@rend='hide')] | descendant-or-self::tei:note[last()][parent::tei:p or parent::tei:lg]">
                        <xsl:call-template name="app-link">
                            <xsl:with-param name="location" select="'apparatus'"/>
                            <xsl:with-param name="type">
                                <xsl:choose>
                                    <xsl:when test="self::tei:note[position() = last()][parent::tei:p] and not(ancestor::tei:div[@type='translation'])">
                                        <xsl:text>lem-last-note</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="self::tei:note[ancestor::tei:div[@type='translation']]">
                                        <xsl:text>trans-note</xsl:text></xsl:when>
                                        <xsl:when test="self::tei:choice[child::tei:sic and child::tei:corr]">
                                            <xsl:text>siccorr</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise><xsl:for-each select="descendant::tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])] |descendant::tei:span[@type='omissionStart'] | descendant::tei:lacunaStart | descendant::tei:span[@type='reformulationStart'] | descendant::tei:note[position() = last()][not(@type='parallels' or parent::tei:app or @type='altLem')][parent::tei:p or parent::tei:lg or parent::tei:l] | descendant::tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]">
                <xsl:call-template name="app-link">
                    <xsl:with-param name="location" select="'apparatus'"/>
                    <xsl:with-param name="type">
                        <xsl:choose>
                            <xsl:when test="self::tei:app/descendant::tei:span[@type='omissionStart']">
                                <xsl:text>lem-omissionStart</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:app/descendant::tei:span[@type='omissionEnd']">
                                <xsl:text>lem-omissionEnd</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:app/descendant::tei:lacunaStart">
                                <xsl:text>lem-lacunaStart</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:app/descendant::tei:lacunaEnd">
                                <xsl:text>lem-lacunaEnd</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:span[@type='reformulationStart']">
                                <xsl:text>lem-reformulationStart</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:span[@type='reformulationEnd']">
                                <xsl:text>lem-reformulationEnd</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:app/descendant::tei:lacunaStart">
                                <xsl:text>lem-lacunaStart</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:app/descendant::tei:lacunaEnd">
                                <xsl:text>lem-lacunaEnd</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:note[position() = last()][parent::tei:p] and not(ancestor::tei:div[@type='translation'])">
                                <xsl:text>lem-last-note</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:note[ancestor::tei:div[@type='translation']]">
                                <xsl:text>trans-note</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:for-each></xsl:otherwise></xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="content-ptr">
        <xsl:param name="MSlink"/>
        <xsl:param name="rendcontent"/>
        <xsl:variable name="rootHand" select="//tei:handDesc"/>
        
               <xsl:choose>
                   <xsl:when test="contains($MSlink, 'txt:')">
                       <xsl:variable name="MSlink-part" select="substring-after($MSlink, 'txt:')"/>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink-part]/child::tei:ptr[1]/@target"/></xsl:attribute>
                            <xsl:if test="$rendcontent= 'title'"><xsl:attribute name="class">font-italic</xsl:attribute></xsl:if>
                            <xsl:if test="$rendcontent= 'siglum'"><xsl:attribute name="class">font-weight-bold</xsl:attribute></xsl:if>
                            <xsl:choose>
                                <xsl:when test="$rendcontent= 'siglum'">
                            <xsl:apply-templates select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink-part]/child::tei:abbr[@type='siglum']"/></xsl:when>
                                <xsl:when test="$rendcontent= 'title'">
                                    <xsl:apply-templates select="document($IdListTexts)//tei:bibl[@xml:id=$MSlink-part]/child::tei:title"/></xsl:when>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:when>
                   <xsl:when test="contains($MSlink, 'bib:')">
                       <xsl:call-template name="source-siglum">
                           <xsl:with-param name="string-to-siglum" select="substring-after($MSlink, 'bib:')"/>
                       </xsl:call-template>
                   </xsl:when>
                   <xsl:when test="contains($MSlink, $edition-id)">
                       <xsl:variable name="targetLink" select="substring-after($MSlink, '#')"/>
                      
                       <a href="{$MSlink}">
                           <b><xsl:choose>
                               <xsl:when test="//tei:*[@xml:id =$targetLink][local-name() ='div']/@type">
                                   <xsl:value-of select="//tei:*[@xml:id =$targetLink]/@type"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:value-of select="//tei:*[@xml:id =$targetLink]/@n"/>
                               </xsl:when>
                               <xsl:when test="//tei:*[@xml:id =$targetLink][local-name() ='p']">
                                  
                                   <xsl:if test="//tei:*[@xml:id =$targetLink][local-name() ='p'][ancestor::tei:div[@type = 'chapter'][1] and not(ancestor::tei:div[@type = 'dyad' or @type ='interpolation' or @type='metrical' or @type='section'])]">
                                       <xsl:value-of select="//tei:*[@xml:id =$targetLink][local-name() ='p']/ancestor::tei:div[@type = 'chapter']/@n"/>
                                       <xsl:text>.</xsl:text>
                                   </xsl:if>
                                   <xsl:if test="//tei:*[@xml:id =$targetLink][local-name() ='p'][parent::tei:div[@type = 'dyad']]">
                                       <xsl:value-of select="//tei:*[@xml:id =$targetLink][local-name() ='p']/parent::tei:div[@type = 'dyad']/@n"/>
                                       <xsl:text>.</xsl:text>
                                   </xsl:if>
                                   <xsl:if test="//tei:*[@xml:id =$targetLink][local-name() ='p'][parent::tei:div[@type = 'liminal']]">
                                       <xsl:value-of select="//tei:*[@xml:id =$targetLink][local-name() ='p']/parent::tei:div[@type = 'liminal']/@n"/>
                                       <xsl:text>.</xsl:text>
                                   </xsl:if>
                                   <xsl:if test="//tei:*[@xml:id =$targetLink][local-name() ='p'][ancestor-or-self::tei:div[@type = 'interpolation']]">
                                       <xsl:choose>
                                           <xsl:when test="//tei:*[@xml:id =$targetLink][local-name() ='p']/ancestor-or-self::tei:div[@type = 'interpolation']/@n">
                                               <xsl:value-of select="//tei:*[@xml:id =$targetLink][local-name() ='p']/ancestor-or-self::tei:div[@type = 'interpolation']/@n"/>
                                               <xsl:text>.</xsl:text>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:value-of select="//tei:*[@xml:id =$targetLink][local-name() ='p']/ancestor-or-self::tei:div[@type = 'interpolation']/preceding::tei:div[not(@type='metrical'or @type='section')][1]/@n"/>
                                               <xsl:text>*.</xsl:text>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                   </xsl:if>
                                   <xsl:value-of select="(count(//tei:*[@xml:id =$targetLink][local-name() ='p']/preceding-sibling::tei:p) + 1)" />
                               </xsl:when>
                               <xsl:when test="//tei:*[@xml:id =$targetLink][local-name() ='lg']">
                                   <xsl:text>stanza </xsl:text>
                                   <xsl:number level="any" format="1" count="tei:lg"/>
                               </xsl:when>
                                <xsl:otherwise>
                                   <xsl:text>Issue in the code</xsl:text>
                               </xsl:otherwise>
                           </xsl:choose></b>
                       </a>
                   </xsl:when>
                   <xsl:when test="contains($MSlink, '_H')">
                       <xsl:variable name="hand-id" select="substring-after($MSlink, '#')"/>
                       <xsl:apply-templates select="$rootHand/tei:handNote[@xml:id = $hand-id]/tei:abbr"/>
                    </xsl:when>
                   <xsl:otherwise>
                       <b><xsl:call-template name="tokenize-witness-list">
                           <xsl:with-param name="string" select="$MSlink"/>
                           <xsl:with-param name="tpl" select="'content-ptr'"/>
                       </xsl:call-template></b>          
                   </xsl:otherwise>
                </xsl:choose>
    </xsl:template>

    <!--  Q ! -->
    <!--  q ! -->
    <!-- to be checked -->
    <xsl:template match="tei:q">
        <xsl:choose>
            <xsl:when test="@rend='block'">
                <span class="qblock"><xsl:apply-templates/></span>
            </xsl:when>
        <xsl:otherwise>
            <span class="q">‘<xsl:apply-templates/>’</span>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  quote ! -->
    <!-- to be updated -->
    <xsl:template match="tei:quote">
        <xsl:choose>
            <xsl:when test="tei:quote[@type = 'base-text']">
                <div class="basetext" id="{@xml:id}"><xsl:apply-templates/></div>
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
                <span class="qblock"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@type='normalized' or @type='diplomatic'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:when test="@type='translation'">
                <xsl:text>‘</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>’</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  R ! -->
    <!-- to be done -->
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="$viz-context='github'">
                <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:choose>
                    <!-- link to the epigraphy -->
                    <!-- https://dharmalekha.info/texts/INSIDENKAbhayananda -->
                    <xsl:when test="matches(@target, 'DHARMA_INSIDENK')">
                        <xsl:variable name="target-match" select="substring-before(substring-after(@target, 'DHARMA_'), '.xml')"/>
                        <xsl:value-of select="concat('https://dharmalekha.info/texts/', $target-match)"/>
                    </xsl:when>
                    <xsl:when test="matches(@target,'DHARMA_CritEd') or matches(@target,'DHARMA_DiplEd')">
                        <xsl:value-of select="replace(concat('https://erc-dharma.github.io/tfd-nusantara-philology/output/critical-edition/html/', @target), '.xml#', '.html#')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@target"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
                    <xsl:apply-templates/>
        </xsl:element>
            </xsl:when>
            <!-- conditions pour le système de Michaël -->
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                <xsl:choose>
                    <!-- une règle pour tous les cas de figures dans la DB -->
                    <!-- à vérifier, une fois implémenter -->
                    <xsl:when test="matches(@target, 'DHARMA_')">
                        <xsl:variable name="target-match" select="substring-before(substring-after(@target, 'DHARMA_'), '.xml')"/>
                        <xsl:value-of select="concat('https://dharmalekha.info/texts/', $target-match)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@target"/>
                    </xsl:otherwise>
 </xsl:choose>
                    </xsl:attribute>

                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!--  S ! -->
    <!--  s ! -->
    <xsl:template match="tei:said">
        <span class="said" id="{@xml:id}">‘<xsl:apply-templates/>’</span>
    </xsl:template>   

    <!--  seg ! -->
    <xsl:template match="tei:seg">
        <xsl:choose>
            <xsl:when test="@rend='pun'">
                <span class="pun" data-tip="Pun (&lt;i&gt;ślesa&lt;/i&gt;)">{<xsl:apply-templates/>}</span>
            </xsl:when>
            <xsl:when test="@type='highlight'">
                <b><xsl:apply-templates/></b>
            </xsl:when>
            <xsl:when test="@type='interpolation'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='aksara'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='component' and child::tei:gap">
                <xsl:element name="span">
                    <xsl:attribute name="class">gap</xsl:attribute>
                    <xsl:attribute name="data-tip">
                        <xsl:value-of select="child::tei:gap/@quantity"/><xsl:text> </xsl:text><xsl:value-of select="child::tei:gap/@reason"/><xsl:text> </xsl:text><xsl:choose>
                            <xsl:when test="child::tei:gap/@quantity &gt; 1">characters</xsl:when><xsl:otherwise>character</xsl:otherwise>
                        </xsl:choose><xsl:text> component</xsl:text>
                    </xsl:attribute>
                    [<xsl:value-of select="functx:repeat('.', child::tei:gap/@quantity)"/>]
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type='component' and not(child::tei:gap)"><xsl:apply-templates/></xsl:when>
            <xsl:when test="@met and child::tei:gap">
                <span class="gap" data-tip="{child::tei:gap/@quantity} {child::tei:gap/@reason} characters">[<xsl:call-template name="metrical-list"><xsl:with-param name="metrical" select="@met"/></xsl:call-template>]</span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- i -->
    <xsl:template match="tei:settlement">
        <xsl:apply-templates/>
    </xsl:template>
    

    <!--  sic ! -->
    <!-- to verify  -->
    <xsl:template match="tei:sic[not(parent::tei:choice)]">
        <span class="sic standalone" data-tip="Incorrect text">¿<xsl:apply-templates/>?</span>
    </xsl:template>

    <!--  sp ! -->
    <xsl:template match="tei:sp">
        <div class="row sp">
            <div class="col-sm-3"><xsl:apply-templates mode="bypass" select="tei:speaker"/></div>
                <div class="col-sm-9"><xsl:apply-templates/></div>
        </div>
    </xsl:template>
    
    <!--  speaker ! -->
    <xsl:template match="tei:speaker"/>
    <xsl:template match="tei:speaker" mode="bypass">
        <span class="speaker"><xsl:apply-templates/></span>
    </xsl:template>

    <!--  stage ! -->
    <!--  case one: it is not contained within a character’s
       lines ! -->
    <xsl:template match="tei:stage[not(ancestor::tei:sp)]">
        <div class="row">
            <div class="col-sm-12 clearfix">
                <p class="stage text-center"><xsl:apply-templates/></p>
            </div>
        </div>
    </xsl:template>

    <!--  case two: it is contained within a characters’ lines ! -->
    <xsl:template match="tei:sp//tei:stage">
        <span class="stage stage-sp"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:stage" mode="in-modal">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <!-- space ! -->
    <!-- <span class="space" data-tip="Large vacat space (about 34 characters wide)">__________________________________</span> -->
    <!-- <space type="vacat" quantity="8" unit="character"/> -->
    <xsl:template match="tei:space">
        <xsl:choose>
            <xsl:when test="@type='binding-hole'"><span class="space" data-tip="Space left blank: binding-hole">◯</span></xsl:when>
            <xsl:when test="@type='vacat'">
                <span class="space" data-tip="Vacat space (about {@quantity} characters wide)"><xsl:value-of select="functx:repeat('_', @quantity)"/></span>
            </xsl:when>
            <xsl:when test="@type='unclassified'">
                <span class="space" data-tip="unclassified space (about {@quantity} characters wide)"><xsl:value-of select="functx:repeat('_', @quantity)"/></span>
            </xsl:when>
            <xsl:when test="@quantity &lt; 3">
                <span class="space" data-tip="Small semantic space (from barely noticeable to less than two average character widths in extent)"><xsl:value-of select="functx:repeat('_', @quantity)"/></span>
            </xsl:when>
            <xsl:when test="@quantity &gt; 2">
                <span class="space" data-tip="Vacat space (about {@quantity} characters wide)"><xsl:value-of select="functx:repeat('_', @quantity)"/></span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="omission-content">
        <xsl:variable name="wit-omission" select="self::tei:span[@type='omissionStart']/parent::tei:*[1]/@wit"/>
        <xsl:if test="self::tei:span[@type='omissionStart']">
                    <xsl:element name="span">
                        <xsl:attribute name="class">fake-lem</xsl:attribute>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/parent::tei:*[@wit = $wit-omission]/preceding::tei:lem[1]"/>
                        <xsl:text> &#8230;</xsl:text>
                        <xsl:if test="self::tei:span[@type='omissionStart'][not(ancestor::tei:app/ancestor::tei:*[1][descendant::tei:span[@type='omissionEnd']])]">
                            <xsl:text> (</xsl:text>
                            <xsl:element name="span">
                            <xsl:attribute name="class">font-weight-bold</xsl:attribute>
                                <!--<xsl:text>§</xsl:text>-->
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:text>#</xsl:text><xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][child::tei:span[@type='omissionEnd']][1]/ancestor::tei:div[1]/@xml:id"/>
                            </xsl:attribute>
                            <xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][child::tei:span[@type='omissionEnd']][1]/ancestor::tei:div[1]/@n"/>
                            <xsl:if test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:*[1][local-name ()= ('lg', 'ab', 'p')]">
                                <xsl:text>.</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:lg[1]">
                                        <!--<xsl:value-of select="functx:substring-after-last(self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:lg[1]/@xml:id,'.0')"/>-->
                                        <xsl:number count="tei:lg" format="1" level="multiple"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:ab[1][not(child::tei:supplied)]">
                                        <xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:ab[1]/position()"/>

                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:p[1]">
                                        <xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:p[1]/position()"/>
                                 </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:element>
                            </xsl:element>
                        <xsl:text>) </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][child::tei:span[@type='omissionEnd']][1]/preceding::tei:lem[1]"/>
                        <b>]</b>
                        <xsl:text> A gap due to omission intervenes in </xsl:text>
                        <b><xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="self::tei:span[@type='omissionStart']/parent::tei:rdg[@wit = $wit-omission][1]/@wit"/>
                            </xsl:call-template>
                        </b>
                        <xsl:if test="self::tei:span[@type='omissionStart']/parent::tei:rdg[@wit = $wit-omission]/@cause">
                            <xsl:text> caused by </xsl:text>
                            <xsl:value-of select="self::tei:span[@type='omissionStart']/parent::tei:rdg[@wit = $wit-omission]/@cause"/>
                        </xsl:if>
                        <xsl:text>.</xsl:text>
                    </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="lost-content">
        <xsl:variable name="wit-lost" select="self::tei:lacunaStart/parent::tei:*[1]/@wit"/>
        <xsl:if test="self::tei:lacunaStart">
            <span class="fake-lem">
                <xsl:apply-templates select="self::tei:lacunaStart/parent::tei:*[@wit = $wit-lost]/preceding::tei:lem[1]"/>
                <xsl:text> &#8230;</xsl:text>
                <xsl:if test="self::tei:lacunaStart[not(ancestor::tei:app/ancestor::tei:*[1][descendant::tei:lacunaEnd])]">
                    <xsl:text> (</xsl:text>
                    <b><a href="#{self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][child::tei:lacunaEnd][1]/ancestor::tei:div[1]/@xml:id}">
                            <xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][child::tei:lacunaEnd][1]/ancestor::tei:div[1]/@n"/>
                            <xsl:if test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:*[1][local-name ()= ('lg', 'ab', 'p')]">
                                <xsl:text>.</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:lg[1]">
                                        <xsl:number count="tei:lg" format="1" level="multiple"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:ab[1][not(child::tei:supplied)]">
                                        <xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:ab[1][not(child::tei:supplied)]/position()"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:p[1]">
                                        <xsl:value-of select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][tei:lacunaEnd][1]/ancestor::tei:app/parent::tei:p[1]/position()"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </a>
                    </b>
                    <xsl:text>) </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="self::tei:lacunaStart/following::tei:*[@wit = $wit-lost][child::tei:lacunaEnd][1]/preceding::tei:lem[1]"/>
                <b>]</b>
                <xsl:text> A gap due to loss intervenes in </xsl:text>
                <b><xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="self::tei:lacunaStart/parent::tei:rdg[@wit = $wit-lost][1]/@wit"/>
                    </xsl:call-template>
                </b>
                <xsl:if test="self::tei:lacunaStart/parent::tei:rdg[@wit = $wit-lost]/@cause">
                    <xsl:text> caused by </xsl:text>
                    <xsl:value-of select="self::tei:lacunaStart/parent::tei:rdg[@wit = $wit-lost]/@cause"/>
                </xsl:if>
                <xsl:text>.</xsl:text>
            </span>
        </xsl:if>
    </xsl:template>

    <!-- span - modals -->
    <xsl:template match="tei:span[@type='omissionStart']" mode="modals">
        <xsl:variable name="wit-omission" select="self::tei:span[@type='omissionStart']/parent::tei:*[1]/@wit"/>
        <xsl:variable name="apparatus-omission">
            <span class="mb-1 lemma-line modal-omissionStart">
                <span class="fake-lem">
                            <xsl:apply-templates select="self::tei:span[@type='omissionStart']/parent::tei:*[@wit = $wit-omission]/preceding::tei:lem[1]"/>
                        <xsl:text> &#8230;</xsl:text>
                        <xsl:if test="self::tei:span[@type='omissionStart'][not(ancestor::tei:app/ancestor::tei:*[1][descendant::tei:span[@type='omissionEnd']])]">
                            <xsl:text> (</xsl:text>
                        <b>
                            <a href="#{self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][child::tei:span[@type='omissionEnd']][1]/ancestor::tei:div[1]/@xml:id}">
                            <xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][child::tei:span[@type='omissionEnd']][1]/ancestor::tei:div[1]/@n"/>
                            <xsl:if test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:*[1][local-name ()= ('lg', 'ab', 'p')]">
                                <xsl:text>.</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:lg[1]">
                                        <xsl:number count="tei:lg" level="multiple" format="1"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:ab[1][not(child::tei:supplied)]">
                                        <xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:ab[1]/position()"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:p[1]">
                                        <xsl:value-of select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][tei:span[@type='omissionEnd']][1]/ancestor::tei:app/parent::tei:p[1]/position()"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                    </a>
                        </b>
                        <xsl:text>) </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="self::tei:span[@type='omissionStart']/following::tei:*[@wit = $wit-omission][child::tei:span[@type='omissionEnd']][1]/preceding::tei:lem[1]"/>
                    </span>
                    <hr/>
                <span class="note-line">                           
                        <xsl:text>A gap due to omission intervenes in</xsl:text>
                            <b><xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="self::tei:span[@type='omissionStart']/parent::tei:rdg[@wit = $wit-omission][1]/@wit"/>
                                </xsl:call-template>
                            </b>
                            <xsl:if test="self::tei:span[@type='omissionStart']/parent::tei:rdg[@wit = $wit-omission]/@cause">
                            <xsl:text> caused by </xsl:text>
                                <xsl:value-of select="self::tei:span[@type='omissionStart']/parent::tei:rdg[@wit = $wit-omission]/@cause"/>
                        </xsl:if>
                            <xsl:text>.</xsl:text>
                    </span>
                </span>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-omission"/>
        </span>
    </xsl:template>

    <!-- span - modals -->
    <xsl:template match="tei:span[@type='reformulationStart']" mode="modals">
        <xsl:variable name="apparatus-reformulation">
            <xsl:variable name="reformulation-id" select="self::tei:span[@type='reformulationStart']/@xml:id"/>
            <span class="mb-1 lemma-line reformulation-line">
                <span class="fake-lem app-lem">
                        <xsl:apply-templates select="self::tei:span[@type='reformulationStart']/following::node()[1]"/>
                        <xsl:text> &#8230;</xsl:text>
                        <xsl:if test="self::tei:span[@type='reformulationStart'][not(ancestor::tei:*[1][descendant::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')]])]">
                            <xsl:text> (</xsl:text>
                            <b><a href="#{self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/ancestor::tei:div[1]/@xml:id}">
                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/ancestor::tei:div[1]/@n"/>
                            <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:*[local-name ()= ('lg', 'ab', 'p')]">
                                <xsl:text>.</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:lg">
                                        <xsl:number count="tei:lg" format="1" level="single"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:ab">
                                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:ab/position()"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:p">
                                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:p/position()"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </a>
                            </b><xsl:text>)</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/preceding::node()[1]"/>
                    </span>

                    <span>
                        <xsl:text> Thus formulated in </xsl:text>
                        <b>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:lem[@type='retained'][1]/@wit"/>
                            </xsl:call-template>
                        </b>
                    </span>
                    <hr/>
                    <xsl:for-each select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg">
                        <span class="reading-line reading">
                            <span class="app-rdg"><xsl:apply-templates/></span>
                        </span>
                        <b>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="@wit"/>
                            </xsl:call-template>
                        </b>
                    </xsl:for-each>
                        <hr/>
                    <xsl:for-each select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:note[not(@type='altLem')]">
                        <span class="note-line">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:for-each>
                </span>
        </xsl:variable>
        <span class="popover-content d-none" id="{generate-id()}">
            <xsl:copy-of select="$apparatus-reformulation"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc">
        <hr/>
        <h2 id="witnesses">
            <xsl:choose>
                <xsl:when test="count(tei:listWit[1]/tei:witness) = 1">
                    <xsl:text>Witness</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Witnesses</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <ul>
            <xsl:apply-templates select="tei:listWit"/>
        </ul>
        <hr/>
    </xsl:template>

    <!--  subst ! -->
    <!-- Not found so far in the files -->
    <xsl:template match="tei:subst">
        <xsl:apply-templates/>
    </xsl:template>

    <!--  supplied ! -->
    <!-- <span class="supplied" data-tip="Editorial addition to clarify interpretation">⟨,⟩</span> -->
    <!-- <span class="supplied" data-tip="Omitted text">⟨ṁ⟩</span> -->
    <!-- <span class="supplied" data-tip="Lost text">[siddha]</span>-->
    <!-- <span class="supplied" data-tip="Text added to the translation for the sake of target language syntax">[players]</span> -->
    <!-- <span class="supplied" data-tip="Text inserted into the translation as explanation or disambiguation">(cloth)</span>-->
    <!-- To be done -->
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:attribute name="class">supplied</xsl:attribute>
            <xsl:attribute name="data-tip">
                <xsl:choose>
                    <xsl:when test="@reason='unknown'">
                        <xsl:text>Text to be supplied unknown to editor</xsl:text>
                    </xsl:when>
                    <xsl:when test="@reason='lost'">
                        <xsl:text>Lost text</xsl:text>
                    </xsl:when>
                    <!--<xsl:when test="@reason='illegible'">
                        <xsl:text>Illegible text</xsl:text>
                    </xsl:when>
-->                    <xsl:when test="@reason='omitted'">
                        <xsl:text>Omitted text</xsl:text>
                    </xsl:when>
                    <xsl:when test="@reason='subaudible'">
                        <xsl:text>Editorial addition to clarify interpretation</xsl:text>
                    </xsl:when>
                    <xsl:when test="@reason='explanation'">
                        <xsl:text>Text inserted into the translation as explanation or disambiguation</xsl:text><xsl:if test="@cert='low'"> (low certainty)</xsl:if>
                    </xsl:when>
                    <xsl:when test="@reason='subaudible'">
                        <xsl:text>Text added to the translation for the sake of target language syntax</xsl:text><xsl:if test="@cert='low'"> (low certainty)</xsl:if>
                    </xsl:when>
                    <xsl:otherwise>Supplied by the editor</xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@reason='lost' or @reason='illegible' or @reason='subaudible' or @reason='unknown'">[<xsl:apply-templates/><xsl:if test="@cert='low'">
                        <xsl:text>?</xsl:text>
                    </xsl:if><xsl:text>]</xsl:text>
                </xsl:when>
                <xsl:when test="@reason='omitted' and not(child::tei:lg)">⟨<xsl:apply-templates/>⟩</xsl:when>
                <xsl:when test="@reason='explanation'">(<xsl:apply-templates/>
                        <xsl:if test="@cert='low'">
                            <xsl:text>?</xsl:text>
                        </xsl:if>)</xsl:when>
                <xsl:when test="@reason='implied' and not(parent::tei:ab)">
                    <xsl:choose>
                        <xsl:when test="not(parent::tei:quote[@type='base-text'])">
                            <xsl:element name="span">
                                <xsl:attribute name="class">implied</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!--  surplus ! -->
    <!-- updates -->
    <xsl:template match="tei:surplus">
        <span class="surplus" data-tip="Superfluous text erroneously added by the scribe">{<xsl:apply-templates/>}</span> 
    </xsl:template>
    
    <!--  term ! -->
    <!-- updates -->
    <xsl:template match="tei:term">
        <b class="term"><xsl:apply-templates/></b>
    </xsl:template>
    
    <!--  title ! -->
    <!-- updates -->
    <xsl:template match="tei:title">
            <xsl:choose>
                <xsl:when test="@rend='plain'  or @type='editorial' or @type='alt'">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="@level='a'">
                    <xsl:text>‘</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>’</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <i><xsl:apply-templates/></i>
                </xsl:otherwise>
            </xsl:choose> 
    </xsl:template>

    <!--  U ! -->
    <!--  unclear -->
    <!-- updated -->
    <!-- Unclear avec choice géré dans choice directement -->
    <xsl:template match="tei:unclear[not(parent::tei:choice)]">
        <xsl:element name="span">
            <xsl:attribute name="class">unclear</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@cert='low'">
                    <xsl:attribute name="data-tip">Tentative reading</xsl:attribute>
                </xsl:when>
    <xsl:otherwise>
            <xsl:attribute name="data-tip">Unclear text<xsl:if test="@reason"><xsl:choose>
                <xsl:when test="@reason='eccentric_ductus'"> (&lt;i&gt;eccentric ductus&lt;/i&gt;)</xsl:when>
                <xsl:otherwise> (<xsl:apply-templates select="replace(@reason, '_', ' ')"/>)</xsl:otherwise></xsl:choose></xsl:if></xsl:attribute>
    </xsl:otherwise>
            </xsl:choose> <xsl:text>(</xsl:text><xsl:apply-templates/><xsl:if test="@cert='low'">?</xsl:if><xsl:text>)</xsl:text>
        </xsl:element>
    </xsl:template>

    <!--  witDetail ! -->
    <!-- to avoid displaying the textual content of rejected branch in the main text -->
    <xsl:template match="tei:witDetail">
        <xsl:choose>
            <xsl:when test="tei:witDetail[@type='rejected']/text()"/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:witness">
            <li>
                <a id="{@xml:id}">
                <b>
                    <xsl:choose>
                        <!-- pour éviter les abbr vides -->
                        <xsl:when test="tei:abbr[@type='siglum'][1]/text()">
                            [<xsl:apply-templates select="tei:abbr[@type='siglum']"/>]
                        </xsl:when>
                        <!-- pour éviter les id non édités -->
                        <xsl:when test="@xml:id='fakeID'"/>
                       <xsl:otherwise>
                            [<xsl:value-of select="@xml:id"/>]
                        </xsl:otherwise>
                    </xsl:choose>
                </b></a><xsl:text> </xsl:text>
                <xsl:choose>
                    <xsl:when test="tei:msDesc">
                        <xsl:if test="tei:msDesc/tei:msIdentifier//text()">
                            <!-- On pourrait être plus efficace ici et éviter de répéter inutilement certaines parties pour les msFrag et msPart, à faire si le temps -->
                            <xsl:choose>
                                <xsl:when test="tei:msDesc/tei:msIdentifier[following-sibling::tei:msFrag]">
                                    <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:msName"/>
                                    <ul>
                                    <xsl:for-each select="tei:msDesc/tei:msFrag">
                                        <li>
                                            <xsl:if test="tei:msIdentifier/tei:abbr[@type='siglum']"><b>[<xsl:apply-templates select="tei:msIdentifier/tei:abbr"/>]</b></xsl:if>
                                            <xsl:if test="tei:msIdentifier/tei:settlement">
                                                <xsl:apply-templates select="tei:msIdentifier/tei:settlement"/>
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="tei:msIdentifier/tei:institution">
                                                
                                                <xsl:apply-templates select="tei:msIdentifier/tei:institution"/>
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="tei:msIdentifier/tei:repository">
                                                <xsl:apply-templates select="tei:msIdentifier/tei:repository"/>
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="tei:msIdentifier/tei:collection">
                                                <xsl:apply-templates select="tei:msIdentifier/tei:collection"/>
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="tei:msIdentifier/tei:idno">
                                                <xsl:apply-templates select="tei:msIdentifier/tei:idno"/>             
                                            </xsl:if>
                                            <xsl:if test="tei:physDesc/tei:objectDesc/tei:p/text()">
                                                <ul><li><b>Physical Description: </b><xsl:apply-templates select="tei:physDesc/tei:objectDesc/tei:p"/></li>
                                                    <xsl:if test="tei:physDesc/tei:handDesc/descendant-or-self::tei:p/text() | tei:physDesc/tei:handDesc/descendant-or-self::tei:handNote/text()">
                                                        <li>
                                                            <b>Hand Description: </b>
                                                            <xsl:apply-templates select="tei:physDesc/tei:handDesc/tei:p| tei:physDesc/tei:handDesc/tei:handNote"/> </li></xsl:if>
                                                       
                                                </ul>
                                            </xsl:if>
                                            
                                            
                                        </li>
                                    </xsl:for-each>
                                    </ul>
                                </xsl:when>
                                <xsl:when test="tei:msDesc/tei:msIdentifier[following-sibling::tei:msPart]"><!-- Part to be done --></xsl:when>
                                <xsl:otherwise><xsl:if test="tei:msDesc/tei:msIdentifier/tei:settlement">
                                <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:settlement"/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:institution">
                                
                                <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:institution"/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:repository">
                                <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:repository"/>
                                <xsl:text>, </xsl:text>
                           </xsl:if>
                            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:collection">
                                <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:collection"/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="tei:msDesc/tei:msIdentifier/tei:idno">
                                <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:idno"/>             
                            </xsl:if>
                        
                        </xsl:otherwise>
                </xsl:choose>
                        </xsl:if>
                       
                        <ul>
                            <xsl:if test="tei:msDesc/tei:msContents/tei:msItem[child::tei:locus/text()|child::tei:author/text()|child::tei:title/text()]">
                                <li>
                                    <b>Content: </b> 
                                    <xsl:if test="tei:msDesc/tei:msContents/tei:summary"><xsl:apply-templates select="tei:msDesc/tei:msContents/tei:summary"/></xsl:if>
                                    <ul>
                                        <xsl:if test="tei:msDesc/tei:msContents/tei:msItem[child::tei:locus/text()|child::tei:author/text()|child::tei:title/text()]"><xsl:for-each select="tei:msDesc/tei:msContents/tei:msItem[child::tei:locus|child::tei:author|child::tei:title]">
                                            <li>
                                                <xsl:if test="tei:locus">
                                                    <xsl:apply-templates select="tei:locus"/>
                                                    <xsl:text>: </xsl:text>
                                                </xsl:if>
                                                <i>
                                                    <xsl:apply-templates select="tei:title"/>
                                                </i>
                                                <xsl:if test="tei:author">
                                                    <xsl:text> by </xsl:text>
                                                    <xsl:apply-templates select="./tei:author"/>
                                                </xsl:if>
                                            </li>
                                        </xsl:for-each></xsl:if>
                                    </ul>
                                </li>
                            </xsl:if>
                                
                                <xsl:if test="tei:msDesc/tei:msContents/tei:msItem/tei:colophon//text()"><li>
                                    <b>Colophon: </b>
                                    <ul>
                                        <xsl:for-each select="tei:msDesc/tei:msContents/tei:msItem/tei:colophon/tei:quote">
                                            <li> 
                                                <xsl:value-of select="@type"/>
                                                <xsl:if test="@type"><xsl:text>: </xsl:text></xsl:if>
                                                <xsl:apply-templates/>
                                            </li>
                                            
                                        </xsl:for-each>
                                    </ul></li>
                                </xsl:if>
                                <xsl:if test="tei:msDesc/tei:msContents/tei:msItem/tei:colophon/tei:note">
                                    <xsl:apply-templates select="tei:msDesc/tei:msContents/tei:msItem/tei:colophon/tei:note"/>
                                </xsl:if>
                            <xsl:if test="tei:msDesc/tei:physDesc/tei:objectDesc/tei:p/text()">
                                <li><b>Physical Description: </b><xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:p"/></li>
                            </xsl:if>
                            <xsl:if test="tei:msDesc/tei:physDesc/tei:handDesc/descendant-or-self::tei:p/text() | tei:msDesc/tei:physDesc/tei:handDesc/descendant-or-self::tei:handNote/text()">
                                <li>
                                    <b>Hand Description: </b>
                                    <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:handDesc/tei:p| tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote"/>
                                </li>
                            </xsl:if>
                            <xsl:if test="tei:msDesc/tei:history/tei:p/text()">
                                <li>
                                    <b>History: </b>
                                    <xsl:apply-templates select="tei:msDesc/tei:history"/>
                                </li>
                            </xsl:if>  
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="node() except child::tei:abbr"/>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
    </xsl:template>
    
    <!--  NAMED TEMPLATES ! -->
    <xsl:template name="tokenize-witness-list">
        <xsl:param name="string"/>
        <xsl:param name="witdetail-string"/>
        <xsl:param name="witdetail-type"/>
        <xsl:param name="witdetail-text"/>
        <xsl:param name="wit-hand"/>
        <xsl:param name="tpl"/>
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
                        <xsl:with-param name="wit-hand" select="$wit-hand"/>
                        <xsl:with-param name="tpl" select="$tpl"/>
                    </xsl:call-template>
                    <xsl:call-template name="tokenize-witness-list">
                        <xsl:with-param name="string" select="substring-after($string, ' ')"/>
                        <xsl:with-param name="witdetail-string" select="$witdetail-string"/>
                        <xsl:with-param name="witdetail-type" select="$witdetail-type"/>
                        <xsl:with-param name="witdetail-text" select="$witdetail-text"/>
                        <xsl:with-param name="wit-hand" select="$wit-hand"/>
                        <xsl:with-param name="tpl" select="$tpl"/>
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
                            <xsl:with-param name="wit-hand" select="$wit-hand"/>
                            <xsl:with-param name="tpl" select="$tpl"/>
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
        <xsl:param name="wit-hand"/>
        <xsl:param name="tpl"/>
        <!-- Changement dans la gestion des espaces donc $tpl='content-ptr' n'est plus nécessaire -->
        <xsl:if test="not($tpl='content-pb')">
            <xsl:text> </xsl:text>
        </xsl:if>
        <a class="siglum ref" href="#{$target}">
            <xsl:choose>
                <xsl:when test="//tei:listWit/tei:witness[@xml:id=$target]/tei:abbr[@type='siglum'][1]">
                    <xsl:apply-templates select="//tei:listWit/tei:witness[@xml:id=$target]/tei:abbr[@type='siglum'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$target"/>
                </xsl:otherwise>
            </xsl:choose>
        </a>
        <xsl:if test="$target = $witdetail-string">
                    <sub>
                    <xsl:value-of select="$witdetail-type"/>
                        <xsl:if test="$wit-hand !=''">
                            <xsl:choose>
                                <xsl:when test="fn:contains($wit-hand, 'H1')">
                                    <xsl:text>-pm</xsl:text>
                                </xsl:when>
                                <xsl:when test="fn:contains($wit-hand, 'H2')">
                                    <xsl:text>-sm</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
            </sub>
            <xsl:if test="$witdetail-text != ''">
                <span class="witDetail-line font-weight-normal">
                <xsl:text> (</xsl:text>
            <xsl:apply-templates select="$witdetail-text"/>
            <xsl:text>)</xsl:text>
            </span></xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- Check feature -->
    <!-- Note that any element <hi> only used with the @rend="check" will be deleted at some point. On other elements, only the @rend attribute will be deleted, except if several values are given in the @rend. -->
    <xsl:template match="tei:*[not(local-name()=('app'))][@rend='check']">
        <span class="mark">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Unmetrical feature -->
    <!-- might need to be updated depending on the use contexted -->
    <xsl:template match="tei:*[not(local-name()=('app'))][@rend='unmetrical']">
        <span class="unmetrical">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template name="dharma-head">
        <xsl:variable name="title">
            <xsl:if test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()">
                <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
            </xsl:if>
        </xsl:variable>
        <head>
            <title>
                <xsl:value-of select="$title"/>
            </title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
                <!-- Attention pour des raisons de test les liens ne sont pas tout à fait correct -->
                <xsl:choose>
                    <xsl:when test="$viz-context='github'">
                        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
                        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
                        <link rel="icon" href="https://dharmalekha.info/favicon.svg"/>
                        <link rel="stylesheet" href="https://dharmalekha.info/fonts.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>                       
                            <link rel="stylesheet" href="https://dharmalekha.info/base.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <link rel="stylesheet" href="./dharma-ms_v02.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@refs/heads/master/stylesheets/criticalEditions/dharma-ms_v02.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>-->
                            <script src="https://cdn.jsdelivr.net/npm/@floating-ui/core@1.6.0"/>
                            <script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.3"/>
                        <script src="https://dharmalekha.info/base.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@refs/heads/master/stylesheets/criticalEditions/loader_v02.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"></script>                  
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- liens pour le système intégré de Michaël -->
         <!-- lien vers bootstrap 4 à faire -->
                        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"></link>                        
                     <link rel="stylesheet" href="./base.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <link rel="stylesheet" href="./fonts.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <link rel="icon" href="./favicon.svg"/>
                <link rel="stylesheet" href="./dharma-ms_v02.css?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
                        <script src="https://cdn.jsdelivr.net/npm/@floating-ui/core@1.6.0"></script>
                        <script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.3"></script>
                        <script src="./base.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                        <script src="./loader_v02.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"/>
                    </xsl:otherwise>
                </xsl:choose>    
         </meta>
        </head>
    </xsl:template>
    

    <!-- DHARMA html JS scripts  -->
    <xsl:template name="dharma-script">
        <!-- Attention pour des raisons de test les liens ne sont pas tout à fait correct -->
        <xsl:choose>
            <xsl:when test="$viz-context='github'">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                <script src="https://dharmalekha.info/base.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"></script>
        <!-- Popper.JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <!-- Bootstrap JS -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>    
                <script src="https://cdn.jsdelivr.net/gh/erc-dharma/project-documentation@refs/heads/master/stylesheets/criticalEditions/loader_v02.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"></script>
            </xsl:when>
            <xsl:otherwise>
        <!-- les  liens pour bootstraps 4 sont à faire pour la version locale-->
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                
                <!-- Popper.JS -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                <!-- Bootstrap JS -->
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script> 
        <script src="./loader_v02.js?v=1a9450aa77c9b125526d71a0e58819c086fa4cab"></script>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Templates for Apparatus at the botton of the page -->
  <xsl:template name="tpl-apparatus">
    <!-- An apparatus is only created if one of the following is true -->
    <xsl:choose>
        <xsl:when test="$edition-type='diplomatic'">
            <!-- je vais devoir ajouter les choice et peut-être les subst -->
            <xsl:if test=".//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])]| .//tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart'] | .//tei:l[@real]">

                    <div class="ed-section">
                        <xsl:for-each
                            select=".//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])]| .//tei:note[last()][not(@type='parallels' or parent::tei:app or @type='altLem')][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart'] | .//tei:lacunaStart | .//tei:l[@real]">
                            
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
                                        <xsl:when test="self::tei:span[@type='reformulationStart']">
                                            <xsl:text>reformulation</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="self::tei:lacunaStart">
                                            <xsl:text>lost</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="self::tei:note[ancestor::tei:div[@type='translation']]">
                                            <xsl:text>trans</xsl:text>
                                        </xsl:when>
                                       <!-- <xsl:when test="self::choice">choice</xsl:when>
                                        <xsl:when test="self::subst">subst</xsl:when>-->
                                    </xsl:choose>
                                </xsl:with-param>
                                <xsl:with-param name="display-context" select="'printedapp'"/>
                                
                            </xsl:call-template>
                        </xsl:for-each>
                    </div>
                
            </xsl:if>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if
        test=".//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])]| .//tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart'] | .//tei:l[@real]">
      <div class="ed-section">
        <xsl:for-each
            select=".//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])]| .//tei:note[last()][not(@type='parallels' or parent::tei:app or @type='altLem')][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart'] | .//tei:lacunaStart | .//tei:l[@real]">

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
                  <xsl:when test="self::tei:span[@type='reformulationStart']">
                      <xsl:text>reformulation</xsl:text>
                  </xsl:when>
                  <xsl:when test="self::tei:lacunaStart">
                      <xsl:text>lost</xsl:text>
                  </xsl:when>
                  <xsl:when test="self::tei:note[ancestor::tei:div[@type='translation']]">
                      <xsl:text>trans</xsl:text>
                  </xsl:when>
              </xsl:choose>
            </xsl:with-param>
              <xsl:with-param name="display-context" select="'printedapp'"/>
          </xsl:call-template>
        </xsl:for-each>
      </div>
        
    </xsl:if>
    </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="lbrk-app">
    <br/>
  </xsl:template>

    <xsl:template name="app-link">
        <!-- location defines the direction of linking -->
        <xsl:param name="location"/>
        <xsl:param name="type"/>
            <!-- Only produces a link if it is not nested in an element that would be in apparatus -->
        <!-- I need to revise this!!! -->
        <xsl:if test="not((local-name() = 'choice' or local-name() = 'subst')
            and (ancestor::tei:choice or ancestor::tei:subst))">
            <xsl:variable name="app-num">
                <xsl:value-of select="name()"/>
                <xsl:number level="any" format="0001"/>
            </xsl:variable>
                    <xsl:call-template name="generate-app-link">
                    <xsl:with-param name="location" select="$location"/>
                    <xsl:with-param name="app-num" select="$app-num"/>
                    <xsl:with-param name="type" select="$type"/>
                </xsl:call-template>
            </xsl:if>
    </xsl:template>

    <xsl:template name="generate-app-link">
        <xsl:param name="location"/>
        <xsl:param name="app-num"/>
        <xsl:param name="trans-num"/>
        <xsl:param name="type"/>
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
                    <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])] | //tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | //tei:note[ancestor::tei:div[@type='translation']] //tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] | .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart']| .//tei:l[@real] |.//tei:lacunaStart"/>
                </a>
            </xsl:if>
        <xsl:if test="$location = 'apparatus'">
            <xsl:element name="a">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="$type !=''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$type"/>
                    </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="self::tei:lacunaStart">
                                    <xsl:text> lostStartAnchor</xsl:text>
                                </xsl:when>
                                <xsl:when test="self::tei:lacunaEnd">
                                    <xsl:text> lostEndAnchor</xsl:text>
                                </xsl:when>
                                <xsl:when test="self::tei:span[@type='omissionStart']">
                                    <xsl:text> omissionStartAnchor</xsl:text>
                                </xsl:when>
                                <xsl:when test="self::tei:span[@type='omissionEnd']">
                                    <xsl:text> omissionEndAnchor</xsl:text>
                                </xsl:when>
                                <xsl:when test="self::tei:span[@type='reformulationStart']">
                                    <xsl:text> reformulationStartAnchor</xsl:text>
                                </xsl:when>
                                <xsl:when test="self::tei:span[@type='reformulationEnd']">
                                    <xsl:text> reformulationEndAnchor</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="data-toggle">popover</xsl:attribute>
                <xsl:attribute name="data-html">true</xsl:attribute>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:attribute name="href"><xsl:text>#to-app-</xsl:text>
                    <xsl:value-of select="$app-num"/></xsl:attribute>
                <xsl:attribute name="title">Apparatus <xsl:number level="any" count=" //tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])]| .//tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | //tei:note[ancestor::tei:div[@type='translation']] | .//tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]] |.//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart']| .//tei:l[@real] |.//tei:lacunaStart"></xsl:number></xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>from-app-</xsl:text>
                    <xsl:value-of select="$app-num"/>
                </xsl:attribute>
                <xsl:attribute name="data-app">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:text>(</xsl:text>
                <xsl:number level="any" count="//tei:app[not(parent::tei:listApp[@type='parallels'] or @rend='hide' or preceding-sibling::tei:span[@type='reformulationEnd'][1])] | .//tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] | //tei:note[ancestor::tei:div[@type='translation']] | .//tei:note[parent::tei:ab[preceding-sibling::tei:lg][1]]| .//tei:span[@type='omissionStart'] | .//tei:span[@type='reformulationStart']| .//tei:l[@real] |.//tei:lacunaStart"/>
                <xsl:text>)</xsl:text>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="dharma-app">
        <xsl:param name="apptype"/>
        <xsl:param name="display-context"/>
       <xsl:variable name="childtype">
            <xsl:choose>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice[child::tei:orig and child::tei:reg]">
                    <xsl:text>origreg</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:choice[child::tei:sic and child::tei:corr]">
                    <xsl:text>siccorr</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:subst">
                    <xsl:text>subst</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:*[local-name()=('orig' , 'sic' , 'add' , 'lem')]/tei:app">
                    <xsl:text>app</xsl:text>
                </xsl:when>
              <!--<xsl:when test="child::tei:*[local-name()=('note')]/tei:app"/>-->
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$display-context='modalapp'"/>
            <xsl:when test="not(ancestor::tei:choice or ancestor::tei:subst) or //tei:note[last()][parent::tei:p or parent::tei:lg or parent::tei:l][not(ancestor::tei:div[@type='translation'])] and $display-context='printedapp'">
                <xsl:call-template name="lbrk-app"/>
                <xsl:call-template name="app-link">
                    <xsl:with-param name="location" select="'bottom'"/>
                </xsl:call-template>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:when test="tei:note[ancestor::tei:div[@type='translation']]">
                <xsl:call-template name="lbrk-app"/>
                <xsl:call-template name="generate-trans-link">
                    <xsl:with-param name="situation" select="'apparatus-bottom'"/>
                </xsl:call-template>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>:&#x202F;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <span class="app-entry">
            <!-- commenter afin de ne le déclarer qu'une unique fois! -->
            <!-- à bouger -->
          <!--<xsl:choose>
              <xsl:when test=".[local-name() = 'note'][ not(ancestor::tei:div[@type='translation'])]">
                      <xsl:call-template name="fake-lem-making"/>
                      <b><xsl:text>] </xsl:text></b>
                      <xsl:apply-templates/>
                  </xsl:when>
              <xsl:when test="local-name() = 'l'">
                  <xsl:call-template name="fake-lem-making"/>
                  <b><xsl:text>] </xsl:text></b>
                  <xsl:text>Unmetrical line. The observed pattern is not </xsl:text>
                      <i>
                          <xsl:value-of select="ancestor::tei:*[@met][1]/@met"/>
                          <xsl:call-template name="metrical-list">
                          <xsl:with-param name="metrical" select="ancestor::tei:*[@met][1]/@met"/>
                          <xsl:with-param name="line-context" select="'real'"/>
                      </xsl:call-template>
                      </i>
                  <xsl:text> but </xsl:text>
                  <span class="prosody"><xsl:value-of select="translate(@real, '-=+', '⏑⏓–')"/></span>
                  <xsl:text>.</xsl:text>
              </xsl:when>
              <xsl:otherwise>-->
              <xsl:call-template name="appcontent">
                <xsl:with-param name="apptype" select="$apptype"/>
                <xsl:with-param name="childtype" select="$childtype" />
                  <xsl:with-param name="display-context" select="$display-context"/>
            </xsl:call-template>
              <!--</xsl:otherwise>
          </xsl:choose>-->
        </span>
    </xsl:template>

    <!-- prints the content of apparatus-->
    <xsl:template name="appcontent">
        <xsl:param name="apptype"/>
     <xsl:param name="childtype"/>
        <xsl:param name="display-context"/>
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
                    <xsl:with-param name="display-context" select="$display-context"/>
                </xsl:call-template>
               <xsl:text> </xsl:text>
            </xsl:when>
             <xsl:otherwise>
                <xsl:call-template name="appchoice">
                    <xsl:with-param name="apptype"><xsl:value-of select="$apptype"/></xsl:with-param>
                    <xsl:with-param name="child"><xsl:if test="$childtype != ''">true</xsl:if></xsl:with-param>
                    <xsl:with-param name="path"><xsl:copy-of select="$path"/></xsl:with-param>
                   <xsl:with-param name="parent-lang"><xsl:value-of select="$parent-lang" /></xsl:with-param>
                    <xsl:with-param name="display-context" select="$display-context"/>
                </xsl:call-template>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- contenu de tous les app; printed et modaux; nombreuses conditions sur $display-content pour éviter de répéter plusieurs le contenu -->
    <xsl:template name="appchoice">
        <xsl:param name="apptype" />
       <xsl:param name="child" />
        <xsl:param name="path" />
       <xsl:param name="parent-lang"/>
        <xsl:param name="display-context"/>
        <xsl:choose>
            <xsl:when test="$apptype='app'">
                <!-- **ALT - <xsl:value-of select="$path/tei:rdg"/>** -->
                <xsl:for-each select="tei:lem">
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="$display-context='printedapp'">bottom-lemma-line</xsl:when>
                                <xsl:otherwise>lemma-line</xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="not($path/tei:lem/following-sibling::tei:note[@type='altLem'])">
                                <xsl:call-template name="truncation-type"/>
                            </xsl:if>
                            
                        </xsl:attribute>
                            <xsl:choose>
                            <xsl:when test="$path/tei:lem/following-sibling::tei:note[@type='altLem']">
                                <xsl:apply-templates select="replace($path/tei:lem/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')"/>
                            </xsl:when>
                            <xsl:when test="$path/tei:lem[@type='transposition'][not(matches(@xml:id, 'trsp\d\d\d'))]"/>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$path/tei:lem"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    
                    <xsl:if test="not($path/tei:lem[@type='transposition'][following-sibling::tei:rdg[descendant::*[@corresp]]]) and $display-context='printedapp'">
                        <b><xsl:text>]</xsl:text></b>
                    </xsl:if>
                    <xsl:if test="$path/tei:lem/@type">
                        <i><xsl:text> </xsl:text><xsl:call-template name="apparatus-type"><xsl:with-param name="type-app" select="$path/tei:lem/@type"/></xsl:call-template></i></xsl:if>
                        <!-- @resp and @source -->
                        <xsl:if test="$path/tei:lem/@resp">
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="responsability-display">
                                <xsl:with-param name="responsability" select="$path/tei:lem/@resp"/>
                                <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                            </xsl:call-template>
                        </xsl:if>                            
                    <xsl:if test="self::tei:lem[@type='reformulated_elsewhere'] or .[following-sibling::tei:rdg[@type='paradosis']]"><!-- or .[following-sibling::tei:witDetail[@type='retained']] -->
                            <xsl:text> Thus formulated in </xsl:text>
                            <xsl:element name="b">
                                <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>

                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="wit-hand" select="@hand"/>

                                    </xsl:call-template>
                            </xsl:element>
                        </xsl:if>
                    <xsl:if test="self::tei:lem[@type='transposition'][not(matches(@xml:id, 'trsp\d\d\d'))][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]">
                        <b><xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::tei:rdg[1]/@wit"/>
                            </xsl:call-template>
                        </b>
                        <xsl:text> presents the lines in order </xsl:text>
                        <xsl:for-each select="following-sibling::tei:rdg/descendant::tei:l">
                            <xsl:variable name="id-corresp" select="substring-after(@corresp, '#')"/>
                            <xsl:value-of select="ancestor::tei:rdg/preceding-sibling::tei:lem[@type='transposition']/descendant::tei:l[@xml:id = $id-corresp]/@n"/>
                        </xsl:for-each>
                    </xsl:if>
                    <!-- case for transposition with parent with xml:if  -->
                    <xsl:if test="self::tei:lem[contains(@type,'transposition')][matches(@xml:id, 'trsp\d\d\d')]">
                        <b><xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="wit-hand" select="@hand"/>

                            </xsl:call-template>
                        </b>
                    </xsl:if>
                    <xsl:if test="self::tei:lem/@type='omitted_elsewhere'">
                        <xsl:text> transmitted in </xsl:text>
                        <xsl:element name="b">
                            <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>

                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="self::tei:lem/@type='lost_elsewhere'">
                        <xsl:text> preserved in </xsl:text>
                        <xsl:element name="b">
                            <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>                            <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>

                                <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                <xsl:with-param name="wit-hand" select="tei:lem/@hand"/>

                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="self::tei:lem/@wit">
                        <xsl:choose>
                            <xsl:when test="self::tei:lem[@type='transposition'][not(@xml:id)][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]"/>
                            <xsl:otherwise>
                                <xsl:element name="b">
                                    <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                        <xsl:with-param name="wit-hand" select="@hand"/>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                            </xsl:if>
                    <xsl:if test="self::tei:lem[@type='transposition']">
                        <xsl:choose>
                            <xsl:when test=".[not(@xml:id)][following-sibling::tei:rdg[descendant-or-self::tei:*[@corresp]]]"/>
                            <xsl:otherwise>
                                <xsl:text> (transposition)</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                       <!-- <xsl:value-of select="@type"/>
                        <xsl:text>)</xsl:text>-->
                    </xsl:if>
                    <xsl:if test="@source">
                        <xsl:text> </xsl:text>
                        <xsl:choose>
                            <xsl:when test="contains(@source, '#')"><xsl:call-template name="source-siglum">
                                <xsl:with-param name="string-to-siglum" select="@source"/>
                            </xsl:call-template></xsl:when>
                            <xsl:when test="contains(@source, 'bib:')">
                                <xsl:call-template name="bibliography">
                                    <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="$path/tei:lem[not(@type='transposition')] and $display-context='printedapp'">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                        <xsl:if test="$path/tei:lem[not(@type='transposition')] and $display-context='modalapp'">
                            <xsl:call-template name="lbrk-app"/>
                        </xsl:if>
                    </xsl:element>
                    <xsl:if test="$display-context='modalapp'">
                        <hr/>
                    </xsl:if>
                </xsl:for-each>
                <!-- create the fake lem for transposition only containing rdg -->
                <xsl:for-each select="tei:rdg[@cause='transposition'][not(preceding-sibling::tei:lem)]">
                        <xsl:variable name="corresp-id" select="@corresp"/>
                    <xsl:apply-templates select="replace(//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/following-sibling::tei:note[@type='altLem'], '\.\.\.', '&#8230;')
                            "/>
                        <!--  adding the bracket since it can't be diplayed without element lem-->
                        <xsl:if test="$display-context='printedapp'">
                            <b><xsl:text>]</xsl:text></b>
                        </xsl:if>

                </xsl:for-each>
                <xsl:for-each select="descendant-or-self::tei:rdg[not(preceding-sibling::tei:lem[@type='transposition'])]">

                    <xsl:element name="span">
                        <xsl:attribute name="class">reading bottom-reading-line<xsl:choose><xsl:when test="descendant-or-self::tei:lacunaStart"><xsl:text> bottom-lacunaStart</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionStart']"> bottom-omissionStart<xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:lacunaEnd"><xsl:text> bottom-lacunaEnd</xsl:text><xsl:value-of select="@wit"/></xsl:when><xsl:when test="descendant-or-self::tei:span[@type='omissionEnd']"> bottom-omissionEnd<xsl:value-of select="@wit"/></xsl:when></xsl:choose>
                        </xsl:attribute>
                            <xsl:if test="position()!=1 and $display-context='printedapp'">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                        <xsl:if test="position()!=1 and $display-context='modalapp'">
                            <xsl:call-template name="lbrk-app"/>
                        </xsl:if>
                    <xsl:choose>
                        <xsl:when test="child::tei:pb"/>
                        <xsl:when test="child::tei:gap[@reason='omitted']">
                            <i>om.</i>
                        </xsl:when>
                        <xsl:when test="child::tei:gap[@reason='lost' and not(@quantity or @unit)]">
                            <i>lac.</i>
                        </xsl:when>
                        <xsl:when test="child::tei:lacunaEnd or child::tei:span[@type='omissionEnd']">...]</xsl:when>

                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@rend">
                            <xsl:element name="span">
                                <xsl:attribute name="class">
                                    <xsl:if test="@rend='check'">
                                        <xsl:text>mark</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="@rend='unmetrical'">
                                        <xsl:text>unmetrical</xsl:text>
                                    </xsl:if>
                                </xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>

                            <xsl:choose>
                                <xsl:when test="child::tei:lacunaStart or child::tei:span[@type='omissionStart']">[...</xsl:when>
                            </xsl:choose>
                    </xsl:element>
                    <xsl:if test="@*">
                        <xsl:if test="@wit">
                            <xsl:element name="b">
                                <xsl:if test="following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                                <xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="@wit"/>
                                    <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                    <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                    <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                    <xsl:with-param name="wit-hand" select="@hand"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="@type">
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="apparatus-type">
                                <xsl:with-param name="type-app" select="@type"/>
                            </xsl:call-template>
                        </xsl:if>

                        <!-- @resp and @source -->
                        <xsl:if test="@resp">
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="responsability-display">
                                <xsl:with-param name="responsability" select="@resp"/>
                                <xsl:with-param name="display-behaviour" select="'western-surname-only'"/>
                            </xsl:call-template>
                        </xsl:if>                                
                        <xsl:if test="@source">
                            <xsl:text> </xsl:text>
                            <xsl:choose>
                                <xsl:when test="contains(@source, '#')"><xsl:call-template name="source-siglum">
                                    <xsl:with-param name="string-to-siglum" select="@source"/>
                                </xsl:call-template></xsl:when>
                                <xsl:when test="contains(@source, 'bib:')">
                                    <xsl:call-template name="bibliography">
                                        <xsl:with-param name="biblentry" select="substring-after(@source, 'bib:')"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="@cause">
                            <xsl:choose>
                                <xsl:when test="@cause='transposition'">
                                    <xsl:variable name="corresp-id" select="@corresp"/>
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="@cause"/>
                                    <xsl:text>, see </xsl:text>
                                    <a href="#{//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/@xml:id}">
                                        <xsl:text>st. </xsl:text>
                                        <xsl:value-of select="//tei:lem[@type='transposition'][@xml:id = substring-after($corresp-id, '#')]/child::tei:lg/@n"/>
                                    </a>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="replace(@cause, '_', ' ')"/>
                                <xsl:text>)</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="@type='paradosis'">
                        <xsl:text> • </xsl:text>
                        <span class="paradosis-line">
                            <i>Paradosis</i><xsl:text> of </xsl:text>
                                    <xsl:element name="b">
                                        <xsl:if test="tei:lem/following-sibling::*[local-name()='witDetail']"><xsl:attribute name="class">supsub</xsl:attribute></xsl:if>
                                        
                                    <xsl:call-template name="tokenize-witness-list">
                                        <xsl:with-param name="string" select="@wit"/>
                                        <xsl:with-param name="witdetail-string" select="following-sibling::*[local-name()='witDetail'][1]/@wit"/>
                                        <xsl:with-param name="witdetail-type" select="following-sibling::*[local-name()='witDetail'][1]/@type"/>
                                        <xsl:with-param name="witdetail-text" select="following-sibling::*[local-name()='witDetail'][1]/text()"/>
                                        <xsl:with-param name="wit-hand" select="@hand"/>
                                    </xsl:call-template>
                                    </xsl:element>
                                    <xsl:text>: </xsl:text>
                                    <xsl:apply-templates/>
                                </span>
                    </xsl:if>
                    
                </xsl:for-each>
                <xsl:for-each select="ancestor::*[local-name()='lem'][not(@type='reformulation' or @type='transposition')][1]/following-sibling::tei:rdg[1]">
                   <xsl:call-template name="rdg-content">
                       <xsl:with-param name="display-context" select="$display-context"/>
                   </xsl:call-template>
                </xsl:for-each>
                    
                <xsl:for-each select="tei:rdg/following-sibling::tei:note[not(@type='altLem')]">
                    <xsl:if test="$display-context='modalapp'">
                        <hr/>
                    </xsl:if>
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="$display-context='printedapp'">
                                    <xsl:text>bottom-note-line</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>note-line</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$display-context='printedapp'">
                                <xsl:text> • </xsl:text>
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    </xsl:for-each>

                <xsl:if test="not(tei:rdg) and tei:lem/following-sibling::tei:note[not(@type='altLem')]">
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="$display-context='printedapp'">
                                    bottom-note-line
                                </xsl:when>
                                <xsl:otherwise>note-line</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$display-context='printedapp'">
                                <xsl:text> • </xsl:text>
                                <xsl:apply-templates select="tei:lem/following-sibling::tei:note[not(@type='altLem')]"/>
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="tei:lem/following-sibling::tei:note[not(@type='altLem')]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> 
                </xsl:if>
            </xsl:when>

                <xsl:when test="$child=('appalt') or $apptype=('appalt')">
                    <xsl:apply-templates select="child::tei:*[local-name()=('orig','sic','add','lem')]">
                        <xsl:with-param name="location" select="'text'"/>
                    </xsl:apply-templates>
                </xsl:when>
            <xsl:when test="$apptype='note'">
                <xsl:for-each select="$path/tei:note">
                    <span class="bottom-note-line">
                    <xsl:apply-templates select="$path/tei:note"/>
                </span>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$apptype='omission'">
                <xsl:call-template name="omission-content"/>
            </xsl:when>
            <xsl:when test="$apptype='lost'">
                <xsl:call-template name="lost-content"/>
            </xsl:when>
            <xsl:when test="$apptype='reformulation'">
                <xsl:if test="self::tei:span[@type='reformulationStart']">
                    <xsl:variable name="reformulation-id" select="@xml:id"/>
                    <span class="bottom-reformulation">
                        <xsl:apply-templates select="self::tei:span/following::node()[1]"/>
                        <xsl:text> &#8230;</xsl:text>
                        <xsl:if test="self::tei:span[@type='reformulationStart'][not(ancestor::tei:*[1][descendant::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')]])]">
                            <xsl:text> (</xsl:text>
                        <b>
                            
                            <a href="#{self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/ancestor::tei:div[@type='dyad']/@xml:id}">
                            <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/ancestor::tei:div[@type='dyad']/@n"/>
                            <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:*[local-name ()= ('lg', 'ab', 'p')]">
                                <xsl:text>.</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:lg">
                                        <xsl:number count="tei:lg" format="1" level="single"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:ab">
                                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:ab/position()"/>
                                    </xsl:when>
                                    <xsl:when test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:p">
                                        <xsl:value-of select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/parent::tei:p/position()"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </a>
                        </b>
                            <xsl:text>) </xsl:text>
                        </xsl:if>

                        <xsl:apply-templates select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/preceding::node()[1]"/>
                        <b><xsl:text>]</xsl:text>
                        </b>
                        <xsl:text> Thus formulated in </xsl:text>
                        <b> <xsl:call-template name="tokenize-witness-list">
                                <xsl:with-param name="string" select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:lem[@type='retained']/@wit"/>
                            </xsl:call-template>
                        </b>
                        <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg and $display-context='printedapp'">
                        <xsl:text>, </xsl:text>
                    </xsl:if>

                        <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg">
                            <xsl:for-each select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:rdg">
                                <span class="reading bottom-reading-line">
                                <xsl:apply-templates/>
                                </span>
                                <b><xsl:call-template name="tokenize-witness-list">
                                    <xsl:with-param name="string" select="./@wit"/>
                                </xsl:call-template></b>
                        
                        </xsl:for-each>
                    </xsl:if>
                        <xsl:if test="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:note[not(@type='altLem')]"> • </xsl:if>
                        <xsl:for-each select="self::tei:span[@type='reformulationStart']/following::tei:span[@type='reformulationEnd'][$reformulation-id = substring-after(@corresp, '#')][1]/following-sibling::tei:app[1]/tei:note[not(@type='altLem')]">
                            <span class="reading bottom-reading-line">
                            <xsl:apply-templates/>
                            </span>
                    </xsl:for-each>
                    </span>
                </xsl:if>
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
        <xsl:param name="type-app"/>
        <xsl:choose>
            <xsl:when test="$type-app='emn'">
                <xsl:text>em.</xsl:text>
            </xsl:when>
            <xsl:when test="$type-app='norm'">
                <xsl:text>norm.</xsl:text>
            </xsl:when>
            <xsl:when test="$type-app='conj'">
                <xsl:text>conj.</xsl:text>
           </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Siglum : fetch the siglum to display -->
    <xsl:template name="source-siglum">
        <xsl:param name="string-to-siglum"/>
            <b>Ed<sup class="ed-siglum">
                <xsl:apply-templates select="//tei:witness[@xml:id=$string-to-siglum]/tei:abbr"/></sup></b>
    </xsl:template>

    <!-- Parallels: generate the content  -->
    <xsl:template name="parallels-content">
                    <xsl:for-each select="descendant-or-self::tei:app">
                        <xsl:if test="@type">   
                        <b><xsl:value-of select="@type"/></b>                       
                        </xsl:if>
                        <ul class="list-unstyled">
            <xsl:if test="descendant-or-self::tei:lem">
                <i><xsl:apply-templates select="descendant-or-self::tei:lem"/></i>
            </xsl:if>
            <xsl:for-each select="descendant-or-self::tei:note">
                <li>     
                    <span class="parallel-text">
                        <xsl:apply-templates/>
                    </span>
                </li>
            </xsl:for-each>
        </ul>
                    </xsl:for-each>
    </xsl:template>

    <!-- lem: render the compound in the apparatus entries for any truncation -->
    <!-- Given as class attribute and completed with js preappend and append -->
    <xsl:template name="truncation-type">
        <xsl:choose>
            <xsl:when test="@rend='hyphenleft'">
                <xsl:text> hyphenleft</xsl:text>
            </xsl:when>
            <xsl:when test="@rend='hyphenright'">
                <xsl:text> hyphenright</xsl:text>
            </xsl:when>
            <xsl:when test="@rend='hyphenaround'">
                <xsl:text> hyphenaround</xsl:text>
            </xsl:when>
            <xsl:when test="@rend='circleleft'">
                <xsl:text> circleleft</xsl:text>
            </xsl:when>
            <xsl:when test="@rend='circleright'">
                <xsl:text> circleright</xsl:text>
            </xsl:when>
            <xsl:when test="@rend='circlearound'">
                <xsl:text> circlearound</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="editors">
        <xsl:param name="list-editors"/>
        <xsl:for-each select="$list-editors">
            <xsl:choose>
                <xsl:when test="position()= 1"/>
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
    </xsl:template>

<xsl:template name="fake-lem-making">
    <xsl:choose>
        <!-- ajouter le self tei:l pour le fake lem making de tei:l[@real]. Actuellement, bug-->
        <xsl:when test="parent::tei:p">
            <xsl:choose>
                <xsl:when test="parent::tei:p/child::node()[1][self::text()]">
                    <xsl:value-of select="substring-before(parent::tei:p/child::node()[1], ' ')"/>
                </xsl:when>
                <xsl:when test="parent::tei:p/child::node()[1][self::tei:app]">
                    <xsl:value-of select="parent::tei:p/tei:*[1]/tei:lem"/>
                </xsl:when>
                <!-- adding provision for term at the beginning of a paragraph -->
                <xsl:when test="parent::tei:p/child::node()[1][self::tei:term]">
                    <xsl:choose>
                        <xsl:when test="parent::tei:p/tei:term[child::tei:app]">
                            <xsl:value-of select="parent::tei:p/tei:*[1]//tei:lem"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="parent::tei:p/tei:*[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(parent::tei:p/child::node()[1], ' ')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> [&#8230;] </xsl:text>
                    <xsl:choose>
                        <xsl:when test="parent::tei:p/child::node()[last()-1][self::text()]">
                            <xsl:choose>
                                <!-- special condition si la chaîne se termine par un simple . -->
                                <xsl:when test="parent::tei:p/child::node()[last()-1][self::text()] = '.'">
                                    <xsl:value-of select="functx:substring-after-last(parent::tei:p/tei:app[last()]/tei:lem, ' ')"/>
                                    <xsl:text>.</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="functx:substring-after-last(normalize-space(parent::tei:p/child::node()[last()-1][self::text()]), ' ')"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="parent::tei:p/tei:*[last()-1][local-name() ='app']">
                            <xsl:value-of select="parent::tei:p/tei:*[last()-1]/tei:lem"/>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:value-of select="functx:substring-after-last(parent::tei:p, ' ')"/>
                        </xsl:otherwise>
                    </xsl:choose>
        </xsl:when>
        <xsl:when test="parent::tei:lg">
            <xsl:choose>
                <xsl:when test="parent::tei:lg/child::tei:l[1]/descendant::node()[1][self::tei:app]">
                    <xsl:value-of select="parent::tei:lg/child::tei:l[1]/tei:app[1]/tei:lem"/>
                </xsl:when>
                <xsl:when test="parent::tei:lg/child::tei:l[1]/descendant::node()[1][self::text()]">
                    <xsl:value-of select="substring-before(parent::tei:lg/child::tei:l[1], ' ')"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="substring-before(parent::tei:lg/child::tei:l[1], ' ')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> [&#8230;] </xsl:text>
            <xsl:choose>
                <xsl:when test="parent::tei:lg/child::tei:l[last()]/descendant::node()[last()][self::text()]">
                    <xsl:choose>
                        <xsl:when test="ends-with(normalize-space(parent::tei:lg/child::tei:l[last()]), '||')">

                            <xsl:value-of select="functx:substring-after-last(functx:substring-before-last-match(parent::tei:lg/child::tei:l[last()]/descendant::node()[last()][self::text()], '\s\|\|'), ' ')"/>
                            <xsl:text> ||</xsl:text>
                        </xsl:when>
                        <xsl:when test="ends-with(normalize-space(parent::tei:lg/child::tei:l[last()]), '|')">
                            <xsl:value-of select="functx:substring-after-last(functx:substring-before-last-match(normalize-space(parent::tei:lg/child::tei:l[last()]/descendant::node()[last()][self::text()]), '\s\|'), ' ')"/>
                                <xsl:text> |</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="functx:substring-after-last(normalize-space(parent::tei:lg/child::tei:l[last()]/descendant::node()[last()][self::text()]), ' ')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="parent::tei:lg/child::tei:l[last()]/tei:*[last()][local-name() ='app']">
                    <xsl:apply-templates select="parent::tei:lg/child::tei:l[last()]/tei:*[last()]/tei:lem"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="functx:substring-after-last(normalize-space(parent::tei:lg/child::tei:l[last()]/descendant::node()[last()][self::text()]), ' ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="parent::tei:l">
            <xsl:choose>
                <xsl:when test="parent::tei:l/child::node()[1][self::text()]">
                    <xsl:value-of select="substring-before(parent::tei:l/text()[1], ' ')"/>
                </xsl:when>
                <xsl:when test="parent::tei:l/child::node()[1][self::tei:app]">
                    <xsl:value-of select="parent::tei:l/tei:app[1]/tei:lem"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(parent::tei:l, ' ')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> [&#8230;] </xsl:text>
                    <xsl:choose>
                        <xsl:when test="parent::tei:l/child::node()[last()-1][self::text()]">
                            <xsl:choose>
                             <xsl:when test="ends-with(parent::tei:l/child::node()[last()-1][self::text()], '||')">
                                    <xsl:value-of select="functx:substring-after-last(functx:substring-before-last-match(normalize-space(parent::tei:l/child::node()[last()-1][self::text()]), '\s\|\|'), ' ')"/>
                                 <xsl:text> ||</xsl:text>
                            </xsl:when>
                                <xsl:when test="ends-with(parent::tei:l/child::node()[last()-1][self::text()], '|')">
                                    <xsl:value-of select="functx:substring-after-last(functx:substring-before-last-match(normalize-space(parent::tei:l/child::node()[last()-1][self::text()]), '\s\|'), ' ')"/>
                                    <xsl:text> |</xsl:text>
                                </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="functx:substring-after-last(normalize-space(parent::tei:l/child::node()[last()-1][self::text()]), ' ')"/>
                            </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="parent::tei:l/tei:*[last()-1][local-name() ='app']">
                            <xsl:apply-templates select="parent::tei:l/tei:*[last()-1]/tei:lem"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="functx:substring-after-last(normalize-space(parent::tei:l/child::node()[last()-1][self::text()]), ' ')"/>
                        </xsl:otherwise>
                    </xsl:choose>
        </xsl:when>
        <xsl:when test="parent::tei:ab">
            <xsl:value-of select="."/>
        </xsl:when>
    </xsl:choose>
</xsl:template>

   <xsl:template name="translation-button">
       <xsl:param name="textpart-id"/>
       <div class="row">
           <div class="col-10 text-col">
               <a class="btn btn-outline-dark btn-block" data-toggle="collapse" href="#{generate-id()}" role="button" aria-expanded="false" aria-controls="generate-id()">
                   <span class="smallcaps">Translation</span>
                   <!-- need to add the language -->
               </a>
               <div id="{generate-id()}" class="collapse">
                   <div class="card-body">
                       <xsl:call-template name="tpl-translation">
                           <xsl:with-param name="textpart-id" select="$textpart-id"/>
                       </xsl:call-template>
                   </div>
               </div>
           </div>
       </div>
       <xsl:call-template name="lbrk-app"/>
   </xsl:template>


    <!-- tpl-translation -->
    <xsl:template name="tpl-translation">
        <!-- $textpart-id = xml:id des div editions -->
        <xsl:param name="textpart-id"/>
        <xsl:variable name="trans-path" select="//tei:*[substring-after(@corresp, '#') = $textpart-id][ancestor-or-self::tei:div[@type='translation']]"/>
            <xsl:choose>
                <xsl:when test="$trans-path">
                            <xsl:apply-templates select="$trans-path"/>
                    <xsl:if test="$trans-path/child::tei:note">
                        <hr/>
                        <div class="bloc-notes">
                            <h6>Notes</h6>
                            <span class="notes-translation">
                                <!-- An entry is created for-each of the following instances
                                * notes.  -->
                                <xsl:for-each select="$trans-path/tei:note">
                                    <span>
                                        <xsl:call-template name="generate-trans-link">
                                            <xsl:with-param name="situation" select="'apparatus-internal'"/>
                                        </xsl:call-template>
                                        
                                        <xsl:apply-templates/>
                                    </span>
                                    <xsl:call-template name="lbrk-app"/>
                                </xsl:for-each>
                            </span>
                        </div>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <p>No translation available yet for this part of the edition <xsl:value-of select="$filename"/></p>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template name="translation-bottom-notes">
        <ol>
            <xsl:for-each select="tei:text/tei:body/tei:div[@type='translation']/descendant-or-self::tei:note">
                  <li><xsl:call-template name="generate-trans-link">
                    <xsl:with-param name="situation" select="'apparatus-bottom'"/>
                </xsl:call-template>
                <xsl:apply-templates/></li>
        </xsl:for-each>
        </ol>
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
                    <xsl:text>n. </xsl:text>
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
    
    <!-- source display hidden by default -->
    <!-- structure préparée, mais contenu à faire -->
    <xsl:template name="source-display">
        <xsl:variable name="file-content" select="unparsed-text($fileuri)"/>
        <div id="inscription-source" class="hidden">
            <xsl:call-template name="fieldset-source-display"/>
            <div id="xml" class="xml xml-wrap xml-lines-nos">
                <!-- découper xml en lignes -->
                <xsl:variable name="file-lines" select="tokenize($file-content, '\r?\n')"/>
                <xsl:for-each select="$file-lines">
                        <div class="xml-line">
                            <span class="xml-line-no hidden">
                                <xsl:choose>
                                    <!-- il manque le 1 dans mon système, mais les autres lignes sont numérotées donc c'est déjà ça -->
                                    <xsl:when test="(position() mod 5) = 0">
                                        <xsl:value-of select="position()"/>
                                    </xsl:when>
                                    <xsl:otherwise>.</xsl:otherwise>
                                </xsl:choose>
                                </span>
                            <span class="xml-line-contents">
                                <!-- pour le moment, je n'ai mis en place que l'identification des lignes de processing-instructions -->
                                <xsl:choose>
                                    <xsl:when test="matches(., '&lt;?xml')">
                                        <span class="instruction"><xsl:copy-of select="."/></span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </span>
                        </div>
                    </xsl:for-each>                
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="fieldset-source-display">
        <fieldset>
            <legend>Display Options</legend>
            <label>Word Wrap
                <input class="display-option" name="xml-wrap" type="checkbox" checked=""/>
            </label>
            <label>Line Numbers
                <input class="display-option" name="xml-line-nos" type="checkbox" checked=""/>
            </label>
            <label>Comments
                <input class="display-option" name="xml-hide-comments" type="checkbox" checked=""/>
            </label>
            <label>Processing Instructions
                <input class="display-option" name="xml-hide-instructions" type="checkbox" checked=""/>
            </label>
        </fieldset>
    </xsl:template>
</xsl:stylesheet>

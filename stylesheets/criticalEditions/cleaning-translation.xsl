<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="tei xi fn functx">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- need to add processing instruction -->
    <xsl:template match="/">
        <xsl:element name="TEI">
            <xsl:attribute name="xml:lang">eng</xsl:attribute>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:attribute name="corresp">#skk</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <xsl:element name="ref">
            <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:value-of select="@target"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Translation of the Saṅ Hyaṅ Siksa Kandaṅ Karəsian</title>
                    <editor ref="part:adgu">
                        <name>Aditia Gunawan</name>
                    </editor>
                </titleStmt>
                <publicationStmt>
                    <authority>DHARMA</authority>
                    <pubPlace>Paris</pubPlace>
                    <idno type="filename">DHARMA_CritEdSiksaKandangKaresian_transEng01</idno>
                    <!-- Replace by filename following FNC -->
                    <availability>
                        <licence target="https://creativecommons.org/licenses/by/4.0/">
                            <p>This work is licenced under the Creative Commons Attribution 4.0 Unported Licence. To view a copy of the licence, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.</p>
                            <p>Copyright (c) 2019-2025 by Aditia Gunawan.</p>
                        </licence>
                    </availability>
                    <date from="2019" to="2025">2019-2025</date>
                </publicationStmt>
                <!-- <notesStmt><note><bibl>Digital translation of <bibl><ptr target="bib:"></ptr></bibl>.<relatedItem target=""></relatedItem></bibl></note></notesStmt>-->
                <!-- provide a notesStmt if you need to add some precision regarding the establishement of the translation -->
                <sourceDesc>
                    <biblFull> <!-- Copy and paste the titleStmt and publicationStmt of the edition file -->           <titleStmt>
                        <title type="main">Saṅ Hyaṅ Siksa Kandaṅ Karəsian</title>
                        <title type="sub" subtype="editorial">Digital Critical Edition and Translation</title>
                        <editor ref="part:adgu">
                            <name>Aditia Gunawan</name>
                        </editor>
                        <respStmt>
                            <resp>structuring of the TEI file</resp>
                            <persName>Aditia Gunawan</persName>
                        </respStmt>
                    </titleStmt>
                        <publicationStmt>
                            <authority>DHARMA</authority>
                            <pubPlace>Paris</pubPlace>
                            <idno type="filename">DHARMA_CritEdSiksaKandangKaresian</idno>
                            <availability>
                                <licence target="https://creativecommons.org/licenses/by/4.0/">
                                    <p>This work is licensed under the Creative Commons Attribution 4.0 Unported Licence. To view a copy of the licence, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.</p>
                                    <p>Copyright (c) 2019-2025 by Aditia Gunawan.</p>
                                </licence>
                            </availability>
                            <date from="2019" to="2025">2019-2025</date>
                        </publicationStmt>
                    </biblFull>
                    <!-- if your translation is a copy of already published one: fill a biblStruct -->
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <projectDesc>
                    <!-- Part mandatory -->
                    <p>This project has received funding from the European Research Council (ERC) under the European Union's Horizon 2020 research and innovation programme (grant agreement no 809994).</p>
                    <p></p>
                </projectDesc>
            </encodingDesc>
            <revisionDesc>
                <change who="part:adgu" when="2021-12-15" status="draft">Creating the file for the translation</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
    
    <xsl:template match="tei:anchor"/>
    
    <xsl:template match="tei:body">
        <xsl:element name="body">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:date"/>
    
    <xsl:template match="tei:div[child::tei:p[@rend='Title']]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:div[child::tei:head]">
        <xsl:choose>
            <xsl:when test="matches(child::tei:head, '\d+\.\s')">
                <xsl:element name="div">
                    <xsl:attribute name="corresp">
                        <xsl:text>#skk_</xsl:text>
                        <xsl:choose>
                            <xsl:when test="matches(child::tei:head, '\d\d\.\s')">
                                <xsl:value-of select="substring-before(child::tei:head, '.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0</xsl:text>
                                <xsl:value-of select="substring-before(child::tei:head, '.')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:head"/>
        
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='color(ff00ff)'"/>
            <xsl:when test="@rend='italic'">
                <xsl:element name="foreign">
            <xsl:apply-templates/>
        </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:note[@place='comment']"/>
    
    <xsl:template match="tei:note[not(@place='comment')]">
        <xsl:element name="note">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:p[@rend='Title']"/>
    
    <xsl:template match="tei:p[@rend='Subtitle']"/>
    
    <xsl:template match="tei:p[child::tei:hi[@rend='color(ff00ff)']]"/>
    
    <xsl:template match="tei:p[parent::tei:note]">
        <xsl:apply-templates/>
    </xsl:template>
        
    <xsl:template match="tei:p[not(parent::tei:note or @rend='Title' or @rend='Subtitle' or child::tei:hi[@rend='color(ff00ff)'])]">
            <xsl:element name="p">
                <xsl:attribute name="n">
                    <xsl:value-of select="substring-after(preceding-sibling::tei:head[1], '.')"/>
                </xsl:attribute>
            <xsl:attribute name="corresp">
                <xsl:text>#skk_</xsl:text>
                <xsl:choose>
                    <xsl:when test="matches(preceding-sibling::tei:head[1], '\d\d\.\d\d')">
                        <xsl:value-of select="preceding-sibling::tei:head[1]"/>
                    </xsl:when>
                    <xsl:when test="matches(preceding-sibling::tei:head[1], '\d\d\.\d')">
                        <xsl:value-of select="substring-before(preceding-sibling::tei:head[1], '.')"/>
                        <xsl:text>.</xsl:text>
                        <xsl:text>0</xsl:text>
                        <xsl:value-of select="substring-after(preceding-sibling::tei:head[1], '.')"/>
                    </xsl:when>
                    <xsl:when test="matches(preceding-sibling::tei:head[1], '\d\.\d\d')">
                        <xsl:text>0</xsl:text>
                        <xsl:value-of select="substring-before(preceding-sibling::tei:head[1], '.')"/>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="substring-after(preceding-sibling::tei:head[1], '.')"/>
                    </xsl:when>
                    <xsl:when test="matches(preceding-sibling::tei:head[1], '\d\.\d')">
                        <xsl:text>0</xsl:text>
                        <xsl:value-of select="substring-before(preceding-sibling::tei:head[1], '.')"/>
                        <xsl:text>.0</xsl:text>
                        <xsl:value-of select="substring-after(preceding-sibling::tei:head[1], '.')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:text">
        <xsl:element name="text">
            <xsl:attribute name="xml:space">preserve</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!--<xsl:template match="tei:p/text()">
                <xsl:analyze-string select="." regex="\[(.)\]">
                    <xsl:matching-substring>
                        <xsl:element name="supplied">
                            <xsl:attribute name="reason">subaudible</xsl:attribute>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:element>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:apply-templates/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
    </xsl:template>-->
    
</xsl:stylesheet>
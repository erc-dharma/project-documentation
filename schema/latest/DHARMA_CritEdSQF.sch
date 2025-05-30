﻿<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="t"/>
    
    <xsl:function name="functx:sequence-node-equal-any-order" as="xs:boolean"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="seq1" as="node()*"/>
        <xsl:param name="seq2" as="node()*"/>
        
        <xsl:sequence select="
            not( ($seq1 except $seq2, $seq2 except $seq1))
            "/>
        
    </xsl:function>
    
    
    <sch:pattern>
        <sch:rule context="t:*/@source"><sch:assert test="starts-with(.,'bib:')" sqf:fix="bib-prefix-source bib-prefix-target">Bibliographic
            prefix is bib:</sch:assert>
            
            <sqf:fix id="bib-prefix-source">
                <sqf:description>
                    <sqf:title>Add the bibliographic prefix</sqf:title>
                </sqf:description>
                <sqf:replace match="." node-type="attribute" target="source" select="concat('bib:', .)"/>
            </sqf:fix>
            <sqf:fix id="bib-prefix-target">
                <sqf:description>
                    <sqf:title>Add the bibliographic prefix</sqf:title>
                </sqf:description>
                <sqf:replace match="." node-type="attribute" target="target" select="concat('bib:', .)"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the syntax for @ref with edtior-->
    <sch:pattern>
        <sch:rule context="t:*/@resp | t:editor/@ref">
            <sch:assert test="starts-with(.,'part:') or starts-with(.,'http')" sqf:fix="part-prefix-addition http-prefix-addition">Project members prefix is
                part: or a http/https link for people not associated with the project.</sch:assert>
            <sqf:fix id="part-prefix-addition">
                <sqf:description>
                    <sqf:title>Add prefix part: for project members</sqf:title>
                </sqf:description>
                <sqf:replace match="." node-type="attribute" target="resp" select="concat('part:', .)"/>
            </sqf:fix>
            
            <sqf:fix id="http-prefix-addition">
                <sqf:description>
                    <sqf:title>Add "http://" to start creating a link  for non-members project</sqf:title>
                </sqf:description>
                <sqf:replace match="." node-type="attribute" target="resp" select="concat('http', .)"/>
            </sqf:fix>
        </sch:rule>
        
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="t:div[@type='translation']">
            <sch:report test="@xml:lang='eng'" sqf:fix="eng-translation">@xml:lang="eng" shouldn't be used with div[@type='translation']</sch:report>
            <sqf:fix id="eng-translation">
                <sqf:description>
                    <sqf:title>Delete @xml:lang="eng"</sqf:title>
                </sqf:description>
                <sqf:delete match="."/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="t:div[@type='edition']//t:l">
            <sch:assert test="parent::t:lg">Line verses should be wrapped into lg element</sch:assert>
        </sch:rule> 
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="t:div[@type='translation']//t:l">
            <sch:assert test="parent::t:p">Line verses should be wrapped into a paragraph in translation as parent, lg element is not expected inside translations.</sch:assert></sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/">
            <sch:let name="fileName" value="tokenize(document-uri(/), '/')[last()]"/>
            <sch:assert test="starts-with($fileName, 'DHARMA_CritEd') or starts-with($fileName, 'DHARMA_DiplEd')">The filename should start with DHARMA_CritEd and is currently or DiplEd "<sch:value-of select="$fileName"/>"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="//t:idno[@type='filename'][not(ancestor::t:biblFull)]">
            <sch:let name="idno-fileName" value="tokenize(document-uri(/), '/')[last()]"/>
            <sch:assert test="./text() eq $idno-fileName">The idno[@type='filename'] must match the filename of the file "<sch:value-of select="$idno-fileName"/>"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:let name="list-id" value="doc('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_idListMembers_v01.xml')"/>
        <sch:rule context="//t:teiHeader//t:persName/@ref[contains(., 'part:')]|//t:*/@resp">
            <sch:let name="tokens" value="for $i in tokenize(., ' ') return substring($i, 6)"/>
            <sch:assert test="every $token in $tokens satisfies $token = $list-id//t:person/@xml:id">The attribute value must match a defined @xml:id in DHARMA list members</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <!-- Check if the ST exists in Zotero -->
        <sch:rule context="t:*/@source[starts-with(., 'bib:')] |t:*/@target[starts-with(., 'bib:')]">
            <sch:let name="biblEntries" value="for $w in tokenize(., '\s+') return substring-after($w,'bib:')"/>
            <sch:let name="test-presence" value="every $biblEntry in $biblEntries satisfies doc-available(concat('https://dharmalekha.info/zotero-proxy/extra?shortTitle=', encode-for-uri($biblEntry), '&amp;format=tei'))"/>
            <sch:report test="not($test-presence)">The Short Title doesn't seem to exist in Zotero</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <!-- Make sure the ST matches one item and not several -->
        <sch:rule context="t:*/@source[starts-with(., 'bib:')] |t:*/@target[starts-with(., 'bib:')]">
            <sch:let name="biblEntries" value="for $w in tokenize(., '\s+') return substring-after($w,'bib:')"/>
            <sch:assert test="every $biblEntry in $biblEntries satisfies 1 eq count(document(concat('https://dharmalekha.info/zotero-proxy/extra?shortTitle=', encode-for-uri($biblEntry), '&amp;format=tei'))//t:biblStruct)">The Short Title seems to match several entities in Zotero Library</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the witnesses -->
    <sch:pattern>
        <sch:rule context="@wit">
            <sch:let name="witnesses" value="for $w in tokenize(., '\s+') return substring-after($w, '#')"/>
            <sch:assert test="every $witnesse in $witnesses satisfies $witnesses = //t:TEI//t:listWit//@xml:id">
                Every reading witness (@wit) after the hashtag must match an xml:id defined in the list of witnesses in this file!
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the syntax for @xml:id -->
    <sch:pattern>
        <sch:rule context="@xml:id">
            <sch:report test="starts-with(., '#')">
                @xml:id attributes must not begin with a hashtag!
            </sch:report>
        </sch:rule>
    </sch:pattern> 
    
    <!-- controlling the syntax for @corresp -->
    <sch:pattern>
        <sch:rule context="@corresp">
            <sch:assert test="starts-with(., '#') or starts-with(., 'https')">
                @corresp attributes must begin with a hashtag or a uri with 'https'. 
            </sch:assert>
        </sch:rule>
    </sch:pattern> 
    
    <!-- controlling the syntax for @corresp -->
    <sch:pattern>
        <sch:rule context="@sameAs">
            <sch:assert test="starts-with(., '#')">
                @sameAs attributes must begin with a hashtag. 
            </sch:assert>
        </sch:rule>
    </sch:pattern> 
    
    <!-- controlling the syntax for @wit -->
    <sch:pattern>
        <sch:rule context="@wit">
            <sch:let name="wit-contents" value="for $w in tokenize(., '\s+') return $w"/>
            <sch:assert test="every $wit-content in $wit-contents satisfies starts-with($wit-content, '#')">
                @wit declarations must  begin with a hashtag!
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the syntax for @hand -->
    <sch:pattern>
        <sch:rule context="@hand">
            <sch:let name="hand-contents" value="for $w in tokenize(., '\s+') return $w"/>
            <sch:assert test="every $hand-content in $hand-contents satisfies starts-with($hand-content, '#')">
                @hand  must  begin with a hashtag
            </sch:assert>
            <sch:assert test="every $hand-content in $hand-contents satisfies substring-before(substring-after($hand-content, '#'), '_') = //t:TEI//t:listWit//@xml:id">@hand should match a witness's @xml:id</sch:assert>
            <sch:assert test="every $hand-content in $hand-contents satisfies matches($hand-content, '_[H]\d$')">
                A hand should be declare after the @xml:id of the witness followed by an underscore, a uppercase letter H and a number (mostly with a single digit). 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the syntax for @target with ptr -->
    <sch:pattern>
        <sch:rule context="t:ptr/@target[not(parent::t:bibl)]">
            <sch:let name="contents" value="for $w in tokenize(., '\s+') return $w"/>
            <sch:assert test="every $content in $contents satisfies starts-with($content, '#') or starts-with($content, 'bib:')">
                The content of the attribute @target used on its own should start with '#' or 'bib:'. 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the beginning of the value for calendar and datingMethod -->
    <sch:pattern>
        <sch:rule context="t:*/@calendar | t:*/@datingMethod">
            <sch:let name="calendarValues" value="for $w in tokenize(., '\s+') return $w"/>
            <sch:assert test="starts-with($calendarValues, 'cal:')">
                The attributes @calendar and @datingMethod must starts with the prefixe "cal:"
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the prosody with @met -->
    <sch:pattern>
        <sch:rule context="t:div/@met[not(matches(.,'[=\+\-]+') or contains(., 'free'))] | t:lg/@met[not(matches(.,'[=\+\-]+') or contains(., 'free'))]">
            <sch:let name="prosody" value="doc('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_prosodicPatterns_v01.xml')"/>
            <!--<sch:let name="metricals" value="for $metrical in tokenize(., '\s+') return $metrical"/>
            <sch:assert test="every $metrical in $metricals satisfies $metricals = $prosody//t:item/t:name">The attribute @met should match one entry in the prosodic patterns file, when filled with textual content.</sch:assert>-->
            <sch:assert test=".= $prosody//t:item/t:name">The attribute @met should match one entry in the prosodic patterns file, when filled with textual content.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- to do vérifier les lacunae -->
    <!--<sch:pattern>
        <sch:rule context="t:lacunaStart">
            <sch:let name="witness-related" value="parent::t:rdg/@wit"/>
            <sch:assert test="./following::t:lacunaEnd/parent::t:rdg[@wit= $witness-related]">
                Check this lacuna, it might not have a matching ending
            </sch:assert>
        </sch:rule>
    </sch:pattern>-->
    
    <!-- compter les lacunae -->
    <!--<sch:pattern>
        <sch:rule context="t:lacunaStart | t:lacunaEnd">
            <sch:let name="num-lacunaStart" value="count(//t:lacunaStart)"/>
            <sch:let name="num-lacunaEnd" value="count(//t:lacunaEnd)"/>
            <sch:assert test="$num-lacunaStart = $num-lacunaEnd">
                The number of lacunaStart (<xsl:value-of select="$num-lacunaStart"/>) doesn't match the one from
                lacunaEnd (<xsl:value-of select="$num-lacunaEnd"/>), please check them.
            </sch:assert>
        </sch:rule>
    </sch:pattern>-->
    
    <!-- to do vérifier les omissions -->
    <!--<sch:pattern>
        <sch:rule context="t:span[@type='omissionStart']">
            <sch:let name="witness-related" value="parent::t:rdg/@wit"/>
            <sch:assert test="./following::t:span[@type='omissionEnd']/parent::t:rdg[@wit= $witness-related]">
                Check this omission, it might not have a matching ending.
            </sch:assert>
        </sch:rule>
    </sch:pattern>-->
    
    <!-- compter les omissions -->
    <!--<sch:pattern>
        <sch:rule context="t:span[@type='omissionStart'] | t:span[@type='omissionEnd']">
            <sch:let name="num-omStart" value="count(//t:span[@type='omissionStart'])"/>
            <sch:let name="num-omEnd" value="count(//t:span[@type='omissionEnd'])"/>
            <sch:assert test="$num-omStart = $num-omEnd">
                The number of omissionStart (<xsl:value-of select="$num-omStart"/>) doesn't match the one from
                omissionEnd (<xsl:value-of select="$num-omEnd"/>), please check them.
            </sch:assert>
        </sch:rule>
    </sch:pattern>-->
    
    <!-- controlling ref on rs - BESTOW addition-->
    <sch:pattern>
        <sch:rule context="t:rs/@ref">
            <sch:let name="list-id" value="doc('https://raw.githubusercontent.com/erc-dharma/BESTOW/main/DHARMA_BestAuthorities.xml')"/>
            <sch:assert test=".[starts-with(., 'best:')]">ref must starts with best:</sch:assert>
            <sch:assert test="substring-after(., 'best:') = $list-id//t:item/@xml:id">the value inside ref must match a value declared in BESTOW authorities file</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>

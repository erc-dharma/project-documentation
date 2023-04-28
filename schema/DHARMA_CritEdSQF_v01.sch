<?xml version="1.0" encoding="UTF-8"?>
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
        <sch:rule context="t:TEI[@type='translation']/t:text">
            <sch:report test="./@xml:lang='eng'" sqf:fix="eng-translation">@xml:lang="eng" shouldn't be used with div[@type='translation']</sch:report>
            <sqf:fix id="eng-translation">
                <sqf:description>
                    <sqf:title>Delete @xml:lang="eng"</sqf:title>
                </sqf:description>
                <sqf:delete match="."/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
 
    <sch:pattern>
        <sch:rule context="t:TEI[@type='edition']//t:l">
            <sch:assert test="parent::t:lg">Line verses should be wrapped into lg element</sch:assert>
        </sch:rule> 
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="t:TEI[@type='translation']//t:l">
            <sch:assert test="parent::t:p">Line verses should be wrapped into a paragraph in translation as parent, lg element is not expected inside translations.</sch:assert></sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/">
            <sch:let name="fileName" value="tokenize(document-uri(/), '/')[last()]"/>
            <sch:assert test="starts-with($fileName, 'DHARMA_CritEd')">The filename should start with DHARMA_CritEd and is currently "<sch:value-of select="$fileName"/>"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="//t:idno[@type='filename'][not(ancestor::t:biblFull)]">
            <sch:let name="idno-fileName" value="substring-before(tokenize(document-uri(/), '/')[last()], '.xml')"/>
            <sch:assert test="./text() eq $idno-fileName">The idno[@type='filename'] must match the filename of the file "<sch:value-of select="$idno-fileName"/>"; without the extension ".xml"  </sch:assert>
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
            <sch:let name="biblEntries" value="for $w in tokenize(replace(., '\+', '%2B'), '\s+') return substring-after($w,'bib:')"/>
            <sch:let name="test-presence" value="every $biblEntry in $biblEntries satisfies doc-available(replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblEntry, '&amp;format=tei'), 'amp;', ''))"/>
            <sch:report test="not($test-presence)">The Short Title doesn't seem to exist in Zotero</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <!-- Make sure the ST matches one item and not several -->
        <sch:rule context="t:*/@source[starts-with(., 'bib:')] |t:*/@target[starts-with(., 'bib:')]">
            <sch:let name="biblEntries" value="for $w in tokenize(replace(., '\+', '%2B'), '\s+') return substring-after($w,'bib:')"/>
            <sch:assert test="every $biblEntry in $biblEntries satisfies 1 eq count(document(replace(concat('https://api.zotero.org/groups/1633743/items?tag=', $biblEntry, '&amp;format=tei'), 'amp;', ''))//t:biblStruct)">The Short Title seems to match several entities in Zotero Library</sch:assert>
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
            <sch:assert test="starts-with(., '#') or starts-with(., 'txt:') or starts-with(., 'https')">
                @corresp attributes must begin with a hashtag, a 'txt:' reference or a uri with 'https'. 
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
            <sch:assert test="every $content in $contents satisfies starts-with($content, '#') or starts-with($content, 'bib:') or starts-with($content, 'txt:')">
                The content of the attribute @target used on its own should start with '#', 'bib:' or 'txt:'. 
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
    
    <!-- controlling the prosdoy with @met -->
    <sch:pattern>
        <sch:rule context="t:div/@met[not(matches(.,'[=\+\-]+') or contains(., 'free'))] | t:lg/@met[not(matches(.,'[=\+\-]+') or contains(., 'free'))]">
            <sch:let name="prosody" value="doc('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_prosodicPatterns_v01.xml')"/>
            <sch:let name="metricals" value="for $metrical in tokenize(., '\s+') return $metrical"/>
            <sch:assert test="every $metrical in $metricals satisfies $metricals = $prosody//t:item/t:name">The attribute @met should match one entry in the prosodic patterns file, when filled with textual content.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- controlling the corresp for translation -->
    <sch:pattern>
        <sch:rule context="t:*[@corresp][ancestor::t:TEI[@type='translation']]">
            <sch:let name="current-translation" value="substring-before(tokenize(document-uri(/), '/')[last()], '_transEng01.xml')"/>
            <sch:let name="editionfile" value="doc(concat('https://raw.githubusercontent.com/erc-dharma/tfd-nusantara-philology/master/editions/', $current-translation, '.xml'))"/>
            <sch:let name="textpart-id" value="for $id in substring-after(tokenize(@corresp, '\s+'), '#') return $id"/>
            <sch:assert test="every $id in $textpart-id satisfies $textpart-id = $editionfile//t:*/@xml:id">@corresp not found in edition file.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- sqf under build -->
    <!-- controlling the presence of witnesses -->
    <!--<sch:pattern>
        
        <sch:rule context="t:app//@wit">
            <!-\- making a list of the sigla -\->
            <sch:let name="witnesses-list" value=""/>
            <!-\- making a list of all the values -\->
            <sch:let name="witnesses-app" value="string-join(.//@wit, ' ')"/>
            <sch:assert test="functx:sequence-node-equal-any-order($witnesses-app, $witnesses-list)">all witnesses should be declares in app entries.</sch:assert>
        </sch:rule>
    </sch:pattern>-->
    <!--<sch:pattern>
        <sch:rule context="t:app">
            <sch:let name="wit-contents" value="for $w in tokenize(.//@wit, '\s+') return $w"/>
            
            <sch:assert test="count($wit-contents) = $witnesses-list">
                all witnesses should be declares in app entries.
            </sch:assert>
        </sch:rule>
    </sch:pattern>-->
    
    <!-- sorting the witnesses -->
    <!--<sch:pattern>
        <sch:rule context="@wit[contains(., ' ')]">
            <sch:let name="wit-contents" value="for $w in tokenize(., '\s+') return substring-after($w, '#')"/>
            <sch:let name="witnesses-list" value="//t:TEI//t:listWit/t:witness/@xml:id"/>
            <sch:assert test="deep-equal($witnesses-list, $wit-contents)">
                Please check the order of the witness<xsl:value-of select="$witnesses-list"/>
            </sch:assert>
        </sch:rule>
        
    </sch:pattern>
    -->
    <!-- vérifier la présence de tous les témoins -->
    <sch:pattern>
        <sch:rule context="t:app[not(parent::t:listApp[@type='parallels'])]">
            <!-- on compte les témoins déclarés-->
            <sch:let name="witnesses-list" value="count(//t:TEI//t:listWit/t:witness/@xml:id)"/>
            <sch:let name="witnesses-app" value="count(tokenize(string-join(./t:*[not(t:witDetail)]/@wit, ' '), '\s'))"/>            
            <sch:assert test="$witnesses-app = $witnesses-list">every apparatus entry should have the same number of witnesses as declared in the teiHeader</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>

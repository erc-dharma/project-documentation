<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.tei-c.org/ns/1.0">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="t"/>

    <sch:pattern>
        <sch:rule context="//t:text//t:ptr/@target| //t:*/@source"><sch:assert test="starts-with(.,'bib:')" sqf:fix="bib-prefix-source bib-prefix-target">Bibliographic
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

    <sch:pattern>
        <sch:rule context="t:*/@resp">
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
            <sch:report test="./@xml:lang='eng'" sqf:fix="eng-translation">@xml:lang="eng" shouldn't
                be used with div[@type='translation']</sch:report>

            <sqf:fix id="eng-translation">
                <sqf:description>
                    <sqf:title>Delete @xml:lang="eng"</sqf:title>
                </sqf:description>
                <sqf:delete match="."/>
            </sqf:fix>
        </sch:rule>
        <sch:rule context="t:div[@type='translation']">
            <sch:assert test="./@resp|./@source" sqf:fix="resp-translation source-translation">An attribute @resp or @source is mandatory</sch:assert>
            <sqf:fix id="resp-translation">
                <sqf:description>
                    <sqf:title>Add @resp for a DHARMA member author of the translation</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="resp"/>
            </sqf:fix>

            <sqf:fix id="source-translation">
                <sqf:description>
                    <sqf:title>Add @source for translation taken from a published source</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="source"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="t:bibl[parent::t:listBibl[@type='primary']]">
            <sch:assert test="./@n" sqf:fix="add-siglum">@n mandatory in
                the primary bibliography to declare
                sigla</sch:assert>

            <sqf:fix id="add-siglum">
                <sqf:description>
                    <sqf:title>Add @n for the siglum</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="n"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <!--<sch:pattern>
        <sch:rule context="t:app">
            <sch:assert test="./@loc" sqf:fix="add-loc">@loc is mandatory on the app element</sch:assert>
            <sqf:fix id="add-loc">
                <sqf:description>
                    <sqf:title>Add @loc on app</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="loc"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>-->
    <sch:pattern>
        <sch:rule context="t:div[@type='edition']//t:l">
            <sch:assert test="./@n">Line verses should be numered with @n attribute</sch:assert>
        </sch:rule>
    </sch:pattern>
        <!-- not working -->
        <sch:pattern>
            <sch:rule context="t:div[@type='edition']//t:l">
            <sch:assert test="parent::t:lg">Line verses should be wrapped into lg element</sch:assert>
        </sch:rule> </sch:pattern>
    <sch:pattern>
        <sch:rule context="t:div[@type='translation']//t:l">
            <sch:assert test="parent::t:p">Line verses should be wrapped into a paragraph in translation as parent, lg element is not expected inside translations.</sch:assert></sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="/">
            <sch:let name="fileName" value="tokenize(document-uri(/), '/')[last()]"/>
            <sch:assert test="starts-with($fileName, 'DHARMA_INS') or starts-with($fileName, 'DHARMA_DiplEd')">The filename should start with DHARMA_INS or DHARMA_DiplEd, and is currently "<sch:value-of select="$fileName"/>"</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="//t:idno[@type='filename']">
            <sch:let name="idno-fileName" value="substring-before(tokenize(document-uri(/), '/')[last()], '.xml')"/>
            <sch:assert test="./text() eq $idno-fileName">The idno[@type='filename'] must match the filename of the file "<sch:value-of select="$idno-fileName"/>"; without the extension ".xml"  </sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:let name="list-id" value="doc('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_IdListMembers_v01.xml')"/>
        <!--<sch:let name="list-id" value="doc('https://gitcdn.link/repo/erc-dharma/project-documentation/master/DHARMA_IdListMembers_v01.xml')"/>-->
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
    
    <!-- Adding codes to check the content of the attribute @rendition - juillet 2021 -->
    <sch:pattern>
        <sch:rule context="t:*/@rendition">
            <sch:assert test="contains(.,'class:') and contains(.,'maturity:')">The content of the attribute @corresp should contained ids for both script classification and script maturity, respectively represented by the following prefixes "class:" and "maturity:".</sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>

<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="t"/>
    
    <sch:pattern>
        <sch:rule context="@source"><sch:assert test="starts-with(.,'bib:')" sqf:fix="bib-prefix-addition">Bibliographic
            prefix is bib:</sch:assert>
            
            <sqf:fix id="bib-prefix-addition">
                <sqf:description>
                    <sqf:title>Add the bibliographic prefix</sqf:title>
                </sqf:description>
                <sqf:replace match="." node-type="attribute" target="source" select="concat('bib:', .)"/>
            </sqf:fix>                            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="@resp">
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
            <sch:report test="@xml:lang='eng'" sqf:fix="eng-translation">@xml:lang="eng" shouldn't
                be used with div[@type='translation']</sch:report>
            
            <sqf:fix id="eng-translation">
                <sqf:description>
                    <sqf:title>Delete @xml:lang="eng"</sqf:title>
                </sqf:description>
                <sqf:delete match="."/>
            </sqf:fix>  
        </sch:rule>
        <sch:rule context="t:div[@type='translation']"> 
            <sch:assert test="@resp or @source" sqf:fix="resp-translation source-translation">An attribute @resp or @source is mandatory</sch:assert>
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
        <sch:rule context="t:div[@type='translation']">
            <sch:report test="@resp and @source">@resp and @source can
                not be used together</sch:report>
        </sch:rule>
        <sch:rule context="t:div[@type='translation']/t:p">
            <sch:assert test="child::t:l">Line verses should be wrapped into a paragraph in translation.</sch:assert></sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="t:listBibl[@type='primary']">
            <sch:assert test="child::t:bibl[@n]" sqf:fix="add-siglum">@n mandatory in
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
    
    <sch:pattern>
        <sch:rule context="t:app">
            <sch:assert test="@loc" sqf:fix="add-loc">@loc is mandatory on the app element</sch:assert>
            <sqf:fix id="add-loc">
                <sqf:description>
                    <sqf:title>Add @loc on app</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="loc"/>
            </sqf:fix>  
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="t:l[ancestor::t:div[@type='edition']]">
            <sch:assert test="@n">Line verses should be numered with @n attribute</sch:assert>
        </sch:rule>
        <sch:rule context="t:l[ancestor::t:div[@type='edition']]">
            <sch:assert test="parent::t:lg">Line verses should be wrapped into lg element</sch:assert>
        </sch:rule>   
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/">
            <sch:let name="fileName" value="tokenize(document-uri(/), '/')[last()]"/>
            <sch:assert test="starts-with($fileName, 'DHARMA_INS')">The filename should starts with DHARMA_INS, and is currently "<sch:value-of select="$fileName"/>"</sch:assert>
        </sch:rule>
        <sch:rule context="publicationStmt">
            <sch:let name="idno-fileName" value="substring-before(tokenize(document-uri(/), '/')[last()], '.xml')"/>
            <sch:assert test="t:idno[@type='filename'] eq $idno-fileName">The idno[@type='filename'] must match the filename of the file without the extension ".xml"</sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    <sch:pattern>
        <sch:let name="list-id" value="doc('https://raw.githubusercontent.com/erc-dharma/project-documentation/master/DHARMA_IdListMembers_v01.xml')"/>
        
        <sch:rule context="@resp |@ref">
            <sch:let name="tokens" value="for $i in tokenize(substring-after(.,'part:'), '\s+') return $i"/>
            <sch:assert test="every $token in $tokens satisfies $token = $list-id//t:person/@xml:id">The attribute value must match a defined @xml:id in DHARMA list members</sch:assert>
        </sch:rule>
        
    </sch:pattern>
</sch:schema>
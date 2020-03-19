<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="t xs"
    version="2.0">
    
    <xsl:template name="campanotenum">
        <!-- build a list of sequential, html-reading-order ids for all notes users will see, then look up the appropriate entry in
            this list for the current context node -->
        <!-- html document order differs from xml document order, so generating a sequential note number is a bit tricky. This template
         creates a sequence of generated ids for note elements in the document in the order they're transformed into html output. By
         finding the index of a note's generated id in this list, we can get the sequence number we seek -->
        <!-- tricky bit is that notes can get called into one context by ptr inclusion from another context in document order -->
        <xsl:variable name="noteids" as="xs:string *">
            <xsl:for-each select="//t:physDesc//node(), //t:msContents//node()[not(ancestor::t:msItem)], //t:origDate//node(), //t:origPlace//node(), //t:provenance//node(), //t:div[@type='bibliography' and @subtype='edition']//node(), //t:surrogates//node(), //t:div[@type='translation']//node(), //t:div[@type='commentary']//node(), //t:div[@type='bibliography' and @subtype='secondary']//node()">
                <xsl:choose>
                    <xsl:when test="local-name()='note'">
                        <xsl:sequence select="xs:string(generate-id(.))"/>
                    </xsl:when>
                    <xsl:when test="local-name()='ptr' and starts-with(@target, '#')">
                        <xsl:message>generating id for ptr: <xsl:value-of select="generate-id(.)"/></xsl:message>
                        <xsl:variable name="sought" select="substring-after(@target, '#')"/>
                        <xsl:choose>
                            <xsl:when test="//*[@xml:id=$sought and descendant::t:note]">
                                <xsl:sequence select="xs:string(generate-id(//*[@xml:id=$sought]/descendant::t:note[1]))"/>
                            </xsl:when>
                            <xsl:when test="//t:idno[@xml:id=$sought and following-sibling::t:note]">
                                <xsl:sequence select="xs:string(generate-id(//t:idno[@xml:id=$sought]/following-sibling::t:note[1]))"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="index-of($noteids, generate-id(.))"/>
    </xsl:template>
    
</xsl:stylesheet>
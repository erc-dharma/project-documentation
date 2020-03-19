<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="t" 
    version="2.0">
    
    <!-- templates for handling tei <ptr> elements to pull in content from elsewhere -->
    
    <xsl:template match="t:ptr[not(@target)]">
        <span class="xformerror">pointer without target not implemented</span>
    </xsl:template>
    <xsl:template match="t:ptr[@target]">        
        <xsl:choose>
            <xsl:when test="starts-with(@target, '#')">
                <xsl:call-template name="ptr-internal"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ptr-external"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="ptr-internal">
        <xsl:message>internal pointer</xsl:message>
        <!-- template to handle a <ptr> to an internal target (i.e., one in the current document -->
        <xsl:variable name="sought" select="substring-after(@target, '#')"/>
        <xsl:if test="not(//*[@xml:id=$sought])">
            <span class="xformerror">cannot find an element with xml:id="<xsl:value-of select="$sought"/> for an internal pointer reference</span>
        </xsl:if>
        <xsl:for-each select="//*[@xml:id=$sought][1]">
            <xsl:element name="span">
            <xsl:attribute name="class" select="local-name()"/>
                <xsl:choose>
                    <xsl:when test="self::t:idno">
                        <xsl:text></xsl:text><xsl:value-of select="."/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:when test="self::t:bibl">
                        <xsl:text></xsl:text><xsl:apply-templates/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="xformerror">don't know how to resolve target of type=<xsl:value-of select="local-name()"/> with xml:id <xsl:value-of select="$sought"/></span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:if test="self::t:idno and following-sibling::t:note">
                <xsl:apply-templates select="following-sibling::t:note"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="ptr-external">
        <!-- template to handle a pointer to an external target (i.e., an external document -->
        <xsl:choose>
            <xsl:when test="contains(@target, ':')">
                <xsl:variable name="prefix" select="substring-before(@target, ':')"/>
                <xsl:variable name="sought" select="substring-after(@target, ':')"/>
                <xsl:message>prefix = <xsl:value-of select="$prefix"/></xsl:message>
                <xsl:message>sought = <xsl:value-of select="$sought"/></xsl:message>
                <xsl:choose>
                    <xsl:when test="$edn-structure='campa'">
                        <xsl:variable name="cic-path">
                            <xsl:choose>
                                <xsl:when test="$prefix = 'cic-bibl'">../../bibliography/biblio.xml</xsl:when>
                                <xsl:when test="$prefix = 'cic-geo'">../../geography/geography.xml</xsl:when>
                                <xsl:otherwise>
                                    <xsl:message>ERROR: untrapped prefix of <xsl:value-of select="$prefix"/> in template name="ptr-external" in file htm-teiptr.xsl</xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="count(document($cic-path, .)/*/descendant-or-self::*[@xml:id=$sought]) &gt; 0">
                                <xsl:for-each select="document($cic-path, .)/*/descendant-or-self::*[@xml:id=$sought][1]">
                                    <xsl:choose>
                                        <xsl:when test="local-name()='biblStruct'">
                                            <xsl:choose>
                                                <xsl:when test="descendant::t:title[@type='short']">
                                                    <xsl:text></xsl:text><a href="../bibliography/#{$sought}"><xsl:value-of select="descendant::t:title[@type='short'][1]"/></a><xsl:text></xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text></xsl:text><span class="check"><a href="../bibliography/#{$sought}"><xsl:value-of select="descendant::t:author[1]/t:surname"/><xsl:text> </xsl:text><xsl:value-of select="descendant::t:imprint/t:date[1]"/></a></span><xsl:text></xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="local-name()='place'">
                                            <xsl:text></xsl:text><a href="../geography#{$sought}"><xsl:value-of select="descendant::t:placeName[1]"/></a><xsl:text></xsl:text>
                                        </xsl:when>
                                        <xsl:when test="local-name()='placeName'">
                                            <xsl:text></xsl:text><a href="../geography#{./../@xml:id}"><xsl:value-of select="."/></a><xsl:text></xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>unexpected local-name() = <xsl:value-of select="local-name()"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="xformerror">failed to find content with xml:id='<xsl:value-of select="$sought"/>' for short prefix of '<xsl:value-of select="$prefix"/>'</span>                        
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="xformerror">external pointers not implemented for $edn-structure != 'campa' (target='<xsl:value-of select="@target"/>')</span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <span class="xformerror">external pointers not implemented for targets like '<xsl:value-of select="@target"/>'</span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
</xsl:stylesheet>
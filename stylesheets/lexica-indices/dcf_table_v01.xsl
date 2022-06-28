<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" indent="no" encoding="UTF-8" />
    <xsl:strip-space elements="*"/>
    
    <xsl:function name="functx:substring-after-last" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>
        <xsl:sequence select="replace($arg,concat('^.*',functx:escape-for-regex($delim)),'')"/>
    </xsl:function>
    <xsl:function name="functx:escape-for-regex" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>  
        <xsl:sequence select="replace($arg,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>     
    </xsl:function>
    
    <xsl:template match="entry">
        <xsl:text>page: </xsl:text>
        <xsl:value-of select="substring-before(substring-after(@n, 'p.'), '-')"/>
        <xsl:text>; </xsl:text>
        <xsl:text>colonne: </xsl:text>
        <xsl:value-of select="functx:substring-after-last(@n, '-')"/>
        <xsl:text>; </xsl:text>
        <xsl:text>entrée: </xsl:text>
        <xsl:value-of select="substring-before(@n, '-')"/>
        <xsl:text>; </xsl:text>
        <xsl:text>romanized: </xsl:text>
        <xsl:value-of select="tc"/>
        <xsl:text>; </xsl:text>
        <xsl:text>cham: </xsl:text>
        <xsl:value-of select="c"/>
        <xsl:text>; </xsl:text>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
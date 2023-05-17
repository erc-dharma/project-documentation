<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- first quick draft to query encoding -->  

    <xsl:variable name="input-sircar" select="doc('https://raw.githubusercontent.com/erc-dharma/BESTOW/main/DHARMA_Sircar1965.xml')"/>
    <xsl:variable name="sircar-ref" select="$input-sircar//tei:div/@xml"/>
    

    
    <xsl:template name="main">
        <xsl:for-each select="collection('/Users/axelle/Documents/github/?select=*.xml;recurse=yes')">            
            <xsl:apply-templates select=".//tei:lg[substring-after(@corresp, '#') = $sircar-ref] | .//tei:p[substring-after(@corresp, '#') = $sircar-ref]"/>
        </xsl:for-each> 

    </xsl:template>       <!-- <xsl:variable name="api-url">
            <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/tfb-somavamsin-epigraphy/contents/texts')"/>
        </xsl:variable>
        <xsl:variable name="json-xml" select="json-to-xml($api-url)"/>
        <xsl:variable name="data">
            <xsl:for-each select="$json-xml/node()//*[@key = 'download_url']">
                <xsl:apply-templates select="document('.')"/>
            </xsl:for-each>
            </xsl:variable>-->
       <!-- <xsl:variable name="data" select="document('https://raw.githubusercontent.com/erc-dharma/tfb-somavamsin-epigraphy/main/texts/DHARMA_INSSomavamsin00001.xml')"/>-->
       
        
          
        
                   
    
 <!--   <xsl:variable name="sircar-ref" select="parent::tei:div/@xml:id"/>
    <xsl:variable name="api-url">
        <xsl:value-of select="unparsed-text('https://api.github.com/repos/erc-dharma/tfb-somavamsin-epigraphy/contents/texts')"/>
    </xsl:variable>
    <xsl:variable name="json-xml" select="json-to-xml($api-url)"/>
    <xsl:variable name="data" select="$json-xml/node()"/>-->

    
</xsl:stylesheet>

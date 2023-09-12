<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="tei xsl">
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- March 2020, Axelle Janiak for DHARMA TFA                           -->
    <!-- Very basic Stylesheet to extract the persName                      -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
        
        <xsl:template match="/">
            <listPerson>
                <xsl:apply-templates select="//tei:div[@type='edition']//tei:persName"/>
            </listPerson> 
        </xsl:template>   
   <xsl:template match=".">
       <person><xsl:value-of select="."/></person>
    </xsl:template>
        
    </xsl:stylesheet>
      
        

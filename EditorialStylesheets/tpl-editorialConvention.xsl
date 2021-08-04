<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs t"
    version="2.0">
    
    <xsl:output indent="yes" encoding="UTF-8" use-character-maps="all-languages"/>
    
    <!-- Transform ' to ’ (apostrophe) in all contextes -->
    <xsl:character-map name="all-languages">
        <xsl:output-character character="'" string="’" />
    </xsl:character-map>
    
    <!-- pattern to copy-paste
    <regex>
            <find></find>
            <change></change>
        </regex>
    -->
    
    <xsl:param name="english-regexes" as="element(regex)*">
        <!-- curly quotes for " -->
        <regex>
            <find>(\s*)"([\w])</find>
            <change>$1“$2</change>
        </regex>
        <regex>
            <find>([\w])"([\s\.]*)</find>
            <change>$1”$2</change>
        </regex>
        
        <!-- curly quotes for ': ‘…’ -->
        <regex>
            <find>(\s*)"([\w])</find>
            <change>$1‘$2</change>
        </regex>
        <regex>
            <find>([\w])"([\s\.]*)</find>
            <change>$1’$2</change>
        </regex>
        
        <!-- Space before + no space after for opening quotation mark.
No space before + space after for closing quotation mark. -->
        <regex>
            <find>(\w)([“‘]+)</find>
            <change>$1 $2</change>
        </regex>
        <regex>
            <find>([“‘]+)\s</find>
            <change>$1</change>
        </regex>
        <regex>
            <find>(\w)\s([’”]+)</find>
            <change>$1$2</change>
        </regex>
        <regex>
            <find>(\w[”]+)(\w)</find>
            <change>$1 $2</change>
        </regex>
        <!-- No space before + space after any punctuation, e.g. ! ? ; : -->
        <regex>
            <find>\s([;\?!:])</find>
            <change>$1</change>
        </regex>
        <regex>
            <find>([;\?!:])(\w)</find>
            <change>$1 $2</change>
        </regex>
        
        <!--non breaking spaces after common abbreviations:

cf. and Cf.
e.g. and E.g.
p. (although there shouldn't be any of encoders follow the EG)
n. (although there shouldn't be any of encoders follow the EG) -->
        
        <regex>
            <find>([cC][f]\.)\s</find>
            <change>$1&#160;</change>
        </regex>
        <regex>
            <find>([eE]\.[g]\.)\s</find>
            <change>$1&#160;</change>
        </regex>
        <regex>
            <find>([pn]+\.)\s</find>
            <change>$1&#160;</change>
        </regex>
        
    </xsl:param>
    <xsl:param name="french-regexes" as="element(regex)*">
        <!-- Non breaking space = espace mot insécable -->
        <regex>
            <find>[\s]*([:»]+)</find>
            <change>&#160;$1</change>
        </regex>
        <regex>
            <find>([\w])([:]+)</find>
            <change>&#160;$1</change>
        </regex>
        <regex>
            <find>([«])[\s]</find>
            <change>$1&#160;</change>
        </regex>
        <regex>
            <find>([«])([\w])</find>
            <change>$1&#160;$2</change>
        </regex>
        <regex>
            <find>"([\w])</find>
            <change>«&#160;$1</change>
        </regex>
        <regex>
            <find>([\w\.])"</find>
            <change>$1&#160;»</change>
        </regex>
        
        <!-- espace fine insécable -->
        <regex>
            <find>[\s]([;\?!]+)</find>
            <change>&#8239;$1</change>
        </regex>
        <regex>
            <find>([\w])([;\?!»]+)</find>
            <change>$1&#8239;$2</change>
        </regex>
        
        <!-- Pas d'espaces -->
        <regex>
            <find>\s([\.,\]\)]+)</find>
            <change>$1</change>
        </regex>
        <regex>
            <find>([\[\(]+)\s</find>
            <change>$1</change>
        </regex>
        
    </xsl:param>
    
    <!-- regexes to apply transliteration rules -->
    <xsl:param name="javanese-regexes" as="element(regex)*">
        <!-- pas d'espace après : -->
        <regex>
            <find>([:])\s+</find>
            <change>$1</change>
        </regex>
    </xsl:param>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="t:div[@xml:lang='fra']/descendant::text()[string-length(normalize-space(.))>0]">
        <xsl:call-template name="applyRegexes">
            <xsl:with-param name="nodeText" select="."/>
            <xsl:with-param name="regex" select="$french-regexes"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="t:div[not(@xml:lang='fra')]/descendant::text()[string-length(normalize-space(.))>0]">
            <xsl:call-template name="applyRegexes">
            <xsl:with-param name="nodeText" select="."/>
            <xsl:with-param name="regex" select="$english-regexes"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="t:div[@xml:lang=('kaw-Latn', 'kaw-osn')]/descendant::text()[string-length(normalize-space(.))>0]">
        <xsl:call-template name="applyRegexes">
            <xsl:with-param name="nodeText" select="."/>
            <xsl:with-param name="regex" select="$javanese-regexes"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="applyRegexes">
        <xsl:param name="nodeText"/>
        <xsl:param name="regex"/>
        <xsl:choose>
            <xsl:when test="$regex">
                <xsl:variable name="temp">
                    <xsl:value-of
                        select="replace($nodeText,$regex[1]/find,$regex[1]/change)"/>
                </xsl:variable>
                <xsl:call-template name="applyRegexes">
                    <xsl:with-param name="nodeText" select="$temp"/>
                    <xsl:with-param name="regex"
                        select="$regex[position()>1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nodeText"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
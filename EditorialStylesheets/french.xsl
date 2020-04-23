<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="t" version="2.0">
   <xsl:output method="xml" encoding="UTF-8"/>

    <xsl:template match="t:*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="t:* | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*|processing-instruction()|comment()">
        <xsl:copy/>
    </xsl:template>

<xsl:template match="//t:div[@xml:lang='fra']">
  <!--Control on comma - official pattern: no blankspace , U+0020-->
  <xsl:analyze-string select="t:div[@xml:lang='fra']" regex="[\w\&gt;]\,[\s\&lt;]">
    <!-- prendre en compte les balises avant et après la virgule -->
    <xsl:non-matching-substring>
      <!-- check space before to delete it-->
    <xsl:if test="matches(., '\s\,')">
      <xsl:value-of select="replace(., '\s\,', ',')"></xsl:value-of>
    </xsl:if>
    <!-- check the lack of space after it-->
    <xsl:if test="matches(.,'\,\w')">
      <xsl:value-of select="replace(.,'\,(\w)',',&#32;$1')"></xsl:value-of>
    </xsl:if>
  </xsl:non-matching-substring>
  </xsl:analyze-string>

  <!-- Control on final dot - official pattern: no blankspace . U+0020-->
  <xsl:analyze-string select="t:div[@xml:lang='fra']" regex="[\w\&gt;]\.[\s\&lt;]">
    <xsl:non-matching-substring>
      <!-- check space before to delete it-->
    <xsl:if test="matches(., '\s\.')">
      <xsl:value-of select="replace(., '\s\.', '.')"></xsl:value-of>
    </xsl:if>
    <!-- check the lack of space after it-->
    <xsl:if test="matches(.,'\.\w')">
      <xsl:value-of select="replace(.,'\.(\w)','.&#32;$1')"></xsl:value-of>
    </xsl:if>
  </xsl:non-matching-substring>
  </xsl:analyze-string>

  <!-- Control for ; - official pattern U+202F ; U+0020-->
  <xsl:analyze-string select="t:div[@xml:lang='fra']" regex="[\s]\;[\s\&lt;]">
    <xsl:non-matching-substring>
      <!-- check space before -->
    <xsl:if test="matches(., '\s\;')">
      <xsl:value-of select="replace(., '\s\;', '&#8239;;')"></xsl:value-of>
    </xsl:if>
    <!-- case if no space at all-->
    <xsl:if test="matches(.,'[\w\&gt;]\;')">
      <xsl:value-of select="replace(., '([\w\&gt;])\;', '$1&#8239;;')"></xsl:value-of>
    </xsl:if>
    <!-- check the lack of space after it-->
    <xsl:if test="matches(.,'\;\w')">
      <xsl:value-of select="replace(.,'\;(\w)',';&#32;$1')"></xsl:value-of>
    </xsl:if>
  </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:template>
 </xsl:stylesheet>

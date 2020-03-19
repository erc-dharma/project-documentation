<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/terms/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:pi="http://papyri.info/ns"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs dc rdf pi tei t xd" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  version="2.0">

  <xsl:import href="global-varsandparams.xsl"/>

  <xsl:import href="txt-teiab.xsl"/>
  <xsl:import href="txt-teiapp.xsl"/>
  <xsl:import href="txt-teidiv.xsl"/>
  <xsl:import href="txt-teidivedition.xsl"/>
  <xsl:import href="txt-teigap.xsl"/>
  <xsl:import href="txt-teihead.xsl"/>
  <xsl:import href="txt-teilb.xsl"/>
  <xsl:import href="txt-teilgandl.xsl"/>
  <xsl:import href="txt-teilistanditem.xsl"/>
  <xsl:import href="txt-teilistbiblandbibl.xsl"/>
  <xsl:import href="txt-teimilestone.xsl"/>
  <xsl:import href="txt-teinote.xsl"/>
  <xsl:import href="txt-teip.xsl"/>
  <xsl:import href="txt-teispace.xsl"/>
  <xsl:import href="txt-teisupplied.xsl"/>
  <xsl:import href="txt-teiref.xsl"/>
  <xsl:import href="teiabbrandexpan.xsl"/>
  <xsl:import href="teiaddanddel.xsl"/>
  <xsl:import href="teichoice.xsl"/>
  <xsl:import href="teiheader.xsl"/>
  <xsl:import href="teihi.xsl"/>
  <xsl:import href="teimilestone.xsl"/>
  <xsl:import href="teinum.xsl"/>
  <xsl:import href="teiorig.xsl"/>
  <xsl:import href="teiorigandreg.xsl"/>
  <xsl:import href="teiq.xsl"/>
  <xsl:import href="teiseg.xsl"/>
  <xsl:import href="teisicandcorr.xsl"/>
  <xsl:import href="teispace.xsl"/>
  <xsl:import href="teisupplied.xsl"/>
  <xsl:import href="teisurplus.xsl"/>
  <xsl:import href="teiunclear.xsl"/>
  <xsl:import href="txt-tpl-apparatus.xsl"/>
  <xsl:import href="txt-tpl-linenumberingtab.xsl"/>
  <xsl:import href="tpl-reasonlost.xsl"/>
  <xsl:import href="tpl-certlow.xsl"/>
  <xsl:import href="tpl-text.xsl"/>
  <xsl:import href="teisurplus.xsl"/>
  <xsl:import href="cic-txt-teilb.xsl"/>

  <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

  <xsl:param name="collection"/>
  <xsl:param name="related"/>
  <xsl:variable name="relations" select="tokenize($related, ' ')"/>
  <xsl:variable name="path">/data/papyri.info/idp.data</xsl:variable>
  <xsl:variable name="outbase"/>
  <xsl:variable name="line-inc">5</xsl:variable>
  <xsl:variable name="resolve-uris" select="false()"/>

  <xsl:include href="cic-functions.xsl"/>

  <xsl:template match="/">
    <add>
      <doc>
        <field name="project">CIC</field>
        <field name="collection">CIC</field>
        <field name="series">campa</field>
        <xsl:variable name="id">
          <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@type='filename']"/>
        </xsl:variable>
        <field name="id">cic:<xsl:value-of select="$id"/></field>

        <xsl:variable name="text">
          <xsl:apply-templates select="//t:div[@type = 'edition']"/>
        </xsl:variable>
        <xsl:variable name="textnfc"
          select="normalize-space(replace(translate($text, '·[]{},.-()+^?̣&lt;&gt;*&#xD;\\/〚〛ʼ', ''),'&#xA0;', ''))"/>
        <xsl:variable name="textnfd" select="normalize-unicode($textnfc, 'NFD')"/>
        <field name="transcription">
          <xsl:value-of select="$textnfc"/>
        </field>
        <field name="transcription_id">
          <xsl:value-of select="replace($textnfd, '[\p{IsCombiningDiacriticalMarks}]', '')"/>
        </field>
        <field name="transcription_ngram">
          <xsl:value-of select="$textnfc"/>
        </field>

        <field name="transcription_ngram_id">
          <xsl:value-of select="replace($textnfd, '[\p{IsCombiningDiacriticalMarks}]', '')"/>
        </field>
        <xsl:if test="string-length($textnfd) > 0">
          <field name="has_transcription">true</field>
        </xsl:if>
        <xsl:variable name="languages"
          select="distinct-values(//t:div[@type='edition']/descendant-or-self::*/@xml:lang)"/>
        <xsl:for-each select="//t:langUsage/t:language">
          <xsl:if test="index-of($languages, string(@ident))">
            <field name="language">
              <xsl:value-of select="."/>
            </field>
            <field name="facet_language">
              <xsl:value-of select="string(@ident)"/>
            </field>
          </xsl:if>
        </xsl:for-each>
        <xsl:call-template name="images"/>
        <xsl:call-template name="metadata"/>
        <xsl:call-template name="translation"/>
      </doc>
    </add>
  </xsl:template>


  <xsl:template name="metadata">
    <xsl:call-template name="title"/>
    <field name="display_place">
      <xsl:value-of select="//t:origin/t:origPlace/t:placeName"/>
    </field>
    <xsl:variable name="relevant-date-nodeset"
      select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:origDate/(@when|@notBefore|@notAfter)"/>
    <field name="display_date">
      <xsl:choose>
        <xsl:when test="count(tokenize($relevant-date-nodeset, ' ')) gt 0">
          <xsl:value-of select="pi:get-date-range(tokenize($relevant-date-nodeset, ' '))"/>
        </xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </field>
    <xsl:choose>
      <xsl:when test="count(tokenize($relevant-date-nodeset, ' ')) gt 0">
        <field name="earliest_date">
          <xsl:value-of
            select="pi:get-min-date(remove(tokenize($relevant-date-nodeset, ' '), 1), pi:iso-date-to-num(tokenize($relevant-date-nodeset, ' ')[1]), false())"
          />
        </field>
        <field name="latest_date">
          <xsl:value-of
            select="pi:get-max-date(remove(tokenize($relevant-date-nodeset, ' '), 1), pi:iso-date-to-num(tokenize($relevant-date-nodeset, ' ')[1]), false())"
          />
        </field>
      </xsl:when>
      <!-- unknown date -->
      <xsl:otherwise>
        <field name="unknown_date_flag">true</field>
      </xsl:otherwise>
    </xsl:choose>
    <field name="metadata">
      <!-- Title -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Publications -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:text/t:body/t:div[@type = 'bibliography'], ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Inv. Id -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:idno, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Physical Desc. -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc//t:p, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Origin -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/(t:origPlace|t:p[t:placeName]), ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Provenance -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:provenance/t:ab, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Material -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:material, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Language -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/t:textLang, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Date -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:origDate, ' '))"/>
      <xsl:text> </xsl:text>
      <!-- Commentary -->
      <xsl:value-of
        select="normalize-space(string-join(/t:TEI/t:text/t:body/t:div[@type='commentary']/t:p, ' '))"/>
      <xsl:text> </xsl:text>
    </field>
    <field name="place">
      <xsl:value-of
        select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:origPlace)"
      />
    </field>

    <!-- InvNum -->
    <xsl:if test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:idno">
      <field name="invnum">
        <xsl:value-of
          select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:idno"/>
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="images">
    <!-- note difference here - 'images' are *online* images, 'illustrations' are print-publication images -->
    <xsl:if test="/t:TEI/t:facsimile">
      <field name="images">true</field>
      <xsl:for-each select="/t:TEI/t:facsimile/t:graphic">
        <field name="image_path">
          <xsl:value-of select="./@url"/>
        </field>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="translation">
    <xsl:for-each select="//t:div[@type='translation']">
      <field name="translation">
        <xsl:value-of select="."/>
      </field>
      <xsl:variable name="trans_lang">
        <!-- defaults to 'en' -->
        <xsl:choose>
          <xsl:when test="@xml:lang">
            <xsl:value-of select="@xml:lang"/>
          </xsl:when>
          <xsl:otherwise>en</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <field name="translation_language">
        <xsl:value-of select="$trans_lang"/>
      </field>
    </xsl:for-each>
    <xsl:if test="//t:div[@type='translation']">
      <field name="has_translation">true</field>
    </xsl:if>
  </xsl:template>

  <xsl:template
    match="text()[local-name(following-sibling::*[1]) = 'lb' and following-sibling::t:lb[1][@type='inWord']]">
    <xsl:value-of select="replace(., '\s+$', '')"/>
  </xsl:template>

  <xsl:template match="t:div[@type = 'textpart']" priority="1">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="t:lb[@break='no']"/>

  <xsl:template match="t:lb[not(@break='no')]">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="t:gap">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="t:g">
    <xsl:value-of select="@type"/>
  </xsl:template>

  <xsl:template name="tpl-apparatus">
    <!-- An apparatus is only created if one of the following is true -->
    <xsl:if
      test=".//t:choice[(child::t:sic and child::t:corr) or (child::t:orig and child::t:reg)] | .//t:subst | .//t:app |        
      .//t:hi[@rend = 'diaeresis' or @rend = 'varia' or @rend = 'oxia' or @rend = 'dasia' or @rend = 'psili' or @rend = 'perispomeni'] |
      .//t:del[@rend='slashes' or @rend='cross-strokes'] | .//t:milestone[@rend = 'box']">

      <!-- An entry is created for-each of the following instances -->
      <xsl:for-each
        select=".//t:choice[(child::t:sic and child::t:corr) or (child::t:orig and child::t:reg)] | .//t:subst | .//t:app |
        .//t:hi[@rend = 'diaeresis' or @rend = 'varia' or @rend = 'oxia' or @rend = 'dasia' or @rend = 'psili' or @rend = 'perispomeni'] |
        .//t:del[@rend='slashes' or @rend='cross-strokes'] | .//t:milestone[@rend = 'box']">

        <xsl:call-template name="app-link">
          <xsl:with-param name="location" select="'apparatus'"/>
        </xsl:call-template>

        <!-- Found in tpl-apparatus.xsl -->
        <xsl:call-template name="ddbdp-app"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="title">
    <field name="title">
      <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title"/>
    </field>
  </xsl:template>

  <xsl:template name="revision-history">
    <xsl:param name="docs"/>

    <xsl:variable name="all-edits" select="$docs/t:TEI/t:teiHeader/t:revisionDesc/t:change"/>
    <xsl:variable name="app-edits"
      select="$docs/t:TEI/t:teiHeader/t:revisionDesc/t:change[matches(text(), 'appchange', 'i')]"/>
    <xsl:variable name="date-edits"
      select="$docs/t:TEI/t:teiHeader/t:revisionDesc/t:change[matches(text(), 'datechange', 'i')]"/>
    <xsl:variable name="place-edits"
      select="$docs/t:TEI/t:teiHeader/t:revisionDesc/t:change[matches(text(), 'placechange', 'i')]"/>
    <xsl:if test="count($all-edits) &gt; 0">
      <xsl:variable name="first-revised">
        <xsl:value-of
          select="pi:regularise-datestring(pi:get-earliest-date-element(remove($all-edits, 1), $all-edits[1])/@when)"
        />
      </xsl:variable>
      <xsl:variable name="last-revised">
        <xsl:value-of
          select="pi:regularise-datestring(pi:get-latest-date-element(remove($all-edits, 1), $all-edits[1])/@when)"
        />
      </xsl:variable>
      <xsl:variable name="all-edit-author">
        <xsl:value-of select="pi:get-latest-date-element(remove($all-edits, 1), $all-edits[1])/@who"
        />
      </xsl:variable>
      <field name="published">
        <xsl:value-of select="$first-revised"/>
      </field>
      <field name="edit_date">
        <xsl:value-of select="$last-revised"/>
      </field>
      <field name="last_editor">
        <xsl:value-of select="$all-edit-author"/>
      </field>
    </xsl:if>
    <xsl:if test="count($app-edits) > 0">
      <xsl:variable name="latest-app-edit">
        <xsl:value-of
          select="pi:regularise-datestring(pi:get-latest-date-element(remove($app-edits, 1), $app-edits[1])/@when)"
        />
      </xsl:variable>
      <xsl:variable name="app-edit-author">
        <xsl:value-of select="pi:get-latest-date-element(remove($app-edits, 1), $app-edits[1])/@who"
        />
      </xsl:variable>
      <field name="app_edit_date">
        <xsl:value-of select="$latest-app-edit"/>
      </field>
      <field name="app_editor">
        <xsl:value-of select="$app-edit-author"/>
      </field>
    </xsl:if>
    <xsl:if test="count($date-edits) > 0">
      <xsl:variable name="latest-date-edit">
        <xsl:value-of
          select="pi:regularise-datestring(pi:get-latest-date-element(remove($date-edits, 1), $date-edits[1])/@when)"
        />
      </xsl:variable>
      <xsl:variable name="date-edit-author">
        <xsl:value-of
          select="pi:get-latest-date-element(remove($date-edits, 1), $date-edits[1])/@who"/>
      </xsl:variable>
      <field name="date_edit_date">
        <xsl:value-of select="$latest-date-edit"/>
      </field>
      <field name="date_editor">
        <xsl:value-of select="$date-edit-author"/>
      </field>
    </xsl:if>
    <xsl:if test="count($place-edits) > 0">
      <xsl:variable name="latest-place-edit">
        <xsl:value-of
          select="pi:regularise-datestring(pi:get-latest-date-element(remove($place-edits, 1), $place-edits[1])/@when)"
        />
      </xsl:variable>
      <xsl:variable name="place-edit-author">
        <xsl:value-of
          select="pi:get-latest-date-element(remove($place-edits, 1), $place-edits[1])/@who"/>
      </xsl:variable>
      <field name="place_edit_date">
        <xsl:value-of select="$latest-place-edit"/>
      </field>
      <field name="place_editor">
        <xsl:value-of select="$place-edit-author"/>
      </field>
    </xsl:if>

    <!--   <xsl:variable name="last-revised"><xsl:value-of select="pi:get-latest-date($docs/t:TEI/t:teiHeader/t:revisionDesc/t:change/@when, $docs/t:TEI/t:teiHeader/t:revisionDesc/t:change/@when)[1]"></xsl:value-of></xsl:variable>   
 <xsl:variable name="app-whens" select="$docs/t:TEI/t:teiHeader/t:revisionDesc/t:change[contains(text(), 'appchange')]/@when"></xsl:variable> -->



    <!--  <field name="edit_date"><xsl:value-of select="$last-revised"></xsl:value-of></field>
  <field name="last_editor"><xsl:value-of select="pi:get-latest-editor($docs/t:TEI/t:teiHeader/t:revisionDesc/t:change/@when, data($docs/t:TEI/t:teiHeader/t:revisionDesc/t:change/@when)[1])"></xsl:value-of></field>
  
  <xsl:if test="count($app-whens) > 0">
  <xsl:variable name="first-app-revised"><xsl:value-of select="concat(pi:get-latest-date($app-whens, $app-whens[1]), $date-suffix)"></xsl:value-of></xsl:variable>
  <xsl:if test="matches($first-app-revised, '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z')">
    <field name="app_edit_date"><xsl:value-of select="$first-app-revised"></xsl:value-of></field>
  </xsl:if>
  
  </xsl:if>-->
  </xsl:template>

  <xsl:template name="reg-text-processing">
    <xsl:param name="temp-node"/>
    <xsl:apply-templates select="$temp-node//t:div[@type='edition']"/>
  </xsl:template>

  <xsl:template name="orig-text-processing">
    <xsl:param name="temp-node"/>
    <xsl:apply-templates select="$temp-node//t:div[@type='edition']"/>
  </xsl:template>


  <xsl:template name="ddbdp-app">
    <xsl:choose>
      <!-- choice -->
      <xsl:when test="local-name() = 'choice' and child::t:sic and child::t:corr">
        <xsl:apply-templates select="t:sic/node()"/>
      </xsl:when>

      <xsl:when test="local-name() = 'choice' and child::t:reg and child::t:orig">
        <xsl:apply-templates select="t:reg/node()"/>
      </xsl:when>

      <!-- subst -->
      <xsl:when test="local-name() = 'subst'">
        <xsl:apply-templates select="t:del/node()"/>
      </xsl:when>

      <!-- app -->
      <xsl:when test="local-name() = 'app'">
        <xsl:apply-templates select="t:rdg/node()"/>
      </xsl:when>

    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

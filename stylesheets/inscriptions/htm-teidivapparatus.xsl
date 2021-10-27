<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all" version="2.0">


  <!-- only triggered if there is a <div type="apparatus"> (i.e. "external appartus") in the XML -->

  <!--<xsl:import href="teidivapparatus.xsl"/>-->

  <!-- Other div matches can be found in htm-teidiv.xsl -->
  <xsl:param name="parm-internal-app-style" />
  <xsl:param name="parm-external-app-style" />

  <xsl:variable name="default-language" select="'en'"/>

  <xsl:variable name="local-bibliography">
    <xsl:if test="$parm-external-app-style = 'iospe'">
      <xsl:for-each select="//t:div[@type='bibliography']//(t:bibl | t:biblStruct)">
        <xsl:choose>
          <xsl:when test="t:ptr/@target">
            <!-- I know there is only one, we use for-each only to change context -->
            <xsl:for-each select="t:ptr/@target">
              <xsl:call-template name="source">
                <xsl:with-param name="root" select="ancestor-or-self::t:TEI"/>
                <xsl:with-param name="parm-external-app-style" select="'iospe'" tunnel="yes"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <t:ref>
              <xsl:apply-templates select="." mode="parse-name-year"/>
            </t:ref>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:template name="source">
    <xsl:param name="root"/>
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>

    <xsl:variable name="source_location">
      <xsl:choose>
        <xsl:when
          test="$root//t:encodingDesc//t:prefixDef[@ident] and $root//t:encodingDesc//t:prefixDef/@ident = substring-before(., ':')">
          <xsl:value-of
            select="replace(substring-after(., ':'),
            $root//t:encodingDesc//t:prefixDef/@matchPattern,
            $root//t:encodingDesc//t:prefixDef/@replacementPattern)"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <t:ref>
      <xsl:choose>
        <xsl:when test="$parm-external-app-style = 'iospe'">
          <xsl:text>not collated</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($source_location, '#')">
          <xsl:apply-templates
            select="$root//t:div[@type='bibliography']//(t:bibl | t:biblStruct)[@xml:id=substring-after($source_location, '#')]"
            mode="parse-name-year"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="document($source_location, $root)" mode="parse-name-year"/>
        </xsl:otherwise>
      </xsl:choose>
    </t:ref>
  </xsl:template>

  <xsl:template name="sources">
    <xsl:param name="root"/>

    <!-- collect all sources -->
    <xsl:variable name="sources">
      <xsl:for-each select="tokenize(@source, ' ')">
        <xsl:call-template name="source">
          <xsl:with-param name="root" select="$root"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>

    <!-- preselect sources to be printed -->
    <xsl:variable name="final_printing_sources">
      <xsl:for-each select="$sources/t:ref">
        <xsl:variable name="n_authors_with_same_name_in_local_bib_and_current_sources"
          select="count($local-bibliography/t:ref[t:name/text() = $sources/t:ref[t:name/text() = current()/t:name/text()]/t:name/text()])"/>
        <xsl:variable name="n_authors_with_same_name_in_current_sources"
          select="count($sources/t:ref[t:name/text() = current()/t:name/text()])"/>
        <xsl:variable name="first_occurrence_of_this_author_in_sources"
          select="$sources/t:ref[t:name/text() = current()/t:name/text()][1] = current()"/>
        <xsl:variable name="n_authors_with_same_name_in_local_bib"
          select="count($local-bibliography/t:ref[t:name/text() = current()/t:name/text()])"/>

        <xsl:if
          test="not($n_authors_with_same_name_in_local_bib_and_current_sources = $n_authors_with_same_name_in_current_sources)
                  or $first_occurrence_of_this_author_in_sources">

          <t:ref>
            <xsl:sequence select="./t:name"/>
            <xsl:if
              test="$n_authors_with_same_name_in_local_bib != 1
                and not($n_authors_with_same_name_in_local_bib_and_current_sources = $n_authors_with_same_name_in_current_sources)">

              <xsl:sequence select="./t:date"/>
            </xsl:if>
          </t:ref>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- print references -->
    <xsl:text> </xsl:text>
    <xsl:for-each select="$final_printing_sources/t:ref">
      <xsl:value-of select="t:name"/>

      <xsl:if test="t:date">
        <xsl:text> </xsl:text>
        <xsl:value-of select="t:date"/>
      </xsl:if>
      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <xsl:template match="t:bibl | t:biblStruct" mode="parse-name-year">
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
    <t:name>
      <xsl:for-each select=".//t:author[1]">
        <xsl:choose>
          <xsl:when test=".//t:surname">
            <xsl:value-of select=".//t:surname[@xml:lang=$default-language or not(@xml:lang)]"/>
          </xsl:when>
          <xsl:when test=".//t:forename">
            <xsl:value-of select=".//t:forename[@xml:lang=$default-language or not(@xml:lang)]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </t:name>
    <t:date>
      <xsl:choose>
        <xsl:when test=".//t:imprint[1]">
          <xsl:value-of select=".//t:imprint[1]//t:date"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select=".//t:date[1]"/>
        </xsl:otherwise>
      </xsl:choose>

    </t:date>
  </xsl:template>

  <xsl:template match="t:div[@type='apparatus']" priority="1">
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
  <xsl:if test="descendant::*">
    <div id="apparatus">
      <h2>Apparatus</h2>
      <p>
        <xsl:apply-templates/>
      </p>
    </div>
  </xsl:if>
  </xsl:template>

  <xsl:template match="t:div[@type='apparatus']//t:app">
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
    <sup>
      <xsl:attribute name="class">
         <xsl:text>linenumberapp</xsl:text>
       </xsl:attribute>
    <!--  <xsl:text>(</xsl:text>-->
      <!--<xsl:attribute name="class">-->
        <xsl:value-of select="@loc"/>
      <!--</xsl:attribute>
      <xsl:if
        test="@loc and (not(preceding-sibling::t:app) or @loc != preceding-sibling::t:app[1]/@loc)">
        <xsl:value-of select="translate(@loc, ' ', '.')"/>
        <xsl:text>)</xsl:text>
      </xsl:if>-->
      <!-- Changing the numbering process since @n is deleted from the lemma fro declutering purposes. -->
       <xsl:if test="child::t:lem/t:lb and @loc != child::t:lem/t:lb/@n">
        <xsl:text>–</xsl:text>
        <xsl:value-of select="child::t:lem/t:lb/@n"/>
      </xsl:if>
      <!--<xsl:if test="child::t:lem/t:lb">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="number(sum(@loc+1))"/>
      </xsl:if>-->
      <!--<xsl:text>)</xsl:text>-->
    </sup>
      <xsl:apply-templates/>

<!-- changement du ; en — pour l'apparat d'Arlo -->
    <xsl:choose>
      <xsl:when test="@loc != following-sibling::t:app[1]/@loc">
        <br/>
      </xsl:when>
      <xsl:when test="following-sibling::t:app">
        <xsl:text>— </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:div[@type = 'apparatus']//t:rdg">
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
    <xsl:element name="span">
       <xsl:attribute name="class">reading</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
  <xsl:call-template name="sigla"/>
    <!--<xsl:call-template name="sources">
      <xsl:with-param name="root" select="ancestor-or-self::t:TEI"/>
    </xsl:call-template>-->

    <xsl:if test="following-sibling::t:rdg and not(following-sibling::*[1][self::t:note])">
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="t:div[@type = 'apparatus']//t:lem">
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <xsl:element name="span">
      <xsl:attribute name="class">lemma</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
  <xsl:if test="$parm-leiden-style='dharma'">
  <xsl:call-template name="sigla"/>
</xsl:if>
    <!--<xsl:call-template name="sources">
      <xsl:with-param name="root" select="ancestor-or-self::t:TEI"/>
    </xsl:call-template>-->

<!-- Ask Manu, if he wants to delete the : for ◇. Arlo susggested also just a blank space -->
    <xsl:if
      test="following-sibling::t:* and not(following-sibling::t:*[1][self::t:note]) and not(@source) and not($parm-leiden-style='dharma')">
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:if
      test="following-sibling::t:* and not(following-sibling::t:*[1][self::t:note]) and $parm-leiden-style='dharma'">
      <xsl:text> ◇ </xsl:text>
    </xsl:if>
  </xsl:template>

<!-- addition of a • before any note made in the apparatus.-->
  <xsl:template match="t:div[@type = 'apparatus']//t:note">
    <xsl:param name="parm-external-app-style" tunnel="yes" required="no"/>
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <span>
      <xsl:if test="ancestor::t:app">
        <xsl:if test="preceding-sibling::t:lem and $parm-leiden-style='dharma'">
        <xsl:text>• </xsl:text>
      </xsl:if>
      <xsl:if test="preceding-sibling::t:rdg and following-sibling::t:rdg">
                <xsl:text>• </xsl:text>
      </xsl:if>
    </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template name="sigla">
    <xsl:param name="parm-zoteroUorG" tunnel="yes" required="no"/>
    <xsl:param name="parm-zoteroKey" tunnel="yes" required="no"/>
      <!-- ajout d'un nouveau système pour les sigles bibliographiques-->
    <xsl:variable name="authors">
      <xsl:choose>
        <xsl:when test="./@source">
        <xsl:variable name="bibl-resp" select="tokenize(./@source,' ')"/>
          <xsl:for-each select="$bibl-resp">
          <xsl:variable name="indresp">
            <xsl:sequence select="replace(substring-after(., ':'), '\+', '%2B')"/>
          </xsl:variable>
            <xsl:variable name="zoteroapijsonresp">
              <xsl:value-of
                select="replace(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $indresp, '&amp;format=json'), 'amp;', '')"
              />
            </xsl:variable>
            <xsl:variable name="unparsedresp" select="unparsed-text($zoteroapijsonresp)"/>
            <xsl:choose>
              <xsl:when test="matches(., '\+[a][l]')">
                <xsl:analyze-string select="$unparsedresp"
                  regex="(^\s+&quot;lastName&quot;:\s&quot;)(.+)(&quot;)">
                  <xsl:matching-substring>
                    <xsl:value-of select="regex-group(2)"/>
                  </xsl:matching-substring>
                </xsl:analyze-string>
                <xsl:text> &amp; al </xsl:text>
              </xsl:when>
              <xsl:when test="matches(., '\+[A-Z]')">
                <xsl:analyze-string select="$unparsedresp"
                  regex="(^\s+&quot;lastName&quot;:\s&quot;)(.+)(&quot;)">
                  <xsl:matching-substring>
                    <xsl:value-of select="regex-group(2)"/>
                  </xsl:matching-substring>
                </xsl:analyze-string>
              </xsl:when>
              <xsl:otherwise>
                <xsl:analyze-string select="$unparsedresp"
                  regex="(\s+&quot;lastName&quot;:\s&quot;)(.+)(&quot;)">
                  <xsl:matching-substring>
                    <xsl:value-of select="regex-group(2)"/>
                  </xsl:matching-substring>
                </xsl:analyze-string>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:analyze-string select="$unparsedresp"
              regex="(\s+&quot;date&quot;:\s&quot;)(.+)(&quot;)">
              <xsl:matching-substring>
                <xsl:value-of select="regex-group(2)"/>
              </xsl:matching-substring>
            </xsl:analyze-string>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
  <xsl:element name="span">
    <xsl:variable name="vDoc" select="//t:listBibl"/>
    <xsl:variable name="biblID" select="tokenize(@source, ' ')"/>
    <xsl:attribute name="class">tooltipSiglum</xsl:attribute>
    <xsl:attribute name="trigger">hover</xsl:attribute>
    <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
    <xsl:attribute name="data-placement">top</xsl:attribute>
    <xsl:attribute name="title">
      <xsl:value-of select="$authors"/>
      <!--<xsl:choose>
      <xsl:when test="matches(@source, '\+[a][l]')">     
          <xsl:value-of select="replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '\+', ' &amp; '), '([a-z])([0-9])', '$1 $2'), ' bib:', ' ')"/>      
      </xsl:when>
      <xsl:when test="matches(@source, '\+[A-Z]')">      
          <xsl:value-of select="replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '\+', ' &amp; '), '([a-z])([0-9])', '$1 $2'), ' bib:', ' ')"/>    
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '([a-z])([A-Z])', '$1 $2'), '([a-z])([0-9])', '$1 $2'), ' bib:', ' ')"/>
      </xsl:otherwise>
    </xsl:choose>-->
    </xsl:attribute>
    <xsl:if test="count($biblID) &gt;= 1">
      <xsl:choose>
        <xsl:when test="$vDoc//t:ptr[@target=$biblID]">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$vDoc/t:bibl[t:ptr/@target=$biblID]/@n"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>No siglum for <xsl:value-of select="$biblID"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:element>
  <!-- Old system; to be deleted after validation -->
     <!--<span class="tooltip">
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="matches(@source, '\+[a][l]')">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(translate(@source,'abcdefghijklmnopqrstuvwxyz0123456789+-_:',''))"/>
            <xsl:text> &amp; al.</xsl:text>
            <span class="tooltiptext">
              <xsl:value-of select="replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '\+', ' &amp; '), '([a-z])([0-9])', '$1 $2'), ' bib:', ' ')"/>
            </span>
          </xsl:when>
          <xsl:when test="matches(@source, '\+[A-Z]')">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(translate(substring-before(@source, '+'),'abcdefghijklmnopqrstuvwxyz0123456789+-_:',''))"/>
            <xsl:text>&amp;</xsl:text>
            <xsl:value-of select="normalize-space(translate(substring-after(@source, '+'),'abcdefghijklmnopqrstuvwxyz0123456789+-_:',''))"/>
            <xsl:text> </xsl:text>
            <span class="tooltiptext">
              <xsl:value-of select="replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '\+', ' &amp; '), '([a-z])([0-9])', '$1 $2'), ' bib:', ' ')"/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
         <xsl:value-of select="normalize-space(translate(@source,'abcdefghijklmnopqrstuvwxyz0123456789-_:',''))"/>
         <span class="tooltiptext">
         <xsl:value-of select="replace(replace(replace(replace(substring-after(@source, ':'), '_[0-9][0-9]', ''), '([a-z])([A-Z])', '$1 $2'), '([a-z])([0-9])', '$1 $2'), ' bib:', ' ')"/>
       </span>
  </xsl:otherwise>
         </xsl:choose>
    </span>-->

  </xsl:template>
</xsl:stylesheet>
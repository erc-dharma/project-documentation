<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="text()[not(ancestor::t:note)]">
      <xsl:param name="parm-edition-type" tunnel="yes" required="no"></xsl:param>
      <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:choose>
        <!-- Strip a white space for dharma-->
        <!-- Ne marche pas-->
         <!--<xsl:when test="$parm-leiden-style='dharma' and ancestor::t:div[@type='apparatus']">
         <xsl:value-of select="replace(., '([\S+\)\]])/\s+([\S+\)\]])', '$1/$2')"/>
       </xsl:when>-->
       <!-- strip all spaces and punctuation in diplomatic edition -->

         <!-- Georgian Alphabet in diplomatic edition-->

         <xsl:when test="$parm-edition-type = 'diplomatic' and ancestor::t:div[@type='edition'] and not(ancestor::t:head)
            and ancestor-or-self::t:*[@xml:lang][1][@xml:lang='ka']">
            <xsl:value-of select="translate(.,'აბგდევზჱთიკლმნჲოპჟრსტჳუფქღყშჩცძწჭხჴჯჰჵ','ႠႡႢႣႤႥႦჁႧႨႩႪႫႬჂႭႮႯႰႱႲჃႳႴႵႶႷႸႹႺႻႼႽႾჄႿჀჅ')" />
         </xsl:when>

         <!-- Armenian Alphabet  -->

         <xsl:when test="$parm-edition-type = 'diplomatic' and ancestor::t:div[@type='edition'] and not(ancestor::t:head)
            and ancestor-or-self::t:*[@xml:lang][1][@xml:lang='hy']">
            <xsl:value-of select="translate(.,'աբգդեզէըթժիլխծկհձղճմյնշոչպջռսվտրցւփք','ԱԲԳԴԵԶԷԸԹԺԻԼԽԾԿՀՁՂՃՄՅՆՇՈՉՊՋՌՍՎՏՐՑՒՓՔ')" />
         </xsl:when>

          <xsl:when test="$parm-edition-type = 'diplomatic' and ancestor::t:div[@type='edition'] and not(ancestor::t:head)">
            <xsl:variable name="apos">
               <xsl:text><![CDATA[']]></xsl:text>
            </xsl:variable>
             <xsl:value-of select="upper-case(translate(normalize-unicode(translate(translate(translate(.,'&#x03f2;','&#x03f9;'),$apos,''), '··&#xA; ,.;‘’', ''),'NFD'),'&#x0300;&#x0301;&#x0308;&#x0313;&#x0314;&#x0342;&#x0345;',''))"/>
            <!--<xsl:value-of select="translate(translate(translate(.,$apos,''), '··&#xA; ,.;‘’', ''), $all-grc, $grc-upper-strip)"/>-->
             <!-- &#x02bc;&#x02bd;&#x0301;&#x0302;&#x0303;&#x0308;&#x0340;&#x0341;&#x0342;&#x0343;&#x0344;&#x0345; -->
         </xsl:when>
         <!-- omit space between abbreviation and (deleted) "f." or "l." from EDH names mode -->
          <xsl:when test="$parm-leiden-style='edh-names' and
            normalize-space(.) = '' and
            following-sibling::t:*[1][local-name()='w'][@lemma='filius' or @lemma='libertus' or @lemma='filia' or @lemma='liberta'] and
            preceding-sibling::t:*[1][descendant-or-self::t:expan]"/>
         <xsl:otherwise>
            <xsl:if test="matches(., '^\s') and not(matches(., '^\s+$')) and not(preceding-sibling::t:*[1][self::t:lb[@break='no']])">
               <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="$parm-leiden-style='edh-names'">
                  <xsl:value-of select="."/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="normalize-space(.)"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="matches(.,'\s$') and not(following-sibling::t:*[1][self::t:lb[@break='no']])">
               <xsl:text> </xsl:text>
            </xsl:if>
            <!--<xsl:if test="matches(.,'([a-z\)\]])/\s+([a-z\)\]])') and $parm-leiden-style='dharma'">
              <xsl:value-of select="replace(., '([a-z\)\]])/\s+([a-z\)\]])', '$1/$2')" />
            </xsl:if>-->

            <!-- not sure how to add it yet
            ([a-z\)\]])/\s+([a-z\)\]])  -->


         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teilgandl.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">
  <xsl:include href="teilgandl.xsl"/>

  <xsl:template match="t:lg">
      <xsl:choose>
          <xsl:when test="$leiden-style='campa'">
              <div class="verse-part">
                <span class="verse-number"><xsl:choose>
                    <xsl:when test="@n">
                        <xsl:text></xsl:text><xsl:value-of select="@n"/><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- this is a hack -->
                        <xsl:text>&#160;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose></span>
                  <span class="verse-meter">
                      <xsl:choose>
                          <xsl:when test="@met">
                              <xsl:text></xsl:text><xsl:value-of select="@met"/><xsl:text></xsl:text>
                          </xsl:when>
                          <xsl:otherwise>
                              <xsl:text></xsl:text><span class="xformerror">no @met found on this lg element</span><xsl:text></xsl:text>
                          </xsl:otherwise>
                      </xsl:choose>
                  </span>
                  <xsl:apply-templates/>
              </div>
          </xsl:when>
          <xsl:otherwise>
              <div class="textpart">
      <!-- Found in htm-tpl-lang.xsl -->
      <xsl:call-template name="attr-lang"/>
         <xsl:apply-templates/>
      </div></xsl:otherwise></xsl:choose>
  </xsl:template>


  <xsl:template match="t:l">
      <xsl:choose>
         <xsl:when test="$leiden-style = 'campa'">
            <xsl:variable name="elename">
             <xsl:choose>
                 <xsl:when test="ancestor-or-self::*[@rend='break-verse-lines']">div</xsl:when>
                 <xsl:otherwise>span</xsl:otherwise>
             </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="count(preceding-sibling::t:l) = 0">
                  <xsl:element name="{$elename}">
                      <xsl:attribute name="class">verse-line-initial</xsl:attribute>
                      <xsl:apply-templates/>
                  </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:element name="{$elename}">
                      <xsl:attribute name="class">verse-line</xsl:attribute>
                      <xsl:apply-templates/>
                  </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
         <xsl:when test="$verse-lines = 'on'">   
            <xsl:variable name="div-loc">
               <xsl:for-each select="ancestor::t:div[@type='textpart']">
                  <xsl:value-of select="@n"/>
                  <xsl:text>-</xsl:text>
               </xsl:for-each>
            </xsl:variable>
            <br id="a{$div-loc}l{@n}"/>
            <xsl:if test="number(@n) and @n mod $line-inc = 0 and not(@n = 0)">
               <span class="linenumber">
                  <xsl:value-of select="@n"/>
               </span>
            </xsl:if>
            <!-- found in teilgandl.xsl -->
        <xsl:call-template name="line-context"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
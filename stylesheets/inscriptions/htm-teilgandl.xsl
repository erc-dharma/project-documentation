<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <xsl:include href="teilgandl.xsl"/>

  <xsl:template match="t:lg">
      <xsl:choose>
          <xsl:when test="$leiden-style='dharma'">
              <div class="verse-part">
                <span class="stanzanumber"><xsl:choose>
                    <xsl:when test="@n">
                        <xsl:number value="@n" format="I"/><xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- this is a hack -->
                        <xsl:text>no n@ found on this lg element </xsl:text>
                    </xsl:otherwise>
                </xsl:choose></span>
                  <span class="verse-meter">
                      <xsl:choose>
                          <xsl:when test="@met">
                              <xsl:text></xsl:text><xsl:value-of select="concat(upper-case(substring(@met,1,1)), substring(@met, 2),' '[not(last())] )"/><xsl:text></xsl:text>
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
      <xsl:param name="parm-line-inc" tunnel="yes" required="no"></xsl:param>
      <xsl:param name="parm-verse-lines" tunnel="yes" required="no"></xsl:param>
      <!-- <xsl:choose>
           <xsl:when test="$parm-verse-lines = 'on'">
             <xsl:element name="div">
                 <xsl:attribute name="class">verse-line</xsl:attribute>
                 <xsl:apply-templates/>
             </xsl:element>
             </xsl:when>
           <xsl:otherwise>
             <xsl:element name="span">
                 <xsl:attribute name="class">verse-line-error</xsl:attribute>
                 <xsl:apply-templates/>
             </xsl:element>
           </xsl:otherwise>
       </xsl:choose>-->
      <xsl:choose>
          <xsl:when test="$parm-verse-lines = 'on'">
            <xsl:variable name="div-loc">
               <xsl:for-each select="ancestor::t:div[@type='textpart']">
                  <xsl:value-of select="@n"/>
                  <xsl:text>-</xsl:text>
               </xsl:for-each>
            </xsl:variable>
            <br id="a{$div-loc}l{@n}"/>
              <xsl:if test="number(@n) and @n mod number($parm-line-inc) = 0 and not(@n = 0)">
               <sup class="versenumber">
                 <xsl:text>(</xsl:text>
                  <xsl:value-of select="@n"/>
                  <xsl:text>) </xsl:text>
               </sup>
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

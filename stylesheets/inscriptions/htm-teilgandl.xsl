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
                                            <!-- Deleting the language constraint TO BE DONE -->
                                           <!-- TO BE DONE : Adding the @n if more than one <lg> = adding a variable -->
                                             <xsl:if test="not(ancestor::t:div[@xml:lang='tam-Latn']) and not(ancestor::t:div[@xml:lang='tam'])">
                                            <span class="stanzanumber"><xsl:choose>
                                                <xsl:when test="@n">
                                                    <xsl:number value="@n" format="I"/><xsl:text> </xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>no n@ found on this lg element </xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose></span>
                                          </xsl:if>
                                              <span class="verse-meter">
                                                  <xsl:choose>
                                                    <xsl:when test="matches(@met,'[\+\-]+')">
                                                      <xsl:call-template name="prosodic"/>
                                                    </xsl:when>
                                                      <xsl:otherwise>
                                                        <xsl:text></xsl:text><xsl:value-of select="concat(upper-case(substring(@met,1,1)), substring(@met, 2),' '[not(last())] )"/><xsl:text></xsl:text>
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
                 <xsl:text>(</xsl:text>
                  <xsl:value-of select="@n"/>
                  <xsl:text>) </xsl:text>
            </xsl:if>
            <!-- div for each l and addition of a class depending the metric pattern -->
            <xsl:element name="div">
              <xsl:if test="@n=('ab', 'cd', 'ef', 'gh')">
                <xsl:attribute name="class">matravitta</xsl:attribute>
              </xsl:if>
              <xsl:if test="@n=('a', 'c', 'e', 'g')">
                <xsl:attribute name="class">varnavritta-odd</xsl:attribute>
              </xsl:if>
              <xsl:if test="@n=('b', 'd', 'f', 'h')">
                <xsl:attribute name="class">varnavritta-even</xsl:attribute>
              </xsl:if>
              <!-- metric to be discussed with Manu -->
              <xsl:if test="matches(@n, '[0-9]+')">
                <xsl:attribute name="class">tamil-verse</xsl:attribute>
              </xsl:if>
              <!-- found in teilgandl.xsl -->
        <xsl:call-template name="line-context"/>
      </xsl:element>
         </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<xsl:template name="prosodic">
      <xsl:if test="matches(@met,'[\+\-]+')">
        <xsl:value-of select="replace(replace(replace(@met,'-','⏑'),'=','⏓'),'\+','-')"/>
      </xsl:if>
  </xsl:template>

</xsl:stylesheet>

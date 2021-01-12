<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                version="2.0">

  <xsl:include href="teilgandl.xsl"/>

                             <xsl:template match="t:lg">
                                 <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
                                  <xsl:choose>
                                      <xsl:when test="$leiden-style='dharma'">
                                        <xsl:choose>
                                            <xsl:when test="child::t:l/descendant::t:milestone[following-sibling::t:lb] or child::t:l/descendant::t:milestone[following-sibling::t:label and following-sibling::t:lb]">
                                            <xsl:element name="h3">
                                              <xsl:text>&#8225; </xsl:text>
                                              <xsl:value-of select="descendant::t:label"/>
                                            <hr/>
                                          </xsl:element>
                                        </xsl:when>
                                      </xsl:choose>
                                            <!-- Deleting the language constraint TO BE DONE -->
                                           <!-- TO BE DONE : Adding the @n if more than one <lg> = adding a variable -->
                                           <div class="verse-part">
                                            <xsl:if test="(count(//t:lg[ancestor::t:div[@type='edition']]) &gt; 1)">
                                            <span class="stanzanumber">
                                              <xsl:choose>
                                                <!--<
                                                    <xsl:when test="contains(@n, 'seal')">
                                                      <xsl:value-of select="@n"/>
                                                      <xsl:text>. </xsl:text>
                                                    </xsl:when>
                                                  -->
                                                <xsl:when test="@n">
                                               
                                                      <xsl:number value="@n" format="I"/>
                                                      <xsl:text>. </xsl:text>
                                                </xsl:when>
                                                
                                              <xsl:when test="not(t:lg/@n)">
                                                    <xsl:message>the @n is missing on the stanza</xsl:message>
                                                </xsl:when>
                                            </xsl:choose>
                                          </span>
                                        </xsl:if>
                                          <span class="verse-meter">
                                                  <xsl:choose>
                                                    <xsl:when test="matches(@met,'[\+\-]+')">
                                                      <xsl:call-template name="prosodic"/>
                                                    </xsl:when>
                                                      <xsl:otherwise>
                                                        <xsl:text></xsl:text>
                                                        <xsl:value-of select="concat(upper-case(substring(@met,1,1)), substring(@met, 2),' '[not(last())] )"/>
                                                        <xsl:text></xsl:text>
                                                      </xsl:otherwise>
                                                  </xsl:choose>

                                          </span>
                                          <xsl:apply-templates/>
                                        </div>
                                          <xsl:if test="following::t:lg">
                                            <br/>
                                          </xsl:if>
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
        <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
        <xsl:choose>
               <xsl:when test="$parm-verse-lines = 'on' and ancestor::t:div[@type='edition']">
                 <xsl:element name="div">
                   <xsl:if test="count(preceding-sibling::t:l) = 0">
                     <xsl:attribute name="class">first-line</xsl:attribute>
                   </xsl:if>
                   <xsl:if test="count(preceding-sibling::t:l) &gt;= 1">
                     <xsl:attribute name="class">verse-line</xsl:attribute>
                   </xsl:if>
                     <xsl:apply-templates/>
                     <!-- Pb de trailing space related to the addition of the div -->
                     <!--  and not(child::t:unclear[position()=last()])-->
                    <xsl:if test="@enjamb='yes'">
                          <xsl:text>-</xsl:text>
                   </xsl:if>
                 </xsl:element>
                 </xsl:when>
               <xsl:otherwise>
                 <xsl:element name="div">
                     <xsl:attribute name="class">translated-verse</xsl:attribute>
                     <xsl:apply-templates/>
                 </xsl:element>
               </xsl:otherwise>
           </xsl:choose>
      <xsl:choose>
          <xsl:when test="$parm-verse-lines = 'on'  and not($leiden-style='dharma')">
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
                  <xsl:text>)</xsl:text>
            </xsl:if>
            <!-- div for each l and addition of a class depending the metric pattern -->
         </xsl:when>
         <!-- Create an unecessary tag apply-template in the html-->
      <xsl:otherwise>
        <xsl:if test="not($leiden-style='dharma')">
            <apply-template/>
          </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<xsl:template name="prosodic">
      <xsl:if test="matches(@met,'[\+\-]+')">
        <xsl:value-of select="replace(replace(replace(@met,'-','⏑'),'=','⏓'),'\+','–')"/>
      </xsl:if>
  </xsl:template>

</xsl:stylesheet>

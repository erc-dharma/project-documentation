<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="t" version="2.0">
   <!-- Contains templates for choice/orig and choice/reg and surplus -->

    <!--  <xsl:template match="t:choice/t:orig">
          <xsl:param name="parm-edition-type" tunnel="yes" required="no"></xsl:param>
          <xsl:param name="parm-edn-structure" tunnel="yes" required="no"></xsl:param>
          <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
          <xsl:choose>
              <xsl:when test="$parm-edn-structure = 'rib'">

              </xsl:when>
              <xsl:otherwise>
                  <xsl:apply-templates/>
                  <xsl:if test="$parm-leiden-style = 'ddbdp'">

                      <xsl:call-template name="cert-low"/>

                      <xsl:if test="ancestor::t:*[local-name()=('reg','corr','rdg')
                          or self::t:del[@rend='corrected']]">

                          <xsl:text> (</xsl:text><xsl:for-each select="../t:reg">
                              <xsl:sort select="position()" order="descending"/>
                              <xsl:call-template name="multreg"/>
                          </xsl:for-each><xsl:text>)</xsl:text>
                      </xsl:if>
                  </xsl:if>
                  <xsl:if test="$parm-leiden-style='iospe' and ../t:reg and $parm-edition-type='interpretive'">

                      <xsl:text> (pro </xsl:text>
                      <xsl:apply-templates select="../t:reg/node()"/>
                      <xsl:text>)</xsl:text>
                  </xsl:if>
              </xsl:otherwise>
          </xsl:choose>
      </xsl:template>-->

      <xsl:template match="t:choice/t:orig">
        <xsl:text>¡</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>!</xsl:text>
      </xsl:template>

   <xsl:template match="t:choice/t:reg">
     <xsl:text>&lt;</xsl:text>
     <xsl:apply-templates/>
     <xsl:text>&gt;</xsl:text>
   </xsl:template>

</xsl:stylesheet>

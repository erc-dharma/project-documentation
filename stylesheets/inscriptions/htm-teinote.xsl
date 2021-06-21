<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Template in teinote.xsl -->
  <xsl:import href="teinote.xsl"/>
<!-- Mode necessary to apply the italic if a bibl is descend of t:list/t:item/t:note -->
   <xsl:template match="t:note" mode="#all">
      <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
     <xsl:choose>
        <xsl:when test="$parm-leiden-style='iospe' and (ancestor::t:p or ancestor::t:l or ancestor::t:ab)">
           <xsl:apply-imports/>
        </xsl:when>
        <xsl:when test="$parm-leiden-style='dharma' and ((ancestor::t:item) or ancestor::t:p or ancestor::t:l or ancestor::t:ab)">
          <xsl:choose>
            <xsl:when test="ancestor::t:item[ancestor::t:div[@type='translation']] or ancestor::t:p[ancestor::t:div[@type='translation']]">
              <span class="note">
              <xsl:apply-imports/>
            </span>
            </xsl:when>
            <xsl:otherwise>
            <i class="note">
              <xsl:apply-imports/>
            </i>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="ancestor::t:p or ancestor::t:l or ancestor::t:ab">
           <i><xsl:apply-imports/></i>
        </xsl:when>
         <xsl:otherwise>
            <p class="note">
               <xsl:apply-imports/>
            </p>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

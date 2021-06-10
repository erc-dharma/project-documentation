<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:list" mode="#all">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"/>
      <xsl:choose>
         <xsl:when test="@type = 'ordered'">
            <ol>
               <xsl:apply-templates/>
            </ol>
         </xsl:when>
         <xsl:when test="@rend='bulleted' and $parm-leiden-style = 'dharma'">
           <ul>
                 <xsl:apply-templates mode="dharma"/>
           </ul>
         </xsl:when>
         <xsl:when test="@rend='numbered' and $parm-leiden-style = 'dharma'">
           <ol>
             <xsl:apply-templates mode="dharma"/>
           </ol>
         </xsl:when>
         <xsl:when test="$parm-leiden-style = 'dharma' and child::t:label">
           <dl>
             <xsl:apply-templates mode="dharma"/>
           </dl>
         </xsl:when>
         <xsl:otherwise>
           <xsl:if test="$parm-leiden-style = 'dharma'">
            <xsl:element name="ul">
              <xsl:attribute name="class">notBulleted</xsl:attribute>
                  <xsl:apply-templates mode="dharma"/>
            </xsl:element>
          </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!--Adding a mode on item requires adding modes on all the list container application-->
  <xsl:template match="t:item" mode="dharma">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"/>
    <!-- <li> -->
        <xsl:choose>
          <xsl:when test="ancestor::t:div[@type='translation'] and $parm-leiden-style = 'dharma' and preceding-sibling::t:label">
          <dd>
            <xsl:apply-templates mode="dharma"/>
          </dd>
        </xsl:when>
          <xsl:when test="ancestor::t:div[@type='translation'] and @n and $parm-leiden-style = 'dharma'">
            <li>
            <sup class="linenumber">
             <xsl:value-of select="@n"/>
           </sup>
           <xsl:apply-templates mode="dharma"/>
         </li>
       </xsl:when>    
          <xsl:otherwise>
                <li>
              <xsl:apply-templates mode="dharma"/>
            </li>
            </xsl:otherwise>
            </xsl:choose>
    <!-- </li> -->
  </xsl:template>

  <xsl:template match="t:label[ancestor-or-self::t:list]" mode="dharma">
    <xsl:element name="dt">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>

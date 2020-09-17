<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

  <xsl:template match="t:list">
      <xsl:choose>
         <xsl:when test="@type = 'ordered'">
            <ol>
               <xsl:apply-templates mode="dharma"/>
            </ol>
         </xsl:when>
         <xsl:otherwise>
            <ul>
              <xsl:choose>
                <xsl:when test="descendant::t:bibl">
                  <xsl:apply-templates mode="dharma"/>
                </xsl:when>
                    <xsl:otherwise>
                    <xsl:apply-templates mode="dharma"/>
                  </xsl:otherwise>
                  </xsl:choose>
            </ul>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!--Adding a mode on item requires adding modes on all the list container application-->
  <xsl:template match="t:item" mode="dharma">
      <li>
        <xsl:choose>
          <xsl:when test="descendant::t:bibl">
            <xsl:apply-templates mode="dharma"/>
          </xsl:when>
              <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
            </xsl:choose>
      </li>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  
  <xsl:template match="t:persName[ancestor::t:teiHeader]">
    <xsl:choose>
      <xsl:when test="t:forename and t:surname">
      <xsl:value-of select="t:forename"/>
    <xsl:text> </xsl:text>
    <xsl:element name="span">
      <xsl:attribute name="class">resp</xsl:attribute>
    <xsl:value-of select="t:surname"/>
    </xsl:element>
      </xsl:when>
      <xsl:when test="t:name">
          <xsl:value-of select="normalize-space(.)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
<xsl:template match="t:persName[ancestor::t:body]">
  <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:div[@type='edition']">
          <xsl:choose>
            <xsl:when test="child::t:*[local-name()=('persName')]">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <!-- <button type="button" class="btn btn-lg btn-danger" data-toggle="popover" title="Popover title" data-content="And here's some amazing content. It's very engaging. Right?">Click to toggle popover</button>-->
              <xsl:element name="span">
                <xsl:attribute name="data-toggle">popover</xsl:attribute>
                <xsl:attribute name="data-placement">bottom</xsl:attribute>
                <xsl:attribute name="title">       
                    <xsl:apply-templates/>                    
                </xsl:attribute>
                <xsl:attribute name="data-target">
                  <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:apply-templates/>
              <xsl:element name="sup">
                <xsl:text>👤</xsl:text>
              </xsl:element>
              </xsl:element>            
            </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
</xsl:template>

  <xsl:template match="t:persName[ancestor::t:body]" mode="modals">
    <xsl:variable name="persons">
                      <xsl:choose>
            <xsl:when test="@ref">
              <xsl:variable name="person-file" select="document('https://raw.githubusercontent.com/erc-dharma/mdt-authorities/main/temporary/DHARMA_persons.xml')//File"/>
              <xsl:variable name="person-id" select="@ref"/>
              <xsl:element name="span">
                <xsl:attribute name="class">entry-line</xsl:attribute>
              <xsl:text>Identifier: </xsl:text><xsl:apply-templates select="$person-id"/>
              <br/>
              </xsl:element>
              <xsl:choose>
                <xsl:when test="$person-file/listPerson[person[@xml:id = $person-id]]">
                  <xsl:element name="span">
                    <xsl:attribute name="class">entry-line</xsl:attribute>
                    <xsl:text>Name: </xsl:text><xsl:apply-templates select="$person-file/listPerson[person[@xml:id = $person-id]]/descendant::persName[1]"/><br/></xsl:element>
                  <xsl:element name="span">
                    <xsl:attribute name="class">entry-line</xsl:attribute>
                    <xsl:text>Sex: </xsl:text><xsl:apply-templates select="$person-file/listPerson[person[@xml:id = $person-id]]/child::person/@sex"/><br/></xsl:element>
                  <xsl:element name="span">
                    <xsl:attribute name="class">entry-line</xsl:attribute>
                    <xsl:text>Role: </xsl:text><xsl:apply-templates select="$person-file/listPerson[person[@xml:id = $person-id]]/child::person/@role"/></xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>no data available for this id.</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="span">
                <xsl:attribute name="class">entry-line</xsl:attribute>
                <xsl:text>No identifier given for </xsl:text>
              <xsl:apply-templates/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:variable>
    
    <span class="popover-content d-none" id="{generate-id()}">
      <xsl:copy-of select="$persons"/>
    </span>
</xsl:template>

  <xsl:template match="t:placeName[ancestor::t:body]">
  <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
      <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:div[@type='edition']">
        <xsl:choose>
          <xsl:when test="child::t:*[local-name()=('placeName')]">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="span">
              <xsl:attribute name="data-toggle">popover</xsl:attribute>
              <xsl:attribute name="data-placement">bottom</xsl:attribute>
              <xsl:attribute name="title">       
                <xsl:apply-templates/>                    
              </xsl:attribute>
              <xsl:attribute name="data-target">
                <xsl:value-of select="generate-id()"/>
              </xsl:attribute>
              <xsl:apply-templates/>
              <xsl:element name="sup">
                <xsl:text>🧭</xsl:text>
              </xsl:element>
            </xsl:element>
            </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
</xsl:template>
  
  <xsl:template match="t:date">
    <xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
    <xsl:if test="$parm-leiden-style='dharma' and ancestor::t:div[@type='edition']">
      <xsl:choose>
        <xsl:when test="child::t:*[local-name()=('date')]">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
          <xsl:element name="sup">
            <xsl:text>📅</xsl:text>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="t:placeName[ancestor::t:body]" mode="modals">
    <xsl:variable name="persons">
      <xsl:choose>
        <xsl:when test="@ref">
          <xsl:variable name="place-file" select="document('https://raw.githubusercontent.com/erc-dharma/mdt-authorities/main/temporary/DHARMA_places.xml')//File/listPlace"/>
          <xsl:variable name="place-id" select="@ref"/>
          <xsl:element name="span">
            <xsl:attribute name="class">entry-line</xsl:attribute>
            <xsl:text>Identifier: </xsl:text><xsl:apply-templates select="$place-id"/>
            <br/>
          </xsl:element>
          <xsl:choose>
            <xsl:when test="$place-file/place[@xml:id = $place-id]">
              <xsl:element name="span">
                <xsl:attribute name="class">entry-line</xsl:attribute>
                <xsl:text>Name: </xsl:text><xsl:apply-templates select="$place-file/place[@xml:id = $place-id]/persName[1]"/><br/></xsl:element>
              <xsl:element name="span">
                <xsl:attribute name="class">entry-line</xsl:attribute>
                <xsl:text>Type: </xsl:text><xsl:apply-templates select="$place-file/place[@xml:id = $place-id]/@type"/><br/></xsl:element>
              <xsl:element name="span">
                <xsl:attribute name="class">entry-line</xsl:attribute>
                <xsl:text>Country: </xsl:text><xsl:apply-templates select="$place-file/place[@xml:id = $place-id]/country"/></xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>no data available for this id.</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="span">
            <xsl:attribute name="class">entry-line</xsl:attribute>
            <xsl:text>No identifier given for </xsl:text>
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <span class="popover-content d-none" id="{generate-id()}">
      <xsl:copy-of select="$persons"/>
    </span>
  </xsl:template>

</xsl:stylesheet>

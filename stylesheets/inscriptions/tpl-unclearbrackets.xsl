<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">

<!-- Inspired bu the deprecated way to deal with the square brackets. Adapting the new code for () is not possible. -->

  <xsl:template name="brackets-opener">
    <!-- Relationship: start at x going to y -->
    <xsl:choose>
      <!--1.1
        ````````__|__
        ```````|`````|
        ```````y`````x
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
      <xsl:when test="preceding-sibling::t:unclear[1]">
            <xsl:if test="preceding-sibling::node()[1][self::text()][not(translate(normalize-space(.), ' ', '') = '')] or preceding-sibling::t:*[1][local-name() = ('lb', 'supplied', 'gap', 'pb', 'space', 'milestone', 'hi', 'choice', 'g', 'orig', 'num', 'surplus', 'seg', 'abbr')]">
               <xsl:element name="span">
                  <xsl:attribute name="class">notBold cas1.1</xsl:attribute>
                  <xsl:text>(</xsl:text>
               </xsl:element>
            </xsl:if>
         </xsl:when>


         <!--1.2
        ````````__|__
        ```````|`````|
        ```````y```__z__
        ``````````|`````|
        ``````````x
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
      <xsl:when test="current()[not(preceding-sibling::t:*)][not(preceding-sibling::text())]
                                   /parent::t:*[preceding-sibling::t:unclear[1]]">
         <xsl:if test="parent::t:*[preceding-sibling::t:*[1][local-name() = ('lb','seg', 'supplied', 'gap', 'pb', 'space', 'milestone', 'choice', 'g', 'orig', 'num', 'surplus', 'abbr')] or preceding-sibling::node()[1][self::text()][not(translate(normalize-space(.), ' ', '') = '')]]">
                     <xsl:element name="span">
                        <xsl:attribute name="class">notBold cas1.2</xsl:attribute>
                        <xsl:text>(</xsl:text>
                     </xsl:element>
            </xsl:if>
         </xsl:when>


         <!--1.3
        ````````______|______
        ```````|`````````````|
        ```````y```````````__z__
        ``````````````````|`````|
        ````````````````__z__
        ```````````````|`````|
        ```````````````x
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->

    <!--  <xsl:when test="current()[not(preceding-sibling::t:*)]
                                             [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                             [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                             /parent::t:*[not(preceding-sibling::t:*)]
                                             [not(preceding-sibling::node()[1][self::text()]) or
                                             preceding-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]
                                             /parent::t:*[preceding-sibling::t:unclear[1]]">
            <xsl:if test="parent::t:*/parent::t:*[preceding-sibling::node()[1][self::text()][not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>(</xsl:text>
            </xsl:if>
         </xsl:when>-->


         <!--2.1
        ````````__|__
        ```````|`````|
        `````__z__```x
        ````|`````|
        ``````````y
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
    <xsl:when test="current()[not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                       [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                       /preceding-sibling::t:*[1]/t:unclear[not(following-sibling::t:*)]">
            <xsl:if test="preceding-sibling::t:*[1]/t:unclear[not(following-sibling::t:*)]
                                       [following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
                     <xsl:element name="span">
                        <xsl:attribute name="class">notBold cas2.1</xsl:attribute>
                        <xsl:text>(</xsl:text>
                     </xsl:element>
            </xsl:if>
            <xsl:if test="preceding-sibling::t:choice">
              <xsl:element name="span">
                 <xsl:attribute name="class">notBold cas2.1</xsl:attribute>
                 <xsl:text>(</xsl:text>
              </xsl:element>
            </xsl:if>
         </xsl:when>

         <!--2.2
        ````````____|____
        ```````|`````````|
        `````__z__`````__z__
        ````|`````|```|`````|
        ``````````y```x
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
 <!--  <xsl:when test="current()[not(preceding-sibling::t:*)]
                                       [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                       [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                       /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][preceding-sibling::t:*[1]]
                                       [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                       [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                       /preceding-sibling::t:*[1]/t:unclear[not(following-sibling::t:*)]">
            <xsl:if test="parent::t:*/preceding-sibling::t:*[1]
                                       /t:unclear[not(following-sibling::t:*)]
                                       [following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
                    <xsl:element name="span">
                        <xsl:attribute name="class">notBold cas2.2</xsl:attribute>
                        <xsl:text>(</xsl:text>
                    </xsl:element>
            </xsl:if>
         </xsl:when>-->


         <!--2.3
        ````````______|______
        ```````|`````````````|
        `````__z__`````````__z__
        ````|`````|```````|`````|
        ``````````y`````__z__
        ```````````````|`````|
        ```````````````x
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
    <!--  <xsl:when test="current()[not(preceding-sibling::t:*)]
                                            [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                            [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                            /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][not(preceding-sibling::t:*)]
                                            [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                            [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                            /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][preceding-sibling::t:*[1]]
                                            [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                            [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                            /preceding-sibling::t:*[1]
                                            /t:unclear[not(following-sibling::t:*)]">
            <xsl:if test="parent::t:*/parent::t:*/preceding-sibling::t:*[1]
                                 /t:unclear[not(following-sibling::t:*)][following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>(</xsl:text>
            </xsl:if>
         </xsl:when>-->


         <!--3.1
        ````````____|____
        ```````|`````````|
        `````__z__```````x
        ````|`````|
        ````````__z__
        ```````|`````|
        `````````````y
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
    <!--  <xsl:when test="current()[not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]         /preceding-sibling::t:*[1]         /t:*[not(following-sibling::t:*)]         [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]         /t:unclear[not(following-sibling::t:*)]">
            <xsl:if test="preceding-sibling::t:*[1]/t:*           /t:unclear[not(following-sibling::t:*)][following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>(</xsl:text>
            </xsl:if>
         </xsl:when>-->


         <!--3.2
        ````````_______|_______
        ```````|```````````````|
        `````__z__```````````__z__
        ````|`````|`````````|`````|
        ````````__z__```````x
        ```````|`````|
        `````````````y
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
    <!--  <xsl:when test="current()[not(preceding-sibling::t:*)]
                                            [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                            [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                            /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][preceding-sibling::t:*[1]]
                                            [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                            [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                            /preceding-sibling::t:*[1]
                                            /t:*[not(following-sibling::t:*)]
                                            [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                            [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                            /t:unclear[not(following-sibling::t:*)]">
            <xsl:if test="parent::t:*/preceding-sibling::t:*[1]/t:*           /t:unclear[not(following-sibling::t:*)][following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>(</xsl:text>
            </xsl:if>
         </xsl:when>-->


         <!--3.3
        ````````______|______
        ```````|`````````````|
        `````__z__`````````__z__
        ````|`````|```````|`````|
        ````````__z__```__z__
        ```````|`````|`|`````|
        `````````````y`x
        If y is a text() then output '['
        If y is 'lost' then nothing
      -->
    <!--  <xsl:when test="current()[not(preceding-sibling::t:*)]
                                         [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                         [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                         /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][not(preceding-sibling::t:*)]
                                         [not(preceding-sibling::node()[1][self::text()]) or
                                         preceding-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]
                                         /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][preceding-sibling::t:*[1]]
                                         [not(preceding-sibling::node()[1][self::text()]) or preceding-sibling::node()[1]
                                         [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                         /preceding-sibling::t:*[1]
                                         /t:*[not(following-sibling::t:*)]
                                         [not(preceding-sibling::node()[1][self::text()]) or
                                         preceding-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]
                                         /t:unclear[not(following-sibling::t:*)]">
            <xsl:if test="parent::t:*/parent::t:*/preceding-sibling::t:*[1]/t:*
               /t:unclear[not(following-sibling::t:*)][following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>(</xsl:text>
            </xsl:if>
         </xsl:when>-->

         <xsl:otherwise>
           <xsl:element name="span">
              <xsl:attribute name="class">notBold</xsl:attribute>
              <xsl:text>(</xsl:text>
           </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


  <xsl:template name="brackets-closer">
    <!--
      In the diagrams above corresponding to the same number
      Relationship: start at y going to x
      And so the 'y' in the comments should be replaced with 'x'
    -->
    <xsl:choose>
      <!-- 1.1 -->
      <xsl:when test="following-sibling::t:unclear[1]">
         <xsl:if test="following-sibling::node()[1][self::text()][not(translate(normalize-space(.), ' ', '') = '')] or following-sibling::t:*[1][local-name() = ('lb', 'supplied', 'gap', 'pb', 'space', 'milestone', 'choice', 'hi', 'g', 'orig', 'surplus', 'seg')] or following-sibling::t:*[1][local-name() = ('lb', 'supplied', 'gap', 'pb', 'space', 'milestone', 'choice', 'hi', 'num', 'abbr')]/text()">
               <xsl:element name="span">
                  <xsl:attribute name="class">notBold cas1.1</xsl:attribute>
                  <xsl:text>)</xsl:text>
               </xsl:element>
            </xsl:if>
         </xsl:when>


         <!-- 1.2 -->
      <xsl:when test="current()[not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]
                                   /following-sibling::t:*[1]/t:unclear[not(preceding-sibling::t:*)]">
         <xsl:if test="following-sibling::t:*[1]/t:unclear[not(preceding-sibling::t:*[local-name() = ('lb', 'seg', 'supplied', 'gap', 'pb', 'space', 'milestone', 'choice', 'hi', 'g', 'orig', 'surplus', 'abbr', 'num')])][preceding-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:element name="span">
                  <xsl:attribute name="class">notBold cas1.2</xsl:attribute>
                  <xsl:text>)</xsl:text>
               </xsl:element>
            </xsl:if>
         </xsl:when>


         <!-- 1.3 -->
      <!--<xsl:when test="current()[not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]/following-sibling::t:*[1]/t:*[not(preceding-sibling::t:*)][not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]/t:unclear[not(preceding-sibling::t:*)]">
            <xsl:if test="following-sibling::t:*[1]/t:*/t:unclear[not(preceding-sibling::t:*)][preceding-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>)</xsl:text>
            </xsl:if>
         </xsl:when>-->


         <!-- 2.1 -->
     <xsl:when test="current()[not(following-sibling::t:*)]
         [not(following-sibling::text()) or translate(normalize-space(following-sibling::text()[1]), ' ', '') = '']
         /parent::t:*[following-sibling::t:unclear[1]]">
            <xsl:if test="parent::t:*[following-sibling::node()[1][self::text()][not(translate(normalize-space(.), ' ', '') = '')] or following-sibling::node()[1]
            [self::text() and translate(normalize-space(.), ' ', '') = '']] or following-sibling::t:*[1]/t:unclear[not(preceding-sibling::t:*[local-name() = ('lb', 'supplied', 'gap', 'pb', 'space', 'milestone', 'choice', 'hi')])][preceding-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]
            /following-sibling::t:*[1]/t:unclear[not(preceding-sibling::t:*)] or parent::t:*[following-sibling::node()[1]]/following-sibling::t:*[1]/t:*[not(self::t:unclear)] or parent::t:*[following-sibling::node()[1]]/following-sibling::t:*[not(self::t:unclear)]">
               <xsl:element name="span">
                  <xsl:attribute name="class">notBold cas2.1</xsl:attribute>
                  <xsl:text>)</xsl:text>
               </xsl:element>
            </xsl:if>
         </xsl:when>


         <!-- 2.2 -->
      <!--<xsl:when test="current()[not(following-sibling::t:*)]
                                          [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                          [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                          /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][following-sibling::t:*[1]]
                                          [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                          [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                          /following-sibling::t:*[1]/t:unclear[not(preceding-sibling::t:*)]">
            <xsl:if test="parent::t:*/preceding-sibling::t:*[1]
               /t:unclear[not(following-sibling::t:*)][following-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>)</xsl:text>
            </xsl:if>
         </xsl:when>-->


         <!-- 2.3 -->
      <!--<xsl:when test="current()[not(following-sibling::t:*)]
                                          [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                          [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                          /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][following-sibling::t:*[1]]
                                          [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                          [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                          /following-sibling::t:*[1]
                                          /t:*[not(preceding-sibling::t:*)]
                                          [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                          [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                          /t:unclear[not(preceding-sibling::t:*)]">
            <xsl:if test="parent::t:*/following-sibling::t:*[1]/t:*
               /t:unclear[not(preceding-sibling::t:*)][preceding-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>)</xsl:text>
            </xsl:if>
         </xsl:when>
-->

         <!-- 3.1 -->
      <!--<xsl:when test="current()[not(following-sibling::t:*)]
         [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]/parent::t:*[not(following-sibling::t:*)]         [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1][self::text() and translate(normalize-space(.), ' ', '') = '']]         /parent::t:*[following-sibling::t:unclear[1]]">
            <xsl:if test="parent::t:*/parent::t:*[following-sibling::node()[1][self::text()][not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>)</xsl:text>
            </xsl:if>
         </xsl:when>
-->

         <!-- 3.2 -->
     <!-- <xsl:when test="current()[not(following-sibling::t:*)]
                                           [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                           [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                           /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][not(following-sibling::t:*)]
                                           [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                           [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                           /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][following-sibling::t:*[1]]
                                           [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                           [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                           /following-sibling::t:*[1]
                                           /t:unclear[not(preceding-sibling::t:*)]">
            <xsl:if test="parent::t:*/parent::t:*/following-sibling::t:*[1]
               /t:unclear[not(preceding-sibling::t:*)][preceding-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>)</xsl:text>
            </xsl:if>
         </xsl:when>
-->

         <!-- 3.3 -->
     <!--<xsl:when test="current()[not(following-sibling::t:*)]
                                             [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                             [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                             /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][not(following-sibling::t:*)]
                                             [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                             [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                             /parent::t:*[not(local-name() = ('ab','egXML','l','item'))][following-sibling::t:*[1]]
                                             [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                             [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                             /following-sibling::t:*[1]
                                             /t:*[not(preceding-sibling::t:*)]
                                             [not(following-sibling::node()[1][self::text()]) or following-sibling::node()[1]
                                             [self::text() and translate(normalize-space(.), ' ', '') = '']]
                                             /t:unclear[not(preceding-sibling::t:*)]">
            <xsl:if test="parent::t:*/parent::t:*/following-sibling::t:*[1]/t:*
               /t:unclear[not(preceding-sibling::t:*)][preceding-sibling::text()[not(translate(normalize-space(.), ' ', '') = '')]]">
               <xsl:text>)</xsl:text>
            </xsl:if>
         </xsl:when>-->
         <xsl:when test="following-sibling::t:*[1][local-name() = ('lb')]/following-sibling::t:*[2][self::text()]">
         <xsl:if test="following-sibling::t:*[1][local-name() = ('lb')]">
           <xsl:text>)</xsl:text>
         </xsl:if>
       </xsl:when>


         <xsl:otherwise>
              <xsl:element name="span">
               <xsl:attribute name="class">notBold</xsl:attribute>
               <xsl:text>)</xsl:text>
            </xsl:element>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

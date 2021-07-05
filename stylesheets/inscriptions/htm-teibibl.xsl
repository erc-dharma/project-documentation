<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:t="http://www.tei-c.org/ns/1.0"
	xmlns:f="http://example.com/ns/functions"
	xmlns:html="http://www.w3.org/1999/html"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" version="2.0">
	<!--

Pietro notes on 14/8/2015 work on this template, from mail to Gabriel.

- I have converted the TEI bibliography of IRT and IGCyr to ZoteroRDF
(https://github.com/EAGLE-BPN/BiblioTEI2ZoteroRDF) in this passage I have tried to
distinguish books, bookparts, articles and conference proceedings.

- I have uploaded these to the zotero eagle open group bibliography
(https://www.zotero.org/groups/eagleepigraphicbibliography)

- I have created a parametrized template in my local epidoc xslts which looks at the json
and TEI output of the Zotero api basing the call on the content of ptr/@target in each
bibl. It needs both because the key to build the link is in the json but the TEI xml is
much more accessible for the other data. I tried also to grab the html div exposed in the
json, which would have been the easiest thing to do, but I can only get it escaped and
thus is not usable.
** If set on 'zotero' it prints surname, name, title and year with a link to the zotero
item in the eagle group bibliography. It assumes bibl only contains ptr and citedRange.
** If set on 'localTEI' it looks at a local bibliography (no zotero) and compares the
@target to the xml:id to take the results and print something (in the sample a lot, but
I'd expect more commonly Author-Year references(.
** I have also created sample values for irt and igcyr which are modification of the
zotero option but deal with some of the project specific ways of encoding the
bibliography. All examples only cater for book and article.



-->

	<!--

		Pietro Notes on 10.10.2016

		this should be modified based on parameters to

		* decide wheather to use zotero or a local version of the bibliography in TEI

		* assuming that the user has entered a unique tag name as value of ptr/@target, decide group or user in zotero to look up based on parameter value entered at transformation time

		* output style based on Zotero Style Repository stored in a parameter value entered at transformation time



	-->

	<xsl:template match="t:bibl" priority="1" mode="dharma">
		<xsl:param name="parm-bib" tunnel="yes" required="no"/>
		<xsl:param name="parm-bibloc" tunnel="yes" required="no"/>
		<xsl:param name="parm-zoteroUorG" tunnel="yes" required="no"/>
		<xsl:param name="parm-zoteroKey" tunnel="yes" required="no"/>
		<xsl:param name="parm-zoteroNS" tunnel="yes" required="no"/>
		<xsl:param name="parm-zoteroStyle" tunnel="yes" required="no"/>
		<xsl:param name="parm-leiden-style" tunnel="yes" required="no"></xsl:param>
		<xsl:variable name="var-zoteroStyle-abb">https://raw.githubusercontent.com/erc-dharma/project-documentation/master/bibliography/DHARMA_Modified-chicago-author-date_Abbreviation_v01.csl</xsl:variable>

		<xsl:choose>
			<!-- default general zotero behaviour prints
				author surname and name, title in italics, date and links to the zotero item page on the zotero bibliography.
				assumes the inscription source has no free text in bibl,
				!!!!!!!only a <ptr target='key'/> and a <citedRange>pp. 45-65</citedRange>!!!!!!!
			it also assumes that the content of ptr/@target is a unique tag used in the zotero bibliography as the ids assigned by Zotero are not
			reliable enough for this purpose according to Zotero forums.

			if there is no ptr/@target, this will try anyway and take a lot of time.
			-->

			<xsl:when test="$parm-bib = 'none'">
				<xsl:apply-templates/>
			</xsl:when>

			<xsl:when test="$parm-bib = 'zotero'">
				<xsl:choose>
					<!--					check if there is a ptr at all

					WARNING. if the pointer is not there, the transformation will simply stop and return a premature end of file message e.g. it cannot find what it is looking for via the zotero api
					-->
					<xsl:when test=".[t:ptr]">

						<!--						check if a namespace is provided for tags/xml:ids and use it as part of the tag for zotero-->
						<xsl:variable name="biblentry"
							select="replace(substring-after(./t:ptr/@target, ':'), '\+', '%2B')"/>
							<!-- Debugging message-->
								<!--	<xsl:message>biblentry= <xsl:value-of select="$biblentry"/></xsl:message>-->

						<xsl:variable name="zoteroapitei">

							<xsl:value-of
								select="replace(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=tei'), 'amp;', '')"/>
							<!-- to go to the json with the escaped html included  use &amp;format=json&amp;include=bib,data and the code below: the result is anyway escaped... -->

						</xsl:variable>
							<!-- Debugging message-->
						<!--<xsl:message>zoteroapitei= <xsl:value-of select="$zoteroapitei"/></xsl:message>-->
						<xsl:variable name="zoteroapijsonomitname">
							<xsl:value-of
								select="replace(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=json'), 'amp;', '')"
							/>
						</xsl:variable>
						<xsl:variable name="unparsedomitname" select="unparsed-text($zoteroapijsonomitname)"/>

						<xsl:variable name="zoteroapijson">
							<xsl:value-of
								select="replace(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=json&amp;style=',$parm-zoteroStyle,'&amp;include=citation'), 'amp;', '')"
							/>
						</xsl:variable>
							<!-- Debugging message-->
					<!--<xsl:message>zoteroapijson= <xsl:value-of select="$zoteroapijson"/></xsl:message>-->

						<xsl:variable name="unparsedtext" select="unparsed-text($zoteroapijson)"/>
						<!--<xsl:variable name="zoteroitemKEY">

							<xsl:analyze-string select="$unparsedtext"
								regex="(\[\s+\{{\s+&quot;key&quot;:\s&quot;)(.+)&quot;">
								<xsl:matching-substring>
									<xsl:value-of select="regex-group(2)"/>
								</xsl:matching-substring>
							</xsl:analyze-string>

						</xsl:variable>-->
						<xsl:variable name="zoteroapijournal">
							<xsl:value-of
								select="replace(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=json&amp;style=',$parm-zoteroStyle), 'amp;', '')"
							/>
						</xsl:variable>
						<xsl:variable name="unparsedjournal" select="unparsed-text($zoteroapijournal)"/>
						<!--<xsl:message> unparsedjournal = <xsl:value-of select="$unparsedjournal"/></xsl:message>-->


						<xsl:choose>
							<!--this will print a citation according to the selected style with a link around it pointing to the resource DOI, url or zotero item view-->
							<xsl:when test="not(//t:div[@type = 'bibliography']/t:listBibl) or ancestor::t:p or ancestor::t:note">
								<xsl:variable name="pointerurl">
									<xsl:choose>
										<xsl:when
											test="document($zoteroapitei)//t:idno[@type = 'DOI']">
											<xsl:value-of
												select="document($zoteroapitei)//t:idno[@type = 'DOI']"
											/>
										</xsl:when>
										<xsl:when
											test="document($zoteroapitei)//t:idno[@type = 'url']">
											<xsl:value-of
												select="document($zoteroapitei)//t:idno[@type = 'url']"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="document($zoteroapitei)//t:biblStruct/@corresp"
											/>
										</xsl:otherwise>
									</xsl:choose>

								</xsl:variable>


								<a href="{$pointerurl}">
									<xsl:variable name="citation">
										<xsl:analyze-string select="$unparsedtext"
											regex="(\s+&quot;citation&quot;:\s&quot;&lt;span&gt;)(.+)(&lt;/span&gt;&quot;)">
											<xsl:matching-substring>
												<xsl:value-of select="regex-group(2)"/>
											</xsl:matching-substring>
										</xsl:analyze-string>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="@rend='omitname' and $leiden-style = 'dharma'">
											<!-- Omitname ne peut pas passer par $soteroapitei car ne parse que la première date d'un intervalle -->
											<!--<xsl:value-of select="document($zoteroapitei)//t:imprint/t:date"/>-->
											<xsl:analyze-string select="$unparsedomitname"
												regex="(\s+&quot;date&quot;:\s&quot;)(.+)(&quot;)">
												<xsl:matching-substring>
													<xsl:value-of select="regex-group(2)"/>
												</xsl:matching-substring>
											</xsl:analyze-string>
										</xsl:when>
										<xsl:when test="@rend='ibid'">
											<xsl:element name="i">
										<xsl:text>ibid.</xsl:text>
										</xsl:element>
									</xsl:when>
									<xsl:when test="$leiden-style = 'dharma' and matches(./child::t:ptr/@target, '[A-Z][A-Z]')">
										<xsl:call-template name="journalTitle"/>
									</xsl:when>
										<xsl:otherwise>
											<!--<xsl:value-of select="replace(replace(replace($citation, '^[\(]+([&lt;][a-z][&gt;])*', '') , '[&lt;/]*[a-z]+[&gt;][\)]*', ''), '([0-9–]*[0-9]+)[\)]+$', '($1)')"/>-->
											<xsl:value-of select="replace(replace(replace(replace($citation, '^[\(]+([&lt;][a-z][&gt;])*', ''), '([&lt;/][a-z][&gt;])+[\)]+$', ''), '\)', ''), '&lt;/[i]&gt;', '')"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
								<xsl:if test="t:citedRange">
									<xsl:choose>
									<xsl:when test="t:citedRange and not(ancestor::t:cit)">
									<xsl:text>: </xsl:text>
								</xsl:when>
								<xsl:when test="t:citedRange and ancestor::t:cit">
									<xsl:text>, </xsl:text>
								</xsl:when>
							</xsl:choose>
									<xsl:for-each select="t:citedRange">
										<xsl:call-template name="citedRange-unit"/>
										<!-- NEED TO BE REVISED AT SOME POINT TO RENDER THE ITALIC
										not the best solution but hierarchy too instabled to force it with mode without breaking the current display - necessary to revise the code once the encoding is stable enough probably need to use the foreign element as the base rather than the bibl element -->
										<xsl:choose>
											<xsl:when test="child::t:foreign">
											<i>
												<xsl:apply-templates select="replace(normalize-space(.), '-', '–')"/>
											</i>
										</xsl:when>
										<xsl:otherwise>
										<xsl:apply-templates select="replace(normalize-space(.), '-', '–')"/>
									</xsl:otherwise>
										</xsl:choose>

									<xsl:if test="following-sibling::t:citedRange[1]">
										<xsl:text>, </xsl:text>
									</xsl:if>
									</xsl:for-each>
								</xsl:if>
								<!-- Display for t:cit  -->
								<xsl:if test="following::t:quote[1] and ancestor::t:cit">
								<xsl:text>: </xsl:text>
							</xsl:if>
							</xsl:when>
							<!--	if it is in the bibliography print styled reference-->
							<xsl:otherwise>
								<!--	print out using Zotoro parameter format with value bib and the selected style-->

								<xsl:element name="div">
									<xsl:attribute name="class">refBibl</xsl:attribute>
									<xsl:if test="matches(./child::t:ptr/@target, '[A-Z][A-Z]')">
										<!-- Adding a style to match the CSS style imported from Zotero added by the API -->
										<xsl:attribute name="style">line-height: 1.35; padding-left: 1em; text-indent:-1em;</xsl:attribute>
								</xsl:if>
								<!--<span class="tooltip-bibl">-->
								<!--<xsl:apply-templates select="./text()"/>-->
								<xsl:if test="./child::t:author">
								<xsl:value-of select="./child::t:author"/>
							<xsl:text> in </xsl:text></xsl:if>
								<!--<xsl:copy-of
									select="replace(document(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$parm-zoteroStyle))/div, '[\.]$', ':')"/>-->
									<xsl:choose>
										<xsl:when test="matches(./child::t:ptr/@target, 'bib:[A-Z][A-Z]') and $leiden-style = 'dharma'">
											<!-- Code added for Arlo's request regarding BEFEO36_1936 in K00868.xml-->
											<!--<xsl:variable name="soughtSiglum" select="./child::t:ptr/@target"/>-->
													<!-- Handles also JBG, NBG -->
													<xsl:choose>
									<xsl:when test="$leiden-style = 'dharma' and matches(./child::t:ptr/@target, '[A-Z][A-Z]')">
															<xsl:call-template name="journalTitle"/>
															<xsl:text>. </xsl:text>
																	<!--<span class="tooltiptext-bibl">
																		<xsl:copy-of
																			select="document(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$parm-zoteroStyle))/div"/>
																</span>-->
												</xsl:when>
												<!-- For the cases handled with regularly entry in Zotero-->
												<!-- journal abbreviation -->
												<!--	<xsl:otherwise>

														<xsl:variable name="journalAbbreviation">
															<xsl:analyze-string regex="(&quot;journalAbbreviation&quot;:\s&quot;)(.+)&quot;" select="$unparsedjournal">
																<xsl:matching-substring>
																<xsl:value-of select="regex-group(2)"/>
															</xsl:matching-substring>
															</xsl:analyze-string>
														</xsl:variable>
														<xsl:message>journalAbb = <xsl:value-of select="$journalAbbreviation"/></xsl:message>
														volume number
														<xsl:variable name="journalVolume">
															<xsl:analyze-string regex="(&quot;volume&quot;:\s&quot;)(.+)&quot;" select="$unparsedjournal">
																<xsl:matching-substring>
																<xsl:value-of select="regex-group(2)"/>
															</xsl:matching-substring>
															</xsl:analyze-string>
														</xsl:variable>
													<xsl:message>journalVolume = <xsl:value-of select="$journalVolume"/></xsl:message>
													 Date
														<xsl:variable name="journalDate">
															<xsl:analyze-string regex="(&quot;date&quot;:\s&quot;)(.+)&quot;" select="$unparsedjournal">
																<xsl:matching-substring>
																<xsl:value-of select="regex-group(2)"/>
															</xsl:matching-substring>
															</xsl:analyze-string>
														</xsl:variable>
													<xsl:message>journalDate = <xsl:value-of select="$journalDate"/></xsl:message>
													<xsl:variable name="journalName">
														<xsl:analyze-string regex="(&quot;lastName&quot;:\s&quot;)(.+)&quot;" select="$unparsedjournal">
															<xsl:matching-substring>
															<xsl:value-of select="regex-group(2)"/>
														</xsl:matching-substring>
														</xsl:analyze-string>
													</xsl:variable>

														<xsl:value-of select="$journalName"/>
														<xsl:text> in </xsl:text>
														<i><xsl:value-of select="$journalAbbreviation"/></i>
														<xsl:text> </xsl:text>
														<xsl:value-of select="$journalVolume"/>
														<xsl:text> (</xsl:text>
														<xsl:value-of select="$journalDate"/>
														<xsl:text>). </xsl:text>
														<span class="tooltiptext-bibl">
															<xsl:copy-of
																select="document(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$parm-zoteroStyle))/div"/>
													</span>
													</xsl:otherwise>-->
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
												<xsl:copy-of
													select="document(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$var-zoteroStyle-abb))/div"/>
												<!--<span class="tooltiptext-bibl">
									<xsl:copy-of
										select="document(concat('https://api.zotero.org/',$parm-zoteroUorG,'/',$parm-zoteroKey,'/items?tag=', $biblentry, '&amp;format=bib&amp;style=',$parm-zoteroStyle))/div"/>
										</span>-->
										</xsl:otherwise>
									</xsl:choose>
								<!--</span>-->
									<xsl:if test="t:citedRange">
										<xsl:for-each select="t:citedRange">
											<b>
											<xsl:call-template name="citedRange-unit"/>
										<xsl:apply-templates select="replace(normalize-space(.), '-', '–')" mode="italic-citedRange"/>
											</b>
										<xsl:if test="following-sibling::t:citedRange">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
										<xsl:text>.</xsl:text>
									</xsl:if>
										<xsl:if test="child::t:note">
											<xsl:text> • </xsl:text>
											<xsl:value-of select="child::t:note"/>
										</xsl:if>

									<!--<xsl:if test="following-sibling::t:note">
									<xsl:text> • </xsl:text>
									<xsl:value-of select="following-sibling::t:note"/>
								</xsl:if>-->

									<xsl:if test="ancestor::t:listBibl and ancestor-or-self::t:bibl/@n"> <!-- [@type='primary'] -->
									<xsl:element name="span">
										<xsl:attribute name="class">siglum</xsl:attribute>
										<xsl:if test="ancestor-or-self::t:bibl/@n">
											<xsl:text> [siglum </xsl:text>
											<strong><xsl:value-of select="ancestor-or-self::t:bibl/@n"/></strong>
											<xsl:text>]</xsl:text>
										</xsl:if>
											</xsl:element>
										<!-- Deleting the display for siglum proposition-->
									<!--	<xsl:if test="not(ancestor-or-self::t:bibl/@n)">
											<xsl:text>No Siglum : </xsl:text>
											<xsl:choose>
											<xsl:when test="matches(t:ptr/@target, '\+[a][l]')">
												<xsl:value-of select="normalize-space(translate(@target,'abcdefghijklmnopqrstuvwxyz0123456789+-_:',''))"/>
												<xsl:text> &amp; al.</xsl:text>
												<xsl:text>?</xsl:text>
											</xsl:when>
											<xsl:when test="matches(t:ptr/@target, '\+[A-Z]')">
												<xsl:value-of select="normalize-space(translate(substring-before(@target, '+'),'abcdefghijklmnopqrstuvwxyz0123456789+-_:',''))"/>
												<xsl:text>&amp;</xsl:text>
												<xsl:value-of select="normalize-space(translate(substring-after(@target, '+'),'abcdefghijklmnopqrstuvwxyz0123456789+-_:',''))"/>
												<xsl:text>?</xsl:text>
											</xsl:when>
											<xsl:otherwise>
										 <xsl:value-of select="normalize-space(translate(t:ptr/@target,'abcdefghijklmnopqrstuvwxyz0123456789-_:',''))"/>
										 <xsl:text>?</xsl:text>
									 </xsl:otherwise>
								 </xsl:choose>
							 </xsl:if>-->


								</xsl:if>
								<xsl:element name="br"/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:when>

					<!-- if there is no ptr, print simply what is inside bibl and a warning message-->
					<xsl:otherwise>
						<xsl:value-of select="."/>
						<xsl:message>There is no ptr with a @target in the bibl element <xsl:copy-of
								select="."/>. A target equal to a tag in your zotero bibliography is
							necessary.</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>


			<!--uses the local TEI bibliography at the path specified in parameter parm-bibloc -->
			<xsl:when test="$parm-bib = 'localTEI'">

				<xsl:variable name="biblentry" select="./t:ptr/@target"/>
				<xsl:variable name="biblentryID" select="substring-after(./t:ptr/@target, '#')"/>
				<!--					parameter localbibl should contain the path to the bibliography relative to this xslt -->
				<xsl:variable name="textref"
					select="document(string($parm-bibloc))//t:bibl[@xml:id = $biblentryID]"/>
				<xsl:for-each select="$biblentry">
					<xsl:choose>
						<!--this will print a citation according to the selected style with a link around it pointing to the resource DOI, url or zotero item view-->
						<xsl:when test="not(ancestor::t:div[@type = 'bibliography'])">

							<!-- basic	render for citations-->
							<xsl:choose>
								<xsl:when test="$textref/@xml:id = $biblentryID">
									<xsl:choose>
										<xsl:when test="$textref//t:author">
											<xsl:value-of select="$textref//t:author[1]"/>
											<xsl:if test="$textref//t:author[2]">
												<xsl:text>-</xsl:text>
												<xsl:value-of select="$textref//t:author[2]"/>
											</xsl:if>
											<xsl:text>, </xsl:text>
										</xsl:when>
										<xsl:when test="$textref//t:editor">
											<xsl:value-of select="$textref//t:editor[1]"/>
											<xsl:if test="$textref//t:editor[2]">
												<xsl:text>-</xsl:text>
												<xsl:value-of select="$textref//t:editor[2]"/>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
									<xsl:text> (</xsl:text>
									<xsl:value-of select="$textref//t:date"/>
									<xsl:text>), </xsl:text>
									<xsl:value-of select="$textref//t:biblScope"/>

								</xsl:when>
								<xsl:otherwise>
									<!--if this appears the id do not really correspond to each other,
									ther might be a typo or a missing entry in the bibliography-->
									<xsl:message>
										<xsl:text> there is no entry in your bibliography file at </xsl:text>
										<xsl:value-of select="$parm-bibloc"/>
										<xsl:text> with the @xml:id</xsl:text>
										<xsl:value-of select="$biblentry"/>
										<xsl:text>!</xsl:text>
									</xsl:message>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>

							<!--						rudimental render for each entry in bibliography-->
							<xsl:choose>
								<xsl:when test="$textref/@xml:id = $biblentryID">
									<xsl:value-of select="$textref"/>
									<!--assumes a sligthly "formatted" bibliography...-->

								</xsl:when>
								<xsl:otherwise>
									<!--if this appears the id do not really correspond to each other,
									ther might be a typo or a missing entry in the bibliography-->
									<xsl:message>
										<xsl:text> there is no entry in your bibliography file at </xsl:text>
										<xsl:value-of select="$parm-bibloc"/>
										<xsl:text> for the entry </xsl:text>
										<xsl:value-of select="$biblentry"/>
										<xsl:text>!</xsl:text>
									</xsl:message>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise>
				<!-- This applyes other templates and does not call the zotero api -->
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template name="citedRange-unit">
	<xsl:variable name="CurPosition" select="position()"/>
	<xsl:variable name="unit-value">
		<xsl:choose>
		<xsl:when test="@unit='page'"><!-- and ancestor::t:listBibl -->
			<xsl:choose>
			<xsl:when test="matches(., '[–\-]+')">
				<xsl:text>pages </xsl:text>
			</xsl:when>
			<xsl:when test="matches(., ',')">
				<xsl:text>pages </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text>page </xsl:text>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:when>
		<xsl:when test="@unit='part'">
			<xsl:text>part </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='volume'">
			<xsl:text>volume </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='note'">
			<xsl:text>note </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='item'">
			<xsl:text>&#8470; </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='entry'">
			<xsl:text>s.v. </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='figure'">
			<xsl:text>figure </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='plate'">
			<xsl:text>plate </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='table'">
			<xsl:text>table </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='appendix'">
			<xsl:text>appendix </xsl:text>
		</xsl:when>
		<xsl:when test="@unit='line'">
			<xsl:choose>
			<xsl:when test="matches(., '[–\-]+')">
				<xsl:text>lines </xsl:text>
			</xsl:when>
			<xsl:when test="matches(., ',')">
				<xsl:text>lines </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text>line </xsl:text>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<!--<xsl:if test="ancestor::t:listBibl">-->
			<xsl:choose>
			<xsl:when test="matches(., '[\-]+')">
				<xsl:text>pages </xsl:text>
			</xsl:when>
			<xsl:when test="matches(., ',')">
				<xsl:text>pages </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text>page </xsl:text>
		</xsl:otherwise>
		</xsl:choose>
	<!--</xsl:if>-->
	</xsl:otherwise>
</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$CurPosition = 1 and not(ancestor::t:p or ancestor::t:note)">
			<xsl:value-of select="concat(upper-case(substring($unit-value,1,1)), substring($unit-value, 2),' '[not(last())] )"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="$unit-value"/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="journalTitle">
	<xsl:choose>
		<!-- Handles ARIE1886-1887 or ARIE1890-1891_02 -->
		<xsl:when test="matches(./child::t:ptr/@target, '[a-z]+:([A][R][I][E])([0-9\-]+)(_[0-9])*')">
			<xsl:analyze-string select="./child::t:ptr/@target" regex="[a-z]+:([A][R][I][E])([0-9\-]+)(_[0-9])*">
				<xsl:matching-substring>
								<i><xsl:value-of select="regex-group(1)"/></i>
								<xsl:text> </xsl:text>
								<xsl:value-of select="regex-group(2)"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
		</xsl:when>
<xsl:when test="matches(./child::t:ptr/@target, '[a-z]+:([A-Z]+)([0-9][0-9]+[0-9\-]*)_([0-9]+[\-]*)')">
 <xsl:analyze-string select="./child::t:ptr/@target" regex="[a-z]+:([A-Z]+)([0-9][0-9]+[0-9\-]*)_([0-9]+[\-]*)">
	<xsl:matching-substring>
					<i><xsl:value-of select="regex-group(1)"/></i>
					<xsl:text> </xsl:text>
					<xsl:value-of select="regex-group(2)"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="regex-group(3)"/>
					<xsl:text>)</xsl:text>
			</xsl:matching-substring>
		</xsl:analyze-string>
</xsl:when>
<!-- Handles OV, ROC, ROD -->
<xsl:when test="matches(./child::t:ptr/@target, '[a-z]+:([A-Z]+)([0-9\-]+)(_[0-9])*')">
 <xsl:analyze-string select="./child::t:ptr/@target" regex="[a-z]+:([A-Z]+)([0-9\-]+)(_[0-9])*">
	<xsl:matching-substring>
					<i><xsl:value-of select="regex-group(1)"/></i>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="regex-group(2)"/>
					<xsl:text>)</xsl:text>
			</xsl:matching-substring>
		</xsl:analyze-string>
</xsl:when>
	<!-- TBG1924_64 transformed into TBG64_1924 so the following lines are necessary anymore-->
	<!--<xsl:when test="matches(./child::t:ptr/@target, '[a-z]+:([T][G][B])([0-9\-]*)(_[0-9][0-9])')">
	 <xsl:analyze-string select="./child::t:ptr/@target" regex="[a-z]+:([T][G][B])([0-9\-]*)(_[0-9][0-9])">
		<xsl:matching-substring>
						<i><xsl:value-of select="regex-group(1)"/></i>
						<xsl:text> </xsl:text>
						<xsl:value-of select="regex-group(3)"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="regex-group(2)"/>
						<xsl:text>)</xsl:text>
				</xsl:matching-substring>
			</xsl:analyze-string>
	</xsl:when>-->
	<!-- BCAI_1912 and BCAI_1917-1930 / Avanam1993_01   – not tested  transformed into BCAI1912 folliwing lines not necessary anymore-->
	<!--<xsl:when test="matches(./child::t:ptr/@target, '[a-z]+:([B][C][A][I])(_[0-9\-]*)')">
	 <xsl:analyze-string select="./child::t:ptr/@target" regex="[a-z]+:([B][C][A][I])(_[0-9\-]*)">
		<xsl:matching-substring>
						<i><xsl:value-of select="regex-group(1)"/></i>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="regex-group(2)"/>
						<xsl:text>)</xsl:text>
				</xsl:matching-substring>
			</xsl:analyze-string>
	</xsl:when>-->
</xsl:choose>
</xsl:template>

<!-- Code added regardung Manu's request in pallava00042 for siglum with @rend='siglum'-->
<!--<xsl:when test="@rend='siglum' and $leiden-style = 'dharma'">
	<xsl:variable name="soughtSiglum" select="child::t:ptr/@target"/>
	<xsl:if test="//t:listBibl/descendant::t:ptr[@target=$soughtSiglum]">
		<span class="tooltip-bibl">
			<xsl:value-of select="//t:listBibl/t:bibl[t:ptr/@target=$soughtSiglum]/@n"/>
			<span class="tooltiptext-bibl">
				<xsl:choose>
					<xsl:when test="matches(./child::t:ptr/@target, '[A-Z][A-Z]')">
						<xsl:call-template name="journalTitle"/>
					</xsl:when>
					<xsl:otherwise>
				<xsl:value-of select="replace(replace(replace(replace($citation, '^[\(]+([&lt;][a-z][&gt;])*', ''), '([&lt;/][a-z][&gt;])+[\)]+$', ''), '\)', ''), '&lt;/[i]&gt;', '')"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
		</span>
		</xsl:if>
</xsl:when>-->
</xsl:stylesheet>

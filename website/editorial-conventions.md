# Editorial Conventions

## 1. Semantic and metrical structure (intrinsic structure)

###### Stanza in named metre

```
<lg n="1" met="āryā"></lg>
```

###### Stanza in metre without a known name

```
<lg n="2" met="+++++-++-+="></lg>
```

###### Verse line

```
<l n="a">kāritam idan nr̥patinā</l>
```

###### Word divided across verse lines (enjambement)

```
<l n="a" enjamb="yes">tat-sūnus sakalārāti</l><l n="b">-mada-ccheda-karāyudhaḥ</l>
```

The hyphen at the beginning of the second line is editorial compound segmentation; that at the end of the first line is the display for enjambement.


## 2. Layout (extrinsic structure)

###### Beginning of inscribed zone

```
<milestone type="pagelike" unit="zone" n="A"/>svasti śrī
```

###### Beginning of inscribed zone

```
<milestone type="pagelike" unit="item" n="A"/>svasti śrī
```

###### Beginning of surface or zone, with editorial label

```
<milestone type="pagelike" unit="item" n="N"/><label xml:lang="eng">Northern Doorjamb</label>svasti śrī
```

###### Beginning of page in copperplate inscription

```
<pb n="1r"/>svasti śrī
```

###### Beginning of line

```
<lb n="1"/>svasti śrī<lb n="2"/>kōpparakēcari
```

###### Beginning of non-hierarchical division (fragment, masonry block, etc.)

```
<milestone unit="block" n="a"/>svasti śrī
```

###### Word divided across break

```
<lb n="1"/>…dhar<lb n="2" break="no"/>ma…
```

Same display and same attribute for breaks other than line beginnings.


## 3. Palaeographic features

###### Vowel

```
<seg type="component" subtype="prescript"/> <seg type="component" subtype="postscript"/>`
```

###### Consonant

```
<seg type="component" subtype="body"/>
```

###### Single symbol representing a number above 9

```
<g type="numeral">200</g>
```

###### Symbol interpreted as punctuation

```
<g type="danda">.</g>
```

Display depends on `@type`.

###### Symbol interpreted as space filler

```
<g type="squiggleVertical">§</g>
```

Display depends on `@type`.

###### Uninterpreted symbol

```
<g type="floretComplex"/>
```

Display depends on `@type`.

###### Small space between words

```
<space/>
```

“Small” is defined as less than two typical character widths.

###### Large space between words or semantic units

```
<space quantity="3" unit="character"/>
```

Approximate width of space in typical-sized character.

###### Space left blank because it was not possible to write in a given spot

```
<space type="binding-hole"/>
```

Other values of `@type` for other reasons of inability to write. The size of these spaces is never encoded.

###### Space left blank presumably with the intent to fill later

```
<space type="vacat" quantity="5" unit="character"/>
```

Approximate width of space in typical-sized character. The size of these spaces must always be encoded.

###### Space of uninterpreted function

```
<space type="unclassified"/>
```

Size optionally encoded with `@quantity` and `@unit`.


## 4. Scribal alterations in text

###### Characters added by premodern scribe

```
dha<add>rma</add>
```

Locus of insertion and eventual addition mark encoded by attributes.

###### Characters deleted by premodern scribe but still legible

```
dharma<del>ma</del>
```

Manner of deletion encoded by attributes. If the deleted text is unclear or only tentatively legible, this is encoded and displayed normally (section 5).

###### Characters deleted by premodern scribe and no longer legible

```
<del><gap reason="illegible" quantity="1" unit="character"/></del>
```

Manner of deletion encoded by attributes. Number of illegible characters encoded as in other lacunae (section 5).

###### Scribal correction

```
bottun<subst><del rend="corrected">u</del><add place="overstrike">a</add></subst>
```

Manner of deletion and locus of addition may be encoded with different attributes.


## 5. Imperfectly legible text

###### Unclear reading (characters would be ambiguous outside of their context)

```
dha<unclear>rma</unclear>
```

This is without regard to the degree of damage and used in all cases where a character or vestige that would be ambiguous or illegible without its context is confidently read in context.

###### Tentative reading

```
dha<unclear cert="low">rma</unclear>
```

This indicates reduced confidence in the reading, not reduced legibility of the original.

###### Ambiguous reading with two or more possible alternatives

```
<choice> <unclear>a</unclear> <unclear>o</unclear> </choice>
```

###### Lacuna: unknown number of characters irretrievably lost

```
<gap reason="lost" extent="unknown" unit="character"/>
```

###### Lacuna: confidently estimated number of characters irretrievably lost

```
<gap reason="lost" unit="character" quantity="3"/>
```

###### Lacuna: tentatively estimated number of characters irretrievably lost

```
<gap reason="lost" unit="character" quantity="3" precision="low"/>
```

###### Lacuna: unknown number of characters illegible, but vestiges are present

```
<gap reason="illegible" extent="unknown" unit="character"/>
```

###### Lacuna: confidently estimated number of characters illegible, but vestiges are present

```
<gap reason="illegible" unit="character" quantity="3"/>
```

###### Lacuna: tentatively estimated number of characters illegible, but vestiges are present

```
<gap reason="illegible" unit="character" quantity="3" precision="low"/>
```

###### Lacuna: unknown number of characters (encoded from previous edition that makes no distinction between loss and illegibility)

```
<gap reason="undefined" extent="unknown" unit="character"/>
```

###### Lacuna: confidently estimated number of characters (encoded from previous edition that makes no distinction between loss and illegibility)

```
<gap reason="undefined" unit="character" quantity="3"/>
```

###### Lacuna: tentatively estimated number of characters (encoded from previous edition that makes no distinction between loss and illegibility)

```
<gap reason="undefined" unit="character" quantity="3" precision="low"/>
```

###### Lacuna: confidently estimated number of lines

```
<gap reason="lost" quantity="3" unit="line"/>
```

Similarly with reason “illegible” and “undefined”

###### Lacuna: tentatively estimated number of lines

```
<gap reason="lost" quantity="3" unit="line" precision="low"/>
```

Similarly with reason “illegible” and “undefined”

###### Lacuna: unknown number of lines

```
<gap reason="lost" extent="unknown" unit="line"/>
```

Similarly with reason “illegible” and “undefined”

###### Lacuna in verse with known prosody

```
<seg met="+++-++"><gap reason="lost" quantity="6" unit="character"/></seg>
```

Similarly with reason “illegible” and “undefined”

###### Lacuna confidently restored by editor

```
dha<supplied reason="lost">r</supplied>ma
```

Similarly with reason “undefined”, but NOT with reason “illegible”. If vestiges are present, a restoration is to be shown as an unclear reading. Basis of restoration may be encoded with `@evidence`.

###### Lacuna tentatively restored by editor

```
dha<supplied reason="lost" cert="low">r</supplied>ma
```

Similarly with reason “undefined”, but NOT with reason “illegible”. If vestiges are present, a tentative restoration is to be shown as a tentative reading.  Basis of restoration may be encoded with `@evidence`.

###### Lacuna with differently treated parts

```
<gap reason="illegible" quantity="10" unit="character" precision="low"/><seg met="+++-++"><gap reason="illegible" quantity="6" unit="character"/></seg><supplied reason="lost">abc</supplied>
```


## 6. Editorial intervention

###### Non-standard lexicon or spelling

```
<orig>dhamma</orig>
```

###### Non-standard lexicon or spelling normalised by the editor

```
<choice><orig>dhamma</orig><reg>dharmma</reg></choice>
```

###### Erroneous or unintelligible original

```
<sic>dhoma</sic>
```

###### Erroneous or unintelligible original corrected by the editor

```
dha<choice><sic>t</sic><corr>r</corr></choice>ma
```

###### Character(s) omitted by scribe and restored by the editor (editorial addition)

```
dha<supplied reason="omitted">rma</supplied>
```

###### Character(s) omitted by the scribe and not restored by the editor

```
catvāriṁśat samā<seg met="-="><gap reason="omitted" quantity="2" unit="character"/></seg>
```

Unrestored omissions tend to occur in metrical text, since without a known prosody it is hard to be certain that something was omitted. But the same encoding may also be used without `<seg>` and `@met`, and also with `@extent="unknown"` instead of `@quantity`.

###### Superfluous characters engraved by scribe (e.g. dittography) and suppressed by the editor

```
dharma<surplus>ma</surplus>
```


## 7. Editorial markup in translations and commentary

###### Text in language other than the surrounding text, modern language written in Latin script

```translation
<foreign xml:lang="fra">vis-à-vis</foreign>
```

###### Text in language other than the surrounding text and the primary language of the edition, modern or premodern language transliterated from non-Latin script

```translation
<foreign xml:lang="tel-Latn">cuvikaṇṭhi-</foreign>
```

###### Explanatory insertion in translation

```translation
Kantacēṉaṉ <supplied reason="explanation">Skt. Skandasena</supplied>
```

###### Tentative explanatory insertion

```translation
the Raṭṭa lord <supplied reason="explanation" cert="low">Amoghavarṣa I</supplied>
```

###### Corresponding original word inserted in translation

```translation
Temple <supplied reason="explanation"><foreign>tēvakulam</foreign></supplied>
```

###### Words inserted into translation for clarity or syntactical correctness

```translation
Fiftieth <supplied reason="subaudible">year</supplied> of Nantippōttaracar
```

###### Words tentatively inserted for clarity or syntactical correctness

```
<supplied reason="subaudible" cert="low">The donee</supplied> has been allocated a residence
```

###### Unintelligible segment in the original

```translation
<gap reason="ellipsis"/>
```

Usually followed by the original segment in `<supplied reason="explanation"><foreign></foreign></supplied>` and optionally also by an explanatory note.

###### Untranslated segment

```translation
<gap reason="ellipsis"/>
```

Followed by a note explaining why this text has not been translated.

###### Alternative translation of bitextual phrase (*śleṣa*)

```translation
who is attended by mercy as Droṇa <seg rend="pun">is followed by Kr̥pā</seg>
```

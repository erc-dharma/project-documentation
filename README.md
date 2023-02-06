# DHARMA Project Documentation

This repository is storing all the current documentation of the DHARMA Project.

## Corpora repositories
|Task Force|Corpus Designation|Repository name|
|--|--|--|
|Task Force A|Accāḷpuram|tfa-accalpuram-epigraphy|
|Task Force A|Cempiyaṉ Mahādevī|tfa-cempiyan-mahadevi-epigraphy|
|Task Force A|Cīrkāḻi|tfa-cirkali-epigraphy|
|Task Force A|Koṭumpāḷūr|tfa-kotumpalur-epigraphy|
|Task Force A|Mēlappaḻuvūr & Kīḻappaḻuvūr|tfa-melappaluvur-kilappaluvur-epigraphy|
|Task Force A|Pallava|tfa-pallava-epigraphy|
|Task Force A|Pāṇḍya|tfa-pandya-epigraphy|
|Task Force A|South Indian Inscriptions|tfa-sii-epigraphy|
|Task Force A|Tamil Nadu (varia)|tfa-tamilnadu-epigraphy|
|Task Force A|Uttiramērūr|tfa-uttiramerur-epigraphy|
|Task Force B|Śailodbhava|tfb-sailodbhava-epigraphy|
|Task Force B|Bhaumakara|tfb-bhaumakara-epigraphy|
|Task Force B|Eastern Gaṅga|tfb-gangaeast-epigraphy|
|Task Force B|Bengal Copper plates|tfb-bengalcharters-epigraphy|
|Task Force B|Bengal Dedication Inscriptions|tfb-bengalded-epigraphy|
|Task Force B|Arakan|tfb-arakan-epigraphy|
|Task Force B|Dakṣiṇa Kosala|tfb-daksinakosala-epigraphy|
|Task Force B|Rāṣṭrakūṭa|tfb-rastrakuta-epigraphy|
|Task Force B|Bādāmi Cālukya|tfb-badamicalukya-epigraphy|
|Task Force B|Kalyāṇa Cālukya|tfb-kalyanacalukya-epigraphy|
|Task Force B|Eastern Cālukya|tfb-vengicalukya-epigraphy|
|Task Force B|Telugu Inscriptions|tfb-telugu-epigraphy|
|Task Force B|Early Andhra|tfb-eiad-epigraphy|
|Task Force B|Satavahana|tfb-satavahana-epigraphy|
|Task Force B|Somavaṁśin|tfb-somavamsin-epigraphy|
|Task Force B|Maitraka|tfb-maitraka-epigraphy|
|Task Force B|Viṣṇukuṇḍin|tfb-visnukundin-epigraphy|
|Task Force B|Licchavi|tfb-licchavi-epigraphy|
|Task Force C|Campa|tfc-campa-epigraphy|
|Task Force C|Khmer|tfc-khmer-epigraphy|
|Task Force C|Nusantara|tfc-nusantara-epigraphy|
|Task Force D|Sanskrit|tfd-sanskrit-philology|
|Task Force D|Nusantara|tfd-nusantara-philology|

## Open repository list
|Repository name|Corpus Designation|
|arie|ARIE edition in open-source - only html|
|digital-areal| xml-TEI introduction, lessons in French|
|erc-dharma.github.io|Files for temporary website|
|mdt-artefacts|all mdt artefacts and conglomerate artefacts|
|mdt-authorities|all authorities files|
|mdt-surrogates|all mdt surrogates|
|mdt-texts|all mdt texts|
|project-documentation| all docs and scripts of the project|

## Closed repository list
|Repository name|Corpus Designation|
|aditia-phd|Aditia's phd and latex scripts|
|arie-corpus|All arie's sources files|
|electronic-text|Project txt files|
|exchange_aurorachana|repository to share files with Aurorachana|
|lexica-indices|dictionaries and lexica - side projects|

## bibliography 
- pyzotero code to move ZST to tag (**deprecated**)
- CSL adapted for DHARMA from Chicago author-date model
     - DHARMA_modified-chicago-author-date_Abbreviation_v01 [currently used in the codes]
    - DHARMA_modified-chicago-author-date_v01 (**deprecated**)
- DHARMA_zotero_v01 (**back-up**) **must be done manually from time to time, but not a necessity**

## docs
several documents and markdown files 
- atom: user helps in markdown (**deprecated**)
- encoding-critical: back-up since no official release yet
- encoding-diplomatic : back-up for the current working version and first official release
- FNC : back-up for the current working version and first official release
- fonts : sharing fonts in open source
- git : user helps in markdown
- git-issuetracker: user helps in markdown
- images: folder with screenshots for user helps markdown
- metadata: a back-up version of tpl
- open-access: user guide written by Solène Chevalier
- transliteration : back-up for the current working version and first official release
- visual-code : user helps in markdown
- zotero : back-up for the current working version and first official release

## editorialStrylesheets
- pipelineTools: saxon 9 he (if changed, all the build files must be updated as well)
- all xslt usd in java ant task to edit compotary languages in xml : first draft  **not extremely stable**
- editorial stylesheets used for batak : first draft 

## Schema
- archives : deprecated versions
- latest : lastest versions of all relaxNG and schematron files called from XML files - must be updated each time a change in the version is made, generic calling in the files so processing-instruction mustn't be changed. 
- metadata : DTD written by Adeline Levivier to go with tpl xml files for mdt. See templates/metadata folder. 
- validationTools: tools to valid the files in travis (**deprecated**)
- version 1 for all xml schemas, relaxNG, Schematron Quick fixes and specific schematron rules. First draft made in 2019 with TEI ROMA tools. XML files are not odd since no specific documentation have been added. 
    - Critical editions : 
        - DHARMA_CritEdSchema_v01.xml : main schema for CritEd files used to created relaxNg, contains some schematron rules.
        - DHARMA_CritEdSQF_v01.sch : rules with SQF and specific checking of filenames, zotero ST ... (some rules are the same than DHARMA_SQF_v01.sch)
        - DHARMA_CritEdSchema_v01.rng : output in xml syntax
    - Diplomatic editions : 
        - DHARMA_DiplEdSchema_v01.xml : main schema for DiplEd files used to created relaxNg, contains some schematron rules.
        - DHARMA_DiplEdSchema_v01.rng : output in xml syntax
    - Inscriptions : 
        - DHARMA_SQF_v01.sch : rules with SQF and specific checking of filenames, zotero ST ... (some rules are the same than DHARMA_CritEdSQF_v01.sch)
        - DHARMA_INSSchema_v01.xml : main schema for inscriptions files used to created relaxNg, contains some schematron rules.
        - DHARMA_INSSchema_v01.rng : output in xml syntax
    - Prosody : 
        - DHARMA_ProsodySchema_v01.xml : main schema for prosody used to created relaxNg.
        - DHARMA_ProsodySchema_v01.rng : output in xml syntax
- README : explain how to use the schema with DHARMA files.

## Stylesheets
All stylesheets made for display purposes are associated to a css and a js files. Both are specific for each allowing an autonomous use, even if more difficult to keep on a long run. 
- arie :
    - arie-css.css 
    - arie-loader.css
    - arie-display.xslt : stylesheets for html display
    - arie-splitting.xslt : splitting the main source file into one file per volume
    - arie2tei.xslt : first draft - not finish to transform the xml into xml TEI.
- criticalEditions : 
    - dharma-ms.css
    - loader.js : used to resolve the large gap issue
    - nodes.md : remarks on the dev (**deprecated**, see issues on tfd-nusantara-philology)
    - cleaning-translation: xslt to extract ooxml for googleDoc into xml - **specific for Aditia's phD**.
    - start-edition.xsl : html output
    - start-txt.xsl : text output
- diplomaticEditions : 
    - dharma-diplEd-ms.css
    - loader-diplEd.js
    - start-diplEd.xsl
- ec :
    - ec-css.css
    - ec-loader.js
    - ec-display.xsl : output html for Epicagraphia Carnatica
- images : images used in the readme
- inscriptions : all the stylesheets reused from Epidoc - but not maintained in its updates from EPIDOC updates. 
- lexica-indices :
    - dcf-table_v01.xsl : table made for filling the missing part, not done by the digitaizng compagnie. 
- mdt_inscriptions :
    - mapping for textual mdt
    - mdt_CommaCleaning.xsl: cleaning all the 'COMMA' used in googleSheets, used in githubActions.
    - mdtArtefact_splitting.xsl : Splitting artefact file, runs thanks to githubActions.
    - mdtArtefact_start.xsl :  Processing for artefacts mdt, uses github api and runs thanks to githubActions.
    - mdtCollection_start.xsl : Processing for collection list, uses github api and runs thanks to githubActions.
    - mdtConglomerateArtefact_start.xsl : Processing for conglomerate artefacts mdt, uses github api and runs thanks to githubActions.
    - mdtMonument_start.xsl : Processing for monument list, uses github api and runs thanks to githubActions.
    - mdtPerson_start.xsl :  Processing for person list, uses github api and runs thanks to githubActions.
    - mdtPlace_start.xsl :  Processing for place list, uses github api and runs thanks to githubActions.
    - mdtSurrogate_splitting.xsl : Splitting surrogates file, runs thanks to githubActions.
    - mdtSurrogate_start.xsl : Processing for surrogates mdt, uses github api and runs thanks to githubActions.
    - mdtText_splitting.xsl : Splitting text file, runs thanks to githubActions.
    - mdtText_strat.xsl : Processing for text mdt, uses github api and runs thanks to githubActions.
    - mdtText-display.xsl : html display for mdt texts, used by each repository and display from erc-dharma.github.io
- mdt_-authorities :
    - Collections-start.xsl : html display for erc-dharma.github.io/
    - Monuments-start.xsl : html display for erc-dharma.github.io/
    - Persons-start.xsl : html display for erc-dharma.github.io/
    - Places-start.xsl : html display for erc-dharma.github.io/
- output : folder used to store output when generated locally.
- prosody :
    - start-edition.xsl : html display for erc-dharma.github.io/
- roej :
    - roej-css.css
    - roej-loader.js
    - roej-display.xsl : html display for erc-dharma.github.io/
- shivadharma :
    - moving-app.xsl : xst to make sivadharma file conformant to dharma rules, then criticalEditions/start-edition.xsl is used to run the output file and made a html display available on erc-dharma.github.io/
- sii : 
    - sii-css.css
    - sii-loader.js
    - sii-display.xsl : html display for erc-dharma.github.io/
- varia: some random xslt made during the project for a part of a task or for a full one, meaning some are not finished as such or can't be used alone. Some important one are explain here. 
    - DHARMA_deleteIds_v01.xsl : delete ids for tfd-nusantara when necessary
    - DHARMA_dyadNumbering_v01.xsl : numbering dyad for  tfd-nusantara
    - DHARMA_emptyingElements_trans : 
    - DHARMA_numberingCanto_v01.xsl: numbering canto for tfd-nusantara
    - DHARMA_numberingLg_v01.xsl : numbering ld for tfd-nusantara
    - DHARMA_numberingMS_v01.xsl : numbering several elements for tfd-nusantara
    - DHARMA_numberingVerse_v01.xsl : numbering verse lines
    - DHARMA_pbNumbering_v01.xsl : numbering pb element 
    - DHARMA_ROEJextractSanskrit_v01.xsl : extract sanskrit lemma for roej
    - DHARMA_termNumbering_v01.xsl: numbering term element for tfd-nusantara
- README : explain how to use the xslt with DHARMA files.

## Templates
Templates for dharma produced in the project. 

## Files
- licence.txt
- readme.md
- build.xml : run the xslt to make the html for prosody - send the output to erc-dharma.github.io repository
- DHARMA_idListMembers_v01.xml : list with all members of the project to refer to
- DHARMA_idListTexts_v01.xml : list of texts for tfd-nusantara-philology
- DHARMA_prosodicPatterns_v01 : list for prosody
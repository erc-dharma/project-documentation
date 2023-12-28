# DHARMA languages list

The file DHARMA_languages.tsv is a table that enumerates languages used in the
project. It is in the same format as the ISO 639-3 table here:
https://iso639-3.sil.org/sites/iso639-3/files/downloads/iso-639-3_Name_Index.tab

Columns are:

* Id. A three-letter language codes from ISO 639-3 or ISO 639-5. It is OK to
  invent a new language code if needed, but in this case use a string longer
  than three characters, to avoid collisions with ISO codes, and do not use
  hyphens.
* Print_Name. Example: "Old Cham".
* Inverted_Name. Like Print_Name, but used when sorting names. Example:
  "Cham, Old". Note the use of capitals.

The DHARMA database contains a full copy of the ISO 639 data. But, if you give
a different Print_Name or Inverted_Name, the value you provide will be used
instead of the ones given in the standard.

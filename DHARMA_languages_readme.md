# DHARMA languages list

The file `DHARMA_languages.tsv` is a table that enumerates languages used in the
project. The corresponding display is at https://dharmalekha.info/languages. The
table is in the same format as the ISO 639-3 table here:
https://iso639-3.sil.org/sites/iso639-3/files/downloads/iso-639-3_Name_Index.tab.

Columns are:

* `Id`. A three-letter language codes from ISO 639-3 or ISO 639-5. It is OK to
   invent a new language code if needed, but in this case you must use a string
   longer than three characters, to prevent collisions with ISO codes, and you
   must not use hyphens, because they have a special meaning in language codes.
* `Print_Name`. Example: "Old Cham". The name you use here overrides the one
   from the ISO standard. For instance, for the language code `kaw`, we use
   "Old Javanese" as `Print_Name` instead of the default "Kawi". If not given,
   the default `Print_Name` defined by the ISO standard is used instead.
* `Inverted_Name`. Like `Print_Name`, but used when sorting names, in
   particular. Example: "Cham, Old". Note the use of capitals. The value you
   provide here overrides the one from the ISO standard, as for `Print_Name`.
   If not given, the default `Inverted_Name` defined by the ISO standard is used
   instead.

ISO language codes that do not appear in the table are still recognized by the
DHARMA application. It stores a full copy of the standards' tables. The point of this table is to overwrite `Print_Name` or `Inverted_Name`.

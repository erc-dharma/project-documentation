# DHARMA languages list

The file `DHARMA_languages.tsv` is a table that enumerates languages used in the
project. The corresponding display is at https://dharmalekha.info/languages. The
table is in the same format as the ISO 639-3 table here:
https://iso639-3.sil.org/sites/iso639-3/files/downloads/iso-639-3_Name_Index.tab,
but includes an extra column.

Columns are:

* `Id`. A three-letter language codes from ISO 639-3 or ISO 639-5. It is OK to
  invent a new language code if needed, but in this case you must use a string
  longer than three characters, to prevent collisions with ISO codes, and you
  must not use hyphens, because they have a special meaning in language codes.
* `Print_Name`. Example: "Old Cham". The name you use here overrides the one
   from the ISO standard. For instance, for the language code `kaw`, we use
   "Old Javanese" as `Print_Name` instead of the default "Kawi".
* `Inverted_Name`. Like `Print_Name`, but used when sorting names, in
   particular. Example: "Cham, Old". Note the use of capitals. The value you
   provide here overrides the one from the ISO standard, as for `Print_Name`.
* `source`. This is a DHARMA-specific field, which should contain a boolean
   value viz. `true` or `false`. If this column is empty, `true` is assumed.
   Languages that have `source` set to `true` are treated as source languages by
   the DHARMA application, per contrast with translation languages (all the
   others: English, etc.) Source languages are displayed in texts' metadata and
   in data aggregations, while the others are not. This field is needed
   because translation languages do appear in our texts' `div[@type='edition']`
   (`head` elements are in English, for instance). Thus, we cannot determine
   automatically which languages are source languages and which are not.

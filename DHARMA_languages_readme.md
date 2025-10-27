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
* `type`. This is a DHARMA-specific field, which should contain either `source`
   or `study`. If this column is empty, `source` is assumed. `source` is also
   assumed for languages that are not enumerated in this table. Languages that
   have `source` are treated as source languages (e.g. Sanskrit, etc.) by the
   DHARMA application, per contrast with `study` languages (all the
   others: English, etc.). A language cannot be both a `source` language and a
   `study` language. Only `source` languages are displayed in data aggregations.

ISO language codes that do not appear in the table are still recognized by the
DHARMA application. It stores a full copy of the standards' tables.

The `type` field is needed because translation languages do appear in our
texts' `div[@type='edition']` (`head` elements are typically in English, for
instance). Thus, we cannot determine automatically which languages are source
languages and which are not.

The rationale for assuming that languages are source languages per default is
that this does not hurt much the interface and makes the problem apparent
(irrelevant languages are displayed), while by doing the reverse we might not
notice that a source language is missing, since it would not appear in the
interface.

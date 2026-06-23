# Search Help

The query syntax is similar to most search engine's.

## Matching Modes

The search system looks for substrings instead of terms. Thus, the query `edit`
matches the word "edit", but also words like "edition" or "meditation".
Furthermore, matching is case-insensitive, thus searching `Edit` or `edit`
yields the same results.

The matching behaviour is field-dependent. Take the query `mantra`, for
instance. When the system looks for this substring within the `title` field, it
will treat "mantra" or "măntra" as matches. However, when the system looks for
this substring within the `logical` field (the body of the edition), it will
also treat "manthra", "mandra" and "mandhra" as matches.

There are thus several *matching modes*, which exhibit different matching
behaviours. Currently, there are two modes, which we call `forma` and `formb`:

* The `forma` mode is the one used per default for all fields except `logical`. It preserves significant diacritical marks, but treats some of them as equivalent. For instance, "ṃ", "ṁ" and "m̐" are considered as equivalent.
* The `formb` mode is used per default when searching within the `logical` field. It ignores most diacritical marks. Thus, it treats "a" and "ā" as equivalent. Furthermore, it treats occlusives from the same group as equivalent. Thus "k", "kh", "g" and "gh" are assumed to be the same; likewise for "ṭ", "ṭh", "ḍ", "ḍh", "t", "th", "d" and "dh".

The exact behaviour of matching modes are subject to change.

You typically do not need to specify a matching mode when searching, but you can do it if you want to enforce a given behaviour. Say you want to look for the string "brāhmaṇa", treating diacritical marks as significant. For this to work, you need to choose the `forma` mode. To do so, add a `.forma` suffix to the field you want to search into. Thus, for searching in the `logical` field, you should use the following:

```
logical.forma:brāhmaṇa
```

If you want to search in all fields, but still use the `forma` mode, use the following syntax:

```
.forma:brāhmaṇa
```

This syntax works because, when you do not explicitly give a field name, it is assumed that you want to look into the field "" (the empty string).


## Phrases

When you input several words or substrings, as in the query `temple stone`, these words or substrings are treated as if they were connected with the `AND` (conjunction) operator. Thus, the query `temple stone` is strictly equivalent to the query `temple AND stone`.

If you want to search for a phrase (a sequence of words), you should surround the phrase with double quotes. For instance, the query `"Aihole temple"` will find documents that contain the substring "Aihole temple". Quotation marks are necessary, otherwise this query would be treated as `Aihole AND temple`, as explained above.

## Wildcard Queries

Strings can be literals, as in `temple`, but you can also use wildcard characters, namely `?` and `*`. The special character `?` matches exactly one character, thus the query `t?mple` would match "temple", "tample", etc. The special character `*` matches a sequence of zero or more characters, thus `t*mple` would match "temple", "tmple", "tample", etc.

Now, what constitutes a character depends on the matching mode you are using:

* For the `formb` mode (which is the default for the `logical` field), the default is to treat a phoneme as a character. Thus, if you want to find "dharmalekha", your query could be `dharmale?a`, but _not_ `dharmale??a`, since the character `?` corresponds to a single phoneme.
* For the `forma` mode, the character `?` matches a character. Thus, if you want to find "dharmalekha", your query could be `dharmale??a`, but _not_ `dharmale?a`, since "kh" is not treated as a single unit.

## Field Search

When you type a string like `Aihole`, it is searched within all fields of a document: `title`, `editor`, `summary`, etc. It is possible to restrict matching to a single field by prefixing the field name to your query, as in:

```
title:Aihole
title:"Aihole temple"
title:(Aihole temple)
```

Here are the fields you can search into.

<table>
<thead>
<tr>
<th>Field Name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>`ident`</td>
<td>File identifier (its name without the `*.xml` extension), e.g. `DHARMA_INSKalyanaCalukya01005`. A file only bears a single identifier.</td>
</tr>
<tr>
<td>`repo`</td>
<td>Git repository.</td>
</tr>
<tr>
<td>`title`</td>
<td>Title assigned to the text. A single file might be assigned several titles.</td>
</tr>
<tr>
<td>`editor`</td>
<td>Scientific editors responsible for establishing the text.
</tr>
<tr>
<td>`author`</td>
<td>Authors of the text.</td>
</tr>
<tr>
<td>`summary`</td>
<td>Abstract or analytical description synthesizing the contents of the text.</td>
</tr>
<tr>
<td>`hand`</td>
<td>Paleographical or epigraphical analysis describing the scribe's hand, the ductus, or the carving style.</td>
</tr>
<tr>
<td>`logical`</td>
<td>The body of the text, derived from its `logical` representation (the text you see when clicking on "Logical" in the display of a text).</td>
</tr>
<tr>
<td>`trans`</td>
<td>The "translation" section of the document.</td>
</tr>
<tr>
<td>`bibl`</td>
<td>The "bibliography" section of the document.</td>
</tr>
<tr>
<td>`lang`</td>
<td>Languages used in the original text.</td>
</tr>
<tr>
<td>`script`</td>
<td>Graphic system or alphabet used for noting the text.</td>
</tr>
</tbody>
</table>

The fields `repo`, `editor`, `author`, `lang` and `script` all have subfields named `ident` and `code`. When you issue a query like this:

```
repo:nusantara
```

... the search system looks up the term "nusantara" both in the repository identifier (`ident`) and in it's name (`name`). You can also restrict search to one of these subfields by using the following dot notation:

```
repo.ident:nusantara
repo.name:nusantara
```

Here is a description of these subfields:

<table>
<thead>
<tr>
<th>Field Name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>`repo`</td>
<td>`ident` is the name of the Git repository, e.g. `tfa-pallava-epigraphy`, `name` is a readable name like "Pallava Epigraphy".</td>
</tr>
<tr>
<td>`editor`, `author`</td>
<td>`ident` is a four-letter identifier like `emfr`, `name` is a full name like "Emmanuel Francis".</td>
</tr>
<tr>
<td>`lang`</td>
<td>`ident` is a three-letters ISO code like `san`, `name` is a readable name like "Old Javanese".</td>
</tr>
<tr>
<td>`script`</td>
<td>`ident` is a script identifier like `grantha`, `name` is a readable name like "Devanāgarī".</td>
</tr>
</tbody>
</table>

## Operators

Available boolean operators are `AND`, `OR`, and `NOT`. Examples:

```
Aihole AND temple
Aihole OR temple
temple NOT Aihole
NOT Aihole
```

In most search engines, `NOT` is a binary operator. Thus `foo NOT bar` really means `foo AND NOT bar`, and the query `NOT bar` is treated as invalid. In our system, however, `NOT` is a unary operator, thus `NOT bar` is valid (and returns all documents that do not match `bar`). Furthermore, given that two queries that are not bound by an explicit operator are treated as if they were bound with `AND`, the query `foo NOT bar` is interpreted as `foo AND (NOT bar)`, as in most search engines.

When using boolean operators with fields, you should be aware that the following are not equivalent:

```
editor:arlo AND editor:eko
editor:(arlo AND eko)
```

The first query matches a document if one of the editors of this document has `arlo` in his name and if the same editor or another one has `eko` in his name. Per contrast, the second query matches a document if one of its editors has both the strings `arlo` and `eko` in his name.

Here are the operators sorted by decreasing precedence: `NOT` > `AND` > `OR`. A given operator binds tighter than the ones that follow, which means that, for instance, the query `foo OR bar AND baz` is interpreted as `foo OR (bar AND baz)`.

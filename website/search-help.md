# Search Help

The query syntax is similar to most search engine's.

## Basics

Matching is case-insensitive. It looks for substrings instead of terms. For instance, the query `edit` matches "edition" or "meditation".

```
temple
```

You might also want to look for documents that contain two substrings:

```
temple stone
```

This is equivalent to `temple AND stone`.

For searching a phrase, surround it with double quotes:

```
"Aihole temple"
```

Quotation marks are necessary, otherwise the query would be treated as:

```
Aihole AND temple
```

Strings can be literals, as in `temple`, but you can also use wildcard characters, namely `?` and `*`. The special character `?` matches exactly one character, thus the query `t?mple` would matche "temple", "tample", etc. The special character `*` matches a sequence of zero or more characters, thus `t*mple` would match "temple", "tmple", "tample", etc.

What constitutes a character depends on the field you are searching into.

For the `logical` field, the default is to treat a phoneme as a character. Thus, if you want to find "dharmalekha", your query could be `dharmale?a`, but _not_ `dharmale??a`, since the character `?` corresponds to a single phoneme.

In all other fields, the character `?` matches a Unicode grapheme cluster. Thus, if you want to find "dharmalekha", your query could be `dharmale??a`, but _not_ `dharmale?a`, since "kh" is not treated as a single unit.

## Field Search

When you type a string like `Aihole`, it is searched within all fields of a document: title, editor, summary, etc. It is possible to restrict matching to a single field by prefixing the field name to your query, as in:

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

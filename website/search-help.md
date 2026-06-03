# Search Help

## Basics

The query syntax is similar to most search engine's.

For searching everywhere in a document:

```
temple
```

Matching is case-insensitive, does not take diacritics into account, and looks for substrings instead of terms. For instance, the query `edit` matches "edition" or "meditation".

You might also want to look for documents that contain two terms:

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
<td>ident</td>
<td>File identifier (its name without the `*.xml` extension), e.g. `DHARMA_INSKalyanaCalukya01005`. A file only bears a single identifier.</td>
</tr>
<tr>
<td>repo</td>
<td>Git repository.</td>
</tr>
<tr>
<td>title</td>
<td>Title assigned to the text. A single file might be assigned several titles.</td>
</tr>
<tr>
<td>editor</td>
<td>Scientific editors responsible for establishing the text.
</tr>
<tr>
<td>author</td>
<td>Authors of the text.</td>
</tr>
<tr>
<td>summary</td>
<td>Abstract or analytical description synthesizing the contents of the text.</td>
</tr>
<tr>
<td>hand</td>
<td>Paleographical or epigraphical analysis describing the scribe's hand, the ductus, or the carving style.</td>
</tr>
<tr>
<td>logical</td>
<td>The body of the text, derived from its `logical` representation (the text you see when clicking on "Logical" in the display of a text).</td>
</tr>
<tr>
<td>lang</td>
<td>Languages used in the original text.</td>
</tr>
<tr>
<td>script</td>
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

In most search engine, `NOT` is a binary operator. Thus `foo NOT bar` really means `foo AND NOT bar`, and the query `NOT bar` is treated as invalid. In our system, however, `NOT` is a unary operator, thus `NOT bar` is valid (and returns all documents that do not match `bar`). Furthermore, given that two queries that are not bound by an explicit operator are treated as if they were bound with `AND`, the query `foo NOT bar` is interpreted as `foo AND (NOT bar)`, as in most search engines.

There are also two proximity operators, which are both binary: `SEQ` and `NEAR`. The `SEQ` operator matches if both its members match and if they occur in sequence (hence the name `SEQ`) within the target field. The `NEAR` operator behaves in the same way save for the fact that its members can appear in both order. Thus, the query `a NEAR b` is strictly equivalent to `(a SEQ b) OR (b SEQ a)`.

Here are the operators sorted by decreasing precedence: `SEQ` > `NEAR` > `NOT` > `AND` > `OR`. A given operator binds tighter than the ones that follow, which means that, for instance, the query `foo SEQ bar AND baz` is interpreted as `(foo SEQ bar) AND baz`.

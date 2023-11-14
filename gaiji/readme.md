# gaiji

We use the TEI element `<g>` (gaiji) to encode symbols. The symbol name is
encoded in the `@type` attribute, as in `<g type="danda">`. Symbol names are
not constrained for now. You can introduce new ones if needed. When displaying
texts, symbols are replaced with a Unicode string or an image, if possible.
Otherwise, their name is displayed between brackets {}.

If you want to register a new symbol, you first need to edit the file
`gaiji.tsv`. You can edit it with Microsoft Excel, LibreOffice Calc, or another
spreadsheet editor. The file contains four fields:

1. `names`. This is a list of symbol names, separated with whitespace. The
   provided names are treated as aliases. By "symbol name", we mean the value
   of `g/@type` in edited texts.
2. `text`. This holds a Unicode string that should be an approximate
   textual representation of the symbol. This field is optional.
3. `prefer_text`. This field holds a boolean, either "yes" or "no". If the
   field is empty, "no" is assumed. If `prefer_text` is true, the value of the
   `text` field will always be used when displaying texts, even if an image
   representing the symbol is available.
4. `description`. A description of the symbol. This is displayed in
   tooltips. This field is optional.

Optionally, you can create an image representing the symbol. This image will be
displayed in place of the `<g>` element when rendering edited texts, unless
`prefer_text` is true, in which case the symbol's textual representation will
be used instead, and the image will be displayed somewhere else (in tooltips
and in symbols table, a priori).

The image must be placed in the `/images` directory (at the root of it, not in
subdirectories). It will be picked up automatically by the DHARMA application.
The SVG format is preferred, because it allowes images to scale to arbitrary
sizes, and because it is possible to change the image color mechanically (this
would be useful for reverse video display). PNG and JPG images can also be
used.

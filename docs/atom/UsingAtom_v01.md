# Using Atom to encode XML files

Written by Axelle Janiak, version 1 (2020-05-14)

****

If you want to use [Atom](https://atom.io/) to edit XML files, you will need to add new packages that are not among the core packages that you get by default while installing the editor.

## Installing
Once you have installed Atom, go in your toolbar to the `settings` or `Atom > preferences...`, depending on your computer. In the opening settings, go to the tab  `+install` at the bottom of the left panel.

![install tag](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtom01.png)

Search the name of packages, see the list of possibilities in the following sections. Once it has found the package, click on install and agree to each dependency installation request.

![search and install a package](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtom02.png)

It is also possible to install the packages from the Atom website.
![install from a website](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtom03.png)

## Necessary packages to encode
You will need the following packages to be able to work:
- [linter-autocomplete-jing](https://atom.io/packages/linter-autocomplete-jing) in order to validate and get schema support. Please note that the package needs **Java (Java Runtime Environment (JRE) v1.6 or above)** to be installed on your computer as well as the additional packages: busy-signal, intentions, linter and linter-ui-default. All those dependencies should be installed for you by default by linter-autocomplete-jing, while Java can be download from [here](https://www.java.com/fr/).
You might get error messages, but it will still work. It might be necessary to restart the editor.  
If the installation have been successful, you will have a bottom toolbar that shows, at the left, after the path of the file, the linter info.  
![location of the linter infos](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtom04.png)

## Optional packages to encode
- [wrap-in-tag](https://atom.io/packages/atom-wrap-in-tag) a very simple package allowing you to wrap tags around the text, like the `surroundings with tags...` function of Oxygen. To use it: just select a word or phrase and hit `Alt + Shift + w` or right click and select `Wrap in tag` in the menu.

![Use from the right Click](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtom05.png)

 This will insert `<p>...</p>` around the selected text. You can then write the name of the tag you want in stead of `<p>` and make use of autocomplete.

- [select-text-between-tags](https://atom.io/packages/select-text-between-tags) this package allows you to select all the text between two tags.

- [double-tag](https://atom.io/packages/double-tag) edit one tag and the other is automatically changed to match.

- [tag](https://atom.io/packages/tag) automatically closes your tags.

- [atom-beautify](https://atom.io/packages/atom-beautify) automatically indents your markup.

## Optional packages for Academic writing
- [pdf-view](https://atom.io/packages/pdf-view) add a support to open PDF in Atom, so you don't have to open a new tool while working.

- [zotero-citations](https://atom.io/packages/zotero-citations) adds Zotero support to Atom Markdown editing. To use it, you will need to have the Better BibTeX plugin installed in Zotero.

- [zotero-picker](https://atom.io/packages/zotero-picker) needs Better BibTeX plugin installed in Zotero, insert your citations if you write your research papers in markdown.

- [linter-retextjs](https://atom.io/packages/linter-retextjs) natural language processor that includes plugins to check for bad prose. It uses the Retext dependencies.

- [highlight-selected](https://atom.io/packages/highlight-selected) find duplicates and see where you used certain words too often.

- [wordcount](https://atom.io/packages/wordcount) help you counting words.

- [typewriter](https://atom.io/packages/typewriter) to have a better layout.

## Optional packages for Latex convinced
- [language-latex](https://atom.io/packages/language-latex) for syntax highlighting.

- [latex](https://atom.io/packages/latex) to compile the .tex files.

## Known Issues related to packages
- The package “copy-with-style” : ABCextended keyboard in Atom no longer seems to allow putting macron-marks over the long vowels. Some problems are also known with EasyUnicode keyboard.

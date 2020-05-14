# Using Atom to encode XML files

Written by Axelle Janiak, version 1 (2020-05-14)

****

If you want to use [Atom](https://atom.io/) to edit XML files. You will need to add new packages not in the core packages set by default while installing the editor.

## Installing
Once you have installed Atom, go to the `settings` or `preferences` depending your computer in your toolbar. In the opening settings, go to the tab  `+install` on the left panel and search the name of packages. Once it has found the package. Click on install and agree to each dependency installation request.

It is also possible to install the packages from the Atom website.

## Necessary packages

You will need the following packages to be able to work:
- [linter-autocomplete-jing](https://atom.io/packages/linter-autocomplete-jing) in order to validate and get schema support. Please note that the package need Java to be installed on your computer as well as the additional packages: busy-signal, intentions, linter and linter-ui-default. All those dependencies should be installed for you by default by linter-autocomplete-jing.
You might get errors messages, but it will still work. It might be necessary to restart the editor. If the installation have been successful, you will have the bottom toolbar, at the left the litter info, after the path of the file.
![location of the linter infor](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtom01.png)

## Optional packages
- [wrap-in-tag](https://atom.io/packages/atom-wrap-in-tag) a very simple package allowing you to wrap tags around the text, like the `surroundings with tags...` function of Oxygen.
- [select-text-between-tags](https://atom.io/packages/select-text-between-tags)this package allows you to select all the text between two tags.

# DHARMA project: Guide to master Markdown.
March 2020

## Introduction

This file sums up basic writing and formatting syntax for Markdown. Each feature is described with its code followed by its rendering.
Use the following table to navigate inside the file:

*   [headings](#Headings)
*   [Making Paragraphs](#MakingParagraphs)
*   [Creating new lines](#CreatingLines)
*   [Styling the text](#StylingText)
*   [Quoting Text](#QuotingText)
    * [Simple Quote](#SimpleQuote)
    * [Blockquote](#Blockquote)
*   [Code Blocks](#CodeBlocks)
    * [Inline code](#InlineCode)
    * [Block code](#BlockCode)    
*   [Lists](#Lists)
    * [Unordered List](#Unordered)
    * [Ordered List](#Ordered)
    * [Nested List](#Nested)
    * [Task List](#Task)
*   [Horizontal Rules](#HorizontalRules)
*   [Tables](#Tables)
*   [Links](#Links)
*   [Mentioning Person and Team](#Mentioning)
    * [Person](#Person)
    * [Team](#Team)
*   [Escaping symbols in Markdown](#Escaping)


### Headings
You can add one to six `#` symbols before your headings. Their numbers determine size of their display.

```
# The first heading
## The second heading
### the third heading
```
# The first heading
## The second heading
### the third heading

### Making Paragraphs
To create a new paragraph, you can simple leave an empty line. Note that starting at a new line doesn't create a new paragraph.

```
paragraph 1
and new line

paragraph 2
```
paragraph 1
and new line

paragraph 2

### Creating new lines
To create a new line, use two spaces where you want the new line to begin.
```
paragraph 1  and new line
```
paragraph 1  
and new line

### Styling the text
Bold: `** **`
```
**This is bold text**
```
**This is bold text**


Italic: `* *`
```
*This is italicized text*
```
*This is italicized text*


Bold and nested italic: `** **`and `_ _`  
```
**This is bold text and** _this is italic_
```
**This is bold text and _this is italic_**


All bold and italic: `*** ***`
```
***This is bold italic text***
```
***This is bold italic text***

Striketrough: `~~ ~~`
```
~~This is striketrough~~
```
~~This is striketrough~~

### Quoting Text
#### Simple Quote
Use `>` at the beginning of a line to make a quote
```
> Hello World!
```
>Hello World!

#### Blockquote
To make a block, repeat `>` at the beginning of all the lines of the block. Any markup can be used inside a block. To put a code block within a list item, the code block needs to be indented twice — 8 spaces or two tabs:
```
> ## This is a header.
>
> 1.   This is the first list item.
> 2.   This is the second list item.
>
>> Here's some example of nested quote and code:
>
>     return shell_exec("echo $input | $markdown_script");
```
> ## This is a header.
>
> 1.   This is the first list item.
> 2.   This is the second list item.
>
>> Here's some example of nested quote and code:
>
>     return shell_exec("echo $input | $markdown_script");

#### Code Blocks
#### Inline code
To quote code you can use backticks \` \` inside a sentence.
```
Use `<teiHeader>`
```
Use `<teiHeader>`

#### Block code
For lenghtier code, use triple backticks \`\`\`  \`\`\` or ident the code
```
Some basic Git commands are:
git status
git add
git commit
```

### Lists
#### Unordered List
You can do unordered list using `-`, `*`, `+` interchangebly.
```
+ Pallava
- Tirunallaru
* Melappaluvur
```
+ Pallava
- Tirunallaru
* Melappaluvur

#### Ordered List
To order then, use numbers at the beginning of the line. Note that the number doesn't matter. See the following example with the repeated 2.
```
1. Pallava
2. Tirunallaru
2. Melappaluvur
```
1. Pallava
2. Tirunallaru
2. Melappaluvur

#### Nested list
To nest list, indent the line before using ordered and unordered systems. Several level of list can be nested as long as the ident is made.
```
1. TFA
  * Pallava
  + Tirunallaru
  - Melappaluvur
```
1. TFA
  * Pallava
  + Tirunallaru
  - Melappaluvur

#### Task list
Any task list begins with `- []` to make an empty box and with `- [x]` to make a checked box.
```
- [x] Finish my changes
- [ ] Push my commits to GitHub
- [ ] Open a pull request
```
- [x] Finish my changes
- [ ] Push my commits to GitHub
- [ ] Open a pull request

### Horizontal Rules
You can produce a horizontal rule by placing three or more hyphens, asterisks, or underscores on a line by themselves. If you wish, you may use spaces between the hyphens or asterisks. Each of the following lines will produce a horizontal rule:
```
---
* * *
----------------------
```
---
* * *
----------------------

### Tables
You can create table in markdown by using pipes to separate the columns. You can create a header by using hyphens to distinguish it.
```
First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column
```
First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column

### Links
You can create an inline link by wrapping link text in brackets `[ ]`, and then wrapping the URL in parentheses ( ).
```
This is the [link](https://dharma.hypotheses.org/) to our hypotheses website
```
This is the [link](https://dharma.hypotheses.org/) to our hypotheses website

You can also use this method to mention files inside the repository but replace the URL with the file path.
```
This guide completes the [issue tracker guide](UsingGitIssueTracker.pdf)
```
This guide completes the [issue tracker guide](UsingGitIssueTracker.pdf)




### Mentioning person and team
#### Person
In any of your issue, you can mentioned person using `@` and adding their ID after it: `@PersonID`. Autocompletion will make proposal for the id while your typing.
The person will received a notification of being mentioned. It can be useful, if you have a task or a question from them.
```
@manufrancis
```

#### Team
You can also use it with teams. In this case, it begins with the `@` followed by the organization name and the team name:  `@OrganizationName/TeamName`
```
@erc-dharma/task-force-a
```


### Escaping symbols in Markdown
If you want to display any symbol used as markup in a Markdown file, you can escape it with a backslash `/`.
```
 /- This is not a list

```
 /- This is not a list

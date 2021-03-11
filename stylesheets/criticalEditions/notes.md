# Notes regarding the Development for MS

| Subject | Current implementation| Updates |
|--|--|--|
|Hover on the lemma when mouseover the symbol of the apparatus entry at the end of the line| Made with CSS `.tooltipApp:hover ~ .lem{background-color: yellow;}` working thanks to a parent-containter `<span class="lem-tooltipApp">`| Once encodings are stabilized should be moved as a javascript feature|
|witDetail|Display the witDetail/@type at the end of the witnesses| Must add a matching working with the tokenization of the @wit. Adding a modal template probably - need to think about this though|

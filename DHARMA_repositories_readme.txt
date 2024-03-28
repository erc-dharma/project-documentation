# DHARMA Repositories List

The file `DHARMA_repositories.tsv` enumerates Github repositories the dharma
application should keep track of. This list of repositories is displayed at
https://dharmalekha.info/repositories. It is automatically picked up by the
dharma application whenever the `project-documentation` repository is updated.

DHARMA repositories that do not appear in this list are ignored by the
application.

The `textual` column is a boolean that tells the dharma application whether it
should try to find TEI editions in the corresponding repository. If it is
`false`, the application will update its clone of the repository, but will not
to try to find edited texts into it. You should set it to `true` if you are not
sure about the purpose of the repository. Setting it to `false` is just an
optimization.

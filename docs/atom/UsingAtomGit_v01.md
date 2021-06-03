# Using Git from within Atom

Written by Axelle Janiak, version 1 (2020-05-14)

****
## Starting
Git and Github are integrated into Atom as part of the core package.
You can open the panel from the tool bar: `Packages -> GitHub -> Toggle Git Tab` and `Toggle GitHub Tab`.
Or you can access both panels from the status bar at the bottom right of the editor by clicking on the relevant icon.

## Clone a repository
On the GitHub panel, select `Clone an existing GitHub repository ...`

![Clone](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomGit01.png)

In the dialog box, paste the URL of a repository. Check the directory path to be sure that it will be located where you expect it on your computer and then click "Clone".
The new project will be added to the Tree View.
**Please note that this part works as a new clone. The system will refuse adding it in a folder, if a previous version has already been cloned inside it.**
![Cloning](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomGit02.png)

## Staging files
Once you have worked on a file and saved it, stage anything you want to be part of the next commit thanks to the git left panel.
Choose between staging...

- All changes: Click the `Stage All` button in the `Unstaged Changes` bar.
- Files: Double-click a file or select a file and press Enter.
![Staging](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomGit03.png)

## Commit changes
If you click on `See All Staged Changes` button above the commit message box, you can double check your changes. It lets you see all of your staged changes in a single pane.

Then enter a commit message and click on the `Commit to master` button.

![Commit](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomGit04.png)

To add co-authors to a commit, click the `👤➕` icon in the bottom left corner of the commit message editor. You can search by name or GitHub username.

![Add co-authors](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomGit05.png)

## Push
To push your changes click on the `Push` icon in the status bar at the right bottom corner of the editor. It can be named `Publish` if the system hasn't identified any commit yet. 
![Push](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomGit06.png)

## Pull
To pull changes made by others, click on the `Pull` icon in the status bar. It can be named `Fetch` if the system hasn't identified any changes yet.

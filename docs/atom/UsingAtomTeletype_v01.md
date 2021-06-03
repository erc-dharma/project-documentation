# Using Atom Teletype to encode XML files

Written by Axelle Janiak, version 1 (2020-05-14)

****
If you need to collaborate in real time on the encoding of a file with others, it can be useful to use the teletype tool of the Atom editor.
Before following this procedure, see the previous guide to [install Atom](https://github.com/erc-dharma/project-documentation/blob/master/guides/atom/UsingAtom_v01.md).

## Install Teletype for Atom
Go in your toolbar to the `settings` or `Atom > preferences...`, depending your computer. In the opening settings, go to the tab  `+install` at the bottom of the left panel.
 Search for `teletype` and click on the `install` button.

 Or install Teletype with the following link:
[atom://settings-view/show-package?package=teletype](atom://settings-view/show-package?package=teletype) and click `Open Atom` in the box that pops up.

## Share a portal
Click on the antenna icon in the Atom status bar at the bottom right of the Editor.
![Antenna icon](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype01.png)

You’ll be prompted with the message in the picture on the left telling you to go to [teletype.atom.io/login](teletype.atom.io/login).
![Login](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype02.png)

There, you will be given a unique token to input into Atom. Note that this operation has to be done only once.
![Token](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype03.png)

Sign in with your token, if you are the host of the collaboration. Slide the switch to start sharing a portal to your workspace.
![Share](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype04.png)

Then invite people to join your portal by sending them your portal URL.
![Invite people](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype05.png)

## Join a portal
Once someone has provided you with a link to their portal, click on the antenna icon in the Atom status bar at the bottom right of the Editor.
![Antenna icon](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype01.png)

You click on `Join Portal` and enter the link that the host just sent.
![Join Portal](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype06.png)
![Add the link](https://github.com/erc-dharma/project-documentation/blob/master/guides/images/UsingAtomTeletype07.png)

The portal opens and all collaborators can edit together in real time.
An avatar for each collaborator connected will appear on the right side of the screen. If you click one, you will then be following the person's work.

## Ending a session
Once the collaborative working session is done. The **host must save the changes, stage, commit and push them on GitHub**, otherwise the work won't be stored and shared on DHARMA repositories. To do so, you can use your usual tool or operate with the git and GitHub possibilities provided by Atom. See the [Git and Atom Guide](https://github.com/erc-dharma/project-documentation/blob/master/guides/atom/UsingAtomGit_v01.md) to know more about it.   

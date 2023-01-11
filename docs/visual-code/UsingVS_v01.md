# Using Visual Studio Code to encode XML files

Written by Axelle Janiak, version 1 (2022-01-11), sump up from [Visual Code documentation](https://code.visualstudio.com/docs).

****

If you want to use [Visual Studio Code](https://code.visualstudio.com/Download/) to edit XML files, you will need to add packages that are not among the core packages that you get by default while installing the editor.

## Install packages
Once you have installed Visual Studio Code, go in your toolbar to the `settings` or `preferences...`, depending on your computer, and select `extensions`. In the opening tab, search for:
- Scholarly XML written by Raffazizzi to install a relaxNg validation: https://marketplace.visualstudio.com/items?itemName=raffazizzi.sxml
- XML Tools written by Josh Johnson to access useful encoding tools: https://marketplace.visualstudio.com/items?itemName=DotJoshJohnson.xml

Search the name of packages, see the list of possibilities in the following sections. Once it has found the package, click on install and agree to each dependency installation request.
With the links, you can also install the packages directly from Visual Studio Market Place.

## Collaboration
If you need to collaborate in real time on the encoding of a file with others, it can be useful to use the Live Share tool.

### Install packages for Live Share
go in your toolbar to the `settings` or `preferences...`, depending on your computer, and select `extensions`. In the opening tab, search for:
- Live Share: https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare 
- Live Share Audio: https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare-audio 
- Live Share Extension pack: https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare-pack

With the links, you can also install the packages directly from Visual Studio Market Place.

Wait for the extension to finish downloading and then reload VS Code when prompted. Wait for Visual Studio Live Share to finish installing dependencies.
Once done, Live Share icon, arrow above a circle, will appear in the status bar – bottom left corner bar- and in the left side bar.

### Share a portal
Click on the Live Share icon in the left side bar or the left bottom bar.
![Live Share Icon](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS01.png)

You'll be asked to sign in the first time you share (using a GitHub or Microsoft account), also identifying you when working. For microsoft, you may need to allow the opening of a firewall port. 

A unique session URL will be copied to you clipboard. Send it to your coworkers. All they will have to do is click on it to get started.
![Sending a link](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS02.png)

Once they are connected, you will receive a notification and see their cursor appearing in your opened files. They will be able to follow all your actions in the editor. 

### Adding the audio to a session
Open the live share Session details panel, by clicking on the left side icon. 
![Live Share panel](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS03.png)

Then, click on Start audio call.
![Start Audio Call](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS04.png)

When you are connected, you will see your name under Audio Call Participants. To mute/unmute yourself, click the speaker button to the right of your name.

When guests join your session, they'll be prompted to join the active call. 
![Join Audio Call](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS05.png)

If at any time you need to configure you microphone or speakers, click the gear button to the right of the Audio Call Participants.
![Settings](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS06.png)

### Join a portal
Once you have installed all the packages, joining a session only requires a link.
After receiving a link from a coworker, click on it. This will open a web browser. Allow it to launch the session direclty in Visual Studio Code.
You will be asked to sign in, during your first session with a GitHub or Microsoft account.

Then you can see the host's file. 

### Joining an audio session
When joining a session, you'll be prompted to join the active call, but you can choose to always join calls.
![Join Audio Call](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS05.png)

If at any time you need to configure you microphone or speakers, click the gear button to the right of the Audio Call Participants.
![Settings](https://github.com/erc-dharma/project-documentation/blob/master/docs/images/VS06.png)

### Ending a session
Once the collaborative working session is done. The **host must save the changes, stage, commit and push them on GitHub**, otherwise the work won't be stored and shared on DHARMA repositories. To do so, you can use your usual tool or operate with the git and GitHub possibilities provided by Visual Code. 

## Source Control with Git
Visual Studio Code includes git support. The Source Control icon is the Activity Bar - left side bar. 
Selecting the icon will show you the details of your current repository changes: CHANGES, STAGED CHANGES and MERGE CHANGES.

Clicking each item will show you in detail the textual changes within each file. 

### Commit 
Staging (git add) and unstaging (git reset) can be done via contextual actions in the files or by drag-and-drop.
Write a commit message in the top box and press `Ctrl` + `Enter` in Microsoft or `command` + `Enter`. 
# DHARMA Stylesheets Documentation

DHARMA Stylesheets adapted from Epidoc Stylesheets.

## How to use the XSLT
- Go `Document>Transformation>Configure Transformation Scenarios...` or click on the `Configure Transformation Scenarios` in the tools bar
![Configure transformation scenario](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario01.png)
- Create a new Scenario. ![Click on new](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario02.png)
- Select `XML transformation with XSLT`![Click on XML transformation with XSLT](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario03.png)
- In the XSLT tab
  - You can choose any name you want but use something clear enough not to confuse it with other stylesheets we might add later for the project.
    - set the value in XML URL as `${currentFileURL}` and in the XSL URL set the path toward  `*[write the path depending the set up of your computer]*/project-documentation/stylesheets/inscriptions/start-edition.xsl` ![Parameters to transformation a file](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario04.png)
    - Select `Saxon-PE 9.9.1.5` as a Transformer.![Select a transformateur](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario04.png)
- In the Output tab
    - click on `save as` and set a value for the folder path.
      - you can choose a folder of your choice and finish it by `/${cfn}${date(yyyy-MM-dd)}.html`. However, for the CSS to work on your html, you will need to copy the [global.css](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/inscriptions/global.css) file inside this folder.![Parameters the output file](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario05.png)
      - That's why, we recommend saving your html output inside the inscriptions folder, so `*[write the path depending the set up of your computer]*/project-documentation/stylesheets/inscriptions/output/${cfn}${date(yyyy-MM-dd)}.html`, this way you won't have to bother yourself with moving the CSS file around. Note that the repository have been set up so that all HTML outputs will be ignored by versioning. It means you won't be able to push them in the project-documentation repository. If you need another set up in order to share with your Task Force the output, feel free to contact us.  
    - The file will be save with the file name followed by the date and a html extension. Click on `Òpen in Browser/System Application` and on `Saved file` under it. ![Parameters the output file](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario06.png)
- To launch the transformation, open the file you want to transform and click on the `Apply the Transformation(s) scenario(s)` button.![Run the transformation](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario07.png)

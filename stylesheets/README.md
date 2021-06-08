# DHARMA Stylesheets Documentation

Before starting, you must clone the project-documentation repository in order to have a version of the Stylesheets on your computer. Remember to regularly update it to access the latest version of the codes. 

## How to use the XSLT for inscriptions
- Go `Document>Transformation>Configure Transformation Scenarios...` or click on the `Configure Transformation Scenarios` in the tools bar
![Configure transformation scenario](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario01.png)
- Create a new Scenario. ![Click on new](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario02.png)
- Select `XML transformation with XSLT`![Click on XML transformation with XSLT](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario03.png)
- In the XSLT tab
  - You can choose any name you want but use something clear enough not to confuse it with other stylesheets we might add later for the project. Note that a default name will be given from one of your opened XML files.
    - set the value in XML URL field  as `${currentFileURL}` and in the XSL URL set the path toward  `*[write the path depending the set up of your computer]*/project-documentation/stylesheets/inscriptions/start-edition.xsl` ![Parameters to transformation a file](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario04.png). *Please note that there is another launching file `start-edition-with-bibl.xsl`, it can be used only if your bibliographical data are stabilized in Zotero, otherwise you will get an error message from the transformer : "Premature end of file".*
    - We recommend as a Transformer  `Saxon-PE` in the version you have available in your Oxygen. It is the Professional edition of the processor, but the HE or EE will also work just fine for the transformation we are doing here. ![Select a transformateur](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario04.png).
      - If you are still working with a previous version of Oxygen:
          - check if your licence key allows you to update it. If yes, do it.
          - Otherwise, we recommend you at least update the Saxon processor to its 9.9 version. **See below how to do both procedures.**
          - The Epidoc stylesheets have been tested with Saxon 9.6, so you will be able to transform your XML with any higher version.
- In the Output tab
    - click on `save as` and set a value for the folder path.
    - You can choose anywhere you want on your computer. However if you want to store it in a repository, please add a folder `output`, so `*[write the path depending the set up of your computer]*/output/${cfn}${date(yyyy-MM-dd)}.html`.
    We also recommend your named the output with the variable allowed by Oxygen. Select the current filename without extension `${cfn}`, then add the variable of date `${date(yyyy-MM-dd)}` and finally add the extension `.html`. Thanks to those variables, we will be able to identify the file as well as its output version.
    - Click on `Òpen in Browser/System Application` and on `Saved file` under it. ![Parameters the output file](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario06.png)
- To launch the transformation, open the file you want to transform and click on the `Apply the Transformation(s) scenario(s)` button.![Run the transformation](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario07.png)

## How to use the XSLT for critical editions
- Go `Document>Transformation>Configure Transformation Scenarios...` or click on the `Configure Transformation Scenarios` in the tools bar
- Create a new Scenario.
- Select `XML transformation with XSLT`
  - You can choose any name you want but use something clear enough not to confuse it with other stylesheets we might add later for the project.
    - set the value in XML URL as `${currentFileURL}` and in the XSL URL set the path toward  `*[write the path depending the set up of your computer]*/project-documentation/stylesheets/criticalEditions/start-edition.xsl`
    - We recommend as a Transformer  `Saxon-PE` in the version you have available in your Oxygen. It is the Professional edition of the processor, but the HE or EE will also work just fine for the transformation we are doing here.
- In the Output tab
    - click on `save as` and set a value for the folder path.
      - You can choose anywhere you want on your computer. However if you want to store it in a repository, please add a folder `output`, so `*[write the path depending the set up of your computer]*/output/${cfn}${date(yyyy-MM-dd)}.html`.
      We also recommend your named the output with the variable allowed by Oxygen. Select the current filename without extension `${cfn}`, then add the variable of date `${date(yyyy-MM-dd)}` and finally add the extension `.html`. Thanks to those variables, we will be able to identify the file as well as its output version.
    - The file will be saved with the file name followed by the date and a html extension. Click on `Òpen in Browser/System Application` and on `Saved file` under it. ![Parameters the output file](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario06.png)
- To launch the transformation, open the file you want to transform and click on the `Apply the Transformation(s) scenario(s)` button.![Run the transformation](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario07.png)

## Updating your Oxygen Editor
The possibility to update your editor depends on the licence key. To check it, go to  `Help>Check for a new version` ![Select the check for a new version](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario08.png)
A new window will open. Telling you if a new release is available. Check for the following remark "**Your current license key can be used with this release.**".
- if you have it, click on the Download version link and click on the download button. Install if as you would for any other software.
Do not keep files from the previous version. Your user-specific add-ons or settings are kept in a separate folder in your user home directory. So it will be reimported.

## Updating your Saxon processor
- Go `Help>Install new add-ons...` in the tools bar.
![install add-ons](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario09.png)
- In the opening contextual window, select `-- All Available Sites --` in menu `Show add-ons from`. You can tick the box `show only compatible add-ons` at the bottom to help you select find the right version.
- Fetch the `Saxon 9.9 XSLT and XQuery Transformer` and select it.
- Click on the `next` button.
![Choose Saxon 9.9](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario10.png)
- The extension is dowloaded. You must accept the terms of licence at the bottom of the window and then click on the `install` button.
![install Saxon 9.9](https://github.com/erc-dharma/project-documentation/blob/master/stylesheets/images/transformationScenario11.png)
- Restart the application.
- To set Saxon 9.9 as the default XSLT validation engine for your validation scenario, go to `Document>Transformation>Configure Transformation Scenarios...` or click on the `Configure Transformation Scenarios` in the tools bar.
- Select the DHARMA scenario, if you have already created it and click on the `Edit` button.
- In the XSLT Tab, in the menu for the transformer, select the `Saxon-EE 9.9.1.6 (External)`. As an add-ons, you might not have the choice between the editions.

## Some basics to understand the Saxon Editions
For each release, Saxon comes with three editions: EE, HE and PE. Some basics about their status is given here.
- The Home Edition (HE) and Professional Edition (PE) implement the basic conformance level for XSLT 2.0 / 3.0 and XQuery 1.0 as defined in the specifications. It is a conformance level that requires support for all features of the language other than those that involve schema processing. The HE product remains open source, but removes some of the more advanced features that are present in Saxon-PE.
- Saxon Enterprise Edition (EE) is the schema-aware edition of Saxon and it is one of the built-in processors included in Oxygen XML Editor. Saxon EE includes an XML Schema processor following the XML Schema 1.0 and 1.1 specifications, and schema-aware XSLT, XQuery, and XPath processors.
- Technically, there is also the CE edition, but it works for web browser and is usually used by IT purposes.

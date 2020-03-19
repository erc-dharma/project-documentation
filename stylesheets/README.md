# DHARMA Stylesheets Documentation

Campa Epidoc Stylesheets initially adapted from Epidoc Stylesheets by Tom Elliot.

## How to use the XSLT
- Go `Document>Transformation>Configure Transformation Scenarios...` or click on the `Configure Transformation Scenarios` in the tools bar
![Configure transformation scenario]()
- Create a new Scenario. You can choose any name you want but use something clear enough not to confuse it with other stylesheets we might add later for the project.
- In the XSLT tab, set the value in XML URL as `${currentFileURL}` and in the XSL URL set the path toward  `*[write the path depending the set up of your computer]*/project-documentation/stylesheets/start-edition.xsl` Select `Saxon-PE 9.9.1.5` as a Transformer.
- In the Output tab, click on `save as` and set its value with the folder path of your choice and finish it by `/${cfn}${date(yyyy-MM-dd)}.html`. The file will be save with the file name followed by the date and a html extension. Click on `Òpen in Browser/System Application` and on `Saved file` under it.
- To launch the transformation, open the file you want to transform and click on the `Apply the Transformation(s) scenario(s)` button.

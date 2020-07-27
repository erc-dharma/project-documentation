# How to use the DHARMA XMLSchema

## Parameters with Oxygen
In  `preferences`, go to `XML -> Schematron`.
in the *Schematron 1.5* part, choose `2.0` as Xpath version to use the schemas to their full extent.

## Linking your XML with a Schema
It is possible to link your XML with any schema. You can use several ways to do so. All the following solutions can be combined. We recommend having the online official schema in the processing instructions and any other schema you wished declare with the project options of Oxygen.

### Declaring your schema in the processing instructions.
You can declare your schema in the processing instructions of your XML. Those follow to XML statement at the beginning of each xml
```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="https://raw.githubusercontent.com/erc-dharma/project-documentation/master/schema/latest/DHARMA_Schema.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="https://raw.githubusercontent.com/erc-dharma/project-documentation/master/schema/latest/DHARMA_Schema.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
```
In the `@href` attribute, you can provide the url for the DHARMA or Epidoc Schema stored on line:
- (Epidoc Schema)[http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng]  
- (DHARMA Schema)[https://raw.githubusercontent.com/erc-dharma/project-documentation/master/schema/latest/DHARMA_Schema.rng]

You can also provide the path from your file toward the schema, if you have a version on your computer. We don't recommend this solution in the processing instructions, but it can be done nonetheless. A path is built with the files and folders names, as you would do while navigating in your folders with the computer terminal.

### Declaring a schema with Oxygen
We recommend setting this feature when you have a low or none internet access.
First, make sure you have a version of the (project-documentation repository)[https://github.com/erc-dharma/project-documentation] Go to `Document -> Validate -> Configure Validation Scenario(s)...`.
- Click on `new`.
- Provide a new for the field `Name` at the top of the new window.
- On the main pane, verify the `URL of the file to validate` is set on `${currentFileURL}`. The `File Type` must be on XML Document. Keep the `<Default  engine>` and check the automatic validation.
- Then, click on `Specify schema` at the end of the line. Choose . `Use a custom schema` and go fetch the schema in the pulled version of the project documentation. Choose the Relax NG schema provided in the latest folder: `project-documentation/schema/latest/DHARMA_Schema.rng`. The Schema type should by default be set on `RELAX NG XML syntax`. To finish, check the box for `Embedded Schematron rules`. Click on the `OK` button.
- Once this setting have been done, you will be able to reuse it every time you need it. To make it run, click on the , `Apply associated (1)`, after selecting the schema in the list. Note that once you have make it run through this panel once in your session, you can launch it as usual with the basic validate function.

## Schemas versions
Note that Epidoc and DHARMA relax NG have a generic name so that you don't have to make any changes to your settings or processing instructions when the schema is updated. You will have to do a git pull though, if you are validating locally rather than on the online schema.
You will be able to access all versions in RNG and ODD (here)[https://github.com/erc-dharma/project-documentation/tree/master/schema]. Note that the schematron will always be embedded to reduce the number of files and make the validation process easier.

## Understanding Validation Issues message
Be aware that the validation issues regarding the mai 

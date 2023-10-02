names = Schema BESTOW CritEdSchema DiplEDSchema ProsodySchema
schemas = $(addsuffix .rng,$(addprefix latest/DHARMA_,$(names)))

all: $(schemas)

latest/DHARMA_Schema.rng: DHARMA_INSSchema_v01.xml
	curl -F fileToConvert=@$^ https://teigarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng > tmp && mv tmp $@

latest/DHARMA_BESTOW.rng: DHARMA_BESTOW_v01.xml
	curl -F fileToConvert=@$^ https://teigarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng > tmp && mv tmp $@

latest/DHARMA_CritEdSchema.rng: DHARMA_CritEdSchema_v02.xml
	curl -F fileToConvert=@$^ https://teigarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng > tmp && mv tmp $@

latest/DHARMA_DiplEDSchema.rng: DHARMA_DiplEDSchema_v01.xml
	curl -F fileToConvert=@$^ https://teigarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng > tmp && mv tmp $@

latest/DHARMA_ProsodySchema.rng: DHARMA_ProsodySchema_v01.xml
	curl -F fileToConvert=@$^ https://teigarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng > tmp && mv tmp $@

%.rnc: %.rng
	java -jar validationTools/trang.jar $^ $@

clean:
	rm -f $(schemas)

.PHONY: all clean

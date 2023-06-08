schemas = Schema BESTOW CritEdSchema DiplEDSchema ProsodySchema

all: $(addsuffix .rng,$(addprefix latest/DHARMA_,$(schemas)))

%.rng: %.xml
	curl -F fileToConvert=@$^ https://teigarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng > tmp && mv tmp $@

latest/DHARMA_Schema.rng: DHARMA_INSSchema_v01.rng
	cp $^ $@

latest/DHARMA_BESTOW.rng: DHARMA_BESTOW_v01.rng
	cp $^ $@

latest/DHARMA_CritEdSchema.rng: DHARMA_CritEdSchema_v02.rng
	cp $^ $@

latest/DHARMA_DiplEDSchema.rng: DHARMA_DiplEDSchema_v01.rng
	cp $^ $@

latest/DHARMA_ProsodySchema.rng: DHARMA_ProsodySchema_v01.xml
	cp $^ $@

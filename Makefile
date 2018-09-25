all: deployado

.PHONY: all deployado

deployado:
	cp binipolate.ado /usr/local/ado/
	cp binipolate.sthlp /usr/local/ado/

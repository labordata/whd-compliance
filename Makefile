whisard.db : cases.csv violations.csv
	sqlite-utils insert $@ cases cases.csv --csv --empty-null
	sqlite-utils insert $@ violations violations.csv --csv --empty-null
	sqlite-utils transform $@ cases --pk case_id
	sqlite-utils transform $@ violations --pk id
	sqlite-utils add-foreign-key $@ violations case_id cases case_id
	cat scripts/flsa_details.sql | sqlite3 $@
	sqlite-utils add-foreign-key $@ flsa_details violation_id violations id

violations.csv : whisard.csv
	cat $< | python scripts/violations.py > $@

cases.csv : whisard.csv
	cat $< | python scripts/cases.py > $@

whisard.csv : WHD_enforcement.zip
	unzip -o $<
	csvstack `zipinfo -1 $<` | python -c "import sys; header=next(sys.stdin); sys.stdout.write(header.lower()); sys.stdout.writelines(sys.stdin)" > $@
	rm -f `zipinfo -1 $<`

WHD_enforcement.zip :
	curl -L -o $@ 'https://data.dol.gov/data-catalog/WHD/enforcement/WHD_enforcement.zip'

whisard.db : cases.csv violations.csv
	csvs-to-sqlite $^ $@
	sqlite-utils transform $@ cases --pk case_id
	sqlite-utils transform $@ violations --pk id
	sqlite-utils add-foreign-key $@ violations case_id cases case_id
	cat scripts/flsa_details.sql | sqlite3 $@
	sqlite-utils add-foreign-key $@ flsa_details violation_id violations id

violations.csv : whisard.csv
	cat $< | python scripts/violations.py > $@

cases.csv : whisard.csv
	cat $< | python scripts/cases.py > $@

%.csv : whd_%.csv.zip
	unzip $<
	csvstack `zipinfo -1 $<` > $@

%.csv.zip : data_summary.php
	wget -O $@ `grep -E $*_[0-9]+.csv.zip data_summary.php | perl -pe 's/^.*?<a href="(.*$*_\d+.csv.zip)".*/\1/'`

data_summary.php :
	curl 'https://enforcedata.dol.gov/views/data_summary.php' -X POST --data-raw 'agency=whd' > $@

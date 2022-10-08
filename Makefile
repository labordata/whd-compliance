whisard.db : whisard.csv
	csvs-to-sqlite $< $@

%.csv : whd_%.csv.zip
	unzip $<
	csvstack `zipinfo -1 $<` > $@

%.csv.zip : data_summary.php
	wget -O $@ `grep -E $*_[0-9]+.csv.zip data_summary.php | perl -pe 's/^.*?<a href="(.*$*_\d+.csv.zip)".*/\1/'`

data_summary.php :
	curl 'https://enforcedata.dol.gov/views/data_summary.php' -X POST --data-raw 'agency=whd' > $@

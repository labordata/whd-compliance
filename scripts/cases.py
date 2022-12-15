import sys
import csv

reader = csv.DictReader(sys.stdin)

violation_columns = {
    column
    for column in reader.fieldnames
    if (
        column.endswith("_violtn_cnt")
        or column.endswith("_bw_atp_amt")
        or column.endswith("_bw_amt")
        or column.endswith("_ee_atp_cnt")
        or column.endswith("_ee_cnt")
        or column.endswith("_minor_cnt")
        or column.endswith("_cmp_assd_amt")
    )
    and column != "case_violtn_cnt"
}

writer = csv.DictWriter(
    sys.stdout,
    fieldnames=[
        column for column in reader.fieldnames if column not in violation_columns
    ],
    extrasaction="ignore",
)

writer.writeheader()
writer.writerows(reader)

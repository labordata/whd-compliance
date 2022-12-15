import sys
import csv

reader = csv.DictReader(sys.stdin)
writer = csv.DictWriter(
    sys.stdout,
    fieldnames=[
        "case_id",
        "type",
        "violations",
        "back_wages",
        "employees",
        "civil_money_penalty",
    ],
)

writer.writeheader()

violation_columns = [
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
]

for row in reader:
    violations = {}
    for column in violation_columns:
        violation_type = (
            column.removesuffix("_violtn_cnt")
            .removesuffix("_bw_atp_amt")
            .removesuffix("_bw_amt")
            .removesuffix("_ee_atp_cnt")
            .removesuffix("_ee_cnt")
            .removesuffix("_minor_cnt")
            .removesuffix("_cmp_assd_amt")
        )
        if violation_type == "dbra_cl":
            violation_type = "dbra"
        violation_details = violations.setdefault(
            violation_type,
            {"case_id": row["case_id"], "type": violation_type},
        )
        if column.endswith("_violtn_cnt"):
            violation_details["violations"] = row[column]
        elif column.endswith("_bw_atp_amt") or column.endswith("_bw_amt"):
            violation_details["back_wages"] = row[column]
        elif (
            column.endswith("_ee_atp_cnt")
            or column.endswith("_ee_cnt")
            or column.endswith("_minor_cnt")
        ):
            violation_details["employees"] = row[column]
        elif column.endswith("_cmp_assd_amt"):
            violation_details["civil_money_penalty"] = row[column]

    filtered_violations = {}
    for violation_type, details in violations.items():
        if any(
            int(float(value))
            for key, value in details.items()
            if key
            in {
                "violations",
                "back_wages",
                "employees",
                "civil_money_penalty",
            }
        ):
            filtered_violations[violation_type] = details

    writer.writerows(filtered_violations.values())

import os
import json
import tempfile
from google.cloud import bigquery
from google.oauth2 import service_account
from datetime import datetime

bq_key_str = os.environ.get("BQ_KEY")

with tempfile.NamedTemporaryFile(mode='w', delete=False) as temp_file:
    temp_file.write(bq_key_str)
    temp_file_path = temp_file.name

# [1] 환경변수에서 값 받아오기
trigger_id = os.environ.get("TRIGGER_ID")
approve_time = os.environ.get("SLACK_APPROVE_TIME")
start_time = os.environ.get("START_TIME")
terraform_end_time = os.environ.get("TERRAFORM_END_TIME")
rds_restore_complete_time = os.environ.get("RDS_RESTORE_COMPLETE_TIME")
was_ready_time = os.environ.get("WAS_READY_TIME")
status = os.environ.get("STATUS", "success")

# [2] BigQuery 연결 설정
project_id = "kdt1-finalproject"  # GCP 프로젝트 ID
dataset_id = "DR_analysis"
table_id = "dr_recovery_logs"
table_ref = f"{project_id}.{dataset_id}.{table_id}"

credentials = service_account.Credentials.from_service_account_file(temp_file_path)
client = bigquery.Client(credentials=credentials, project="kdt1-finalproject")

# [3] 행 만들기
row = [{
    "trigger_id": trigger_id,
    "slack_approve_time": approve_time or None,
    "action_start_time": start_time or None,
    "terraform_end_time": terraform_end_time or None,
    "rds_restore_complete_time": rds_restore_complete_time or None,
    "was_ready_time": was_ready_time or None,
    "status": status
}]

# [4] 삽입 실행
errors = client.insert_rows_json(table_ref, row)

# [5] 결과 확인
if errors:
    print("❌ Failed to insert:", errors)
    exit(1)
else:
    print("✅ Successfully inserted row into BigQuery.")


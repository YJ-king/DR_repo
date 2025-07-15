import os
from google.cloud import bigquery
from google.oauth2 import service_account
from datetime import datetime

# [1] 환경변수에서 값 받아오기
trigger_id = os.environ.get("TRIGGER_ID")
approve_time = os.environ.get("SLACK_APPROVE_TIME")
start_time = os.environ.get("START_TIME")
end_time = os.environ.get("END_TIME")
status = os.environ.get("STATUS", "success")

# [2] BigQuery 연결 설정
project_id = "kdt1-finalproject"  # GCP 프로젝트 ID
dataset_id = "DR_analysis"
table_id = "dr_recovery_logs"
table_ref = f"{project_id}.{dataset_id}.{table_id}"

credentials = service_account.Credentials.from_service_account_file(
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"]
)
client = bigquery.Client(credentials=credentials, project=project_id)

# [3] 행 만들기
row = [{
    "trigger_id": trigger_id,
    "slack_approve_time": approve_time,
    "action_start_time": start_time,
    "action_end_time": end_time,
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


#!/bin/bash

echo "▶️ S3에서 백업 파일 다운로드 중..."
aws s3 cp s3://yj-dr-bucket/db_backup.sql.gz /tmp/db_backup.sql.gz || exit 1

echo "📦 압축 해제 중..."
gunzip -f /tmp/db_backup.sql.gz || exit 1

echo "🛠️ DB 복원 시작..."
mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" < /tmp/db_backup.sql || exit 1

echo "✅ DB 복원 완료!"


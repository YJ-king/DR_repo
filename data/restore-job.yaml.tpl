apiVersion: batch/v1
kind: Job
metadata:
  name: db-restore-job
  namespace: default
spec:
  backoffLimit: 1
  template:
    spec:
      serviceAccountName: irsa-s3-access
      imagePullSecrets:
        - name: regcred
      restartPolicy: Never
      containers:
      - name: restore
        image: asia-northeast3-docker.pkg.dev/kdt1-finalproject/yj-repo/restore:latest
        command: ["/bin/bash", "-c"]
        args:
          - |
            echo "📦 백업 다운로드 중..."
            aws s3 cp s3://yj-dr-bucket/db_backup.sql.gz /tmp/db.sql.gz
            gunzip /tmp/db.sql.gz
            echo "🔁 RDS에 복원 중..."
            mysql -h $RDS_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < /tmp/db.sql
        env:
        - name: RDS_HOST
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: host
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: username
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        - name: DB_NAME
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: dbname


#!/bin/sh

# Create a temporary backup directory
BACKUP_DIR=$(mktemp -d)
echo "Created temp backup dir: ${BACKUP_DIR}"

# Clean up the temporary backup directory
cleanup() {
    rm -rf "${BACKUP_DIR}"
    echo "Removed temp backup dir: ${BACKUP_DIR}"
}

# Register the cleanup function to be called on exit
trap cleanup EXIT

for DB_NAME in $DATABASES
do
    SQL_FILE="backup_${DB_NAME}_hetzner.sql"
    echo "Dumping database ${DB_NAME}..."

    mysqldump --skip-column-statistics -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${BACKUP_DIR}/${SQL_FILE}
    echo " - Dumped database ${DB_NAME} to ${SQL_FILE}"

    gzip ${BACKUP_DIR}/${SQL_FILE}
    echo " - Packed ${SQL_FILE}"

    S3_PATH=s3://${S3_BUCKET}/${SQL_FILE}.gz
    AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY} aws s3 cp ${BACKUP_DIR}/${SQL_FILE}.gz ${S3_PATH} --region ${AWS_REGION} --storage-class ${S3_STORAGE_CLASS}
    echo "- Sent backup to $S3_PATH in ${AWS_REGION}"

    echo "Dumping database ${DB_NAME}... done"
done
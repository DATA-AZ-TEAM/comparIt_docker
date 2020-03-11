# Backup
docker exec compare-it-db /usr/bin/mysqldump -u root --password=rootP@55W0rD compareIt > ./MysqlBackup/backup_$(date "+%Y.%m.%d-%H.%M.%S").sql

# Restore
cat backup.sql | docker exec -i compare-it-db /usr/bin/mysql -u root --password=rootP@55W0rD compareIt

sudo chmod 777 /var/logs/archive
cd /var/logs/archive
tar -zxvf backup.tar.gz
find ./* -name "*.tmp" -type f -delete
grep -ril "user deleted" ./*



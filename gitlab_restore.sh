#!/bin/bash -e

DATE=`date +%Y%m%d -d '1 days ago'`

cd /data
tar -zxf ${DATE}*.tgz && \
DIR=`ls -F | grep "${DATE}.*/$"`
mv ${DIR}/*.tar /var/opt/gitlab/backups/

cd /var/opt/gitlab/backups/
chmod +r *.tar
TIME_LABEL=`ls *.tar | awk -F '_' '{print $1"_"$2"_"$3"_"$4}'`

gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq
sleep 10
echo -e "yes\nyes" | gitlab-rake gitlab:backup:restore BACKUP=${TIME_LABEL} -s
gitlab-ctl start
gitlab-rake gitlab:check SANITIZE=true

rm -rf /var/opt/gitlab/backups/*
rm -rf /data/${DIR}

find /data -name "*.tgz" -mtime +20 -exec rm -f {} \;

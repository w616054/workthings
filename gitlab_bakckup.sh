#!/bin/bash

gitlab=192.168.*.*

file=$(
2>/dev/null ssh $gitlab /bin/bash << \
EOF
  set -o errexit
  /opt/gitlab/bin/gitlab-rake gitlab:backup:create CRON=1
  ls -t /var/opt/gitlab/backups/*_backup.tar | head -1
EOF
)

#tar czf ${ts}.tgz $ts --remove-files

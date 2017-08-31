#!/bin/bash -e

wd=$(cd $(dirname $0) && pwd)
ts=$(date +%Y%m%d%H%M%S)
d_dir=/data/etcd_backup

etcdctl='etcdctl --endpoint "https://192.*.*.*:2379" --cert-file etcd-client.crt --key-file etcd-client.key --ca-file etcd-ca.crt'

etcdctl backup \
        --data-dir /var/lib/etcd \
        --backup-dir ${d_dir}/etcd-${ts}

cd $d_dir && tar -zcf etcd-${ts}.tar.gz etcd-${ts} && rm -rf ${d_dir}/etcd-${ts}

find ${d_dir} -name "etcd-*.tar.gz" -mtime +15 | xargs rm -f

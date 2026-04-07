#!/bin/bash

cd $(dirname $0)/..
docker compose down -v

cd minio
git checkout single-node
[ ! -d old-data ] && sudo mv .data old-data
git checkout -- .data
grep -q old-data docker-compose.yml || gawk -i inplace '1;/volumes:/{print "      - ./old-data:/old-data"}' docker-compose.yml

cd ..
docker compose up -d minio
docker compose exec minio bash -c '
mc alias set local http://localhost:9000 admin changeme;
mc mirror --overwrite /old-data/assets /data/assets'
docker compose down -v minio
sed -i '/old-data/d' minio/docker-compose.yml
sudo rm -rf minio/old-data
docker compose up -d

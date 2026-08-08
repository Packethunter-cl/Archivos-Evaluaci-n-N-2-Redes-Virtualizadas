#!/bin/bash

# Limpiamos la cancha
docker rm -f samplerunning 2>/dev/null || true
rm -rf tempdir

mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Dockerfile cortito y seguro (sin CMD)
cat <<'EOF' > tempdir/Dockerfile
FROM python:3.10
RUN pip install --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 8080
EOF

cd tempdir

docker build --no-cache -t sampleapp .

# EL GOLAZO: Le pasamos seccomp y el comando de Python directo en el run
docker run -d -p 8888:8080 --security-opt seccomp=unconfined --name samplerunning sampleapp python /home/myapp/sample_app.py

docker ps -a

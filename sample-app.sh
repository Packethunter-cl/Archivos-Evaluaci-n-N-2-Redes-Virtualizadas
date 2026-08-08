#!/bin/bash

# Limpieza total de contenedores y directorios
docker rm -f samplerunning 2>/dev/null || true
rm -rf tempdir

mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Armado del Dockerfile a prueba de fallos (Python 3.10 y sin barra de progreso)
cat <<'EOF' > tempdir/Dockerfile
FROM python:3.10
RUN pip install --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 8080
CMD ["python", "/home/myapp/sample_app.py"]
EOF

cd tempdir

docker build --no-cache -t sampleapp .

# Ejecución desactivando el bloqueo de seguridad de la VM (seccomp)
docker run -d -p 8888:8080 --security-opt seccomp=unconfined --name samplerunning sampleapp

docker ps -a

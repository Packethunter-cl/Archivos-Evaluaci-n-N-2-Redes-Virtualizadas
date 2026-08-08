#!/bin/bash

# Limpieza inicial
rm -rf tempdir
docker rm -f samplerunning 2>/dev/null || true

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Armado del Dockerfile línea por línea
echo "FROM python:3.10" >> tempdir/Dockerfile
echo "RUN pip install --progress-bar off flask" >> tempdir/Dockerfile
echo "COPY  ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY  ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY  sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo 'CMD ["python", "/home/myapp/sample_app.py"]' >> tempdir/Dockerfile

cd tempdir

# OBLIGAR a Docker a leer todo de nuevo (sin caché)
docker build --no-cache -t sampleapp .

# Levantar con permisos de hilos
docker run -t -d -p 8888:8080 --security-opt seccomp=unconfined --name samplerunning sampleapp
docker ps -a


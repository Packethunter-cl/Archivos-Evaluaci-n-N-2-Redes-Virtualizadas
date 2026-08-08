#!/bin/bash

# 1. Limpieza inicial por si quedó algo colgando
rm -rf tempdir
docker rm -f samplerunning 2>/dev/null || true

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# 2. Armado del Dockerfile
echo "FROM python:3.10" > tempdir/Dockerfile
echo "RUN pip install --progress-bar off flask" >> tempdir/Dockerfile
echo "COPY  ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY  ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY  sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo 'CMD ["python", "/home/myapp/sample_app.py"]' >> tempdir/Dockerfile

cd tempdir

# 3. Construcción sin caché
docker build --no-cache -t sampleapp .

# 4. Ejecución
docker run -t -d -p 8888:8080 --security-opt seccomp=unconfined --name samplerunning sampleapp
docker ps -a

# 5. LIMPIEZA FINAL (Opción Nuclear local)
cd ..
rm -rf tempdir
echo "¡Entorno local limpio y contenedor corriendo!"
 

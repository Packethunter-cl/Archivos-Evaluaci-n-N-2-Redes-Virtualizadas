#!/bin/bash

# Limpiar ejecuciones anteriores
rm -rf tempdir
docker rm -f samplerunning 2>/dev/null || true

# Crear estructura temporal
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copiar archivos de la aplicación
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Crear Dockerfile
echo "FROM python:3.10" > tempdir/Dockerfile
echo "RUN pip install --progress-bar off flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo 'CMD ["python", "/home/myapp/sample_app.py"]' >> tempdir/Dockerfile

cd tempdir

# Construir imagen
docker build --no-cache -t sampleapp .

# Ejecutar contenedor (AQUÍ ESTÁ EL SALVAVIDAS AL FINAL)
docker run -t -d \
  -p 8888:8080 \
  --security-opt seccomp=unconfined \
  --name samplerunning \
  sampleapp \
  python /home/myapp/sample_app.py

# Mostrar estado
docker ps -a

cd ..
rm -rf tempdir
 

#!/bin/bash

rm -rf tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile <<'EOF'
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

docker rm -f samplerunning 2>/dev/null || true

docker run -d -p 8888:8080 --name samplerunning sampleapp

docker ps -a

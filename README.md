# onyx-project-skeleton
Base project sketon

## Install for development
```bash
wget https://github.com/laposa/onyx-project-skeleton/archive/v2.0-pre1.zip
unzip v2.0-pre1.zip
cd onyx-project-skeleton-2.0-pre1/
composer install
ln -s vendor/laposa/onyx/
```

## Build Docker image

Dockerfile and required files are included within the repository. You can build your own image, for example:
```bash
docker build -t my/onyx-project .
docker push my/onyx-project
```

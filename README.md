# onyx-project-skeleton
Base project sketon

## Install for development
```bash
wget https://github.com/laposa/onyx-project-skeleton/archive/v2.0-pre1.zip
unzip v2.0-pre1.zip
cd onyx-project-skeleton-2.0-pre1/
composer install
ln -s vendor/laposa/onyx/
chmod a+w -R var/
```
### DB configuration
```bash
sudo -u postgres psql

CREATE USER onyx WITH ENCRYPTED PASSWORD 'onyx';
CREATE DATABASE onyx;
GRANT ALL PRIVILEGES ON DATABASE onyx TO onyx;

PGPASSWORD=onyx psql -h localhost -U onyx onyx < _resources/base.sql
```
Configure db connection in .env file.

## Build Docker image

Dockerfile and required files are included within the repository. You can build your own image, for example:
```bash
docker build -t my/onyx-project .
docker push my/onyx-project
```

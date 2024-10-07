# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# Mattermost-Clone


Install ruby 3.2.2

Install rails 7.0.6

Install postresql 

sudo service postgresql start
sudo -u postgres psql
CREATE ROLE postgres WITH SUPERUSER CREATEDB CREATEROLE LOGIN;
ALTER USER postgres WITH PASSWORD 'PASSWORD';
CREATE ROLE rails LOGIN PASSWORD 'rails';
ALTER ROLE rails CREATEDB;

git clone https://github.com/Tas-depal/Clone-Mattermost.git
cd Clone-Mattermost
bundle i
rails db:create
rails db:migrate

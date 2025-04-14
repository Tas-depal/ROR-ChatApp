## Steps to get the app running

- Install ruby 3.2.2

- Install rails 7.0.6

- Install postresql
  
- To start postgres: `sudo service postgresql start`

- Enter the postgres shell and write the following commands:
  ```
  sudo -u postgres psql
  CREATE ROLE postgres WITH SUPERUSER CREATEDB CREATEROLE LOGIN;
  ALTER USER postgres WITH PASSWORD 'PASSWORD';
  CREATE ROLE rails LOGIN PASSWORD 'rails';
  ALTER ROLE rails CREATEDB;
  ```
- Install Redis server: `sudo apt install redis-server`
- Start redis server: `redis-server`

- Write the following commands:
  ```
  git clone https://github.com/Tas-depal/Clone-Mattermost.git
  cd Clone-Mattermost
  bundle i
  rails db:create
  rails db:migrate
  ```
### Start the project from this url: http://localhost:3000

# 💬 Real-Time Chat Application (Ruby on Rails + ActionCable)

A **real-time chat application** built with **Ruby on Rails**, using **ActionCable** for WebSocket communication.  
This app provides seamless messaging with support for **direct messages** and **group chats**, along with dynamic member management.

---

## ✨ Features
- ⚡ **Real-Time Messaging** – Messages are delivered instantly using WebSockets (ActionCable).
- 👥 **Direct Messaging** – One-to-one private conversations.
- 🏠 **Group Chats** – Create and manage chat rooms for multiple users.
- 🔄 **Member Management** – Add or remove members from groups dynamically.
- 🛠 **Scalable Rails Architecture** – Clean, extensible structure ready for enhancements.

---

## 🛠 Tech Stack
- **Backend:** Ruby on Rails  
- **WebSockets:** ActionCable  
- **Frontend:** Rails views (extendable with React/Vue)  
- **Database:** PostgreSQL / MySQL (configurable)  

---

## 🚀 Getting Started

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

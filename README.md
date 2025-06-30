# 📅 Daily Dev Gigest

A simple and secure **Ruby on Rails API** for user authentication and event management.
Includes user registration/login, full CRUD for events, and stateless session management via **JWT (HS256)**.

---

## 🔧 Tech Stack

- **Ruby** 3.x
- **Rails** 7.x (API-only)
- **PostgreSQL** (can be replaced with SQLite for dev)
- **JWT** for authentication (`jwt` gem)
- **BCrypt** for password hashing
- **Rack CORS** for frontend compatibility

---

## ✨ Features

### 🔐 Authentication

- `POST /users` – Register a new user
- `POST /users/login` – Authenticate and receive JWT
- JWT stored on client side (e.g. localStorage)

### 👤 User Management

- `GET /users/account_details` – View user profile

### 🗓 Event Management

- `GET /events` – List all events (authenticated)
- `GET /events/:id` – View specific event
- `POST /events` – Create new event
- `PUT /events/:id` – Update event
- `DELETE /events/:id` – Remove event

All event routes require a valid JWT in the `token` header or in body parameter.

---

## 🚀 Getting Started

```bash
git clone https://github.com/abhishek-jaiswal-eng/daily_dev_gigest.git
cd daily_dev_gigest

bundle install
rails db:create db:migrate

# Start server
rails s

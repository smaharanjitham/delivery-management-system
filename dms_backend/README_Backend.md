# Delivery Management System - Node.js Backend

REST API backend for the Delivery Management System built using Node.js, Express, TypeScript, Sequelize, MySQL, and Firebase Cloud Messaging.

## Features

- JWT Authentication
- User Login
- Refresh Token
- Role-Based Access Control (RBAC)
- Delivery Orders API
- Delivery Status Update
- Delivery Remarks
- Image Upload using Multer
- Firebase Cloud Messaging
- Swagger Documentation
- MySQL Database
- Sequelize ORM
- TSOA API Documentation
- TypeScript Support

---

## Tech Stack

- Node.js
- Express.js
- TypeScript
- Sequelize ORM
- MySQL
- JWT
- Bcrypt
- Multer
- Firebase Admin SDK
- Swagger
- TSOA

---

## Project Structure

```
src/
│
├── config/
├── controllers/
├── dtos/
├── middleware/
├── models/
├── repositories/
├── routes/
├── services/
├── uploads/
├── utils/
├── validations/
├── auth/
└── server.ts
```

---

## Prerequisites

- Node.js 20+
- MySQL
- npm

---

## Installation

Clone Repository

```bash
git clone https://github.com/yourusername/delivery_management_backend.git
```

```bash
cd delivery_management_backend
```

Install Packages

```bash
npm install
```

---

## Environment Variables

Create

```
.env
```

Example

```
PORT=5000

DB_HOST=localhost
DB_PORT=3306
DB_NAME=delivery_management
DB_USER=root
DB_PASSWORD=password

JWT_SECRET=your_secret

JWT_REFRESH_SECRET=your_refresh_secret

FIREBASE_PROJECT_ID=project-id

FIREBASE_CLIENT_EMAIL=email

FIREBASE_PRIVATE_KEY=private_key
```

---

## Run Development Server

```bash
npm run dev
```

---

## Build

```bash
npm run build
```

---

## Start Production

```bash
npm start
```

---

## API Documentation

Swagger

```
http://localhost:5000/docs
```

OpenAPI JSON

```
http://localhost:5000/swagger.json
```

---

## Main APIs

### Authentication

- POST /auth/register
- POST /auth/login
- POST /auth/refresh-token
- POST /auth/logout

### Delivery Orders

- GET /orders
- GET /orders/{id}
- PUT /orders/{id}
- PATCH /orders/status

### Remarks

- POST /orders/{id}/remarks

### Upload

- POST /upload

### Notifications

- POST /fcm-token/save
- POST /notification/send

---

## Authentication

```
Authorization: Bearer <JWT_TOKEN>
```

---

## Image Upload

Supported Formats

- JPG
- JPEG
- PNG

Stored in

```
uploads/
```

---

## Database

MySQL Tables

- users
- delivery_orders
- delivery_status
- delivery_remarks
- fcm_tokens

---

## Architecture

```
Flutter App
      │
 REST API
      │
Controller
      │
Service
      │
Repository
      │
Sequelize
      │
MySQL
```

---

## Scripts

```bash
npm run dev
npm run build
npm start
npm run tsoa
npm run swagger
```

---

## Author

Maharanjitham S.
Node.js & Flutter Developer
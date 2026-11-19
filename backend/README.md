# PSB Go Backend

Node.js + Express + MongoDB Atlas backend for the PSB Go Flutter application.

## Architecture (MVC)

- `models/` — Mongoose database schemas.
- `controllers/` — HTTP request handlers and responses.
- `routes/` — API endpoint definitions.
- `middleware/` — JWT authentication, role authorization, validation and error handling.
- `services/` — reusable business logic (authentication).
- `config/` — database connection.
- `utils/` — shared utilities (JWT generation).
- `validators/` — request validation rules.
- `scripts/` — one-time admin creation and route seeding.
- `server.js` — application entry point and Socket.IO setup.

The Flutter application under `../lib/` is the presentation/view layer. The backend intentionally does not render HTML views.

## 1. Configure environment

From this `backend` directory:

1. Copy `.env.example` to `.env`.
2. Add your MongoDB Atlas connection string to `MONGO_URI`.
3. Add a long random value to `JWT_SECRET`.
4. Keep `.env` private; it is ignored by Git.

Example:

```env
PORT=5005
MONGO_URI=mongodb+srv://YOUR_USER:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/psb_go?retryWrites=true&w=majority
JWT_SECRET=replace-with-a-long-random-secret
CLIENT_URL=http://localhost:5173
```

`CLIENT_URL` is for a browser-based admin portal. Flutter and Postman requests without an Origin header are accepted by the configured CORS middleware.

## 2. Install and run

```bash
npm install
npm run dev
```

The API starts at `http://localhost:5005`.

Health check:
- `GET /`
- `GET /api/health`

## 3. Create the first admin account

Admin accounts cannot be created through public signup.

Temporarily add these values to `.env`:

```env
ADMIN_NAME=PSB Go Admin
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=use-a-unique-password-at-least-12-characters
```

Run:

```bash
npm run create:admin
```

Remove the three `ADMIN_*` values from `.env` after the account is created.

## 4. API endpoints

### Authentication

| Method | Endpoint | Access |
|---|---|---|
| POST | `/api/auth/register` | Public passenger/driver |
| POST | `/api/auth/login` | Public |
| GET | `/api/auth/me` | Any authenticated user |

Passenger registration body:

```json
{
  "name": "Passenger Name",
  "email": "passenger@example.com",
  "password": "password123",
  "role": "passenger"
}
```

Driver registration body:

```json
{
  "name": "Driver Name",
  "email": "driver@example.com",
  "password": "password123",
  "role": "driver",
  "cnic": "42101-1234567-1",
  "licenseNo": "LIC-123456"
}
```

Login body:

```json
{
  "email": "driver@example.com",
  "password": "password123"
}
```

The response includes a JWT token and `nextStep`. A pending or rejected driver can log in to see the verification state, but protected driver operations are blocked until approved.

### Driver verification (Admin only)

| Method | Endpoint |
|---|---|
| GET | `/api/admin/drivers` |
| GET | `/api/admin/drivers/pending` |
| PATCH | `/api/admin/drivers/:id/verification` |

Approval body:

```json
{ "status": "approved" }
```

Rejection body:

```json
{ "status": "rejected", "rejectionReason": "Please submit a valid licence." }
```

### Driver

| Method | Endpoint | Access |
|---|---|---|
| GET | `/api/driver/verification-status` | Driver |

### Passenger

| Method | Endpoint | Access |
|---|---|---|
| GET | `/api/passenger/dashboard` | Passenger |
| GET | `/api/passenger/live-locations` | Passenger |

### Buses, routes, stops and announcements

Read endpoints are public. Create, update and delete endpoints require an Admin JWT.

- Buses: `/api/buses`
- Routes: `/api/routes`
- Stops: `/api/stops`
- Announcements: `/api/announcements`

### Trips

- `GET /api/trips` — Admin or Driver
- `POST /api/trips` — Admin
- `PATCH /api/trips/:id/status` — Admin or the assigned Driver (approved drivers only)

### Live location

- `POST /api/live-location/update` — approved Driver assigned to the bus

The request body includes `busId`, `routeId`, `latitude`, `longitude`, and optionally `speed` and `heading`.

## 5. Authorization

Send this header for protected endpoints:

```http
Authorization: Bearer YOUR_JWT_TOKEN
```

Public signup accepts only `passenger` and `driver`. Admin creation is a private one-time script. Driver operational actions require `verificationStatus: approved`.

## 6. Route seed data

The existing Karachi route seed data has been retained in `scripts/seedRoutes.js`. After configuring `.env`, run:

```bash
npm run seed:routes
```

The source route file contains approximate generated coordinates for stops that did not have verified GPS coordinates. Do not use those generated coordinates for production navigation; replace them with verified coordinates.

## Important next steps

This backend is the authentication and core API foundation. Before production deployment, add rate limiting, audit logging for admin verification, stronger operational assignment rules, notification delivery, and integration tests. Test all API flows with Postman before connecting the Flutter login/signup UI.

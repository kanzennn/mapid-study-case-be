## Links

| | URL |
|---|---|
| API | https://api.report.studycase.kanzen.my.id/ |
| API docs (Swagger) | https://api.report.studycase.kanzen.my.id/api-docs |
| Frontend | https://report.studycase.kanzen.my.id |

All endpoints live under `/api/v1` (e.g. `https://api.report.studycase.kanzen.my.id/api/v1/auth/login`). `GET /health` can be used as a health check.

## Demo accounts

| Role | Email | Password |
|---|---|---|
| Admin | administrator@gmail.com | Admin1234! |
| Approver | approver@gmail.com | Approver1234! |
| Reporter | reporter1@gmail.com | Reporter1234! |
| Reporter | reporter2@gmail.com | Reporter1234! |

To try the API from Swagger, call `POST /auth/login` with one of these accounts, then paste the returned `token` into **Authorize**.

## Getting started

### 1. Install and configure

```bash
npm install
cp .env.example .env        # then fill in DATABASE_URL, JWT_SECRET, CORS_ORIGIN
npm run prisma:generate     # generate the Prisma client
```

### 2. Set up the database

Pick **one** of the two options below.

#### Option A: Migrations and seeders

Builds the schema from `prisma/migrations` and fills it with seed data.

```bash
npm run prisma:migrate      # apply migrations
npm run prisma:seed         # admin, approver and reporter demo accounts
npm run prisma:seed:reports # optional: 100 dummy reports
```

#### Option B: Database dump

Restores `report_case_study.sql` (PostgreSQL 16, plain SQL). It already contains the schema, the Prisma migration history, the demo accounts and 100 sample reports, so no migration or seeding is needed.

```bash
createdb report_case_study
psql -d report_case_study -f report_case_study.sql
```

The dump drops existing tables before recreating them, so restore it into an empty database or one you don't mind overwriting.

### 3. Run

```bash
npm run dev
```

The API runs on `http://localhost:3000` and the local docs on `http://localhost:3000/api-docs`.

## Packages

### Dependencies

| Package | Version | Used for |
|---|---|---|
| express | ^5.3.0 | HTTP server and routing |
| @prisma/client | ^7.10.0 | Type-safe database client (ORM) |
| prisma | ^7.10.0 | Prisma CLI: migrations, client generation, seeding |
| @prisma/adapter-pg | ^7.10.0 | Prisma driver adapter for PostgreSQL |
| pg | ^8.23.1 | PostgreSQL driver |
| zod | ^4.6.6 | Request and environment validation |
| jsonwebtoken | ^9.0.3 | JWT authentication |
| bcrypt | ^6.0.0 | Password hashing |
| helmet | ^8.3.0 | Security HTTP headers |
| cors | ^2.8.6 | CORS configuration |
| dotenv | ^18.0.7 | Load `.env` variables |
| pino | ^10.4.0 | Logging |
| pino-http | ^11.0.0 | HTTP request logging |
| swagger-jsdoc | ^6.3.0 | Build the OpenAPI spec from route comments |
| swagger-ui-express | ^5.0.1 | Serve the Swagger UI at `/api-docs` |

### Dev dependencies

| Package | Version | Used for |
|---|---|---|
| typescript | ^6.0.3 | TypeScript compiler |
| tsx | ^4.23.15 | Run TypeScript directly (dev server with watch, seeders) |
| pino-pretty | ^13.2.0 | Readable, colorized logs in development |
| @types/bcrypt, @types/cors, @types/express, @types/jsonwebtoken, @types/node, @types/pg, @types/swagger-jsdoc, @types/swagger-ui-express | - | Type definitions |

## Scripts

| Script | Description |
|---|---|
| `npm run dev` | Start the API with hot reload |
| `npm run build` / `npm start` | Compile to `dist/` and run it |
| `npm run prisma:migrate` | Create/apply migrations |
| `npm run prisma:seed` | Seed demo accounts (see `prisma/seed.ts`) |
| `npm run prisma:seed:reports` | Seed 100 dummy reports; add `-- --reset` to recreate them |
| `npm run prisma:studio` | Open Prisma Studio |

## Roles

- **Admin** creates and manages user accounts.
- **Reporter** creates reports and can only see their own.
- **Approver** sees all reports and approves or rejects them.

## List endpoints

`GET /users` and `GET /reports` support search, filters, sorting and optional pagination through query params, for example:

```
GET /api/v1/reports?search=jalan&status=PENDING,REJECTED&sort=-created_at&page=1&limit=10
```

Pagination is only applied when `page` or `limit` is sent; the response then includes a `meta` object (`page`, `limit`, `total`, `total_pages`). `GET /reports/stats` returns report counts per status using the same filters. See the Swagger docs for the full list of parameters.

## Project structure

```
src/
|-- config/        # env, logger, prisma client, swagger
|-- routes/        # route definitions + OpenAPI annotations
|-- middlewares/   # auth, role check, validation, error handling
|-- controllers/   # HTTP layer
|-- services/      # business rules
|-- repositories/  # Prisma queries
|-- validations/   # Zod schemas
`-- utils/         # helpers (responses, JWT, password, query params -> Prisma)
prisma/
|-- schema.prisma
|-- migrations/
|-- seed.ts            # demo accounts
`-- seed-reports.ts    # dummy reports
```

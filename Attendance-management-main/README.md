# Attendance Management System

A full‑stack Attendance Management System built with **React 18**, **Node.js/Express**, **MySQL 8**, JWT authentication, role‑based access control, and automated tests.

## Tech Stack
| Layer | Technology |
|-------|------------|
| Frontend | React 18 + Vite, TailwindCSS, React‑Router 6, Axios, Chart.js |
| Backend | Node.js 20 (ESM), Express 4, MySQL2, bcryptjs, jsonwebtoken, express‑validator, helmet, rate‑limit |
| Database | MySQL 8 (normalized 3NF) |
| Testing | Jest + Supertest (backend), Vitest + React Testing Library (frontend) |
| DevOps | Docker‑Compose (optional), GitHub Actions (CI) |

## Project Structure
```
attendance-management-system/
├─ database/          # schema.sql, seed.sql
├─ backend/           # Express API
│  ├─ src/
│  │  ├─ config/
│  │  ├─ middleware/
│  │  ├─ routes/
│  │  ├─ controllers/
│  │  ├─ services/
│  │  ├─ dao/
│  │  ├─ utils/
│  │  ├─ app.js
│  │  └─ server.js
│  ├─ package.json
│  └─ .env.example
├─ frontend/          # React SPA
│  ├─ src/
│  │  ├─ components/
│  │  ├─ pages/
│  │  ├─ layouts/
│  │  ├─ services/
│  │  ├─ context/
│  │  ├─ hooks/
│  │  ├─ utils/
│  │  ├─ App.jsx
│  │  └─ main.jsx
│  ├─ package.json
│  └─ .env.example
├─ docker-compose.yml
├─ .gitignore
└─ README.md
```

## Prerequisites
- **Node.js ≥ 20**
- **MySQL 8** (or Docker)
- **Git**
- **VS Code** (recommended)

## Getting Started (Windows / VS Code)

### 1. Clone & create folders
```bash
git clone <your-repo-url> attendance-management-system
cd attendance-management-system
```

### 2. Database
```bash
# Using Docker (recommended)
docker compose up -d db          # starts MySQL on 3306

# Or use a local MySQL instance and create the DB manually:
# mysql -u root -p -e "CREATE DATABASE ams_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### 3. Run SQL scripts
```bash
# From project root
mysql -h 127.0.0.1 -u root -proot < database/schema.sql
mysql -h 127.0.0.1 -u root -proot < database/seed.sql
```
> The seed script creates demo accounts (password **Password@123**):
> - `admin@college.edu` – ADMIN
> - `faculty1@college.edu` / `faculty2@college.edu` – FACULTY
> - `student1…5@college.edu` – STUDENT

### 4. Backend
```bash
cd backend
cp .env.example .env          # edit if your MySQL credentials differ
npm install
npm run dev                   # starts on http://localhost:4000
```

### 5. Frontend
```bash
cd ../frontend
cp .env.example .env          # VITE_API_BASE_URL=http://localhost:4000/api
npm install
npm run dev                   # starts on http://localhost:5173
```

### 6. Verify
Open **http://localhost:5173** → login with any demo account → you should see a role‑aware dashboard.

## API Overview (selected)

| Method | Endpoint | Auth | Roles | Description |
|--------|----------|------|-------|-------------|
| POST | `/api/auth/login` | – | – | Returns HttpOnly access & refresh cookies |
| POST | `/api/auth/refresh` | Refresh cookie | – | Rotates tokens |
| POST | `/api/auth/logout` | Access cookie | any | Clears cookies |
| GET  | `/api/auth/me` | Access cookie | any | Current user profile |
| GET  | `/api/students` | Access | ADMIN | Paginated list |
| POST | `/api/students` | Access | ADMIN | Create student + user |
| GET  | `/api/attendance/reports/summary` | Access | ADMIN, FACULTY | Dashboard stats |
| GET  | `/api/attendance/student/:id` | Access | STUDENT (own), ADMIN, FACULTY | Student‑wise attendance |

Full OpenAPI spec can be generated from the route files.

## Testing
```bash
# Backend
cd backend && npm test

# Frontend
cd frontend && npm test
```

## Docker (one‑command)
```bash
docker compose up --build   # builds frontend, backend, starts MySQL
```
Frontend → `http://localhost:3000` (nginx), Backend → `http://localhost:4000`.

## Common Issues
| Symptom | Fix |
|---------|-----|
| `ECONNREFUSED` to MySQL | Ensure DB container is healthy (`docker compose ps`) and `.env` values match. |
| CORS error on login | Frontend dev‑server proxy (`vite.config.js`) must point to backend; both must run on declared ports. |
| Cookies not stored | Backend sets `SameSite=Lax`, `Secure=false` for localhost; browser must accept third‑party cookies on `localhost`. |
| `jwt expired` on refresh | Check `JWT_REFRESH_EXPIRY` and that refresh cookie is sent (`withCredentials:true`). |

## Extending the Project
- Add **CRUD** routes for departments, classes, subjects, faculty, assignments, sessions (follow the same pattern as `auth`).
- Implement **attendance marking** (`POST /api/attendance`) with transaction & duplicate guard.
- Build **reporting** endpoints (`/reports/subject-wise`, CSV export).
- Add **Java micro‑service** for heavy PDF generation – communicate via internal REST.

## Interview Preparation
See `INTERVIEW.md` (to be generated) for a curated list of questions & answers covering architecture, security, DB design, testing, and scaling.

## License
MIT – feel free to use for learning or portfolio.
# Ejercicio2 - Angular + FastAPI + Firebase

Aplicación CRUD de personas con frontend en Angular, backend en FastAPI y base de datos en **Firebase Firestore** (`ing-web-93d49`).

## Inicio rápido

```powershell
cd d:\WEB\ejercicio2
.\start.ps1
```

Abre **http://localhost:4201**

| Servicio  | URL |
|-----------|-----|
| Frontend  | http://localhost:4201 |
| Backend   | http://localhost:8001 |
| API Docs  | http://localhost:8001/docs |

> Usa puertos 4201 y 8001 para no chocar con Ejercicio1 (4200/8000).

## Firebase

- **Proyecto:** `ing-web-93d49`
- **Base de datos:** Firestore `(default)`
- **Colección:** `personas`

### Autenticación automática

El backend se conecta automáticamente usando tu sesión de **Firebase CLI** (`firebase login`).

Opcionalmente puedes usar una cuenta de servicio:
1. Firebase Console → Cuentas de servicio → Generar nueva clave privada
2. Guardar como `backend/firebase-service-account.json`

Verificar conexión:

```powershell
.\setup-firebase.ps1
```

## Estructura

```
ejercicio2/
├── backend/          # API FastAPI + Firestore
├── frontend/         # Angular 21 + Bootstrap
├── start.ps1         # Inicia backend y frontend
└── setup-firebase.ps1
```

## Manual

### Backend

```powershell
cd backend
.\.venv\Scripts\Activate.ps1
uvicorn main:app --reload --port 8001
```

### Frontend

```powershell
cd frontend
npm start -- --port 4201
```

### Datos de ejemplo

```powershell
cd backend
.\.venv\Scripts\python scripts\seed.py
```

## Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/health` | Estado de conexión con Firebase |
| GET | `/api/personas` | Listar personas |
| GET | `/api/personas/{doc}` | Obtener persona por documento |
| POST | `/api/personas` | Crear persona |
| PUT | `/api/personas/{doc}` | Editar persona |
| DELETE | `/api/personas/{doc}` | Eliminar persona |

## Colección Firestore

Cada documento usa `docIdentidad` como ID:

```json
{
  "nombre": "Juan Pérez",
  "edad": 30,
  "correo": "juan@ejemplo.com"
}
```

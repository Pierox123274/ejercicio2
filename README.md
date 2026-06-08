# Ejercicio2 - Angular + FastAPI + Firebase

Aplicación CRUD de personas con frontend en Angular, backend en FastAPI y base de datos en **Firebase Firestore** (`ing-web-93d49`).

## URLs en producción

| Servicio | URL | Estado |
|----------|-----|--------|
| **Frontend (Firebase)** | https://ing-web-93d49.web.app | Desplegado |
| **Backend (Render)** | https://ejercicio2-api.onrender.com | Requiere configurar Blueprint |
| **Frontend (Render)** | https://ejercicio2-web.onrender.com | Requiere configurar Blueprint |
| **Repositorio** | https://github.com/Pierox123274/ejercicio2 | Publicado |

## Desplegar el backend (paso final)

El frontend ya está publicado. Para que la app funcione al 100%, despliega el backend en Render:

1. Descarga la clave privada de Firebase:
   [Cuentas de servicio](https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk) → **Generar nueva clave privada**

2. Despliega con Render Blueprint:

   [![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/Pierox123274/ejercicio2)

3. En el servicio **ejercicio2-api**, agrega la variable secreta:
   - `FIREBASE_CREDENTIALS_JSON` = contenido completo del archivo JSON

4. Espera el deploy y verifica:
   ```bash
   curl https://ejercicio2-api.onrender.com/api/health
   ```

5. Abre https://ing-web-93d49.web.app y prueba la aplicación.

## Desarrollo local

```powershell
cd d:\WEB\ejercicio2
.\start.ps1
```

- Frontend: http://localhost:4201
- Backend: http://localhost:8001

## Estructura

```
ejercicio2/
├── backend/          # FastAPI + Firestore
├── frontend/         # Angular 21 + Bootstrap
├── render.yaml       # Blueprint Render
├── firebase.json     # Firebase Hosting
└── docs/deploy.md    # Guía detallada
```

## Endpoints API

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/health` | Estado de Firebase |
| GET | `/api/personas` | Listar personas |
| GET | `/api/personas/{doc}` | Obtener persona |
| POST | `/api/personas` | Crear persona |
| PUT | `/api/personas/{doc}` | Editar persona |
| DELETE | `/api/personas/{doc}` | Eliminar persona |

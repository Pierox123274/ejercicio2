# Despliegue en Render (Web Service manual)

## Servicio 1: Backend (crear primero)

**New → Web Service**

| Campo | Valor |
|-------|-------|
| Repository | `https://github.com/Pierox123274/ejercicio2` |
| Name | `ejercicio2-api` |
| Branch | `master` |
| Root Directory | `backend` |
| Runtime | Python 3 |
| Build Command | `pip install -r requirements.txt` |
| Start Command | `uvicorn main:app --host 0.0.0.0 --port $PORT` |
| Health Check Path | `/api/health` |
| Plan | Free |

### Variables de entorno

| Key | Value |
|-----|-------|
| `FIREBASE_PROJECT_ID` | `ing-web-93d49` |
| `PERSONAS_COLLECTION` | `personas` |
| `FIREBASE_CREDENTIALS_JSON` | JSON completo de Firebase (Cuentas de servicio) |
| `PYTHON_VERSION` | `3.13.0` |

URL resultante: `https://ejercicio2-api.onrender.com`

---

## Servicio 2: Frontend (crear después)

**New → Web Service**

| Campo | Valor |
|-------|-------|
| Repository | `https://github.com/Pierox123274/ejercicio2` |
| Name | `ejercicio2-web` |
| Branch | `master` |
| Root Directory | `frontend` |
| Runtime | Node |
| Build Command | `npm ci && npm run build` |
| Start Command | `npm run serve:ssr:frontend` |
| Plan | Free |

### Variable de entorno

| Key | Value |
|-----|-------|
| `API_BASE_URL` | `ejercicio2-api.onrender.com` |

URL resultante: `https://ejercicio2-web.onrender.com`

---

## Firebase Hosting (frontend alternativo)

```powershell
cd frontend
npm run build:hosting
cd ..
firebase deploy --only hosting --project ing-web-93d49
```

URL: https://ing-web-93d49.web.app

Requiere que el backend en Render esté activo.

---

## Obtener FIREBASE_CREDENTIALS_JSON

1. [Firebase Console → Cuentas de servicio](https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk)
2. **Generar nueva clave privada**
3. Abrir el `.json` con bloc de notas
4. Copiar todo el contenido y pegarlo en Render

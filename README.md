# Ejercicio2 - Angular + FastAPI + Firebase

CRUD de personas con Angular, FastAPI y Firebase Firestore.

## Desplegar en la nube (sin tarjeta)

> **Render siempre pide tarjeta** (incluso plan gratis).  
> Usamos **Hugging Face Spaces** para el backend (gratis, sin tarjeta).

### Paso 1: Credenciales Firebase (solo una vez, sin tarjeta)

1. Abre [Firebase → Cuentas de servicio](https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk)
2. **Generar nueva clave privada**
3. Guarda el archivo como: `backend/firebase-service-account.json`

### Paso 2: Cuenta Hugging Face (gratis, sin tarjeta)

1. Regístrate en https://huggingface.co/join
2. Crea un token en https://huggingface.co/settings/tokens
3. Ejecuta:
   ```powershell
   cd backend
   .\.venv\Scripts\huggingface-cli login
   ```

### Paso 3: Desplegar todo

```powershell
cd d:\WEB\ejercicio2
.\deploy-nube.ps1
```

### URLs en producción

| Servicio | URL |
|----------|-----|
| **App** | https://ing-web-93d49.web.app |
| **API** | https://pierox123274-ejercicio2-api.hf.space/api |
| **Health** | https://pierox123274-ejercicio2-api.hf.space/api/health |

## Desarrollo local

```powershell
.\install.ps1    # primera vez
.\start.ps1      # cada vez
```

| Servicio | URL |
|----------|-----|
| Frontend | http://localhost:4201 |
| Backend | http://localhost:8001 |

## Repositorio

https://github.com/Pierox123274/ejercicio2

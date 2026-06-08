# Ejercicio2 - Angular + FastAPI + Firebase

CRUD de personas con Angular, FastAPI y Firebase Firestore (`ing-web-93d49`).

## Producción (internet)

| Servicio | URL |
|----------|-----|
| **App** | https://ing-web-93d49.web.app |
| **API** | https://ing-web-93d49.web.app/api |
| **Código** | https://github.com/Pierox123274/ejercicio2 |

### Desplegar backend en la nube

El frontend ya está publicado. Para activar el backend en la nube:

1. **Activa plan Blaze** en Firebase (gratis para uso bajo):  
   https://console.firebase.google.com/project/ing-web-93d49/usage/details

2. Ejecuta:
   ```powershell
   .\deploy-production.ps1
   ```

Guía detallada: `DESPLIEGUE-BACKEND.md`

## Desarrollo local

### Primera vez
```powershell
.\install.ps1
```

### Ejecutar
```powershell
.\start.ps1
```
O doble clic en `ejecutar.bat`.

| Servicio | URL |
|----------|-----|
| Frontend | http://localhost:4201 |
| Backend | http://localhost:8001 |
| API Docs | http://localhost:8001/docs |

### Detener
```powershell
.\stop.ps1
```

## Funciones

- Listar, crear, editar y eliminar personas
- Datos en Firebase Firestore (colección `personas`)
- Producción: Angular → FastAPI (Cloud Function) → Firestore
- Local: Angular → FastAPI (localhost) → Firestore

# Desplegar el Backend en la nube (Firebase)

El backend FastAPI se despliega como **Cloud Function** en tu proyecto Firebase.
El frontend en `https://ing-web-93d49.web.app` llama a `/api` y Firebase redirige al backend.

## Paso 1: Activar plan Blaze (obligatorio, gratis para uso bajo)

Firebase Functions requiere el plan **Blaze** (pago por uso). Con el tráfico de un ejercicio **no se cobra nada**.

1. Abre: https://console.firebase.google.com/project/ing-web-93d49/usage/details
2. Clic en **Actualizar a Blaze**
3. Agrega tarjeta (solo verificación, no hay cargo mensual fijo)

## Paso 2: Desplegar backend + frontend

```powershell
cd d:\WEB\ejercicio2
.\deploy-production.ps1
```

## Paso 3: Verificar

- App: https://ing-web-93d49.web.app
- API: https://ing-web-93d49.web.app/api/health
- API Docs: no disponible en Cloud Functions (usa `/docs` solo en local)

Respuesta esperada de health:
```json
{"status":"ok","database":"firebase","project":"ing-web-93d49","auth":"application-default"}
```

## Arquitectura en producción

```
Usuario → ing-web-93d49.web.app (Firebase Hosting)
              ├── /           → Angular
              └── /api/**     → Cloud Function (FastAPI)
                                    └── Firestore
```

## Desarrollo local (sin cambios)

```powershell
.\start.ps1
```

Local sigue usando FastAPI en `localhost:8001`.

## Alternativa: Render

Si prefieres Render en lugar de Firebase Functions, ver `docs/deploy.md`.

# Despliegue de Ejercicio2

## Opción recomendada: Render (backend + frontend)

### 1. Credenciales Firebase

En [Firebase Console](https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk):
- Genera una **nueva clave privada** (JSON)
- Copia el contenido completo del archivo

### 2. GitHub

Sube el repositorio a GitHub.

### 3. Render Blueprint

1. Entra a [Render Dashboard](https://dashboard.render.com/)
2. **New** → **Blueprint**
3. Conecta el repositorio de GitHub
4. Render detectará `render.yaml`
5. En el servicio **ejercicio2-api**, agrega la variable secreta:
   - `FIREBASE_CREDENTIALS_JSON` = contenido completo del JSON

### 4. URLs públicas

| Servicio | URL |
|----------|-----|
| API | https://ejercicio2-api.onrender.com |
| Web | https://ejercicio2-web.onrender.com |
| Docs | https://ejercicio2-api.onrender.com/docs |

### 5. Verificación

```bash
curl https://ejercicio2-api.onrender.com/api/health
curl https://ejercicio2-api.onrender.com/api/personas
```

Abre https://ejercicio2-web.onrender.com y prueba crear, editar y eliminar personas.

---

## Opción alternativa: Firebase Hosting (solo frontend)

Si el backend ya está en Render:

```powershell
cd frontend
npm run build
cd ..
firebase deploy --only hosting
```

El frontend en Firebase usará `https://ejercicio2-api.onrender.com/api` (configurado en `environment.production.ts`).

URL: https://ing-web-93d49.web.app

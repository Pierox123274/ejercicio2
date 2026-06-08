# Ejercicio2 - Angular + FastAPI + Firebase

CRUD de personas con Angular, FastAPI y Firebase Firestore (`ing-web-93d49`).

## Ejecutar (100% local)

### Primera vez

```powershell
cd d:\WEB\ejercicio2
.\install.ps1
```

### Cada vez que quieras usar la app

```powershell
.\start.ps1
```

O haz doble clic en **`ejecutar.bat`**.

Se abre automáticamente: **http://localhost:4201**

| Servicio | URL |
|----------|-----|
| Frontend | http://localhost:4201 |
| API | http://localhost:8001 |
| API Docs | http://localhost:8001/docs |

### Detener

```powershell
.\stop.ps1
```

## Funciones

- Listar personas
- Crear persona
- Editar persona
- Eliminar persona
- Datos guardados en Firebase Firestore (colección `personas`)

## Requisitos

- Node.js 20+
- Python 3.11+
- Firebase CLI (`npm install -g firebase-tools`)
- Sesión Firebase: `firebase login`

## Despliegue en internet (opcional)

- **Frontend Firebase:** https://ing-web-93d49.web.app
- **Backend Render:** ver `docs/deploy.md` (requiere tarjeta en Render)

Guía paso a paso con Web Service manual: `docs/deploy.md`

## Repositorio

https://github.com/Pierox123274/ejercicio2

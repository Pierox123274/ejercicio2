# frontend

Angular 21 (standalone default), SSR (Express), Vitest, npm 11.11.

## Commands

- **Dev server**: `ng serve` (port 4200, auto-reload)
- **Build**: `ng build` (output: `dist/`, SSR + browser)
- **Test (Vitest)**: `ng test`
- **Format**: `npx prettier --write .`
- **Lint**: none configured

## Repo-specific conventions

- **Standalone components** only (no NgModules). Do NOT set `standalone: true` — it's the default.
- **State**: signals + `computed()`, never `mutate`. Use `input()`/`output()` functions, not decorators.
- **Templates**: native control flow (`@if`, `@for`, `@switch`), not `*ngIf`/`*ngFor`.
- **DI**: `inject()` function, not constructor injection.
- **Forms**: Reactive forms, not template-driven.
- **Styling**: Bootstrap via CDN (added in `index.html`). Do NOT install via npm.
- **Formatting**: Prettier (printWidth 100, single quotes, `angular` parser for HTML).

## Directories

```
src/app/
  app.ts             # root shell (router-outlet only)
  app.routes.ts      # route definitions
  app.config.ts      # providers (router, http, hydration)
  components/        # UI components (one folder per feature)
    persona-list/
      persona-list.ts
      persona-list.html
      persona-list.css
  services/          # backend communication + business logic
    persona.service.ts
  models/            # TypeScript interfaces
    persona.model.ts
    index.ts         # re-exports
```

Flow: **components → services → backend API**

## Configuration notes

- `tsconfig.json`: strict mode, strict templates, ES2022, `module: "preserve"`
- `tsconfig.spec.json`: includes `vitest/globals` types
- `angular.json`: SSR enabled (`outputMode: "server"`), `@angular/build` application builder
- `app.config.ts`: SSR with `provideClientHydration(withEventReplay())`
- `proxy.conf.json`: dev proxy `/api` → `http://localhost:8000`

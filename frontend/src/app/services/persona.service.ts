import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { environment } from '../../environments/environment';
import { Persona, PersonaCreate, PersonaUpdate } from '../models';

@Injectable({ providedIn: 'root' })
export class PersonaService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/personas`;

  list(): Observable<Persona[]> {
    return this.http.get<Persona[]>(this.baseUrl);
  }

  get(docIdentidad: string): Observable<Persona> {
    return this.http.get<Persona>(`${this.baseUrl}/${docIdentidad}`);
  }

  create(persona: PersonaCreate): Observable<Persona> {
    return this.http.post<Persona>(this.baseUrl, persona);
  }

  update(docIdentidad: string, persona: PersonaUpdate): Observable<Persona> {
    return this.http.put<Persona>(`${this.baseUrl}/${docIdentidad}`, persona);
  }

  delete(docIdentidad: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${docIdentidad}`);
  }
}

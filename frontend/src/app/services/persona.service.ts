import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { environment } from '../../environments/environment';
import { Persona, PersonaCreate, PersonaUpdate } from '../models';
import { PersonaFirestoreService } from './persona-firestore.service';

@Injectable({ providedIn: 'root' })
export class PersonaService {
  private readonly http = inject(HttpClient);
  private readonly firestore = inject(PersonaFirestoreService);
  private readonly baseUrl = `${environment.apiUrl}/personas`;

  list(): Observable<Persona[]> {
    return environment.useFirestore
      ? this.firestore.list()
      : this.http.get<Persona[]>(this.baseUrl);
  }

  get(docIdentidad: string): Observable<Persona> {
    return environment.useFirestore
      ? this.firestore.get(docIdentidad)
      : this.http.get<Persona>(`${this.baseUrl}/${docIdentidad}`);
  }

  create(persona: PersonaCreate): Observable<Persona> {
    return environment.useFirestore
      ? this.firestore.create(persona)
      : this.http.post<Persona>(this.baseUrl, persona);
  }

  update(docIdentidad: string, persona: PersonaUpdate): Observable<Persona> {
    return environment.useFirestore
      ? this.firestore.update(docIdentidad, persona)
      : this.http.put<Persona>(`${this.baseUrl}/${docIdentidad}`, persona);
  }

  delete(docIdentidad: string): Observable<void> {
    return environment.useFirestore
      ? this.firestore.delete(docIdentidad)
      : this.http.delete<void>(`${this.baseUrl}/${docIdentidad}`);
  }
}

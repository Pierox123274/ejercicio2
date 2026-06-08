import { Injectable } from '@angular/core';
import { initializeApp } from 'firebase/app';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  getFirestore,
  setDoc,
} from 'firebase/firestore';
import { from, map, Observable, switchMap, throwError } from 'rxjs';

import { environment } from '../../environments/environment';
import { Persona, PersonaCreate, PersonaUpdate } from '../models';

const COLLECTION = 'personas';

@Injectable({ providedIn: 'root' })
export class PersonaFirestoreService {
  private readonly db = getFirestore(initializeApp(environment.firebaseConfig));

  list(): Observable<Persona[]> {
    return from(getDocs(collection(this.db, COLLECTION))).pipe(
      map((snapshot) => {
        const personas = snapshot.docs.map((document) => this.toPersona(document.id, document.data()));
        return personas.sort((left, right) => left.nombre.localeCompare(right.nombre));
      }),
    );
  }

  get(docIdentidad: string): Observable<Persona> {
    return from(getDoc(doc(this.db, COLLECTION, docIdentidad))).pipe(
      map((snapshot) => {
        if (!snapshot.exists()) {
          throw new Error('Persona no encontrada');
        }
        return this.toPersona(snapshot.id, snapshot.data());
      }),
    );
  }

  create(persona: PersonaCreate): Observable<Persona> {
    const documentRef = doc(this.db, COLLECTION, persona.docIdentidad);
    return from(getDoc(documentRef)).pipe(
      switchMap((snapshot) => {
        if (snapshot.exists()) {
          return throwError(() => new Error('Ya existe una persona con ese documento'));
        }
        return from(
          setDoc(documentRef, {
            nombre: persona.nombre,
            edad: persona.edad,
            correo: persona.correo,
          }),
        ).pipe(map(() => persona));
      }),
    );
  }

  update(docIdentidad: string, persona: PersonaUpdate): Observable<Persona> {
    const documentRef = doc(this.db, COLLECTION, docIdentidad);
    return from(
      setDoc(documentRef, {
        nombre: persona.nombre,
        edad: persona.edad,
        correo: persona.correo,
      }),
    ).pipe(map(() => ({ docIdentidad, ...persona })));
  }

  delete(docIdentidad: string): Observable<void> {
    return from(deleteDoc(doc(this.db, COLLECTION, docIdentidad)));
  }

  private toPersona(docIdentidad: string, data: Record<string, unknown>): Persona {
    return {
      docIdentidad,
      nombre: String(data['nombre'] ?? ''),
      edad: Number(data['edad'] ?? 0),
      correo: String(data['correo'] ?? ''),
    };
  }
}

import { Component, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';

import { Persona } from '../../models';
import { PersonaService } from '../../services/persona.service';

@Component({
  selector: 'app-persona-list',
  imports: [ReactiveFormsModule],
  templateUrl: './persona-list.html',
  styleUrl: './persona-list.css',
})
export class PersonaList implements OnInit {
  private readonly personaService = inject(PersonaService);
  private readonly fb = inject(FormBuilder);

  protected readonly personas = signal<Persona[]>([]);
  protected readonly loading = signal(true);
  protected readonly error = signal<string | null>(null);
  protected readonly saving = signal(false);
  protected readonly editingDoc = signal<string | null>(null);
  protected readonly deletingDoc = signal<string | null>(null);

  protected readonly form = this.fb.nonNullable.group({
    docIdentidad: ['', [Validators.required, Validators.maxLength(12)]],
    nombre: ['', [Validators.required, Validators.maxLength(60)]],
    edad: [0, [Validators.required, Validators.min(1), Validators.max(120)]],
    correo: ['', [Validators.required, Validators.email]],
  });

  ngOnInit(): void {
    this.loadPersonas();
  }

  protected get isEditing(): boolean {
    return this.editingDoc() !== null;
  }

  protected loadPersonas(): void {
    this.loading.set(true);
    this.error.set(null);
    this.personaService.list().subscribe({
      next: (personas) => {
        this.personas.set(personas);
        this.loading.set(false);
      },
      error: () => {
        this.error.set('No se pudo conectar con el backend o la base de datos.');
        this.loading.set(false);
      },
    });
  }

  protected submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.saving.set(true);
    this.error.set(null);

    if (this.isEditing) {
      const docIdentidad = this.editingDoc()!;
      const { nombre, edad, correo } = this.form.getRawValue();
      this.personaService.update(docIdentidad, { nombre, edad, correo }).subscribe({
        next: () => {
          this.resetForm();
          this.saving.set(false);
          this.loadPersonas();
        },
      error: (err) => {
        this.error.set(this.resolveError(err, 'No se pudo actualizar la persona.'));
        this.saving.set(false);
      },
      });
      return;
    }

    this.personaService.create(this.form.getRawValue()).subscribe({
      next: () => {
        this.resetForm();
        this.saving.set(false);
        this.loadPersonas();
      },
      error: (err) => {
        this.error.set(this.resolveError(err, 'No se pudo guardar la persona.'));
        this.saving.set(false);
      },
    });
  }

  protected startEdit(persona: Persona): void {
    this.editingDoc.set(persona.docIdentidad);
    this.error.set(null);
    this.form.setValue({
      docIdentidad: persona.docIdentidad,
      nombre: persona.nombre,
      edad: persona.edad,
      correo: persona.correo,
    });
    this.form.controls.docIdentidad.disable();
  }

  protected cancelEdit(): void {
    this.resetForm();
  }

  protected deletePersona(persona: Persona): void {
    const confirmed = confirm(
      `¿Eliminar a ${persona.nombre} (${persona.docIdentidad})?`,
    );
    if (!confirmed) {
      return;
    }

    this.deletingDoc.set(persona.docIdentidad);
    this.error.set(null);

    this.personaService.delete(persona.docIdentidad).subscribe({
      next: () => {
        if (this.editingDoc() === persona.docIdentidad) {
          this.resetForm();
        }
        this.deletingDoc.set(null);
        this.loadPersonas();
      },
      error: (err) => {
        this.error.set(this.resolveError(err, 'No se pudo eliminar la persona.'));
        this.deletingDoc.set(null);
      },
    });
  }

  private resolveError(err: unknown, fallback: string): string {
    if (err && typeof err === 'object') {
      const error = err as { error?: { detail?: string }; message?: string; status?: number };
      if (error.status === 409 || error.error?.detail?.includes('documento')) {
        return 'Ya existe una persona con ese documento de identidad.';
      }
      if (error.error?.detail) {
        return error.error.detail;
      }
      if (error.message?.includes('documento')) {
        return error.message;
      }
    }
    return fallback;
  }

  private resetForm(): void {
    this.editingDoc.set(null);
    this.form.controls.docIdentidad.enable();
    this.form.reset({ docIdentidad: '', nombre: '', edad: 0, correo: '' });
  }
}

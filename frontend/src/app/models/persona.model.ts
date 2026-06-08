export interface Persona {
  docIdentidad: string;
  nombre: string;
  edad: number;
  correo: string;
}

export interface PersonaCreate {
  docIdentidad: string;
  nombre: string;
  edad: number;
  correo: string;
}

export interface PersonaUpdate {
  nombre: string;
  edad: number;
  correo: string;
}

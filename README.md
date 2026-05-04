# Veterinaria App

Aplicación veterinaria orientada a la gestión clínica y administrativa de una veterinaria o fundación de rescate animal.

---
### Integrantes:
- Estefania Solórzano - 00332809
- Daniela Urbina - 00332927
- Daniel Salazar - 00335587
-
- 

---

## Descripción del Proyecto

Este proyecto consiste en el desarrollo de una aplicación que permite gestionar de manera eficiente la información relacionada con una veterinaria o fundación animal.  

La aplicación facilita el manejo de:
- Mascotas
- Usuarios
- Citas médicas
- Vacunas
- Adopciones
- Reportes de abandono

El sistema fue diseñado para reemplazar procesos manuales (papel y Excel) y mejorar la organización de la información, permitiendo un acceso más rápido, seguro y centralizado.

---

## Objetivo

Desarrollar una solución tecnológica que permita:
- Digitalizar la información clínica de las mascotas  
- Gestionar citas y vacunación  
- Registrar adopciones y reportes  
- Facilitar el trabajo interno de la organización  

---

## Usuarios del sistema

El sistema contempla diferentes tipos de usuarios:

- **Administrador:** control total del sistema  
- **Veterinario:** gestión clínica (citas, vacunas, historial)  
- **Voluntario:** registro de reportes y apoyo en procesos  
- **Cliente:** registro de mascotas, citas y adopciones  

---

## Tecnologías utilizadas

- **Frontend:** Flutter / Web  
- **Backend:** Node.js + Express  
- **Base de datos:** MySQL  
- **Entorno:** Ubuntu Server (Virtual Machine)  
- **Control de versiones:** Git & GitHub  

---

## Arquitectura del sistema

El sistema sigue una arquitectura básica cliente-servidor:
```bash
Frontend (App)
↓
Backend (API REST)
↓
Base de Datos (MySQL)
```

---

## Base de datos

La base de datos fue diseñada siguiendo principios de normalización para evitar redundancia de datos.

### Tablas principales:
- `usuarios`
- `mascotas`
- `citas`
- `vacunas`
- `adopciones`
- `reportes`

### Relaciones:
- Un usuario puede tener varias mascotas  
- Una mascota puede tener varias citas  
- Una mascota puede tener varias vacunas  
- Un usuario puede generar reportes  
- Un usuario puede solicitar adopciones  

---

## Modelo ER

El sistema cuenta con un modelo entidad-relación que define las entidades principales y sus relaciones.

<img width="1011" height="694" alt="image" src="https://github.com/user-attachments/assets/86555551-823c-4baa-82f0-60653aaf5cd4" />


---

## Funcionalidades principales

- Registro e inicio de sesión de usuarios  
- Registro y gestión de mascotas  
- Agendamiento de citas veterinarias  
- Registro de vacunas  
- Gestión de adopciones  
- Reportes de abandono  
- Visualización de historial clínico  

---

## Datos de prueba

El sistema incluye datos de prueba para validar su funcionamiento, como:
- Usuarios de ejemplo  
- Mascotas registradas  
- Citas programadas  
- Vacunas aplicadas  

---

## Cómo ejecutar el proyecto

### 1. Clonar repositorio
```bash
git clone https://github.com/tu-repo/veterinaria-app.git
cd veterinaria-app
```

## 2. Base de datos

Importar el archivo SQL:

```bash
sudo mysql < veterinaria_db.sql
```

Luego verificar:
USE veterinaria_db;
SHOW TABLES;

## 3. Backend
```bash
cd backend
npm install
npm start
```

## 4. Frontend
```bash
cd frontend
flutter run
```

### Estructura del proyecto
```bash
veterinaria-app/
│
├── backend/
├── frontend/
├── database/
│   └── veterinaria_db.sql
├── docs/
└── README.md
```

---

### Metodología de trabajo

El proyecto fue organizado utilizando Scrum en Jira, dividiendo el trabajo en diferentes módulos:

- Análisis y requisitos
- Diseño del sistema
- Backend
- Frontend
- Funciones IA: El módulo de IA y funciones extra incluye detección de animales duplicados mediante un algoritmo de similitud de texto, un sistema de reportes urgentes con tres niveles de prioridad, y búsqueda inteligente de animales con múltiples filtros. Además se actualizó el ApiService para conectarse correctamente al backend .NET y se mejoraron los mensajes y alertas de todos los formularios existentes.


Cada módulo fue desarrollado por un miembro del equipo.

---
Con respecto al fronted: 

# Frontend Flutter

## Descripción general

El frontend está desarrollado en Flutter y contiene la interfaz que utilizará el usuario para navegar entre las funciones principales del sistema.

La aplicación incluye una pantalla de inicio y tres módulos principales:

- Registro de animales.
- Agenda de citas.
- Registro de adopciones.

En la pantalla principal se muestran las opciones para acceder a cada módulo. La navegación ya está configurada mediante rutas internas de Flutter, por lo que el usuario puede moverse entre las pantallas desde el menú principal.

---

## Módulos del frontend

### Registro de animales

En el módulo de registro de animales se creó un formulario con los siguientes campos:

- Nombre.
- Especie.
- Raza.
- Edad.
- Estado de salud.
- Sexo.

También se agregaron validaciones simples para evitar el envío de campos vacíos y para comprobar que la edad ingresada sea válida.

---

### Agenda de citas

En el módulo de citas se creó un formulario para registrar la siguiente información:

- Mascota.
- Responsable.
- Fecha.
- Hora.
- Motivo de la cita.

La fecha y la hora se seleccionan mediante controles propios de Flutter. Además, los campos cuentan con validación obligatoria.

---

### Registro de adopciones

En el módulo de adopciones se creó un formulario para registrar la siguiente información:

- Animal.
- Adoptante.
- Fecha de adopción.
- Estado del proceso.

El estado del proceso puede tener uno de los siguientes valores:

- En proceso.
- Aprobada.
- Rechazada.

---

## Mensajes y estados de carga

El frontend muestra mensajes de éxito o error cuando se intenta guardar información.

Además, cuenta con estados de carga, como:

```txt
Guardando...

### Aprendizajes

Durante el desarrollo se aprendió:

- Diseño de bases de datos relacionales
- Uso de llaves foráneas y normalización
- Creación de APIs REST
- Integración entre frontend y backend
- Trabajo en equipo con Git y Scrum

---

### Conclusión

El proyecto cumple con el objetivo de crear una aplicación funcional para la gestión veterinaria, mejorando significativamente la organización de la información y facilitando los procesos internos de la institución.

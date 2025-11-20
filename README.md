# Hospital BD – Documentación y Decisiones de Diseño

## Introducción

Este documento describe las decisiones de diseño tomadas para construir la base de datos **Hospital BD**, creada como proyecto académico para modelar procesos reales de un sistema hospitalario.

El diseño se basa en los principios de:

- Normalización hasta 3FN
- Integridad referencial
- Seguridad por roles (RBAC) y Row-Level Security (RLS)
- Escalabilidad modular
- Trazabilidad mediante triggers de auditoría

---

## Enfoque General del Diseño

La base de datos fue diseñada considerando la operación real de un hospital: atención de pacientes, agenda médica, hospitalizaciones, tratamientos aplicados y administración de medicamentos.

Se priorizó:

- Un modelo claro, semántico y bien normalizado
- Relaciones realistas entre entidades
- Alta cohesión y bajo acoplamiento
- Seguridad centrada en roles y políticas por fila

---

## Modelo Entidad–Relación (ER)

### Entidades principales

- **Pacientes**: datos personales, contacto y estado.
- **Médicos**: información del personal clínico.
- **Departamentos**: organización física/funcional del hospital.
- **Habitaciones**: espacios asignados a ingresos.
- **Citas**: agenda entre médico y paciente.
- **Ingresos**: hospitalizaciones registradas.
- **Tratamientos**: catálogo de terapias.
- **Historial de tratamientos**: tratamientos aplicados a un ingreso.
- **Medicamentos**
- **Recetas**
- **Receta Detalle**

Cada entidad fue diseñada para contener solo la información necesaria, evitando redundancia y manteniendo consistencia.

---

## Relaciones del Modelo

### Relaciones principales

#### Pacientes – Citas – Médicos
Relación N:N modelada mediante tabla intermedia (`citas`).

#### Habitación – Ingresos
Relación 1:N (una habitación puede tener varios ingresos en diferentes fechas).

#### Ingresos – Tratamientos
Relación N:N mediante `historial_tratamientos`.

#### Recetas – Medicamentos
Relación N:N mediante `receta_detalle`.

### Justificación

Estas relaciones reflejan fielmente la operación hospitalaria real, permitiendo auditoría, reportes y procesos clínicos sin inconsistencias.

---

## Restricciones de Integridad

### Llaves primarias

Todas las tablas usan claves primarias autoincrementales (`AUTO_INCREMENT` o `SERIAL`).

### Llaves foráneas

Las llaves foráneas garantizan integridad referencial, asegurando que no existan registros huérfanos.

### Restricciones CHECK

Se aplicaron para reforzar la validez del dato:

- Fechas correctas
- Valores no negativos
- Estados válidos mediante `ENUM`

### Campos únicos

- Correos electrónicos
- Números de habitación

Estas restricciones evitan duplicidad y errores lógicos.

---

## Seguridad del Sistema

### Roles definidos

| Rol | Descripción |
|-----|-------------|
| `rol_admin` | Acceso total al sistema |
| `rol_medico` | Solo puede ver pacientes de su mismo departamento |
| `rol_recepcionista` | Lectura general, sin editar datos |
| `rol_auditor` | Solo lectura total para auditorías |

### Row-Level Security (RLS)

RLS se implementó para proteger información sensible.  
Define qué filas puede ver cada usuario dependiendo de:

- Su rol
- El departamento médico asignado
- Su identificador de médico

**Ejemplo de variables de sesión utilizadas por RLS:**
```sql
SET app.departamento = '3';
SET app.id_medico = '12';
```

Esto asegura visibilidad condicionada y personalizada.

---

## Procedimientos y Triggers

### Procedimientos almacenados

#### `registrar_ingreso()`
Verifica disponibilidad de habitación, crea el ingreso y cambia su estado a "Ocupada".

#### `dar_alta_paciente()`
Registra la salida y libera la habitación automáticamente.

#### `agregar_tratamiento()`
Añade un tratamiento al historial de un ingreso.

### Triggers

- **Auditoría de ingresos**: registra cambios importantes en formato JSON.
- **Validación de disponibilidad**: evita que dos pacientes ocupen la misma habitación.

Estos mecanismos fortalecen la lógica del sistema y reducen errores humanos o de aplicación.

---

## Beneficios del Diseño

- Integridad alta gracias a FK, PK, CHECK y restricciones.
- Protección de datos sensibles mediante RLS.
- Modelo escalable que permite agregar nuevos módulos.
- Auditoría incorporada para trazabilidad completa.
- Diseño fiel a la operación hospitalaria.

---

## Conclusión

El diseño de la base de datos **Hospital BD** ofrece una estructura segura, consistente y extensible.  
Mediante el uso de normalización, seguridad por roles, RLS y auditoría, se garantiza el cumplimiento de buenas prácticas profesionales y académicas.

La arquitectura presentada está preparada para ampliarse hacia módulos más avanzados como historias clínicas, turnos del personal, facturación médica y más.

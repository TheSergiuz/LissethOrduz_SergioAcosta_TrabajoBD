
SELECT 
    m.id_medico,
    CONCAT(m.nombre, ' ', m.apellidos) AS medico,
    COUNT(c.id_cita) AS total_citas,
    GROUP_CONCAT(CONCAT(p.nombre, ' ', p.apellidos) SEPARATOR ', ') AS pacientes_atendidos
FROM medicos m
LEFT JOIN citas c ON m.id_medico = c.id_medico
LEFT JOIN pacientes p ON c.id_paciente = p.id_paciente
GROUP BY m.id_medico;



SELECT 
    h.numero AS habitacion,
    h.tipo,
    p.nombre AS paciente,
    p.apellidos AS paciente_apellidos,
    i.fecha_ingreso,
    i.diagnostico
FROM habitaciones h
INNER JOIN ingresos i ON h.id_habitacion = i.id_habitacion
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE h.estado = 'Ocupada';



SELECT 
    p.id_paciente,
    CONCAT(p.nombre, ' ', p.apellidos) AS paciente,
    SUM(t.costo) AS costo_total_tratamientos
FROM pacientes p
INNER JOIN ingresos i ON p.id_paciente = i.id_paciente
INNER JOIN historial_tratamientos ht ON i.id_ingreso = ht.id_ingreso
INNER JOIN tratamientos t ON ht.id_tratamiento = t.id_tratamiento
GROUP BY p.id_paciente
ORDER BY costo_total_tratamientos DESC;



SELECT 
    m.id_medicamento,
    m.nombre AS medicamento,
    SUM(rd.cantidad) AS total_unidades_recetadas
FROM medicamentos m
INNER JOIN receta_detalle rd ON m.id_medicamento = rd.id_medicamento
INNER JOIN recetas r ON rd.id_receta = r.id_receta
GROUP BY m.id_medicamento
ORDER BY total_unidades_recetadas DESC;



SELECT 
    d.nombre AS departamento,
    COUNT(i.id_ingreso) AS total_ingresos,
    AVG(DATEDIFF(i.fecha_salida, i.fecha_ingreso)) AS promedio_estancia_dias
FROM departamentos d
LEFT JOIN habitaciones h ON d.id_departamento = h.id_departamento
LEFT JOIN ingresos i ON h.id_habitacion = i.id_habitacion
GROUP BY d.id_departamento
ORDER BY total_ingresos DESC;


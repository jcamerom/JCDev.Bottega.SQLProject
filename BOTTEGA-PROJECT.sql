-- 1) Crear tablas:

-- Crear la tabla de Estudiantes
CREATE TABLE Students (
    student_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL
);

-- Crear la tabla de Cursos
CREATE TABLE Courses (
    course_id NUMBER PRIMARY KEY,
    course_name VARCHAR2(100) NOT NULL,
    credits NUMBER NOT NULL
);

-- Crear la tabla de Profesores
CREATE TABLE Professors (
    professor_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL
);

-- Crear la tabla de Calificaciones
CREATE TABLE Grades (
    grade_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    course_id NUMBER NOT NULL,
    professor_id NUMBER NOT NULL,
    grade NUMBER CHECK (grade>= 0 AND grade<=10),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);


-- 2) Crear otras claves externas:
-- Agregar course_id y professor_id como columnas en la tabla de Students:
ALTER TABLE Students 
ADD (professor_id NUMBER, course_id NUMBER);

-- Añadir restriccione para que sean claves foráneas:
ALTER TABLE Students
ADD CONSTRAINT std_pid_fk
FOREIGN KEY (professor_id) REFERENCES Professors(professor_id);

ALTER TABLE Students
ADD CONSTRAINT std_cid_fk
FOREIGN KEY (course_id) REFERENCES Courses(course_id);

-- Agregar course_id a la tabla Professors:
ALTER TABLE Professors
ADD course_id NUMBER;

-- Añadir restricción como clave foránea:
ALTER TABLE Professors
ADD CONSTRAINT prf_cid_fk
FOREIGN KEY (course_id) REFERENCES Courses(course_id);


-- 3) Introducir datos:
-- Insertar datos en la tabla de Cursos
INSERT INTO Courses (course_id, course_name, credits) VALUES (1, 'Matemáticas', 3);
INSERT INTO Courses (course_id, course_name, credits) VALUES (2, 'Historia', 3);
INSERT INTO Courses (course_id, course_name, credits) VALUES (3, 'Ciencias de la Computación', 4);

-- Insertar datos en la tabla de Profesores
INSERT INTO Professors (professor_id, first_name, last_name, email, course_id) VALUES (1, 'Luis', 'Fernández', 'luis.fernandez@example.com', 1);
INSERT INTO Professors (professor_id, first_name, last_name, email, course_id) VALUES (2, 'Elena', 'Ruiz', 'elena.ruiz@example.com', 2);
INSERT INTO Professors (professor_id, first_name, last_name, email, course_id) VALUES (3, 'Pedro', 'Sánchez', 'pedro.sanchez@example.com', 3);

-- Insertar datos en la tabla de Estudiantes
INSERT INTO Students (student_id, first_name, last_name, email, professor_id, course_id) VALUES (1, 'Juan', 'Pérez', 'juan.perez@example.com', 1, 1);
INSERT INTO Students (student_id, first_name, last_name, email, professor_id, course_id) VALUES (2, 'María', 'López', 'maria.lopez@example.com', 2, 2);
INSERT INTO Students (student_id, first_name, last_name, email, professor_id, course_id) VALUES (3, 'Carlos', 'García', 'carlos.garcia@example.com', 3, 3);
INSERT INTO Students (student_id, first_name, last_name, email, professor_id, course_id) VALUES (4, 'Ana', 'Martínez', 'ana.martinez@example.com', 1, 1);
INSERT INTO Students (student_id, first_name, last_name, email, professor_id, course_id) VALUES (5, 'Luis', 'Torres', 'luis.torres@example.com', 2, 2);

-- Insertar datos en la tabla de Calificaciones
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (1, 1, 1, 1, 9);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (2, 1, 2, 2, 8);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (3, 1, 3, 3, 10);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (4, 2, 1, 1, 6);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (5, 2, 2, 2, 5);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (6, 2, 3, 3, 7);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (7, 3, 1, 1, 9);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (8, 3, 2, 2, 5);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (9, 3, 3, 3, 7);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (10, 4, 1, 1, 4);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (11, 4, 2, 2, 8);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (12, 4, 3, 3, 6);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (13, 5, 1, 1, 3);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (14, 5, 2, 2, 9);
INSERT INTO Grades (grade_id, student_id, course_id, professor_id, grade) VALUES (15, 5, 3, 3, 7);


-- 4) Consultas:
-- a. Nota media de cada profesor:
SELECT p.first_name, p.last_name, AVG(g.grade)
FROM Grades g
JOIN Professors p
ON g.professor_id = p.professor_id
GROUP BY p.first_name, p.last_name;

-- b. Las mejores notas de cada estudiante:
SELECT s.first_name, s.last_name, MAX(g.grade)
FROM Students s
JOIN Grades g
ON s.student_id = g.student_id
GROUP BY s.first_name, s.last_name;

-- c. Ordenar los estudiantes por los cursos inscritos:
SELECT s.first_name, s.last_name, c.course_name
FROM Courses c
JOIN Students s
ON c.course_id = s.course_id
ORDER BY c.course_name;

-- d. Ordenar cursos y promedio de calificaciones, de menor a mayor nota:
SELECT c.course_name, AVG(g.grade)
FROM Courses c
JOIN Grades g
ON c.course_id = g.course_id
GROUP BY c.course_name;

-- e. Encontrar qué estudiante y profesor tienen más cursos en común:
SELECT s.first_name, s.last_name, p.first_name, p.last_name, COUNT(s.course_id) AS common
FROM Students s
JOIN Professors p
ON s.professor_id = p.professor_id
GROUP BY s.first_name, s.last_name, p.first_name, p.last_name
ORDER BY common DESC
FETCH FIRST 1 ROWS ONLY;



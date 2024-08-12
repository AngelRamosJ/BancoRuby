-- -----------------------------------------------------
-- USUARIO, PRIVILEGIOS Y ROLES
-- -----------------------------------------------------

create role BANCOMANAGER;
grant create session, create table, create any sequence, create view, create public synonym, create any trigger to BANCOMANAGER;

create user angel identified by 123 default tablespace users;

grant BANCOMANAGER to angel;
alter user angel quota unlimited on users;

-- -----------------------------------------------------
-- TABLA PAISES
-- -----------------------------------------------------

CREATE TABLE paises (
  id NUMBER(4) GENERATED ALWAYS AS IDENTITY,
  nombre VARCHAR2(50) NOT NULL,
  descripcion VARCHAR2(50) NOT NULL,
  CONSTRAINT PAISES_PK PRIMARY KEY (id));

-- -----------------------------------------------------
-- TABLA ESTADOS
-- -----------------------------------------------------

CREATE TABLE estados (
  id NUMBER(4) GENERATED ALWAYS AS IDENTITY,
  nombre VARCHAR2(50) NOT NULL,
  descripcion VARCHAR2(50) NOT NULL,
  pais_id NUMBER(4) NOT NULL,
  CONSTRAINT ESTADOS_PK PRIMARY KEY (id),
  CONSTRAINT ESTADOS_PAISES_FK FOREIGN KEY (pais_id) REFERENCES paises (id));

-- -----------------------------------------------------
-- TABLA LOCALIDADES
-- -----------------------------------------------------

CREATE TABLE localidades (
  id NUMBER(7) GENERATED ALWAYS AS IDENTITY,
  tipo VARCHAR2(1) NOT NULL,
  codigo_postal VARCHAR2(5) NOT NULL,
  municipio VARCHAR2(50),
  ciudad VARCHAR2(50) NOT NULL,
  colonia VARCHAR2(50) NOT NULL,
  calle VARCHAR2(50) NOT NULL,
  exterior VARCHAR2(4) NOT NULL,
  interior VARCHAR2(4),
  estado_id NUMBER(4) NOT NULL,
  CONSTRAINT LOCALIDADES_PK PRIMARY KEY (id),
  CONSTRAINT LOCALIDADES_ESTADOS_FK FOREIGN KEY (estado_id) REFERENCES estados (id));

-- -----------------------------------------------------
-- TABLA DEPARTAMENTOS
-- -----------------------------------------------------

CREATE TABLE departamentos (
  id NUMBER(5) GENERATED ALWAYS AS IDENTITY,
  nombre VARCHAR2(50) NOT NULL,
  telefono VARCHAR2(20) NOT NULL,
  maximo_empleados NUMBER(5) NOT NULL,
  fondo NUMBER(9,2) NOT NULL,
  fecha_creacion DATE NOT NULL,
  estado VARCHAR2(1) NOT NULL,
  hora_apertura VARCHAR2(5) NOT NULL,
  hora_cierre VARCHAR2(5) NOT NULL,
  localidad_id NUMBER(7) NOT NULL,
  CONSTRAINT DEPARTAMENTOS_PK PRIMARY KEY (id),
  CONSTRAINT DEPARTAMENTOS_LOCALIDADES_FK FOREIGN KEY (localidad_id) REFERENCES localidades (id));

-- -----------------------------------------------------
-- TABLA TRABAJOS
-- -----------------------------------------------------

CREATE TABLE trabajos (
  id NUMBER(4) GENERATED ALWAYS AS IDENTITY,
  nombre VARCHAR2(50) NOT NULL,
  descripcion VARCHAR2(100),
  salario_minimo NUMBER(7,2) NOT NULL,
  salario_maximo NUMBER(8,2) NOT NULL,
  estudio_minimo VARCHAR2(35) NOT NULL,
  area VARCHAR2(35) NOT NULL,
  horas NUMBER(2) NOT NULL,
  prestacion VARCHAR2(1) NOT NULL,
  CONSTRAINT TRABAJOS_PK PRIMARY KEY (id));

-- -----------------------------------------------------
-- TABLA EMPLEADOS
-- -----------------------------------------------------

CREATE TABLE empleados (
  id NUMBER(7) GENERATED ALWAYS AS IDENTITY,
  nombre VARCHAR2(50) NOT NULL,
  paterno VARCHAR2(50) NOT NULL,
  materno VARCHAR2(50) NOT NULL,
  rfc VARCHAR2(13) NOT NULL,
  curp VARCHAR2(18),
  fecha_nacimiento DATE NOT NULL,
  correo VARCHAR2(50) NOT NULL,
  telefono VARCHAR2(20),
  salario NUMBER(8,2) NOT NULL,
  fecha_contratacion DATE NOT NULL,
  bono NUMBER(8,2) NOT NULL,
  descuento NUMBER(8,2) NOT NULL,
  prestacion_dinero VARCHAR2(1) NOT NULL,
  login VARCHAR2(50) NOT NULL,
  password VARCHAR2(50) NOT NULL,
  localidad_id NUMBER(7) NOT NULL,
  departamento_id NUMBER(5) NOT NULL,
  trabajo_id NUMBER(4) NOT NULL,
  CONSTRAINT EMPLEADOS_PK PRIMARY KEY (id),
  CONSTRAINT EMPLEADOS_LOCALIDADES_FK FOREIGN KEY (localidad_id) REFERENCES localidades (id),
  CONSTRAINT EMPLEADOS_DEPARTAMENTOS_FK FOREIGN KEY (departamento_id) REFERENCES departamentos (id),
  CONSTRAINT EMPLEADOS_TRABAJOS_FK FOREIGN KEY (trabajo_id) REFERENCES trabajos (id));

-- -----------------------------------------------------
-- TABLA CLIENTES
-- -----------------------------------------------------

CREATE TABLE clientes (
  id NUMBER(8) GENERATED ALWAYS AS IDENTITY,
  nombre VARCHAR2(50) NOT NULL,
  paterno VARCHAR2(50) NOT NULL,
  materno VARCHAR2(50) NOT NULL,
  rfc VARCHAR(13),
  curp VARCHAR(18),
  fecha_nacimiento DATE NOT NULL,
  correo VARCHAR2(50),
  telefono VARCHAR2(20) NOT NULL,
  estado_laboral VARCHAR2(1) NOT NULL,
  salario_mensual NUMBER(8,2) NOT NULL,
  estudio VARCHAR2(50) NOT NULL,
  tiempo_laboral NUMBER(3) NOT NULL,
  riesgo_laboral VARCHAR2(1) NOT NULL,
  login VARCHAR2(50) NOT NULL,
  password VARCHAR2(50) NOT NULL,
  localidad_id NUMBER(7) NOT NULL,
  CONSTRAINT CLIENTES_PK PRIMARY KEY (id),
  CONSTRAINT CLIENTES_LOCALIDADES_FK FOREIGN KEY (localidad_id) REFERENCES localidades (id));

-- -----------------------------------------------------
-- TABLA PRESTAMOS
-- -----------------------------------------------------

CREATE TABLE prestamos (
  id NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  descripcion VARCHAR2(50) NOT NULL,
  cantidad NUMBER(8,2) NOT NULL,
  intereses NUMBER(5,2) NOT NULL,
  fecha_expedicion DATE NOT NULL,
  fecha_termino DATE NOT NULL,
  tiempo_tolerancia NUMBER(3) NOT NULL,
  modo_pago VARCHAR2(45) NOT NULL,
  estado VARCHAR2(1) NOT NULL,
  cliente_id NUMBER(8) NOT NULL,
  CONSTRAINT PRESTAMOS_PK PRIMARY KEY (id),
  CONSTRAINT PRESTAMOS_CLIENTES_FK FOREIGN KEY (cliente_id) REFERENCES clientes (id));

-- -----------------------------------------------------
-- TABLA DEBITOS
-- -----------------------------------------------------

CREATE TABLE debitos (
  id NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  clabe VARCHAR2(18) NOT NULL,
  numero_tarjeta VARCHAR2(16) NOT NULL,
  monto NUMBER(10,2) NOT NULL,
  monto_maximo NUMBER(10,2) NOT NULL,
  estado VARCHAR2(1) NOT NULL,
  fecha_creacion DATE NOT NULL,
  saldo_minimo NUMBER(6,2) NOT NULL,
  comision NUMBER(7,2) NOT NULL,
  seguro VARCHAR2(1) NOT NULL,
  cobro_inactividad NUMBER(6,2) NOT NULL,
  bonificacion NUMBER(6,2) NOT NULL,
  cliente_id NUMBER(8) NOT NULL,
  CONSTRAINT DEBITOS_PK PRIMARY KEY (id),
  CONSTRAINT DEBITOS_CLIENTES_FK FOREIGN KEY (cliente_id) REFERENCES clientes (id));

-- -----------------------------------------------------
-- TABLA AHORROS
-- -----------------------------------------------------

CREATE TABLE ahorros (
  id NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  clabe VARCHAR2(18) NOT NULL,
  numero_tarjeta VARCHAR2(16) NOT NULL,
  monto NUMBER(10,2) NOT NULL,
  monto_maximo NUMBER(10,2) NOT NULL,
  estado VARCHAR2(1) NOT NULL,
  fecha_creacion DATE NOT NULL,
  interes NUMBER(5,2) NOT NULL,
  impuesto_anual NUMBER(7,2) NOT NULL,
  descuento_transaccion NUMBER(6,2) NOT NULL,
  meses_cambio NUMBER(3) NOT NULL,
  limite_monto_transaccion NUMBER(8,2) NOT NULL,
  cliente_id NUMBER(8) NOT NULL,
  CONSTRAINT AHORROS_PK PRIMARY KEY (id),
  CONSTRAINT AHORROS_CLIENTES_FK FOREIGN KEY (cliente_id) REFERENCES clientes (id));

-- -----------------------------------------------------
-- TABLA CITAS
-- -----------------------------------------------------

CREATE TABLE citas (
  id NUMBER(10) GENERATED ALWAYS AS IDENTITY,
  tipo_tramite VARCHAR2(50) NOT NULL,
  motivo VARCHAR2(50) NOT NULL,
  fecha_encuentro DATE NOT NULL,
  hora_inicio VARCHAR2(5) NOT NULL,
  hora_final VARCHAR2(5) NOT NULL,
  confirmacion VARCHAR2(1) NOT NULL,
  tipo_atencion VARCHAR2(1) NOT NULL,
  observacion VARCHAR2(100) NOT NULL,
  cliente_id NUMBER(8) NOT NULL,
  departamento_id NUMBER(5) NOT NULL,
  CONSTRAINT CITAS_PK PRIMARY KEY (id),
  CONSTRAINT CITAS_CLIENTES_FK FOREIGN KEY (cliente_id) REFERENCES clientes (id),
  CONSTRAINT CITAS_DEPARTAMENTOS_FK FOREIGN KEY (departamento_id) REFERENCES departamentos (id));

-- -----------------------------------------------------
-- TABLA QUEJAS
-- -----------------------------------------------------

CREATE TABLE quejas (
  id NUMBER(10) GENERATED ALWAYS AS IDENTITY,
  motivo VARCHAR2(45) NOT NULL,
  descripcion VARCHAR2(100) NOT NULL,
  fecha_suceso DATE NOT NULL,
  tipo VARCHAR2(1) NOT NULL,
  confirmacion VARCHAR2(1) NOT NULL,
  respuesta VARCHAR2(1) NOT NULL,
  causante VARCHAR2(1) NOT NULL,
  evidencia VARCHAR2(1) NOT NULL,
  cliente_id NUMBER(8) NOT NULL,
  CONSTRAINT QUEJAS_PK PRIMARY KEY (id),
  CONSTRAINT QUEJAS_CLIENTES_FK FOREIGN KEY (cliente_id) REFERENCES clientes (id));

-- -----------------------------------------------------
-- TABLA TRANSACCIONES
-- -----------------------------------------------------

CREATE TABLE transacciones (
  id NUMBER(10) NOT NULL,
  monto_nuevo NUMBER(8,2) NOT NULL,
  monto_anterior NUMBER(8,2) NOT NULL,
  fecha_creacion DATE NOT NULL,
  mes NUMBER(3) NOT NULL,
  hora_creacion VARCHAR2(5) NOT NULL,
  tipo_envio VARCHAR2(1) NOT NULL,
  clabe_origen VARCHAR2(18) NOT NULL,
  clabe_destino VARCHAR2(18),
  tarjeta_destino VARCHAR2(16),
  cliente_id NUMBER(8) NOT NULL,
  CONSTRAINT TRANSACCIONES_PK PRIMARY KEY (id),
  CONSTRAINT TRANSACCIONES_CLIENTES_FK FOREIGN KEY (cliente_id) REFERENCES clientes (id));

-- -----------------------------------------------------
-- SELECT
-- -----------------------------------------------------

SELECT mes,SUM(monto_anterior - monto_nuevo) FROM transacciones WHERE clabe_destino is NOT NULL GROUP BY mes; 

SELECT e.nombre, COUNT(c.nombre) FROM clientes c JOIN localidades l ON c.localidad_id = l.id JOIN estados e ON l.estado_id = e.id GROUP BY e.nombre;  

-- -----------------------------------------------------
-- TABLAS HISTORIAL
-- -----------------------------------------------------

CREATE TABLE emp_log(
	id NUMBER(8) GENERATED ALWAYS AS IDENTITY,
	nombre VARCHAR2(50) NOT NULL,
	paterno VARCHAR2(50) NOT NULL,
	materno VARCHAR2(50) NOT NULL,
	rfc VARCHAR2(13) NOT NULL,
	fecha_contratacion DATE NOT NULL,
	salario NUMBER(8,2) NOT NULL,
	nombre_trabajo VARCHAR2(50),
	nombre_departamento VARCHAR2(50),
	log_date DATE,
	CONSTRAINT EMP_LOG_PK PRIMARY KEY(id)
);

CREATE TABLE cliente_localidad_log(
  id NUMBER(8) GENERATED ALWAYS AS IDENTITY,
  tipo VARCHAR2(1) NOT NULL,
  codigo_postal VARCHAR2(5) NOT NULL,
  ciudad VARCHAR2(50) NOT NULL,
  colonia VARCHAR2(50) NOT NULL,
  calle VARCHAR2(50) NOT NULL,
  exterior VARCHAR2(4) NOT NULL,
  estado VARCHAR2(50),
  pais VARCHAR2(50),
  log_date DATE,
  CONSTRAINT CLIENTE_LOCALIDAD_LOG_PK PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- TRIGGERS
-- -----------------------------------------------------

CREATE OR REPLACE TRIGGER log_emp_delete
	BEFORE DELETE ON empleados
	FOR EACH ROW
	DECLARE
		nombre_t VARCHAR2(50);
		nombre_d VARCHAR2(50);	
	BEGIN
		SELECT nombre INTO nombre_t FROM trabajos WHERE :OLD.trabajo_id = id;
		SELECT nombre INTO nombre_d FROM departamentos WHERE :OLD.departamento_id = id;
		INSERT INTO emp_log(nombre,paterno,materno,rfc,fecha_contratacion,salario,nombre_trabajo,nombre_departamento,log_date) VALUES(:OLD.nombre,:OLD.paterno,:OLD.materno,:OLD.rfc,:OLD.fecha_contratacion,:OLD.salario,nombre_t,nombre_d,SYSDATE);
	END;
/

CREATE OR REPLACE TRIGGER log_cliente_update
	AFTER UPDATE ON clientes
	FOR EACH ROW
	WHEN (NEW.localidad_id != OLD.localidad_id)
	DECLARE
		localidad localidades%ROWTYPE;
		estado VARCHAR2(50);
		pais VARCHAR2(50);	
	BEGIN
		SELECT * INTO localidad from localidades WHERE :OLD.localidad_id = id; 
		SELECT nombre INTO estado FROM estados WHERE localidad.estado_id = id;
		SELECT p.nombre INTO pais FROM estados e, paises p WHERE localidad.estado_id = e.id AND e.pais_id = p.id;
 
		INSERT INTO cliente_localidad_log(tipo,codigo_postal,ciudad,colonia,calle,exterior,estado,pais,log_date) VALUES(localidad.tipo,localidad.codigo_postal,localidad.ciudad,localidad.colonia,localidad.calle,localidad.exterior,estado,pais,SYSDATE);
	END;
/

-- -----------------------------------------------------
-- SECUENCIAS
-- -----------------------------------------------------

CREATE SEQUENCE auto_increment_paises INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_estados INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_localidades INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_departamentos INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_empleados INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_trabajos INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_clientes INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_prestamos INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_quejas INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_citas INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_ahorros INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_debitos INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE auto_increment_transacciones INCREMENT BY 1 NOCYCLE;

-- -----------------------------------------------------
-- SINONIMOS
-- -----------------------------------------------------

CREATE PUBLIC SYNONYM vista FOR angel.vistadebitos;

-- -----------------------------------------------------
-- VISTAS
-- -----------------------------------------------------

CREATE VIEW vistadebitos AS SELECT clabe, numero_tarjeta, monto, estado, nombre, paterno, materno FROM clientes c, debitos d WHERE c.id = d.cliente_id;

-- -----------------------------------------------------
-- TABLA DROPS
-- -----------------------------------------------------

DROP TABLE empleados;
DROP TABLE quejas;
DROP TABLE citas;
DROP TABLE ahorros;
DROP TABLE debitos;
DROP TABLE prestamos;
DROP TABLE clientes;

-- -----------------------------------------------------
-- TABLA DELETE
-- -----------------------------------------------------

delete from empleados;

GENERATED ALWAYS AS IDENTITY


-- -----------------------------------------------------
-- TABLA ALTER
-- -----------------------------------------------------

alter table clientes drop constraint CLIENTES_LOCALIDADES_FK;
alter table clientes drop column localidad_id;
alter table clientes add salario_mensual NUMBER(8,2) NOT NULL;
alter table clientes add estudio VARCHAR2(50) NOT NULL;
alter table clientes add tiempo_laboral NUMBER(3) NOT NULL;
alter table clientes add riesgo_laboral VARCHAR2(1) NOT NULL;
alter table clientes add login VARCHAR2(50) NOT NULL;
alter table clientes add password VARCHAR2(50) NOT NULL;
alter table clientes add localidad_id NUMBER(7) NOT NULL;
alter table clientes add constraint CONSTRAINT CLIENTES_LOCALIDADES_FK FOREIGN KEY (localidad_id) REFERENCES localidades (id);

alter table paises modify id drop identity;
alter table estados modify id drop identity;
alter table localidades modify id drop identity;
alter table departamentos modify id drop identity;
alter table trabajos modify id drop identity;
alter table empleados modify id drop identity;
alter table clientes modify id drop identity;
alter table prestamos modify id drop identity;
alter table quejas modify id drop identity;
alter table citas modify id drop identity;
alter table ahorros modify id drop identity;
alter table debitos modify id drop identity;

alter table trabajos modify salario_minimo NUMBER(7,2) NOT NULL;

-- -----------------------------------------------------
-- INSERT
-- -----------------------------------------------------
INSERT INTO paises(nombre,descripcion) values('Mexico','MX');
INSERT INTO estados(nombre,descripcion,pais_id) values('Michoacan','MH',1);
INSERT INTO localidades(tipo,codigo_postal, municipio, ciudad, colonia, calle, exterior, interior, estado_id) values('U',61512,'Morelia','Morelia','Agua Nueva','El Mirador',602,2,2);
INSERT INTO departamentos(nombre, telefono, maximo_empleados, fondo, fecha_creacion, estado, hora_apertura, hora_cierre, localidad_id) 
values('Finanzas','7224567895',88,55001,TO_DATE('11/03/2021','dd/mm/yyyy'),'A','07:00','19:00',2);
INSERT INTO trabajos(nombre, descripcion, salario_minimo, salario_maximo, estudio_minimo, area, horas, prestacion)
values('Contador','El individuo se encargará de revisar los ingresos y egresos',13000,25000,'Licenciatura','Finanzas',8,'S');
INSERT INTO empleados(nombre, paterno, materno, rfc, curp, fecha_nacimiento, correo, telefono, salario, fecha_contratacion, bono, descuento, prestacion_dinero, login, password,localidad_id,departamento_id,trabajo_id)
values('Maria','Gonzalez','Perez','MAGP012345LS2','MAGP012345MMNHMEA9',TO_DATE('23/12/1995','dd/mm/yyyy'),'maria@gmail.com','7221453623',20000.45,TO_DATE('23/12/1995','dd/mm/yyyy'),1000,500,'S','Maria','maria1234',2,1,2);

INSERT INTO transacciones(monto_nuevo,monto_anterior,fecha_creacion,mes,hora_creacion,tipo_envio,clave_origen,clabe_destino,tarjeta_destino,cliente_id)
values()

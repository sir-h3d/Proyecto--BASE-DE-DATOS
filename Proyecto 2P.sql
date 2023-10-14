CREATE DATABASE if not exists g4;  
USE g4; 
CREATE TABLE oficina 
( idOficina INT, idDireccion INT ); 
CREATE TABLE direccion 
( idDireccion INT, calle VARCHAR(40), villa CHAR(6), manzana CHAR(6), referencia VARCHAR(40) ); 
CREATE TABLE departamento
 ( nombre VARCHAR(10), idOficina INT, tipo VARCHAR(40) ); 
CREATE TABLE persona 
( cedula VARCHAR(10), nombre VARCHAR(30), apellido VARCHAR(30), correo VARCHAR(30), telefono CHAR(10), edad INT, sexo CHAR(1) ); 
CREATE TABLE empleado
 ( cedula VARCHAR(10), sueldo FLOAT, jefe VARCHAR(10), departamento VARCHAR(10) ); 
CREATE TABLE cliente
 ( cedula VARCHAR(10), numTarjetaCredito VARCHAR(20) ); 
CREATE TABLE operador
 ( idOperador VARCHAR(10), numExtension VARCHAR(15) ); 
CREATE TABLE conductor
 ( licencia VARCHAR(10), disponibilidad BOOLEAN ); 
CREATE TABLE vehiculo 
( placa VARCHAR(10), conductor VARCHAR(10), modelo VARCHAR(30), marca VARCHAR(30), numAsientos INT ); 
CREATE TABLE carrera 
( idCarrera INT, fecha DATE, ruta INT, hora INT, chofer VARCHAR(10), operador VARCHAR(10), cliente VARCHAR(10) ); 
CREATE TABLE ruta 
( idRuta INT, puntoInicio VARCHAR(40), puntoLlegada VARCHAR(40) ); 
CREATE TABLE hora 
( idHora INT, horaInicio TIME, horaLlegada TIME ); 
CREATE TABLE transaccion 
( idTransaccion INT, carrera INT, monto FLOAT, fechaEmision DATETIME ); 
CREATE TABLE anulacion 
( idAnulacion INT, porcentaje FLOAT, motivo VARCHAR(40) ); 
CREATE TABLE pago 
( idPago INT, tipo VARCHAR(40) ); 

 ALTER TABLE direccion ADD CONSTRAINT pkDireccion PRIMARY KEY (idDireccion),
 MODIFY COLUMN calle varchar(40) not null, MODIFY COLUMN villa char(6) not null, 
 MODIFY COLUMN manzana char(6) not null, MODIFY COLUMN referencia varchar(49) null DEFAULT '---'; 
 
 ALTER TABLE oficina 
 ADD CONSTRAINT pkOficina PRIMARY KEY (idOficina), 
 ADD CONSTRAINT direccion FOREIGN KEY (idDireccion) REFERENCES direccion (idDireccion); 
 
 ALTER TABLE departamento 
 ADD CONSTRAINT pkDepartamento PRIMARY KEY (nombre), 
 ADD CONSTRAINT oficina FOREIGN KEY (idOficina) REFERENCES oficina (idOficina), 
 MODIFY COLUMN tipo varchar(30) not null; 
 
 ALTER TABLE persona ADD CONSTRAINT pkPersona PRIMARY KEY (cedula), 
 MODIFY COLUMN nombre varchar(30) not null, 
 MODIFY COLUMN apellido varchar(30) not null, 
 MODIFY COLUMN correo varchar(30) not null, 
 MODIFY COLUMN telefono char(10) not null, 
 MODIFY COLUMN edad int not null, ADD CHECK (edad>=18), 
 modify column sexo char(1) null DEFAULT '-'; 
 
 ALTER TABLE empleado 
 ADD CONSTRAINT pkEmpleado PRIMARY KEY (cedula); 
 
 ALTER TABLE empleado 
 ADD CONSTRAINT fkPersona FOREIGN KEY (cedula) REFERENCES persona (cedula), 
 MODIFY COLUMN sueldo float not null, 
 ADD CONSTRAINT jefe FOREIGN KEY (jefe) REFERENCES empleado (cedula), 
 ADD CONSTRAINT departamento FOREIGN KEY (departamento) REFERENCES departamento (nombre); 
 
 ALTER TABLE operador 
 ADD CONSTRAINT pkOperador PRIMARY KEY (idOperador), 
 ADD CONSTRAINT fkEmpleado FOREIGN KEY (idOperador) REFERENCES empleado (cedula), 
 MODIFY COLUMN numExtension int not null; 
 
 ALTER TABLE conductor 
 ADD CONSTRAINT pkConductor2 PRIMARY KEY (licencia), 
 ADD CONSTRAINT fkEmpleado2 FOREIGN KEY (licencia) REFERENCES empleado (cedula), 
 MODIFY COLUMN disponibilidad boolean DEFAULT true; 
 
 ALTER TABLE vehiculo 
 ADD CONSTRAINT pkVehiculo primary key (placa), 
 ADD CONSTRAINT conductor FOREIGN KEY (conductor) REFERENCES conductor (licencia), 
 MODIFY COLUMN modelo varchar(30) not null, 
 MODIFY COLUMN marca varchar(30) not null, 
 MODIFY COLUMN numAsientos int not null DEFAULT 5; 
 
 ALTER TABLE cliente ADD CONSTRAINT pkCliente3 PRIMARY KEY (cedula), 
 ADD CONSTRAINT fkPersona3 FOREIGN KEY (cedula) REFERENCES persona (cedula), 
 MODIFY COLUMN numTarjetaCredito varchar(16) null unique;
 
 ALTER TABLE ruta ADD CONSTRAINT pkRuta PRIMARY KEY (idRuta), 
 MODIFY COLUMN puntoInicio varchar(40) not null, 
 MODIFY COLUMN puntoLlegada varchar(40) not null; 
 
 ALTER TABLE hora ADD CONSTRAINT pkHora PRIMARY KEY (idHora), 
 MODIFY COLUMN horaInicio time not null, 
 MODIFY COLUMN horaLlegada time not null;
 
 ALTER TABLE carrera 
 ADD CONSTRAINT pkCarrera PRIMARY KEY (idCarrera),
 MODIFY COLUMN fecha date not null,
 ADD CONSTRAINT ruta foreign key (ruta) REFERENCES ruta (idRuta), 
 ADD CONSTRAINT hora foreign key (hora) REFERENCES hora (idHora),
 ADD CONSTRAINT chofer foreign key (chofer) REFERENCES conductor (licencia),
 ADD CONSTRAINT operador foreign key (operador) REFERENCES operador (idOperador), 
 ADD CONSTRAINT cliente foreign key (cliente) REFERENCES cliente (cedula); 
 
 ALTER TABLE transaccion 
 ADD CONSTRAINT pkTransaccion primary key (idTransaccion), 
 ADD CONSTRAINT fkCarrera foreign key (carrera) REFERENCES carrera (idCarrera), 
 MODIFY COLUMN monto float not null, MODIFY COLUMN fechaEmision date not null;
 
 ALTER TABLE anulacion 
 ADD CONSTRAINT pkAnulacion PRIMARY KEY (idAnulacion), 
 ADD CONSTRAINT fkTransaccion FOREIGN KEY (idAnulacion) REFERENCES transaccion (idTransaccion), 
 MODIFY COLUMN porcentaje float not null, 
 MODIFY COLUMN motivo varchar(20) DEFAULT '---'; 
 
 ALTER TABLE pago 
 ADD CONSTRAINT pkPago4 PRIMARY KEY (idPago), 
 ADD CONSTRAINT fkTransaccion4 FOREIGN KEY (idPago) REFERENCES transaccion (idTransaccion),
 MODIFY COLUMN tipo varchar(10) not null;
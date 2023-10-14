use g4;

-- inserts
insert into persona values
	('0958761061', 'KARLA', 'MACAS', 'km@email.com', '0964222939', 21, 'M'),
    ('0953421062', 'MATIAS', 'BELLO', 'mb@email.com', '0963331938', 18, 'H'),
    ('0957771063', 'JOHAN', 'VILLA', 'jv@email.com', '0964444493', 19, 'H'),
    ('0950001064', 'MARCOS', 'POLOS', 'mp@email.com', '0964888936', 30, 'H'),
    ('0951111065', 'LEON', 'PEREZ', 'lp@email.com', '0969991935', 60, 'H'),
    ('0952221066', 'ANDREA', 'ROJAS', 'ar@email.com', '0960901934', 55, 'M');
insert into cliente values
	('0958761061', 4000123456789010),
    ('0953421062', 5000246810121411),
    ('0957771063', 6000987654321012);
    
    -- error
insert into empleado values
	('0950001064', 500.25, '0951111065',1),
    ('0951111065', 1000.50, '0951111066', 1),
    ('0952221066', 450.00, '0951111067', 1);
insert into direccion values
	(1,'MANZANARES','1','1','PARALELO AL CENTRO COMERCIAL LA LUPITA'),
    (2,'BOZQUEZ','2','2','EN DIRECCION A LA PELUQUERIA PELON'),
    (3,'MANZANARES','3','3','FRENTE A MCDONALDS');
insert into oficina values
	(1, 3),
    (2, 1),
    (3, 2);
insert into departamento values
	('ENIAC', 1, 'TRANSPORTE'),
    ('MARK', 2, 'SISTEMAS'),
    ('PONTIAC', 3, 'CONTABILIDAD');
    
    -- error
insert into operador value
	('0950001064', 123);
    -- error
    
insert into conductor value
	('0952221066', false);
    -- error
    
insert into vehiculo value
	('AAC-0123', '0952221066', 'AVEO', 'CHEVROLET', 4);
insert into ruta values
	(1, 'MALL DEL SOL', 'SAN MARINO'),
    (2, 'SAMBOCITY', 'CASA LAGUNA'),
    (3, 'MALECON 2000', 'GUAYARTE');
insert into hora values
	(1, '9:00','9:30'),
    (2, '10:00','10:10'),
    (3, '20:00','20:45');
    
    -- error
insert into carrera values
	(1, date('2022-01-01 09:00:00'), 1, 1, '0952221066', '0950001064', '0958761061'),
    (2, date('2022-02-02 10:00:00'), 2, 2, '0952221066', '0950001064', '0953421062'),
    (3, date('2022-03-03 20:00:00'), 3, 3, '0952221066', '0950001064', '0957771063'),
	(4, date('2022-01-01 09:00:00'), 1, 1, '0952221066', '0950001064', '0958761061'),
    (5, date('2022-02-02 10:00:00'), 2, 2, '0952221066', '0950001064', '0953421062'),
    (6, date('2022-03-03 20:00:00'), 3, 3, '0952221066', '0950001064', '0957771063'),
	(7, date('2022-01-02 09:00:00'), 1, 1, '0952221066', '0950001064', '0958761061'),
    (8, date('2022-02-02 10:00:00'), 2, 2, '0952221066', '0950001064', '0958761061'),
    (9, date('2022-03-03 20:00:00'), 3, 3, '0952221066', '0950001064', '0958761061');
    
    -- error
insert into transaccion values
	(1, 1, 5.25, date('2022-01-01 09:00:00')),
    (2, 2, 2.50, date('2022-02-02 10:00:00')),
    (3, 3, 6.00, date('2022-03-03 20:00:00')),
	(4, 4, 5.25, date('2022-01-01 09:00:00')),
    (5, 5, 2.50, date('2022-02-02 10:00:00')),
    (6, 6, 6.00, date('2022-03-03 20:00:00')),
	(7, 7, 5.25, date('2022-01-02 09:00:00')),
    (8, 8, 2.50, date('2022-02-02 10:00:00')),
    (9, 9, 6.00, date('2022-03-03 20:00:00'));
    
-- error
insert into pago values
	(1,'DEPOSITO'),
    (2,'TARJETA DE CREDITO'),
    (3,'EFECTIVO');
delete from anulacion;

/*
CONSULTA 1:
	Presentar el nombre y apellido de los 5 clientes que más carreras han anulado
*/
select tb.nombre, tb.apellido from 
	(select p.nombre, p.apellido, sum(idAnulacion) as cantidadAnulaciones from persona p
	join cliente cl using (cedula)
	join carrera ca on (cl.cedula = ca.cliente)
	join transaccion tr on (ca.idCarrera = tr.carrera)
	join anulacion an on (tr.idTransaccion = an.idAnulacion)
	group by cedula
    order by cantidadAnulaciones desc
    limit 5) tb;
/*
CONSULTA 2
	Total de pagos por anio y por mes
*/
select year(fechaEmision) as anio, month(fechaEmision) as mes, sum(monto) as total from transaccion
       group by year(fechaEmision), month(fechaEmision)
	   order by year(fechaEmision), month(fechaEmision);
/*
CONSULTA 3
	Mostrar datos de todos los vehiculos de modelo AVEO
*/
select * from vehiculo where modelo like 'AVEO';
/*
DISPARADOR
	Crear una tabla de resumenes de pago el cual se registra anio, mes, y el valor total en carreras. 
    Crear un disparador para cuando se realice un pago se actualice el valor en el anio y mes indicado
*/
create table resumenPago (
    anio year,
    mes varchar(15),
    valorTotal float
);
alter table resumenPago
	add constraint pkResumen primary key (anio,mes),
	modify column valorTotal float not null;

delimiter ||
create trigger tgr_aggResumenPago after insert on transaccion for each row
begin
	set @val = (select count(tb.xd) 
                from (select anio, mes as xd 
					  from resumenPago 
					  where anio = year(new.fechaEmision) and mes = month(new.fechaEmision)) tb);
	if @val = 0 then
		insert into resumenPago values (year(new.fechaEmision), month(new.fechaEmision), new.monto);
	elseif @val = 1 then
    	update resumenPago
		set valorTotal = valorTotal + new.monto
		where anio = year(new.fechaEmision) and mes = month(new.fechaEmision);
    end if;
end;
||
delimiter ;

-- TABLAS A UTILIZAR: PERSONA, CLIENTE, ANULACION, TRANSACCION, VEHICULO
/*
PROCEDIMIENTO 1 - create (tabla Persona)
*/
Delimiter $$
Create procedure ingresar_datos_persona(in cedula varchar(10),in nombre varchar(30), in apellido varchar(30), 
in correo varchar(30), in telefono char(10), in edad int, in sexo char(1), out resultado boolean)
Begin
	if cedula like '09%' then
		set resultado = false;
	else
		insert into persona value (cedula,nombre,apellido,correo,telefono,edad,sexo);
        set resultado = true;
	end if;
End;
$
Delimiter;
/*
PROCEDIMIENTO 2 - create (tabla Cliente)
*/
Delimiter $$
Create procedure ingresar_datos_cliente(in cedula varchar(10),in numTarjeta varchar(16), out resultado boolean)
Begin
	if isnull(numTarjeta) then
		insert into cliente value (cedula);
        set resultado = false;
	else
		insert into cliente value (cedula,numTarjeta);
        set resultado = true;
	end if;
End;
$
Delimiter;
/*
PROCEDIMIENTO 3 - create (tabla Anulacion)
*/
delimiter $$
create procedure agregarAnulacion(in idAnul int, in motiv varchar(30))
begin
	insert into anulacion value (idAnul, 0.10, motiv);
end;
$$
delimiter ;
/*
PROCEDIMIENTO 4 - create (tabla Transaccion)
*/
Delimiter $$
Create procedure ingresar_datos_transaccion(in idTransa int, in idCarrera int, in monto float, in fecha datetime, out resultado boolean)
Begin
	if fecha >= now() then
    	Insert into transaccion value (idTransa, idCarrera, monto, fecha);
        set resultado = true;
	else
		set resultado = false;
	end if;
    select resultado;
End;
$$
Delimiter ;
/*
PROCEDIMIENTO 5 - create (tabla Vehiculo)
*/
delimiter $$
create procedure validarMatriculaVehiculo(in placa varchar(10), in conductor varchar(10), in modelo varchar(30), in marca varchar(30), in numAsiento int, out resultado boolean)
begin	
	if placa like '___-____' then
		insert into vehiculo value (placa, conductor, modelo, marca, numAsiento);
        set resultado = true;
	else
		set resultado = false;
	end if;
    select resultado;
end;
$$
delimiter ;
/*
PROCEDIMIENTO 6 - delete (tabla Transaccion)
*/
delimiter $$
create procedure anularTransaccion(in idTrans int, in motiv varchar(30))
begin
	delete from transaccion where idTransaccion = idTrans;
    call agregarAnulacion(idTrans, motiv);
end;
$$
delimiter ;
/*
PROCEDIMIENTO 7 - delete (tabla Vehiculo)
*/
delimiter $$
create procedure eliminarVehiculosXAsientos(in asientos int)
begin 
	delete from vehiculo where numAsientos = asientos;
end;
$$
delimiter ;
/*
PROCEDIMIENTO 8 - delete (tabla Persona)
*/
delimiter $$
create procedure eliminarPersonaXEdad(in ed int)
begin
	delete from persona where edad = ed;
end;
$$
delimiter ;
/*
PROCEDIMIENTO 9 - delete (tabla Cliente)
*/
delimiter $$
create procedure eliminarVehiculoXMarcayModelo(in mr varchar(30), in md varchar(30))
begin
	delete from vehiculo where marca = mr and modelo = md;
end;
$$
delimiter ;
/*
PROCEDIMIENTO 10 - delete (tabla Anulacion)
*/
delimiter $$
create procedure eliminarAnulacion(in idAnul varchar(30))
begin
	delete from anulacion where idAnulacion = idAnul;
end;
$$
delimiter ;
/*
PROCEDIMIENTO 11 - read (tabla Persona)
*/
Delimiter $$
Create procedure datos_persona(in cedula varchar(10))
Begin
	select * From persona p where cedula = p.cedula;
End;
$$
Delimiter ;
/*
PROCEDIMIENTO 12 - read (tabla Cliente)
*/
Delimiter $$
Create procedure datos_cliente(in cedula varchar(10))
Begin
	Select * From cliente c where cedula = c.cedula;
End;
$$
Delimiter ;
/*
PROCEDIMIENTO 13 - read (tabla Transaccion)
*/
Delimiter $$
Create procedure datos_transaccion(in idTrans int)
Begin
	Select * From transaccion t where idTrans = t.idTransaccion;
End;
$$
Delimiter ;
/*
PROCEDIMIENTO 14 - read (tabla Vehiculo)
*/
Delimiter $$
Create procedure datos_vehiculo(in placa varchar(10))
Begin
	Select * From vehiculo v where placa = v.placa;
End;
$$
Delimiter ;
/*
PROCEDIMIENTO 15 - read (tabla Anulacion)
*/
Delimiter $$
Create procedure datos_anulacion(in idAnulacion int)
Begin
	Select * From anulacion a where idAnulacion = a.idAnulacion;
End;
$$
Delimiter ;
/*
PROCEDIMIENTO 16 - update (tabla Persona)
*/
delimiter $$
Create procedure act_NombreyApellidoPersona(in ced varchar(10), in nuevoNom varchar(15), in nuevoApe varchar(10))
Begin
	update persona 
	set nombre = nuevoNom, apellido = nuevoApe
    where cedula = ced;
End;
$$
delimiter ;
/*
PROCEDIMIENTO 17 - update (tabla Cliente)
*/
delimiter $$
Create procedure act_NumeroTarjetaCliente(in ced varchar(10), in nuevatarjeta varchar(16))
Begin
	update cliente
	set numTarjetaCredito = nuevatarjeta
    where cedula = ced;
End;
$$
delimiter ;
/*
PROCEDIMIENTO 18 - update (tabla Transaccion)
*/
delimiter $$
Create procedure act_AumentarMontoAdicionalTransaccion(in trans int, in montoAdicional float)
Begin
	update transaccion
    set monto = monto + montoAdicional
    where idTransaccion = trans;
End;
$$
delimiter ;

/*
PROCEDIMIENTO 19 - update (tabla Vehiculo)
*/
delimiter $$
Create procedure act_AsientosVehiculo(in plac varchar(10), in NAsientos int)
Begin
	update vehiculo
    set numAsientos = NAsientos
    where placa = plac;
End;
$$
delimiter ;

/*
PROCEDIMIENTO 20 - update (tabla Anulacion)
*/
delimiter $$
Create procedure act_MotivoAnulacion(in anulacion int, in newmotivo varchar(20))
Begin
	update anulacion
    set motivo = newmotivo
    where idAnulacion = anulacion;
End;
$$
delimiter ;

/*
TRANSACCIÓN
*/
delimiter $
create procedure sp_crear_pago(in id_transaccion int, in carrera int, in monto float, in FechaEmision datetime, in N_tipo varchar(10))
begin 
start transaction; 
	insert into transaccion values (id_transaccion, carrera, monto, FechaEmision);
    insert into pago values (id_transaccion, n_tipo);
    commit;
end;
$
delimiter ;

/*
VIEW
*/

create view Transacciones as
select idTransaccion, carrera, monto, fechaEmision
from transaccion;

//empleados tienen usuario y sucursal
select dp.nombre, dp.apellido_paterno, s.nombre_sucursal
from datos_personales as dp,
	empleados as e, 
	sucursales as s, 
	empleados_sucursales as es,
	usuarios_empleados as ue
where e.id_empleado=ue.id_empleado 
	and e.id_datos_personales=dp.id_datos_personales
	and e.id_empleado=es.id_empleado
	and es.id_sucursal=s.id_sucursal

//empleados NO tienen usuario
select dp.nombre, dp.apellido_paterno
from datos_personales as dp, empleados as e
left join usuarios_empleados ue
on e.id_empleado=ue.id_empleado
where ue.id_empleado is null and e.id_datos_personales=dp.id_datos_personales

//TODOS los empleados, sucursal y usuario
select dp.nombre Nombre, dp.apellido_paterno, s.nombre_sucursal, u.username, te.tipo_de_empleado
from datos_personales as dp,
	empleados as e, 
	sucursales as s, 
	empleados_sucursales as es, 
	usuarios as u, 
	usuarios_empleados as ue,
	tipos_de_empleados as te
where e.id_datos_personales=dp.id_datos_personales
	and u.id_usuario=ue.id_usuario
	and ue.id_empleado=e.id_empleado
	and e.id_empleado=es.id_empleado
	and es.id_sucursal=s.id_sucursal
	and e.id_tipo_de_empleado=te.id_tipo_de_empleado

//ejemplooooooooooooooooooooooooooooooooos

CREATE OR REPLACE PROCEDURE mySproc
(
 invoiceId IN NUMBER,  -- Added comma
 customerId IN NUMBER
)
IS
    v_id  NUMBER;  -- ADDED
BEGIN 
    INSERT INTO myTable (INVOICE_ID) 
    VALUES (invoiceId)
    returning id into v_id;

    INSERT INTO anotherTable (ID, customerID) 
    VALUES (v_id, customerId);  
END mySproc;


//Insertar
DELIMITER $$
DROP PROCEDURE IF EXIST `agenda`.`Insertar`$$
CREATE PROCEDURE `agenda`.`Insertar`(in nombre varchar(45), telefono varchar(12), email varchar(50), id_contacto int primary key)
BEGIN
/*DECLARE nombre varchar(45)*/
INSERT INTO contactos VALUES (nombre,telefono,email,id_contacto);
END $$
DELIMITER ;
 
//Borrar
DELIMITER $$
DROP PROCEDURE IF EXIST `agenda`.`Borrar`$$
CREATE PROCEDURE `agenda`.`Borrar`(in ident integer)
BEGIN
   DELETE FROM contactos id_contacto=ident;
END $$
DELIMITER ;
 
//Actualizar
DELIMITER $$
DROP PROCEDURE IF EXIST `agenda`.`Actualizar`$$
CREATE PROCEDURE `agenda`.`Actualizar`(in ident integer,ntelefono varchar(12))
BEGIN
UPDATE contactos SET telefono=ntelefono WHERE id_contacto=ident;
END $$
DELIMITER ;
 

select*from bd_factsv2.tbl_productos_facturados;
select*from bd_factsv2.tbl_productos;
select*from bd_factsv2.tbl_facturas;
describe bd_factsv2.tbl_productos;

drop procedure IF EXISTS bd_factsv2.sp_registro_productos;

DELIMITER //
create procedure bd_factsv2.sp_registro_productos(
in p_idfactura  int,
in p_idProducto int,
in p_cantidad   int
)
begin

declare  v_idproducto    int; 
declare  v_idfactura     int; 
declare  v_cantidad      int;
declare  v_impuestosobreventa decimal(12,2);
declare  v_precioVenta        decimal(12,2);
declare  v_saldoUnidades  int;

set v_idfactura        = p_idfactura;
set v_idproducto       = p_idproducto; 
set v_cantidad         = p_cantidad;

select saldoUnidades into v_saldoUnidades 
from bd_factsv2.tbl_productos where idProducto=v_idproducto;

select precioVenta into v_precioVenta 
from bd_factsv2.tbl_productos where idProducto=v_idproducto;
set v_impuestosobreventa=v_precioVenta*0.15;

/*Insertar un nuevo producto en la tabla de productos facturados para un idfactura determinada solo 
si el saldo de unidades del producto idproducto es mayor o igual a la cantidad de productos indicada. */

if v_saldoUnidades>=v_cantidad then
insert into bd_factsv2.tbl_productos_facturados
(idProducto,idFactura,cantidad,impuestosobreventa,precioVenta
                    )values (
v_idproducto,v_idfactura,v_cantidad,v_impuestosobreventa,v_precioVenta
);

/*Luego de realizar la inserción, debe actualizar el campo de saldo de unidades en la tabla productos, 
descontando la cantidad de productos registrados en el inciso anterior. */

update bd_factsv2.tbl_productos set 
saldoUnidades=saldoUnidades-v_cantidad
where idProducto=idProducto;

/*Después, debe actualizar los campos de la factura con idfactura con los nuevos valores generados con la adición del producto*/

update bd_factsv2.tbl_productos set 
cantidadProductos=cantidadProductos+v_cantidad,
subTotalPagar=subTotalPagar+v_precioVenta,
totalISV=totalISV+v_impuestosobreventa,
totalpagar=totalISV+subTotalPagar
where idFactura=v_idfactura;


end if;

commit;
end;


CALL bd_factsv2.sp_registro_productos(
'1000',                          #p_idproducto
'207',                           #p_idfactura
'1'                             #p_cantidad
);
select*from bd_factsv2.tbl_productos_facturados;

SET SQL_SAFE_UPDATES = 0;
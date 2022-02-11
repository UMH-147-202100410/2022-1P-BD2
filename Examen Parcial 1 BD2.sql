
/*La asignación de valores no es correcta. El código dará error
set @suma = 0; 
insert into @suma values 1+2; 
*/


select * from bd_facts.tbl_asesores;
select * from bd_facts.tbl_clientes;
select * from bd_facts.tbl_facturas;

#######################################################################################################
/* combinar tbl_asesores y tbl_clientes*/

select
A. idAsesor,
concat(a.nombres,' ' ,a.apellidos) Nombre, apellidos,
A. numeroID,cantClientes

from bd_facts.tbl_asesores A
left join bd_facts.tbl_clientes C
on A. idAsesor= C.idAsesor
where c. idAsesor is null

############################################################################################################
/*creear una consulta sql para obtener 
nombre de cliente, 
idfactura, 
fecha de emision 
fecha de vencimiento*/


select
A. nombrecompleto, 
A.idCliente,
E. idfactura, 
E. fechaEmision,
E .fechaVencimiento

from bd_facts.tbl_facturas E
inner join tbl_clientes A
on E. idCliente= A. idCliente
where E.fechaVencimiento between "2022-01-01" and "2022-02-28";

##################################################################################################################################################
/* Cree una transacción que realice lo siguiente:

Asignar un asesor a un cliente, actualizando el campo idasesor en la tabla clientes.
Actualizar el campo cantclientes en la tabla asesores, según la cantidad de clientes que tenga el asesor.
Necesita las variables de entrada: idasesor, idcliente.
Cuando haya terminado de crear la transacción, ejecute el código con los siguientes valores:

Al cliente 101 asigne el asesor 14.
Al cliente 128 asigne el asesor 1.*/

set @asesor=14;
set @AsigCliente=101;
set @Clientes=0;


/*Asignacion de Asesores /

UPDATE tbl_clientes set idAsesor = @asesor where idcliente = @AsigCliente;

/Actualizacion de TBL_asesores*/

select count(idAsesor) into @Clientes from tbl_clientes where idAsesor=@asesor;
update tbl_asesores set cantClientes=@Clientes where idAsesor=@asesor;
select * from tbl_asesores;



##########################################################################################################
/*Despues de ejecutada la transacción.  Haga una consulta SQL para encontrar los números id de asesores con por lo menos 4 clientes asignados. */

select A.idAsesor, count(E.cantClientes) as clientes 
from bd_facts.tbl_clientes as A
left join bd_facts.tbl_asesores as E
on A.idAsesor = E.idAsesor
group by idAsesor
having clientes >= 4













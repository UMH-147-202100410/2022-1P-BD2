select * from bd_sample.tbl_subscriptores;
select * from bd_sample.tbl_facturas;
select * from bd_sample.tbl_items_factura;
select * from bd_sample.tbl_productos;

/* Crear subscriptor */

insert into bd_sample.tbl_subscriptores (
codigo_subscriptor, nombres, apellidos)
values ("202212345", "Jon Paul", "Doe");



/* Ejecucion 1  */

set @v_id_subscriptor =  16 ;
set @v_id_factura 	  =  27;
set @v_id_producto 	  =  2 ;
set @v_cantidad		  =  2 ;
set @v_numero_items   =  0 ;
set @v_precio_prod    =  0 ;


/* Ejecucion 2  */

set @v_id_subscriptor =  16 ;
set @v_id_factura 	  =  27;
set @v_id_producto 	  =  3 ;
set @v_cantidad		  =  2 ;
set @v_numero_items   =  0 ;
set @v_precio_prod    =  0 ;



/* 1. Crear la factura 

    insert into bd_sample.tbl_facturas (
	id_factura, fecha_emision, id_subscriptor, numero_items, isv_total, subtotal, totapagar
    ) values (
	null, curdate(),@v_id_subscriptor , 0, 0, 0, 0 );

    select id_factura into @v_id_factura
    from bd_sample.tbl_facturas 
    where id_subscriptor = @v_id_subscriptor
    order by  id_factura desc ;  */
    
    
    /* 2 . Agregar Articulos*/
    
    insert into  bd_sample . tbl_items_factura (
	id_factura, id_producto, cantidad
    ) values ( @v_id_factura, @v_id_producto, @v_cantidad );
    
    
    /* 3. Actualizar Factura */
    
	select sum(cantidad) into @v_numero_items
    from bd_sample . tbl_items_factura
    where id_factura = @v_id_factura;
    
	select precio_venta into @v_precio_prod  
    from bd_sample . tbl_productos 
    where id_producto = @v_id_producto;
    
	update bd_sample . tbl_facturas 
	set numero_items = @v_numero_items,
	isv_total = (@v_precio_prod * @v_numero_items) *0.18 ,
	subtotal  = @v_precio_prod * @v_numero_items,
	totapagar = (@v_precio_prod * @v_numero_items) *1.18
    where id_factura =   @v_id_factura;
    
    commit; 
    
	select * from bd_sample.tbl_facturas
	where id_subscriptor=16
    and date_format(fecha_emision, "%Y%m")="202202"
    ;
    
    select * from tbl_facturas where id_factura= 27;
    select * from tbl_items_factura where id_factura = 27;
    
    /* eliminar facturas erroneas
	delete from tbl_facturas where id_factura = 26;
	delete from tbl_facturas where id_factura = 28;
    delete from tbl_facturas where id_factura = 29;
    
    */
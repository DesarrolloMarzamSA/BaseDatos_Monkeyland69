-- =============================================
-- Author:		mandrade
-- Create date: 10/03/2014
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_benavides_actualiza_cliente_producto] @hash_md5 varchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	--cliente sucursal
 update p set p.cliente=t.cuenta,p.sucursal=t.sucursal,p.letra=SUBSTRING(t.cliente_ibs,1,1)
--select p.cliente,p.sucursal,t.sucursal,t.cuenta,p.letra,SUBSTRING(t.cliente_ibs,1,1)
 from pedidos_fbenavides_ci p
inner join cat_sucursales_benavides t on p.cia=t.cia where p.hash_md5=@hash_md5
and t.controlados<>1 and  t.activo=1 


--letra
--update p set p.letra=s.ibs_letra
----select p.sucursal,s.sucursal,p.letra,s.ibs_letra
-- from pedidos_fbenavides_ci p
--inner join sucursales s on p.sucursal=s.sucursal where p.hash_md5=@hash_md5

--letra historia
--update p set p.letra=s.ibs_letra
----select p.sucursal,s.sucursal,p.letra,s.ibs_letra
-- from pedidos_fbenavides_ci_historia p
--inner join sucursales s on p.sucursal=s.sucursal where p.hash_md5=@hash_md5

 update p set p.codigo=pb.cod_mar,p.cod_barras=pb.cod_barras,p.descripcion=pb.descripcion
 --select p.codigo,p.cod_barras,p.cod_bena,p.descripcion,pb.cod_mar,pb.cod_barras,pb.cod_ben,pb.descripcion
  from pedidos_fbenavides_ci p
 inner join cat_productos_benavides pb on p.cod_bena=pb.cod_ben  where p.hash_md5=@hash_md5

 --update p set p.codigo=pb.cod_mar,p.cod_barras=pb.cod_barras,p.descripcion=pb.descripcion
 ----select p.codigo,p.cod_barras,p.cod_bena,p.descripcion,pb.cod_mar,pb.cod_barras,pb.cod_ben,pb.descripcion
 -- from pedidos_fbenavides_ci_historia p
 --inner join cat_productos_benavides pb on p.cod_bena=pb.cod_ben  where p.hash_md5=@hash_md5

 --Eliminacion de productos que no se deben de surtir por que las cuentas solo surte psicotropicos
-- delete p
update p set p.cliente='00000'
--select *			   
from pedidos_fbenavides_ci p 
inner join cat_sucursales_benavides c on p.cliente=c.cuenta and p.letra=c.ibs_letra
inner join capa_ibs.dbo.maestro_productos pd on p.codigo=pd.codigo
where c.activo=1 and c.sucursal in(23,24) and pd.clas_ssa not in('2','3') 
and c.cliente_ibs in('X51782','X51783','X51784','X51785','X51786','X51787','X51788',
'X51789','X51790','X51791','X51792','X51793','X51794','X51795','X51796','X51797','X51798',
'X51799','X51800','X51801','X51809','X51810','X51811','X51812','X51813','X51814','X51837',
'X51841','X51842','X51843','X51850','X51861','X51871','X51872','X51873','X51874','X51875',
'X51876','X51877','X51878','X51879','X51880','X51881','X51882','X51884','X51885','X51976','X51873') 
and CONVERT(varchar,p.timestamp,112)>=CONVERT(varchar,getdate(),112)
and p.hash_md5=@hash_md5


--actualizar productos psicotropicos
update p set p.cliente=c.cuenta,p.letra=SUBSTRING(c.cliente_ibs,0,2),
p.sucursal=c.sucursal
--select p.cliente,c.cuenta,p.letra,SUBSTRING(c.cliente_ibs,0,2),
--p.sucursal,c.sucursal
from monkeyland..pedidos_fbenavides_ci p
inner join monkeyland..cat_sucursales_benavides c on p.cia=c.cia
inner join monkeyland..productosPsicotropicos ps on p.codigo=ps.[PGPHPRDC]
where p.hash_md5=@hash_md5 
and c.controlados=1 and c.activo=1

--select * from monkeyland..pedidos_fbenavides_ci
update monkeyland..pedidos_fbenavides_ci set cliente='00000',codigo='0000000' 
where  hash_md5=@hash_md5 and cliente is null or codigo is null


END

GO


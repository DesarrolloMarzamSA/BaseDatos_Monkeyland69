
-- =============================================
-- Author:		MANDRADE	
-- Create date: 2013-11-08
-- Description:	ACTUALIZA FACTURAS MUGUERZA
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualiza_facturas_Muguerza]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @sucursal int
declare @serie varchar(50)
declare @factura varchar(50)
declare @cliente varchar(50)
declare cur_facturasMuguerza cursor forward_only for
 select factura,sucursal ,serie ,cliente from Historica.dbo.encabezado 
  where -- factura='01670487' and sucursal=7 and serie='FG' and cliente ='08893'
   fechaprog> GETDATE()-2 and ctepadre='341' order by fechaprog
open cur_facturasMuguerza
fetch from cur_facturasMuguerza into @factura, @sucursal,@serie,@cliente 
while @@FETCH_STATUS=0
begin
--print(@sucursal)
--print(@serie)
--print(@factura)
--print(@cliente )
IF (SELECT COUNT(*) FROM [monkeyland].[dbo].[facturasMuguerza]  f 
	WHERE f.sucursal=@sucursal and f.serie=@serie and  f.factura=@factura and  f.cliente =@cliente) = 0
	BEGIN
	--print('wntro')
	insert into [monkeyland].[dbo].[facturasMuguerza]
	select *,null as ruta_factura,null as nomb_factura,null as msgWeb 
		from Historica.dbo.encabezado where  factura=@factura and sucursal=@sucursal and serie=@serie and cliente =@cliente
	 end
	fetch from cur_facturasMuguerza into @factura, @sucursal,@serie,@cliente 
	end	
CLOSE cur_facturasMuguerza
DEALLOCATE cur_facturasMuguerza				
END

GO


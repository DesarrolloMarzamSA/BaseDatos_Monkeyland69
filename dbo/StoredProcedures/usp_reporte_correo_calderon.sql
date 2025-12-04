
-- =============================================
-- Author:		mandrade
-- Create date: 05/11/2015
-- Description:	reporte excel Calderon
-- =============================================
CREATE PROCEDURE [dbo].[usp_reporte_correo_calderon] @parHashesMD5 varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- usp_reporte_correo_calderon '''5ef411c301e9667f700f0b7a4d1bd454'',''5ef411c301e9667f700f0b7a4d1bd454'''
	-- select '''5ef411c301e9667f700f0b7a4d1bd454'',''5ef411c301e9667f700f0b7a4d1bd454'''
	SET NOCOUNT ON;
   
    declare @query varchar(max)
	set @query='select  t1.arch_cliente ''Archivo Cliente'',isnull(t3.descripcion, ''Desconocido'') Sucursal,  
					    t1.cliente Cliente,isnull(t1.arch_tandem, ''Desconocido'') ''Archivo de Pedido'',  
					    count(t1.codigo) ''Total Productos'',sum(t1.cant_ped) ''Total Cantidad Pedida'' 
					    from pedidos_pharmacy_calderon t1 
						left outer join maestro_productos_baan t2 on t1.codigo = t2.codigo  
					    and convert(int, t2.codigo) < dbo.gobierno()  
					    left outer join sucursales t3 on t1.sucursal = t3.sucursal  
					    where t1.codigo is not null and hash_md5 in (' + @parHashesMD5 + ') and enviado_ftp=1
					    group by t1.arch_cliente,t3.descripcion,t1.cliente,t1.arch_tandem'
				   --print(@query)
				   execute (@query)
				   execute('update pedidos_pharmacy_calderon set  enviado_ftp=2 where hash_md5 in ('+ @parHashesMD5 + ')')
				   execute('update pharmacy_lotes_calderon set  finalizado=1 where hash_md5 in ('+ @parHashesMD5 + ')')
END

GO


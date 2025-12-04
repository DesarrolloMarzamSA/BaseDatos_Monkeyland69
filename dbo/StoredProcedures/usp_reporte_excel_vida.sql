
-- =============================================
-- Author:		lafernandez
-- Create date: 20/04/2020
-- Description:	reporte excel Farmacia Vida
-- =============================================
CREATE PROCEDURE [dbo].[usp_reporte_excel_vida] @parHashesMD5 varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    declare @query varchar(max)
	set @query='select t1.arch_cliente ''Archivo Cliente'',isnull(t3.descripcion, ''Desconocido'') Sucursal, 
                   t1.cliente Cliente,t1.codigo Codigo,t2.cod_barras ''Codigo de Barras'',
				   isnull(t2.descripcion, ''Desconocido'') Descripcion,convert(varchar(20), t1.cant_ped) ''Cantidad Pedida'', 
                   isnull(convert(varchar(20), t1.cant_surt), ''No Confirmado'') ''Cantidad Surtida'',isnull(t1.arch_tandem, ''Desconocido'') ''Archivo de Pedido'' 
                   from pedidos_pharmacy_vida t1 
				   left outer join maestro_productos_baan t2 on t1.codigo = t2.codigo and convert(int, t2.codigo) < dbo.gobierno() 
                   left outer join sucursales t3 on t1.sucursal = t3.sucursal 
                   where hash_md5 in ( '+@parHashesMD5 +') and enviado_ftp=1 order by 1, 2, 3'

				   execute (@query)
END

GO


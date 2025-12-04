-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_fbenavides_destinoHH_pc 'd1baf0db0da0f6f9e8194aa255d5efe4'
-- =============================================
CREATE PROCEDURE usp_fbenavides_destinoHH_pc @hashmd5 varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT DISTINCT ped.archivo_hh, ped.arch_cliente,ped.hash_md5,ruta.sucursal, ruta.letra ,
	 ruta.volumen volumen,'IBS' facturador 
	FROM pedidos_fbenavides_ci_pc ped 
	INNER JOIN rutas_pedidos ruta ON ruta.sucursal = ped.sucursal  
	WHERE ped.estatus='2' and ped.hash_md5 in(@hashmd5) 
	ORDER BY ped.archivo_hh 
END

GO


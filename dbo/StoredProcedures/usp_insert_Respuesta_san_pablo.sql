-- =============================================
-- Author:		mandrade
-- Create date: 26/06/2015
-- Description:	insertar respuesta san pablo Aperak
-- =============================================
CREATE PROCEDURE [dbo].[usp_insert_Respuesta_san_pablo] @hashMd5 varchar(350),@aperak varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    INSERT INTO [dbo].AperakRespuestaRamaSanPablo
           ([numeroOrden],[fechaOrden],[hashMd5],[numeroLineas],[aperakRespuesta],[fechaRegistro])
	select numeroOrden,fechaOrden,hashMd5,count(distinct lineaPedido),@aperak,getdate()
	from monkeyland..[pedidoRamaSanPablo_historia] 
	where hashMd5=@hashMd5
	group by numeroOrden,fechaOrden,hashMd5
    
END

GO


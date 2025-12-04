-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_insertar_bitacora_heb @serie varchar(10),@folio_fiscal varchar(100),@documentoIbs numeric,@estatus varchar(50),@aperack varchar(max),@estatusSistema int,@tipoEnvio varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [dbo].[cfdi_envio_HEB]
			([serie],[folio_fiscal],[documentoIbs],[fechaEnvio],[estatus],[aperack],[estatusSistema],[tipoEnvio])
     VALUES (@serie,@folio_fiscal,@documentoIbs,getdate(),@estatus,@aperack,@estatusSistema,@tipoEnvio)

END

GO


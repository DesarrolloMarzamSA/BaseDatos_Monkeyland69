-- =============================================
-- Author:		mandrade
-- Create date: 26/06/2015
-- Description:	insertar aperak san pablo Ofertas
-- =============================================
CREATE PROCEDURE usp_insert_aperak_san_pablo @numeroPeticionOferta varchar(150),@numLineas int,@aperakOferta varchar(max),@estatus varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO monkeyland..[AperakOfertaRamaSanPablo] 
	([numeroPeticion],[numeroLineas],[aperakOferta],[estatus],[fechaRegistro])
     VALUES (@numeroPeticionOferta,@numLineas,@aperakOferta,@estatus,GETDATE())
END

GO


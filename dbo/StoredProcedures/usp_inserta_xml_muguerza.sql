
-- =============================================
-- Author:		Mandrade
-- Create date: 06092014
-- Description:	insertar archivos xml Muguerza
-- =============================================
CREATE PROCEDURE [dbo].[usp_inserta_xml_muguerza]
	@archivo varchar(30),@rutaArchivo varchar(max),@serie varchar(50),@folioFiscal varchar(50),@importe money,@estatus int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT off;
    select serie,folioFiscal from  [monkeyland].[dbo].[archivo_manual_muguerza] where serie=@serie and folioFiscal=@folioFiscal
	if(@@ROWCOUNT=1)
	begin
	update [monkeyland].[dbo].[archivo_manual_muguerza] set archivo=@archivo,rutaArchivo=@rutaArchivo,importe=@importe,estatus=@estatus where serie=@serie and folioFiscal=@folioFiscal
	end
	else
	begin
	INSERT INTO  [monkeyland].[dbo].[archivo_manual_muguerza] ([archivo],[rutaArchivo],[serie],[folioFiscal]
           ,[importe],[estatus],[fechaRegistro])
     VALUES (@archivo,@rutaArchivo,@serie,@folioFiscal,@importe,@estatus,getdate())
	end
END


--select * from  [monkeyland].[dbo].[archivo_manual_muguerza]

GO


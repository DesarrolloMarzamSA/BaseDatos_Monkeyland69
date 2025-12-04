-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,10-04-2018,>
-- Description:	<Description,procedimiento para hacer un update a los folios que ya estan insertados en la base de datos de casa ley de las respuestas (aperak casa ley),>
-- =============================================
create PROCEDURE [dbo].[Spr_UpdateCasaleyfolios]
@emisor nvarchar(100),
@tipo nvarchar(60),
@uuid nvarchar(200),
@folio int,
@serie nvarchar(20),
@rfcEmisor nvarchar(200),
@rfcreceptor nvarchar(200),
@valestructura nvarchar(200),
@valfolios nvarchar(200),
@valsello nvarchar(200),
@valimporte nvarchar(200),
@valdatos nvarchar(200),
@fecha date,
@estatus nvarchar(40),
@nombre nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update Casaleyxml set emisor =@emisor,
	                      tipo=@tipo,
						  uuid=@uuid,						  
						  serie=@serie,
						  rfcEmisor=@rfcEmisor,
						  rfcReceptor=@rfcreceptor,
						  ValidacionEstructura=@valestructura,
						  ValidacionFoliosCert=@valfolios,
						  ValidacionSello=@valsello,
						  ValidacionImportes=@valimporte,
						  ValidacionDatosFiscales=@valdatos,
						  Fecha=@fecha,
						  estatus=@estatus,
						  nombrearchivo=@nombre
					where folio =@folio
END

GO


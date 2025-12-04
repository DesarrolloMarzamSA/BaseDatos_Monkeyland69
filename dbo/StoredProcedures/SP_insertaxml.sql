create procedure [dbo].[SP_insertaxml]
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
as
begin
insert into Casaleyxml (emisor,tipo,uuid,folio,serie,rfcEmisor,rfcReceptor,ValidacionEstructura,ValidacionFoliosCert,ValidacionSello,ValidacionImportes,ValidacionDatosFiscales,Fecha,estatus,nombrearchivo) 
values (@emisor,@tipo,@uuid,@folio,@serie,@rfcEmisor,@rfcreceptor,@valestructura,@valfolios,@valsello,@valimporte,@valdatos,@fecha,@estatus,@nombre)
end

GO


create procedure  [dbo].[Sp_listaxmlcasaley]
as
begin

select
 detalle_casaley_xml.SUCURSAL, 
 detalle_casaley_xml.SERIE,
 detalle_casaley_xml.IDINVN,
 ca.emisor,
 ca.tipo,
 ca.uuid,
 ca.folio,
 ca.serie,
 ca.rfcEmisor,
 ca.rfcReceptor,
 ca.ValidacionEstructura,
 ca.ValidacionFoliosCert,
 ca.ValidacionSello,
 ca.ValidacionImportes,
 ca.ValidacionDatosFiscales,
 ca.Fecha,ca.estatus,
 ca.nombrearchivo
    from Casaleyxml ca 
      left join  detalle_casaley_xml  
	  on ca.serie = detalle_casaley_xml.SERIE 
        and ca.folio = detalle_casaley_xml.FACTURA
  end

GO


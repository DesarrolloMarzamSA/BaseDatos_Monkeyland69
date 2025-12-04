create procedure  [dbo].[Sp_listaxmlcasaleyweb2]
@fecha nvarchar(50),
@fecha2 nvarchar(50)
as
begin
select distinct 
    marz.FACTURA as [Factura marzam],
	 marz.SUCURSAL as Sucursal,
	  marz.IDCUNO as [Cliente],
	  casa.folio as [Folio casa ley],
	   casa.id_factura,
	    UPPER(SUBSTRING(casa.estatus,1,1)) +  LOWER(SUBSTRING (casa.estatus,2,LEN(casa.estatus)-1)) as estatus,	
		casa.serie as Serie,
		 UPPER(SUBSTRING(casa.tipo,1,1)) +  LOWER(SUBSTRING (casa.tipo,2,LEN(casa.tipo)-1)) as tipo,		
		casa.uuid,
		casa.rfcEmisor,
		casa.rfcReceptor,
		 case 
		 when casa.ValidacionEstructura  ='CFD EXISTENTE' then casa.ValidacionEstructura else SUBSTRING(casa.ValidacionEstructura,86,14) end as [Validacion estroctura],
		 case when 	 casa.ValidacionFoliosCert = 'Errores en Certificado: CERTIFICADO INCORRECTO' then  SUBSTRING(casa.ValidacionFoliosCert,25,22) when  casa.ValidacionFoliosCert = 'Errores en Certificado: SIN ERROR' then SUBSTRING(casa.ValidacionFoliosCert,25,9) else casa.ValidacionFoliosCert   end as ValidacionFoliosCert,	
	
		 casa.ValidacionSello,
		 casa.ValidacionImportes,
		 cast(marz.FECHAPROG as date) as Fecha
             from Casaleyxml casa
				inner join detalle_casaley_xml marz 
				  on casa.folio = marz.FACTURA and casa.serie = marz.SERIE
					where cast(marz.FECHAPROG as date) between @fecha and @fecha2
					order by cast(marz.FECHAPROG as date) asc
  end

GO


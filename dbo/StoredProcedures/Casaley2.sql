  create procedure [dbo].[Casaley2]
  @fecha1 nvarchar(30),
  @fecha2 nvarchar(30)
  as
  begin  
  select distinct 
    case when  cast(casa.folio as nvarchar(30)) is null then null  else casa.folio  end as [Folio casa ley],
     marz.FACTURA as [Factura marzam],marz.SUCURSAL as [Sucursal],marz.SERIE as [Serie],marz.IDCUNO as [Cliente],
    cast(marz.FECHAPROG as date) as [Fecha], marz.NOPEDIDO as [Numero pedido]
    from Casaleyxml casa      
       right join  detalle_casaley_xml marz   
        on casa.folio = marz.FACTURA-- and casa.serie = marz.SERIE
         where  cast(marz.FECHAPROG as date) BETWEEN  @fecha1  and @fecha2
		       and casa.folio is  null
			     order by Fecha asc
				 end

GO


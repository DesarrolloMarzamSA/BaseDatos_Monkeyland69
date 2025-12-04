CREATE PROCEDURE [dbo].[SP_FarmaciaGutierreztxt]
AS
BEGIN	
	SET NOCOUNT ON;
	declare @fecha date
	set @fecha = getdate()-1
        select replicate('0',7-len(ltrim(rtrim(replace(g.IDCUNO,'G','0')))))+cast(ltrim(rtrim(replace(g.IDCUNO,'G','0'))) as varchar(20)) as cliente,
		substring(g.factura,2,7) as "Folio factura",
		'000000' as "clave producto",
		replicate('0',7-len(cast(g.IDQTY as int)))+cast( cast(g.IDQTY as int) as varchar(20)) as "Cantidad facturada",
		case 
		when IEPS_MONEDA > 0.0
		then 
		replace(replicate('0',11-len(cast(g.Farmacia * 1.08 as decimal(8,2))))+cast(cast(g.Farmacia * 1.08 as decimal(8,2)) as varchar(20)),'.','') 
		else
		replace(replicate('0',11-len(cast(g.Farmacia  as decimal(8,2))))+cast(cast(g.Farmacia  as decimal(8,2)) as varchar(20)),'.','') end as "Presio facturado con IESPS",
		
		replace(replicate('0',11-len(g.DESCOFERTA))+cast(g.DESCOFERTA as varchar(30)),'.','') as Oferta,
		replace(replicate('0',11-len(g.PRECIO_CANTIDAD-g.NETO_CANTIDAD))+cast(g.PRECIO_CANTIDAD-g.NETO_CANTIDAD as varchar(30)),'.','') as Descuentos,
		case 
		when g.CF ='B' OR g.CF ='H' OR g.CF = 'F' OR g.CF='O' or g.CF='N' 
		THEN  '0000000000'
		ELSE '00'+replace(substring(replicate('0',11-len(cast((cast(g.FARMACIA-g.DESCOFERTA-(g.PRECIO_CANTIDAD-g.NETO_CANTIDAD) as decimal(8,2))*0.16) as nvarchar(30))))+cast((cast(g.FARMACIA-g.DESCOFERTA-(g.PRECIO_CANTIDAD-g.NETO_CANTIDAD) as decimal(8,2))*0.16) as nvarchar(30)),0,10),'.','') END AS "Iva mercancia",
	    --replicate('0',11 -len ( (CAST(G.TOTAL_FINAL AS VARCHAR(13)),'.','')  As "Importe",
		replace( replicate('0',11-len(cast(G.TOTAL_FINAL as nvarchar(30))))+cast( cast(G.TOTAL_FINAL as nvarchar(30)) as varchar(20)),'.','') as "Importe",												  
		replace(replicate('0',5-len(g.OFERTA))+cast(g.OFERTA as varchar(30)),'.','') as "Porcentaje oferta",
		replace(replicate('0',5-len(f.porcentaje_descto_comercial))+cast(f.porcentaje_descto_comercial as varchar(30)),'.','') as "Descuento facturado",
		case
		when 
		 len(g.PCXPRC) = 13 
		 then cast(g.PCXPRC as varchar(20))+' '   
		when len(g.PCXPRC) = 12 
		 then cast(g.PCXPRC as varchar(20)) +'  '
		when  len(g.PCXPRC) = 11
		 then    cast(g.PCXPRC as varchar(20)) +'   '
		when  CAST(g.PCXPRC AS varchar(20)) is null
		 THEN  '0000000000000' 
		 end as "Amecop",
		replace(replicate('0',11-len(cast(g.prec_pub as decimal(8,2))))+cast(cast(g.prec_pub  as decimal(8,2)) as varchar(30)),'.','')as"Precio publico del producto",
		replicate('0',10-len(g.NOPEDIDO))+cast(g.NOPEDIDO as varchar(20)) as "Orden de compra",
		replace(cast(g.FECHAPROG as date),'-','')as "fecha facturacion",
		'0000000' as "Oferta sin cargo",
		'0000000' as "Bulto donde va producto",
		LTRIM(RTRIM(g.IDCUNO)) as "cliente2",
		g.SUCURSAL
	FROM detalle_facturas_gutierrez g
		right  join facturacion_electronica_estandar f on f.factura = g.factura  and g.PCXPRC = f.cod_barras  and f.ctepadre = '963'
		where cast(g.FECHAPROG as date) = @fecha 
		order by g.factura desc 
		END

GO


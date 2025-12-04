-- =============================================
-- Author:		mandrade
-- Create date: 20-11-2015
-- Description:	obtiene facturacion Univesal
-- =============================================
CREATE PROCEDURE [dbo].[usp_facturacion_atz_D77130] @bnd int
AS
BEGIN
	-- exec [usp_facturacion_atz_D77130] 1
	SET NOCOUNT ON;

   select 
	 --*'FA',cliente,' ',replicate('0',10-len(factura)),factura,REPLICATE(' ',11),
	--codigo,REPLICATE(' ',40),replicate('0',13-len(cod_barras)),cod_barras,
	--case when p.PGPCA5 in('N','NA','O','OA') then 'NE' else 'DE' end,replicate('0',7-len(cast(piezas_surtidas_con_cargo as varchar))),cast(piezas_surtidas_con_cargo as varchar),
	--REPLICATE(' ',7),replicate('0',10-len(cast(precio_farm_sin_imp as varchar))),cast(precio_farm_sin_imp as varchar),
	--replicate('0',10-len(cast(precio_pub_sin_imp as varchar))),cast(precio_pub_sin_imp as varchar),
	--replicate('0',6-len(cast(descto_oferta as varchar))),cast(descto_oferta as varchar)
sucursal,cliente,
'FA'+cliente+' '+replicate('0',10-len(factura))+factura+REPLICATE(' ',10)+
codigo+REPLICATE(' ',40)+replicate('0',13-len(cod_barras))+cod_barras+
case when p.PGPCA5 in('N','NA','O','OA') then 'NE' else 'DE' end+replicate('0',7-len(cast(piezas_surtidas_con_cargo as varchar)))+cast(piezas_surtidas_con_cargo as varchar)+
REPLICATE(' ',7)+replicate('0',10-len(cast(precio_farm_sin_imp as varchar)))+cast(precio_farm_sin_imp as varchar)+
replicate('0',10-len(cast(precio_pub_sin_imp as varchar)))+cast(precio_pub_sin_imp as varchar)+
replicate('0',6-len(cast(descto_oferta as varchar)))+cast(descto_oferta as varchar)as factura
into #facturacionUniversal
--select *
from facturacion_electronica_estandar f
left join capa_ibs..[productoClassFiscal] p on f.codigo=p.[PGPRDC]
where  f.cliente='77130' and f.sucursal in(1,21)  and convert(varchar,f.fecha_factura,112) between convert(varchar,getdate()-25,112) and convert(varchar,getdate(),112)
order by cliente,factura,codigo

if @bnd=1
begin 
select distinct * from #facturacionUniversal
end 
else if @bnd=2
begin
select distinct f.sucursal,f.cliente,f.cliente+substring(replace(convert(varchar,getdate(),3), '/', ''),0,5)+'.DAT' as archivo
,r.ip as ip,'apadmin'as usr,r.contrasena as pwd,r.ruta
from #facturacionUniversal f
inner join rutas_facturacion_universal r on f.cliente=r.cliente and case when f.sucursal=1 then 21 else f.sucursal end =r.sucursal
order by f.sucursal
end
drop table #facturacionUniversal
END

GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [IEmbarque].[ExtraccionEmbarquePlantilla] '','0011000003' --por cliente padre
-- [IEmbarque].[ExtraccionEmbarquePlantilla] '','','R32742'-- por No Cliente
-- =============================================
CREATE PROCEDURE [IEmbarque].[ExtraccionEmbarquePlantilla] @fecha varchar(8)=null,@clientePadre varchar(11)= null,@cliente varchar(10)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @fecha is null or @fecha=''
	begin
	declare @dia int
	set @dia= DATEPART(DW, GETDATE())			 
	set @fecha=convert(varchar,getdate()- case when @dia=2 then 1 else 1 end,112) 
	end
    -- Insert statements for procedure here
	if @clientePadre !='' or  @clientePadre is null
	begin
	
	select distinct 
	f.sucursal  as  VWERK,
	f.cliente   as  [PARTNER],
	f.serie     as  XBLNR,
	f.factura   as  VBELN,
	f.fecha_factura		as  FKDAT,
	f.no_registro		as  POSNR,
	f.codigo			as  MATNR,
	f.descripcion		as  ARKTX,
	''					as  CHARG,
	p.PCXPRC		as  EAN11,
	f.clas_fis			as  KONDM,
	f.piezas_surtidas_con_cargo	as  CANTIDAD,
	f.precio_farm_sin_imp		as  PRECIOFARMACIA,
	f.precio_pub_sin_imp		as  PRECIO_PUBLICO,
	f.precio_pub_con_imp		as  PRECIO_PUBLICO_IMP,
	f.importe_bruto				as  IMPORTE_BRUTO,
	f.porcentaje_descto_oferta  as  PORCENTAJE_OFERTAS,
	f.descto_oferta				as  OFERTAS,
	f.porcentaje_descto_comercial  as  PORCENTAJE_DESCUENTOS,
	f.descto_comercial	as  DESCUENTOS,
	f.ieps				as  IEPS,
	f.iva				as  IVA,
	f.importe_neto		as  IMPORTE_NETO,
	f.orden				as  BSTKD,
	f.porcentaje_iva	as  PORC_TMX1,
	f.desc_comerc_ieps  as  PORC_TMX2,
	f.segto				as  IND_SECTOR,
	f.ctepadre			as  KNRZE,
	f.rfc				as  TAXNUM,
	''					as  IDNUMBER,
	c.cliente_ibs		as  ALTKN,
	c.farmacia			as  NAME_ORG1
	into #facturacionEstandar
	from [dbo].[facturacion_electronica_estandar] f 
	inner join clientes_baan c on f.sucursal=c.sucursal and f.cliente=c.cliente
	inner join [IEmbarque].[producto_EAN] p on f.codigo=p.PCIPRC
	where '99'+c.ctepadre=@clientePadre and convert(varchar,f.fecha_factura,112)>=@fecha
	--select '99'+ctepadre from clientes_baan
	select * from #facturacionEstandar order by VBELN
	drop table #facturacionEstandar
    print @fecha
--  print @clientePadre
end --select distinct * from  [MiddleWare].[VwDM].[MClientes]  where knrze='0011014512'
else
begin	 	
select distinct 
	f.sucursal  as  VWERK,
	f.cliente   as  [PARTNER],
	f.serie     as  XBLNR,
	f.factura   as  VBELN,
	f.fecha_factura		as  FKDAT,
	f.no_registro		as  POSNR,
	f.codigo			as  MATNR,
	f.descripcion		as  ARKTX,
	''					as  CHARG,
	p.PCXPRC		as  EAN11,
	f.clas_fis			as  KONDM,
	f.piezas_surtidas_con_cargo	as  CANTIDAD,
	f.precio_farm_sin_imp		as  PRECIOFARMACIA,
	f.precio_pub_sin_imp		as  PRECIO_PUBLICO,
	f.precio_pub_con_imp		as  PRECIO_PUBLICO_IMP,
	f.importe_bruto				as  IMPORTE_BRUTO,
	f.porcentaje_descto_oferta  as  PORCENTAJE_OFERTAS,
	f.descto_oferta				as  OFERTAS,
	f.porcentaje_descto_comercial  as  PORCENTAJE_DESCUENTOS,
	f.descto_comercial	as  DESCUENTOS,
	f.ieps				as  IEPS,
	f.iva				as  IVA,
	f.importe_neto		as  IMPORTE_NETO,
	f.orden				as  BSTKD,
	f.porcentaje_iva	as  PORC_TMX1,
	f.desc_comerc_ieps  as  PORC_TMX2,
	f.segto				as  IND_SECTOR,
	f.ctepadre			as  KNRZE,
	f.rfc				as  TAXNUM,
	''					as  IDNUMBER,
	c.cliente_ibs		as  ALTKN,
	c.farmacia			as  NAME_ORG1
	into #facturacionEstandar2
	from [dbo].[facturacion_electronica_estandar] f 
	inner join clientes_baan c on f.sucursal=c.sucursal and f.cliente=c.cliente
	inner join [IEmbarque].[producto_EAN] p on f.codigo=p.PCIPRC
	where c.cliente_ibs=@cliente and convert(varchar,f.fecha_tandem,112)>=@fecha
	select * from #facturacionEstandar2 order by VBELN
	drop table #facturacionEstandar2
  print @fecha
  print @cliente
end
end 
--select * from  [MiddleWare].[sapdo].[FacturasDevolver] f

GO


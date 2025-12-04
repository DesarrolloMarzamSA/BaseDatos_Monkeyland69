

CREATE
	--CREATE
procedure [dbo].[usp_fbenavides_pedidos_ci_faltantesHistorico] @archivo_cliente VARCHAR(300)
AS

/*
execute [usp_fbenavides_pedidos_ci_faltantesHistorico] '7168834cea0968d328415ac116909c4d'
*/
--select * from  pedidos_fbenavides_ci_historia where arch_cliente='PE20150217_175948.TXT'

BEGIN

CREATE TABLE [dbo].[faltanteBenavidesHistorico#](
	[no_prov] [varchar](2) NOT NULL,
	[suc_mzm] [varchar](2) NULL,
	[cia_ben] [varchar](4) NOT NULL,
	[alm_ben] [varchar](4) NOT NULL,
	[no_ped] [varchar](10) NULL,
	[can_fal] [varchar](7) NULL,
	[cod_ben] [varchar](18) NULL,
	[fecha] [varchar](8) NULL
) ON [PRIMARY]

		UPDATE pedidos_fbenavides_ci_historia SET cantidad_surtida = 0 
		WHERE rtrim(hash_md5) = @archivo_cliente and cantidad_surtida IS NULL ;

		update p set p.letra=substring(ltrim(rtrim(c.cliente_ibs)),1,1)
		--select p.cia,p.cliente,p.sucursal,p.letra,substring(ltrim(rtrim(c.cliente_ibs)),1,1),
		--c.cia,c.cliente_ibs,c.cuenta,c.sucursal
		from pedidos_fbenavides_ci_historia p
		inner join cat_sucursales_benavides c on p.cia=c.cia
		where  ltrim(rtrim(p.hash_md5))=@archivo_cliente

		update p set p.cantidad_surtida=d.IDQTY
		--select p.arch_cliente,p.codigo,p.letra+p.cliente as cliente,
		--p.cantidad_pedida,p.pedido,d.IDPRDC,d.IDCUNO,d.[IHOREF],d.IDQTY
		from pedidos_fbenavides_ci_historia p
		left join [dbo].[detalle_respuesta_benavides] d
		on ltrim(rtrim(p.letra))+ltrim(rtrim(p.cliente))=ltrim(rtrim(d.IDCUNO)) and p.codigo=ltrim(rtrim(d.IDPRDC)) and p.pedido=ltrim(rtrim(d.[IHOREF]))
		where FECHAPROG>=getdate()-3 and ltrim(rtrim(p.hash_md5))=@archivo_cliente--'cbbf2ab2e8af00f3bd96f1beab6cfa71'

		--select * from pedidos_fbenavides_ci where hash_md5='cbbf2ab2e8af00f3bd96f1beab6cfa71' 
		update pedidos_fbenavides_ci_historia set cantidad_surtida=0,estatus=1
		--SELECT ped.cantidad_pedida,ped.cantidad_surtida
		--FROM pedidos_fbenavides_ci  ped 
		where archivo_hh is null  and cliente='00000' or codigo='0000000'
		and ltrim(rtrim(hash_md5)) = @archivo_cliente

		insert into faltanteBenavidesHistorico#
		SELECT   
		'05'																																														no_prov	,
		RIGHT('00'+ CONVERT(VARCHAR(2),ped.sucursal), 2)  suc_mzm	,
		ped.cia			cia_ben	,
		ped.mostrador	alm_ben	,
		RIGHT(REPLICATE('0',10) + ped.pedido,10)  no_ped	,
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,cantidad_pedida - cantidad_surtida )	, 7)  can_fal,
		RIGHT(REPLICATE('0',18) + ped.cod_bena,18)	cod_ben,
		CONVERT(VARCHAR(8), fecha_pedido,112)	fecha		
		--	, cantidad_pedida					, cantidad_surtida																
		FROM  pedidos_fbenavides_ci_historia  ped   
		WHERE ltrim(rtrim(hash_md5)) = @archivo_cliente--'cbbf2ab2e8af00f3bd96f1beab6cfa71' 
	    AND cantidad_surtida < cantidad_pedida and SUBSTRING(arch_cliente,1,4) not in('PECD')	
		ORDER BY ped.linea 
	
		select  no_prov,suc_mzm,cia_ben,alm_ben,no_ped,can_fal,cod_ben,fecha
		from faltanteBenavidesHistorico#
		drop table faltanteBenavidesHistorico#
END

GO


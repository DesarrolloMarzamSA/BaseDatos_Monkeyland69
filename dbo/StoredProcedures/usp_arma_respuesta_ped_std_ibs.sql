SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--select * from pedidos_servidor_ftp where arch_cliente = 'FF04200012.DAT'
--exec usp_arma_respuesta_ped_std_ftp 'FF04200012.DAT' , '18d2994c7af01fa48a998b9cdaa85975', 'express', 95
CREATE procedure [dbo].[usp_arma_respuesta_ped_std_ibs] @arch_cliente varchar(30), @hash_md5 varchar(50), @nombre varchar(30)--, @longitud_registro int
as
SELECT left(
right('00' + convert(varchar(2), vr.sucursal), 2) +
vr.cuenta +
vr.cod_barras + 
left('00'+convert(varchar(3),ISNULL(vr.cantidad_surtida, 0)),3) +
vr.num_pedido +
vr.filler1 +
'00' +
vr.codigo +
vr.filler2 +
--right('00'+vr.filler3,22)+ 
case when vr.nombre = 'fcasaly' then right('00'+vr.filler3,20) else right('00'+vr.filler3,22) end +
--right('0000000000' + convert(varchar(10), vr.precio) , 10) +
--right('00000' + convert(varchar(10), isnull(vr.porcentaje_oferta, 0)) , 5) +
--convert(varchar(1), vr.cod_credito)+
case when vr.nombre = 'fcasaly' then convert(varchar(4),isnull(rtrim(vr.numTienda),'0000'))
	else '' end +
	case when vr.nombre = 'fcasaly' then '217357'
	else '' end
,case when vr.nombre = 'fcasaly' then 89
	else 79 end)
  FROM [monkeyland].[dbo].[vw_respDirectEstandar] vr
  where
vr.arch_cliente = @arch_cliente and
vr.hash_md5 = @hash_md5 and
vr.nombre = @nombre
order by
vr.orden 
asc
GO

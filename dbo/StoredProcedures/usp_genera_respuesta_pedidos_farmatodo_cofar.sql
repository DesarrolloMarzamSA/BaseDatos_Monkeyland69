
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_farmatodo_cofar]
	@arch_cliente varchar(50),
	@hash_md5 varchar(50)

as
--declare @arch_cliente varchar(50)
--declare @hash_md5 varchar(50)
--set @arch_cliente = 'cod3_sec.txt'
--set @hash_md5 = '4bbead7681da60aefcf5e12767746e0a'
select	left(convert(varchar(13), cod_barras) + replicate(' ', 13), 13) + 
			left(convert(varchar(4), cant_ped) + replicate(' ', 4), 4) + 
			case 
				when cant_surt is null then left(convert(varchar(4), cant_ped) + replicate(' ', 4), 4) 
				when cant_ped - cant_surt != 0 then left(convert(varchar(4), (cant_ped - cant_surt)) + replicate(' ', 4), 4) 
			end + 
			left(convert(varchar(11), orden) + replicate(' ', 11), 11) + 
			left(convert(varchar(4), codigo_farmacia) + replicate(' ', 4), 4) 
from		pedidos_farmatodo_cofar 
where	arch_cliente = @arch_cliente and 
			hash_md5 = @hash_md5 and 
			(cant_surt is null or (cant_ped - cant_surt) != 0)
GO

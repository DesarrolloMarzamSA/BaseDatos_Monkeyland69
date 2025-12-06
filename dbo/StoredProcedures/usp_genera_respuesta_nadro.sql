
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_respuesta_nadro]
@x_Hashes as varchar(100)
WITH ENCRYPTION
as
--declare @x_Hashes as varchar(100)
--set @x_Hashes = 'e4906da0f21e8167431f5744f51d0795'

select	right(replicate('0', 7) + convert(varchar(7), cliente), 7) + 
			right(replicate('0', 15) + convert(varchar(15), orden_corta), 15) +
			right(replicate('0', 8) + convert(varchar(8), current_timestamp, 112), 8) +
			right(replicate('0', 15) + convert(varchar(15), cod_barras), 15) +
			right(replicate('0', 7) + convert(varchar(7), (isnull(cantidad, 0) - isnull(cantidad_surtida, 0)), 7), 7)
from		pedido_nadro
where	hash_md5_arch_cliente = @x_Hashes and
			isnull(cantidad, 0) - isnull(cantidad_surtida, 0) > 0
GO

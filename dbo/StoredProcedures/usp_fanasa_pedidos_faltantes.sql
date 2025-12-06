
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_fanasa_pedidos_faltantes]
@ahh as varchar(15)
WITH ENCRYPTION
as

select 	
right(REPLICATE(' ',20) + CONVERT(varchar,codigo_barras),20)ean,
right(REPLICATE(' ',8) + CONVERT(varchar,cantidad_pedida-isnull(cantidad_surtida,0)),8)faltante,
' 0' const 
from pedidos_fanasa_historia where respuesta=1 and CONVERT(varchar,cantidad_pedida-isnull(cantidad_surtida,0))>0 
AND archivo_hh like @ahh + '%'
order by linea
GO

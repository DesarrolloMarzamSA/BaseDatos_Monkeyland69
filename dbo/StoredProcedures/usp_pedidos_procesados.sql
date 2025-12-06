USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE--CREATE--DROP
PROCEDURE [dbo].[usp_pedidos_procesados]
WITH ENCRYPTION
AS


--create drop 
--table pedidos_procesados	(
--	fecha_pedido	smalldatetime	,
--	sucursal			VARCHAR(4),
--	lineas				INT
--	PRIMARY KEY (fecha_pedido, sucursal, lineas)
--)



--TRUNCATE TABLE pedidos_procesados

--INSERT INTO pedidos_procesados

select top 10
	CONVERT(SMALLDATETIME, fecha_pedido, 121)fecha_pedido, su.IATA suc, COUNT(pt.archivo) lineas
from capa_ibs.dbo.pedidos_traductor pt with (nolock)
RIGHT OUTER JOIN sucursales su on 
	su.sucursal = pt.sucursal
WHERE
	pt.fecha_pedido > DATEADD(hh, -1, GETDATE() ) AND
	su.fisica = 1 OR su.sucursal IN (24, 25)
group by CONVERT(SMALLDATETIME, fecha_pedido, 121), su.IATA--, LEFT(archivo, 8)
order by CONVERT(SMALLDATETIME, fecha_pedido, 121) desc, su.IATA--, LEFT(archivo,8 )


--SELECT * FROM pedidos_procesados
GO

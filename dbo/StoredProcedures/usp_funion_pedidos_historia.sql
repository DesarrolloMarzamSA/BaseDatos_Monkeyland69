
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--CREATE
PROCEDURE [dbo].[usp_funion_pedidos_historia]	
--DECLARE
	@fecha VARCHAR(10)
WITH ENCRYPTION
AS

--	2011-04-13		CREACION				MIGUEL SAMAYOA

/*
EXECUTE usp_funion_pedidos_historia '2011-04-28'
SELECT * FROM pedidos_funion ORDER BY arch_cliente, orden
SELECT * FROM pedidos_funion_historia
*/

DELETE FROM pedidos_funion_historia 
WHERE fecha < = DATEADD(dd, -8, GETDATE() )

INSERT INTO pedidos_funion_historia (
	fecha							,
	sucursal					,
	cuenta						,
	cod_barras				,
	codigo						,
	pedido						,
	cantidad_surtida	,
	cantidad_pedida		,
	arch_cliente			,
	hora_resp_tandem	,
	arch_tandem				,	
	orden							,
	mostrador					,
	descripcion				,
	tftp
)

SELECT 
	CONVERT(SMALLDATETIME,@fecha,121)	fecha,	--	CONVERT(VARCHAR(10),GETDATE(),121)
	sucursal					,
	cuenta						,
	cod_barras				,
	codigo						,
	pedido						,
	cantidad_surtida	,
	cantidad_pedida		,
	arch_cliente			,
	hora_resp_tandem	,
	arch_tandem				,
	orden							,
	mostrador					,
	descripcion				,
	tftp
FROM pedidos_funion




GO

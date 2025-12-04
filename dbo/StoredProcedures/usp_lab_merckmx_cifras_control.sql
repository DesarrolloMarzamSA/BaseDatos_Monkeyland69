USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_lab_merckmx_cifras_control] @fecha VARCHAR(10)
WITH ENCRYPTION
AS

/*
EXECUTE usp_lab_merckmx_cifras_control '201-07-12'
*/


CREATE TABLE #cifras_merckmx	(
	archivo					VARCHAR(20)	,
	registros				INT					,
	cantidad				INT					,
	precio					MONEY				,
	valor						MONEY				,
	faltante				INT					,
	orden						INT		
	PRIMARY KEY (archivo))


INSERT INTO #cifras_merckmx
	SELECT
		'Facturas'					ARCHIVO		, 
		t1.TotalRegistros		REGISTROS	, 
		t1.SumaCantidad			CANTIDAD	, 
		t1.SumaPrecio				PRECIO		, 
		t1.SumaValor				VALOR			,
		0										FALTANTE	,
		1										ORDEN
	FROM lab_merckmx_control_facturas									t1

	UNION

	SELECT 
		'Pedidos'						, 
		t1.TotalRegistros		, 
		t1.SumaCantidad			, 
		t1.SumaPrecio				, 
		t1.SumaValor				,
		t1.SumaCantFaltante	,
		--(SELECT COUNT(*) from lab_merckmx_pedidos WHERE MotFaltante <> 'NA')										,
		2
	FROM lab_merckmx_control_pedidos									t1

	UNION

	SELECT 
		'Stock'							, 
		t1.TotalRegistros		, 
		t1.SumaCantidad			, 
		0										, 
		0										,
		0										,
		3
	FROM lab_merckmx_control_stock_distribucion				t1

	UNION

	SELECT 
		'Transfer'								,
		SUM(t1.TotalRegistros)		,
		SUM(t1.SumaCantidad)			,
		0											, 
		0											,
		0											,
		4
	FROM lab_merckmx_control_transfer_sucursal				t1

	UNION

	SELECT 
		'MovInventa'				, 
		(SELECT SUM(t1.TotalRegistros)	FROM lab_merckmx_control_movimientos_inventarios	t1)		,
		(SELECT SUM(t1.SumaCantidad)		FROM lab_merckmx_control_movimientos_inventarios	t1)		,
		0										, 
		0										,
		0										,
		5
	ORDER BY orden



SELECT 
	LEFT( CONVERT( VARCHAR, archivo			)	+ REPLICATE(' ' , 15) , 15)	archivo							,
	LEFT( CONVERT( VARCHAR, registros		)	+ REPLICATE(' ' , 18) , 18)	registros						,
	LEFT( CONVERT( VARCHAR, cantidad		)	+ REPLICATE(' ' , 10) , 10)	cantidad						,
	LEFT( CONVERT( VARCHAR, precio			)	+ REPLICATE(' ' , 18) , 18)	precio							,
	LEFT( CONVERT( VARCHAR, valor				)	+ REPLICATE(' ' , 21) , 21)	valor								,
	LEFT( CONVERT( VARCHAR, faltante		)	+ REPLICATE(' ' , 10) , 10)	faltante				
FROM #cifras_merckmx
ORDER BY orden

DROP TABLE #cifras_merckmx
GO

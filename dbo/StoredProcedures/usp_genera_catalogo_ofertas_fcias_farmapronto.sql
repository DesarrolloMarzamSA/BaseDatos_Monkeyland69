CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fcias_farmapronto]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS

--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'LIBRE'
--SET @segunda_bolsa = 'ZZZZZ'
--SET @sucursal = 1

create table #resultados(consecutivo int identity(1,1), texto varchar(200))

insert into #resultados
SELECT	CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + 
		'|' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100))
			WHEN cant_base > 0 AND cant_oferta > 0 THEN CONVERT(VARCHAR(7), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100)
			ELSE CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100))
		END +
		'|' +
		CONVERT(VARCHAR(10), t3.vigencia_inicial, 120) +
		'|' +
		CONVERT(VARCHAR(10), t3.vigencia_final, 120) +
		'|' --+
		--REPLICATE('0', 5) +
		--'|'
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND
		t3.bolsa = @primer_bolsa
WHERE	--t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B'
UNION
SELECT	CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + 
		'|' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100))
			WHEN cant_base > 0 AND cant_oferta > 0 THEN CONVERT(VARCHAR(7), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100)
			ELSE CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100))
		END +
		'|' +
		CONVERT(VARCHAR(10), t3.vigencia_inicial, 120) +
		'|' +
		CONVERT(VARCHAR(10), t3.vigencia_final, 120) +
		'|' --+
		--REPLICATE('0', 5) +
		--'|'
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
WHERE	--t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)

select texto + right('00000' + convert(varchar(5), consecutivo), 5) + '|'  from #resultados

GO


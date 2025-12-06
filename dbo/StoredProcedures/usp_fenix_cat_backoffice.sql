
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_fenix_cat_backoffice]

/*
usp_fenix_cat_backoffice
*/


AS

DECLARE 
@sucursal	INT,	@cliente VARCHAR(5)
SET @sucursal = 4
SET @cliente = '00879'

DECLARE @descuento MONEY
SELECT @descuento = CONVERT(MONEY, descuento) 
  FROM clientes_baan WHERE sucursal = @sucursal AND cliente = @cliente

SELECT
	LEFT (CONVERT (VARCHAR,cod_barras										),13)			cod_barras	,
	LEFT (CONVERT (VARCHAR,descripcion									),30)			descripcion	,
	LEFT (CONVERT (VARCHAR,REPLACE(lab_largo,',','')		),50)			lab_largo		,
	LEFT (CONVERT (VARCHAR,CASE 
		WHEN left(status,1) = 'B' THEN 'BAJA' 
		WHEN left(status,1) = 'C' THEN 'CAMBIO' 
		WHEN left(status,1) = ' ' THEN 'ACTIVO' 
		END 																							),10)			status			,
	LEFT (CONVERT (VARCHAR,prec_farm										),10)			prec_farm		,
	LEFT (CONVERT (VARCHAR,prec_pub											),10)			prec_pub		,
	LEFT (CONVERT (VARCHAR,clas_fis											),10)			clas_fis		,
	--LEFT (CONVERT (VARCHAR,descto												),10)			descto			
	--@descuento				descto_fact	
	CASE
	WHEN mpb.clas_fis = 'B'  THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, @descuento			), 6)
	WHEN mpb.clas_fis = 'BA' THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, @descuento			), 6)
	WHEN mpb.clas_fis = 'N'  THEN '000.00' 
	WHEN mpb.clas_fis = 'NA' THEN '000.00' 
	WHEN mpb.clas_fis = 'H'  THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, mpb.descto_prod	), 6) 
	WHEN mpb.clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, mpb.descto_prod	), 6) END	porc_desc

FROM maestro_productos_baan mpb		WITH (NOLOCK)
INNER JOIN inventario_baan ib			WITH (NOLOCK)	ON	ib.sucursal = @sucursal 
	AND ib.codigo = mpb.codigo AND	ib.piezas > 0
WHERE mpb.codigo < dbo.gobierno()
	AND	ISNUMERIC(mpb.cod_barras) = 1
	
GO

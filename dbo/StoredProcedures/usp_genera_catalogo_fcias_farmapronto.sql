
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_farmapronto]
@sucursal INT, 
@minexist INT

AS
--exec usp_genera_catalogo_fcias_farmapronto 1, 1
--DECLARE @sucursal INT
--DECLARE @minexist INT
--SET @sucursal = 1
--SET @minexist = 0

create table #resultados(orden int identity(1,1), texto1 varchar(500), texto2 varchar(500))

insert into #resultados(texto1, texto2)
SELECT	CONVERT(VARCHAR(8), CURRENT_TIMESTAMP - 1, 112) +
		'00' + t1.codigo +
		LEFT(t1.descripcion + REPLICATE(' ', 40), 40) +
		LEFT(RIGHT('0000000' + CONVERT(VARCHAR(15), CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_farm + (t1.prec_farm * 0.5) ELSE t1.prec_farm END), 13), 10) +
		LEFT(RIGHT('0000000' + CONVERT(VARCHAR(15), CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_pub + (t1.prec_pub * 0.5) ELSE t1.prec_pub END), 13), 10) +
		RIGHT('000' + CONVERT(VARCHAR(6), t1.iva * 100), 6) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN '050.00' 
			ELSE '000.00' 
		END +
		'000.00' +
		CASE t1.clas_ssa 
			WHEN '1' THEN 'CO' 
			WHEN '2' THEN 'CO' 
			WHEN '3' THEN 'CO' 
			WHEN '4' THEN 'ET' 
			WHEN '5' THEN 'OT' 
			WHEN '6' THEN 'OT' 
			WHEN '7' THEN 'MC' 
			WHEN '8' THEN 'PF' 
			WHEN '9' THEN 'VA' 
			ELSE 'VA' 
		END +
		LEFT(t1.lab_largo + REPLICATE(' ', 30), 30) +
		REPLICATE(' ', 10) ,
		LEFT(t1.clas_fis + REPLICATE(' ', 2), 2) +
		REPLICATE(' ', 40) +
		LEFT(ISNULL(t1.desc_sus_act1, REPLICATE(' ', 40)) + REPLICATE(' ', 40), 40) +
		CASE t1.refrigerado 
			WHEN 'R' THEN 'R' 
			ELSE ' ' 
		END  +
		CASE t1.clas_ssa 
			WHEN '1' THEN 'P' 
			WHEN '2' THEN 'P' 
			WHEN '3' THEN 'P' 
			ELSE ' ' 
		END + 
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + '             ', 13) + 
		'PZA19000101' +
		CASE t1.clas_ssa 
			WHEN '1' THEN '1 '
			WHEN '2' THEN '2 ' 
			WHEN '3' THEN '3 ' 
			WHEN '4' THEN '4 ' 
			WHEN '5' THEN '5 ' 
			WHEN '6' THEN '5 ' 
			ELSE '  ' 
		END + 
		'C' +
		RIGHT('0000' + CONVERT(VARCHAR(4), t1.pzas_empaque_original), 4) +
		CASE t1.clas_fis 
			WHEN 'B' THEN '018.00' 
			WHEN 'BA' THEN '018.00' 
			WHEN 'N' THEN '000.00' 
			WHEN 'NA' THEN '000.00' 
			WHEN 'H' THEN RIGHT('000' + CONVERT(VARCHAR(6), t1.descto_prod), 6)  
			WHEN 'HA' THEN RIGHT('   ' + CONVERT(VARCHAR(6), t1.descto_prod), 6)  
		END +
		REPLICATE(' ', 14)
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo
WHERE	t2.sucursal = @sucursal AND
		ISNUMERIC(t1.cod_barras) = 1 AND 
		t2.piezas >= @minexist AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		--t1.fecha_baja IS NULL
		SUBSTRING(t1.status, 1, 1) <> 'B'
ORDER BY LEFT(t1.descripcion + REPLICATE(' ', 40), 40) 

select texto1, texto2, right('00000' + convert(varchar(5), orden), 5) consecutivo from #resultados
GO

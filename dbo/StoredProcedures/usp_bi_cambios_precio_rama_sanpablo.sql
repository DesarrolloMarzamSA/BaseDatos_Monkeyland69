
--exec usp_bi_cambios_precio 1

CREATE procedure [dbo].[usp_bi_cambios_precio_rama_sanpablo]
as

--PROCEDIMIENTO PARA  CAMBIOS BI

/*
DECLARE @sucursal int
SET @sucursal = 1
*/

begin

select 
	t1.codigo,
	t1.descripcion,
	t1.grupo_est,
	t1.prec_pub ,
	t1.prec_farm,
	t1.cod_barras,
	t1.iva
into #temp_bi_catalogo	
from maestro_productos_baan t1 
inner join cambios_precio_baan t2 on t1.codigo = t2.t_item
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = 1
where t2.fecha_hora > dateadd(dd, -5, current_timestamp) and
--	t1.prec_farm < 9999.99 and
convert(int, t1.codigo) < dbo.gobierno() and
t1.status not like 'B%'


select 
	left(descripcion + REPLICATE(' ',31), 31) +
	codigo + 
	RIGHT(REPLICATE('0',7) + CONVERT(VARCHAR, CONVERT(MONEY, 
		CASE grupo_est WHEN 'PC01A' THEN prec_pub		* 1.5 * (1 + iva) ELSE prec_pub * (1 + iva) END)), 7) + 
	RIGHT(REPLICATE('0',7) + CONVERT(VARCHAR, CONVERT(MONEY, 
		CASE grupo_est WHEN 'PC01A' THEN prec_pub		* 1.5							ELSE prec_pub							END)), 7) + 
	RIGHT(REPLICATE('0',7) + CONVERT(VARCHAR, CONVERT(MONEY, 
		CASE grupo_est WHEN 'PC01A' THEN prec_farm	* 1.5								ELSE prec_farm						END)), 7) +
	left(convert(varchar(13), convert(bigint, cod_barras)) + REPLICATE(' ',13), 13) texto1,
	codigo
into #cat
from #temp_bi_catalogo


CREATE TABLE #resultados(texto VARCHAR(100))
DECLARE @codigo VARCHAR(7), @texto VARCHAR(100)
DECLARE mi_cursor CURSOR fast_forward FOR 
	SELECT DISTINCT codigo FROM #cat

OPEN mi_cursor

fetch next from mi_cursor into @codigo

while @@fetch_status = 0
begin
	insert into #resultados select top 1 texto1 from #cat where codigo = @codigo
	fetch next from mi_cursor into @codigo
end

close mi_cursor
deallocate mi_cursor
SELECT * FROM #resultados

end


DROP TABLE #temp_bi_catalogo
DROP TABLE #cat
DROP TABLE #resultados

GO


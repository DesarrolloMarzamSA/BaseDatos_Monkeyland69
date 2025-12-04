CREATE	--	CREATE
PROCEDURE [dbo].[usp_fregis_pedidos_codigos]
AS

--SET DATEFIRST 7

--Sunday		 1 
--Monday		 2
--Tuesday		 3
--Wednesday	 4
--Thursday	 5
--Friday		 6
--Saturday	 7

UPDATE pedidos_fregis  SET
	sucursal = c.sucursal
FROM pedidos_fregis ped
INNER JOIN monkeyland..clientes_baan c on ped.cuenta=c.cliente
 where  c.ctepadre = '165'

/*
IF ( SELECT DATEPART(DW,GETDATE() ) ) = 1
	BEGIN
		UPDATE pedidos_fregis SET 
		cuenta = domingos ,
		sucursal = cat.sucursal, 
		letra = 'X'
		FROM pedidos_fregis ped 
		INNER JOIN cat_ctas_fregis cat ON cat.domingos IS NOT NULL AND ped.cuenta = cat.cliente 
		--AND ped.sucursal = cat.sucursal 
	END
*/


UPDATE pedidos_fregis SET 
	cod_barras = mpb.cod_barras,
	tftp = GETDATE()
FROM pedidos_fregis r
INNER JOIN maestro_productos_baan mpb ON mpb.codigo = r.codigo
	AND ISNUMERIC(mpb.cod_barras)=1

DELETE FROM pedidos_fregis 
WHERE codigo > dbo.gobierno()

GO


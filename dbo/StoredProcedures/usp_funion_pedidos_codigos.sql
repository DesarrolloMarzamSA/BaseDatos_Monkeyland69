CREATE	--	CREATE
PROCEDURE [dbo].[usp_funion_pedidos_codigos]
AS

/*
select * from pedidos_funion
EXECUTE usp_funion_pedidos_codigos
*/

--UPDATE pedidos_funion SET 
--	sucursal = cat_cte.sucursal
--FROM pedidos_funion  ped 
--INNER JOIN cat_cuentas_funion cat_cte ON 
--	ped.cuenta = cat_cte.cliente;
/*
UPDATE pedidos_funion SET 
	cod_barras = mpb.cod_barras,
	descripcion = mpb.descripcion
FROM pedidos_funion  ped 
INNER JOIN maestro_productos_baan mpb ON mpb.codigo < dbo.gobierno()
	AND ISNUMERIC(mpb.cod_barras)=1
	AND ped.codigo = mpb.codigo							;
*/

--UPDATE pedidos_funion SET 
--	codigo = mpb.codigo,
--	descripcion = mpb.descripcion
--FROM pedidos_funion  ped 
--INNER JOIN maestro_productos_baan mpb ON RIGHT( REPLICATE('0', 13) + ped.cod_barras, 13) = mpb.cod_barras
--where (mpb.codigo < dbo.gobierno() or mpb.codigo in ('3600004'))

INSERT INTO [monkeyland].[dbo].[pedidos_funion_eliminados]
           ([sucursal]
           ,[letra]
           ,[cuenta]
           ,[cod_barras]
           ,[codigo]
           ,[pedido]
           ,[cantidad_surtida]
           ,[cantidad_pedida]
           ,[arch_cliente]
           ,[hora_resp_tandem]
           ,[arch_tandem]
           ,[rftp]
           ,[tftp]
           ,[hash_md5]
           ,[orden]
           ,[mostrador]
           ,[descripcion]
           ,[fecha])
SELECT [sucursal]
      ,[letra]
      ,[cuenta]
      ,[cod_barras]
      ,[codigo]
      ,[pedido]
      ,[cantidad_surtida]
      ,[cantidad_pedida]
      ,[arch_cliente]
      ,[hora_resp_tandem]
      ,[arch_tandem]
      ,[rftp]
      ,[tftp]
      ,[hash_md5]
      ,[orden]
      ,[mostrador]
      ,[descripcion]
      ,GETDATE() as fecha
  FROM [monkeyland].[dbo].[pedidos_funion]
  WHERE cuenta = '00000' or sucursal = 0 
  --or (codigo > dbo.gobierno() and codigo not in('3600004'))

IF (SELECT COUNT(*) FROM pedidos_funion WHERE codigo > dbo.gobierno() ) > 0
	DELETE FROM pedidos_funion WHERE codigo > dbo.gobierno() and codigo not in('3600004')

DELETE FROM pedidos_funion WHERE cuenta = '00000' or sucursal = 0

GO


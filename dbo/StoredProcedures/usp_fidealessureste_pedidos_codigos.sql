
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_fidealessureste_pedidos_codigos]
WITH ENCRYPTION
AS

/*
select * from pedidos_fidealessureste
EXECUTE usp_fidealessureste_pedidos_codigos
*/

UPDATE pedidos_fidealessureste SET 
	sucursal = cat_cte.sucursal
FROM pedidos_fidealessureste  ped 
INNER JOIN cat_cuentas_fidealessureste cat_cte ON 
	ped.cuenta = cat_cte.cliente;
/*
UPDATE pedidos_fidealessureste SET 
	cod_barras = mpb.cod_barras,
	descripcion = mpb.descripcion
FROM pedidos_fidealessureste  ped 
INNER JOIN maestro_productos_baan mpb ON mpb.codigo < dbo.gobierno()
	AND ISNUMERIC(mpb.cod_barras)=1
	AND ped.codigo = mpb.codigo							;
*/

UPDATE pedidos_fidealessureste SET 
	codigo = mpb.codigo,
	descripcion = mpb.descripcion
FROM pedidos_fidealessureste  ped 
INNER JOIN maestro_productos_baan mpb ON mpb.codigo < dbo.gobierno()
	AND RIGHT( REPLICATE('0', 13) + ped.cod_barras, 13) = mpb.cod_barras

INSERT INTO [monkeyland].[dbo].[pedidos_fidealessureste_eliminados]
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
  FROM [monkeyland].[dbo].[pedidos_fidealessureste]
  WHERE cuenta = '00000' or sucursal = 0 or codigo > dbo.gobierno()

IF (SELECT COUNT(*) FROM pedidos_fidealessureste WHERE codigo > dbo.gobierno() ) > 0
	DELETE FROM pedidos_fidealessureste WHERE codigo > dbo.gobierno()

DELETE FROM pedidos_fidealessureste WHERE cuenta = '00000' or sucursal = 0

GO

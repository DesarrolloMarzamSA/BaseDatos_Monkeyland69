
CREATE
PROCEDURE [FormatoUnion].[usp_Farmatodo_pedidos_codigos]
AS


INSERT INTO [FormatoUnion].[pedidos_Farmatodo_Eliminados]
           ([sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida],[arch_cliente]
		   ,[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion],[fecha])
SELECT [sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida],[arch_cliente]
      ,[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion],GETDATE() as fecha
  FROM [FormatoUnion].[pedidos_Farmatodo]
  WHERE cuenta = '00000' or sucursal = 0 


IF (SELECT COUNT(*) FROM [FormatoUnion].[pedidos_Farmatodo] WHERE codigo > dbo.gobierno() ) > 0
	DELETE FROM [FormatoUnion].[pedidos_Farmatodo] WHERE codigo > dbo.gobierno() and codigo not in('3600004')

DELETE FROM [FormatoUnion].[pedidos_Farmatodo] WHERE cuenta = '00000' or sucursal = 0

GO


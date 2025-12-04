
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,16-03-2023,>
-- Description:	<Description,Se inserta el pedido del cliente en un solo bloque optimizando tiempo y recurso de BD>
-- =============================================
CREATE PROCEDURE [fbena].[usp_fbenavides_pedidos_ci_insert]
@LstPedidosDetalle AS [fbena].[LstDetallePedidos_fbenavides_ci] READONLY
AS
BEGIN
    
	--BEGIN TRY
	     --select top 200* from pedidos_fbenavides_ci order by fecha_pedido desc
		 MERGE [dbo].[pedidos_fbenavides_ci_20131106] T
		 USING (
		 		SELECT	[Linea] AS [linea], [FechaPedido] AS [fecha_pedido], [Pedido] AS [pedido]
				,'O' AS letra,0 as sucursal, '00000' AS cliente
				,[Cia] AS [cia], [Mostrador] AS [mostrador]
				,'0000000' AS codigo
				,[CodigoBenavides] AS [cod_bena]
				,'' AS descripcion,[CantPedido] AS [cantidad_pedida]
				,[NombreArchivo] AS [arch_cliente],[Hash_md5] AS [hash_md5]	
	  	        FROM @LstPedidosDetalle 
		 ) S
		 ON (S.linea = T.linea AND S.fecha_pedido = T.fecha_pedido AND S.sucursal = T.sucursal AND S.cliente = T.cliente AND S.codigo = T.codigo AND S.cantidad_pedida = T.cantidad_pedida AND S.pedido = T.pedido AND S.hash_md5 = T.hash_md5 )	
		 --WHEN MATCHED THEN
		 --	 UPDATE SET
		 --	  T.cod_bena=S.cod_bena
		 --	 ,T.arch_cliente=S.arch_cliente
		 --	 ,T.[timestamp] = GETDATE()		
		 WHEN NOT MATCHED THEN
		 INSERT (linea, fecha_pedido, pedido, letra, sucursal, cliente, cia, mostrador, codigo, cod_bena, descripcion, cantidad_pedida, arch_cliente, hash_md5, timestamp) 
		 VALUES ([linea],[fecha_pedido],[pedido],letra,sucursal,cliente, [cia],[mostrador],codigo,[cod_bena],descripcion,[cantidad_pedida],[arch_cliente],[hash_md5],GETDATE());	

 --   END TRY
 --   BEGIN CATCH
	--      DECLARE @CodError int =0,  
 --                 @ErrorSeverity int,  
 --                 @ErrorState int,  
 --                 @ErrorProcedure varchar(100),  
 --                 @ErrorLine int,  
 --                 @ErrorMessage varchar (250),  
 --                 @mensaprocedure varchar(250) ='[fbena].[usp_fbenavides_pedidos_ci_insert]' ;
 --         SELECT  
 --           @CodError= ERROR_NUMBER()    
 --          ,@ErrorSeverity= ERROR_SEVERITY()  
 --          ,@ErrorState=ERROR_STATE()  
 --          ,@ErrorProcedure =ERROR_PROCEDURE()   
 --          ,@ErrorLine=ERROR_LINE()   
 --          ,@ErrorMessage=ERROR_MESSAGE(); 
		
	--	  EXEC [mob_sp_LOGERRORBenavides]  'INSERTAR DETALLE',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine           
	--END CATCH


END

GO


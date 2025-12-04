

create	--	DROP
PROCEDURE [dbo].[usp_fbenavides_insert_hh]
@sucursal int,
      @cliente varchar(5),
      @codigo varchar(7),
      @arch_cliente varchar(50),
      @archivo_hh varchar(20),
      @hash_md5 varchar(150),
      @estatus varchar(1),
      @pedido varchar(10)	


AS


DECLARE 
@descripcion VARCHAR(100),
 @CodError int =0,  
  @ErrorSeverity int,  
  @ErrorState int,  
  @ErrorProcedure varchar(100),  
  @ErrorLine int,  
  @ErrorMessage varchar (250),  
  @mensaprocedure varchar(250) ='[usp_fbenavides_insert_hh]' ;

	
   begin try
		INSERT INTO [dbo].[pedidos_fbenavides_hh] ([sucursal],[cliente],[codigo],[arch_cliente],[archivo_hh],[tftp],[hash_md5],[estatus],[pedido])
		VALUES (@sucursal,@cliente,@codigo,@arch_cliente,@archivo_hh,getdate(),@hash_md5,'2',@pedido);
   end try
   begin catch
       SELECT  
	     @CodError= ERROR_NUMBER()    
        ,@ErrorSeverity= ERROR_SEVERITY()  
        ,@ErrorState=ERROR_STATE()  
        ,@ErrorProcedure =ERROR_PROCEDURE()   
        ,@ErrorLine=ERROR_LINE()   
        ,@ErrorMessage=ERROR_MESSAGE(); 
		EXEC [mob_sp_LOGERRORBenavides]  'insertar hh',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine
        end catch
sET NOCOUNT on;
--select * from cat_productos_benavides

GO


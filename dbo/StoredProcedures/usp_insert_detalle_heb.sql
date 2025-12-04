
-- =============================================
-- Author:		mandrade
-- Create date: 05122014
-- Description:	insertar detalle heb
-- =============================================
CREATE PROCEDURE [dbo].[usp_insert_detalle_heb] @item int 
           ,@product_id int 
           ,@department_article_id int 
           ,@department_article_desc varchar(150) 
           ,@bar_code varchar(150) 
           ,@article_desc varchar(150) 
           ,@measurement_unit varchar(150) 
           ,@ordered_quantity int 
           ,@packing_factor numeric(18,4) 
           ,@packaging_quantity int 
           ,@unit_price money
		   ,@purchase_order numeric(18,4)
		   ,@Subsidiary_gln varchar(150)
		   ,@Subsidiary int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    Declare @Parame   Varchar(1),           
  @CodError int =0,  
  @ErrorSeverity int,  
  @ErrorState int,  
  @ErrorProcedure varchar(100),  
  @ErrorLine int,  
  @ErrorMessage varchar (250);
  begin try
INSERT INTO [dbo].[pedidoHEB_Detalle]
           ([item]
           ,[product_id]
           ,[department_article_id]
           ,[department_article_desc]
           ,[bar_code]
           ,[article_desc]
           ,[measurement_unit]
           ,[ordered_quantity]
           ,[packing_factor]
           ,[packaging_quantity]
           ,[unit_price]
		   ,[FechaRegistro]
		   ,[Purchase_order]
		   ,[Subsidiary_gln]
		   ,[Subsidiary]
		   ,[estatus])
     VALUES
           (@item   
           ,@product_id   
           ,@department_article_id   
           ,@department_article_desc  
           ,@bar_code  
           ,@article_desc  
           ,@measurement_unit  
           ,@ordered_quantity   
           ,@packing_factor  
           ,@packaging_quantity   
           ,@unit_price
		   ,getdate()
		   ,@purchase_order
		   ,@Subsidiary_gln
		   ,@Subsidiary
		   ,30)
		end try

		begin catch
		SELECT  @CodError= ERROR_NUMBER() 
			,@ErrorSeverity= ERROR_SEVERITY()  
			,@ErrorState=ERROR_STATE()  
			,@ErrorProcedure =ERROR_PROCEDURE()   
			,@ErrorLine=ERROR_LINE()   
			,@ErrorMessage=ERROR_MESSAGE(); 		
		EXEC mob_sp_LOGERRORHEB  'insertar Detalle',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine
           
		end catch
END

GO


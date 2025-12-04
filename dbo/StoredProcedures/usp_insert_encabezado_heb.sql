
-- =============================================
-- Author:		mandrade
-- Create date: 05122014
-- Description:	insertar pedidos HEB
-- =============================================
CREATE PROCEDURE [dbo].[usp_insert_encabezado_heb]
@Document_type varchar(150) 
           ,@Heb_rfc varchar(150) 
           ,@Vendor_number int 
           ,@Vendor_rfc varchar(150) 
           ,@Detail_number_of_lines int 
           ,@Purchase_order numeric(18,4) 
           ,@Subsidiary_gln varchar(150) 
           ,@Subsidiary int 
           ,@Subsidiary_desc varchar(150) 
           ,@Subsidiary_address varchar(150) 
           ,@Subsidiary_city varchar(150) 
           ,@Cancellation_date varchar(150) --datetime
           ,@Department_id int 
           ,@Department varchar(150) 
           ,@Vendor varchar(150) 
           ,@Purchase_date varchar(150) --datetime 
           ,@Operation_date varchar(150) --datetime 
           ,@Estatus varchar(150) 
           ,@Receipt_date varchar(150) --datetime 
           ,@Comments varchar(150) 
           ,@Buyer_id int 
           ,@Buyer varchar(150) 
           ,@Total_pretax numeric(18,4) 
           ,@Total_packs int
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
  @ErrorMessage varchar (250),  
  @mensaprocedure varchar(250) ='[usp_insert_encabezado_heb]' ;
  --select cast('2014-12-05 13:27:30'as datetime)
	begin try
INSERT INTO [dbo].[pedidoHEB_Encabezado]
           ([Document_type]
           ,[Heb_rfc]
           ,[Vendor_number]
           ,[Vendor_rfc]
           ,[Detail_number_of_lines]
           ,[Purchase_order]
           ,[Subsidiary_gln]
           ,[Subsidiary]
           ,[Subsidiary_desc]
           ,[Subsidiary_address]
           ,[Subsidiary_city]
           ,[Cancellation_date]
           ,[Department_id]
           ,[Department]
           ,[Vendor]
           ,[Purchase_date]
           ,[Operation_date]
           ,[Estatus]
           ,[Receipt_date]
           ,[Comments]
           ,[Buyer_id]
           ,[Buyer]
           ,[Total_pretax]
           ,[Total_packs]
		   ,[FechaRegistro]
		   ,[EstatusEnvio])
     VALUES
           (@Document_type  
           ,@Heb_rfc  
           ,@Vendor_number   
           ,@Vendor_rfc  
           ,@Detail_number_of_lines   
           ,@Purchase_order  
           ,@Subsidiary_gln  
           ,@Subsidiary   
           ,@Subsidiary_desc  
           ,@Subsidiary_address  
           ,@Subsidiary_city  
           ,cast(@Cancellation_date as datetime)--@Cancellation_date   
           ,@Department_id   
           ,@Department  
           ,@Vendor  
           ,cast(@Purchase_date as datetime)--@Purchase_date   
           ,cast(@Operation_date as datetime)--@Operation_date   
           ,@Estatus  
           ,cast(@Receipt_date as datetime)--@Receipt_date   
           ,@Comments  
           ,@Buyer_id   
           ,@Buyer  
           ,@Total_pretax  
           ,@Total_packs
		   ,getdate(),0)
		   end try

		   begin catch
       SELECT  
        @CodError= ERROR_NUMBER() ,   
        @ErrorSeverity= ERROR_SEVERITY()  
        ,@ErrorState=ERROR_STATE()  
        ,@ErrorProcedure =ERROR_PROCEDURE()   
        ,@ErrorLine=ERROR_LINE()   
        ,@ErrorMessage=ERROR_MESSAGE(); 
		
		EXEC mob_sp_LOGERRORHEB  'insertar encabezado',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine
           
		end catch

END

GO


-- =============================================
-- Author:		mandrade
-- Create date: 13-03-2015
-- Description:	bitacora envio CFDI HEB
-- =============================================
CREATE PROCEDURE usp_envio_cfdi_heb @serie varchar(10)
           ,@folio_fiscal varchar(100)
           ,@documentoIbs numeric(18,0)
           ,@documentEstatus varchar(350)
           ,@codErrorm varchar(350)
           ,@msgError varchar(350)
           ,@aperack varchar(max)
           ,@estatusSistema int
           ,@tipoEnvio varchar(50)
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
  @mensaprocedure varchar(250) ='usp_envio_cfdi_heb' ;
  --select cast('2014-12-05 13:27:30'as datetime)
	begin try
	INSERT INTO [dbo].[envio_cfdi_HEB]
           ([serie]
           ,[folio_fiscal]
           ,[documentoIbs]
           ,[fechaEnvio]
           ,[documentEstatus]
           ,[codError]
           ,[msgError]
           ,[aperack]
           ,[estatusSistema]
           ,[tipoEnvio])
     VALUES
           (@serie
           ,@folio_fiscal
           ,@documentoIbs
           ,getdate()
           ,@documentEstatus
           ,@codErrorm
           ,@msgError
           ,@aperack
           ,@estatusSistema
           ,@tipoEnvio)
	 end try
		   begin catch
       SELECT  
        @CodError= ERROR_NUMBER() ,   
        @ErrorSeverity= ERROR_SEVERITY()  
        ,@ErrorState=ERROR_STATE()  
        ,@ErrorProcedure =ERROR_PROCEDURE()   
        ,@ErrorLine=ERROR_LINE()   
        ,@ErrorMessage=ERROR_MESSAGE(); 		
		EXEC mob_sp_LOGERRORHEB  'insertar envio Xml CFDI HEB',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine           
		end catch
   
END

GO


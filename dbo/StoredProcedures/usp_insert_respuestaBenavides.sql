-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_insert_respuestaBenavides @hashmd5 varchar(300),@nombreArchivo varchar(350)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CodError int =0,  
  @ErrorSeverity int,  
  @ErrorState int,  
  @ErrorProcedure varchar(100),  
  @ErrorLine int,  
  @ErrorMessage varchar (250),  
  @mensaprocedure varchar(250) ='[usp_insert_respuestaBenavides]' ;
  begin try
    -- Insert statements for procedure here
	INSERT INTO [dbo].[respuesta_benavides] ([hashmd5],[nombreArchivo],[fechaRespuesta],[estatus]) VALUES (@hashmd5,@nombreArchivo,getdate(),1)
	 end try

		   begin catch
       SELECT  
        @CodError= ERROR_NUMBER() ,   
        @ErrorSeverity= ERROR_SEVERITY()  
        ,@ErrorState=ERROR_STATE()  
        ,@ErrorProcedure =ERROR_PROCEDURE()   
        ,@ErrorLine=ERROR_LINE()   
        ,@ErrorMessage=ERROR_MESSAGE(); 
		
		EXEC [mob_sp_LOGERRORBenavides]  'insertar archivo',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine
           
		end catch
END

GO


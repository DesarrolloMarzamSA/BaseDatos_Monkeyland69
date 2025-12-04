-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_insert_hashmd5Benavides @programa varchar(150), @firma varchar(150),  @nombre_archivo varchar(150), @lineas int,@ruta varchar(150)
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
  @mensaprocedure varchar(250) ='[usp_insert_hashmd5Benavides]' ;
  begin try
   insert into [dbo].[hashes_md5_benavides] (programa, firma, fecha, nombre_archivo, lineas,[ruta]) 
   values (@programa, @firma, getdate(), @nombre_archivo, @lineas,@ruta)
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


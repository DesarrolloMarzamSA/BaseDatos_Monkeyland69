

create   Procedure [dbo].[mob_sp_LOGERRORBenavides]      
 @Proceso Varchar(250)='',      
@Error Varchar(250)='',      
@ErrorSql varchar(250)='',      
@Procedimiento varchar(150) =''   ,  
@lineaError int      
As      
set nocount on        

      
Insert Into [dbo].[log_error_Benavides] with (rowlock) (log_proceso,Log_Error,Log_ErrorSql,log_procedure,[log_fecha],[log_lineaerror])      
                 Values  (@Proceso,@Error,@ErrorSql,@Procedimiento,getdate(),@lineaError)

GO


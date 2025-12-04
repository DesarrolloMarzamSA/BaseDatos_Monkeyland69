
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[MarcarHandHeldGenerado]
@hash varchar(50),
@nombreHandHeld varchar(25),
@handHeld varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @errorMessage as varchar(max)

begin try
	BEGIN TRAN
		update [Ahorro].[encabezadoPedidosFiliales]
		   set [estatus]=20,[nombreHandHeld]=@nombreHandHeld,[archivoHandHeld]=@handHeld,[fechaGeneracionHandHeld]=GETDATE()
		   where [hashMd5]=@hash
		update [Ahorro].[pedidosFiliales] set [status]='H' where [hashMd5]=@hash
	COMMIT TRAN
end try
	begin catch
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		SELECT @errorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		
		ROLLBACK TRAN
		RAISERROR (@errorMessage,@ErrorSeverity,@ErrorState);
end catch
END

GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[MarcarHandHeldCargado]
@hash varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @errorMessage as varchar(max)

begin try
		update [Ahorro].[encabezadoPedidosFiliales]
		   set [estatus]=40,[fechaCargaHandHeld]=GETDATE()
		   where [hashMd5]=@hash
end try
	begin catch
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		SELECT @errorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		
		RAISERROR (@errorMessage,@ErrorSeverity,@ErrorState);
end catch

END

GO


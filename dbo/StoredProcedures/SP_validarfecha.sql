
			create procedure [dbo].[SP_validarfecha]
			@fecha nvarchar(30)
			as
			begin
			if cast(@fecha as date)>cast(getdate() as date)
			select 1
			else 
			select 2
			end

GO


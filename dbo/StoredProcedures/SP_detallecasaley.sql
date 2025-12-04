 create procedure [dbo].[SP_detallecasaley]
 @fecha nvarchar(30)
 as
 begin
 select top 1 
    totalbd as total_bd,
	totalarchivo as total_archivos,
	totalftps as ftp_exito,
	totalftpr as ftp_fracaso,
	cast(fecha as date) as fecha 
  from totalescasaley2
   where cast(fecha as date)=@fecha
    order by fecha desc
	end

GO


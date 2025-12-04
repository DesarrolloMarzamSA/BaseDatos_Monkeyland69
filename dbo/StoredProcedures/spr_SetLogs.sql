

-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,19-12-17,>
-- Description:	<Description,Procedimiento para guardar logs en base de datos ,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_SetLogs]
@Id_Pagina int,
@Titulo varchar(50),
@Metodo varchar(60),
@Descripcioncorta varchar(100),
@Descripcionlarga varchar(max),
@Usuario varchar(60),
@estatus bit
AS
BEGIN
	Begin Try
	  insert into [WebMarzam].[dbo].[Logs] (
	  Id_Pagina,
      Titulo,
      Metodo,
      Descripcioncorta,
      Descripcionlarga,
      Usuario,
	  Fecha,
	  Estatus) values 
	  (
@Id_Pagina,
@Titulo,
@Metodo,
@Descripcioncorta ,
@Descripcionlarga ,
@Usuario,

SYSDATETIME(),
@estatus)
end try
 Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario,Fecha,Estatus)
		Values(58,ERROR_PROCEDURE(),'spr_SetLogs',ERROR_MESSAGE(),'','SQL',SYSDATETIME(),0) 
END Catch
end

GO


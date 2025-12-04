-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 28/03/2019
-- Description:	Valida solo se realize una extraccion por usuario
-- Exec [dbo].[usp_AgregarExtraccionRemisionesFAhorroIBS] 'Robert','20190101','20190110'
-- =============================================
CREATE PROCEDURE [dbo].[usp_AgregarExtraccionRemisionesFAhorroIBS]
@IdUsuario VARCHAR(20),
@FechaInicial DATE,
@FechaFinal DATE
AS
BEGIN

	SET NOCOUNT ON;

	IF (DATEDIFF(D,@FechaInicial,@FechaFinal)>12)
	BEGIN			  
		RAISERROR('Error en rango de fechas, para optimización de recursos la extracción máxima permitida es de 12 dias',16,1);	
		RETURN;
	END
	IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlCargaRemisionesFAhorro] WHERE [Usuario] = @IdUsuario AND IdEstado IN (1,4))
	BEGIN			  
		RAISERROR('Ya se esta realizando un proceso de extracción favor de esperar el resultado',16,1);	
		RETURN;
	END

		MERGE INTO [dbo].[ControlCargaRemisionesFAhorro] T
		USING 
		( SELECT @IdUsuario AS [Usuario],@FechaInicial AS [InicioCarga],@FechaFinal AS [FinCarga] ) 
		S ON (T.[Usuario] = S.[Usuario] AND T.[InicioCarga] = S.[InicioCarga] AND T.[FinCarga] = S.[FinCarga])	
		WHEN MATCHED THEN
		  UPDATE 
			  SET T.[Usuario] = S.[Usuario],
			      T.[UltimaEjecucion] = GETDATE(),
			      T.[IdEstado] = 4,
				  T.[Intento] =(ISNULL(T.[Intento],1)+1),
				  T.[Procesar] = 1
	    WHEN NOT MATCHED BY TARGET THEN --No existe en el destino
	       INSERT ([Usuario],[InicioCarga],[FinCarga],[IdEstado],[Intento],[Procesar])
           VALUES ([Usuario],[InicioCarga],[FinCarga],1,1,1);		  

END

GO


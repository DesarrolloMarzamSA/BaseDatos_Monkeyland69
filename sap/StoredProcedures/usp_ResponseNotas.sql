
-- =============================================
-- Author:		<JCPM>
-- Create date: <15/06/2021>
-- Description:	<obtiene la respuesta de las notas de credito que se han enviado por el API>
-- exec [sap].[usp_ResponseNotas]
-- =============================================
Create PROCEDURE [sap].[usp_ResponseNotas]
@xmlResponse XML
AS
BEGIN
	-- Opciones iniciales
	SET NOCOUNT ON;
	
	insert into sap.Respuesta220
	select 
	Tabla.Columna.value('ID_SEG[1]',	'bigint') as ID_SEG,
	Tabla.Columna.value('NOTAIBS[1]',	'varchar(20)') as NOTAIBS,
	Tabla.Columna.value('FOLDEVO[1]',	'varchar(20)') as idSeguimiento,
	Tabla.Columna.value('FOLCARG[1]',	'varchar(20)') as idSeguimiento,
	Tabla.Columna.value('VBELN[1]',		'varchar(20)') as idSeguimiento,
	Tabla.Columna.value('VBELN_VF[1]',	'varchar(20)') as idSeguimiento,
	Tabla.Columna.value('ERROR[1]',		'varchar(max)') as idSeguimiento,
	getdate()
	from @xmlResponse.nodes('//item') Tabla(Columna)
	
END

GO


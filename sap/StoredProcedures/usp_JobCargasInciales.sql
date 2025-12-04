
-- =============================================
-- Author:		<JCPM>
-- Create date: <19/05/2021>
-- Description:	<obtiene las cargas iniciales de la notas de crédito>
-- exec [sap].[usp_JobCargasInciales]
-- =============================================
CREATE PROCEDURE [sap].[usp_JobCargasInciales]
AS
BEGIN
	-- Opciones iniciales
	SET NOCOUNT ON;
	
	-- Inicia la trasaccion
	DECLARE @TranName VARCHAR(20) = 'TransfersIBSSAPTransactionNCCI';  
	
	BEGIN TRANSACTION @TranName;
	BEGIN TRY

		declare @tblCINC table(
			[idSeguimiento] [bigint] NULL,--
			[Factura] varchar(20) NULL, --
			[FolioAgente] varchar(20) NULL,--1
			[FolioDeCargo] varchar(20) NULL,--2
			[Organizacion] varchar(20) NULL,--3
			[CanalCdis] varchar(20) NULL,--4
			[Sector] varchar(20) NULL,--5
			[tipoDocumento] varchar(20) NULL,--6
			[Solicitante] varchar(20) NULL, --
			[fechaDeCreacion] varchar(20) NULL, --
			[Motivo] varchar(20) NULL,--7
			[Producto] varchar(20) NULL, --
			[Cantidad] bigint NULL,--8
			[Unidad] varchar(20) NULL, --
			[Precio] decimal(15,2) NULL,--9
			[TotalDocumento] decimal(15,2) NULL,--10
			[ImpuestoBase] varchar(20) NULL,--11
			[Division] varchar(20) NULL, --12
			[Centro] varchar(20) NULL,--13
			[FechaRegistro] varchar(20) NULL,--
			[HoraRegistro] varchar(20) NULL,--
			[TipoNota] varchar(20) NULL,--14
			[CarteraDocumento] varchar(20) NULL,--15
			[estatus] [bigint] NULL,
			[idref] [bigint] NULL,
			[detalleRef] [varchar](200) NULL,
			[apiWeb][bit]
		)

		declare @query nvarchar(max)
		set @query= N'select * from  openquery(AS400,''select 0,a.*,20,0,'''''''',0 FROM MA4620EC.Z3OCARNC A'')'

		insert into @tblCINC EXEC(@query)

		--select * from @tblCINC

		MERGE sap.CargasInicialesNC AS r
		USING @tblCINC AS t
		ON (r.Factura=t.Factura and r.solicitante=t.solicitante and r.fechaDeCreacion=t.fechaDeCreacion and r.Producto=t.Producto and r.unidad=t.unidad)
		WHEN MATCHED AND (r.FolioAgente<>t.FolioAgente or r.FolioDeCargo<>t.FolioDeCargo or r.Organizacion<>t.Organizacion OR 
						  r.canalCdis<>t.canalCdis or r.sector<>t.sector or r.tipoDocumento<>t.tipoDocumento or r.Motivo<>RIGHT(REPLICATE('0', 3)+cast(t.[Motivo] as varchar(3)),3) or 
						  r.cantidad<>t.cantidad or r.Precio<>t.Precio or r.TotalDocumento<>t.TotalDocumento or r.ImpuestoBase<>t.ImpuestoBase or
						  r.Division<>t.Division or r.Centro<>t.Centro or r.TipoNota<>t.TipoNota or r.CarteraDocumento<>t.CarteraDocumento) 
						  and r.estatus=30 
						  --se validara que se marque la nota de credito se actualice, 
						  --su estatus a 20 para que se envie complet nuevamente
		THEN UPDATE SET r.FolioAgente=t.FolioAgente, r.FolioDeCargo=t.FolioDeCargo, r.Organizacion=t.Organizacion, r.canalCdis=t.canalCdis, 
						r.sector=t.sector, r.tipoDocumento=t.tipoDocumento, r.Motivo=t.Motivo, r.cantidad=t.cantidad, r.Precio=t.Precio, 
						r.TotalDocumento=t.TotalDocumento, r.ImpuestoBase=t.ImpuestoBase, r.Division=t.Division, r.Centro=t.Centro, 
						r.TipoNota=t.TipoNota, r.CarteraDocumento=t.CarteraDocumento, r.estatus=20, r.apiWeb=1
		WHEN NOT MATCHED BY TARGET THEN 
		insert(
			[idSeguimiento],[Factura],[FolioAgente],[FolioDeCargo],[Organizacion],[CanalCdis],[Sector],[tipoDocumento],
			[Solicitante],[fechaDeCreacion],[Motivo],[Producto],[Cantidad],[Unidad],[Precio],[TotalDocumento],[ImpuestoBase],
			[Division],[Centro],[FechaRegistro],[HoraRegistro],[TipoNota],[CarteraDocumento],[estatus],[idref],[detalleRef],[apiWeb]) 
		values(
			t.[idSeguimiento],t.[Factura],t.[FolioAgente],t.[FolioDeCargo],t.[Organizacion],t.[CanalCdis],t.[Sector],t.[tipoDocumento],
			t.[Solicitante],t.[fechaDeCreacion],RIGHT(REPLICATE('0', 3)+cast(t.[Motivo] as varchar(3)),3),t.[Producto],t.[Cantidad],t.[Unidad],t.[Precio],t.[TotalDocumento],t.[ImpuestoBase],
			t.[Division],t.[Centro],t.[FechaRegistro],t.[HoraRegistro],t.[TipoNota],t.[CarteraDocumento],t.[estatus],t.[idref],t.[detalleRef],
			t.[apiWeb]);
		
		COMMIT TRANSACTION @TranName;
		
		-- una vez realizado el merge realizar lo siguiente:
		declare @tblAsignaIdseg table(
					[idSeguimiento] [bigint] NULL,
					[AfeReg] [varchar](20) NULL
		)

		declare @idsSeg int
		--obtnemos el ultimo id de seguimiento que se genero
		select top 1 @idsSeg = idSeg from sap.ControlEnvioCINC  order by idSeg desc
		-- se determinara los idseguimiento, para los nuevos registros
		-- bajo la logica de año de fecha de creacion + fecha de registro(AAAA-MM-DD)
		insert into @tblAsignaIdseg
		select (isnull(@idsSeg,0)+Row_number()over(order by left(fechaDeCreacion,4)+'-'+FechaRegistro))idseg,
		left(fechaDeCreacion,4)+'-'+FechaRegistro from sap.CargasInicialesNC where idSeguimiento=0
		group by left(fechaDeCreacion,4)+'-'+FechaRegistro
		order by left(fechaDeCreacion,4)+'-'+FechaRegistro

		insert into sap.ControlEnvioCINC select idSeguimiento, 20, 0, getdate() from @tblAsignaIdseg

		UPDATE  A
		SET A.idSeguimiento = B.idSeguimiento
		FROM sap.CargasInicialesNC A
		INNER JOIN @tblAsignaIdseg B ON left(A.fechaDeCreacion,4)+'-'+A.FechaRegistro = B.AfeReg
		where A.idSeguimiento = 0

		update sap.ControlEnvioCINC set apiWeb=1 where idSeg in(select top 1 idseg from sap.ControlEnvioCINC where estatus=20 order by idseg)

	END TRY
	BEGIN CATCH
		-- Deshace la transaccion
		ROLLBACK TRANSACTION @TranName;
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	
	-- EOF
	
END

GO


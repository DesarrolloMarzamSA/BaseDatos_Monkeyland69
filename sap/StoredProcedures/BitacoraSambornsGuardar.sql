
  CREATE PROCEDURE [sap].[BitacoraSambornsGuardar](@fecha date, @serie_cfd varchar(5), @folio_fiscal varchar(10), 
										@importe money, @msg_error varchar(2000))
  AS
  BEGIN
	DECLARE @SUCURSAL tinyint = ISNULL((SELECT TOP 1 sucursal FROM sucursales WHERE serie_cfd = @serie_cfd), 0);
	DECLARE @remision varchar(10) = '', 
			@cliente varchar(5) = '', 
			@confirmada int = 1, 
			@intento int = 1, 
			@no_error int = 0, 
			@archivo varchar(200) = 'Bobeda CFD', 
			@registro datetime = getdate();

	MERGE [bitacora_sanborns_cfd] T

	USING(SELECT @fecha AS fecha, @sucursal AS sucursal, @serie_cfd AS serie_cfd, @folio_fiscal AS folio_fiscal, 
				@remision AS remision, @cliente AS cliente, @confirmada AS confirmada, @importe AS importe, 
				@intento AS intento, @no_error AS no_error, @msg_error AS msg_error, @archivo AS archivo, 
				@registro AS registro) P

	ON(T.serie_cfd = P.serie_cfd AND T.folio_fiscal = P.folio_fiscal)
		WHEN MATCHED THEN
			UPDATE SET fecha = P.fecha, sucursal = P.sucursal, remision = P.remision, cliente = P.cliente, confirmada = P.confirmada, 
					importe = P.importe, intento = T.intento + 1, no_error = P.no_error, msg_error = P.msg_error, archivo = P.archivo, 
					registro = P.registro
		WHEN NOT MATCHED THEN
			INSERT(fecha, sucursal, serie_cfd, folio_fiscal, remision, cliente, confirmada, importe, intento, no_error, msg_error, archivo, registro)
			VALUES(P.fecha, P.sucursal, P.serie_cfd, P.folio_fiscal, P.remision, P.cliente, P.confirmada, P.importe, P.intento, P.no_error, P.msg_error, P.archivo, P.registro);
END

GO


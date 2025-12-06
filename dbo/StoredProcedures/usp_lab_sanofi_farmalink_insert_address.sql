
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	
--CREATE	--DROP
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_insert_address]

	@b2b_order_number	VarChar(100),
	@seccion					VarChar(030),
	@FirstName				VarChar(090),
	@LastName					VarChar(090),
	@Address1					VarChar(090),
	@Address2					VarChar(090),
	@Address3					VarChar(090),
	@City							VarChar(090),
	@PostalCode				VarChar(090),
	@State						VarChar(090),
	@Country					VarChar(090),
	@CompanyName			VarChar(090),
	@Letra						VarChar(001),
	@Cliente					VarChar(006),
	@recepcion				DateTime


AS

/*

EXECUTE usp_lab_sanofi_farmalink_insert_address '123', 1, 'Miguel','Samayoa', 'Lago Anahuac 123', 'Col. Anahuac ', 'Miguel Hidalgo', 'Mexico', '11400', 'D.F.', 'MX','Farmaceutica Micro', 'A', '00000', '2012-06-27 13:46:25:123'
EXECUTE usp_lab_sanofi_farmalink_insert_address '123', 2, 'Miguel','Samayoa', 'Lago Anahuac 123', 'Col. Anahuac ', 'Miguel Hidalgo', 'Mexico', '11400', 'D.F.', 'MX','Farmaceutica Micro', 'A', '00000', '2012-06-27 13:46:25:123'
EXECUTE usp_lab_sanofi_farmalink_insert_address '123', 3, 'Miguel','Samayoa', 'Lago Anahuac 123', 'Col. Anahuac ', 'Miguel Hidalgo', 'Mexico', '11400', 'D.F.', 'MX','Farmaceutica Micro', 'A', '00000', '2012-06-27 13:46:25:123'
*/

DECLARE @sucursal INT
SET @sucursal = 
	(SELECT sucursal FROM clientes_baan 
		WHERE cliente = @cliente AND letra = @letra)

INSERT INTO pedidos_lab_sanofi_address (
	b2b_order_number, 
	seccion, 
	FirstName, 
	LastName, 
	Address1, 
	Address2, 
	Address3, 
	City, 
	PostalCode, 
	State, 
	Country, 
	CompanyName, 
	letra, 
	cliente, 
	recepcion,
	sucursal
)
VALUES (
	@b2b_order_number, 
	@seccion, 
	@FirstName, 
	@LastName, 
	@Address1, 
	@Address2, 
	@Address3, 
	@City, 
	@PostalCode, 
	@State, 
	@Country, 
	@CompanyName, 
	@letra, 
	@cliente, 
	@recepcion,
	@Sucursal
)
GO

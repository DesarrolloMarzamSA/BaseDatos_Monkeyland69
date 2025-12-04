-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spr_Pharmacy_apoyo
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
insert into [dbo].[pedidos_pharmacy_apoyo_historia]
( [sucursal]
      ,[cliente]
      ,[cod_barras]
      ,[cant_ped]
      ,[cant_surt]
      ,[motivo_no_surtido]
      ,[tamano_archivo_respuesta]
      ,[codigo]
      ,[arch_cliente]
      ,[arch_tandem]
      ,[orden]
      ,[hash_md5]
      ,[fecha_pedido]
      ,[hora_resp_tandem]
      ,[rftp]
      ,[tftp]
      ,[enviado_ftp]
      ,[factura]
      ,[piezas_sin_cargo]
      ,[precio_farmacia_sin_iva]
      ,[importe_descuento_oferta_unitario]
      ,[importe_descuento_financiero_unitario],[fechahistoria])
SELECT  [sucursal]
      ,[cliente]
      ,[cod_barras]
      ,[cant_ped]
      ,[cant_surt]
      ,[motivo_no_surtido]
      ,[tamano_archivo_respuesta]
      ,[codigo]
      ,[arch_cliente]
      ,[arch_tandem]
      ,[orden]
      ,[hash_md5]
      ,[fecha_pedido]
      ,[hora_resp_tandem]
      ,[rftp]
      ,[tftp]
      ,[enviado_ftp]
      ,[factura]
      ,[piezas_sin_cargo]
      ,[precio_farmacia_sin_iva]
      ,[importe_descuento_oferta_unitario]
      ,[importe_descuento_financiero_unitario],getdate()
  FROM [monkeyland].[dbo].[pedidos_pharmacy_apoyo]
END

GO


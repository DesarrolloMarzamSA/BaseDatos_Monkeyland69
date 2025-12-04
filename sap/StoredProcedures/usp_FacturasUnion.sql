-- =============================================
-- Author:		<JCPM>
-- Create date: <03/06/2021>
-- Description:	<obtiene la extracion de facturas para union >
-- exec [sap].[usp_FacturasUnion]
-- =============================================
CREATE PROCEDURE [sap].[usp_FacturasUnion]
AS
BEGIN
	-- Opciones iniciales
	SET NOCOUNT ON;
	
	declare @facturasSap table (
		[VWERK] varchar(10),
		[PARTNER] varchar(40),
		[XBLNR] varchar(40),
		[VBELN] varchar(40),
		[FKDAT] date,
		[POSNR] bigint,
		[MATNR] varchar(40),
		[ARKTX] varchar(40),
		[CHARG] varchar(40),
		[EAN11] varchar(40),
		[KONDM] varchar(40),
		[CANTIDAD] bigint,
		[PRECIOFARMACIA] decimal(15,2),
		[PRECIO_PUBLICO] varchar(40),
		[PRECIO_PUBLICO_IMP] varchar(40),
		[IMPORTE_BRUTO] varchar(40),
		[PORCENTAJE_OFERTAS] varchar(40),
		[OFERTAS] decimal(15,2),
		[PORCENTAJE_DESCUENTOS] varchar(40),
		[DESCUENTOS] decimal(15,2),
		[IEPS] decimal(15,2),
		[IVA] decimal(15,2),
		[IMPORTE_NETO] decimal(15,2),
		[BSTKD] varchar(40),
		[PORC_TMX1] decimal(15,2),
		[PORC_TMX2] decimal(15,2),
		[IND_SECTOR] varchar(40),
		[KNRZE] varchar(40),
		[TAXNUM] varchar(40),
		[IDNUMBER] varchar(40),
		[ALTKN] varchar(40),
		[NAME_ORG1] varchar(40)
	)

	insert into @facturasSap exec [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarquePlantilla] '','0011000003'

	select 
		 [facturaMarzam]=RIGHT('000000000000' +rtrim(VBELN),12)
		,[ordenMarzam]=BSTKD
		,[fechaFacturacion]=FKDAT
		,[serie]='FC'
		,[codigoCliente]=rtrim(ALTKN)
		,[numeroLinea]=POSNR
		,[codigoProducto]=MATNR
		,[codigoBarras]=EAN11
		,[descripcion]=ARKTX
		,[numeroPiezas]=CANTIDAD
		,[clasificacionFiscal]=KONDM
		,[precioFarmacia]=PRECIOFARMACIA
		,[oferta]=OFERTAS
		,[descuentoFinanciero]=DESCUENTOS
		,[IEPSPorcentaje]=PORC_TMX2
		,[IEPS]=IEPS
		,[totalIEPS]=0
		,[IVAPorcentaje]=PORC_TMX1
		,[IVA]=IVA
		,[precioBaseUnitario]=PRECIOFARMACIA
		,[precioBaseCantidad]=(cantidad*precioFarmacia)
		,[precioNetoUnitario]=IMPORTE_NETO
		,[precioNetoCantidad]=Convert(decimal(15,2),(IMPORTE_NETO/cantidad))
		,[ordenCliente]=BSTKD
		,[secuenciaCalculos]=1
		,[precioTotalSinImpuestos]=IMPORTE_NETO
		,[PSSALP]=PRECIOFARMACIA
	from @facturasSap
		
END

GO


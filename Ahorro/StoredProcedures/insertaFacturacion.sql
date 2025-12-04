-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[insertaFacturacion]
@cuentaEstiloAhorro varchar(15),
@orden varchar(15),
@sucursal varchar(5),
@cuentaERP varchar(15),
@nombreArchivo varchar(50),
@contenido varchar(max),
@fechaFactura datetime,
@hash varchar(600)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@hash is null)
	begin
   merge [Ahorro].[encabezadoFacturasAhorro] as destino
   using (Select convert(varchar(1000),HASHBYTES('SHA2_256',@contenido),1) as hash,
				 @cuentaEstiloAhorro as cuentaEstiloAhorro,
				 @orden as orden,
				 @sucursal as sucursal,
				 @cuentaERP as cuentaERP,
				 @nombreArchivo as nombreArchivo,
				 @contenido as contenido,
				 @fechaFactura as fechaFactura) as origen
	on (destino.cuentaEstiloAhorro=origen.cuentaEstiloAhorro and destino.orden=origen.orden)
	WHEN NOT MATCHED BY TARGET
	THEN INSERT ([hashMd5],[cuentaEstiloAhorro],[orden],[sucursal],[cuentaERP],[nombreArchivo]
      ,[contenido],[fechaInsercion],[fechaCarga],[fechaFactura],[estatus]) 
	  VALUES (origen.hash,origen.cuentaEstiloAhorro,origen.orden,origen.sucursal,origen.cuentaERP,origen.nombreArchivo,
			  origen.contenido,getdate(),null,origen.fechaFactura,10);
	end 
	else
	begin
	merge [Ahorro].[encabezadoFacturasAhorro] as destino
	using (Select @hash as hash,
				 @cuentaEstiloAhorro as cuentaEstiloAhorro,
				 @orden as orden,
				 @sucursal as sucursal,
				 @cuentaERP as cuentaERP,
				 @nombreArchivo as nombreArchivo,
				 @contenido as contenido,
				 @fechaFactura as fechaFactura) as origen
	on (destino.cuentaEstiloAhorro=origen.cuentaEstiloAhorro and destino.orden=origen.orden)
	WHEN NOT MATCHED BY TARGET
	THEN INSERT ([hashMd5],[cuentaEstiloAhorro],[orden],[sucursal],[cuentaERP],[nombreArchivo]
      ,[contenido],[fechaInsercion],[fechaCarga],[fechaFactura],[estatus]) 
	  VALUES (origen.hash,origen.cuentaEstiloAhorro,origen.orden,origen.sucursal,origen.cuentaERP,origen.nombreArchivo,
			  origen.contenido,getdate(),null,origen.fechaFactura,10);
	end

END

GO


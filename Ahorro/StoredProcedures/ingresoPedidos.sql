
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[ingresoPedidos] 
@pedidos as [Ahorro].[pedidosFilialesData] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @hasPedido as varchar(50)
	Declare @errorMessage as varchar(max)
	Declare @numeroLineas as int
	Declare @fechaProcesamiento as datetime

	DECLARE @ErrorSeverity INT;  
	DECLARE @ErrorState INT;

	Declare @catalogoProductos Table
	(
	 codigoMarzam varchar(7) NULL,
	 codigoNumericoMarzam bigint,
	 codigoBarras varchar(15) NULL,
	 numeroRepeticion int
	)

	begin try
		select top 1 @hasPedido=[hashMd5] from @pedidos

		--preguntar si ya fue ingresado
		if exists(select * from hashes_md5 where firma =@hasPedido)
		begin
			declare @nombreArchivo as varchar(50)
			select top 1 @nombreArchivo=archivoCliente from @pedidos
			select @errorMessage='El archivo ' +@nombreArchivo+' ya fue procesado con anterioridad'
			RAISERROR (@errorMessage,16,1);
		end
		else
		begin
			insert into @catalogoProductos (codigoMarzam,codigoNumericoMarzam,codigoBarras,numeroRepeticion)
			SELECT [codigo],CONVERT(bigint,codigo),[cod_barras],ROW_NUMBER() over(partition by cod_barras order by codigo) as numeroRepeticion --enumera las repeticiones del mismo codigo de barras
			FROM [capa_ibs].[dbo].[maestro_productos]
			where CONVERT(bigint,codigo)<3000000  or codigo in ('3401416','3401417', '3401807')
			order by cod_barras,codigo

			delete from @catalogoProductos where numeroRepeticion>1 --elimina todos los codigos de barras duplicados y deja solo la primera aparicion

			select @fechaProcesamiento=GETDATE()

			begin try
					BEGIN TRAN --Iniciamos la transacción

					Merge [Ahorro].[encabezadoPedidosFiliales] as destino
					using (Select a.[hashMd5],
						   a.archivoCliente,
						   @fechaProcesamiento as fechaProcesamiento,
						   10 as estatus,
						   COUNT(1) as numeroLineas,
						   a.[cuentaEstiloAhorro],
						   a.[ordenCliente],
						   case when a.[tipoPedido] = 'C' then c.sucursal_factura
								when a.[tipoPedido] = 'N' then c.sucursal_remision
						   end as sucursal,
						   case when a.[tipoPedido] = 'C' then c.cuenta_factura
								when a.[tipoPedido] = 'N' then c.cuenta_remision
						   end as cuenta,
						   case when a.[tipoPedido] = 'C' then (case when c.sucursal_factura=1 then 'A'
																	 when c.sucursal_factura=21 then 'A'
																	 when c.sucursal_factura=2 then 'C'
																	 when c.sucursal_factura=3 then 'C'
																	 when c.sucursal_factura=4 then 'D'
																	 when c.sucursal_factura=5 then 'E'
																	 when c.sucursal_factura=6 then 'J'
																	 when c.sucursal_factura=7 then 'G'
																	 when c.sucursal_factura=8 then 'G'
																	 when c.sucursal_factura=9 then 'E'
																	 when c.sucursal_factura=11 then 'M'
																	 when c.sucursal_factura=13 then 'M'
																	 when c.sucursal_factura=16 then 'P'
																	 when c.sucursal_factura=17 then 'Q'
																	 when c.sucursal_factura=18 then 'R'
																	 when c.sucursal_factura=19 then 'R'
																	 when c.sucursal_factura=23 then 'X'
																	 when c.sucursal_factura=24 then 'X'
																	 when c.sucursal_factura=25 then 'Y'
																	 when c.sucursal_factura=27 then 'G'
																end)+ cuenta_factura
								when a.[tipoPedido] = 'N' then (case when c.sucursal_factura=1 then 'A'
																	 when c.sucursal_factura=21 then 'A'
																	 when c.sucursal_factura=2 then 'C'
																	 when c.sucursal_factura=3 then 'C'
																	 when c.sucursal_factura=4 then 'D'
																	 when c.sucursal_factura=5 then 'E'
																	 when c.sucursal_factura=6 then 'J'
																	 when c.sucursal_factura=7 then 'G'
																	 when c.sucursal_factura=8 then 'G'
																	 when c.sucursal_factura=9 then 'E'
																	 when c.sucursal_factura=11 then 'M'
																	 when c.sucursal_factura=13 then 'M'
																	 when c.sucursal_factura=16 then 'P'
																	 when c.sucursal_factura=17 then 'Q'
																	 when c.sucursal_factura=18 then 'R'
																	 when c.sucursal_factura=19 then 'R'
																	 when c.sucursal_factura=23 then 'X'
																	 when c.sucursal_factura=24 then 'X'
																	 when c.sucursal_factura=25 then 'Y'
																	 when c.sucursal_factura=27 then 'G'
																end) + c.cuenta_remision
						   end as cuentaMarzam,
						   '' as nombreHandHeld,
						   null as fechaGeneracionHandHeld,
						   r.letra
					from @pedidos as a
					left join cat_cuentas_spt_fahorro as c on a.cuentaEstiloAhorro=c.cuenta_estilo_ahorro
					left join [dbo].[rutas_pedidos_AS400] as r on case when a.[tipoPedido] = 'C' then c.sucursal_factura
																	   when a.[tipoPedido] = 'N' then c.sucursal_remision
																  end  =r.sucursal
					group by a.[hashMd5],a.archivoCliente,a.[cuentaEstiloAhorro],a.[ordenCliente],a.[tipoPedido],
							 c.sucursal_factura,c.sucursal_remision,c.cuenta_factura,c.cuenta_remision,r.letra
					) as origen
					ON destino.[hashMd5]=origen.[hashMd5]
					when NOT MATCHED then
						insert ([hashMd5],[nombreArchivo],[fechaInsercion],[estatus],[numeroLineas]
								,[cuentaEstiloAhorro],[orden],[sucursal],[cuenta],[cuentaMarzam]
								,[nombreHandHeld],[fechaGeneracionHandHeld],[letraSucursal])
						values(origen.hashMd5,origen.archivoCliente,origen.fechaProcesamiento,origen.estatus
							  ,origen.numeroLineas,origen.cuentaEstiloAhorro,origen.ordenCliente,origen.sucursal
							  ,origen.cuenta,origen.cuentaMarzam,origen.nombreHandHeld,origen.fechaGeneracionHandHeld,origen.letra);



					Merge [Ahorro].[pedidosFiliales] as destino
					using (
					select a.[cuentaEstiloAhorro],
						   a.[hashMd5],
						   a.[ordenCliente],
						   a.[codigoBarras],
						   case when a.[tipoPedido] = 'C' then c.sucursal_factura
								when a.[tipoPedido] = 'N' then c.sucursal_remision
						   end as sucursal,
						   case when a.[tipoPedido] = 'C' then c.cuenta_factura
								when a.[tipoPedido] = 'N' then c.cuenta_remision
						   end as cuenta,
						   case when a.[tipoPedido] = 'C' then (case when c.sucursal_factura=1 then 'A'
																	 when c.sucursal_factura=21 then 'A'
																	 when c.sucursal_factura=2 then 'C'
																	 when c.sucursal_factura=3 then 'C'
																	 when c.sucursal_factura=4 then 'D'
																	 when c.sucursal_factura=5 then 'E'
																	 when c.sucursal_factura=6 then 'J'
																	 when c.sucursal_factura=7 then 'G'
																	 when c.sucursal_factura=8 then 'G'
																	 when c.sucursal_factura=9 then 'E'
																	 when c.sucursal_factura=11 then 'M'
																	 when c.sucursal_factura=13 then 'M'
																	 when c.sucursal_factura=16 then 'P'
																	 when c.sucursal_factura=17 then 'Q'
																	 when c.sucursal_factura=18 then 'R'
																	 when c.sucursal_factura=19 then 'R'
																	 when c.sucursal_factura=23 then 'X'
																	 when c.sucursal_factura=24 then 'X'
																	 when c.sucursal_factura=25 then 'Y'
																	 when c.sucursal_factura=27 then 'G'
																end)+ cuenta_factura
								when a.[tipoPedido] = 'N' then (case when c.sucursal_factura=1 then 'A'
																	 when c.sucursal_factura=21 then 'A'
																	 when c.sucursal_factura=2 then 'C'
																	 when c.sucursal_factura=3 then 'C'
																	 when c.sucursal_factura=4 then 'D'
																	 when c.sucursal_factura=5 then 'E'
																	 when c.sucursal_factura=6 then 'J'
																	 when c.sucursal_factura=7 then 'G'
																	 when c.sucursal_factura=8 then 'G'
																	 when c.sucursal_factura=9 then 'E'
																	 when c.sucursal_factura=11 then 'M'
																	 when c.sucursal_factura=13 then 'M'
																	 when c.sucursal_factura=16 then 'P'
																	 when c.sucursal_factura=17 then 'Q'
																	 when c.sucursal_factura=18 then 'R'
																	 when c.sucursal_factura=19 then 'R'
																	 when c.sucursal_factura=23 then 'X'
																	 when c.sucursal_factura=24 then 'X'
																	 when c.sucursal_factura=25 then 'Y'
																	 when c.sucursal_factura=27 then 'G'
																end) + c.cuenta_remision
						   end as cuentaMarzam,
						   a.[tipoPedido],
						   isnull(b.codigoMarzam,'') as codigoMarzam,
						   a.[cantidadPedida],
						   a.[precioFarmacia],
						   a.[importeOferta],
						   a.[importeProntoPago],
						   a.[tipoOferta],
						   a.[porcentajeOferta],
						   '' as archivoHandHeld,
						   'P' as estatus, --P es pedido ingresado
						   @fechaProcesamiento as fechaProcesamiento				   
					from @pedidos as a
					left join @catalogoProductos as b on a.[codigoBarras]=b.codigoBarras
					left join cat_cuentas_spt_fahorro as c on a.cuentaEstiloAhorro=c.cuenta_estilo_ahorro
					) as origen
					on (destino.[cuentaEstiloAhorro] =origen.[cuentaEstiloAhorro] and destino.[hashMd5] =origen.[hashMd5] and destino.[orden] =origen.[ordenCliente] and destino.[codigoBarras] =origen.[codigoBarras])
					when not Matched then
						insert ([cuentaEstiloAhorro],[hashMd5],[orden],[codigoBarras],[sucursal],[cuenta],[cuentaMarzam],[tipoPedido],[codigo],[cantidadPedida],[precioFarmacia],[importeOferta],[importeProntoPago]
							   ,[tipoOferta],[porcentajeOferta],[archivoTandem],[status],[timestamp])
						values (origen.[cuentaEstiloAhorro],origen.[hashMd5],origen.[ordenCliente],origen.[codigoBarras],origen.sucursal,origen.cuenta,origen.cuentaMarzam,origen.[tipoPedido],origen.codigoMarzam
							   ,origen.[cantidadPedida],origen.[precioFarmacia],origen.[importeOferta],origen.[importeProntoPago],origen.[tipoOferta],origen.[porcentajeOferta],origen.archivoHandHeld,origen.estatus
							   ,origen.fechaProcesamiento);

					insert into [dbo].[hashes_md5] ( [programa],[firma],[fecha]) values ('PedidosSptFahorro',@hasPedido,@fechaProcesamiento)

					COMMIT TRAN
			end try
			begin catch
				--este trycatch es solo para el rollback de la transaccion
				SELECT @errorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
				ROLLBACK TRAN
				RAISERROR (@errorMessage,@ErrorSeverity,@ErrorState);
			end catch

			SELECT a.[orden],b.[letraSucursal] as sucursal,a.[cuenta],a.[cuentaMarzam],[codigo],[cantidadPedida],[archivoTandem],[status],[timestamp],a.hashMd5
			FROM [Ahorro].[pedidosFiliales] as a
			left join [Ahorro].[encabezadoPedidosFiliales] as b on b.[hashMd5]=a.hashMd5
			where a.[hashMd5]=@hasPedido and b.estatus=10 and a.sucursal is not null and a.codigo<>'' and a.codigo is not null
			order by [codigo]

		end
	end try
	begin catch
		--este trycatch es para el manejo de errores
		SELECT @errorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		
		RAISERROR (@errorMessage,@ErrorSeverity,@ErrorState);
	end catch
END

GO





CREATE	--	DROP
PROCEDURE [dbo].[usp_fbenavides_pedidos_ci_insert_pc]

@linea			 INT		,
@fecha_pedido	 varchar(10),
@orden_compra	 VARCHAR(10),
@cia			 VARCHAR( 4),
@mostrador		 VARCHAR( 4),
@cod_bena		 VARCHAR(18),
@cantidad_pedida INT		,
@arch_cliente	 VARCHAR(50),
@hash_md5		 VARCHAR(50),			

@PrecioFarm      VARCHAR(20),
@Procet_ofet     VARCHAR(10),
@Porcet_desc     VARCHAR(10),
@Porcet_desc1    VARCHAR(10),
@Porcet_desc2    VARCHAR(10),
@Porcet_desc3    VARCHAR(10),
@Porcet_desc4    VARCHAR(10),
@Porcet_iva      VARCHAR(10),
@Precio_costo    VARCHAR(20)

/*
SELECT * FROM pedidos_fbenavides_ci WITH (NOLOCK) ORDER BY linea
*/

AS

/*
EXECUTE 
[usp_fbenavides_pedidos_ci_insert_pc]
1,
'2011-01-01',									
'123456789',
'M029',
'0001',
'000000000000364509',
15,
'PE20111128_150029.TXT',
'8f4098ba0a7d46c4dce3ced0f2b8be0d'
*/

DECLARE 
 @letra		      VARCHAR(1) ,
 @sucursal	      INT	    ,
 @cliente	      VARCHAR(5) ,
 @cod_barras	  VARCHAR(13),
 @codigo		  VARCHAR(7)	,
 @existe		  int		,
 @descripcion     VARCHAR(100),
 @CodError        int =0,  
  @ErrorSeverity  int,  
  @ErrorState     int,  
  @ErrorProcedure varchar(100),  
  @ErrorLine      int,  
  @ErrorMessage   varchar (250),  
  @mensaprocedure varchar(250) ='[usp_fbenavides_pedidos_ci_insert_pc]' ;
set @letra='O'
set @sucursal=0
set @cliente='00000'
set @cod_barras='0000000000000'
set @codigo='0000000'
set @descripcion=''

	--set @existe = (select count(*) from pedidos_fbenavides_ci where letra=@letra and sucursal=@sucursal and cliente=@cliente and cia=@cia and mostrador=@mostrador and codigo=@codigo 
	--and	cod_bena=@cod_bena and pedido=@orden_compra and cantidad_pedida=@cantidad_pedida and hash_md5=@hash_md5)

	--if @existe =0
	--begin
	begin try
INSERT INTO pedidos_fbenavides_ci_pc	(
	linea			,
	fecha_pedido	,
	pedido			,
	letra			,
	sucursal		,
	cliente			,
	cia				,
	mostrador		,
	codigo			,
	cod_bena		,
	descripcion		,
	cantidad_pedida	,
	arch_cliente	,
	hash_md5		,
	timestamp	,
	precio_farmacia,
	porcentaje_oferta,
	porcentaje_descto,
	porcentaje_descto1,
	porcentaje_descto2,
	porcentaje_descto3,
	porcentaje_descto4,
	porcentaje_iva,
	precio_costo										
) VALUES (
	@linea								,
	cast(@fecha_pedido as smalldatetime),
	@orden_compra						,
	@letra								,
	@sucursal							,
	@cliente							,
	@cia								,
	@mostrador							,
	@codigo								,
	@cod_bena							,
	@descripcion						,
	@cantidad_pedida					,
	@arch_cliente						,
	@hash_md5							,
	GETDATE()							,
	@PrecioFarm                         ,
	@Procet_ofet                        ,
	@Porcet_desc                        ,
	@Porcet_desc1                       ,
	@Porcet_desc2                       ,
	@Porcet_desc3                       ,
	@Porcet_desc4                       ,
	@Porcet_iva                         ,
	@Precio_costo                       )
   end try

		   begin catch
       SELECT  
        @CodError= ERROR_NUMBER() ,   
        @ErrorSeverity= ERROR_SEVERITY()  
        ,@ErrorState=ERROR_STATE()  
        ,@ErrorProcedure =ERROR_PROCEDURE()   
        ,@ErrorLine=ERROR_LINE()   
        ,@ErrorMessage=ERROR_MESSAGE(); 
		
		EXEC [mob_sp_LOGERRORBenavides]  'insertar encabezado',@CodError,@ErrorMessage,@ErrorProcedure,@ErrorLine
           
		end catch
SET NOCOUNT on;
--select * from cat_productos_benavides

GO


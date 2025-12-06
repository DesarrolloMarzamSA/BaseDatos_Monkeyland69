
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	DROP	
PROCEDURE [dbo].[usp_fanasa_pedidos_insert] 
@arch_cliente			VARCHAR(50)	,
@linea_buffer					VARCHAR(100),
@linea								INT					,
@fecha_pedido					DATETIME				,
@hash_md5							VARCHAR(100)  ,	
@cuenta								VARCHAR(5)	,	
@sucursal							INT					,
@pedido							VARCHAR(15)	,
@now					datetime
WITH ENCRYPTION
AS

--	TRUNCATE TABLE pedidos_chedraui_v3


DECLARE 
	
@codigo								VARCHAR(7)	,
@codigo_barras						VARCHAR(13)	,--YA
@descripcion					VARCHAR(30)	,
@precio								MONEY				,--YA
@desc_oferta							MONEY				,--YA
@desc_financiero								MONEY				,--YA
@desc_especial								MONEY				,--YA
@cantidad_pedida			INT					,--YA
@cantidad_sin_cargo			INT					,--YA	
@cantidad_surtida			INT					,	
@letra						char(1),
@cliente							VARCHAR(5)	,
@cliente_ibs					VARCHAR(7)	,
@archivo_hh					VARCHAR(20)	,
@tftp									DATETIME		,
@rftp									DATETIME		,
@timestamp						DATETIME		,
@proceso						int,
@orno						VARCHAR(6)		


/*
SET @archivo_cliente			= 'PEDIDO.TXT' 
SET @linea_buffer					= '0010110870000000172000000000475004972     000000100093852000000000120071120' 
SET @linea								= 1
SET @fecha_pedido					= GETDATE()  
*/
SET @codigo_barras=			ltrim(SUBSTRING(@linea_buffer ,1, 20)) 
SET @cantidad_pedida=		SUBSTRING(@linea_buffer , 22, 7) 
SET @desc_oferta=			SUBSTRING(@linea_buffer , 30, 5) 
SET @desc_financiero=		SUBSTRING(@linea_buffer , 36, 5)
SET @desc_especial=			SUBSTRING(@linea_buffer , 42, 5) 
SET @precio=				SUBSTRING(@linea_buffer , 48, 10) 
SET @cantidad_sin_cargo=	SUBSTRING(@linea_buffer , 59, 7)
SET @proceso=0
----SET @codigo
----SET @descripcion
--SET @cantidad_surtida
----SET @letra
--SET @cliente
--SET @cliente_ibs
--SET @archivo_hh
--SET @tftp
--SET @rftp
--SET @timestamp
--SET @proveedor
--SET @orden_pharmacy
--SET @fecha_emision

--create table #tmp_cod(cod varchar(7),descr varchar(50))
--insert into #tmp_cod select ibs.PJPRDC codigo,ibs.PJDESC from openquery(as400,'select * from MA4620EF04.SROEAN') ibs
--inner join fanasa_catalogo_manual fm on convert(int,ibs.PJPRDC)=convert(int,fm.codigo) and
--ltrim(CONVERT(varchar,ibs.PJEANP))=ltrim(CONVERT(varchar,fm.codigo_barras))
--where ltrim(ibs.PJEANP) =@codigo_barras and fm.codigo<dbo.gobierno()
--set @codigo = (select cod from  #tmp_cod) 
--set @descripcion = (select descr from #tmp_cod)
--drop table #tmp_cod


--create table #tmp_cod(cod varchar(7),descr varchar(50))
--insert into #tmp_cod select ibs.PJPRDC codigo,ibs.PJDESC from openquery(as400,'select * from MA4620EF04.SROEAN') ibs
--inner join fanasa_catalogo_manual fm on convert(int,ibs.PJPRDC)=convert(int,fm.codigo) and
--ltrim(CONVERT(varchar,ibs.PJEANP))=ltrim(CONVERT(varchar,fm.codigo_barras))
--inner join openquery(as400,'select * from MA4620EF04.SROPRG')cla on ibs.PJPRDC=cla.PGPRDC
--where ltrim(ibs.PJEANP) =@codigo_barras and fm.codigo<dbo.gobierno() and cla.PGSTAT<>'D'
--set @codigo = (select cod from  #tmp_cod) 
--set @descripcion = (select descr from #tmp_cod)
--drop table #tmp_cod


create table #tmp_cod(cod varchar(7),descr varchar(50))
insert into #tmp_cod select cat.codigo,cat.descripcion from cat_ean_prg cat
inner join fanasa_catalogo_manual fm on convert(int,cat.codigo)=convert(int,fm.codigo) and
cast(ltrim(CONVERT(varchar,cat.codigo_barras))as bigint)=cast(ltrim(CONVERT(varchar,fm.codigo_barras))as bigint)
where cast(ltrim(cat.codigo_barras) as bigint) =cast(@codigo_barras as bigint) and fm.codigo<dbo.gobierno() and cat.estatus<>'D'
set @codigo = (select cod from  #tmp_cod) 
set @descripcion = (select descr from #tmp_cod)
drop table #tmp_cod


SET	@letra = 
	(select ibs_letra from sucursales
	WHERE sucursal=@sucursal )
	SET @cliente=@cuenta

IF @codigo IS NULL
	SET @codigo = REPLICATE('0', 7)

------------SET @cliente_ibs =
------------	(SELECT cliente_ibs FROM cat_sucursales_fardemex 
------------	WHERE cliente = @mostrador )

------------SET @cliente =
------------	(SELECT cliente FROM cat_sucursales_fardemex 
------------	WHERE cliente = @mostrador )

------------SET @sucursal =
------------	(SELECT sucursal FROM cat_sucursales_fardemex 
------------	WHERE cliente = @mostrador )

IF @cuenta IS NULL	
	SET @cliente = REPLICATE('0', 5)

IF @sucursal IS NULL
	SET @sucursal = 0	

IF @cliente_ibs IS NULL
	SET @cliente_ibs = 'Z99999'



--------------SET @sucursal							= ( SELECT sucursal			FROM catalogo_chedraui_tiendas_V3	WHERE tienda = @tienda )
--------------SET @cliente							= ( SELECT cliente			FROM catalogo_chedraui_tiendas_V3	WHERE tienda = @tienda )
--------------SET @cliente_ibs					= ( SELECT cliente_ibs	FROM catalogo_chedraui_tiendas_V3	WHERE tienda = @tienda )

/*
SET @codigo								= ( SELECT codigo				FROM vi_catalogo_chedraui					WHERE cod_prodcli = @upc )

IF @codigo IS NULL
	SET @codigo								= ( SELECT codigo				FROM vi_catalogo_chedraui				WHERE cod_barras = RIGHT(REPLICATE('0',13) + RTRIM(LTRIM(@upc)), 13 ))

SET @descripcion					= ( SELECT descripcion	FROM vi_catalogo_chedraui					WHERE codigo = @codigo )

--SET @arch_tandem					= 'PCHA0001'
SET @cantidad_pedida			= SUBSTRING(@linea_buffer , 01, 03) 
--SET @cantidad_surtida			= 0 
--SET @hash_md5							= 'fsadjk3485970349fvhaepr58947589034789r5' 
--SET @rftp									= NULL

IF @codigo IS NULL
	SET @codigo = '0000000'
*/
SET @tftp									= GETDATE()
SET @timestamp						= GETDATE()


/*
SELECT @archivo_cliente			 AS  archivo_cliente		                   -- UNION   
SELECT @linea_buffer				 AS  linea_buffer			                   -- UNION   
SELECT @linea								 AS  linea							                   -- UNION   
SELECT @fecha_pedido				 AS  fecha_pedido			                   -- UNION   
SELECT @tienda							 AS  tienda						                   -- UNION   
																 
SELECT @compania						 AS  compania					                   -- UNION   
SELECT @proveedor						 AS  proveedor					                   -- UNION   
SELECT @orden_pharmacy			 AS  orden_pharmacy		                   -- UNION   
SELECT @bodega							 AS  bodega						                   -- UNION   
SELECT @upc									 AS  upc								                   -- UNION   
SELECT @cantidad_solicitada	 AS  cantidad_solicitad                   -- UNION   
SELECT @precio							 AS  precio						                   -- UNION   
SELECT @departamento				 AS  departamento			                   -- UNION   
SELECT @unid_med						 AS  unid_med					                   -- UNION   
SELECT @fecha_emision				 AS  fecha_emision			                   -- UNION   
																 
SELECT @sucursal						 AS  sucursal					                   -- UNION   
SELECT @cliente							 AS  cliente						                   -- UNION   
SELECT @cliente_ibs					 AS  cliente_ibs				                   -- UNION   
SELECT @codigo							 AS  codigo						                   -- UNION   
SELECT @arch_tandem					 AS  arch_tandem				                   -- UNION   
SELECT @cantidad_pedida			 AS  cantidad_pedida		                   -- UNION   
SELECT @cantidad_surtida		 AS  cantidad_surtida	                   -- UNION   
SELECT @hash_md5						 AS  hash_md5					                   -- UNION   
SELECT @tftp								 AS  tftp							                   -- UNION   
SELECT @rftp								 AS  rftp							                   -- UNION   
SELECT @timestamp						 AS	 timestamp					
*/



INSERT INTO pedidos_fanasa

VALUES
(
@arch_cliente,
@linea_buffer,
@linea,
@cuenta,
@fecha_pedido,
@pedido,
@codigo,
@codigo_barras,
@descripcion,
@precio,
@desc_oferta,
@desc_financiero,
@desc_especial,
@cantidad_pedida,
@cantidad_sin_cargo,
@cantidad_surtida,
@letra,
@sucursal,
@cliente,
@cliente_ibs,
@archivo_hh,
@hash_md5,
@tftp,
@rftp,
@now,--@timestamp,
@proceso,
@orno
)



INSERT INTO pedidos_fanasa_historia

VALUES
(
@arch_cliente,
@linea_buffer,
@linea,
@cuenta,
@fecha_pedido,
@pedido,
@codigo,
@codigo_barras,
@descripcion,
@precio,
@desc_oferta,
@desc_financiero,
@desc_especial,
@cantidad_pedida,
@cantidad_sin_cargo,
@cantidad_surtida,
@letra,
@sucursal,
@cliente,
@cliente_ibs,
@archivo_hh,
@hash_md5,
@tftp,
@rftp,
@now,--@timestamp,
@proceso,
@orno
)
GO

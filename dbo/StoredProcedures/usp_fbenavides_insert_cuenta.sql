
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fbenavides_insert_cuenta]	

--declare 
@cliente_ibs	varchar(06)			,
@frontera			bit							,
@mostrador		VARCHAR(08)			,
@descripcion	VARCHAR(40)			,
@franquicia		VARCHAR(10)			,
@fecha_alta		VARCHAR(10)			,
@controlados	BIT							,
@activo				BIT							

WITH ENCRYPTION
AS

declare 

@sucursal			INT							,
@cuenta				varchar(05)			

/*
EXECUTE usp_fbenavides_insert_cuenta 
 'A00000',								--			@cliente_ibs
 1,												--			@frontera		
 'M0000001',							--			@mostrador	
 'PRUEBA',								--			@descripcion
 'BENAVIDES',							--			@franquicia	
 '2012-07-02',						--			@fecha_alta	
 1,												--			@controlados
 1												--			@activo			
*/


/*
SET @cliente_ibs		= 'A00000'
SET @frontera				= 1
SET @mostrador			= 'M0000001'
SET @descripcion		= 'PRUEBA'
SET @franquicia			= 'BENAVIDES'
SET @fecha_alta			= '2012-07-02'
SET @controlados		= 1
SET @activo					= 1
*/

--SET @sucursal			= 0
--SET @cuenta				= '00000'
SET @cuenta				= SUBSTRING(@cliente_ibs, 2, 5)

--	BUSCA SUCURSAL CON FRONTERA 
SET @sucursal = (
	SELECT TOP 1 sucursal FROM sucursales 
	WHERE ibs_letra = LEFT(@cliente_ibs, 1) AND fisica = 1
	AND frontera = @frontera
	)

IF @sucursal IS NULL
	SET @sucursal			= 0
/*
	SET @sucursal = (
		SELECT TOP 1 sucursal FROM sucursales 
		WHERE ibs_letra = LEFT(@cliente_ibs, 1) 
		)
*/

INSERT INTO cat_sucursales_benavides 
(
	cliente_ibs							,
	frontera								,
	franquicia							,
	cia											,
	mostrador								,
	descripcion							,
	sucursal								,
	cuenta									,
	fecha_alta							,
	ibs_letra								,
	controlados							,
	activo			
)
VALUES
(
	@cliente_ibs											,
	@frontera													,
	@franquicia												,
	LEFT(@mostrador, 4)								,
	RIGHT(@mostrador, 4)							,
	@descripcion											,
	@sucursal													,
	@cuenta														,
	CONVERT(DATE,@fecha_alta,121)			,
	LEFT(@cliente_ibs,1)							,
	@controlados											,
	@activo			
)


select 
	cliente_ibs, 
	case when frontera = 1 then 'SI' else 'NO' end frontera ,
	cia, mostrador, franquicia, 
	descripcion, fecha_alta	  ,
	case when controlados = 1 then 'SI' else 'NO' end psicot 
from cat_sucursales_benavides where cliente_ibs = @cliente_ibs
GO

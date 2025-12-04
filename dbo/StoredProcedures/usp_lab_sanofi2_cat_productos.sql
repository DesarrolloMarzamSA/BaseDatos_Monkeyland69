


--usp_lab_sanofi2_cat_productos



--	CATALOGO DE PRODUCTOS SANOFI
--	HECHO POR MIGUEL SAMAYOA
--	2010-02-08	FECHA DE CREACION

CREATE 
--	CREATE
PROCEDURE usp_lab_sanofi2_cat_productos 
--	DECLARE
@fecha VARCHAR(10)
AS

/*	
usp_lab_sanofi2_cat_productos '2011-02-11'
*/

IF (SELECT COUNT(*) FROM sys.sysobjects WHERE name = 'lab_sanofi_cat_productos') = 0
	CREATE --	DROP	--	TRUNCATE
	TABLE lab_sanofi_cat_productos (
	codigo				VARCHAR( 7),
	descripcion		VARCHAR(30),
	cod_barras		VARCHAR(13),
	clas_fis			VARCHAR(2)
	PRIMARY KEY (codigo)
	)

TRUNCATE TABLE lab_sanofi_cat_productos	;

INSERT INTO lab_sanofi_cat_productos
SELECT		--	TOP 50
	codigo			,
	descripcion	,
	cod_barras	,
	clas_fis			
FROM maestro_productos_baan	mpb WITH(NOLOCK)
WHERE lab_corto = 'SANOFI' 
AND mpb.cod_barras IS NOT NULL 


SELECT		--	TOP 50
	LEFT(codigo				,120) codigo				,					
	LEFT(descripcion	,500) descripcion		,		
	LEFT(cod_barras		, 13)	cod_barras		,			
	LEFT(clas_fis			,  5)	clas_fis			
FROM lab_sanofi_cat_productos

GO


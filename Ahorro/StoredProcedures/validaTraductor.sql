
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[validaTraductor]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @fechaLocal datetime
DECLARE @fechaAS400 varchar(8)
DECLARE @queryAS400 varchar(500)
DECLARE @queryOpenquery varchar(500)

DECLARE @datosTraductor TABLE
(
cuenta varchar(10),
nombreArchivo varchar(30),
fechaTraductor datetime,
estatus int,
hashId varbinary(255)
)

select @fechaLocal=DATEADD(day,-2,getdate())
select @fechaAS400=convert(varchar, @fechaLocal,112)

select @queryAS400='select HCUNO,HARCHIVO,HFECHA,HORDS from marzamprd.z1ot4ctrh where HFecha>'''''+@fechaAS400+''''' AND HCLIENTE=''''HAND-HELD'''' and HMAPA=''''PEDIDOS'''' and HNCA1=''''99007'''' with ur'
select @queryOpenquery='select '+
				   ' rtrim(HCUNO) as cuenta,'+
				   ' rtrim(HARCHIVO) as nombreArchivo,'+
				   ' convert(datetime, stuff(stuff(STUFF(STUFF( replace(rtrim(HFECHA),''-'','' ''),14,0,'':'' ),12,0,'':'' ),7,0,''-''),5,0,''-''),121) as fechaTraductor,'+
				   ' HORDS,'+
				   ' HashBytes(''SHA1'',rtrim(HCUNO)+rtrim(HARCHIVO)+rtrim(HFECHA))'+
				   ' from Openquery(AS400,'''+@queryAS400+''')'

insert into @datosTraductor(cuenta,nombreArchivo,fechaTraductor,estatus,hashId)
exec(@queryOpenquery)

 merge [Ahorro].[datosTraductor] as destino
 using (select [hashId],[cuenta],[nombreArchivo],[fechaTraductor],[estatus] from @datosTraductor) as origen
 on (destino.[hashId]=origen.[hashId])
 when not matched
 then insert ([hashId],[cuenta],[nombreArchivo],[fechaTraductor],[estatus])
	  values (origen.[hashId],origen.[cuenta],origen.[nombreArchivo],origen.[fechaTraductor],origen.[estatus]);

END

GO


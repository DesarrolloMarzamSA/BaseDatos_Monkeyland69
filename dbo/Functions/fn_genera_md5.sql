



CREATE  function fn_genera_md5(@cadena varchar(1000))
returns varchar(50)
as
begin
return substring(master.dbo.fn_varbintohexstr(convert(VARBINARY(500), dbo.MD5(CONVERT(VARBINARY(500), @cadena)))), 3, 33)
end

GO



-- MD5 ff transformation
CREATE FUNCTION dbo.md5_ff
(
@a INT,
@b INT,
@c INT,
@d INT,
@x INT,
@s INT,
@t INT
)
RETURNS INT
BEGIN
   RETURN dbo.md5_add(dbo.md5_bitrol(dbo.md5_add(dbo.md5_add(@a, (@b & @c) | ((~@b) & @d)), dbo.md5_add(@x, @t)), @s),@b)
END

GO


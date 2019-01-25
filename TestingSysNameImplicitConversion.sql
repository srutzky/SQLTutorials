--Recently I ran into some issues when connecting to a contained database via a dedicated adminstrative connection (DAC).  There exists a certain table that can only be accessed via a DAC. 
--Basically, the query wasn't returning any results.  On a hunch, I casted the variable as sysname, and then it worked.
--This raised questions about implicit conversion.  We all think that sysname will convert to nvarchar, implicitely, but in this case it did not.  So I tested multiple scenarios, as can be seen below.
--The resulting theory of this test is that perhaps there is something odd about the sys.sysowners table in contained databases, or a DAC, and normal expectations of implicit conversion do not apply. 
DECLARE @sysnamed sysname = 'scott';
DECLARE @nvarcharSysname nvarchar (128) = 'scott';
DECLARE @nvarcharWrong nvarchar (50) = 'scott';
DECLARE @SQL nvarchar(max) = @sysnamed + @nvarcharSysname;
SET @SQL = @sysnamed + @nvarcharWrong;
set @nvarcharWrong = @sysnamed;

IF OBJECT_ID('testSysname') is not null
DROP TABLE testSysname
CREATE TABLE testSysname (
sysnametypefield sysname
)
INSERT INTO testSysname (sysnametypefield) values
(@sysnamed),
(@nvarcharSysname)
, (@nvarcharWrong)
, (@SQL)

SELECT * FROM testSysname WHERE sysnametypefield LIKE '%scott%';
SELECT * FROM testSysname WHERE sysnametypefield = @nvarcharWrong;

SELECT @SQL = 'SELECT  sysnametypefield FROM testSysname WHERE sysnametypefield = ''' + sysnametypefield + '''' FROM testSysname WHERE  sysnametypefield = @nvarcharWrong;
			EXEC sp_executesql @SQL;
SELECT @SQL = 'SELECT  sysnametypefield FROM testSysname WHERE sysnametypefield = ''' + sysnametypefield + '''' FROM testSysname WHERE  sysnametypefield = CAST(@nvarcharWrong as sysname);
			EXEC sp_executesql @SQL;
EXEC sp_executesql @sql;

 

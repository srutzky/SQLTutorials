--Sometimes you need to pump a lot of data into a table to show someone that a datalengthColumn) operation will, in fact, trip off a clustered index scan.
CREATE table stuffed (
idint int identity,
stuffme nvarchar (max)
)
TRUNCATE TABLE stuffed
INSERT INTO stuffed (stuffme)
values
('ab')
--SEt STATISTICS IO, TIME ON
SELECT stuffme from stuffed
--with very little data
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

(1 row affected)
Table 'stuffed'. Scan count 1, logical reads 1, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 3 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
   */
SELECT datalength(stuffme) from stuffed
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

(1 row affected)
Table 'stuffed'. Scan count 1, logical reads 1, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 7 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
   */
   --Now load it up
   --5 doubled
   SELECT datalength(stuffme) from stuffed 
   --length = 128
   --Table 'stuffed'. Scan count 1, logical reads 1, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
   DECLARE @SQL nvarchar (max)
   SELECT @SQL = stuffme FROM stuffed WHERE idint =1
   --Table 'stuffed'. Scan count 1, logical reads 1, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

   GO
   SET NOCOUNT ON
   SELECT TOP 1 * FROM stuffed ORDER by idINt desc
DECLARE @i int = 0
DECLARE @iMax int = 6000 --(roughly 100 GB
DECLARE @SQL nvarchar (max)
--set statistics time, io off
WHILE @i < @iMax
BEGIN
	WHILE @i <= 21 
	BEGIN
		SELECT @SQL = stuffme FROM stuffed WHERE idint = 1
		UPDATE stuffed SET stuffme = @SQL + @SQL WHERE idint = 1
		SET @i = @i + 1
	END
	SET @i = 0
	WHILE @i <= 21 --create 21 rows - I could write this max value to double up to a certain value and then start doing large batches of 1000
	BEGIN
		INSERT stuffed (stuffme)  SELECT stuffme FROM stuffed WHERE idint = 1 
		SET @i = @i + 1
	END
	WHILE @i <= 104 --create 100 rows - I could write this max value to double up to a certain value and then start doing large batches of 1000
	BEGIN
		INSERT stuffed (stuffme)   SELECT stuffme FROM stuffed WHERE idint < 21 
		SET @i = @i + 21
	END
	WHILE @i <= @imax --create 21 rows - I could write this max value to double up to a certain value and then start doing large batches of 1000
	BEGIN
		INSERT stuffed (stuffme)   SELECT stuffme FROM stuffed WHERE idint < 100 
		SET @i = @i + 100
	END
END

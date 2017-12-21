/* This is a simple looping structure.  Iterate over the rows in a table where the rows are known
to have cardinality (<-- just a fancy way of saying each row increases by unity (<- cany way of saying the number '1)) 

PROBLEM - can you alter this SQL code to make a sqitch so that the job will either be enabled, or disabled, based on an input?

PROBLEM - What else can you think of that this script could be altered to do? Later, 
I'll take this script and convert it into a stroed procedure.*/

 
DECLARE @variable int = 1
		,@imax int
		,@i int 
		,@SQL nvarchar (max)
		--Can anyone explain why we put the commas at the FRONT of the definition? (answer at the bottom)

IF object_id('tempdb..#myTable') IS NOT NULL
DROP TABLE #myTable
CREATE TABLE #myTable (
	MTID int identity (1,10)
	,MyJob nvarchar (200)
	)
/*

. . . pretend there is other other program code here 

*/
                      
TRUNCATE TABLE #myTable /* Let's just assume there is other code between this block and declarations, 
      and one of those blocks may have already used this table.  Truncating a table resets the Identity column */
      
     /*There are some checks I could do here... I will create more examples of things 
     like data validators to explaine what I do, what I don't do, and why.*/
      
INSERT INTO #myTable SELECT name FROM msdb.dbo.sysjobs WHERE name like '%sp%' and enabled = 0
SELECT @iMax = max(MTID) FROM #myTable
SET @i = 1
WHILE @i <= @imax
BEGIN
	SELECT @SQL = '
		EXEC msdb.dbo.sp_update_job @job_name = N''' + MyJob + ''',' + ' @enabled = 1
		;
		EXEC msdb.dbo.sp_Start_job N''' + MyJob + '''' FROM #myTable WHERE MTID = @i
	--EXEC sp_executesql @SQL
	PRINT @SQL
	SET @i = @i + 1
END
SET @i = 1 --just being considerate, here. A good way to introduce a bug is for someone else to add acode  block and mess up validation.
SET @SQL = ''
--placing the comma at the beginning of a line makes it easier to A) comment out if needed and B) copy and paste to somewhere else

--This demonstrates recursion in SQL, as well as somethign you might call "faux-recursion" which is the preferred method of doing recursion in SQL
--You can play with this, and test it yuourself, at http://sqlfiddle.com/

IF object_id('SomethingHappened') is not NULL
DROP TABLE SomethingHappened  --If you know you are only ever going to have one line in the IF block, you don't need a BEGIN END. Use them if you anticipate more than one.

--Create a permanent table that can be used throughout this example
CREATE TABLE SomethingHappened (
id int identity,
i int,
eventMessage nvarchar (200)
)

--NOTE- this is not the preffered method of recursion - SQL limits you to 32 recursions and there is no way around it.  However, at times, you may find you do need to have a stored preocduure call back to itself
GO --Batch separator, SQL doesn't like anything else to be inside the creation of stored procedure
IF OBJECT_ID('RecursionMon') IS NULL
	EXEC ('CREATE PROCEDURE RecursionMon AS RETURN 0;') --for idempotency and backwards compatibility for versions that don't support "Drop if Exists" DIE. 
GO

ALTER PROCEDURE RecursionMon 
@sendOutMax int, --AKA recursion max, how many times do we want the recusrive procedure to run
@sendIn int
AS
	-- this variable has local scope to the procedure
	INSERT INTO SomethingHappened (i, EventMessage) VALUES (@sendIn, 'This is what you just sent in : ' + cast(@sendIn as nvarchar)) 
	PRINT 'This is what you just sent in : ' + cast(@sendIn as nvarchar) -- the 'n' is SQL's way of allowing unicode.  I generally always allow it but you have to remember that the data length of actual bytes stored is double what the string length may look to be. Unicode stores two bytes for every one character, evven if its just 00.
	PRINT 'Performing calculation'

	IF @sendIn = @sendOutMax
	BEGIN
			INSERT INTO SomethingHappened (i, EventMessage) VALUES (@sendIn, 'Recursion Limit of ' + cast(@sendOutMax as nVarchar) + ' Reached.  You are about to hit the SQL Server Limit of 32 recursions') 
			RETURN
	END

	SET @sendIn = @sendIn + 1
	PRINT 'This is what I am sending out (only to be sent right back in, so I''m not really going out at all...? @sendOut = ' + cast (@sendIn as nVarchar)
	EXEC RecursionMon @sendIn = @sendIn, @sendOutMax = @sendOutmax


GO
--Now lets call the stored procedure with some values and see what happens.

EXEC RecursionMon @sendIn = 1, @sendOutMax = 30
SELECT * FROM SomethingHappened

GO /* This resets any previously declared variables, which by now I'm guessing yuou understand all begin with '@' */

--now, the above is the typical way that programs like C++ and others do it.  Unlike SQL, they don't have a limit.  TO get around this, SQL has something called a WHILE Loop, which wil lrun forever, if unchecked

-- here is, essentially, the exact same code as above, using a table and a WHILE Loop.  Notice it's a hell of a lot less code to write.
TRUNCATE TABLE SomethingHappened --Remove any rows from previous run, as well as reset the identity seed column
DECLARE 
	@iMax int = 300
	,@i int = 1

WHILE NOT EXISTS (SELECT i FROM SomethingHappened WHERE i = @imax)
BEGIN
	INSERT INTO SomethingHappened (i, EventMessage) VALUES (@i, 'This is what you just sent in : ' + cast(@i as nvarchar)) 
	IF @i = @iMax
	BEGIN
			INSERT INTO SomethingHappened (i, EventMessage) VALUES (@i, '@iMax Limit of ' + cast(@iMax as nVarchar) + ' Reached.  You are about to hit the SQL Server Limit of 32 recursions') 
	END
	SET @i = @i + 1
END
SELECT * FROM SomethingHappened

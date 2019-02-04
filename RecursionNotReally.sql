-- Not really recursion, because SQL hates that, but a sort-of imitation 
--If I want to make an operation iterate one at a time over a data table, some people will use a cursor
--I hate cursors.

CREATE taBLE testRecursiveOps (
tRoiD int identity primary key
,someValue nvarchar (1)
)
INSERT INTO testRecursiveOps (someValue)
VALUES 
	('a'),('b'),('c'),('d'),('e'),('f'),('g'),('h'),('i'),('j'),('k'),('l'),('m'),('n'),('o'),('p'),('q'),('r'),('s'),('t'),('u'),('v'),('w'),('x'),('y'),('z')

DECLARE @thisLetter nvarchar (1) 
DECLARE @nextLetter nvarchar (1)
DECLARE @iMax int
DECLARE @iMin int
DECLARE @quit bit = 0

SELECT @iMax = max(tRoiD) FROM  testRecursiveOps 
SELECT @iMin = min(tRoiD) FROM  testRecursiveOps 

WHILE @iMin <= @iMax 
BEGIN

	SELECT @thisLetter = someValue, @iMin = (SELECT Top 1 tRoiD FROM  testRecursiveOps WHERE tRoiD > @iMin) FROM testRecursiveOps WHERE @iMin = tRoiD
	IF @quit = 1
	BEGIN 
		SET @iMin = @iMin + 1
		PRINT @thisLetter
	END
	ELSE 
	PRINT @thisLetter
	IF @iMax = @iMin AND @quit = 0
	SET @quit = 1
END

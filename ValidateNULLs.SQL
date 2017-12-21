 /* There are many times when it is desirable to validate the contents of a 
 variable before performing some action. Lets start with NULLs, because they are easy.
 
 It is safe to assume taht we "know" what data will be where, and when it will be there, but the data we are
 intentionally feeding the procedures may, at times, be different.  These different paths that the logic can take 
 through our code are called "code paths". */
 
     -- For example, If I have a test such as:
DECLARE @variable int = 1
CREATE TABLE #mytable (
mtid int identity (1,10),
myColumn nvarchar (200)
)

IF @variable IS NOT NULL
BEGIN
  INSERT into #myTable (myColumn) values (isnull(@variable,0))
  PRINT 'HELLO, why would I ever be here in if @variable is NULL?
  You see?  That stupid 'isNull() function is not needed.  Programmers do things like that.  
  As if some random god of the variables will mysteriously NULLify your variable in=between the 
  IF and the values key.

  It is unnecessarry.

  Over the lifetime of a software (10 - 30 years) tens of thousands of inanities like thsi can pile up!'
  SET @variable = NULL  
END

--Right??  I'm talking to you, Erik...

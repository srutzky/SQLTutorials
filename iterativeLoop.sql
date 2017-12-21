/* This is a simple looping structure.  Iterate over the rows in a table where the rows are known
to have cardinality (<-- just a fancy way of saying each row increases by unity (<- cany way of saying the number '1)) */


			TRUNCATE TABLE #jobWork /* Let's just assume there is other code between this block and declarations, 
      and one of those blocks may have already used this table.  Truncating a table resets the Identity column */
      
     /*There are some checks I could do here... I will create more examples of things 
     like data validators, what I do, what I Idon't do, and why.*/
      
			INSERT INTO #jobWork SELECT name FROM msdb.dbo.sysjobs WHERE name like '%SP_AllNightLog_Restore%' and enabled = 0
			SELECT @iMax = max(jwid) FROM #jobWork
			WHILE @i <= @imax
			BEGIN
				SELECT @SQL = '
					EXEC msdb.dbo.sp_update_job @job_name = N''' + jobname + ''',' + ' @enabled = 1
					;
					EXEC msdb.dbo.sp_Start_job N''' + jobname + '''' FROM #jobWork WHERE jwid = @i
				IF @Debug = 1
					PRINT '------------------------------------------------------------
					Enabling sp_allnightlog_restore_xx jobs'
					PRINT @SQL
				EXEC sp_executesql @SQL
				SET @i = @i + 1
			END
			SET @i = 1

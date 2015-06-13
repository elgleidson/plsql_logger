exec proc_1(1, 10);
exec proc_1(1);
exec proc_1(1, null);
exec proc_1(null);

--  set log_level and exec the commands above again
exec logger.set_log_level(p_context => 'proc_1', p_log_level => logger.LOG_LEVEL_ERROR);

select * from logger_logs where log_context = 'proc_1';

-- now, proc_2: you see that level log of proc_1 context doesn't affects log level of proc_2 context, 
-- because they are in different contexts (you have defined within proc body!) 
exec proc_2(1, 10);
exec proc_2(1);
exec proc_2(1, null);
exec proc_2(null);

select * from logger_logs where log_context = 'proc_2';
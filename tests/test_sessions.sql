-- while loop to log all types of log level
-- in another session, change the log level and see the "online effect" :)
begin
  execute immediate 'truncate table logger_logs';
  logger.set_log_level(p_context => 'test', p_log_level => logger.LOG_LEVEL_ALL);
  
  while true loop
    logger.log_debug(p_message => 'debug message '||current_timestamp, p_context => 'test');
    logger.log_info(p_message => 'info message '||current_timestamp, p_context => 'test');
    logger.log_warn(p_message => 'warn message '||current_timestamp, p_context => 'test');
    logger.log_error(p_message => 'error message '||current_timestamp, p_context => 'test');
    logger.log_fatal(p_message => 'fatal message '||current_timestamp, p_context => 'test');
    logger.log_permanent(p_message => 'permanent message'||current_timestamp, p_context => 'test');
    
    dbms_lock.sleep(2);
  end loop;
end;
/  
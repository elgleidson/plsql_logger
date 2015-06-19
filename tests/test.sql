declare
  v_count_levels pls_integer;
  v_count_msgs   pls_integer;
  v_log_level    varchar2(30);
  v_context      varchar2(30)  := 'test';
  v_message      varchar2(100) := 'test message';
  function log_exists(p_log_level in varchar2) return boolean
  is
    v_count pls_integer;
  begin
    select count(*)
    into v_count
    from logger_logs 
    where log_context = v_context
    and log_message = v_message
    and log_level = p_log_level;
    
    return (v_count > 0);
  end;
begin
  /**** ALL ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_ALL;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if not log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** DEBUG ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_DEBUG;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if not log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** INFO ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_INFO;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** WARN ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_WARN;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** ERROR ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_ERROR;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** FATAL ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_FATAL;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** PERMANENT ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_PERMANENT;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if not log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  /**** OFF ****/
  execute immediate 'truncate table logger_logs'; 
  v_log_level := logger.LOG_LEVEL_OFF;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  
  logger.log_debug(p_message => v_message, p_context => v_context);
  logger.log_info(p_message => v_message, p_context => v_context);
  logger.log_warn(p_message => v_message, p_context => v_context);
  logger.log_error(p_message => v_message, p_context => v_context);
  logger.log_fatal(p_message => v_message, p_context => v_context);
  logger.log_permanent(p_message => v_message, p_context => v_context);
  
  if log_exists(logger.LOG_LEVEL_DEBUG) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_DEBUG||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_INFO) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_INFO||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_WARN) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_WARN||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_ERROR) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_ERROR||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_FATAL) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_FATAL||' on '||v_log_level||'!');
  end if;
  
  if log_exists(logger.LOG_LEVEL_PERMANENT) then
    raise_application_error(-20000, 'Fail to log '||logger.LOG_LEVEL_PERMANENT||' on '||v_log_level||'!');
  end if;
  
  
  v_log_level := logger.LOG_LEVEL_ALL;
  logger.set_log_level(p_context => v_context, p_log_level => v_log_level);
  execute immediate 'truncate table logger_logs';
end;
/
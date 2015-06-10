create or replace package logger authid definer is

  -- types
  type key_value is table of varchar2(4000) index by varchar2(100);

  -- constants
  LOGGER_CONTEXT          constant varchar2(30) := 'logger_context';
  CONFIG_GROUP_LEVEL      constant varchar2(30) := 'log_level';

  LOG_LEVEL_OFF           constant varchar2(10) := 'OFF';
  LOG_LEVEL_PERMANENT     constant varchar2(10) := 'PERMANENT';
  LOG_LEVEL_FATAL         constant varchar2(10) := 'FATAL';
  LOG_LEVEL_ERROR         constant varchar2(10) := 'ERROR';
  LOG_LEVEL_WARN          constant varchar2(10) := 'WARNING';
  LOG_LEVEL_INFO          constant varchar2(10) := 'INFO';
  LOG_LEVEL_DEBUG         constant varchar2(10) := 'DEBUG';
  LOG_LEVEL_ALL           constant varchar2(10) := 'ALL';

  -- variables
  empty_key_value         key_value; -- do not change this!


  -- functions and procedures
  function to_string(p_value in varchar2) return varchar2;
  function to_string(p_value in number) return varchar2;
  function to_string(p_value in date) return varchar2;
  function to_string(p_value in timestamp) return varchar2;
  function to_string(p_value in timestamp with time zone) return varchar2;
  function to_string(p_value in timestamp with local time zone) return varchar2;
  function to_string(p_value in boolean) return varchar2;
  function to_string(p_parameters in key_value) return clob;

  function get_log_level(p_context in varchar2 default null) return varchar2;

  procedure set_log_level(
    p_log_level   in varchar2,
    p_context     in varchar2 default null
  );

  procedure log_permanent(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  );
  
  procedure log_fatal(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  );

  procedure log_error(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  );

  procedure log_warn(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  );

  procedure log_info(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  );

  procedure log_debug(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  );

  procedure load_configs;

  procedure init;


end;
/


create or replace package body logger is

  -- private constants
  -- just for internal use
  LOG_LEVEL_INTERNAL      constant varchar2(10) := 'INTERNAL';

  NEW_LINE                constant char(1)      := chr(10);
  UNDEFINED               constant varchar2(10) := 'Undefined';


  -- private variables
  level_priority      key_value;


  -- private functions and procedures
  function can_log_internal(
    p_context    in varchar2,
    p_log_level  in varchar2 
  ) return boolean
  is
  begin
    return (p_log_level = LOG_LEVEL_INTERNAL and p_context = LOGGER_CONTEXT);
  end;
  
  
  function loaded return boolean
  is
  begin
    if sys_context(LOGGER_CONTEXT, LOGGER_CONTEXT) is null then
      return false;
    else
      return true;
    end if;
  end;

  procedure set_logger_config(
    p_context   in varchar2,
    p_log_level in varchar2,
    p_flush     in boolean default true
  )
  is
    pragma autonomous_transaction;
  begin
    dbms_session.set_context(LOGGER_CONTEXT, nvl(p_context, UNDEFINED), p_log_level);

    if p_flush then
      begin
        insert into logger_configs (config_group, config_parameter, config_value, last_load)
        values (CONFIG_GROUP_LEVEL, nvl(p_context, UNDEFINED), p_log_level, current_timestamp);
      exception when dup_val_on_index then
        update logger_configs
           set config_value = p_log_level, last_change = current_timestamp, last_load = current_timestamp
         where config_group = CONFIG_GROUP_LEVEL
           and config_parameter = nvl(p_context, UNDEFINED);
      end;
      commit;
    end if;
  end;


  function get_log_level(
    p_context   in varchar2 default null
  ) return varchar2
  is
  begin
    return sys_context(LOGGER_CONTEXT, nvl(p_context, UNDEFINED));
  end;


  function get_level_priority(
    p_log_level in varchar2
  ) return number
  is
  begin
    return to_number(level_priority(p_log_level));
  end;


  function can_log(
    p_log_level   in varchar2,
    p_context     in varchar2 default null
  ) return boolean
  is
    v_current_log_level varchar2(10);
  begin
    v_current_log_level := get_log_level(p_context);
    if v_current_log_level is null then
      v_current_log_level := LOG_LEVEL_ALL;
      set_logger_config(
        p_context   => p_context,
        p_log_level => v_current_log_level
      );
    end if;

    return (get_level_priority(p_log_level) <= get_level_priority(v_current_log_level));
  end;


  function get_log_info return varchar2
  is
  begin
    return '***** Log info *****'||NEW_LINE
      ||'session_user : '||sys_context('userenv', 'session_user')||NEW_LINE
      ||'sid          : '||sys_context('userenv', 'sid')||NEW_LINE
      ||'module       : '||sys_context('userenv', 'module')||NEW_LINE
      ||'action       : '||sys_context('userenv', 'action')||NEW_LINE
      ||'host         : '||sys_context('userenv', 'host')||NEW_LINE
      ||'os_user      : '||sys_context('userenv', 'os_user');
  end;


  function get_call_stack return varchar2
  is
  begin
    return dbms_utility.format_call_stack;
  end;


  procedure log(
    p_log_level   in varchar2,
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  )
  is
    pragma autonomous_transaction;
    v_log_info            varchar2(500);
    v_call_stack          varchar2(4000);
    v_parameters          clob;
    v_except_parameters   key_value;
    v_message             varchar2(4000);
    v_scope               varchar2(30) := 'log';
  begin
    if length(p_context) > 30 then
      raise_application_error(-20000, 'Log context must be 30 characters maximum!');
    end if;

    begin
      if p_log_level = LOG_LEVEL_INTERNAL and p_context <> LOGGER_CONTEXT then
        raise_application_error(-20000, 'Log context "'||p_context||'" is just for internal use of package!');
      end if;
    
      if can_log(p_log_level, p_context) then
        v_log_info   := get_log_info();
        v_call_stack := get_call_stack();
        v_parameters := to_string(p_parameters);

        insert into logger_logs (
          log_date,
          log_level,
          log_context,
          log_scope,
          log_parameters,
          log_group_id,
          log_message,
          log_callstack,
          log_info)
        values (
          current_timestamp,
          p_log_level,
          nvl(p_context, UNDEFINED),
          nvl(p_scope, UNDEFINED),
          v_parameters,
          p_group_id,
          p_message,
          v_call_stack,
          v_log_info
        );

        commit;
      end if;
    exception when others then
      v_message := sqlerrm;
      v_log_info   := get_log_info();
      v_call_stack := get_call_stack();

      v_except_parameters('p_log_level')  := to_string(p_log_level);
      v_except_parameters('p_message')    := to_string(p_message);
      v_except_parameters('p_parameters') := to_string(p_parameters);
      v_except_parameters('p_context')    := to_string(p_context);
      v_except_parameters('p_scope')      := to_string(p_scope);
      v_except_parameters('p_group_id')   := to_string(p_group_id);

      v_parameters := to_string(v_except_parameters);

      insert into logger_logs (
        log_date,
        log_level,
        log_context,
        log_scope,
        log_parameters,
        log_message,
        log_callstack,
        log_info)
      values (
        current_timestamp,
        LOG_LEVEL_FATAL,
        LOGGER_CONTEXT,
        v_scope,
        v_parameters,
        v_message,
        v_call_stack,
        v_log_info
      );

      commit;
    end;
  end;


  procedure log_internal(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_INTERNAL,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;


  -- public functions and procedures
  function to_string(p_value in varchar2) return varchar2
  is
  begin
    return nvl(p_value, 'NULL');
  end;


  function to_string(p_value in number) return varchar2
  is
  begin
    return nvl(to_char(p_value), 'NULL');
  end;


  function to_string(p_value in date) return varchar2
  is
  begin
    return nvl(to_char(p_value), 'NULL');
  end;


  function to_string(p_value in timestamp) return varchar2
  is
  begin
    return nvl(to_char(p_value), 'NULL');
  end;


  function to_string(p_value in timestamp with time zone) return varchar2
  is
  begin
    return nvl(to_char(p_value), 'NULL');
  end;


  function to_string(p_value in timestamp with local time zone) return varchar2
  is
  begin
    return nvl(to_char(p_value), 'NULL');
  end;


  function to_string(p_value in boolean) return varchar2
  is
  begin
    return case when p_value then 'TRUE' else 'FALSE' end;
  end;


  function to_string(p_parameters in key_value) return clob
  is
    v_out         clob;
    v_key         varchar2(100);
  begin
    v_key := p_parameters.first;
    while v_key is not null loop
      v_out := case when v_out is not null then v_out||NEW_LINE else '' end||v_key||' = '||nvl(p_parameters(v_key), 'NULL');
      v_key := p_parameters.next(v_key);
    end loop;
    return v_out;
  end;


  procedure log_permanent(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_PERMANENT,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;
  
  
  procedure log_fatal(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_FATAL,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;


  procedure log_error(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_ERROR,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;


  procedure log_warn(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_WARN,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;


  procedure log_info(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_INFO,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;


  procedure log_debug(
    p_message     in varchar2,
    p_parameters  in key_value default empty_key_value,
    p_context     in varchar2 default null,
    p_scope       in varchar2 default null,
    p_group_id    in varchar2 default null
  ) is
  begin
    log(
      p_log_level   => LOG_LEVEL_DEBUG,
      p_message     => p_message,
      p_parameters  => p_parameters,
      p_context     => p_context,
      p_scope       => p_scope,
      p_group_id    => p_group_id
    );
  end;


  procedure set_log_level(
    p_log_level   in varchar2,
    p_context     in varchar2 default null
  ) is
    v_scope       varchar2(100) := 'set_log_level';
    v_parameters  key_value;
  begin
    v_parameters('p_log_level') := to_string(p_log_level);
    v_parameters('p_context')   := to_string(p_context);

    if p_log_level is null then
      log_internal(
        p_message     => 'Log level is null. Keeping the current log level "'||get_log_level(p_context)||'"!',
        p_parameters  => v_parameters,
        p_context     => LOGGER_CONTEXT,
        p_scope       => v_scope
      );
    elsif not level_priority.exists(p_log_level) then
      log_internal(
        p_message     => 'Invalid log level!',
        p_parameters  => v_parameters,
        p_context     => LOGGER_CONTEXT,
        p_scope       => v_scope
      );
      raise_application_error(-20000, 'Invalid log level!');
    elsif p_log_level = LOG_LEVEL_INTERNAL and p_context <> LOGGER_CONTEXT then
      log_internal(
        p_message     => 'Invalid log level! "'||p_log_level||'" is just for internal use of package.',
        p_parameters  => v_parameters,
        p_context     => LOGGER_CONTEXT,
        p_scope       => v_scope
      );
      raise_application_error(-20000, 'Invalid log level! "'||p_log_level||'" is just for internal use of package.');
    else
      log_internal(
        p_message     => 'Log level of context "'||nvl(p_context, UNDEFINED)||'" changed from "'||get_log_level(p_context)||'" to "'||p_log_level||'"!',
        p_parameters  => v_parameters,
        p_context     => LOGGER_CONTEXT,
        p_scope       => v_scope
      );

      set_logger_config(
        p_context     => p_context,
        p_log_level   => p_log_level
      );
    end if;
  end;


  procedure load_configs
  is
    pragma autonomous_transaction;
    v_scope       varchar2(30) := 'load_configs';
    v_parameters  key_value;
    cursor configs is select * from logger_configs where config_group = CONFIG_GROUP_LEVEL for update of last_load;
  begin
    dbms_session.clear_all_context(LOGGER_CONTEXT);

    log_internal(
      p_message     => 'Loading logger configs...',
      p_context     => LOGGER_CONTEXT,
      p_scope       => v_scope
    );

    for config in configs loop
      -- allow internal log level just for own package context
      if config.config_value = LOG_LEVEL_INTERNAL and config.config_parameter <> LOGGER_CONTEXT then
        log_warn(
          p_message     => '"'||config.config_value||'" is just for internal use of package! Switch to log level "'||LOG_LEVEL_ERROR||'" for context "'||config.config_parameter||'"!',
          p_context     => LOGGER_CONTEXT,
          p_scope       => v_scope
        );

        config.config_value := LOG_LEVEL_ERROR;
      end if;

      set_logger_config(
        p_context     => config.config_parameter,
        p_log_level   => config.config_value,
        p_flush       => false
      );

      update logger_configs
         set last_load = current_timestamp
       where current of configs;

      v_parameters(config.config_parameter) := to_string(config.config_value);
    end loop;
    commit;

    log_internal(
      p_message     => 'Logger configs loaded',
      p_parameters  => v_parameters,
      p_context     => LOGGER_CONTEXT,
      p_scope       => v_scope
    );
  end;


  procedure init
  is
  begin
    level_priority(LOG_LEVEL_INTERNAL)  := -10;
    level_priority(LOG_LEVEL_OFF)       := 0;
    level_priority(LOG_LEVEL_PERMANENT) := 1;
    level_priority(LOG_LEVEL_FATAL)     := 2;    
    level_priority(LOG_LEVEL_ERROR)     := 3;
    level_priority(LOG_LEVEL_WARN)      := 4;
    level_priority(LOG_LEVEL_INFO)      := 5;
    level_priority(LOG_LEVEL_DEBUG)     := 6;
    level_priority(LOG_LEVEL_ALL)       := 7;


    if not loaded() then
      load_configs();
    end if;
  end;

begin

  init();

end;
/

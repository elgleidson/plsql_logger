create table logger_configs (
  config_group      varchar2(100) not null,
  config_parameter  varchar2(100) not null,
  config_value      varchar2(100) not null,
  last_load         timestamp,
  last_change       timestamp default current_timestamp not null,
  -- 
  constraint logger_configs_pk primary key (config_group, config_parameter)
) organization index;
/

create table logger_logs (
  log_date        timestamp default current_timestamp not null,
  log_level       varchar2(10) not null,
  log_context     varchar2(100) not null,
  log_scope       varchar2(100) not null,
  log_parameters  clob,
  log_group_id    varchar2(30),
  log_message     varchar2(4000) not null,
  -- 
  log_callstack   varchar2(4000),
  log_info        varchar2(500) not null,
  -- 
  constraint logger_logs_pk primary key (log_date, log_level, log_context, log_scope)
);
/

begin
  execute immediate 'drop package logger';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger';
exception when others then null;
end;
/
begin
  execute immediate 'drop table logger_configs';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_configs';
exception when others then null;
end;
/
begin
  execute immediate 'drop table logger_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop view logger_logs_today';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_logs_today';
exception when others then null;
end;
/
begin
  execute immediate 'drop view logger_logs_24h';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_logs_24h';
exception when others then null;
end;
/
begin
  execute immediate 'drop view logger_logs_1h';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_logs_1h';
exception when others then null;
end;
/
begin
  execute immediate 'drop view logger_errors_today';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_errors_today';
exception when others then null;
end;
/
begin
  execute immediate 'drop view logger_errors_24h';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_errors_24h';
exception when others then null;
end;
/
begin
  execute immediate 'drop view logger_errors_1h';
exception when others then null;
end;
/
begin
  execute immediate 'drop synonym logger_errors_1h';
exception when others then null;
end;
/
begin
  execute immediate 'drop context logger_context';
exception when others then null;
end;
/

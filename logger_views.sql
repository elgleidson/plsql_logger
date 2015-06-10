create or replace view logger_logs_today as
select * 
from logger_logs
where log_date >= trunc(sysdate);
/

create or replace view logger_logs_24h as
select * 
from logger_logs
where log_date >= (sysdate-1);
/

create or replace view logger_logs_1h as
select * 
from logger_logs
where log_date >= (sysdate - (1 / 24));
/

create or replace view logger_errors_today as
select * 
from logger_logs
where log_date >= trunc(sysdate)
and log_level = 'ERROR';
/

create or replace view logger_errors_24h as
select * 
from logger_logs
where log_date >= (sysdate-1)
and log_level = 'ERROR';
/

create or replace view logger_errors_1h as
select * 
from logger_logs
where log_date >= (sysdate - (1 / 24))
and log_level = 'ERROR';
/

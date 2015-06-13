create or replace procedure proc_1(p_param_1 in number, p_param_2 in number default null)
as
  v_context     varchar2(30) := lower($$PLSQL_UNIT);
  v_parameters  logger.key_value;
  v_param_2     number;
begin
  v_parameters('p_param_1')  := logger.to_string(p_param_1);
  v_parameters('p_param_2')  := logger.to_string(p_param_2);
  
  logger.log_debug(
    p_message    => 'Iniciando procedure',
    p_context    => v_context,
    p_parameters => v_parameters
  );
  
  if p_param_2 is null then
    v_param_2 := 2;
    logger.log_warn(
      p_message    => 'segundo parametro é nulo. Assumindo valor 2!',
      p_context    => v_context
    );
  end if;
  
  if p_param_1 is null then
    logger.log_error(
      p_message    => 'primeiro parametro é nulo!',
      p_context    => v_context
    );
    raise_application_error(-20000, 'Primeiro parâmetro é nulo!');
  end if;
  
exception when others then 
  -- a proc lançou uma exceção, que não era esperada
  logger.log_fatal(
    p_message    => sqlerrm,
    p_context    => v_context,
    p_parameters => v_parameters
  );
end;
/

create or replace procedure proc_2(p_param_1 in number, p_param_2 in number default null)
as
  v_context     varchar2(30) := lower($$PLSQL_UNIT);
  v_parameters  logger.key_value;
  v_param_2     number;
begin
  v_parameters('p_param_1')  := logger.to_string(p_param_1);
  v_parameters('p_param_2')  := logger.to_string(p_param_2);
  
  logger.log_debug(
    p_message    => 'Iniciando procedure',
    p_context    => v_context,
    p_parameters => v_parameters
  );
  
  if p_param_2 is null then
    v_param_2 := 2;
    logger.log_warn(
      p_message    => 'segundo parametro é nulo. Assumindo valor 2!',
      p_context    => v_context
    );
  end if;
  
  if p_param_1 is null then
    logger.log_error(
      p_message    => 'primeiro parametro é nulo!',
      p_context    => v_context
    );
    raise_application_error(-20000, 'Primeiro parâmetro é nulo!');
  end if;
  
exception when others then 
  -- a proc lançou uma exceção, que não era esperada
  logger.log_fatal(
    p_message    => sqlerrm,
    p_context    => v_context,
    p_parameters => v_parameters
  );
end;
/
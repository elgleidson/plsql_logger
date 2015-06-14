# plsql_logger

## English:

A PL/SQL logger based on log4j, but with level logs by context, not globally like log4j. So you can do a context logging debug messages and another one logging just errors messages.

Some ideas came from https://github.com/OraOpenSource/Logger

See `examples` directory for proc examples.


## Português:

Criei este pacote para facilitar o uso de logs no desenvolvimento em PL/SQL (dentro de triggers, procs, functions, packages).

Queria algo como o log4j, mas onde eu pudesse habilitar e desabilitar níveis de log de acordo com contextos, e não globalmente como o log4j faz.

Exemplo:

Digamos que eu tenha uma procedure chamada proc_1 que valida alguma regra de negócio. Como estou fazendo deploy dela no ambiente de produção, gostaria de acompanhar mais de perto nos primeiros dias. 

Ao fazer deploy da proc_1, quando ela chamar o logger a primeira vez para logar alguma mensagem, automaticamente o logger configura um nível de log para ela como sendo "ALL", ou seja, loga tudo que a proc "cuspir" para ele: DEBUG, INFO, WARN, ERROR e FATAL (nesta hierarquia).

Passados alguns dias, vejo que está bastante estável, se comportando como deve, porém está gerando muito log. Então resolvo logar apenas mensagens de erro e fatais. Assim basta fazer:

```exec logger.set_log_level(logger.LOG_LEVEL_ERROR);```

Com isso, apenas mensagens de erro ou fatais serão logadas. Obs.: isso é online! Assim que eu rodo isso, não importa de qual sessão do banco, a proc_1 só vai logar mensagens de erro ou fatais.

Porém imagine agora que eu tenha uma segunda proc chamada proc_2, que valida outra regra de negócio, e quero fazer exatamente como fiz com a proc_1: acompanhar mais de perto nos primeiros dias e depois só deixar logando mensagens de erro ou fatais.

Agora tenho um problema: o log_level está como "ERROR". Então não verei mensagens de debug ou info ou warn da proc_2, apenas mensagens de erro e fatais. Mas não é isso que eu quero. Bom, basta eu alterar o nível de log para DEBUG e problema resolvido, certo? Errado! Se eu alterar para DEBUG, vou passar a ver tudo que a proc_1 loga, e não quero isso. 
Como que eu resolvo isso? É aí que entram os contextos!

Não é aconselhável eu usar o logger como usei anteriormente, sem definir um contexto para a proc_1 e para a proc_2. O correto é eu definir um contexto para cada uma - declare uma variável dentro da proc com o nome dela, por exemplo, e aí use o logger da seguinte maneira dentro da proc:

```logger.log_debug(p_context => v_context, p_message => 'mensagem desejada');```

Aí, para resolver meu problema, basta eu ativar níveis de log diferente para cada um dos contextos:

```exec logger.set_log_level(p_context => 'proc_1', p_log_level => logger.LOG_LEVEL_ERROR);```

```exec logger.set_log_level(p_context => 'proc_2', p_log_level => logger.LOG_LEVEL_ALL);```

Pronto. Agora tenho a proc_1 logando apenas mensagens de erro ou fatais e a proc_2 logando tudo.

Obs.: olhar diretório `examples` para ver as procs de exemplo.

Instruções e comandos para rodar script:

1 - Rodar os comandos abaixo trocando o <usuario> pelo seu usuario, e mudar o dono do diretorio para postgres, 
	e também garantir que tenha permissão para chegar até esse diretorio;

	$ sudo mkdir /home/<usuario>/aleljo
	$ sudo mkdir /home/<usuario>/aleljo/ts_padrao
	$ sudo mkdir /home/<usuario>/aleljo/ts_tabela
	$ sudo chown -R postgres: /home/<usuario>/aleljo/


2 - Mudar a linha 8 e 9 do arquivo "advanced_SQL.sql" trocando onde tem <usuario> pelo seu usuario.
	
	Exemplo:
	Antes:  CREATE TABLESPACE ts_padrao LOCATION '/home/<usuario>/aleljo/ts_padrao';
	Depois: CREATE TABLESPACE ts_padrao LOCATION '/home/joao/aleljo/ts_padrao';


3 - Conectar no postgres com o comando abaixo, digitar a senha do usuario postgres(por padrão a senha é 'postgres');
	
	$ psql -U postgres -W


4 - Rodar o sccript usando o comando \i, trocando o <caminho script> pelo local onde salvou o script;

	$ \i /<caminho script>/advanced_SQL.sql


5 - Quando mandar rodar vai pedir novamente a senha do usuario postgres, digite a senha(por padrão a senha é 'postgres').
Pronto está tudo criado e conectado no banco de dados.
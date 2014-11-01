/*

Esta atividade consiste em enviar um único arquivo (.zip) cujo o nome terá as duas primeiras letras do nome de cada membro da equipe (todas minúsculas).
Um dos arquivos é um read-me com as instruções e descrição da aplicação e o outro deverá conter o script para atender as seguintes necessidades (os números representam sempre o mínimo):

- 2 tablespaces, uma default do banco outra para uma tabela exclusiva.
- Um banco de dados que conterá os objetos da aplicação
- O esquema para os objetos (não pode ser o Public)
- 1 usuário proprietário da aplicação e outros (2 pelo menos) com privilégios sobre os objetos.
- As tabelas populadas (não precisam ter muitas tuplas)
- Triggers para criar uma tabela de auditoria e outra para atualizar automaticamente atributos de uma tabela (pode ser da mesma tabela que sofreu a trigger)
- Visões (uma (ou umas) com função de grupo/agreagação)

A correção será feita de duas formas: executando os scripts (o readme tem que dar instruções suficientes para rodar o banco) e visualmente.

*/
-------------------------------------------



-- Tablespaces
--CREATE TABLESPACE ts_padrao LOCATION '/home/joao/aleljo/';
--CREATE TABLESPACE ts_tabela LOCATION '/home/joao/aleljo/';
--SET default_tablespace = ts_padrao;

-- cria usuario e dá permissoes
CREATE USER dono;
CREATE USER usuario1;
CREATE USER usuario2;


-- cria database
CREATE DATABASE aleljo
  WITH OWNER = dono;


-- conecta no banco novo
\c aleljo;


-- Schema
CREATE SCHEMA esquema;
SET search_path to esquema;

GRANT ALL ON SCHEMA esquema TO dono;
GRANT ALL ON SCHEMA esquema TO usuario1;
GRANT ALL ON SCHEMA esquema TO usuario2;


CREATE TABLE veiculo (
	placa		varchar(8) PRIMARY KEY,
	marca		varchar(30),
	modelo		varchar(30),
	cod_frota	
)


/*CREATE DATABASE aleljo
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Portuguese_Brazil.1252'
       LC_CTYPE = 'Portuguese_Brazil.1252'
       CONNECTION LIMIT = -1;*/


/*

Esta atividade consiste em enviar um único arquivo (.zip) cujo o nome terá as duas primeiras letras do nome de cada membro da equipe (todas minúsculas).
Um dos arquivos é um read-me com as instruções e descrição da aplicação e o outro deverá conter o script para atender as seguintes necessidades (os números representam sempre o mínimo):

O QUE PRECISA:

50% - 2 tablespaces, uma default do banco outra para uma tabela exclusiva.
FEITO - Um banco de dados que conterá os objetos da aplicação
FEITO- O esquema para os objetos (não pode ser o Public)
FEITO- 1 usuário proprietário da aplicação e outros (2 pelo menos) com privilégios sobre os objetos.
FEITO- As tabelas populadas (não precisam ter muitas tuplas)
FEITO- Triggers para criar uma tabela de auditoria e outra para atualizar automaticamente atributos de uma tabela (pode ser da mesma tabela que sofreu a trigger)
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


CREATE TABLE frota (
	cod_frota	integer PRIMARY KEY,
	nome		varchar(30),
	qt_veic		integer
);


CREATE TABLE veiculo (
	placa		varchar(8) PRIMARY KEY,
	marca		varchar(30),
	modelo		varchar(30),
	cod_frota	integer REFERENCES frota(cod_frota)
);


CREATE TABLE veic_audit(
    op         	char(1),
    dthr       	timestamp,
    usuario    	text,
    placa   	text,
    frota 		integer
);

CREATE OR REPLACE FUNCTION func_veic_audit() RETURNS TRIGGER AS 
$$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO veic_audit SELECT 'D', now(), user, OLD.placa, OLD.cod_frota;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO veic_audit SELECT 'U', now(), user, NEW.placa, NEW.cod_frota;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO veic_audit SELECT 'I', now(), user, NEW.placa, NEW.cod_frota;
            RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER tg_veic_audit
AFTER INSERT OR UPDATE OR DELETE ON veiculo
    FOR EACH ROW EXECUTE PROCEDURE func_veic_audit();


CREATE OR REPLACE FUNCTION up_frota() RETURNS TRIGGER AS
$$
	BEGIN
	IF (TG_OP = 'DELETE') THEN
            UPDATE frota set qt_veic = (qt_veic - 1) WHERE cod_frota = OLD.cod_frota;
            RETURN OLD;
        ELSIF (TG_OP = 'INSERT') THEN

            UPDATE frota set qt_veic = (qt_veic + 1) WHERE cod_frota = NEW.cod_frota;
            RETURN NEW;
        END IF;
        RETURN NULL; 
	END
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tg_up_frota
AFTER INSERT OR DELETE ON veiculo
    FOR EACH ROW EXECUTE PROCEDURE up_frota();



INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(1, 'ronda no norte', 0);
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(2, 'ronda no sul', 0);
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(3, 'ronda no leste', 0);
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(4, 'ronda no oeste', 0);

INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('AAA-1111', 'chevrolet', 'corsa', 1);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('PAT-6835', 'volkswagen', 'gol', 2);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('BCR-4679', 'citroen', 'c4-pallas', 3);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('IJK-0987', 'mercedes-benz', 'CLS 350', 4);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('LCT-1837', 'volkswagen', 'kombi', 2);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('OIU-4567', 'volkswagen', 'voyage', 4);

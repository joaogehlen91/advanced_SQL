-- Script para trabalho "Advanced_SQL"
-- Alunos: Alesom Zorzi, Elias Fank, Joao Gehlen
-- Curso: Banco de dados II - Ciencia da Computacao - UFFS
-- Professor: Denio Duarte


-- Tablespaces
CREATE TABLESPACE ts_padrao LOCATION '/home/<usuario>/aleljo/ts_padrao';
CREATE TABLESPACE ts_tabela LOCATION '/home/<usuario>/aleljo/ts_tabela';
SET default_tablespace = ts_padrao;

-- cria usuarios
CREATE USER dono password 'dono';
CREATE USER usuario1 PASSWORD 'usuario1';
CREATE USER usuario2 PASSWORD 'usuario2';

-- cria database
CREATE DATABASE aleljo
  WITH OWNER = dono
  TABLESPACE ts_padrao;

-- conecta no banco novo
\c aleljo;

-- cria schema
CREATE SCHEMA esquema;
SET search_path to esquema;

-- permissoes de acesso ao schema para os usuarios
GRANT ALL ON SCHEMA esquema TO dono;
GRANT ALL ON SCHEMA esquema TO usuario1;
GRANT ALL ON SCHEMA esquema TO usuario2;

-- cria tabelas
CREATE TABLE frota (
	cod_frota	integer PRIMARY KEY,
	nome		varchar(30),
	qt_veic		integer
) TABLESPACE ts_tabela;
----
CREATE TABLE veiculo (
	placa		varchar(8) PRIMARY KEY,
	marca		varchar(30),
	modelo		varchar(30),
	cod_frota	integer REFERENCES frota(cod_frota)
);
----
CREATE TABLE veic_audit(
    op         	char(1),
    dthr       	timestamp,
    usuario    	text,
    placa   	text,
    frota 		integer
);

-- cria funcao para trigger
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
----
CREATE TRIGGER tg_veic_audit
AFTER INSERT OR UPDATE OR DELETE ON veiculo
    FOR EACH ROW EXECUTE PROCEDURE func_veic_audit();
----
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
----
CREATE TRIGGER tg_up_frota
AFTER INSERT OR DELETE ON veiculo
    FOR EACH ROW EXECUTE PROCEDURE up_frota();

-- insere os dados
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(1, 'ronda no norte', 0);
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(2, 'ronda no sul', 0);
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(3, 'ronda no leste', 0);
INSERT INTO frota(cod_frota, nome, qt_veic) VALUES(4, 'ronda no oeste', 0);
----
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('AAA-1111', 'chevrolet', 'corsa', 1);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('PAT-6835', 'volkswagen', 'gol', 2);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('BCR-4679', 'citroen', 'c4-pallas', 3);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('IJK-0987', 'mercedes-benz', 'CLS 350', 4);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('LCT-1837', 'volkswagen', 'kombi', 2);
INSERT INTO veiculo(placa, marca, modelo, cod_frota) VALUES('OIU-4567', 'volkswagen', 'voyage', 4);

-- cria view
CREATE VIEW veiculo_frota AS
    SELECT
        frota.nome,
        veiculo.placa,
        veiculo.marca,
        veiculo.modelo
    FROM
        veiculo
    JOIN frota ON
        veiculo.cod_frota = frota.cod_frota
    ORDER BY
        1
;
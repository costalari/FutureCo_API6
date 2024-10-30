create database FutureCo;
use futureco;

select * from fabricas;
select * from clientes;
select * from rotas;

SELECT #selecionando as colunas 
    r.ï»¿EMISSAO,
    r.Entrega,
    r.Mes,
    r.Ano,
    r.Fabrica,
    f.MUNICIPIO AS Fabricas_Municipio,
    r.Cliente,
    c.MUNICIPIO AS Clientes_Municipio,
    r.Incoterm,
    r.Veiculo,
    r.pallet,
    r.Capacidade,
    r.Moeda,
    r.Frete,
    r.Distribuicao
FROM #selecionando de qual tabela vc quer as colunas
    rotas r
JOIN fabricas f ON r.Fabrica = f.Fabrica
JOIN clientes c ON r.Cliente = c.Cliente; #JOIN pede para unir as colunas especificas de outras tabelas que não fossem rotas

ALTER TABLE clientes
ADD PRIMARY KEY (Cliente); #definindo que a coluna Cliente da tabela clientes é a chave primaria
 
ALTER TABLE fabricas
ADD PRIMARY KEY (Fabrica); #definindo que a coluna Fabrica da tabela fabricas é a chave primaria


ALTER TABLE rotas
ADD CONSTRAINT fk_rotas_fabricas
FOREIGN KEY (Fabrica) REFERENCES fabricas(Fabrica)
ON DELETE CASCADE
ON UPDATE CASCADE;
 
 
ALTER TABLE rotas
ADD CONSTRAINT fk_rotas_clientes
FOREIGN KEY (Cliente) REFERENCES clientes(Cliente)
#Defini que os valores nas tres tabelas devem existir, se eu tentar adicionar um valor na minha tabela rotas que não existe em cliente e fabricas ele não me deixara inserir, para não haver má comunicação em tabelas

ON DELETE CASCADE #Se um registro em fabricas ou clientes for deletado, todos os registros relacionados na tabela rotas também serão deletados automaticamente
ON UPDATE CASCADE; #Se o valor da chave primária em fabricas ou clientes for atualizado, os registros correspondentes na tabela rotas também serão atualizados automaticamente

CREATE TABLE FACT (
    IDResum INT AUTO_INCREMENT PRIMARY KEY,
    Emissao DATE,
    Entrega DATE,
    Mes INT,
    Ano INT,
    Fabrica INT,
    Cliente INT,
    Incoterm VARCHAR(50),
    Veiculo VARCHAR(50),
    Pallet INT,
    Capacidade INT,
    Moeda VARCHAR(10),
    Frete DECIMAL(10, 2),
    Distribuição DECIMAL(10, 2),
    MunicipioFabrica VARCHAR(255),
    LatitudeFabrica FLOAT,
    LongitudeFabrica FLOAT,
    MunicipioCliente VARCHAR(255),
    LatitudeCliente FLOAT,
    LongitudeCliente FLOAT
);

ALTER TABLE fact
MODIFY COLUMN Distribuição DOUBLE;

INSERT INTO FACT (Emissao, Entrega, Mes, Ano, Fabrica, Cliente, Incoterm, Veiculo, Pallet, Capacidade, Moeda, Frete, Distribuição, MunicipioFabrica, LatitudeFabrica, LongitudeFabrica, MunicipioCliente, LatitudeCliente, LongitudeCliente)
SELECT 
    STR_TO_DATE(r.ï»¿EMISSAO, '%d/%m/%Y') AS Emissao,
    STR_TO_DATE(r.Entrega, '%d/%m/%Y') AS Entrega,
    r.Mes,
    r.Ano,
    r.Fabrica,
    r.Cliente,
    r.Incoterm,
    r.Veiculo,
    r.Pallet,
    r.Capacidade,
    r.Moeda,
    r.Frete,
    r.Distribuicao,
    f.MUNICIPIO AS MunicipioFabrica,
    CAST(NULLIF(f.LATITUDE, '') AS DECIMAL(10, 6)) AS LatitudeFabrica,
    CAST(NULLIF(f.LONGITUDE, '') AS DECIMAL(10, 6)) AS LongitudeFabrica,
    c.MUNICIPIO AS MunicipioCliente,
    CAST(NULLIF(c.LATITUDE, '') AS DECIMAL(10, 6)) AS LatitudeCliente,
    CAST(NULLIF(c.LONGITUDE, '') AS DECIMAL(10, 6)) AS LongitudeCliente
FROM rotas r
LEFT JOIN fabricas f ON r.Fabrica = f.Fabrica
LEFT JOIN clientes c ON r.Cliente = c.Cliente;

select * from fact;

ALTER TABLE fact
ADD CONSTRAINT fk_fact_cliente
FOREIGN KEY (Cliente) REFERENCES clientes(Cliente)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE fact
ADD CONSTRAINT fk_fact_fabricas
FOREIGN KEY (Fabrica) REFERENCES fabricas(Fabrica)
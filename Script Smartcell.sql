use db_orders;

-- Verificação do imput de dados
select * from address;
select * from buyer;
select * from carrier;
select * from orders;
select * from product;
select * from stg_orders;


-- ANALISE EXPLORATÓRIA DOS DADOS

-- Qual marca de celular com mais vendas?
SELECT brand, COUNT(quantity) AS quantidade
	FROM orders odr
	JOIN product pro 
    ON odr.id_product = pro.id_product
	GROUP BY brand
	ORDER BY quantidade DESC;

-- Qual cliente com mais vendas?
SELECT channel, segment, COUNT(quantity) AS quantidade
	FROM orders odr
	JOIN buyer buy 
    ON odr.id_buyer = buy.id_buyer
	GROUP BY channel, segment
	ORDER BY quantidade DESC;
    
    
-- Qual estado com mais vendas 
SELECT state, COUNT(quantity) AS quantidade
	FROM orders odr
	JOIN address adr 
    ON odr.id_address = adr.id_address
	GROUP BY state
	ORDER BY quantidade DESC;

-- Qual transportador mais utilizado
SELECT carrier_name, COUNT(quantity) AS quantidade
	FROM orders odr
	JOIN carrier car 
    ON odr.id_carrier = car.id_carrier
	GROUP BY carrier_name
	ORDER BY quantidade DESC;

-- SLA Médio de entrega geral
SELECT AVG(car.sla) AS entrega
	FROM orders odr
	JOIN carrier car 
    ON odr.id_carrier = car.id_carrier
    ORDER BY car.sla;
    
    

-- SEGMENTAÇÃO DE CLIENTES
-- Qual a transportadora mais usada em cada estado 
WITH RankedCarriers AS (
    SELECT
        car.carrier_name,
        adr.state,
        COUNT(quantity) AS quantidade,
        ROW_NUMBER() OVER (PARTITION BY adr.state ORDER BY COUNT(quantity) DESC) AS row_num
    FROM
        orders odr
        JOIN carrier car ON odr.id_carrier = car.id_carrier
        JOIN address adr ON odr.id_address = adr.id_address
    GROUP BY
        car.carrier_name,
        adr.state
)
SELECT
    carrier_name,
    state,
    quantidade
FROM
    RankedCarriers
WHERE
    row_num = 1;

-- SLA Médio de entrega em cada estado
SELECT adr.state, AVG(car.sla) AS entrega
	FROM orders odr
	JOIN carrier car 
    ON odr.id_carrier = car.id_carrier
    JOIN address adr 
    ON odr.id_address = adr.id_address
    GROUP BY adr.state
	ORDER BY entrega desc;
    
    
-- Ranking das marcas mais vendidas em cada estado
WITH RankedBrands AS (
  SELECT
    pro.brand,
    adr.state,
    COUNT(quantity) AS quantidade,
    ROW_NUMBER() OVER (PARTITION BY adr.state ORDER BY COUNT(quantity) DESC) AS BrandRank
  FROM
    orders odr
    JOIN product pro ON odr.id_product = pro.id_product
    JOIN address adr ON odr.id_address = adr.id_address
  GROUP BY
    pro.brand, adr.state
)
SELECT brand, state, quantidade
FROM RankedBrands
WHERE BrandRank = 1;



-- Qual a marca mais vendida por canal 
WITH RankedCarriers AS (
    SELECT
        buy.channel,
        buy.segment,
        pro.brand,
        COUNT(quantity) AS quantidade,
        ROW_NUMBER() OVER (PARTITION BY buy.channel ORDER BY COUNT(quantity) DESC) AS row_num
    FROM
        orders odr
        JOIN buyer buy ON odr.id_buyer = buy.id_buyer
        JOIN product pro ON odr.id_product = pro.id_product
    GROUP BY
        buy.channel,
        buy.segment,
        pro.brand
)
SELECT
    channel,
    segment,
    brand,
    quantidade
FROM
    RankedCarriers
WHERE
    row_num = 1
ORDER BY quantidade desc;
    
-- Qual valor vendido para cada segmento
CREATE TEMPORARY TABLE total_price_segment AS
    SELECT
        buy.channel,
        buy.segment,
        SUM(quantity * pro.price) AS total_price
    FROM
        orders odr
        JOIN buyer buy ON odr.id_buyer = buy.id_buyer
        JOIN product pro ON odr.id_product = pro.id_product
    GROUP BY
        buy.channel,
        buy.segment
    ORDER BY
        total_price DESC;

 SELECT * FROM total_price_segment;
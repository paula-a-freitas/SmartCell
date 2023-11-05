Análise de Banco de dados Relacional de vendas de celulares

A empresa SmartCell possui diversos canais de venda e tipos de clientes, e por isso está tendo dificuldade em implementar iniciativas e propagandas específicas para seu público a fim de aumentar as vendas. Por isso procuraram nossa consultoria para analisar seu banco de dados de venda a fim de identificar padrões de compra em seus clientes.

Nos próximos dois meses, o objetivo do projeto de análise de dados da SmartCell é identificar e compreender os padrões de compra dos consumidores de celulares, utilizando dados de vendas desde 2016. Isso envolve segmentar os consumidores em grupos demográficos e de preferência de marca, bem como avaliar o impacto das estratégias de marketing ao longo de doze meses. Este objetivo é alcançável, uma vez que todas as informações necessárias estão disponíveis no banco de dados existente, e a equipe de análise de dados tem as habilidades e recursos necessários para realizar a análise. Além disso, é altamente relevante, pois ajudará a SmartCell a ajustar suas estratégias de vendas e marketing com base em dados concretos, visando aprimorar a eficácia e a satisfação do cliente.

Base de dados:
 0   id_order      int64         
 1   channel       object        
 2   segment       object        
 3   carrier_name  object        
 4   sla           int64         
 5   state         object        
 6   city          object        
 7   brand         object        
 8   price         float64       
 9   quantity      int64         
 10  date_order    datetime64[ns]
-- Para executar a consulta, crie um bucket S3 dentro da AWS e, 
-- em seguida, altere a linha 22 com o caminho (url) do bucket 
-- criado previamente. Por fim, execute o código da linha 7 
-- em diante no Athena para criar a tabela "tb_produtos".

-- Script para criação da tabela "tb_produtos"
create external table tb_produtos 
( 
    codigo string, 
    categoria string, 
    nome string, 
    preco decimal(16, 2), 
    status string
) 
partitioned by 
(
    anomesdia string
) 
stored as 
     parquet
location 
     's3://tb-produtos/';
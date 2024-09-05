-- Objetivo: encontrar clientes que realizaram pedidos com valor total 
-- superior a média de todos os pedidos realizados no último mês.

-- Exemplo com uso de subqueries
select 
    nome, 
    total_pedido 
from 
    (
        select 
            c.nome, 
            sum(p.valor) as total_pedido 
        from 
            database.tb_pedidos as p 
        join 
            database.tb_clientes as c on (p.cliente_id = c.cliente_id)
        where 
            ((p.data >= date_trunc('month', current_date - interval '1 month')))
        group by 
            c.nome
    ) as pedidos_por_cliente 
where 
    total_pedido > (
        select 
            avg(total_pedido) 
        from 
            (
                select 
                    sum(valor) as total_pedido 
                from 
                    database.tb_pedidos 
                where 
                    ((data >= date_trunc('month', current_date - interval '1 month')))
                group by 
                    cliente_id
            ) as media_pedidos
    );


-- Exemplo com uso de Common Table Expressions (ou CTE)
with total_pedidos_por_cliente as (
    select 
        c.nome, 
        sum(p.valor) as total_pedido 
    from 
        database.tb_pedidos as p 
    join 
        database.tb_clientes as c on (p.cliente_id = c.cliente_id)
    where 
        ((p.data >= date_trunc('month', current_date - interval '1 month')))
    group by 
        c.nome
), 

media_pedidos as (
    select 
        avg(total_pedido) as media 
    from 
        (
            select 
                sum(valor) as total_pedido 
            from 
                pedidos 
            where 
                ((data >= date_trunc('month', current_date - interval '1 month')))
            group by 
                cliente_id
        ) as subquery
) 

select 
    nome, 
    total_pedido 
from 
    total_pedidos_por_cliente 
    join media_pedidos on total_pedido > media;                              
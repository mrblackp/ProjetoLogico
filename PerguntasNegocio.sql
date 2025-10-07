
use ecommerce;

-- Recuperando informações da tabela cliente

SELECT 
	idcliente as ID, nome, cpf, endereco 
FROM cliente;

-- Recuperando produtos por categoria para encontrar os dois maiores valores

SELECT 
	categoria, valor
FROM produto
ORDER BY categoria DESC
LIMIT 2;

-- Recuperando entregas com status 'em trânsito'

SELECT * 
FROM entrega
WHERE status_entrega = 'Em trânsito';

-- -------------------------------------------
-- Quantos pedidos foram feitos por cada cliente?

SELECT 
    c.idcliente,
    c.Nome AS nome_cliente,
    COUNT(p.idpedido) AS total_pedidos,
    CONCAT('Cliente ', c.Nome, ' realizou ', COUNT(p.idpedido), ' pedido(s).') AS Observação
FROM cliente c
LEFT JOIN pedido p 
    ON p.cliente_idcliente = c.idcliente
GROUP BY c.idcliente, c.Nome
HAVING COUNT(p.idpedido) > 0
ORDER BY total_pedidos DESC;

-- ------------------------------------------
-- Relação de produtos, fornecedores e estoques

SELECT 
    p.idproduto,
    p.descricao AS produto,
    f.razao AS fornecedor,
    e.local AS local_estoque,
    pe.quantidade AS qtd_em_estoque,
    (CAST(p.valor AS DECIMAL(10,2)) * pe.quantidade) AS Valor_total_do_estoque
FROM produto p
INNER JOIN disponibilizando_um_produto dp 
    ON dp.produto_idproduto = p.idproduto
INNER JOIN fornecedor f 
    ON f.idfornecedor = dp.fornecedor_idfornecedor
INNER JOIN produto_estoque pe 
    ON pe.produto_idproduto = p.idproduto
INNER JOIN estoque e 
    ON e.idestoque = pe.estoque_idestoque
WHERE pe.quantidade > 0
ORDER BY Valor_total_do_estoque DESC;

-- ----------------------------------------------
-- Relação de nomes dos fornecedores e nomes dos produtos

SELECT 
    f.razao AS nome_fornecedor,
    COUNT(p.idproduto) AS total_produtos,
    CONCAT(f.razao, ' fornece ', COUNT(p.idproduto), ' produto(s).') AS Observação
FROM fornecedor f
INNER JOIN disponibilizando_um_produto dp 
    ON dp.fornecedor_idfornecedor = f.idfornecedor
INNER JOIN produto p 
    ON p.idproduto = dp.produto_idproduto
GROUP BY f.razao
HAVING COUNT(p.idproduto) >= 1
ORDER BY total_produtos DESC;





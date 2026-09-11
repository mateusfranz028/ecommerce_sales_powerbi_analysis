SELECT 
    products.product_category_name,
    SUM(order_items.price) AS faturamento_total
FROM order_items
LEFT JOIN products ON order_items.product_id = products.product_id
LEFT JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY products.product_category_name
ORDER BY faturamento_total DESC
LIMIT 10;

-- =============================================
-- BASE ANALÍTICA CONSOLIDADA PARA EXPORTAÇÃO
-- =============================================

SELECT 
    order_items.order_id,
    orders.order_purchase_timestamp AS data_compra,
    orders.order_delivered_customer_date AS data_entrega,
    products.product_category_name AS categoria,
    customers.customer_city AS cidade_cliente,
    customers.customer_state AS uf_cliente,
    order_items.price AS preco,
    order_items.freight_value AS frete,
    (order_items.price + order_items.freight_value) AS valor_total
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN orders 
    ON order_items.order_id = orders.order_id
LEFT JOIN customers 
    ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
  AND orders.order_delivered_customer_date IS NOT NULL
  AND products.product_category_name IS NOT NULL;
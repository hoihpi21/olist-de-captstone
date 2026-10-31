	SELECT 'category_translation' AS table_name, COUNT(*) AS total_rows FROM raw.category_translation
	UNION ALL
	SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM raw.customers
	UNION ALL
	SELECT 'geolocation' AS table_name, COUNT(*) AS total_rows FROM raw.geolocation
	UNION ALL
	SELECT 'order_items' AS table_name, COUNT(*) AS total_rows FROM raw.order_items
	UNION ALL
	SELECT 'order_payments' AS table_name, COUNT(*) AS total_rows FROM raw.order_payments
	UNION ALL
	SELECT 'order_reviews' AS table_name, COUNT(*) AS total_rows FROM raw.order_reviews
	UNION ALL
	SELECT 'orders' AS table_name, COUNT(*) AS total_rows FROM raw.orders
	UNION ALL
	SELECT 'products' AS table_name, COUNT(*) AS total_rows FROM raw.products
	UNION ALL
	SELECT 'sellers' AS table_name, COUNT(*) AS total_rows FROM raw.sellers;
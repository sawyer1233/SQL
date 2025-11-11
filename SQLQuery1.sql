use test
select top 10
	p.product_name,
	sum(oi.quantity) as total_quantity
from orders_item oi
join products p on oi.product_id=p.product_id
group by p.product_name
order by total_quantity desc

select top 10
	p.product_name,
	sum(oi.quantity * oi.list_price) as total_cash,
	 100.0 * SUM(oi.quantity * oi.list_price)/ SUM(SUM(oi.quantity * oi.list_price)) OVER () AS percent_of_total
from orders_item oi
join products p on oi.product_id=p.product_id
group by p.product_name
order by total_cash desc



SELECT
    ms.[Rok],
    ms.[Miesiąc],
    ms.monthly_sales AS [Sprzedaż Bieżąca],
    
    -- Funkcja LAG(): Pobiera wartość sprzedaży z poprzedniego miesiąca
    LAG(ms.monthly_sales, 1) OVER (ORDER BY ms.[Rok], ms.[Miesiąc] ) AS [Sprzedaż Poprzedni Miesiąc],
    
    -- Dodatkowy wskaźnik: Różnica (wzrost/spadek) miesiąc do miesiąca (MoM)
    ms.monthly_sales - LAG(ms.monthly_sales, 1) OVER (
        ORDER BY ms.[Rok], ms.[Miesiąc]
    ) AS [Zmiana MoM]
FROM
    (
        -- *** PODZAPYTANIE (INLINE VIEW) ***
        -- Oblicza zagregowaną sprzedaż miesięczną (ms)
        SELECT
            YEAR(o.order_date) AS [Rok],
            MONTH(o.order_date) AS [Miesiąc],
            SUM(oi.quantity * oi.list_price) AS monthly_sales
        FROM
            orders_item oi
        JOIN
            orders o ON oi.order_id = o.order_id
        GROUP BY
            YEAR(o.order_date),
            MONTH(o.order_date)
    ) ms -- Konieczny alias
ORDER BY
    ms.[Rok],
    ms.[Miesiąc];



SELECT
    o.order_id AS [Numer Zamówienia],
    t.store_name AS [Sklep],
    o.order_date AS [Data Zamówienia],
    o.shipped_date AS [Data Wysyłki],
    -- Obliczenie różnicy w dniach
    DATEDIFF(day, CONVERT(DATE, o.order_date), CONVERT(DATE, o.shipped_date)) AS [Czas Realizacji (dni)]
FROM
    orders o
JOIN
    stores t ON o.store_id = t.store_id
WHERE
    o.shipped_date IS NOT NULL -- Tylko zrealizowane zamówienia
ORDER BY
    [Czas Realizacji (dni)] DESC;




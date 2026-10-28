CREATE TABLE QueryPerformance (
    RecordID INT PRIMARY KEY,
    CustomerCity VARCHAR(50),
    OrderStatus VARCHAR(30),
    ProductCategory VARCHAR(50),
    OrderDate DATE,
    Amount DECIMAL(10,2)
);

INSERT INTO QueryPerformance
(RecordID, CustomerCity, OrderStatus, ProductCategory, OrderDate, Amount)
SELECT
    n,
    CASE
        WHEN n % 4 = 0 THEN 'Lucknow'
        WHEN n % 4 = 1 THEN 'Kanpur'
        WHEN n % 4 = 2 THEN 'Delhi'
        ELSE 'Agra'
    END,
    CASE
        WHEN n % 3 = 0 THEN 'Delivered'
        WHEN n % 3 = 1 THEN 'Pending'
        ELSE 'Cancelled'
    END,
    CASE
        WHEN n % 3 = 0 THEN 'Electronics'
        WHEN n % 3 = 1 THEN 'Clothing'
        ELSE 'Furniture'
    END,
    DATE_ADD('2025-01-01', INTERVAL (n % 365) DAY),
    500 + (n % 2000)
FROM (
    SELECT
        a.n + b.n * 10 + c.n * 100 + d.n * 1000 + 1 AS n
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    CROSS JOIN
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
    CROSS JOIN
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
) AS numbers
WHERE n <= 10000;

SELECT COUNT(*) AS total_records
FROM QueryPerformance;

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE CustomerCity = 'Lucknow';

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE OrderStatus = 'Delivered';

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE ProductCategory = 'Electronics'
AND OrderDate BETWEEN '2025-03-01' AND '2025-06-30';

EXPLAIN
SELECT CustomerCity, COUNT(*)
FROM QueryPerformance
GROUP BY CustomerCity;

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE ProductCategory LIKE '%Electronics%';

CREATE INDEX idx_city
ON QueryPerformance(CustomerCity);

CREATE INDEX idx_status
ON QueryPerformance(OrderStatus);

CREATE INDEX idx_category_date
ON QueryPerformance(ProductCategory, OrderDate);

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE CustomerCity = 'Lucknow';

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE OrderStatus = 'Delivered';

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE ProductCategory = 'Electronics'
AND OrderDate BETWEEN '2025-03-01' AND '2025-06-30';

EXPLAIN
SELECT CustomerCity, COUNT(*)
FROM QueryPerformance
GROUP BY CustomerCity;

EXPLAIN
SELECT *
FROM QueryPerformance
WHERE ProductCategory = 'Electronics';
IF EXISTS (SELECT * FROM sys.objects WHERE name LIKE '%getPayments%') DROP PROCEDURE getPayments; 

USE commercialNetwork
GO
CREATE PROCEDURE getPayments   
    @beginDate DATE,   
    @endDate DATE   
AS   
    SELECT 
		p.id AS 'Идентификатор платежа', 
		p.paymentDate AS 'Дата платежа', 
		CASE 
			WHEN c.name LIKE 'Индивидуальный предприниматель'  THEN c.customerFirstName+' '+c.customerName+' '+c.customerLastName
			ELSE  c.name
		END AS 'Клиент',
		prod.Name AS 'Наименование товара',
		prod.price AS 'Цена за ед.',
		p.quantity AS 'Количество',
		prod.unitCountName AS 'Ед. изм',
		prod.price*p.quantity AS 'Номинальная цена',
		p.cost AS 'Сумма ИТОГО'
    FROM payments p INNER JOIN customers c on p.customer_id=c.id INNER JOIN products prod ON p.product_id=prod.id
    WHERE paymentDate   BETWEEN @beginDate AND @endDate ORDER BY 'Дата платежа';
GO
EXECUTE getPayments '2014-01-10','2016-01-10';
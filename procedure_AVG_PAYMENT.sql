IF EXISTS (SELECT * FROM sys.objects WHERE name LIKE '%avgCostMoreThan%') DROP PROCEDURE avgCostMoreThan;
USE commercialNetwork
GO
CREATE PROCEDURE avgCostMoreThan
	@avgCost FLOAT
AS
SELECT 
	tempTable.id AS 'Идентификатор клиента',
	tempTable.m AS 'Месяц',
	tempTable.y AS 'Год',
	tempTable.cost AS 'Среднемесячный платеж',
	CASE 
	WHEN c.name LIKE 'Индивидуальный предприниматель'  THEN c.customerFirstName+' '+c.customerName+' '+c.customerLastName
	ELSE  c.name
	END AS 'Клиент'
FROM (
	SELECT 
		p.customer_id AS id,
		MONTH(p.paymentDate) as m,
		YEAR(p.paymentDate) AS y,
		AVG(p.cost) AS cost 
	FROM payments p GROUP BY MONTH(p.paymentDate),YEAR(p.paymentDate),p.customer_id 
	HAVING ((SELECT AVG(p_avg.cost) FROM payments p_avg WHERE MONTH(p.paymentDate)=MONTH(p_avg.paymentDate) AND YEAR(p.paymentDate)=YEAR(p_avg.paymentDate))<=AVG(p.cost) AND AVG(p.cost)<@avgCost)
	) tempTable
INNER JOIN customers c on tempTable.id=c.id ORDER BY 'Год','Месяц';

GO
EXECUTE avgCostMoreThan 7000;
 


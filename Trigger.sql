USE commercialNetwork
GO
IF  EXISTS (SELECT * FROM [dbo].[sysobjects] WHERE id = object_id('check_sale') and OBJECTPROPERTY(id, 'IsTrigger') = 1) DROP TRIGGER check_sale;
GO
CREATE TRIGGER check_sale ON [dbo].[payments] INSTEAD OF INSERT AS
 
	DECLARE @date Date, @customerId INT, @ProductId INT, @quantity INT, @INSERTED_VALUES CURSOR,@cost_fact FLOAT, @cost FLOAT, @ErrText VARCHAR(255);
	DECLARE tempCur CURSOR FOR 
		SELECT ins.paymentDate,ins.customer_id,ins.product_id,ins.quantity,ins.cost,(prod.price*ins.quantity)
		FROM inserted ins INNER JOIN [dbo].[products] prod ON ins.product_id=prod.id;
	
	SET @INSERTED_VALUES=tempCur;

	OPEN @INSERTED_VALUES;
	FETCH NEXT FROM @INSERTED_VALUES INTO @date,@customerId,@ProductId,@quantity,@cost,@cost_fact;

	WHILE @@FETCH_STATUS=0
	BEGIN
		IF (@cost_fact<@cost)
		BEGIN
			INSERT INTO [commercialNetwork].[dbo].[payments] VALUES (@date,@customerId, @ProductId, @quantity,@cost);
		PRINT (
			 'ДАТА: '+CAST(@date AS VARCHAR(20)) 
			+', идентификатор товара: '+CAST(@ProductId  AS VARCHAR(20)) 
			+', количество: '+CAST(@quantity AS VARCHAR(20))
			+', фактическая стоимость: '+CAST(@cost_fact AS VARCHAR(20))
			+', предлагаемая стоимость: '+CAST(@cost AS VARCHAR(20))
			+', Продано!'
			);
		END
		ELSE
		BEGIN
		PRINT (
			 'ДАТА: '+CAST(@date AS VARCHAR(20)) 
			+', идентификатор товара: '+CAST(@ProductId  AS VARCHAR(20)) 
			+', количество: '+CAST(@quantity AS VARCHAR(20))
			+', фактическая стоимость: '+CAST(@cost_fact AS VARCHAR(20))
			+', предлагаемая стоимость: '+CAST(@cost AS VARCHAR(20))
			+', НЕ Продано!'
			);
		END;
		FETCH NEXT FROM @INSERTED_VALUES INTO @date,@customerId,@ProductId,@quantity,@cost,@cost_fact;
		END;
	CLOSE @INSERTED_VALUES;
	DEALLOCATE @INSERTED_VALUES;




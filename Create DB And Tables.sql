--дроп и создание базы
USE master;
IF EXISTS( select name from [sys].databases Where name='commercialNetwork') DROP DATABASE [commercialNetwork];
CREATE DATABASE [commercialNetwork];


USE [commercialNetwork];
GO
CREATE TABLE [customers] (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL DEFAULT 'Индивидуальный предприниматель',
    ogrn BIGINT   NOT NULL,
    inn BIGINT NOT NULL,
    kpp BIGINT NOT NULL DEFAULT 0,
    region VARCHAR(180) NOT NULL,
    city VARCHAR(180) NOT NULL,
    street VARCHAR(180) NOT NULL,
    houseNumber INT NOT NULL DEFAULT 0,
    addHouseNumber VARCHAR(25),
    phoneNumber VARCHAR(11),
    customerFirstName VARCHAR(150) NOT NULL DEFAULT 'Юридическое лицо',
    customerName VARCHAR(150) NOT NULL DEFAULT 'Юридическое лицо',
    customerLastName VARCHAR(150) NOT NULL DEFAULT 'Юридическое лицо',
    zipCode INT,
    eMale VARCHAR(50)
);

GO
CREATE TABLE [products] (
    id INT PRIMARY KEY IDENTITY,
    Name VARCHAR(255) NOT NULL,
    articul INT NOT NULL UNIQUE,
    unitCountName VARCHAR(50) NOT NULL DEFAULT 'Шт.',
    price MONEY NOT NULL DEFAULT 0,
    note VARCHAR(255)
);
GO
CREATE TABLE [payments] (
    id INT PRIMARY KEY IDENTITY,
    paymentDate DATE NOT NULL,
    customer_id  INT NOT NULL FOREIGN KEY REFERENCES [dbo].[customers](id),
    product_id INT NOT NULL FOREIGN KEY REFERENCES [dbo].[products](id),
    quantity INT NOT NULL DEFAULT 1,
    cost MONEY NOT NULL DEFAULT 0
);

--создаем ограничения
GO
ALTER TABLE [dbo].[customers]
ADD CONSTRAINT ogrnInnKpp_unique
UNIQUE ([OGRN],[INN],[KPP]);

GO
ALTER TABLE [payments] 
ADD CONSTRAINT defautlDate DEFAULT GETDATE() FOR [paymentDate]
;



CREATE DATABASE Toys_group;
CREATE TABLE ProductCategory (
    ProductCategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    ProductCategoryID INT,
    FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID)
);

CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(50) NOT NULL
);

CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(50) NOT NULL,
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    ProductID INT,
    CountryID INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);
INSERT INTO ProductCategory (ProductCategoryID, CategoryName)
VALUES 
    (1, 'Bikes'),
    (2, 'Clothing');
INSERT INTO Product (ProductID, ProductName, ProductCategoryID)
VALUES 
    (101, 'Bike-100', 1),
    (102, 'Bike-200', 1),
    (201, 'Bike Glove M', 2),
    (202, 'Bike Glove L', 2);
INSERT INTO Region (RegionID, RegionName)
VALUES 
    (1, 'WestEurope'),
    (2, 'SouthEurope');

INSERT INTO Country (CountryID, CountryName, RegionID)
VALUES 
    (1, 'France', 1),
    (2, 'Germany', 1),
    (3, 'Italy', 2),
    (4, 'Greece', 2);
INSERT INTO Sales (SaleID, SaleDate, ProductID, CountryID)
VALUES 
    (1001, '2023-01-10', 101, 1),
    (1002, '2023-02-15', 102, 2),
    (1003, '2023-03-20', 201, 3),
    (1004, '2023-04-25', 202, 4),
    (1005, '2023-05-30', 101, 1);
-- Query per ProductCategory
SELECT ProductCategoryID, COUNT(*)
FROM ProductCategory
GROUP BY ProductCategoryID
HAVING COUNT(*) > 1;

-- Query per Product
SELECT ProductID, COUNT(*)
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- Query per Region
SELECT RegionID, COUNT(*)
FROM Region
GROUP BY RegionID
HAVING COUNT(*) > 1;

-- Query per Country
SELECT CountryID, COUNT(*)
FROM Country
GROUP BY CountryID
HAVING COUNT(*) > 1;

-- Query per Sales
SELECT SaleID, COUNT(*)
FROM Sales
GROUP BY SaleID
HAVING COUNT(*) > 1;
SELECT 
    s.SaleID AS CodiceDocumento,
    s.SaleDate AS DataVendita,
    p.ProductName AS NomeProdotto,
    pc.CategoryName AS CategoriaProdotto,
    c.CountryName AS NomeStato,
    r.RegionName AS NomeRegione,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, s.SaleDate) > 180 THEN True
        ELSE False
    END AS PiùDi180Giorni
FROM 
    Sales s
JOIN Product p ON s.ProductID = p.ProductID
JOIN ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
JOIN Country c ON s.CountryID = c.CountryID
JOIN Region r ON c.RegionID = r.RegionID;
WITH VenditeAnnuali AS (
    SELECT 
        ProductID,
        SUM(quantity) AS TotaleVenduto,
        YEAR(SaleDate) AS Anno
    FROM 
        Sales
    WHERE 
        SaleDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    GROUP BY 
        ProductID, Anno
),
MediaAnnua AS (
    SELECT 
        AVG(TotaleVenduto) AS MediaVendite
    FROM 
        VenditeAnnuali
)

SELECT 
    v.ProductID,
    SUM(v.TotaleVenduto) AS TotaleVenduto
FROM 
    VenditeAnnuali v
JOIN 
    MediaAnnua m ON v.TotaleVenduto > m.MediaVendite
GROUP BY 
    v.ProductID;
WITH VenditeAnnuali AS (
    SELECT 
        ProductID,
        SUM(Quantity) AS TotaleVenduto,
        YEAR(SaleDate) AS Anno
    FROM 
        Sales
    WHERE 
        SaleDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    GROUP BY 
        ProductID, Anno
)

SELECT 
    ProductID,
    Anno,
    TotaleVenduto
FROM 
    VenditeAnnuali
ORDER BY 
    Anno, TotaleVenduto DESC;
CREATE TABLE SalesDetails (
    SaleDetailID INT AUTO_INCREMENT PRIMARY KEY,  -- ID unico per ogni dettaglio di vendita
    SaleID INT NOT NULL,                            -- Riferimento all'ID della vendita
    ProductID INT NOT NULL,                         -- Riferimento all'ID del prodotto
    Quantity INT NOT NULL,                          -- Quantità venduta del prodotto
    Price DECIMAL(10, 2) NOT NULL,                 -- Prezzo del prodotto al momento della vendita
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID), -- Vincolo di chiave esterna su Sales
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)  -- Vincolo di chiave esterna su Product
);
-- Query per ProductCategory
SELECT ProductCategoryID, COUNT(*)
FROM ProductCategory
GROUP BY ProductCategoryID
HAVING COUNT(*) > 1;

-- Query per Product
SELECT ProductID, COUNT(*)
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- Query per Region
SELECT RegionID, COUNT(*)
FROM Region
GROUP BY RegionID
HAVING COUNT(*) > 1;

-- Query per Country
SELECT CountryID, COUNT(*)
FROM Country
GROUP BY CountryID
HAVING COUNT(*) > 1;

-- Query per Sales
SELECT SaleID, COUNT(*)
FROM Sales
GROUP BY SaleID
HAVING COUNT(*) > 1;
SELECT 
    s.SaleID AS CodiceDocumento,
    s.SaleDate AS DataVendita,
    p.ProductName AS NomeProdotto,
    pc.CategoryName AS CategoriaProdotto,
    c.CountryName AS NomeStato,
    r.RegionName AS NomeRegione,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, s.SaleDate) > 180 THEN True
        ELSE False
    END AS PiùDi180Giorni
FROM 
    Sales s
JOIN Product p ON s.ProductID = p.ProductID
JOIN ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
JOIN Country c ON s.CountryID = c.CountryID
JOIN Region r ON c.RegionID = r.RegionID;
WITH VenditeAnnuali AS (
    SELECT 
        ProductID,
        SUM(Quantity) AS TotaleVenduto,
        YEAR(SaleDate) AS Anno
    FROM 
        Sales
    WHERE 
        SaleDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    GROUP BY 
        ProductID, Anno
),
MediaAnnua AS (
    SELECT 
        AVG(TotaleVenduto) AS MediaVendite
    FROM 
        VenditeAnnuali
)

SELECT 
    v.ProductID,
    SUM(v.TotaleVenduto) AS TotaleVenduto
FROM 
    VenditeAnnuali v
JOIN 
    MediaAnnua m ON v.TotaleVenduto > m.MediaVendite
GROUP BY 
    v.ProductID;
ALTER TABLE sales
ADD COLUMN Quantity INT;
WITH VenditeAnnuali AS (
    SELECT 
        ProductID,
        SUM(Quantity) AS TotaleVenduto,
        YEAR(SaleDate) AS Anno
    FROM 
        Sales
    WHERE 
        SaleDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    GROUP BY 
        ProductID, Anno
),
MediaAnnua AS (
    SELECT 
        AVG(TotaleVenduto) AS MediaVendite
    FROM 
        VenditeAnnuali
)

SELECT 
    v.ProductID,
    SUM(v.TotaleVenduto) AS TotaleVenduto
FROM 
    VenditeAnnuali v
JOIN 
    MediaAnnua m ON v.TotaleVenduto > m.MediaVendite
GROUP BY 
    v.ProductID;
SELECT 
    p.ProductID,
    YEAR(s.SaleDate) AS Anno,
    SUM(s.Quantity * s.UnitPrice) AS FatturatoTotale
FROM 
    Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductID, Anno
HAVING 
    SUM(s.Quantity) > 0;
ALTER TABLE sales
ADD COLUMN unitPrice DECIMAL(10,2);
SELECT 
    p.ProductID,
    YEAR(s.SaleDate) AS Anno,
    SUM(s.Quantity * s.UnitPrice) AS FatturatoTotale
FROM 
    Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductID, Anno
HAVING 
    SUM(s.Quantity) > 0;
  SELECT 
    c.CountryName AS NomeStato,
    YEAR(s.SaleDate) AS Anno,
    SUM(s.Quantity * s.UnitPrice) AS FatturatoTotale
FROM 
    Sales s
JOIN Country c ON s.CountryID = c.CountryID
GROUP BY 
    NomeStato, Anno
ORDER BY 
    Anno ASC, FatturatoTotale DESC;
 SELECT 
    pc.CategoryName,
    SUM(s.Quantity) AS TotaleRichieste
FROM 
    Sales s
JOIN Product p ON s.ProductID = p.ProductID
JOIN ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    pc.CategoryName
ORDER BY 
    TotaleRichieste DESC
LIMIT 1;
SELECT 
    p.ProductID,
    p.ProductName
FROM 
    Product p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE 
    s.SaleID IS NULL;
CREATE VIEW VistaProdotti AS
SELECT 
    p.ProductID,
    p.ProductName,
    pc.CategoryName
FROM 
    Product p
JOIN ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID;
CREATE VIEW VistaGeografica AS
SELECT 
    c.CountryID,
    c.CountryName,
    r.RegionID,
    r.RegionName
FROM 
    Country c
JOIN Region r ON c.RegionID = r.RegionID;
 

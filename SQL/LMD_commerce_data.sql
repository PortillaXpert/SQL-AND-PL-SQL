-- Author: Juan Pablo Portilla
-- Description: SQL script for defining a sales system database, including geographical hierarchy, clients, sellers, products, invoices, and line items.
-- Language: Oracle SQL / PL/SQL

--------------------------------------------------------------------------------
-- TABLE: Provincia
-- Description: Stores province codes and names with a positive value check.
--------------------------------------------------------------------------------
CREATE TABLE Provincia (
  codPro INT NOT NULL,
  nombrePro VARCHAR2(50) NOT NULL,
  CONSTRAINT pk_Provincia PRIMARY KEY(codPro),
  CONSTRAINT ckc_codPro CHECK(codPro > 0)
);

--------------------------------------------------------------------------------
-- TABLE: Pueblo
-- Description: Stores towns associated with a province.
--------------------------------------------------------------------------------
CREATE TABLE Pueblo (
  codPue INT NOT NULL,
  nombrePue VARCHAR2(50) NOT NULL,
  codPro INT NOT NULL,
  CONSTRAINT pk_Pueblo PRIMARY KEY (codPue),
  CONSTRAINT ckc_codPue CHECK(codPue > 0),
  CONSTRAINT fk_ProPue FOREIGN KEY (codPro) REFERENCES Provincia(codPro)
);

--------------------------------------------------------------------------------
-- TABLE: Cliente
-- Description: Stores customer data, including town and postal info.
--------------------------------------------------------------------------------
CREATE TABLE Cliente (
  codCli INT NOT NULL,
  nombreCli VARCHAR2(50) NOT NULL,
  direccionCli VARCHAR2(50) NOT NULL,
  codPostalCli INT NOT NULL,
  codPue INT NOT NULL,
  CONSTRAINT pk_Cliente PRIMARY KEY(codCli),
  CONSTRAINT ckc_codCli CHECK(codCli > 0),
  CONSTRAINT fk_PueCli FOREIGN KEY (codPue) REFERENCES Pueblo(codPue)
);

--------------------------------------------------------------------------------
-- TABLE: Vendedor
-- Description: Stores seller data with optional manager relationship.
--------------------------------------------------------------------------------
CREATE TABLE Vendedor (
  codVen INT NOT NULL,
  nombreVen VARCHAR2(50) NOT NULL,
  direccionVen VARCHAR2(50) NOT NULL,
  codPostalVen INT NOT NULL,
  codPue INT NOT NULL,
  codJefe INT,
  CONSTRAINT pk_Vendedor PRIMARY KEY(codVen),
  CONSTRAINT ckc_codVen CHECK(codVen > 0),
  CONSTRAINT fk_PueVen FOREIGN KEY(codPue) REFERENCES Pueblo(codPue),
  CONSTRAINT fk_VenVen FOREIGN KEY (codJefe) REFERENCES Vendedor(codVen)
);

--------------------------------------------------------------------------------
-- TABLE: Articulo
-- Description: Stores article/product information.
--------------------------------------------------------------------------------
CREATE TABLE Articulo (
  codArt INT NOT NULL,
  descripcionArt VARCHAR2(60) NOT NULL,
  categoriArt VARCHAR2(20) NOT NULL,
  precioArt FLOAT NOT NULL,
  stockArt INT NOT NULL,
  stock_minArt INT NOT NULL,
  CONSTRAINT pk_Articulo PRIMARY KEY(codArt),
  CONSTRAINT ckc_codArt CHECK(codArt > 0)
);

--------------------------------------------------------------------------------
-- TABLE: Factura
-- Description: Stores invoices related to clients and sellers.
--------------------------------------------------------------------------------
CREATE TABLE Factura (
  codFac INT NOT NULL,
  fechaFac DATE NOT NULL,
  codCli INT NOT NULL,
  codVen INT NOT NULL,
  ivaFac FLOAT,
  descuento FLOAT,
  CONSTRAINT pk_Factura PRIMARY KEY (codFac),
  CONSTRAINT ckc_codFac CHECK(codFac > 0),
  CONSTRAINT fk_CliFac FOREIGN KEY(codCli) REFERENCES Cliente(codCli),
  CONSTRAINT fk_VenFac FOREIGN KEY(codVen) REFERENCES Vendedor(codVen)
);

--------------------------------------------------------------------------------
-- TABLE: Lineas_Fac
-- Description: Stores line items for each invoice.
--------------------------------------------------------------------------------
CREATE TABLE Lineas_Fac (
  codFac INT NOT NULL,
  linea INT NOT NULL,
  cantLF INT NOT NULL,
  codArt INT NOT NULL,
  precioLF FLOAT NOT NULL,
  descuentoLF FLOAT,
  CONSTRAINT pk_Lineas_Fac PRIMARY KEY (codFac, linea),
  CONSTRAINT ckc_codFac_linea CHECK(codFac > 0 AND linea > 0),
  CONSTRAINT fk_Fac_LF FOREIGN KEY(codFac) REFERENCES Factura(codFac),
  CONSTRAINT fk_ArtLF FOREIGN KEY(codArt) REFERENCES Articulo(codArt)
);

--------------------------------------------------------------------------------
-- INSERT DATA: Provincia
--------------------------------------------------------------------------------
INSERT INTO Provincia VALUES (10, 'CAUCA');
INSERT INTO Provincia VALUES (20, 'BOLIVAR');
INSERT INTO Provincia VALUES (30, 'CORDOBA');
INSERT INTO Provincia VALUES (40, 'CALDAS');
INSERT INTO Provincia VALUES (50, 'RISARALDA');

--------------------------------------------------------------------------------
-- INSERT DATA: Pueblo
--------------------------------------------------------------------------------
INSERT INTO Pueblo VALUES (210, 'DOSQUEBRADAS', 50);
INSERT INTO Pueblo VALUES (220, 'CHINCHINA', 40);
INSERT INTO Pueblo VALUES (230, 'TURBACO', 20);
INSERT INTO Pueblo VALUES (240, 'TIMBIO', 10);
INSERT INTO Pueblo VALUES (250, 'MONTERIA', 30);

--------------------------------------------------------------------------------
-- INSERT DATA: Cliente
--------------------------------------------------------------------------------
INSERT INTO Cliente VALUES (1, 'FELIPE', 'CALLE 1-35', 10002, 250);
INSERT INTO Cliente VALUES (2, 'JHONNY', 'CALLE 5-22', 09001, 230);
INSERT INTO Cliente VALUES (3, 'ALEX', 'CALLE 5-70', 12005, 210);
INSERT INTO Cliente VALUES (4, 'LUISA', 'CALLE 9-68', 07502, 220);
INSERT INTO Cliente VALUES (5, 'ANDREA', 'CALLE 10-32', 90001, 240);

--------------------------------------------------------------------------------
-- INSERT DATA: Vendedor
--------------------------------------------------------------------------------
INSERT INTO Vendedor VALUES (100, 'JHON', 'CALLE 1 2-32', 150000, 210, NULL);
INSERT INTO Vendedor VALUES (200, 'LUIS', 'CALLE 5 4-50', 35000, 210, NULL);
INSERT INTO Vendedor VALUES (300, 'SAMANTHA', 'CALLE 2 3-43', 50000, 230, NULL);
INSERT INTO Vendedor VALUES (400, 'EDWIN', 'CALLE 2 5-36', 35000, 240, NULL);
INSERT INTO Vendedor VALUES (450, 'ANDRES', 'CALLE 9 12-22', 40000, 250, NULL);
INSERT INTO Vendedor VALUES (460, 'SARA', 'CALLE 4 13-30', 40000, 250, NULL);

UPDATE Vendedor SET codJefe = 200 WHERE codVen = 100;
UPDATE Vendedor SET codJefe = 450 WHERE codVen = 300;
UPDATE Vendedor SET codJefe = 450 WHERE codVen = 200;
UPDATE Vendedor SET codJefe = 100 WHERE codVen = 400;
UPDATE Vendedor SET codJefe = 100 WHERE codVen = 450;
UPDATE Vendedor SET codJefe = 200 WHERE codVen = 460;

--------------------------------------------------------------------------------
-- INSERT DATA: Articulo
--------------------------------------------------------------------------------
INSERT INTO Articulo VALUES (310, 'ORDENADOR DE ESCRITORIO', 'TECNOLOGIA', 4000000, 18, 3);
INSERT INTO Articulo VALUES (320, 'IMPRESORA LASER', 'TECNOLOGIA', 2655000, 15, 2);
INSERT INTO Articulo VALUES (330, 'ABRIGO LARGO', 'VESTUARIO', 220000, 110, 2);
INSERT INTO Articulo VALUES (340, 'TELEVISOR SAMSUNG 55', 'TECNOLOGIA', 2900000, 25, 3);
INSERT INTO Articulo VALUES (350, 'CHAQUETA TIPO GABAN', 'VESTUARIO', 112000, 80, 2);
INSERT INTO Articulo VALUES (360, 'SOPORTE TELEVISOR', 'TECNOLOGIA', 38000, 300, 1);
INSERT INTO Articulo VALUES (370, 'CAMISA DE TEMPORADA', 'VESTUARIO', 80000, 300, 1);

--------------------------------------------------------------------------------
-- INSERT DATA: Factura
--------------------------------------------------------------------------------
INSERT INTO Factura VALUES (410, TO_DATE('15/05/2022', 'DD/MM/YYYY'), 1, 200, 10, 30);
INSERT INTO Factura VALUES (420, TO_DATE('11/11/2023', 'DD/MM/YYYY'), 2, 200, 19, 20);
INSERT INTO Factura VALUES (430, TO_DATE('05/02/2022', 'DD/MM/YYYY'), 3, 400, 5, 10);
INSERT INTO Factura VALUES (440, TO_DATE('01/09/2022', 'DD/MM/YYYY'), 2, 100, 15, 40);
INSERT INTO Factura VALUES (450, TO_DATE('18/01/2022', 'DD/MM/YYYY'), 5, 450, 13, 20);
INSERT INTO Factura VALUES (460, TO_DATE('18/01/2022', 'DD/MM/YYYY'), 5, 460, 13, 20);
INSERT INTO Factura VALUES (470, TO_DATE('18/01/2022', 'DD/MM/YYYY'), 5, 460, 13, 20);

--------------------------------------------------------------------------------
-- INSERT DATA: Lineas_Fac
--------------------------------------------------------------------------------
INSERT INTO Lineas_Fac VALUES (410, 1, 2, 310, 8000000, 19);
INSERT INTO Lineas_Fac VALUES (420, 2, 3, 320, 7965000, 19);
INSERT INTO Lineas_Fac VALUES (430, 3, 1, 330, 220000, 5);
INSERT INTO Lineas_Fac VALUES (440, 4, 3, 340, 6600000, 15);
INSERT INTO Lineas_Fac VALUES (450, 5, 4, 350, 448000, 13);
INSERT INTO Lineas_Fac VALUES (460, 6, 2, 360, 76000, 13);
INSERT INTO Lineas_Fac VALUES (470, 7, 2, 370, 160000, 10);

--------------------------------------------------------------------------------
-- QUERIES
--------------------------------------------------------------------------------
SELECT DISTINCT ivaFac FROM Factura;
SELECT nombrePro FROM Provincia WHERE codPro < 30;
SELECT codFac, fechaFac FROM Factura WHERE codCli = 2 AND ivaFac = 19;
SELECT nombreVen, direccionVen FROM Vendedor WHERE nombreVen LIKE 'S%' OR nombreVen LIKE '%O%';
UPDATE Articulo SET precioArt = precioArt * 1.10 WHERE categoriArt = 'TECNOLOGIA';
SELECT codArt FROM Lineas_Fac NATURAL JOIN Articulo WHERE descripcionArt = 'TELEVISOR SAMSUNG 55';
DELETE FROM Lineas_Fac WHERE codArt = 340;
DELETE FROM Articulo WHERE descripcionArt = 'TELEVISOR SAMSUNG 55';
SELECT codArt, descripcionArt FROM Lineas_Fac NATURAL JOIN Articulo WHERE precioLF > 600000;
SELECT descripcionArt, precioArt FROM Articulo WHERE precioArt >= 180000 ORDER BY precioArt DESC;
SELECT descripcionArt, precioArt FROM Articulo WHERE precioArt >= 180000 ORDER BY descripcionArt;

CREATE TABLE Provincia (
codPro int not null,
nombrePro VARCHAR2(50) not null,
CONSTRAINT pk_Provincia PRIMARY KEY(codPro),
CONSTRAINT ckc_codPro CHECK(codPro>0)
);

create TABLE Pueblo (
codPue int not null,
nombrePue varchar2(50) not null,
codPro int not null,
CONSTRAINT pk_Pueblo PRIMARY KEY (codPue) ,
CONSTRAINT ckc_codPue CHECK(codPue>0) ,
CONSTRAINT fk_ProPue foreign key (codPro) references Provincia (codPro)
);

CREATE TABLE Cliente (
codCli int not null,
nombreCli VARCHAR2(50) not null,
direccionCli VARCHAR2(50) not null,
codPostalCli int not null,
codPue int not null,
CONSTRAINT pk_Cliente PRIMARY KEY(codCli),
CONSTRAINT ckc_codCli CHECK(codCli>0),
CONSTRAINT fk_PueCli foreign key(codPue) references Pueblo(codPue)
);

CREATE TABLE Vendedor (
codVen int not null,
nombreVen VARCHAR2(50) not null,
direccionVen VARCHAR2(50) not null,
codPostalVen int not null,
codPue int not null,
codJefe int,
CONSTRAINT pk_Vendedor PRIMARY KEY(codVen),
CONSTRAINT ckc_codVen CHECK(codVen>0),
CONSTRAINT fk_PueVen FOREIGN KEY(codPue) references Pueblo(codPue),
CONSTRAINT fk_VenVen FOREIGN KEY (codJefe) references Vendedor (codVen)
);

CREATE TABLE Articulo (
codArt int not null,
descripcionArt varchar2(60) not null,
categoriArt VARCHAR2(20) not null,
precioArt float not null,
stockArt int not null,
stock_minArt int not null,
CONSTRAINT pk_Articulo PRIMARY KEY(codArt),
CONSTRAINT ckc_codArt CHECK(codArt>0)
);



create TABLE factura (
codFac int not null,
fechaFac date not null,
codCli int not null,
codVen int not null,
ivaFac float,
descuento float,
CONSTRAINT pk_Fcatura PRIMARY KEY (codFac),
CONSTRAINT ckc_codFac CHECK(codFac>0) ,
CONSTRAINT fk_CliFac foreign key(codCli) references Cliente (codCli),
CONSTRAINT fk_VenFac FOREIGN KEY (codVen) references Vendedor (codVen)
);
 

create TABLE Lineas_Fac (
codFac int not null,
linea int not null,
cantLF int not null,
codArt int not null,
precioLF float not null,
descuentoLF float,
CONSTRAINT pk_Lineas_Fac PRIMARY KEY (codFac,linea),
CONSTRAINT ckc_codFac_linea CHECK(codFac>0 and linea>0),
CONSTRAINT fk_Fac_LF foreign key(codFac) references Factura(codFac),
CONSTRAINT fk_ArtLF FOREIGN KEY (codArt) references Articulo (codArt)
);


--Datos de la tabla Provincia--

INSERT INTO Provincia (codPro, nombrePro) VALUES (10, 'CAUCA');
INSERT INTO Provincia (codPro, nombrePro) VALUES (20, 'BOLIVAR');
INSERT INTO Provincia (codPro, nombrePro) VALUES (30, 'CORDOBA');
INSERT INTO Provincia (codPro, nombrePro) VALUES (40, 'CALDAS');
INSERT INTO Provincia (codPro, nombrePro) VALUES (50, 'RISARALDA');

--Datos de la tabla Pueblo--

INSERT INTO Pueblo (codPue, nombrePue,codPro) VALUES (210, 'DOSQUEBRADAS',50);
INSERT INTO Pueblo (codPue, nombrePue,codPro) VALUES (220, 'CHINCHINA', 40);
INSERT INTO Pueblo (codPue, nombrePue,codPro) VALUES (230, 'TURBACO', 20);
INSERT INTO Pueblo (codPue, nombrePue,codPro) VALUES (240, 'TIMBIO', 10);
INSERT INTO Pueblo (codPue, nombrePue,codPro) VALUES (250, 'MONTERIA', 30);

--Datos de la tabla Cliente--

INSERT INTO Cliente (codCli, nombreCli,direccionCli, codPostalCli,codPue) VALUES (1, 'FELIPE', 'CALLE 1-35', 10002,250);
INSERT INTO Cliente (codCli, nombreCli,direccionCli,codPostalCli,codPue) VALUES (2, 'JHONNY', 'CALLE  5-22', 09001, 230);
INSERT INTO Cliente (codCli, nombreCli,direccionCli, codPostalCli, codPue) VALUES (3, 'ALEX', 'CALLE 5-70', 12005, 210);
INSERT INTO Cliente (codCli, nombreCli,direccionCli,codPostalCli,codPue) VALUES (4, 'LUISA', 'CALLE 9-68', 07502, 220);
INSERT INTO Cliente (codCli, nombreCli,direccionCli, codPostalCli,codPue) VALUES (5, 'ANDREA', 'CALLE 10-32', 90001, 240);

--Datos de la tabla Vendedor --

INSERT INTO Vendedor (codVen, nombreVen, direccionVen, codPostalVen, codPue, codJefe) VALUES (100, 'JHON', 'CALLE 1 2-32', 150000, 210, null);
INSERT INTO Vendedor (codVen, nombreVen, direccionVen, codPostalVen, codPue, codJefe) VALUES (200, 'LUIS', 'CALLE 5 4-50', 35000, 210, null);
INSERT INTO Vendedor (codVen, nombreVen, direccionVen, codPostalVen, codPue, codJefe) VALUES (300, 'SAMANTHA', 'CALLE 2 3-43', 50000, 230, null);
INSERT INTO Vendedor (codVen, nombreVen, direccionVen, codPostalVen, codPue, codJefe) VALUES (400, 'EDWIN', 'CALLE 2 5-36', 35000, 240, null);
INSERT INTO Vendedor (codVen, nombreVen, direccionVen, codPostalVen, codPue, codJefe) VALUES (450, 'ANDRES', 'CALLE 9 12-22', 40000, 250, null);
INSERT INTO Vendedor (codVen, nombreVen, direccionVen, codPostalVen, codPue, codJefe) VALUES (460, 'SARA', 'CALLE 4 13-30', 40000, 250, null);

--Update de la tabla Vendedor --
update Vendedor set codJefe = 200 where codVen = 100;
update Vendedor set codJefe = 450 where codVen = 300;
update Vendedor set codJefe = 450 where codVen = 200;
update Vendedor set codJefe = 100 where codVen = 400;
update Vendedor set codJefe = 100 where codVen = 450;
update Vendedor set codJefe = 200 where codVen = 460;


--Datos de la tabla Artículo"--

INSERT INTO Articulo (codArt,descripcionArt,categoriArt,precioArt,stockArt, stock_minArt)
VALUES (310, 'ORDENADOR DE ESCRITORIO', 'TECNOLOGIA',4000000, 18,3);

INSERT INTO Articulo (codArt, descripcionArt, categoriArt, precioArt, stockArt, stock_minArt)
VALUES (320, 'IMPRESORA LASER', 'TECNOLOGIA', 2655000, 15,2);

INSERT INTO Articulo (codArt, descripcionArt,categoriArt,precioArt, stockArt, stock_minArt)
VALUES (330, 'ABRIGO LARGO', 'VESTUARIO', 220000, 110,2);

INSERT INTO Articulo (codArt, descripcionArt,categoriArt,precioArt, stockArt, stock_minArt)
VALUES (340, 'TELEVISOR SAMSUNG 55','TECNOLOGIA', 2900000, 25, 3);

INSERT INTO Articulo (codArt, descripcionArt,categoriArt,precioArt, stockArt, stock_minArt)
VALUES (350, 'CHAQUETA TIPO GABAN', 'VESTUARIO', 112000, 80,2);

INSERT INTO Articulo (codArt, descripcionArt,categoriArt,precioArt, stockArt, stock_minArt)
VALUES (360, 'SOPORTE TELEVISOR', 'TECNOLOGIA', 38000, 300,1);

INSERT INTO Articulo (codArt, descripcionArt,categoriArt,precioArt, stockArt, stock_minArt)
VALUES (370, 'CAMISA DE TEMPORADA', 'VESTUARIO', 80000, 300,1);

--Datos de la tabla factura--
INSERT INTO Factura (codFac, fechaFac, codCli,codVen, ivaFac, descuento) VALUES (410, '15/05/202',1,200,10,30);
INSERT INTO Factura (codFac, fechaFac, codCli,codVen, ivaFac, descuento) VALUES (420, '11/11/2023', 2, 200,19,20);
INSERT INTO Factura (codFac, fechaFac, codCli, codVen, ivaFac,descuento) VALUES (430, '05/02/2022', 3,400, 5,10);
INSERT INTO Factura (codFac, fechaFac,codCli, codVen, ivaFac,descuento) VALUES (440, '01/09/2022', 2,100, 15,40);
INSERT INTO Factura (codFac, fechaFac,codCli, codVen,ivaFac,descuento) VALUES (450, '18/01/2022', 5,450, 13,20);
INSERT INTO Factura (codFac, fechaFac,codCli, codVen,ivaFac,descuento) VALUES (460, '18/01/2022', 5,460, 13,20);
INSERT INTO Factura (codFac, fechaFac,codCli, codVen,ivaFac,descuento) VALUES (470, '18/01/2022', 5,460, 13,20);

--Datos de la tabla Lineas-Fac--
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (410,1,2,310,8000000,19);
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (420,2,3,320,7965000,19);
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (430,3,1,330,220000,5);
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (440,4,3,340,6600000,15);
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (450,5,4,350,448000,13);
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (460,6,2,360,76000,13);
INSERT INTO Lineas_Fac(codFac, linea, cantLF,codArt, precioLF, descuentoLF) VALUES (470,7,2,370,160000,10);

--Consultas--
select distinct ivaFac from Factura;
select nombrePro from Provincia where codPro < 30;
select codFac,fechaFac from Factura where codCli=2 and ivaFac=19;
select nombreVen,direccionVen from Vendedor where nombreVen like 'S%' or nombreVen like '%O%';
update Articulo set  precioArt = precioArt*1.10 where categoriArt = 'TECNOLOGIA';
select codArt from Lineas_Fac natural join Articulo where descripcionArt = 'TELEVISOR SAMSUNG 55';
delete from Lineas_Fac where codArt = 340;
delete from Articulo where descripcionArt = 'TELEVISOR SAMSUNG 55';
select codArt,DescripcionArt from Lineas_Fac natural join Articulo where precioLF > 600000;
select descripcionArt, precioArt from Articulo where precioArt >= 180000 order by precioArt desc;
select descripcionArt, precioArt from Articulo where precioArt >= 180000 order by descripcionArt;

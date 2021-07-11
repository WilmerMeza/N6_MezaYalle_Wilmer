use master;
GO
DROP database IF EXISTS DBVENTAS;
CREATE DATABASE DBVENTAS;
GO
USE DBVENTAS;
GO
CREATE TABLE PERSONAS (
    IDPER int  NOT NULL IDENTITY(1,1),
    NOMPER varchar(20)  NOT NULL,
    APEPER varchar(20)  NOT NULL,
    PASPER varchar(16)  NOT NULL,
    EMAPER varchar(20)  NOT NULL,
    DIREPER varchar(20)  NOT NULL,
    DNIPER char(8)  NOT NULL,
    CELPER char(9)  NOT NULL,
    ESTPER char(1)  NOT NULL DEFAULT 'A',
    ROLPER char(1)  NOT NULL,
    PERSONAS_IDPER int NULL,
    CONSTRAINT PERSONAS_pk PRIMARY KEY  (IDPER)
);

-- Contiene los datos de la tabla producto 
-- Table: PRODUCTOS
CREATE TABLE PRODUCTOS (
    IDPROD int  NOT NULL IDENTITY(1,1),
    NOMPROD varchar(20)  NOT NULL,
    MODPRD varchar(20)  NOT NULL,
    PREPROD decimal  NOT NULL,
    DESPROD varchar(50)  NOT NULL,
	STOCKPROD int not null,
	ESTPROD char(1)  NOT NULL DEFAULT 'A',
    CONSTRAINT PRODUCTOS_pk PRIMARY KEY  (IDPROD)
);


--Contiene los datos de la tabla sucursal
-- Table: SUCURSAL
CREATE TABLE SUCURSAL (
    IDSUC int  NOT NULL IDENTITY(1,1),
    NOMSUC varchar(20)  NOT NULL,
    DIRSUC varchar(30)  NOT NULL,
    CONSTRAINT SUCURSAL_pk PRIMARY KEY  (IDSUC)
);


-- Contiene los datos de la tabla venta
-- Table: VENTAS
CREATE TABLE VENTAS (
    IDVENT int  NOT NULL IDENTITY(1,1),
    COSVENT int  NOT NULL,
    FECVENT date  NOT NULL,
    IDPER int  NOT NULL,
    IDPROD int  NOT NULL,
    IDSUC int  NOT NULL,
    IDVENDET int  NOT NULL,
    CONSTRAINT VENTAS_pk PRIMARY KEY  (IDVENT)
);



-- Contiene los datos de la tabla venta-detalle
-- Table: VENTA_DETALLE
CREATE TABLE VENTA_DETALLE (
    IDVENDET int  NOT NULL IDENTITY(1,1),
    CLIVENDET varchar(20)  NOT NULL,
    DNIVENDET char(8)  NOT NULL,
    CONSTRAINT VENTA_DETALLE_pk PRIMARY KEY  (IDVENDET)
);


/*






 */




-- Foreign Keys
-- Reference: PERSONAS_PERSONAS 
ALTER TABLE PERSONAS ADD CONSTRAINT PERSONAS_PERSONAS
    FOREIGN KEY (PERSONAS_IDPER)
    REFERENCES PERSONAS (IDPER);
GO
-- Reference: VENTAS_PERSONAS 
ALTER TABLE VENTAS ADD CONSTRAINT VENTAS_PERSONAS
    FOREIGN KEY (IDPER)
    REFERENCES PERSONAS (IDPER);
GO
-- Reference: VENTAS_PRODUCTOS
ALTER TABLE VENTAS ADD CONSTRAINT VENTAS_PRODUCTOS
    FOREIGN KEY (IDPROD)
    REFERENCES PRODUCTOS (IDPROD);
GO
-- Reference: VENTAS_SUCURSAL 
ALTER TABLE VENTAS ADD CONSTRAINT VENTAS_SUCURSAL
    FOREIGN KEY (IDSUC)
    REFERENCES SUCURSAL (IDSUC);
GO
-- Reference: VENTAS_VENTA_DETALLE 
ALTER TABLE VENTAS ADD CONSTRAINT VENTAS_VENTA_DETALLE
    FOREIGN KEY (IDVENDET)
    REFERENCES VENTA_DETALLE (IDVENDET);
GO
-- End of file.


/*            





*/



-- Validaciòn si hay administradores con el mismo numero de DNI
CREATE OR ALTER PROCEDURE sptAdministrador
(
    @nombre VARCHAR(20),
    @apellido VARCHAR(20),
	@password VARCHAR(16),
	@email varchar(20),
	@direccion varchar(20),
    @dni CHAR(8),
	@celular CHAR(9),
    @estado CHAR(1),
	@rol CHAR(1)
    
)
AS
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(*) FROM dbo.PERSONAS AS V WHERE V.DNIPER = @dni) = 1
                ROLLBACK TRAN
            ELSE
                INSERT INTO dbo.PERSONAS
                (NOMPER, APEPER,PASPER, EMAPER,DIREPER,DNIPER,CELPER,ESTPER,ROLPER)
                VALUES
                (UPPER(@nombre), UPPER(@apellido), @password, @email, @direccion, @dni, @celular, @estado,@rol)
                COMMIT TRAN

        END TRY
        BEGIN CATCH
            SELECT 'Este vendedor ya ha sido registrado.' AS 'ERROR'
                IF @@TRANCOUNT > 0 ROLLBACK TRAN; 
        END CATCH
    END
GO

-- Insetarmos los datos de los administradores
EXEC sptAdministrador 'WILMER', 'MEZA', 'QUID1343','ADMIN@GO.COM','JR. PUNO', '72717476','945654234','A','A'
EXEC sptAdministrador 'ANA', 'SANCHEZ', 'QUID1343','ADMIN@GO.COM','JR. CHINCHA', '37717377','945654234','A','A'
EXEC sptAdministrador 'JOSE', 'PEREZ', 'QUID1343','ADMIN@GO.COM','JR. AREQUIPA', '27717322','945654234','A','A'
EXEC sptAdministrador 'CESAR', 'DE LA CRUZ', 'QUID1343','ADMIN@GO.COM','JR. CHACHAPOLLAS', '17717372','945654234','A','A'
EXEC sptAdministrador 'KARLA', 'YALLE', 'QUID1343','ADMIN@GO.COM','JR. ICA', '66757362','945654234','A','A'
GO


--  Validamos si existe el jefe de sucursal y vendedor con el mismo numero de DNI
CREATE OR ALTER PROCEDURE sptJefeSucursalVendedor
(
    @nombre VARCHAR(20),
    @apellido VARCHAR(20),
	@password VARCHAR(16),
	@email varchar(20),
	@direccion varchar(20),
    @dni CHAR(8),
	@celular CHAR(9),
    @estado CHAR(1),
	@rol CHAR(1),
	@identificadorPersonal int 
)
AS
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(*) FROM dbo.PERSONAS AS V WHERE V.DNIPER = @dni) = 1
                ROLLBACK TRAN
            ELSE
                INSERT INTO dbo.PERSONAS
                (NOMPER, APEPER,PASPER, EMAPER,DIREPER,DNIPER,CELPER,ESTPER,ROLPER,PERSONAS_IDPER)
                VALUES
                (UPPER(@nombre), UPPER(@apellido), @password, @email, @direccion, @dni, @celular, @estado,@rol,@identificadorPersonal)
                COMMIT TRAN

        END TRY
        BEGIN CATCH
            SELECT 'Este vendedor ya ha sido registrado.' AS 'ERROR'
                IF @@TRANCOUNT > 0 ROLLBACK TRAN; 
        END CATCH
    END
GO

EXEC sptJefeSucursalVendedor 'NOE', 'CANDELA', 'QUID1343','user1@GO.COM','JR. moquegua', '62227476','945654234','A','A','1'
EXEC sptJefeSucursalVendedor 'WILIAMS', 'DE LA TORRES', 'Imperial','user2@GO.COM','JR. parteos', '47733377','945654234','A','A','1'
EXEC sptJefeSucursalVendedor 'DAYANNA', 'RIVERA', 'Imper123','user3@GO.COM','JR. MARCAHUASI', '17744322','945654234','A','A','2'
EXEC sptJefeSucursalVendedor 'MAYRA', 'SANCHEZ', 'Justin12','user5@GO.COM','JR. CHIN', '67733372','945654234','A','A','1'
EXEC sptJefeSucursalVendedor 'CRIS', 'CANDELA', 'Martfff','user22@GO.COM','JR. AYACY', '16717362','945654234','A','A','4'
GO



/*



*/





/* Procedimiento para los registros producto, validando que no se repita el mismo nombre*/

CREATE OR ALTER PROCEDURE spInsertProducto
    (
	   @nombreProd VARCHAR(20),
	   @modeloProd VARCHAR(20),
        @precioProd DECIMAL,
        @descripcionProd VARCHAR(50),
        @stockProd INT,
        @estadoProd CHAR(1)
    )
AS
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
        BEGIN TRAN;
            SET DATEFORMAT dmy
            IF (SELECT COUNT(*) FROM dbo.PRODUCTOS AS P WHERE P.NOMPROD = @nombreProd) = 1
                ROLLBACK TRAN;
            ELSE
                INSERT INTO dbo.PRODUCTOS
               (NOMPROD, MODPRD, PREPROD, DESPROD, STOCKPROD, ESTPROD)
                VALUES
               (UPPER(@nombreProd),UPPER(@modeloProd), @precioProd, @descripcionProd, @stockProd, @estadoProd)
               COMMIT TRAN;
        END TRY
        BEGIN CATCH
            SELECT 'El producto ya existe.' AS 'ERROR'
            IF @@TRANCOUNT > 0 ROLLBACK TRAN; 
        END CATCH
    END
GO

EXEC spInsertProducto 'MOUSE','AK-342','34.5','mause lacer','34','A'
EXEC spInsertProducto 'TECLADO','LGT-233','23.5','teclado simple','50','A'
EXEC spInsertProducto 'CAMARA','ABS-11','60.5','camara webcam','24','A'
EXEC spInsertProducto 'FILMADORA','MA-11','120.5','camara filmardora','10','A'
go

INSERT INTO SUCURSAL (NOMSUC,DIRSUC) 
VALUES	('CANETE','JR. AYACUCHO'),
		('CHINCHA','JR. AYACUCHO'),
		('LIMA','JR. AYACUCHO');
GO
INSERT INTO VENTA_DETALLE (CLIVENDET,DNIVENDET)
VALUES	('ANDRES','23433621'),
		('MARCOS','13777629'),
		('FRANK','33457625'),
		('FELIPE','53887622'),
		('LUCAS','83227628'),
		('JAMES','93466626'),
		('LUIS','13466623');
GO

INSERT INTO VENTAS (COSVENT,FECVENT,IDPER,IDPROD,IDSUC,IDVENDET)
VALUES	('34','2021-12-05','1','2','1','3'),
		('25','2021-12-05','2','3','1','3'),
		('50','2021-12-05','3','1','1','3'),
		('48','2021-12-05','4','2','2','2'),
		('23','2021-12-05','2','1','2','2'),
		('72','2021-12-05','1','2','1','2');
go


-- Vista ventas (muestra los datos de la tabla venta)
CREATE VIEW V_VENTAS as
select COSVENT,FECVENT,PERSONAS.NOMPER,PRODUCTOS.NOMPROD,SUCURSAL.NOMSUC,VENTA_DETALLE.CLIVENDET FROM VENTAS
inner join PERSONAS ON VENTAS.IDPER= PERSONAS.IDPER
inner join PRODUCTOS ON VENTAS.IDPROD=PRODUCTOS.IDPROD
inner join SUCURSAL ON VENTAS.IDSUC=SUCURSAL.IDSUC
inner join VENTA_DETALLE ON VENTAS.IDVENDET=VENTA_DETALLE.IDVENDET;
GO


-- Vista persona (muestra los datos de la tabla persona)
CREATE VIEW V_PERSONA as
select ROW_NUMBER() OVER( ORDER BY super.IDPER desc) AS FILA, SUPER.IDPER,
super.NOMPER,super.APEPER,super.PASPER,
super.EMAPER,super.DIREPER,super.DNIPER,super.CELPER,
super.ROLPER,super.ESTPER,CONCAT(infer.NOMPER,' ',infer.APEPER)
as RELACION  from PERSONAS  as super
left join PERSONAS as infer on super.PERSONAS_IDPER =infer.IDPER;
GO


-- FIN
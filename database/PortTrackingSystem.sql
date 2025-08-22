-- Veritabanı Oluşturma
CREATE DATABASE PortTrackingSystem;
GO

USE PortTrackingSystem;
GO

-- Tabloları Oluşturma
CREATE TABLE Ships (
    ShipId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    IMO VARCHAR(10) UNIQUE NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    Flag NVARCHAR(50) NOT NULL,
    YearBuilt INT NOT NULL
);
GO

CREATE TABLE Ports (
    PortId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Country NVARCHAR(50) NOT NULL,
    City NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE CrewMembers (
    CrewId INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    Role NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE ShipVisits (
    VisitId INT PRIMARY KEY IDENTITY(1,1),
    ShipId INT NOT NULL,
    PortId INT NOT NULL,
    ArrivalDate DATETIME NOT NULL,
    DepartureDate DATETIME NOT NULL,
    Purpose NVARCHAR(100) NOT NULL,
    FOREIGN KEY (ShipId) REFERENCES Ships(ShipId),
    FOREIGN KEY (PortId) REFERENCES Ports(PortId)
);
GO

CREATE TABLE Cargoes (
    CargoId INT PRIMARY KEY IDENTITY(1,1),
    ShipId INT NOT NULL,
    Description NVARCHAR(200) NOT NULL,
    WeightTon DECIMAL(10,2) NOT NULL,
    CargoType NVARCHAR(50) NOT NULL,
    FOREIGN KEY (ShipId) REFERENCES Ships(ShipId)
);
GO

CREATE TABLE ShipCrewAssignments (
    AssignmentId INT PRIMARY KEY IDENTITY(1,1),
    ShipId INT NOT NULL,
    CrewId INT NOT NULL,
    AssignmentDate DATETIME NOT NULL,
    FOREIGN KEY (ShipId) REFERENCES Ships(ShipId),
    FOREIGN KEY (CrewId) REFERENCES CrewMembers(CrewId),
    CONSTRAINT UC_ShipCrew UNIQUE (ShipId, CrewId, AssignmentDate)
);
GO

-- İş Kuralları için Constraint'ler
ALTER TABLE ShipVisits ADD CONSTRAINT CHK_ArrivalBeforeDeparture CHECK (ArrivalDate < DepartureDate);
GO

ALTER TABLE Cargoes ADD CONSTRAINT CHK_WeightPositive CHECK (WeightTon > 0);
GO

-- Örnek Veri Girişi
INSERT INTO Ships (Name, IMO, Type, Flag, YearBuilt)
VALUES 
    ('Evergreen Star', 'IMO1234567', 'Container', 'Panama', 2015),
    ('Ocean Queen', 'IMO2345678', 'Tanker', 'Liberia', 2018),
    ('Blue Horizon', 'IMO3456789', 'Cargo', 'Malta', 2010),
    ('Sea Eagle', 'IMO4567890', 'Bulk Carrier', 'Norway', 2020),
    ('Starlight', 'IMO5678901', 'Passenger', 'Bahamas', 2017);
GO

INSERT INTO Ports (Name, Country, City)
VALUES 
    ('Izmir Port', 'Turkey', 'Izmir'),
    ('Hamburg Port', 'Germany', 'Hamburg'),
    ('Singapore Port', 'Singapore', 'Singapore'),
    ('Rotterdam Port', 'Netherlands', 'Rotterdam'),
    ('Los Angeles Port', 'USA', 'Los Angeles');
GO

INSERT INTO CrewMembers (FirstName, LastName, Email, PhoneNumber, Role)
VALUES 
    ('Ahmet', 'Yılmaz', 'ahmet.yilmaz@example.com', '+90 532 123 45 67', 'Captain'),
    ('Ayşe', 'Demir', 'ayse.demir@example.com', '+90 533 234 56 78', 'Engineer'),
    ('Mehmet', 'Kaya', 'mehmet.kaya@example.com', '+90 534 345 67 89', 'Navigator'),
    ('Fatma', 'Çelik', 'fatma.celik@example.com', '+90 535 456 78 90', 'Crew Member'),
    ('Ali', 'Öztürk', 'ali.ozturk@example.com', '+90 536 567 89 01', 'First Officer');
GO

INSERT INTO ShipVisits (ShipId, PortId, ArrivalDate, DepartureDate, Purpose)
VALUES 
    (1, 1, '2025-08-01 10:00:00', '2025-08-03 12:00:00', 'Loading'),
    (2, 2, '2025-08-02 08:00:00', '2025-08-04 14:00:00', 'Unloading'),
    (3, 3, '2025-08-05 09:00:00', '2025-08-06 11:00:00', 'Maintenance'),
    (4, 4, '2025-08-07 15:00:00', '2025-08-09 17:00:00', 'Loading'),
    (5, 5, '2025-08-10 12:00:00', '2025-08-12 16:00:00', 'Passenger Transfer');
GO

INSERT INTO Cargoes (ShipId, Description, WeightTon, CargoType)
VALUES 
    (1, 'Electronics', 150.50, 'General'),
    (2, 'Crude Oil', 5000.00, 'Dangerous'),
    (3, 'Grain', 2000.75, 'Food'),
    (4, 'Steel Coils', 3000.25, 'Industrial'),
    (5, 'Luggage', 100.00, 'Passenger Goods');
GO

INSERT INTO ShipCrewAssignments (ShipId, CrewId, AssignmentDate)
VALUES 
    (1, 1, '2025-08-01 00:00:00'),
    (2, 2, '2025-08-02 00:00:00'),
    (3, 3, '2025-08-05 00:00:00'),
    (4, 4, '2025-08-07 00:00:00'),
    (5, 5, '2025-08-10 00:00:00');
GO
CREATE SCHEMA LosSantosCustom;
USE LosSantosCustom;

CREATE TABLE dealership(
    id_dealership INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone_number CHAR(9) NOT NULL,
    city VARCHAR(100) NOT NULL,
    post_code CHAR(5) NOT NULL
);
 
CREATE TABLE client(
    id_client INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dni CHAR(9) UNIQUE NOT NULL,
    phone_number CHAR(9) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user(
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password CHAR(60) NOT NULL,
    is_boss BOOLEAN DEFAULT FALSE,
    id_dealership INT NOT NULL,
    FOREIGN KEY (id_dealership) REFERENCES dealership(id_dealership)
);

CREATE TABLE vehicle(
    id_vehicle INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_type ENUM('MOTOCICLETA','COCHE','CICLOMOTORES') NOT NULL,
    model VARCHAR(150) NOT NULL,
    year INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    color VARCHAR(30) NOT NULL,
    plate VARCHAR(9),
    VIN VARCHAR(17) UNIQUE NOT NULL,
    km INT NOT NULL DEFAULT 0,
    fuel ENUM('GASOLINA', 'DIESEL','ELECTRICO') NOT NULL,
    status ENUM('DISPONIBLE', 'VENDIDO', 'REPARACION') NOT NULL DEFAULT 'DISPONIBLE',
    resource_path LONGTEXT,
    id_dealership INT NOT NULL,
    FOREIGN KEY (id_dealership) REFERENCES dealership(id_dealership)
);

CREATE TABLE mechanic(
    id_mechanic INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    is_boss BOOLEAN NOT NULL DEFAULT FALSE,
    specialization ENUM('MOTOCICLETAS', 'CICLOMOTORES', 'COCHES'),
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE seller(
    id_seller INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE sale(
    id_sale INT PRIMARY KEY AUTO_INCREMENT,
    id_vehicle INT NOT NULL,
    id_client INT NOT NULL,
    id_seller INT NOT NULL,
    final_price DECIMAL(12,2),
    paid_at DATE,
    paid_method ENUM('EFECTIVO', 'TRANSFERENCIA'),
    FOREIGN KEY (id_vehicle) REFERENCES vehicle(id_vehicle),
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_seller) REFERENCES seller(id_seller)
);

CREATE TABLE sale_proposal(
    id_proposal INT PRIMARY KEY AUTO_INCREMENT,
    id_client INT NOT NULL,
    id_vehicle INT NOT NULL,
    id_seller INT NOT NULL,
    offered_price DECIMAL(12,2),
    valid_until DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_vehicle) REFERENCES vehicle(id_vehicle),
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_seller) REFERENCES seller(id_seller)
);

CREATE TABLE repair(
    id_repair INT PRIMARY KEY AUTO_INCREMENT,
    id_vehicle INT NOT NULL,
    id_client INT NOT NULL,
    id_mechanic INT NOT NULL,
    description LONGTEXT,
    estimated_hours DECIMAL(5,2),
    offered_price DECIMAL(12,2),
    start_date DATE,
    end_date DATE,
    state ENUM('FINALIZADO', 'ESPERANDO', 'REPARANDO'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_vehicle) REFERENCES vehicle(id_vehicle),
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_mechanic) REFERENCES mechanic(id_mechanic)
);

CREATE TABLE material(
    id_material INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description LONGTEXT,
    price DECIMAL(12,2) NOT NULL,
    stock INT DEFAULT 1
);

CREATE TABLE repair_material(
    id_repair INT NOT NULL,
    id_material INT NOT NULL,
    quantity INT,
    PRIMARY KEY(id_repair, id_material),
    FOREIGN KEY (id_repair) REFERENCES repair(id_repair),
    FOREIGN KEY (id_material) REFERENCES material(id_material)
);
DROP TABLE IF EXISTS borough;
DROP TABLE IF EXISTS borough_fees;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user_location;
DROP TABLE IF EXISTS couriers;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS vendor_items;
DROP TABLE IF EXISTS cuisine;
DROP TABLE IF EXISTS vendor_cuisine;
DROP TABLE IF EXISTS licenses;
DROP TABLE IF EXISTS vendor_licenses;
DROP TABLE IF EXISTS placed_orders;
DROP TABLE IF EXISTS order_item;

/* --- --- --- --- --- --- --- --- TABLE CREATION --- --- --- --- --- --- --- --- */
CREATE TABLE borough (
borough_id INT NOT NULL AUTO_INCREMENT,
    	borough_name VARCHAR(50) NOT NULL,
    	PRIMARY KEY (borough_id)
);


CREATE TABLE borough_fees (
	borough_from INT NOT NULL,
    	borough_to INT NOT NULL,
    	fee DECIMAL(5, 2) NOT NULL,
    	PRIMARY KEY (borough_from, borough_to),
    	FOREIGN KEY (borough_from) REFERENCES borough(borough_id),
    	FOREIGN KEY (borough_to) REFERENCES borough(borough_id)
);

CREATE TABLE users (
	user_id INT NOT NULL AUTO_INCREMENT,
    	email VARCHAR(100) NOT NULL,
    	password VARCHAR(50) NOT NULL,
    	username VARCHAR(50) NOT NULL,
    	phone VARCHAR(15),
    	identity_document VARCHAR(100),
    	date_of_birth DATE NOT NULL,
    	last_name VARCHAR(100) NOT NULL, 
    	first_name VARCHAR(100) NOT NULL,
  		middle_name VARCHAR(100),
  		credit_card_number VARCHAR(12),
    	credit_card_expiry_date VARCHAR(7),
    	credit_card_CVV VARCHAR(3),
    	discount_credit DECIMAL(5, 2) DEFAULT 0,
    	PRIMARY KEY (user_id)
);

CREATE TABLE user_location (
	user_location_id INT NOT NULL AUTO_INCREMENT,
    	user_id INT NOT NULL,
    	street_number VARCHAR(100) NOT NULL,
    	city VARCHAR(100) NOT NULL,
    	country VARCHAR(100) NOT NULL,
    	postal_code CHAR(6) NOT NULL,
    	borough_id INT NOT NULL,
    	PRIMARY KEY (user_location_id),
    	FOREIGN KEY (user_id) REFERENCES users(user_id),
    	FOREIGN KEY (borough_id) REFERENCES borough(borough_id)
);


CREATE TABLE couriers (
	courier_id INT AUTO_INCREMENT NOT NULL,
    	phone_number VARCHAR(15) NOT NULL,
    	email VARCHAR(100) NOT NULL,
    	password VARCHAR(50) NOT NULL,
    	username VARCHAR(50) NOT NULL, 
    	last_name VARCHAR(100) NOT NULL,
    	first_name VARCHAR(100) NOT NULL,
    	middle_name VARCHAR(100),
	    work_permit VARCHAR(100) NOT NULL,
    	driver_license VARCHAR(100),
    	street_number VARCHAR(100),
    	city VARCHAR(100),
    	country VARCHAR(100),
    	postal_code VARCHAR(6),
    	SIN VARCHAR(100),
    	vehicle_year INT, 
    	vehicle_make VARCHAR(100), 
    	vehicle_color VARCHAR(100),
    	vehicle_license_plate VARCHAR(100),
    	vehicle_insurance_number VARCHAR(100),
    	vehicle_insurance_expiry VARCHAR(7),
    	payment_frequency VARCHAR(20) NOT NULL,
    	direct_deposit VARCHAR(23) NOT NULL,
    	current_availability VARCHAR(20) NOT NULL DEFAULT "not available",
    	current_location_GPS VARCHAR(100) DEFAULT NULL,
    	current_delivery_method VARCHAR(100) DEFAULT NULL,
    	PRIMARY KEY (courier_id)
);

CREATE TABLE vendors (
	vendor_id INT NOT NULL AUTO_INCREMENT,
    	vendor_type VARCHAR(100) NOT NULL,
    	username VARCHAR(50) NOT NULL,
    	email VARCHAR(100) NOT NULL,
    	password VARCHAR(50) NOT NULL,
    	phone_number VARCHAR(15) NOT NULL,
    	device_id INT,
    	vendor_name VARCHAR(100) NOT NULL,
    	start_time TIME,
    	end_time TIME,
    	street_number VARCHAR(100),
    	city VARCHAR(100),
    	country VARCHAR(100),
    	postal_code VARCHAR(6),
    	borough_id INT NOT NULL,
    	PRIMARY KEY (vendor_id)
);

CREATE TABLE vendor_items (
	item_id INT NOT NULL AUTO_INCREMENT,
    	item_name VARCHAR(100) NOT NULL,
    	item_section VARCHAR(100) NOT NULL,
    	item_description TEXT,
    	price DECIMAL(5,2) NOT NULL,
    	discount DECIMAL(3,2) NOT NULL,
    	availability_status BOOLEAN NOT NULL DEFAULT FALSE,
    	avl_start_time TIME,
    	avl_end_time TIME,
    	allergy_info BOOLEAN NOT NULL DEFAULT FALSE,
    	gluten_free BOOLEAN NOT NULL DEFAULT FALSE,
    	calories INT NOT NULL DEFAULT 0,
    	vendor_id INT NOT NULL,
    	PRIMARY KEY (item_id),
    	FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);
 
CREATE TABLE cuisine (
    cuisine_id INT NOT NULL AUTO_INCREMENT,
    cuisine_name  VARCHAR(100),
    PRIMARY KEY (cuisine_id)
);
 
CREATE TABLE vendor_cuisine (
    vendor_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    PRIMARY KEY (vendor_id, cuisine_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (cuisine_id) REFERENCES cuisine(cuisine_id)
);
 
CREATE TABLE licenses (
    license_id INT NOT NULL AUTO_INCREMENT,
    license_name VARCHAR(100),
    PRIMARY KEY (license_id)
);
 
CREATE TABLE vendor_licenses (
    vendor_id INT NOT NULL,
    license_id INT NOT NULL,
    PRIMARY KEY (vendor_id, license_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (license_id) REFERENCES licenses(license_id)
);
 
CREATE TABLE placed_orders (
	order_id INT NOT NULL AUTO_INCREMENT,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fee_base_price DECIMAL(10,2) NOT NULL,
    fee_cut_from_vendor DECIMAL(10,2) NOT NULL,
    fee_service_fee DECIMAL(10,2) NOT NULL,
    fee_delivery_fee DECIMAL(10,2) NOT NULL,
    fee_tips DECIMAL(10,2) NOT NULL,
    fee_tax DECIMAL(10,2) NOT NULL,
    special_instructions TEXT,
    status VARCHAR(50) NOT NULL,
    delivery_street_number VARCHAR(50),
    delivery_city VARCHAR(50),
    delivery_country VARCHAR(50),
    delivery_postal_code VARCHAR(50),
    delivery_borough_id INT,
    delivery_method VARCHAR(50),
    payment_reference VARCHAR(100),
    chat_history VARCHAR(100),
    customer_id INT,
    courier_id INT,
    PRIMARY KEY (order_id),
    FOREIGN KEY (delivery_borough_id) REFERENCES borough(borough_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (courier_id) REFERENCES couriers(courier_id)
);
 
 
CREATE TABLE order_item (
    unit_ordered INT NOT NULL,
    unit_price DECIMAL(5,2),
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES placed_orders(order_id),
    FOREIGN KEY (item_id) REFERENCES vendor_items(item_id)
);


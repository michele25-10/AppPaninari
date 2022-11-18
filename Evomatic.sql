CREATE DATABASE sandwiches;
USE sandwiches;

CREATE TABLE account(
ID INT AUTO_INCREMENT PRIMARY KEY,
name NVARCHAR(32) NOT NULL,
surname NVARCHAR(32) NOT NULL,
email NVARCHAR(64) NOT NULL,
password NVARCHAR(32) NOT NULL,
active BIT DEFAULT 1
);

CREATE TABLE cart(
ID INT AUTO_INCREMENT PRIMARY KEY,
user_ID INT NOT NULL,
total_price DECIMAL NOT NULL,
CHECK (total_price > 0),
FOREIGN KEY (user_ID) REFERENCES account(ID)
);

CREATE TABLE status(
ID INT AUTO_INCREMENT PRIMARY KEY,
description NVARCHAR(16) NOT NULL
);

CREATE TABLE break(
ID INT AUTO_INCREMENT PRIMARY KEY,
break_time TIME NOT NULL
);

CREATE TABLE pickup_point(
ID INT AUTO_INCREMENT PRIMARY KEY,
description NVARCHAR(64) NOT NULL
);

CREATE TABLE order0(
ID INT AUTO_INCREMENT PRIMARY KEY,
user_ID INT NOT NULL,
total_price DECIMAL NOT NULL,
date_hour_sale DATETIME NOT NULL,
break_ID INT NOT NULL,
status_ID INT NOT NULL,
pickup_ID INT NOT NULL,
json LONGTEXT,
CHECK (total_price > 0),
FOREIGN KEY (user_ID) REFERENCES account(ID),
FOREIGN KEY (break_ID) REFERENCES break(ID),
FOREIGN KEY (status_ID) REFERENCES status(ID),
FOREIGN KEY (pickup_ID) REFERENCES pickup_point(ID)
);

CREATE TABLE catalogue(
ID INT AUTO_INCREMENT PRIMARY KEY,
catalogue_name NVARCHAR(30) NOT NULL,
validity_start_date DATE NOT NULL,
validity_end_date DATE NOT NULL,
CHECK (validity_start_date < validity_end_date)
);

CREATE TABLE category(
ID INT AUTO_INCREMENT PRIMARY KEY,
name NVARCHAR(16) NOT NULL,
iva_tax DECIMAL NOT NULL,
CHECK (iva_tax > 0)
);

CREATE TABLE special_offer(
ID INT AUTO_INCREMENT PRIMARY KEY,
title NVARCHAR(16) NOT NULL,
description NVARCHAR(64),
offer_code NVARCHAR(8) NOT NULL,
validity_start_date DATE NOT NULL,
validity_end_date DATE NOT NULL,
CHECK (validity_start_date < validity_end_date)
);

CREATE TABLE tag(
tag_ID INT AUTO_INCREMENT PRIMARY KEY,
tag NVARCHAR(32) NOT NULL
);

CREATE TABLE nutritional_value(
ID INT AUTO_INCREMENT PRIMARY KEY,
kcal INT NOT NULL,
fats DECIMAL NOT NULL,
saturated_fats DECIMAL,
carbohydrates DECIMAL NOT NULL,
sugars DECIMAL,
proteins DECIMAL NOT NULL,
salt DECIMAL,
fiber DECIMAL,
CHECK (kcal > 0),
CHECK (fats >= 0),
CHECK (carbohydrates >= 0),
CHECK (proteins >= 0)
);

CREATE TABLE product(
ID INT AUTO_INCREMENT PRIMARY KEY,
name NVARCHAR(32) NOT NULL,
price DECIMAL NOT NULL,
description NVARCHAR(128),
category_ID INT NOT NULL,
quantity INT NOT NULL,
nutritional_value_ID INT NOT NULL,
CHECK (price > 0),
CHECK (quantity > 0),
FOREIGN KEY (category_ID) REFERENCES category(ID),
FOREIGN KEY (nutritional_value_ID) REFERENCES nutritional_value(ID)
);

CREATE TABLE order_product(
order_ID INT,
product_ID INT,
quantity INT,
CHECK (quantity > 0),
FOREIGN KEY (order_ID) REFERENCES order0(ID),
FOREIGN KEY (product_ID) REFERENCES product(ID),
CONSTRAINT pk_order_product PRIMARY KEY (order_ID, product_ID)
);

CREATE TABLE cart_product(
cart_ID INT,
product_ID INT,
quantity INT,
CHECK (quantity > 0),
FOREIGN KEY (cart_ID) REFERENCES cart(ID),
FOREIGN KEY (product_ID) REFERENCES product(ID),
CONSTRAINT pk_cart_product PRIMARY KEY (cart_ID, product_ID)
);

CREATE TABLE product_tag(
product_ID INT,
tag_ID INT,
FOREIGN KEY (product_ID) REFERENCES product(ID),
FOREIGN KEY (tag_ID) REFERENCES tag(tag_ID),
CONSTRAINT pk_product_tag PRIMARY KEY (product_ID, tag_ID)
);

CREATE TABLE catalogue_product(
catalogue_ID INT,
product_ID INT,
FOREIGN KEY (catalogue_ID) REFERENCES catalogue(ID),
FOREIGN KEY (product_ID) REFERENCES product(ID),
CONSTRAINT pk_catalogue_product PRIMARY KEY (catalogue_ID, product_ID)
);

CREATE TABLE offer_category(
offer_ID INT,
category_ID INT,
FOREIGN KEY (offer_ID) REFERENCES special_offer(ID),
FOREIGN KEY (category_ID) REFERENCES category(ID),
CONSTRAINT pk_offer_category PRIMARY KEY (offer_ID, category_ID)
);
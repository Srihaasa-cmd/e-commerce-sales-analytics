CREATE TABLE customers 
(
customer_id INT PRIMARY KEY AUTO_INCREMENT,
customer_name VARCHAR(100),
customer_email VARCHAR(50),
customer_country VARCHAR(50),
sign_up_date DATETIME 
);

CREATE TABLE products 
(
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2)
); 

CREATE TABLE orders 
(
order_id INT PRIMARY KEY ,
customer_id INT ,
order_date DATETIME,
total_amount DECIMAL(10,2),
order_status VARCHAR(50) ,
FOREIGN KEY (customer_id)  REFERENCES customers(customer_id)
);

CREATE TABLE order_details
(
item_id INT PRIMARY KEY ,
order_id INT,
product_id INT,
quantity INT CHECK (quantity>0),
item_price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data into customers 
INSERT INTO customers (customer_id,customer_name, customer_email, customer_country, sign_up_date)
VALUES 
(101,'Alice Johnson', 'alice.johnson@example.com', 'USA', '2024-01-15 10:23:00'),
(102,'Brian Smith', 'brian.smith@example.com', 'Canada', '2024-02-20 14:45:00'),
(103,'Carlos Diaz', 'carlos.diaz@example.com', 'Mexico', '2024-03-05 09:10:00'),
(104,'Divya Patel', 'divya.patel@example.com', 'India', '2024-01-30 17:00:00'),
(105,'Eva Müller', 'eva.mueller@example.com', 'Germany', '2024-02-10 12:34:00'),
(106,'Faisal Khan', 'faisal.khan@example.com', 'UAE', '2024-03-12 08:50:00');

-- Insert sample data into products 
INSERT INTO products (product_id ,product_name, category, price)
VALUES
(1,'Wireless Mouse', 'Electronics', 19.99),
(2,'Bluetooth Speaker', 'Electronics', 49.99),
(3,'Yoga Mat', 'Fitness', 24.50),
(4,'Running Shoes', 'Footwear', 89.99),
(5,'Coffee Maker', 'Home Appliances', 59.90),
(6,'LED Desk Lamp', 'Home Decor', 29.95);

-- Insert sample data into orders
INSERT INTO orders (order_id, customer_id, order_date, total_amount, order_status)
VALUES
(1, 1, '2024-06-15 10:15:00', 129.98, 'Shipped'),
(2, 2, '2024-06-16 14:30:00', 59.90, 'Delivered'),
(3, 3, '2024-06-17 09:45:00', 89.99, 'Pending'),
(4, 1, '2024-06-18 11:00:00', 49.99, 'Cancelled'),
(5, 4, '2024-06-19 16:20:00', 24.50, 'Shipped'),
(6, 5, '2024-06-20 18:10:00', 29.95, 'Delivered');

-- Insert sample data into order_details
INSERT INTO order_details (item_id, order_id, product_id, quantity, item_price)
VALUES
(1, 1, 1, 2, 19.99),    -- 2 Wireless Mice
(2, 1, 2, 1, 49.99),    -- 1 Bluetooth Speaker
(3, 2, 3, 1, 89.99),    -- 1 Pair of Running Shoes
(4, 2, 4, 2, 24.50),    -- 2 Yoga Mats
(5, 3, 5, 1, 59.90),    -- 1 Coffee Maker
(6, 3, 6, 1, 29.95);    -- 1 LED Desk Lamp

-- Example SQL Queries:

-- Top 3 products by total revenue
SELECT p.product_name , SUM(od.quantity * od.item_price ) AS total_revenue FROM order_details od 
JOIN products p ON od.product_id = p .product_id 
GROUP BY product_name 
ORDER BY total_revenue DESC 
LIMIT 3; 

-- Monthly sales trend
SELECT DATE_FORMAT( o.order_date ,'%Y-%M') AS month , SUM(od.quantity * od.item_price ) AS total_sales FROM order_details od
JOIN  orders o ON od.order_id = o.order_id 
GROUP BY month
ORDER BY month;

-- Customer retention (customers who ordered more than once)
SELECT c.customer_id, COUNT( DISTINCT order_id ) AS total_sales FROM orders o
JOIN customers c ON o.customer_id = c.customer_id 
GROUP BY customer_id 
HAVING COUNT(DISTINCT order_id )>1 ;

-- Most valuable customer
SELECT c.customer_name, SUM(od.quantity * od.item_price) AS total_spent FROM customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

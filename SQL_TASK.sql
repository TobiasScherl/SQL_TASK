-- tables preparation which should be done before interview
-- Assignment in SQLLite. Recommended to go to https://sqliteonline.com/ and past following commands

CREATE TABLE customers (
    customer_id int,
    last_name varchar(50),
    first_name varchar(50),
referred_by_id varchar(50));
   
INSERT INTO customers (customer_id,first_name,last_name, referred_by_id)
VALUES (1,'John','White',''),
(2,'Sarah','Green',''),
        (3,'George','Black',''),
(4,'Mark','Koon',''),
(5,'Tom','Gone',''),
        (6,'Ezra','Beck',''),
(7,'Jan','Wick',2),
(8,'Petr','Lame',''),
        (9,'Lucy','Can',''),
(10,'Karl','Opel',1),
(11,'Ron','Varon',10),
        (12,'Harry','Bond',''),
(13,'Paul','Kong',''),
(14,'Shaun','King',3),
        (15,'Elisabeth','Yellow','');
       
CREATE TABLE contacts (
    customer_id int,
    address varchar(255),
    city varchar(255),
  phone_number varchar(20),
  email VARCHAR(255));
   
   
INSERT INTO contacts (customer_id,address,city,phone_number,email)
VALUES (1,'3525  Fort Street','COLUMBUS','2532326578','JW@email.com'),
(2,'3924  Cooks Mine Road','Albuquerque','5057657670','SarahG@email.com'),
        (3,'925  College Street','Atlanta','4043278560','Georgie@email.com');

CREATE TABLE orders (
    customer_id int,
    order_id INT,
    item varchar(50),
  order_value DECIMAL(12,2),
  order_currency varchar(3),
  order_date TIMESTAMP);
 
INSERT INTO orders (customer_id,order_id,item,order_value,order_currency,order_date)
VALUES(1,1,'HDMI cable',3.25,'EUR','2020-01-21 14:50:04'),
    (2,2,'Keyboard','15.99','EUR','2020-01-21 17:50:04'),
        (3,3,'Charger','9.99','EUR','2020-01-22 18:00:07'),
        (3,3,'Charger','9.99','EUR','2020-01-22 18:00:07'),
        (3,4,'Phone','225.89','EUR','2020-01-22 19:10:56'),
        (2,5,'Camera','199.99','EUR','2020-01-23 07:50:44'),
        (1,6,'Speakers','75.50','EUR','2020-01-23 08:40:00'),
        (1,6,'Speakers','75.50','EUR','2020-01-23 08:40:00'),
        (2,7,'Mouse','22.19','EUR','2020-01-23 09:20:59');    
   
--TASK 1--
--Write query which will show our customers with contacts and orders (all columns)

select * from customers
FULL OUTER JOIN contacts
on customers.customer_id = contacts.customer_id
FULL OUTER JOIN orders
on customers.customer_id = orders.customer_id;

--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders. If so, return unique duplicates with the following details:
-- first name, last name, email, order id and item

select first_name, last_name, email, order_id, item from customers
FULL OUTER JOIN contacts
on customers.customer_id = contacts.customer_id
FULL OUTER JOIN orders
on customers.customer_id = orders.customer_id
group by first_name, last_name, email, order_id, item
having COUNT(order_id) > 1;

--TASK 3-
-- As you found out, there are some duplicated order which are incorrect, adjust query so it does following:
-- Show first name, last name, email, order id and item
-- Does not show duplicates
-- Order result by customer last name

select  distinct order_id, first_name, last_name, email, item  from customers
FULL OUTER JOIN contacts
on customers.customer_id = contacts.customer_id
FULL OUTER JOIN orders
on customers.customer_id = orders.customer_id
where order_id IS NOT NULL
order by last_name;

--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown
--Sort by order ID (ascending)

SELECT distinct order_id, (first_name || ' ' || last_name) as full_name,
CASE
    WHEN order_value <= 25 THEN 'SMALL'
    WHEN order_value > 25 AND order_value <= 100 THEN 'MEDIUM'
    ELSE 'BIG'
END AS order_size
from customers
INNER JOIN orders
on customers.customer_id = orders.customer_id
where order_id IS NOT NULL
order by order_id asc;

--TASK 5--
-- Show all items from orders table which containt in their name 'ea' or start with 'Key'

select item
from orders
where item like 'Key%'
or item like '%ea%';


--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format "Customer Last name Customer First name" "Last name First name of customer who recomended the new customer"
-- Sort/Order by customer last name (ascending)

select a.last_name as customer_lastname, a.first_name as customer_firstname, b.last_name as ref_lastname, b.first_name as ref_firstname from customers a
join customers b
on a.customer_id = b.referred_by_id
order by a.last_name;

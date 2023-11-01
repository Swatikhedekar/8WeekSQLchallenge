#  Danny dinner 1 sql challenge
create database danny_dinner;
use danny_dinner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER);
  
  INSERT INTO sales
  (customer_id, order_date,product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
 CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER);
  
  INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
drop table members;
select * from sales;
select * from menu;
select * from members;


  
  /* --------------------
   Case Study Questions
   --------------------*/
-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id as Customer,sum(m.price) as Total_amount_spent
from sales s JOIN menu m 
on m.product_id = s.product_id
group by 1;

-- 2. How many days has each customer visited the restaurant?
select customer_id as Customer, count(distinct order_date) as day_visited from sales group by 1 ;

-- 3. What was the first item from the menu purchased by each customer?
select s.customer_id as Customer, m.product_name as first_item_purchsed 
from sales s join menu m
on s.product_id = m.product_id group by 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select m.product_name, count(*) as most_purchased_item from sales s 
join menu m on s.product_id = m.product_id  
group by 1
order by 2 desc limit 1;

# for each item how many time purchased
select m.product_name, count(*) as most_purchased_item
from sales s join menu m 
on s.product_id = m.product_id  group by 1;

-- 5. Which item was the most popular for each customer?
select s.customer_id as customer, m.product_name as most_popular_item,count(*) as total_item
from sales s join menu m 
on s.product_id = m.product_id group by 1;

-- 6. Which item was purchased first by the customer after they became a member?
select s.customer_id as customer,m.product_name as item_purchased_first,m1.join_date,s.order_date from sales s
join menu m on s.product_id = m.product_id 
join members m1 on s.customer_id = m1.customer_id 
where s.order_date = m1.join_date or s.order_date > m1.join_date
group by 1
order by 2 ;

-- 7. Which item was purchased just before the customer became a member?
select s.customer_id as customer,m.product_name as item_purchased_before_member,m1.join_date,
s.order_date from sales s
join menu m on s.product_id = m.product_id 
join members m1 on s.customer_id = m1.customer_id 
where s.order_date = m1.join_date or s.order_date < m1.join_date
group by 1
order by 1 ;

-- 8. What is the total items and amount spent for each member before they became a member?
select s.customer_id as customer,count(*) as total_item,
sum(m.price) as Total_amount_spent,m1.join_date,s.order_date from sales s
join menu m on s.product_id = m.product_id 
join members m1 on s.customer_id = m1.customer_id 
where s.order_date = m1.join_date or s.order_date > m1.join_date
group by 1
order by 1 ;

/* 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
 how many points would each customer have ?*/
select sub.customer,sum(points) as Total_points
from
(select s.customer_id as customer,
case 
when m.product_name ='sushi' then 2*10*m.price
else 10*m.price 
end as points
from sales s left join menu m on s.product_id = m.product_id) sub
group by 1;

/* 10. In the first week after a customer joins the program (including their join date) they earn
2x points on all items, not just sushi - how many points do customer A and B have at the end of January? */
 select s.customer_id ,
 sum(case 
	when s.order_date between m1.join_date and date_add(m1.join_date,interval 6 day)
	then m.price*2*10 when m.product_name = 'sushi' then m.price*2*10
	else m.price*10 
	end) as total_points from sales s 
 join menu m on m.product_id = s.product_id
 join members m1 on m1.customer_id =s.customer_id
 where date_format(s.order_date,'%Y-%m-01')='2021-01-01'
 group by 1 order by 1;
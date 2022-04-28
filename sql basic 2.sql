######################################################################################################################################################################################### EXAM DATA2

CREATE TABLE customers(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders(
	id INT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT 
);


####################################################################################################################################################################################### TABLE MODIFY
# 열 정보 수정 // 외래키 설정 추가 // 테이블 정보 열람

ALTER TABLE orders MODIFY id INT AUTO_INCREMENT;

ALTER TABLE orders ADD CONSTRAINT customer_id 
FOREIGN KEY (customer_id) REFERENCES customers (id);  # <- 제약식 'customer_id' 추가

ALTER TABLE orders DROP CONSTRAINT customer_id ;  # <- 제약식 'customer_id' 삭제

ALTER TABLE orders ADD CONSTRAINT customer_id 
FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE; # <- 제약식 'customer_id' cascade 까지 추가하여 다시 생성.
																	   # <- cascade : 부모 table에 삭제, 수정이 될 때 자식 까지 동시에 바뀜

desc orders;

INSERT INTO customers(first_name, last_name, email)
VALUES ('Boy', 'George', 'george@gmail.com'),
	   ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
	   ('Bette', 'Davis', 'bette@aol.com');


INSERT INTO orders(order_date, amount, customer_id)
VALUES ('2016/02/01', 99.99, 1),
	   ('2017/11/11', 35.50, 1),
       ('2014/12/12', 800.67, 2),
       ('2015/01/03', 12.50, 2),
       ('1999/04/11', 450.25, 5);

INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/06/06', 33.67, 98); # a foreign key constraint fails (`book_shop`.`orders`, CONSTRAINT `customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`))

INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/06/06', 33.67, 98);

############################################################################################################################################################################################### JOIN

# cross join

SELECT * FROM customers, orders; ## <== cross join 이 됨.

# implicit inner join - join 조건에 맞는 row만 출력되게 됨.

SELECT first_name, last_name, order_date, amount FROM customers, orders 
where customers.id = orders.customer_id ;

# explicit inner join - 명시적으로 join 문을 사용하여 조인.

SELECT first_name, last_name, order_date, amount 
FROM customers
JOIN orders
	ON customers.id = orders.customer_id ; 

# Left Join - 왼쪽에 있는 데이터를 기준으로 Join -> Left df 기준으로 Join할 데이터가 없으면 NUll 출력

SELECT * FROM customers, orders 
where customers.id = orders.customer_id ;

SELECT first_name, 
		last_name, 
        ifnull(sum(amount), 0) as total_spent  # <- ifnull 함수는 null값이면 다른값을 반환해 주는 함수.
FROM customers
LEFT JOIN orders
	ON customers.id = orders.customer_id 
group by customers.id
order by total_spent;

# cascade 활용 

delete from customers where email = 'george@gmail.com';

select * from customers; # id 1 이 삭제됨을 확인
select * from orders; # customer의 id 1 이 삭제 됨에 따라 자동으로 orders 의 customer_id 가 1인 데이터도 삭제


# Q1 students 가 부모 테이블 // papers가 자식 테이블이 되게 작성. 

CREATE TABLE students (
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100)
);

CREATE TABLE papers(
	title VARCHAR(100),
    grade VARCHAR(100),
    student_id INT, 
    FOREIGN KEY (student_id) REFERENCES students(id)
);

ALTER TABLE papers ADD CONSTRAINT student_id
FOREIGN KEY (student_id) references students(id) on delete cascade;   # <- on delete cascade 제약을 추가

ALTER TABLE papers drop constraint papers_ibfk_1 ;  # <- 테이블을 생성할 때 생긴 제약 삭제

select * from information_schema.table_constraints
where table_schema = 'book_shop' and table_name = 'papers' ; # <- 테이블 제약 조건 확인

INSERT INTO students(first_name) 
VALUES ('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers(student_id, title, grade)
VALUES (1, 'My First Book Report', 60),
	   (1, 'My Second Book Report', 75),
       (2, 'Russian Lit Through The Ages', 94),
       (2, 'De Montaigne and The Art of The Essay', 98),
       (4, 'Borges and Magical Realism', 89);

select * from papers;

select first_name, title, grade 
from students, papers
where students.id = papers.student_id 
order by first_name desc, grade desc;

select first_name, 
	   ifnull(title, 'MISSING') AS title, 
       IFNULL(grade, 0) as grade
from students
left join papers 
	on students.id = papers.student_id ;

select first_name,
	   ifnull(avg(grade), 0) as average,
       case
	       when avg(grade) >= 80 then 'PASSING' 
           else 'FAILING'
	   end as passing_status
from students
left join papers
	on students.id = papers.student_id
group by first_name
order by average desc;





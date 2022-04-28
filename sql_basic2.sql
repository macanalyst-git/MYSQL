############################################################################################################################################################ EXAM DATA2

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


#####################################################################################################################################$#################### TABLE MODIFY
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
VALUES ('2016/06/06', 33.67, 98); # a foreign key constraint fails (`book_shop`.`orders`, CONSTRAINT `customer_id` FOREIGN KEY (`customer_id`) 
				  #				    REFERENCES `customers` (`id`))

INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/06/06', 33.67, 98);

################################################################################################################################################################## JOIN

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


# exam 1. students 가 부모 테이블 // papers가 자식 테이블이 되게 작성. 

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


# exam 2. 모든 학생들의 시험통과 여부(passing_status)를 출력하라. (80점 이상 통과)

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

############################################################################################################################################################ exam data3

CREATE TABLE reviewers (
	id INT auto_increment PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

CREATE TABLE series(
	id INT AUTO_INCREMENT pRIMARY KEY,
    title VARCHAR(100),
    released_year YEAR,
    genre VARCHAR(100)
);

INSERT INTO series (title, released_year, genre)
VALUES ('Archer', 2009, 'Animation'),
	   ('Arrested Development', 2003, 'Comedy'),
       ("Bob's Burgers", 2011, 'Animation'),
       ("Bojack Horseman", 2014, 'Animation'),
       ("Breaking Bad", 2008, 'Drama'),
       ("Curb Your Enthusiasm", 2000, 'Comedy'),
       ("Fargo", 2014, 'Drama'),
       ("Freaks and Geeks", 1999, 'Comedy'),
       ("General Hospital", 1963, 'Drama'),
       ("Halt and Catch Fire", 2014, 'Drama'),
       ('Malcolm In The Middle', 2000, 'Comedy'),
       ('Pushing Daisies', 2007, 'Comedy'),
       ('Seinfeld', 1989, 'Comedy'),
       ('Stranger Things', 2016, 'Drama');

INSERT INTO reviewers (first_name, last_name) 
VALUES ('Thomas', 'Stoneman'),
	   ('Wyatt', 'Skaggs'),
       ('Kimbra', 'Masters'),
       ('Domingo', 'Cortes'),
       ('Colt', 'Steele'),
       ('Pinkie', 'Petit'),
       ('Marlon', 'Crafford');



CREATE TABLE reviews(
	id INT AUTO_INCREMENT PRIMARY KEY,
    rating DECIMAL(2,1),
    series_id INT,  
    reviewer_id INT,
    FOREIGN KEY (series_id) REFERENCES series (id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES reviewers(id) ON DELETE CASCADE
);

SELECT * FROM series;


INSERT INTO reviews(series_id, reviewer_id, rating)
VALUES (1,1,8.0), (1,2,7.5), (1,3,8.5), (1,4,7.7), (1,5,8.9),
	   (2,1,8.1), (2,4,6.0), (2,3,8.0), (2,6,8.4), (2,5,9.9),
       (3,1,7.0), (3,6,7.5), (3,4,8.0), (3,3,7.1), (3,5,8.0),
       (4,1,7.5), (4,3,7.8), (4,4,8.3), (4,2,7.6), (4,5,8.5),
       (5,1,9.5), (5,3,9.0), (5,4,9.1), (5,2,9.3), (5,5,9.9),
       (6,2,6.5), (6,3,7.8), (6,4,8.8), (6,2,8.4), (6,5,9.1),
       (7,2,9.1), (7,5,9.7),
       (8,4,8.5), (8,2,7.8), (8,6,8.8), (8,5,9.3),
       (9,2,5.5), (9,3,6.8), (9,4,5.8), (9,6,4.3), (9,5, 4.5),
       (10,5,9.9),
       (13,3,8.0), (13,4,7.2),
       (14,2,8.5), (14,3,8.9), (14,4,8.9);
       
############################################################################################################################################## MANY : MANY RELATIONSHIP

# exam 3. 상영물의 평점을 출력하라.
SELECT title, avg(rating) as avg_rating FROM reviews
JOIN series
	ON reviews.series_id = series.id
GROUP BY title
ORDER BY avg_rating ;

# exam 4. 리뷰가 없는 상영물을 출력하라.

SELECT title as unreviewed_series
FROM series as a
LEFT JOIN reviews as b
	ON a.id = b.series_id 
WHERE rating IS NULL ; 

# exam 5. 리뷰어들의 리뷰횟수, 최저점, 최고점, 평점, 활동여부를 출력하라.
SELECT first_name,
       last_name,
       count(rating) as COUNT,
       ifnull(round(min(rating), 1), 0) as MIN,
       ifnull(round(max(rating), 1), 0) as MAX,
       ifnull(avg(rating), 0) as AVG,
       IF(count(rating) >= 1, 'ACTIVE', 'INACTIVE') as STATUS  
FROM reviewers as a
LEFT JOIN reviews as b
	ON 	a.id = b.reviewer_id 
GROUP BY first_name, last_name ;





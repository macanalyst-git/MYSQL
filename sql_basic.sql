############################################################################################################################################################ book data

CREATE DATABASE book_shop;
USE book_shop;
CREATE TABLE books 
	(
		book_id INT NOT NULL AUTO_INCREMENT,
		title VARCHAR(100),
		author_fname VARCHAR(100),
		author_lname VARCHAR(100),
		released_year INT,
		stock_quantity INT,
		pages INT,
		PRIMARY KEY(book_id)
	);

INSERT INTO books (title, author_fname, author_lname, released_year, stock_quantity, pages)
VALUES
('The Namesake', 'Jhumpa', 'Lahiri', 2003, 32, 291),
('Norse Mytholbooksbooksogy', 'Neil', 'Gaiman',2016, 43, 304),
('American Gods', 'Neil', 'Gaiman', 2001, 12, 465),
('Interpreter of Maladies', 'Jhumpa', 'Lahiri', 1996, 97, 198),
('A Hologram for the King: A Novel', 'Dave', 'Eggers', 2012, 154, 352),
('The Circle', 'Dave', 'Eggers', 2013, 26, 504),
('The Amazing Adventures of Kavalier & Clay', 'Michael', 'Chabon', 2000, 68, 634),
('Just Kids', 'Patti', 'Smith', 2010, 55, 304),
('A Heartbreaking Work of Staggering Genius', 'Dave', 'Eggers', 2001, 104, 437),
('Coraline', 'Neil', 'Gaiman', 2003, 100, 208),
('What We Talk About When We Talk About Love: Stories', 'Raymond', 'Carver', 1981, 23, 176),
("Where I'm Calling From: Selected Stories", 'Raymond', 'Carver', 1989, 12, 526),
('White Noise', 'Don', 'DeLillo', 1985, 49, 320),
('Cannery Row', 'John', 'Steinbeck', 1945, 95, 181),
('Oblivion: Stories', 'David', 'Foster Wallace', 2004, 172, 329),
('Consider the Lobster', 'David', 'Foster Wallace', 2005, 92, 343);

INSERT INTO books(title, author_fname, author_lname, released_year, stock_quantity, pages)
VALUES ('10% Happier', 'Dan', 'Harris', 2014, 29, 256),
       ('fake_book', 'Freida', 'Harris', 2001, 287, 428),
       ('Lincoln In The Bardo', 'George', 'Saunders', 2017, 1000, 367);
       
########################################################################################################################################### multi string function exam 
-- exam 1. title 맨 앞 글자가 'A'이면서 stock_quantity가 150 미만인 데이터 조회

SELECT CONCAT(SUBSTR(title, 1, 10), '...') as 'short title',
       CONCAT(author_lname, ',', author_fname) as 'author',
       CONCAT(stock_quantity, ' in stock') as 'quantity'
FROM books
WHERE SUBSTR(title, 1,1) = 'A'
AND stock_quantity < 150;

############################################################################################################################################## refining selection exam
-- exam 2. 'MY FAVORITE AUTHOR IS #author_fname #author_lname !' 출력
SELECT UPPER(CONCAT('my favorite author is ', author_fname, ' ', author_lname, '!')) as yell 
FROM books
ORDER BY author_lname ;

################################################################################################################################################## aggregeate function
-- exam3. 가장 긴 책을 쓴 작가 출력
SELECT CONCAT(author_fname, ' ', author_lname) AS 'author name',
	   pages
FROM books 
ORDER BY pages DESC LIMIT 1;

-- exam4. 연도별 출판된 책의 개수와 책들의 평균 페이지를 구하라
SELECT released_year as year,
       count(*) as '# books',
	   avg(pages) as 'avg pages'
FROM books
GROUP BY released_year
ORDER BY released_year;

-- exam5. 타이틀이 가장 긴 책은 무엇인지 구하라
SELECT title, char_length(title) FROM books
ORDER BY char_length(title) DESC LIMIT 1;

-- exam6. 작가별 첫 작품을 출판 후 지난 년 수를 구하라.
SELECT author_fname, author_lname, 
	   released_year, year(now()) - min(released_year) as 'ago_year' FROM books
GROUP BY author_fname, author_lname;

##################################################################################################################################################### Logical operators

-- exam7. 홀수년도에 출판된 책만 출력하라.
SELECT * FROM books
WHERE released_year >= 2000 AND released_year % 2 != 0 ;  

-- exam8. 작가 성이 C or S 로 시작하는 책만 출력하라.
SELECT * FROM books
WHERE author_lname REGEXP ('^C|^S');

####################################################################################################################################################### CASE STATEMENTS

-- exam9. GENRE - 출판년도가 2000 이상은 Modern Lit 미만은 20th Century Lit
--        STOCK - 재고량이 50 이하는 * 100이하는 ** 100 초과는 *** 인 컬럼을 생성해서 출력하라. 

select title, released_year, stock_quantity, 
	case 
		when released_year >= 2000 then 'Modern Lit' 
        	else '20th Century Lit' 
	end as 'GENRE' ,
    	case 
		when stock_quantity <= 50 then '*'
        	when stock_quantity <= 100 then '**'
        	else '***'
        end as 'STOCK'
from books ; 


-- exam10. title 에 'stories' 가 있으면 'Short Stories', 'Kids' or 'A Heartbreaking Work' 가 있으면 'Memoir' 나머지는 'Novel'

SELECT title, author_lname,
	CASE 
		WHEN title regexp('stories+') THEN 'Short Stories'
        WHEN title regexp('Kids+|A Heartbreaking Work+') THEN 'Memoir'
        ELSE 'Novel'
	END as 'TYPE'
FROM books ;


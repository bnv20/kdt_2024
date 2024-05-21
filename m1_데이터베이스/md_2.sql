SELECT * FROM book;
SELECT bookid, price FROM book;

SELECT * FROM customer;
SELECT * FROM orders;
SELECT * FROM imported_book;

--중복없이 출력
SELECT DISTINCT publisher FROM book;

--Q. 가격이 10,000원 이상인 도서를 검색
SELECT * FROM book
WHERE price > 10000;

--Q. 가격이 10,000원 이상 20,000 이하인 도서를 검색하시오.(2가지 방법)
SELECT * FROM book
WHERE price >=10000 AND price <=20000;

SELECT * FROM book
WHERE price BETWEEN 10000 AND 20000;






--Task1_0517. 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’ 인 도서를 검색하시오.(3가지 방법)
SELECT * FROM book
WHERE (publisher='굿스포츠') OR (publisher='대한미디어');

SELECT *
FROM book
WHERE publisher IN ('굿스포츠', '대한미디어');

SELECT *
FROM book
WHERE  publisher = '굿스포츠'
UNION 
SELECT *
FROM book
WHERE  publisher = '대한미디어';

--Task2_0517. 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’ 가 아닌 도서를 검색
select * from book where publisher not in ('굿스포츠','대한미디어');

--LIKE는 정확히 '축구의 역사'와 일치하는 행만 선택
SELECT bookname, publisher FROM book
WHERE bookname LIKE '축구의 역사';

--%: 0개 이상의 임의의 문자
--_: 정확히 1개의 임의의 문자
--‘축구’ 가 포함된 출판사
SELECT bookname, publisher, price FROM book
WHERE bookname LIKE '%축구%';

--도서이름의 왼쪽 두 번째 위치에 ‘구’라는 문자열을 갖는 도서
SELECT bookname, publisher FROM book
WHERE bookname LIKE '_구%';

--Task3_0517. 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하시오.
SELECT * FROM book
WHERE bookname LIKE '%축구%' and price >= 20000;

--ORDER BY : 올림차순 정렬(default)
SELECT * FROM book
ORDER BY price;

--내림차순
SELECT * FROM book
ORDER BY price DESC;

--Q. 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 검색하시오
SELECT * FROM book
ORDER BY price, bookname;

SELECT * FROM orders;
SELECT SUM(saleprice) AS "총 판매액"
FROM orders
WHERE custid = 2;

--GROUP BY : 데이터를 특정 기준에 따라 그룹화하는데 사용. 이를 통해 집계 함수(SUM, AVG, MAX, MIN, COUNT)를 이용, 계산
SELECT SUM(saleprice) AS total,
AVG(saleprice) AS average,
MIN(saleprice) AS mininum,
MAX(saleprice) AS maximum
FROM orders;

--총판매액을 custid 기준으로 그룹화
SELECT custid, COUNT(*) AS 도서수량, SUM(saleprice) AS "총 판매액"
FROM orders
GROUP BY custid;

--bookid가 5보다 큰 조건
SELECT custid, COUNT(*) AS 도서수량, SUM(saleprice) AS "총 판매액"
FROM orders
WHERE bookid > 5
GROUP BY custid;

--도서수량이 2보다 큰 조건
SELECT custid, COUNT(*) AS 도서수량, SUM(saleprice) AS "총 판매액"
FROM orders
WHERE bookid > 5
GROUP BY custid
HAVING COUNT(*) > 2;

select * from orders;
--Task4_0517. 2번 김연아 고객이 주문한 도서의 수량과 총 판매액을 구하시오.
select customer.name, orders.custid, count(orders.orderid) AS "도서 수량", sum(orders.saleprice) AS "총 판매액"
from orders, customer
where orders.custid = 2 and orders.custid=customer.custid
group by customer.name, orders.custid;

select customer.name, orders.custid, count(orders.orderid) "도서 수량", sum(orders.saleprice) "총 판매액"
from orders
inner join customer on orders.custid = customer.custid
where orders.custid = 2
group by customer.name, orders.custid;

--Task5_0517. 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 
--단, 두 권 이상 구매한 고객만 구하시오.
SELECT custid, COUNT(*) AS 도서수량
FROM orders
WHERE saleprice >= 8000
GROUP BY custid
HAVING COUNT(*) >= 2
ORDER BY custid;

--Task6_0517. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오.
SELECT name, saleprice
FROM customer, orders
WHERE customer.custid=orders.custid;

--Task7_0517. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오.
SELECT custid, SUM(saleprice) "총 판매액"
FROM orders
GROUP BY custid
ORDER BY custid;

SELECT name, SUM (saleprice) AS "총 판매액"
FROM customer C, orders O
WHERE C.custid = O.custid
GROUP BY C.name
ORDER BY C.name;

--Q. 고객의 이름과 고객이 주문한 도서의 이름을 구하시오.

SELECT C.name, B.bookname
FROM customer C, book B, orders O
WHERE C.custid=O.custid AND O.bookid = B.bookid;

SELECT customer.name, book.bookname
FROM orders
INNER JOIN customer ON orders.custid = customer.custid
INNER JOIN book ON orders.bookid = book.bookid;

--Q. 가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오.
SELECT C.name, B.bookname
FROM book B, customer C, orders O
WHERE C.custid = O.custid AND O.bookid=B.bookid AND B.price = 20000; 

SELECT 
(SELECT NAME FROM customer where custid = x.custid) "고객명",
(SELECT BOOKNAME FROM book where bookid = x.bookid) "책이름",
(SELECT PRICE FROM book where bookid = x.bookid) "책판매가",
x.saleprice "구입가격",
x.orderdate "구입날짜"
FROM orders x
WHERE bookid IN (SELECT BOOKID FROM BOOK WHERE price = 20000)
ORDER BY custid;

select * from customer;
select * from orders;
--JOIN은 두 개 이상의 테이블을 연결하여 관련된 데이터를 결합할 때 사용
--내부 조인 (Inner Join)
SELECT customer.name,orders.saleprice
FROM customer 
INNER JOIN orders ON customer.custid=orders.custid;

--왼쪽 외부 조인 (Left Outer Join) : . 두 번째 테이블에 일치하는 데이터가 없는 경우 NULL 값이 사용
SELECT customer.name,orders.saleprice
FROM customer 
LEFT OUTER JOIN orders ON customer.custid=orders.custid;

--오른쪽 외부 조인 (Right Outer Join) : 첫 번째 테이블에 일치하는 데이터가 없는 경우 NULL 값이 사용
SELECT customer.name,orders.saleprice
FROM customer 
RIGHT OUTER JOIN 
orders ON customer.custid=orders.custid;

--FULL OUTER JOIN : 일치하는 데이터가 없는 경우 해당 테이블에서는 NULL 값이 사용
SELECT customer.name,orders.saleprice
FROM customer 
FULL OUTER JOIN orders ON customer.custid=orders.custid;

--CROSS JOIN : 두 테이블 간의 모든 가능한 조합을 생성
SELECT customer.name,orders.saleprice
FROM customer 
CROSS JOIN orders;

--Q. 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하시오.(2가지 방법, WHERE, JOIN)

SELECT C.name, O.saleprice
FROM customer C, orders O
WHERE C.custid = O.custid(+);

SELECT customer.name,orders.saleprice
FROM customer LEFT OUTER JOIN orders ON customer.custid=orders.custid;

--부속 질의
SELECT * FROM customer;
SELECT CUSTID FROM orders;
--Q. 도서를 구매한 적이 있는 고객의 이름을 검색하시오.
SELECT name
FROM customer
WHERE custid IN (SELECT custid FROM orders);

--Q. ‘대한미디어’에서 출판한 도서를 구매한 고객의 이름을 보이시오.
SELECT name
FROM customer
WHERE custid IN (SELECT custid FROM orders
WHERE bookid IN (SELECT bookid FROM book
WHERE publisher = '대한미디어'));

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
SELECT b1.bookname
FROM book b1
WHERE b1.price > (SELECT avg(b2.price)
FROM book b2
WHERE b2.publisher = b1.publisher);

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.
SELECT name
FROM customer
WHERE custid NOT IN (SELECT custid FROM orders);

--Q. 주문이 있는 고객의 이름과 주소를 보이시오.
SELECT name "고객 이름", address "고객 주소"
FROM customer
WHERE custid IN (SELECT custid FROM orders);

--DML 연습
--Task2_0520. Customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경하시오.
select * from customer;
UPDATE customer
SET address = (
    SELECT address
    FROM customer
    WHERE name = '김연아'
)
WHERE name = '박세리';

--확인
select * from customer;

--다시 부산으로 변경
update customer
set address = '대한민국 부산'
where name ='박세리';

--절대값
SELECT ABS(-78), ABS(+78)
FROM dual;

--반올림
SELECT ROUND(4.875, 1)
FROM dual;
 
--Q. 고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하시오.
SELECT * FROM orders;
SELECT custid AS 고객번호, ROUND(AVG(saleprice), -2) AS 평균주문금액
FROM orders
GROUP BY custid;

--Task3_0520.도서 제목에 ‘야구’가 포함된 도서를 ‘농구’로 변경한 후 도서 목록, 가격을 보이시오.
SELECT bookid, REPLACE(bookname, '야구','농구') bookname, publisher, price
FROM book;

--Q.‘굿스포츠’에서 출판한 도서의 제목과 제목의 글자 수, 바이트 수를 보이시오.
SELECT bookname 제목, length(bookname) 글자수, lengthb(bookname) 바이트수
FROM book
WHERE publisher = '굿스포츠';

--Task4_0520. 마당서점의 고객 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.
--substr(name, 1, 1) 함수는 문자열 name의 첫 번째 글자부터 시작하여 한 글자를 반환
--GROUP BY 절에서는 별칭이 아닌 substr(name,1,1) 표현식을 사용해야 함
select * from customer;
select substr(name,1,1) 성, count(*) 인원
from customer
group by substr(name,1,1);

--Task5_0520. 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.
select * from orders;
SELECT orderid, orderdate AS 주문일, orderdate + 62 AS 확정일자
FROM orders;

--Q. 마당서점은 주문일로부터 2개월 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.
SELECT orderid, orderdate AS 주문일, ADD_MONTHS(orderdate, 2) AS 확정일자
FROM orders;

--Task6_0520. 마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오. 
--단 주문일은 ‘yyyy-mm-dd 요일’ 형태로 표시한다.
SELECT orderid 주문번호, orderdate, TO_CHAR(orderdate, 'YYYY-mm-dd day') 주문일, custid 고객번호, bookid 도서번호
FROM orders
WHERE orderdate = '2020-07-07';
--WHERE orderdate = TO_DATE('20/07/07', 'YY/MM/DD');
--WHERE orderdate = TO_DATE('20/07/24', 'DD/MM/YY');
desc orders;

--Task7_0520. 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오.
select orderid, saleprice
from orders
where saleprice < (select avg(saleprice) from orders);

SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
WHERE O1.SALEPRICE < (SELECT AVG(O2.SALEPRICE)
FROM ORDERS O2);

--서브쿼리를 o2라는 별칭으로 지정, saleprice의 평균 값을 avg_saleprice로 계산
SELECT o1.orderid, o1.saleprice
FROM orders o1
JOIN (SELECT AVG(saleprice) AS avg_saleprice FROM orders) o2 
ON o1.saleprice < o2.avg_saleprice;

--Task8_0520. 대한민국’에 거주하는 고객에게 판매한 도서의 총 판매액을 구하시오.
SELECT SUM(saleprice) AS 총판매액
FROM orders
WHERE custid IN (SELECT custid FROM customer WHERE address LIKE '%대한민국%');

--데이터 타입
--숫자형 (Numeric Types)
--NUMBER: 가장 범용적인 숫자 데이터 타입. 정수, 실수, 고정 소수점, 부동 소수점 수를 저장
--NUMBER는 NUMBER(38,0)와 같은 의미로 해석, Precision 38은 자릿수, Scale 0은 소수점 이하 자릿수 
--NUMBER(10), NUMBER(8,2) 
--문자형 (Character Types)
--VARCHAR2(size): 가변 길이 문자열을 저장. size는 최대 문자 길이를 바이트, 혹은 글자수로 지정
--NVARCHAR2(size)의 사이즈를 지정할 때는 바이트 단위 대신 항상 문자 단위로 크기가 지정
--CHAR(size): 고정 길이 문자열을 저장. 지정된 길이보다 짧은 문자열이 입력되면 나머지는 공백으로 채워짐
--날짜 및 시간형 (Date and Time Types)
--DATE: 날짜와 시간을 저장. 데이터 타입은 년, 월, 일, 시, 분, 초를 포함
--DATE 타입은 날짜와 시간을 YYYY-MM-DD HH24:MI:SS 형식으로 저장합니다.
--예를 들어, 2024년 5월 20일 오후 3시 45분 30초는 2024-05-20 15:45:30으로 저장
--TIMESTAMP: 날짜와 시간을 더 상세히 나노초 단위까지 저장
--이진 데이터형 (Binary Data Types)
--BLOB: 대량의 이진 데이터를 저장. 이미지, 오디오 파일 등을 저장하는 데 적합
--대규모 객체형 (Large Object Types)
--CLOB: 대량의 문자 데이터를 저장
--NCLOB: 대량의 국가별 문자 집합 데이터를 저장

--문자 인코딩의 의미
--컴퓨터는 숫자로 이루어진 데이터를 처리. 인코딩을 통해 문자(예: 'A', '가', '?')를 
--숫자(코드 포인트)로 변환하여 컴퓨터가 이해하고 저장할 수 있게 한다.
--예를 들어, ASCII 인코딩에서는 대문자 'A'를 65로, 소문자 'a'를 97로 인코딩. 
--유니코드 인코딩에서는 'A'를 U+0041, 한글 '가'를 U+AC00, 이모티콘 '?'를 U+1F60A로 인코딩
--아스키는 7비트를 사용하여 총 128개의 문자를 표현하는 반면 유니코드는 최대 1,114,112개의 문자를 표현

--ASCII 인코딩:
--문자 'A' -> 65 (10진수) -> 01000001 (2진수)
--문자 'B' -> 66 (10진수) -> 01000010 (2진수)

--유니코드(UTF-8) 인코딩: 
--문자 'A' -> U+0041 -> 41 (16진수) -> 01000001 (2진수, ASCII와 동일)
--문자 '가' -> U+AC00 -> EC 95 80 (16진수) -> 11101100 10010101 10000000 (2진수)

--CLOB: CLOB은 일반적으로 데이터베이스의 기본 문자 집합(예: ASCII, LATIN1 등)을 사용하여 텍스트 데이터를 저장. 
--이 때문에 주로 영어와 같은 단일 바이트 문자로 이루어진 텍스트를 저장하는 데 사용.
--NCLOB: NCLOB은 유니코드(UTF-16)를 사용하여 텍스트 데이터를 저장. 따라서 다국어 지원이 필요할 때, \
--즉 다양한 언어로 구성된 텍스트 데이터를 저장할 때 적합. 다국어 문자가 포함된 데이터를 효율적으로 처리할 수 있다.

--VARCHAR2는 두 가지 방식으로 길이를 정의 : 바이트와 문자
--설정 확인 방법
SELECT *
FROM v$nls_parameters
WHERE parameter = 'NLS_LENGTH_SEMANTICS';

--제약조건 : 
--PRIMARY KEY : 각 행을 고유하게 식별하는 열(또는 열들의 조합). 중복되거나 NULL 값을 허용하지 않는다.
--FOREIGN KEY : 다른 테이블의 기본 키를 참조하는 열. 참조 무결성을 유지
--UNIQUE : 열에 중복된 값이 없어야 함을 지정. NULL값이 허용

--NOT NULL : 열에 NULL 값을 허용하지 않는다.
--CHECK : 열 값이 특정 조건을 만족해야 함을 지정 (예: age > 18)
--DEFAULT : 열에 명시적인 값이 제공되지 않을 경우 사용될 기본값을 지정

--AUTHOR 테이블 생성
CREATE TABLE authors (
  id NUMBER PRIMARY KEY,
  first_name VARCHAR2(50) NOT NULL,
  last_name VARCHAR2(50) NOT NULL,
  nationality VARCHAR2(50)
);
DROP TABLE authors;

--Q. NEWBOOK이라는 테이블을 생성하세요.
CREATE TABLE newbook (
    bookid NUMBER,
    isbn NUMBER(13),
    bookname VARCHAR2(50) NOT NULL,
    author VARCHAR2(50) NOT NULL,
    publisher VARCHAR2(30) NOT NULL,
    price NUMBER DEFAULT 10000 CHECK(price>1000),
    published_date DATE,
    PRIMARY KEY(bookid)
); 

INSERT INTO newbook VALUES (1, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, 
TO_DATE('2024-05-20', 'YYYY-MM-DD'));

SELECT * FROM newbook;
ALTER TABLE newbook MODIFY (isbn VARCHAR2(50));
DELETE FROM newbook;

INSERT INTO newbook VALUES (2, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, 
TO_DATE('2024-05-20 15:45:30', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO newbook VALUES (3, 9781234567890000023, 'SQL Guide', 'John Doe', 'TechBooks', 15000, 
TO_DATE('2024-05-20 15:45:30', 'YYYY-MM-DD HH24:MI:SS'));

DESC NEWBOOK;
--테이블 제약조건 수정, 추가, 속성 추가, 삭제, 수정
ALTER TABLE newbook MODIFY (isbn VARCHAR2(10));
ALTER TABLE newbook ADD author_id NUMBER;
ALTER TABLE newbook DROP COLUMN author_id;

--ON DELETE CASCADE 옵션이 설정되어 있어, newcustomer 테이블에서 어떤 고객의 레코드가 삭제되면, 해당 고객의 모든 주문이 
--neworders 테이블에서도 자동으로 삭제
CREATE TABLE newcustomer(
custid NUMBER PRIMARY KEY,
name VARCHAR2(40),
address VARCHAR2(40),
phone VARCHAR2(30));

CREATE TABLE neworders(
orderid NUMBER,
custid NUMBER NOT NULL,
bookid NUMBER NOT NULL,
saleprice NUMBER,
orderdate DATE,
PRIMARY KEY(orderid),
FOREIGN KEY(custid) REFERENCES newcustomer(custid) ON DELETE CASCADE
);

DESC  NEWORDERS;

INSERT INTO newcustomer VALUES(1,'KEVIN','역삼동','010-1234-1234');
INSERT INTO neworders VALUES(10,1,100,1000,SYSDATE);

SELECT * FROM newcustomer;
SELECT * FROM neworders;
DELETE FROM newcustomer;
DELETE FROM neworders;

--Task1_0520. 10개의 속성으로 구성되는 테이블 2개를 작성하세요. 단 FOREIGN KEY를 적용하여 한쪽 테이블의 데이터를 삭제 시 
--다른 테이블의 관련되는 데이터도 모두 삭제되도록 하세요. (모든 제약조건을 사용)
--단, 각 테이블에 5개의 데이터를 입력하고 두번째 테이블에 첫번째 데이터를 참조하고 있는 속성을 선택하여 데이터 삭제 
DROP table mart;
DROP table department;
create table mart(
    custid number primary key
    , name varchar2(20)
    , age number
    , sx varchar2(20)
    , phone number not null
    , address varchar2(100)
    , frequency number -- 방문 빈도
    , amount_num number
    , amount_price number
    , parking varchar2(20) -- 주차여부
    , family number -- 가족 구성원 수
);

alter table mart drop column amount_num;
alter table mart modify (name varchar2(30));
alter table mart modify (phone varchar2(20));

DESC mart;
insert into mart values(1, '고길동', 32, '남', '010-1234-1234', '서울 강남', 5, 1500000, 'N', 3);
insert into mart values(2, '손흥민', 31, '남', '010-7777-1234', '강원 춘천', 5, 200000000, 'Y', 4);
insert into mart values(3, '이순신', 57, '남', '010-1592-1234', '경남 통영', 5, 270000, 'N', 1);
insert into mart values(4, '아이유', 30, '여', '010-0516-1234', '서울 서초', 5, 750000000, 'Y', 4);
insert into mart values(5, '임영웅', 30, '남', '010-0517-1235', '서울 역삼', 5, 75000000, 'Y', 2);

select * from mart;

create table department(
    custid number primary key
    , name varchar(20)
    , age number
    , sx varchar2(20)
    , phone number not null
    , address varchar2(100)
    , use_store varchar2(100) -- 자주 찾는 매장
    , amount_num number
    , amount_price number
    , valet varchar2(20) -- 발렛파킹 서비스 사용여부
    , rounge varchar2(20) -- vip 라운지 사용여부
    , foreign key (custid) references mart(custid) on delete cascade
);

alter table department modify (amount_price check (amount_price > 100000000));
alter table department modify (rounge default 'Y');
alter table department modify (valet default 'Y');
alter table department modify (phone varchar2(100));
alter table department drop column amount_num;
--alter table department add (custid number);
select * from department;

insert into department values(1, '손흥민', 31, '남', '010-7777-1234', '강원 춘천', 'LV', 900000000,'','');
insert into department values(2, '아이유', 30, '여', '010-0516-1234', '서울 서초', 'GUCCI', 1500000000,'','');
insert into department values(3, '박지성', 31, '남', '010-7775-1235', '강원 춘천', 'LV', 900000000,'','');
insert into department values(4, '박세리', 30, '여', '010-0516-1234', '서울 서초', 'GUCCI', 1500000000,'','');
insert into department values(5, '임영웅', 30, '남', '010-0517-1235', '서울 역삼', 'ROLEX', 150000000,'','');

DELETE mart
WHERE custid = 1;

--Q. Table school, student를 적절한 컬럼으로 생성한 후 기본키, 외래키를 설정하고 데이터을 입력한 후
--기본키 삭제 시 외래키도 삭제되는 것을 확인하세요.
CREATE TABLE school(
schoolid NUMBER PRIMARY KEY,
schoolname VARCHAR2(20) NOT NULL,
schooltype VARCHAR2(10) NOT NULL,
schooladdress VARCHAR2(50) NOT NULL,
schoolsize NUMBER,
headmaster_name VARCHAR2(10),
class_total NUMBER DEFAULT 1,
teachers_total NUMBER,
students_total NUMBER CHECK(students_total>5),
established_date DATE);

DESC school;

CREATE TABLE student(
schoolid NUMBER,
schoolname VARCHAR2(20) NOT NULL,
schooltype VARCHAR2(10) NOT NULL,
gradenumber NUMBER NOT NULL,
classnumber NUMBER NOT NULL,
studentnumber NUMBER,
studentname VARCHAR2(10) NOT NULL,
address VARCHAR2(50),
email VARCHAR2(30) UNIQUE,
phone CHAR(13) DEFAULT '000-0000-0000',
PRIMARY KEY(studentnumber),
FOREIGN KEY(schoolid) REFERENCES school(schoolid) ON DELETE CASCADE);

DESC student;

ALTER TABLE school MODIFY(schooltype VARCHAR2(20));
INSERT INTO school VALUES(1,'개화','초등학교','부산진구 개금동', 1000,'아무개',36,50,1080,'1955-01-01');
INSERT INTO school VALUES(2,'개원','초등학교','부산진구 당감동',1200,'김누구',48,60,1920,'1996-01-01');
INSERT INTO school VALUES(3,'분포','초등학교','부산남구 용호동',1100,'이누구',36,50,1080,'2001-01-01');
INSERT INTO school VALUES(4,'분포','중학교','부산남구 용호동',1000,'박누구',30,40,800,'2002-01-01');
INSERT INTO school VALUES(5,'분포','고등학교','부산남구 용호동',1000,'조누구',20,30,600,'2002-01-01');
SELECT * FROM school;

ALTER TABLE student MODIFY(schooltype VARCHAR2(20));
INSERT INTO student VALUES(1,'개화','초등학교',1,3,20,'정누구','부산진구 개금동','jsldk@naver.com','');
INSERT INTO student VALUES(1,'개화','초등학교',2,3,24,'한누구','부산진구 당감동','lkjq@gmail.com',DEFAULT);
INSERT INTO student VALUES(2,'개원','초등학교',6,1,10,'전누구','부산진구 당감동','poir@naver.com','010-1234-1234');
INSERT INTO student VALUES(3,'분포','초등학교',4,3,21,'황누구','부산진구 용호동','',DEFAULT);
INSERT INTO student VALUES(4,'분포','중학교',3,2,1,'민누구','부산진구 용호동','','010-987-6543');
SELECT * FROM student;

DELETE school
WHERE schoolid = 1;

DELETE student
WHERE schoolid = 2;

SELECT * FROM school;
SELECT * FROM student;

--[실습 - 2인 1조]
--학교 관리를 위하여 테이블 2개 이상으로 db를 구축하고 3개 이상 활용할 수 있는 case를 만드세요.  

--Q. ParentTable, ChildTable 2개를 작성하고 각 테이블의 속성은 4개(데이터 타입은 모두 다름)로 제약조건은 5개 이상 적용한다.
--ParentTable의 기본키에 대하여 ChildTable의 속성중 하나가 참조를 하는 외래키를 설정하고 특정 데이터를 삭제하면 
--모두 삭제가 되도록 한다.
--데이터는 각각 10개 이상 입력하고 다음을 수행한다.
--데이터 전체 조회, 수정, 삭제 등을 통하여 원하는 그룹의 현금 금액을 도출한다.
--VARCHAR2, CHAR, NUMBER, DATE, (DECIMAL, FLOAT, INTEGER, TIMESTAMP) 

--naver 지도 음식점 서비스
CREATE TABLE na_restaurant(
      tid                    NUMBER PRIMARY KEY, 
    name                VARCHAR2(40) NOT NULL,
    address             VARCHAR2(40) NOT NULL,
    registration_number     VARCHAR2(40) UNIQUE NOT NULL,
    phone_number             VARCHAR2(40),
    hompage_url             VARCHAR2(40),
    running_time             VARCHAR2(40),
    real_estate_price    NUMBER DEFAULT 50000 CHECK(real_estate_price > 10000),
    registration_date   DATE,
    open_date            DATE,
    pet_yn                CHAR(1) DEFAULT 'N'
);
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(1, '호타루', '4번출구 뒷편', 'R001');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(2, '노브랜드버거', '7번출구 뒷편', 'R002');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(3, '교동짬뽕', '4번출구 지하', 'R003');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(4, '태평식당', '학원 뒷편', 'R004');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(5, '함초식당', '4번출구 직진', 'R005');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(11, '갓포돈', '4번출구 뒷편', 'R011');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(12, '담소사골순대국', '4번출구 뒷편', 'R012');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(13, '이층맥주창고', '4번출구 뒷편', 'R013');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(14, '요술포차', '4번출구 뒷편', 'R014');
INSERT INTO na_restaurant(TID,NAME,ADDRESS,registration_number) VALUES(15, '백초밥', '4번출구 뒷편', 'R015');
SELECT * FROM na_restaurant;

CREATE TABLE na_food(
    tid                          NUMBER PRIMARY KEY,
    na_restaurant_tid      NUMBER NOT NULL,
    name                      VARCHAR2(40) NOT NULL,
    price                       NUMBER NOT NULL,
    selling_count           NUMBER DEFAULT 0,
    registration_date     DATE DEFAULT SYSDATE,
    pepper_yn           CHAR(1) DEFAULT 'N',
    salt_yn                CHAR(1) DEFAULT 'N',
    sugar_yn             CHAR(1) DEFAULT 'N',
    detail_info           CLOB,
    FOREIGN KEY(na_restaurant_tid) REFERENCES na_restaurant(tid) ON DELETE CASCADE
);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(1,1,'돈코츠라멘',10000);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(2,2,'시그니처버거',4400);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(3,3,'짜장면',7000);  
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(4,4,'백반',9000);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(5,5,'백반',8000);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(11,11,'돈까스정식',11000);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(12,12,'사골순대국',9500);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(13,13,'백반',7000);  
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(14,14,'백반',7500);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(15,15,'연어초밥',18000);

-- 1,2,3 음식점 평균값 테스트용 데이터
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(6,1,'소유라멘',9500);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(7,1,'타코야끼',11000);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(8,2,'짜개치세트',6500);
INSERT INTO na_food(TID,na_restaurant_tid,name,price) VALUES(9,3,'짬뽕',8500);  

-- 데이터 확인
SELECT * FROM na_restaurant;
SELECT * FROM na_food;

-- 캐스캐이드 삭제 테스트
DELETE na_restaurant WHERE TID IN (4,5);

-- 가게별 메뉴 평균금액 테스트
SELECT R.NAME R_NAME, ROUND(AVG(F.PRICE)/10)*10 F_AVG_PRICE 
FROM na_restaurant R, na_food F
WHERE R.TID = F.na_restaurant_tid
GROUP BY R.NAME;

--가족 재산내역 확인
create table parents(
    family_name varchar2(100) primary key
    , age number not null
    , stock number
    , cash number
    , car_num char(10) default '0000' -- 자동차 번호
    , repay_date date -- 대출 상환일자
);

insert into parents values('Kim', 50, 1000000, 20000000, '4458', '2021-11-30');
insert into parents values('Lee', 57, 2000000, 10000000, '4521', '2023-12-31');
insert into parents values('Park', 60, 4000000, 5000000, '5893', '2024-02-20');
insert into parents values('Sim', 55, 8000000, 2500000, '9820', '2024-01-07');
insert into parents values('Seo', 58, 16000000, 1250000, '2786', '2023-11-01');
insert into parents values('Choi', 49, 120000000, 5000000, '1157', '2023-11-11');
insert into parents values('Kang', 59, 3200000, 100000000, '2984', '2023-12-01');
insert into parents values('Joo', 53, 258000000, 12000000, '4233', '2024-01-06');
insert into parents values('Chae', 52, 38000000, 37500000, '2520', '2022-05-05');
insert into parents values('Sung', 60, 58700000, 50000000, '1003', '2025-01-01');

select * from parents;

create table child(
    family_name varchar2(100) primary key
    , age number not null check (age > 25)
    , stock number
    , cash number
    , car_num char(10) default '0000'
    , graduation_date date not null
    , foreign key(family_name) references parents(family_name) on delete cascade
);

insert into child values('Kim', 26, 25000000, 2000000, '5555', '2023-07-31');
insert into child values('Lee', 27, 12500000, 4000000, '4521', '2021-12-28');
insert into child values('Park', 30, 5000000, 8000000, '6666', '2019-02-28');
insert into child values('Sim', 30, 100000000, 100000000, '9820', '2019-02-28');
insert into child values('Seo', 27,50000000, 50000000, '2786', '2022-07-31');
insert into child values('Choi', 26, 15000000, 5000000, '5252', '2023-07-31');
insert into child values('Kang', 26, 18000000, 12000000, '3488', '2021-12-28');
insert into child values('Joo', 31, 20000000, 7000000, '8966', '2019-02-28');
insert into child values('Chae', 33, 35000000, 2500000, '9722', '2019-02-28');
insert into child values('Sung', 28, 5000000, 3500000, '1152', '2022-07-31');

select * from child;

select parents.family_name as "부모"
    , to_char(parents.cash, '999,999,999') as "부모 현금보유량(원)"
    , child.family_name as "자식"
    , to_char(child.cash, '999,999,999') as "자식 현금보유량(원)"
from parents inner join child
    on parents.family_name = child.family_name
order by parents.cash desc;


select repay_date as "상환일자"
    ,(case when stock > cash
    then to_char((stock - cash),'999,999,999')
    else '자동차담보대출'
    end) as "주식담보대출 여부(원)"
    ,(case when repay_date < sysdate
    then '연체'
    else '미연체'
    end) as "연체여부"
from parents
order by family_name;


SELECT SYSDATE FROM DUAL;

--Q. DBMS 서버에 설정된 현재 날짜와 시간, 요일을 확인하시오.
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-mm-dd HH:MI:SS day') SYSDATE1
FROM DUAL;

--Q.이름, 전화번호가 포함된 고객목록을 보이시오. 단, 전화번호가 없는 고객은 ‘연락처없음’으로 표시하시오.
--NVL 함수는 값이 NULL인 경우 지정값을 출력하고, NULL이 아니면 원래 값을 그대로 출력한다. 함수  :  NVL("값", "지정값") 
SELECT name 이름, NVL(phone, '연락처없음') 전화번호
FROM customer;

select * from customer;

--Q. 고객목록에서 고객번호, 이름, 전화번호를 앞의 두 명만 보이시오.
--ROWNUM : 오라클에서 자동으로 제공하는 가상 열로 쿼리가 진행되는 동안 각 행에 일련번호를 자동으로 할당.
SELECT rownum 순번, custid 고객번호, name 이름, phone 전화번호 
FROM customer
WHERE rownum < 3;

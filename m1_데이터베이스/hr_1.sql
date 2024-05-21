select * from employees;

--Q.사번이 120번인 사람의 사번, 이름, 업무(job_id), 업무명(job_title)을 출력.
SELECT E.employee_id 사번, E.first_name 이름, E.last_name 성, E.job_id 업무, J.job_title 업무명
FROM employees E
INNER JOIN jobs J ON E.job_id = J.job_id
WHERE E.employee_id = 120;

--FIRST_NAME || ' ' || LAST_NAME AS 이름: FIRST_NAME과 LAST_NAME을 공백으로 연결하여 
--하나의 문자열로 합치고, 이 결과의 별칭을 '이름'으로 지정
SELECT 
EMPLOYEE_ID 사번, 
FIRST_NAME || ' ' || LAST_NAME AS 이름,
J.JOB_ID 업무,
J.JOB_TITLE 업무명
FROM EMPLOYEES E, JOBS J
WHERE E.EMPLOYEE_ID=120
AND e.job_id = j.job_id;

--Q. 2005년 상반기에 입사한 사람들만 출력
SELECT first_name||' '||last_name "이름", hire_date "입사일"
FROM employees
WHERE TO_CHAR(hire_date, 'YY/MM') BETWEEN '05/01' AND '05/06';

--_을 와일드카드가 아닌 문자로 취급하고 싶을 때 escape 옵션을 사용
select * from employees where job_id like '%\_A%';
select * from employees where job_id like '%\_A%' escape '\';
select * from employees where job_id like '%#_A%' escape '#';

--IN : OR 대신 사용
select * from employees where manager_id=101 or manager_id=102 or manager_id=103;
select * from employees where manager_id in ( 101, 102, 103 );

--Q. 업무 SA_MAN, IT_PROG, ST_MAN 인 사람만 출력
SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('SA_MAN', 'IT_PROG', 'ST_MAN');

--IS NULL / IS NOT NULL
--null 값인지를 확인할 경우 = 비교 연산자를 사용하지 않고 is null을 사용한다.
select * from employees where commission_pct is null;
select * from employees where commission_pct is not null;

--ORDER BY
--ORDER BY 컬럼명 [ASC | DESC]
select * from employees order by salary asc;
select * from employees order by salary desc;
select * from employees order by salary asc, last_name desc;

--DUAL 테이블
select * from employees where mod( employee_id, 2 )= 1;
select mod( 10, 3 ) from dual;

--round()
select round( 355.95555 ) from dual;
select round( 355.95555, 2 ) from dual;
select round( 355.95555, -2 ) from dual;

--trunc()	버림 함수. 지정한 자리수 이하를 버린 결과 제공
select trunc( 45.5555, 1 ) from dual;

--ceil() 무조건 올림, 자리 지정 못함	
select ceil( 45.111 ) from dual;

--Q. HR EMPLOYEES 테이블에서 이름, 급여, 10% 인상된 급여을 출력하세요.
SELECT last_name 이름 , salary 급여, salary*1.1 인상된급여
FROM employees;

--Q. manager_id 가 101에서 103인 사람만 출력
SELECT manager_id
FROM employees
WHERE manager_id between 101 and 103;

--Q. EMPLOYEE_ID가 홀수인 직원의 EMPLPYEE_ID와 LAST_NAME을 출력하세요.
SELECT employee_id 사원번호, last_name 이름 
FROM employees
WHERE employee_id IN (SELECT employee_id FROM employees WHERE mod(employee_id, 2) = 1);

--Q. EMPLOYEES 테이블에서 commission_pct 의  Null값 갯수를  출력하세요.
SELECT COUNT(*) FROM EMPLOYEES WHERE COMMISSION_PCT IS NULL;

--Q. EMPLOYEES 테이블에서 deparment_id 가 없는 직원을 추출하여  POSITION을 '신입'으로 출력하세요.(position 열을 추가)
select employee_id, first_name, last_name, '신입' as position 
from employees
where department_id is null;

select last_name, department_id, nvl(to_char(department_id),'신입') position
from employees where department_id is null;

--Q. employees 테이블에서 이름에 FIRST_NAME과 LAST_NAME을 붙여서 'NAME' 컬럼명으로 출력하세요.
SELECT FIRST_NAME || ' ' || LAST_NAME AS NAME
FROM employees;

--Q. HR EMPLOYEES 테이블에서 SALARY, LAST_NAME 순으로 올림차순 정렬하여 출력하세요.
SELECT * FROM employees ORDER BY salary,last_name;

--날짜 관련 함수
select sysdate from dual;
select sysdate + 1 from dual;
select sysdate - 1 from dual;

select * from employees;
--근무한 날짜 계산
select last_name, round(sysdate-hire_date) 근무기간 from employees;

--add_months()    		특정 개월 수를 더한 날짜를 구한다.
select last_name, hire_date, add_months( hire_date, 6 ) from employees;

--last_day()			해당 월의 마지막 날짜를 반환하는 함수
select last_name, hire_date, last_day( hire_date ) from employees;
select last_name,hire_date, last_day(add_months(hire_date,1)) from employees;

--next_day()			해당 날짜를 기준으로 명시된 요일에 해당하는 날짜를 반환
--일 ~ 토, 1 ~ 7 로 표현가능
select hire_date, next_day( hire_date, '월' ) from employees;

--months_between()		날짜와 날짜 사이의 개월수를 구한다.
SELECT hire_date, round(months_between(sysdate, hire_date),1) from employees;

--형 변환 함수 : to_date()			문자열을 날짜로
--'2023-01-01'이라는 문자열을 날짜 타입으로 변환
SELECT TO_DATE('2023-01-01', 'YYYY-MM-DD') FROM dual;

--to_char( 날짜 )		날짜를 문자로 변환
select to_char( sysdate, 'yy/mm/dd' ) from dual;

--형식
--YYYY 		네 자리 연도
--YY		두 자리 연도
--YEAR		연도 영문 표기
--MM		월을 숫자로
--MON		월을 알파벳으로
--DD		일을 숫자로
--DAY		요일 표현
--DY		요일 약어 표현
--D		요일 숫자 표현
--AM 또는 PM	오전 오후
--HH 또는 HH12	12시간
--HH24		24시간
--MI		분
--SS		초

--Q. 현재 날짜(SYSDATE)를 'YYYY/MM/DD' 형식의 문자열로 변환하세요.
select to_char(sysdate, 'YYYY/MM/DD') "날짜" from dual;

--Q. '01-01-2023'이라는 문자열을 날짜 타입으로 변환하세요
SELECT TO_DATE('02-01-2023', 'mm-dd-YYYY') FROM DUAL;

--Q. 현재 날짜와 시간(SYSDATE)을 'YYYY-MM-DD HH24:MI:SS' 형식의 문자열로 변환하세요
SELECT to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') from dual;

--Q. '2023-01-01 15:30:00'이라는 문자열을 날짜 및 시간 타입으로 변환하세요.
select to_date('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') from dual;

--to_char( 숫자 )	숫자를 문자로 변환
--9		한 자리의 숫자 표현		( 1111, ‘99999’ )		1111	
--0		앞 부분을 0으로 표현		( 1111, ‘099999’ )		001111
--$		달러 기호를 앞에 표현		( 1111, ‘$99999’ )		$1111
--.		소수점을 표시			( 1111, ‘99999.99’ )		1111.00
--,		특정 위치에 , 표시		( 1111, ‘99,999’ )		1,111
--MI		오른쪽에 - 기호 표시		( 1111, ‘99999MI’ )		1111-
--PR		음수값을 <>로 표현		( -1111, ‘99999PR’ )		<1111>
--EEEE		과학적 표현			( 1111, ‘99.99EEEE’ )		1.11E+03
--V		10을 n승 곱한값으로 표현	( 1111, ‘999V99’ )		111100
--B		공백을 0으로 표현		( 1111, ‘B9999.99’ )		1111.00
--L		지역통화			( 1111, ‘L9999’ )

select salary, to_char( salary, '0999999' ) from employees;
select to_char( -salary, '999999PR' ) from employees;
--1111 -> 1.11E+03
select to_char( 11111, '9.999EEEE' ) from dual; 
SELECT TO_CHAR(-1111111, '9999999MI') FROM dual;

--width_bucket()				지정값, 최소값, 최대값, bucket개수
select width_bucket( 92, 0, 100, 10 ) from dual;
select width_bucket( 100, 0, 100, 10 ) from dual;

select last_name from employees;
--Q. employees 테이블의 salary를 5개 등급으로 표시하세요
select max(salary) max, min(salary) min from employees;
SELECT salary, WIDTH_BUCKET(salary, 2100, 24001, 5) AS grade
FROM employees;

--문자 함수 Character Function
--upper()			대문자로 변경
select upper( 'Hello World' ) from dual;
--lower()			소문자로 변경
select lower( 'Hello World' ) from dual;

--Q. last_name이 Seo인 직원의 last_name 과 salary를 구하세요.(Seo, SEO, seo 모두 검출)
SELECT LAST_NAME, SALARY FROM EMPLOYEES WHERE lower(LAST_NAME) = 'seo';

--initcap()			첫글자만 대문자
select job_id, initcap( job_id ) from employees;

--length()			문자열의 길이
select job_id, length( job_id ) from employees;

--instr()			문자열, 찾을 문자, 찾을 위치, 찾은 문자 중 몇 번 째
select instr( 'Hello World', 'o', 3, 2 ) from dual;

--substr()			문자열, 시작위치, 개수
select substr( 'Hello World', 3, 3 ) from dual;
SELECT substr('Hello World', 9, 3) FROM dual;
SELECT substr('Hello World', -3, 3) FROM dual;

--lpad()			오른쪽 정렬 후 왼쪽에 문자를 채운다.
select lpad( 'Hello World', 20, '#' ) from dual;

--rpad()			왼쪽 정렬 후 오른쪽에 문자를 채운다.
select rpad( 'Hello World', 20, '#' ) from dual;

--ltrim()
select ltrim( 'aaaHello Worldaaa', 'a' ) from dual;
select ltrim( '   Hello World   ' ) from dual;

--rtrim()
select rtrim( 'aaaHello Worldaaa', 'a' ) from dual;
select rtrim( '   Hello World   ' ) from dual;

select last_name from employees;
select last_name as 이름, ltrim(last_name, 'A') as 변환
from employees;

--trim
select trim( '   Hello World   ' ) from dual;
--앞뒤의 특정 문자 제거
select last_name, trim( 'A' from last_name ) from employees;

--nvl()		null을 0 또는 다른 값으로 변환하는 함수
select last_name, manager_id, 
nvl( to_char( manager_id ), 'CEO' ) from employees;

--decode() 	if문이나 case문과 같이 여러 경우를 선택할 수 있도록 하는 함수
--DECODE 함수는 단순한 조건에 기반하여 값을 반환합니다. 구문은 DECODE(expression, search1, result1, ..., searchN, resultN, default) 
--여기서 expression은 검사할 값을 나타내고, search와 result는 각각 조건과 해당 조건이 참일 때 반환할 값
--default는 모든 search 조건이 거짓일 때 반환할 기본 값 출력
select last_name, department_id, 
decode(department_id,
    90, '경영지원실', 
    60, '프로그래머', 
    100, '인사부','기타') 부서
from employees;

--Q. employees 테이블에서 commission_pct가 null이 아닌 경우, 'A' null인 경우 'N'을 표시하는 쿼리를 작성
select commission_pct as commission
    , decode(commission_pct, null, 'N', 'A') as 변환
from employees
order by 변환 desc;

--case()
--decode() 함수와 유사하나 decode() 함수는 조건이 동일한 경우만 가능하지만
--case() 함수는 다양한 비교연산자로 조건을 제시할 수 있다.
--CASE 문은 조건에 따라 다른 값을 반환하는 데 사용되며, DECODE보다 복잡한 조건을 표현할 수 있다. 
--구문은 CASE WHEN condition THEN result ... ELSE default END이다. 
select last_name, department_id, 
case when department_id=90 then '경영지원실' 
when department_id=60 then '프로그래머' 
when department_id=100 then '인사부' 
else '기타'
end as 소속
from employees;

--Q. employees 테이블에서 salary가 20000 이상이면 'a', 10000과 20000 미만 사이면 'b', 그 이하면 'c'로 표시하는 쿼리를 
--작성하시오.(case)
select last_name,salary,
case
when salary>=20000 then ' a'
when salary>10000 and salary<20000 then ' b'
else ' c'
end as 등급
from employees;

--INSERT
--테이블에 데이터를 입력하는 방법은 두 가지 유형이 있으며 한 번에 한 건만 입력된다.
--a. INSERT INTO 테이블명 (COLUMN_LIST) VALUES (COLUMN_LIST에 넣을 VALUE_LIST);
--b. INSERT INTO 테이블명 VALUES (전체 COLUMN에 넣을 VALUE_LIST);

-- Concatenation :  콤마 대신에 사용하면 문자열이 연결되어 출력된다.
select last_name, 'is a ', job_id from employees;
select last_name ||  ' is a'  || job_id from employees;

--UNION
--UNION( 합집합 ) INTERSECT( 교집합 ) MINUS( 차집합 ) UNION ALL( 겹치는 것까지 포함 )
--두 개의 쿼리문을 사용해야 한다. 데이터 타입을 일치 시켜야 한다.
select first_name 이름, salary 급여 from employees 
where salary < 5000
union
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';

select first_name 이름, salary 급여 from employees 
where salary < 5000
minus
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';

select first_name 이름, salary 급여 from employees 
where salary < 5000
intersect
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';

--CREATE VIEW 명령어는 오라클 SQL에서 테이블의 특정 부분이나 조인된 결과를 논리적인 뷰(view)로 만들 때 사용
--뷰는 데이터를 요약하거나 복잡한 조인을 단순화하며, 사용자에게 필요한 데이터만을 보여주는 데 유용
--뷰는 실제 테이블 데이터를 복사하지 않고, 대신 쿼리 결과를 저장
--뷰의 주요 특징
--쿼리 단순화: 복잡한 쿼리를 뷰로 저장함으로써 사용자는 복잡한 쿼리문을 반복해서 작성할 필요 없이 간단하게 뷰를 참조할 수 있다.
--데이터 추상화: 뷰는 기본 테이블의 구조를 숨기고 사용자에게 필요한 데이터만을 보여줄 수 있어, 데이터 추상화를 제공.
--보안 강화: 뷰를 사용하면 특정 데이터에 대한 접근을 제한할 수 있으며, 사용자가 볼 수 있는 데이터의 범위를 제어할 수 있다.
--데이터 무결성 유지: 뷰를 사용하여 데이터를 수정하더라도, 이 변경사항이 기본 테이블의 데이터 무결성 규칙을 위반하지 않도록 관리할 수 있다.

CREATE VIEW employee_details AS
SELECT employee_id, last_name, department_id
FROM employees;

SELECT * FROM employee_details;

과제7_1117. employees 테이블에서 salary가 10000원 이상인 직원만을 포함하는 뷰 special_employee를 생성하는 SQL 명령문을 작성하시오.
CREATE VIEW special_employee AS
SELECT *
FROM employees
WHERE salary >= 10000;
select * from special_employee;

과제8_1117. employees 테이블에서 각 부서별 직원 수를 포함하는 뷰를 생성하세요
CREATE VIEW department_employee_count AS
SELECT department_id, COUNT(*) AS 부서별_직원수
FROM employees
GROUP BY department_id
ORDER BY 부서별_직원수;

select * from department_employee_count;

과제9_1117. employees 테이블에서 근속기간이 10년 이상인 직원를 포함하는 뷰를 생성하세요.
CREATE VIEW goinmul AS
SELECT last_name, round(sysdate-hire_date) AS 근속기간
FROM employees
WHERE round(sysdate-hire_date) > 365 * 10;

SELECT * from goinmul;

--TCL (Transaction Control Language)
--COMMIT: 현재 트랜잭션 내에서 수행된 모든 변경(INSERT, UPDATE, DELETE 등)을 데이터베이스에 영구적으로 저장.
--COMMIT 명령을 실행하면, 트랜잭션은 완료되며, 그 이후에는 변경 사항을 되돌릴 수 없다.
--ROLLBACK: 현재 트랜잭션 내에서 수행된 변경들을 취소하고, 데이터베이스를 트랜잭션이 시작하기 전의 상태로 되돌린다. 
--오류가 발생했거나 다른 이유로 트랜잭션을 취소해야 할 경우에 사용된다.
--SAVEPOINT: 트랜잭션 내에서 중간 체크포인트를 생성합니다. 오류가 발생할 경우, ROLLBACK을 사용하여 최근의 SAVEPOINT까지 되돌릴 수 있다.
--트랜잭션을 콘트롤하는 TCL(TRANSACTION CONTROL LANGUAGE)

-- members 테이블 생성
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    join_date DATE,
    status VARCHAR2(20)
);

INSERT INTO members (member_id, name, email, join_date, status) VALUES (1, 'John Doe', 'john@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (2, 'Jane Doe', 'jane@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (3, 'Mike Smith', 'mike@example.com', SYSDATE, 'Inactive');

select * from members;

INSERT INTO members (member_id, name, email, join_date, status) VALUES (4, 'Alice Johnson', 'alice@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (5, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');

INSERT INTO members (member_id, name, email, join_date, status) VALUES (6, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');

SAVEPOINT sp1;
INSERT INTO members (member_id, name, email, join_date, status) VALUES (7, 'Bob Kim', 'bob@example.com', SYSDATE, 'Inactive');

rollback to sp1;
commit;

--과제10_1117.
--orders라는 테이블을 생성하고, order_id, customer_id, order_date, amount, status라는 속성을 설정하세요.
--데이터를 5개 입력하세요.
--입력한 데이터 중 2개를 수정하세요.
--수정한 데이터를 취소하기 위해 롤백을 사용하세요.
--3개의 새로운 데이터를 입력하고, 그 중 마지막 데이터 입력만 취소한 후 나머지를 커밋하세요.

CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount NUMBER check (amount > 0),
    status VARCHAR2(30));

INSERT INTO orders VALUES(1,1, '2023-11-01',32000, '배달완료');
INSERT INTO orders VALUES(2,2, '2023-11-02',20000, '배달완료');
INSERT INTO orders VALUES(3,2, '2023-11-09',20000, '배달완료');
INSERT INTO orders VALUES(4,3, '2023-11-10',18000, '주문처리중');
INSERT INTO orders VALUES(5,4, '2023-11-14',45000, '주문확인중');
SAVEPOINT sp;

SELECT * FROM orders;

UPDATE orders
SET status = '주문취소'
WHERE order_id = 4;

UPDATE orders
SET status = '주문취소'
WHERE order_id = 5;

ROLLBACK to sp;

INSERT INTO orders VALUES(6,5, '2023-11-15',30000, '주문처리중');
INSERT INTO orders VALUES(7,6, '2023-11-15',48000, '주문처리중');
SAVEPOINT spa;
INSERT INTO orders VALUES(8,5, '2023-11-16',25000, '주문확인중');
ROLLBACK to spa;
COMMIT;

--과제11_1117. 관심있는 db 테이블을 생성하고 관리하는 시나리오를 작성하여 데이터 입력, 수정, 삭제 과정을 진행한 후 최종 데이터 
--10개를 출력하세요.(ROLLBACK 2회, SAVEPOINT 2개를 최소한 사용)
create table employee_evaluation(
    employee_id char(10) primary key -- 1부터 10까지
    , name varchar2(50) not null
    , department char(50) not null -- 기획부, 지원부, 영업1부, 영업2부
    , position char(10) not null
    , hire_date date
    , goal int not null
    , performance int
);

select *
from employee_evaluation;

alter table employee_evaluation drop column name;
alter table employee_evaluation add (first_name varchar2(50));
alter table employee_evaluation add (last_name varchar2(50));
alter table employee_evaluation add (salary number check(salary > 3000));
alter table employee_evaluation add (achieve char(10) not null);

select *
from employee_evaluation;

savepoint sp_1;

alter table employee_evaluation drop column achieve;
alter table employee_evaluation add (achieve char(10));

rollback sp_1;

insert into employee_evaluation values (1, '기획부', '팀장', '2020-01-01', 100, 110, '현규', '오', 10000, '');
insert into employee_evaluation values (2, '기획부', '차장', '2020-05-01', 70, 70, '우영', '정', 7500, '');
insert into employee_evaluation values (3, '기획부', '대리', '2021-01-25', 30, 25, '규성', '조', 5500, '');
insert into employee_evaluation values (4, '영업1부', '팀장', '2020-01-01', 100, 120, '의조', '황', 9000, '');
insert into employee_evaluation values (5, '영업1부', '차장', '2020-05-01', 70, 90, '선민', '문', 7300, '');
insert into employee_evaluation values (6, '영업1부', '대리', '2021-01-25', 30, 45, '용우', '박', 5300, '');
insert into employee_evaluation values (7, '영업2부', '차장', '2020-05-01', 70, 80, '흥민', '손', 7300, '');
insert into employee_evaluation values (8, '영업2부', '과장', '2020-05-01', 50, 120, '강인', '이', 5800, '');
insert into employee_evaluation values (9, '영업2부', '사원', '2023-06-01', 15, 20, '순민', '이', 4500, '');
insert into employee_evaluation values (10, '지원부', '대리', '2022-05-14', 30, 45, '재성', '이', 5600, '');

savepoint sp_2;

select *
from employee_evaluation;

alter table employee_evaluation modify (employee_id char(10));
alter table employee_evaluation modify (department varchar2(50));

rollback to sp_2;

commit;

alter table employee_evaluation modify (position char(15));

update employee_evaluation
set position = '팀장(부장)'
where position = '팀장';

commit;

update employee_evaluation
set performance = 90
where first_name = '의조';

update employee_evaluation
set performance = 50
where first_name = '선민';

commit;

-- 본문
create view KPI as
    select last_name||''||first_name as 이름
        , employee_id as 사번
        , position as 직급
        , goal as "목표 KPI"
        , performance as "달성 KPI"
        , (performance - goal) as "KPI 초과량"
        , case when (performance - goal) >= 0
            then 'Y'
            else 'N'
            end as "ACHIEVE"
    from employee_evaluation
    order by achieve desc, "KPI 초과량" desc;
    
select *
from KPI
where "KPI 초과량" >= 0;


--과제12_1117. HR 테이블들을 분석해서 전체 현황을 설명할 수 있는 요약 테이블을 작성하세요. (예 : 부서별 평균 SALARY 순위)
select * from job_history;

--부서별 급여 현황
--테이블생성, 부서별 급여와 총 급여를 확인 할 수 있음.
--(급여의 합 평균 최솟값 최댓값, 총 직원수, 급여전체총합, 직원평균급여, 부서평균급여)
--table 만들기 부서별 급여를 대략적으로 보기
--사용할 테이블 확인
select * from jobs;
select * from departments;
select * from employees;
select * from job_history;

--부서 목록 확인
SELECT department_id
from employees
group by department_id
order by department_id DESC;
-- 부서 목록 department_id : 10,20,30,40,50,60,70,80,90,100,110 그 외 나머지(120~200등..)는 없고 null 값이 있음.
--department_id 가 null 인 사람은 모두 job_id 에 맞는 department_id 를 부여해주려고함(데이터 무결성)
--1. department_id 가 null 값인 사람 찾기
select *
from employees
where department_id IS NULL;
--한명 밖에 없음. department_id : null, employee_id : 178, Job_id : SA_REP

--2. job_id 가 SA_REP 인 department_id 찾기 (직업에 맞는 부서 찾기)
select job_id, department_id
from job_history
where job_id IN 'SA_REP';
--SA_REP 의 department_id 는 80

--3. 수정 전 savepoint 생성
SAVEPOINT null_to_80;
------------------------SAVEPOINT---------------------------------

--4. 제약조건primary key 인 employee_id 로 찾아서 derpartment_id 를 80으로 수정
UPDATE employees
SET department_id = 80
WHERE employee_id = 178;

select * from employees where employee_id = 178;
--ROLLBACK null_to_80; -- savepoint로 가기
--commit;
--수정끝

--팀구성 및 년차별 샐러리
--각 부서마다 팀원은 몇명이고 어떤 포지션들이 있고 구성은 어떻게 되는지
SELECT E.department_id, D.department_name, nvl(E.job_id,'Total') job_id , count(*) 직원수
FROM employees E
LEFT OUTER JOIN departments D on E.department_id = D.department_id
GROUP BY ROLLUP((E.department_id, D.department_name), E.job_id)
ORDER BY E.department_id;

--JOB ID 별 총 몇명이 있는지
SELECT E.job_ID, J.job_title, count(E.employee_id)
FROM employees E
LEFT OUTER JOIN jobs J on E.job_id = J.job_id
WHERE E.job_id = J.job_id
GROUP BY E.job_id, J.job_title;

--JOB ID 별 몇년차는 얼마 받는지 각 년차별로 샐러리 평균
SELECT job_id, 연차, round(avg(salary)) 평균급여
from (select job_id, floor(months_between(sysdate, hire_date)/12) as 연차, salary from employees)
GROUP BY job_id, 연차
ORDER BY job_id, 연차;


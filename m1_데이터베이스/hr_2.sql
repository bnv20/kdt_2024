--ESCAPE 
--WHERE 컬럼명 조건 값 
--LIKE 패턴
--ESCAPE 문자
--_을 와일드카드가 아닌 문자로 취급하고 싶을 때 escape 옵션을 사용한다.
select * from employees where job_id like '%_A%';
select * from employees where job_id like '%\_A%' escape '\';
select * from employees where job_id like '%#_A%' escape '#';

--IN : OR 대신 사용
select * from employees where manager_id=101 or manager_id=102 or manager_id=103;
select * from employees where manager_id in ( 101, 102, 103 );

--IS NULL / IS NOT NULL
--null 값인지를 확인할 경우 = 비교 연산자를 사용하지 않고 is null을 사용한다.

select * from employees where commission_pct is null;
select * from employees where commission_pct is not null;

--ORDER BY
--ORDER BY 컬럼명 [ASC | DESC]

select * from employees order by salary asc;
select * from employees order by salary desc;
select * from employees order by salary asc, last_name asc;

--[주요 함수]

--DUAL 테이블
--select 절 다음에 반드시 from 절을 기술해야 한다.
--연산의 경우 select 절 자체적으로 연산이 가능하기 때문에 from 절 뒤에 올 테이블이 필요없다.
--이런 경우 사용할 수 있는 Dummy 테이블이 DUAL 테이블이다.

--    mod()					나머지 함수
select * from employees where mod( employee_id, 2 )= 1;

select mod( 10, 3 ) from dual;

--round()				반올림 함수
select round( 355.95555 ) from dual;		356	소수점 이하 반올림
select round( 355.95555, 2 ) from dual;	355.96	소수점 이하 둘째자리 반올림
select round( 355.95555, 0 ) from dual;	356
select round( 355.95555, -1 ) from dual;	360	소수점 이전 한자리 반올림

--trunc()					버림 함수. 지정한 자리수 이하를 버린 결과를 제공
select trunc( 45.5555, 1 ) from dual;		45.5	소수점 이하 한자리까지만 표현
select ceil( 45.3333 ) from dual;
select last_name, trunc( salary/12, 2 ) from employees;

--날짜 관련 함수
sysdate
시스템에 저장된 현재 날짜를 반환
select sysdate from dual;

select sysdate + 1 from dual;
select sysdate - 1 from dual;

select last_name, round(sysdate-hire_date) from employees;			근무한 날짜
sysdate는 연월일시분초가 구해지는데 입사일자는 0시 0분 00초로 저장되어 있다.

add_months()    		특정 개월 수를 더한 날짜를 구한다.
select last_name, add_months( hire_date, 6 ) from employees;

last_day()			해당 월의 마지막 날짜를 반환하는 함수
select last_day( sysdate ) - sysdate from dual;
select hire_date, last_day( hire_date ) from employees;
select last_name, hire_date, last_day( add_months( hire_date, 1 ) ) from employees;

next_day()			해당 날짜를 기준으로 명시된 요일에 해당하는 날짜를 반환
일 ~ 토, 1 ~ 7 로 표현가능하다.
select hire_date, next_day( hire_date, '월' ) from employees;
select  TO_CHAR(SYSDATE'DY MONTH DD,YYYY','NLS_DATE_LANGUAGE=ENGLISH') from DUAL;


months_between()		날짜와 날짜 사이의 개월수를 구한다.
select last_name, round(months_between( sysdate, hire_date ), 2) 개월수 from employees;

--형 변환 함수
	
    <-TO_NUMBER                   <-TO_CHAR
Number                character	               	 date
     TO_CHAR ->                   TO_DATE ->

to_date()			문자열을 날짜로
to_date( ‘날짜’ ) 	
select sysdate from dual;

문제: '2023-01-01'이라는 문자열을 날짜 타입으로 변환하세요.
SELECT TO_DATE('2023-01-01', 'YYYY-MM-DD') FROM dual;

문제: 현재 날짜(SYSDATE)를 'YYYY/MM/DD' 형식의 문자열로 변환하세요.
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') FROM dual;

문제: '01-01-2023'이라는 문자열을 날짜 타입으로 변환하세요
SELECT TO_DATE('01-01-2023', 'DD-MM-YYYY') FROM dual;
;

문제: 현재 날짜와 시간(SYSDATE)을 'YYYY-MM-DD HH24:MI:SS' 형식의 문자열로 변환하세요
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM dual;

문제: '2023-01-01 15:30:00'이라는 문자열을 날짜 및 시간 타입으로 변환하세요.
SELECT TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual;


select employee_id 사번, last_name 이름, hire_date 입사일,
trunc( ( to_date( '13/01/01' ) - hire_date ) / 365 ) 근속연수
from employees order by 근속연수 desc;

SELECT TO_DATE('20210101') , 
TO_CHAR(TO_DATE('20210101'),'MonthDD YYYY','NLS_DATE_LANGUAGE=ENGLISH') FORMAT1 
, TO_CHAR(TO_DATE('20210101'),'MonthDD, YYYY','NLS_DATE_LANGUAGE=ENGLISH') FORMAT1_1 
, TO_CHAR(TO_DATE('20210101'),'Month','NLS_DATE_LANGUAGE=ENGLISH') FORMAT2 
, TO_CHAR(TO_DATE('20210101'),'MonthfmDD, YYYY','NLS_DATE_LANGUAGE=ENGLISH') FORMAT3
, TO_CHAR(TO_DATE('20210101'),'MonthDD, YYYY, Day','NLS_DATE_LANGUAGE=ENGLISH') FORMAT4 FROM DUAL;

to_char( 날짜 )		날짜를 문자로 변환
select to_char( sysdate, 'yy/mm/dd hh24:mi:ss' ) from dual;
select to_char( sysdate, 'yy/mm/dd' ) from dual;
select to_char( sysdate, 'YYYY-MM-DD' ) from dual;
select to_char( sysdate, 'hh24:mi:ss' ) from dual;
select to_char( sysdate, 'DAY' ) from dual;

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
--
--AM 또는 PM	오전 오후
--HH 또는 HH12	12시간
--HH24		24시간
--MI		분
--SS		초

--to_char( 숫자 )	숫자를 문자로 변환

--9		한 자리의 숫자 표현		( 1111, ‘99999’ )		1111	
--0		앞 부분을 0으로 표현		( 1111, ‘099999’ )		001111
--$		달러 기호를 앞에 표현		( 1111, ‘$99999’ )		$1111
--.		소수점을 표시			( 1111, ‘99999.99’ )		1111.00
--,		특정 위치에 , 표시		( 1111, ‘99,999’ )		1,111
--MI		오른쪽에 ? 기호 표시		( 1111, ‘99999MI’ )		1111-
--PR		음수값을 <>로 표현		( -1111, ‘99999PR’ )		<1111>
--EEEE		과학적 표현			( 1111, ‘9.999EEEE’ )		1.11E+03
--V		10을 n승 곱한값으로 표현	( 1111, ‘999V99’ )		111100
--B		공백을 0으로 표현		( 1111, ‘B9999.99’ )		1111.00
--L		지역통화			( 1111, ‘L9999’ )
'99999'는 숫자 형식을 나타내고, 'MI'는 음수가 아닌 경우 뒤에 공백을, 음수인 경우에는 마이너스 기호를 추가
select salary, to_char( salary, '0999999' ) from employees;
select to_char( -salary, '999999PR' ) from employees;
select to_char( 11111, '9.99EEEE' ) from dual;	
select to_char( 1111, 'B9999.99' ) from dual;	
select to_char( 1111, 'L99999' ) from dual;
select to_char( 1111, '99999' ) from dual;
select to_char( 1111, '9.99EEEE' ) from dual;
SELECT TO_CHAR(-1111111, '9999999MI') FROM dual;

( 1111, ‘99999MI’ )
--width_bucket()				지정값, 최소값, 최대값, bucket개수
select width_bucket( 92, 0, 100, 10 ) from dual;
select width_bucket( 100, 0, 100, 10 ) from dual;
select width_bucket( 21, 0, 21, 21 ) from dual;
select department_id, last_name, salary, width_bucket( salary, 0, 20000, 5 ) from employees where department_id=50;
select max(salary) from employees;
select min(salary) from employees;
select salary, width_bucket(salary,2100, 24000, 5) 등급 from employees; 
--Q. employees 테이블의 salary를 5개 등급으로 표시하세요
select max(salary) max, min(salary) min from employees;
SELECT salary, WIDTH_BUCKET(salary, 2100, 24001, 5) AS grade
FROM employees;

--문자 함수 Character Function 
--upper()			대문자로 변경
select upper( 'Hello World' ) from dual;

--lower()			소문자로 변경
select lower( 'Hello World' ) from dual;

select last_name, salary from employees where last_name='seo';
select last_name, salary from employees where lower( last_name )='seo';

--initcap()			첫글자만 대문자
select initcap( job_id ) from employees;

--length()			문자열의 길이
select job_id, length( job_id ) from employees;

--instr()			문자열, 찾을 문자, 찾을 위치, 찾은 문자 중 몇 번 째
select instr( 'Hello World', 'o', 3, 2 ) from dual;

--substr()			문자열, 시작위치, 개수
select substr( 'Hello World', 3, 3 ) from dual;
select substr( 'Hello World', -3, 3 ) from dual;		뒤에서 3번째 부터 3글자

--lpad()			오른쪽 정렬 후 왼쪽에 문자를 채운다.
select lpad( 'Hello World', 20, '#' ) from dual;

--rpad()			왼쪽 정렬 후 왼쪽에 문자를 채운다.
select rpad( 'Hello World', 20, '#' ) from dual;

--ltrim()
select ltrim( 'aaaHello Worldaaa', 'a' ) from dual;	Hello Worldaaa	앞의 특정 문자 제거
select ltrim( '   Hello World   ' ) from dual;		Hello World	문자열 앞뒤 공백 제거

--rtrim()
select rtrim( 'aaaHello Worldaaa', 'a' ) from dual;	aaaHello World	뒤의 특정 문자 제거
select rtrim( '   Hello World   ' ) from dual;		Hello World	문자열 앞뒤 공백 제거

--trim()

select trim( '   Hello World   ' ) from dual;
select last_name, trim( 'A' from last_name ) from employees;		앞뒤의 특정 문자 제거

--기타 함수
nvl()		null을 0 또는 다른 값으로 변환하는 함수
select salary, salary*12*nvl(commission_pct, 0 ) from employees;
select last_name, manager_id, 
nvl( to_char( manager_id ), 'CEO' ) from employees;

// deparment_id 가 없는 사람 '신입' 출력

--decode() 	if문이나 case문과 같이 여러 경우를 선택할 수 있도록 하는 함수
--DECODE 함수는 단순한 조건에 기반하여 값을 반환합니다. 구문은 DECODE(expression, search1, result1, ..., searchN, resultN, default) 
--여기서 expression은 검사할 값을 나타내고, search와 result는 각각 조건과 해당 조건이 참일 때 반환할 값
--default는 모든 search 조건이 거짓일 때 반환할 기본 값 출력
select last_name, department_id, 
decode( department_id, 
    90, '경영지원실', 
    60, '프로그래머', 
    100, '인사부', '기타' ) 부서 from employees;

문제: employees 테이블에서 commission_pct가 null이 아닌 경우, 'A' 아닌 경우 'N'을 표시하는 쿼리를 작성
SELECT commission_pct, DECODE(commission_pct, NULL, 'N', 'A') AS commission_status
FROM employees;

--case()
--decode() 함수와 동일하나 decode() 함수는 조건이 동일한 경우만 가능하지만
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

SELECT employee_id, last_name, 
       CASE 
           WHEN salary > 10000 THEN 'High'
           WHEN salary BETWEEN 5000 AND 10000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_level
FROM employees;

문제: employees 테이블에서 salary가 20000 이상이면 'a', 10000과 20000 사이면 'b', 그 이하면 'c'로 표시하는 쿼리를 작성하시오.
SELECT salary, 
       CASE 
           WHEN salary >= 20000 THEN 'a'
           WHEN salary BETWEEN 10000 AND 19999 THEN 'b'
           ELSE 'c'
       END AS salary_size
FROM employees;



--* INSERT
--
--테이블에 데이터를 입력하는 방법은 두 가지 유형이 있으며 한 번에 한 건만 입력된다.
--a. INSERT INTO 테이블명 (COLUMN_LIST) VALUES (COLUMN_LIST에 넣을 VALUE_LIST);
--b. INSERT INTO 테이블명 VALUES (전체 COLUMN에 넣을 VALUE_LIST);
--
--해당 칼럼의 데이터 유형이 CHAR나 VARCHAR2 등 문자 유형일 경우 『’』 (SINGLE QUOTATION)로 입력할 값을 입력한다. 
--숫자일 경우 『'』(SINGLE QUOTATION)을 붙이지 않아도 된다.
--[a 유형]
--[예제] INSERT INTO PLAYER (PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, HEIGHT, WEIGHT, BACK_NO) 
--            VALUES (＇2002007＇, ＇박지성＇, ＇K07＇, ＇MF＇, 178, 73, 7); 
--a 유형은 테이블의 칼럼을 정의할 수 있는데, 이때 칼럼의 순서는 테이블의 칼럼 순서와 매치할 필요는 없으며, 정의하지 않은 칼럼은 
--Default로 NULL  값이 입력된다.  단, Primary Key나 Not NULL 로 지정된 칼럼은 NULL이 허용되지 않는다.
--
--[b 유형]
--[예제] INSERT INTO PLAYER VALUES ('2002010','이청용','K07','','BlueDragon','2002','MF','17’, NULL,NULL,'1',180,69);
--b 유형은 모든 칼럼에 데이터를 입력하는 경우로 굳이 COLUMN_LIST를 언급하지 않아도 되지만, 칼럼의 순서대로 빠짐없이 
--데이터가 입력되어야 한다. 데이터를 입력하는 경우 정의되지 않은 미지의 값인 E PLAYER NAME 은 두개의 『''』SINGLE QUOTATION
--을 붙여서 표현하거나, NATION이나 BIRTH_DATE의 경우처럼 NULL이라고 명시적으로 표현할 수 있다.
--
--* UPDATE
--UPDATE 다음에 수정되어야 할 칼럼이 존재하는 테이블명을 입력하고, SET  다음에 수정되어야 할 칼럼명과 해당 칼럼 수정 값으로 변경이 이루어진다.
--UPDATE 테이블명 SET 수정되어야 할 칼럼명 = 수정되기를 원하는 새로운 값;
--[예제] UPDATE PLAYER SET POSITION = 'MF’;
--일반적으로는5절에서 배울 WHERE 절을 사용하여 UPDATE 대상 행을 선별한다. WHERE 절을 사용하지 않는다면 테이블의 전체 데이터가 수정된다.
--
--* DELETE
--DELETE FROM 다음에 삭제를 원하는 자료가 저장되어 있는 테이블명을 입력하고 실행한다. 이때 FROM 문구는 생략이 가능한 키워드이다. 
--DELETE [FROM] 삭제를 원하는 정보가 있는 테이블명;
--[예제] DELETE FROM PLAYER; 
--
--* SELECT
--조회하기를 원하는 칼럼명을 SELECT 다음에 콤마 구분자(,)로 구분하여 나열하고, FROM 다음에 해당 칼럼이 존재하는 테이블명을 입력하여 실행시킨다.
--SELECT [ALL/DISTINCT] 보고싶은 칼럼명,. . . FROM 해당 칼럼들이 있는 테이블명;
---  ALL : 중복된 데이터가 있어도 모두 출력한다. Default 옵션이므로 별도로 표시하지 않아도 된다.
---  DISTINCT : 중복된 데이터가 있는 경우 1건으로 처리해서 출력한다.
--[예제] SELECT PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, HEIGHT, WEIGHT, BACK_NO FROM PLAYER;
--[예제] SELECT ALL POSITION FROM PLAYER;
--[예제] SELECT DISTINCT POSITION FROM PLAYER;
--
--해당 테이블의 모든 칼럼 정보를 보고 싶을 경우에는 와일드카드로 애스터리스크(*)를 사용하여 조회할 수 있다.
--SELECT * FROM 테이블명;
--실행 결과 화면을 보면 칼럼 레이블(LABLE)이 맨 위에 보여지고, 레이블 밑에 점선이 보여진다. 실질적인 자료는 다음 줄부터 시작된다.
--레이블은 기본적으로 대문자로 보여지고, 첫 라인에 보여지는 레이블의 정렬은 다음과 같다.
--- 좌측 정렬 : 문자 및 날짜 데이터
--- 우측 정렬 : 숫자 데이터
--[예제] SELECT * FROM PLAYER;
--
--SELECT - ALIAS
--조회된 결과에 일종의 별명(ALIAS, ALIASES)을 부여해서 칼럼 레이블을 변경할 수 있다. 
--- 칼럼명 바로 뒤에 온다.
--- 칼럼명과 ALIAS 사이에 AS, as 키워드를 사용할 수도 있다. (option)
--[예제] SELECT PLAYER NAME AS 선수명, POSITION AS 위치, HEIGHT AS 키, WEIGHT AS 몸무게 FROM PLAYER;
--칼럼 별명에서 AS를 꼭 사용하지 않아도 되므로, 아래 SQL은 위 SQL과 같은 결과를 출력한다.
--[예제] SELECT PLAYER_NAME 선수명, POSITION 위치, HEIGHT 키, WEIGHT 몸무게 FROM PLAYER;
--
--SELECT - ALIAS
--ALIAS 사용시 이중 인용부호(Double Quotation)는 ALIAS가 공백, 특수문자를 포함할 경우와 대소문자 구분이 필요할 경우 사용된다.
--SELECT PLAYER_NAME "선수 이름", POSITION "그라운드 포지션",
--[예제] HEIGHT "키", WEIGHT "Weight“ FROM PLAYER;
--
--
--테이블 구성

CREATE TABLE MEMBER(
    ID                  VARCHAR2(50),
    PWD             NVARCHAR2(50),
    NAME          NVARCHAR2(50),
    GENDER      NCHAR(2),  
    AGE              NUMBER(3),
    BIRTHDAY  CHAR(10),    
    PHONE        CHAR(13),      
    REGDATE   DATE
);


CREATE TABLE NOTICE(
    ID                        NUMBER,
    TITLE                  NVARCHAR2(100),
    WRITER_ID       NVARCHAR2(50),    
    CONTENT         CLOB,
    REGDATE         TIMESTAMP,    
    HIT                     NUMBER,      
    FILES                  NVARCHAR2(1000)
);

CREATE TABLE "COMMENT"(
    ID                        NUMBER,
    CONTENT         NVARCHAR2(2000),
    REGDATE         TIMESTAMP,
    WRITER_ID       NVARCHAR2(50),         
    NOTICE_ID       NUMBER
);
-- 예약어 COMMENT는 ""로 처리하면 에러 해결
--select last_name, salary*12 as “연 봉” from employees;
--공백이나 $ _ # 등 특수문자를 넣을 경우 쌍 따옴표를 사용

CREATE TABLE ROLE(
    ID                        VARCHAR2(50),
    DISCRIPTION    NVARCHAR2(500)
);

CREATE TABLE MEMBER_ROLE(
   MEMBER_ID     NVARCHAR2(50),
   ROLE_ID            VARCHAR2(50)
);

-- Concatenation
    select last_name, 'is a ', job_id from employees;
    select last_name ||  ' is a'  || job_id from employees;
--    콤마 대신에 사용하면 문자열이 연결되어 출력된다.

--  Distinct
    select job_id from employees;
    select distinct job_id from employees;
--    중복되는 컬럼을 한 번씩만 보여준다.

--UPDATE/DELETE
SELECT * FROM MEMBER;
SELECT id "USER_ID", NAME, PWD FROM MEMBER;

UPDATE MEMBER SET PWD='222';
-- PWD가 전부 바뀜, 조건을 추가하여 특정 데이터만 변경할 수 있음
UPDATE MEMBER SET PWD='111' WHERE ID='DRAGON';
UPDATE MEMBER SET PWD='333', NAME='KING' WHERE ID='DRAGON'; 

INSERT INTO MEMBER(ID, PWD, NAME) VALUES('TES1','112','JAMES');
DELETE MEMBER WHERE ID='TEST';

UPDATE MEMBER SET PWD='111' WHERE NAME='KING';
--세션에서 UPDATE 후 COMMIT하지 않은면 LOCK이 걸려 다른세션에서 해당 DATA에 대한 UDATE가 진행되지 않음
COMMIT;

--replace 함수는 문자열에서 특정 부분 문자열을 다른 문자열로 대체하는 함수. 하지만 null은 대체할 수 있는 문자열이 아니므로, 이 문장은 오류
update member set name = replace(공통분류, null, '식품') where 소분류코드 like 'C06%';
update member set name = case when 공통분류 is null then '식품' else name end where 소분류코드 like 'C06%';

update member set name = replace(name, 'JAMES', '식품') where pwd =112;


--UNION
--UNION( 합집합 ) INTERSECT( 교집합 ) MINUS( 차집합 ) UNION ALL( 겹치는 것까지 포함 )
--두 개의 쿼리문을 사용해야 한다. 데이터 타입을 일치 시켜야 한다.

select first_name 이름, salary 급여 from employees 
where salary < 5000
union
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';			92명

select first_name 이름, salary 급여 from employees 
where salary < 5000
union all
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';			127명

select first_name 이름, salary 급여 from employees 
where salary < 5000
minus
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';			14명

select first_name 이름, salary 급여 from employees 
where salary < 5000
intersect
select first_name 이름, salary 급여 from employees 
where hire_date < '99/01/01';			35명

-- JOIN 사용

CREATE TABLE test1(
ID VARCHAR2(10),
NAME VARCHAR2(10),
ENG NUMBER
);

INSERT INTO test1 VALUES('111','KEVIN',90);
INSERT INTO test1 VALUES('112','JAMES',70);
INSERT INTO test1 VALUES('113','SUSAN',80);
INSERT INTO test1 VALUES('114','TOM',85);
INSERT INTO test1 VALUES('115','DRAGON',75);

CREATE TABLE test2(
ID VARCHAR2(10),
MATH NUMBER,
AGE NUMBER);
INSERT INTO test2 VALUES('111',80,90);
INSERT INTO test2 VALUES('112',80,90);
INSERT INTO test2 VALUES('113',80,90);
INSERT INTO test2 VALUES('116',80,90);
INSERT INTO test2 VALUES('117',80,90);

--inner join
SELECT t1.id, t1.name, t1.eng, t2.math, t2.age
FROM test1 t1
JOIN test2 t2 ON t1.id = t2.id;

--left outer join
SELECT t1.id, t1.name, t1.eng, t2.math, t2.age
FROM test1 t1
JOIN test2 t2 ON t1.id = t2.id(+);

--right outer join
SELECT t1.id, t1.name, t1.eng, t2.math, t2.age
FROM test1 t1
JOIN test2 t2 ON t1.id(+) = t2.id;

--full outer join
SELECT t1.id, t1.name, t1.eng, t2.math, t2.age
FROM test1 t1
FULL OUTER JOIN test2 t2 ON t1.id= t2.id;

SELECT ID  FROM test1
WHERE ENG > 80
UNION
SELECT ID FROM test2
WHERE MATH > 70;

SELECT ID  FROM test1
WHERE ENG > 80
UNION ALL
SELECT ID FROM test2
WHERE MATH > 70;

SELECT ID  FROM test1
WHERE ENG > 80
INTERSECT
SELECT ID FROM test2
WHERE MATH > 70;

SELECT ID  FROM test1
WHERE ENG > 80
MINUS
SELECT ID FROM test2
WHERE MATH > 70;

SELECT employee_id, department_name 
FROM employees E 
join departments D on E.department_id=D.department_id 
WHERE employee_id=110;

--Q.사번이 120번인 사람의 사번, 이름, 업무(job_id), 업무명(job_title)을 출력.
--join~on, where 로 조인하는 두 가지 방법 모두.
SELECT E.employee_id, E.last_name, E.job_id, J.job_title
FROM employees E, jobs J
WHERE E.job_id = J.job_id AND E.employee_id = 120;

SELECT employee_id, last_name, E.job_id, job_title
FROM employees E JOIN jobs J ON E.job_id=J.job_id 
WHERE employee_id=120;

SELECT E.employee_id 사번ID
 , E.LAST_NAME
 , J.job_id 업무
 , J.job_title 업무명
FROM employees E, jobs J
WHERE J.job_id IN (SELECT E.job_id FROM employees WHERE J.job_id=E.job_id AND E.employee_id = 120);
--WHERE employee_ID LIKE 120 AND E.job_id = J.job_id;

--세개의 테이블 조인
SELECT employee_id, job_title, department_name 
FROM employees E, jobs J, departments D
WHERE E.job_id = J.job_id
AND E.department_id = D.department_id;

SELECT R.region_name 대륙 , C.country_id 나라, L.street_address 주소
From COUNTRIES C , regions R , LOCations L
where C.country_id = L.country_id 
AND R.region_id = C.region_id;

SELECT E.last_name, L.city, L.street_address 
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE E.department_id = D.department_id AND L.location_id = D.location_id;

select * from employees;

SELECT employee_id, job_title, last_name, hire_date, salary, city, country_id
FROM employees E, jobs J, departments D, locations L
WHERE E.job_id = J.job_id 
AND E.department_id = D.department_id 
AND D.location_id = L.location_id 
AND job_title = 'President';

--self join 하나의 테이블이 두 개의 테이블인 것처럼 조인
SELECT E.employee_id 사번, E.last_name 이름, M.last_name, M.manager_id 부서장
FROM employees E, employees M
WHERE E.employee_id = M.manager_id;

--outer join : 조인 조건에 만족하지 못하더라도 해당 행을 나타내고 싶을 때 사용
SELECT E.employee_id 사번, E.last_name 이름, M.last_name 사원, M.manager_id 부서장
FROM employees E, employees M
WHERE E.employee_id = M.manager_id(+);


-----------------------------------------------------------------------------
	DDL
-----------------------------------------------------------------------------

▶ DDL Data Definition Language
▷ 테이블 생성
    create table 테이블명( 컬럼명 자료형 );

    create table test1 (
	eno number( 4 ),
	ename varchar2( 20 ),
	esal number( 7, 2 )
    );

▷ 테이블 복사
    create table test2 as select * from test1;
    다른 테이블의 구조 뿐아니라 데이터까지 복사해서 새로운 테이블 생성
    기존 테이블의 컬럼만 선택해서 생성할 수도 있다.

▷ 테이블 구조 복사
    create table test3 as select * from test1 where 1=0;
    where 조건절에 거짓 조건을 지정하면 해당 로우를 발견하지 못하기 때문에 
    로우가 없는 빈 테이블을 생성한다.
		
▷ 컬럼 추가하기
    alter table test1 add( email varchar2( 10 ) );
	
▷ 컬럼 변경하기	
    alter table test1 modify( email varchar2( 40 ) );
	
    데이터가 존재할 경우 데이터 타입을 변경할 수 없다. 
    단 char와 varchar2 는 가능하다.
    크기는 기존 데이터보다 같거나 크게 변경만 가능하다.

▷ 컬럼 삭제하기
    alter table test1 drop column email;
	
▷ 컬럼 비활성화
    alter table test1 set unused( email );
    컬럼을 삭제할 경우 사용중일 수도 있기 때문에 
    일단 논리적으로 제한한 후 사용빈도가 적은 시간에 실제 삭제 작업을 한다.
    delete와 같이 다시 사용할 수 없다.

    select * from user_unused_col_tabs;
    컬럼 개수 확인	

    alter table test1 drop unused columns;
    unused column 모두 삭제

▷ 테이블의 모든 로우 삭제
    truncate table test1;
	
▷ 테이블 삭제
    drop table test1;


--[테이블 생성 규칙]

--테이블명은 객체를 의미할 수 있는 적절한 이름을 사용한다. 가능한 단수형을 권고한다.--
--테이블명은 다른 테이블의 이름과 중복되지 않아야 한다.--
--한 테이블 내에서는 칼럼명이 중복되게 지정될 수 없다. --
--테이블 이름을 지정하고 각 칼럼들은 괄호 "( )" 로 묶어 지정한다.--
--각 칼럼들은 콤마" ", 로 구분되고, 항상 끝은 세미콜론 ";"으로 끝난다.--
--칼럼에 대해서는 다른 테이블까지 고려하여 데이터베이스 내에서는 일관성 있게 사용하는 것이 좋다. (데이터 표준화 관점)--
--칼럼 뒤에 데이터 유형은 꼭 지정되어야 한다.--
--테이블명과 칼럼명은 반드시 문자로 시작해야 하고, 벤더별로 길이에 대한 한계가 있다.--
--벤더에서 사전에 정의한 예약어(Reserved word)는 쓸 수 없다.--
--A-Z, a-z, 0-9, _, $, # 문자만 허용된다.


SELECT * FROM TABS;
--MEMBER TABLE 생성
DROP TABLE MEMBER;
CREATE TABLE MEMBER
(
    ID                  VARCHAR2(50),
    PWD             VARCHAR2(50),
    NAME          VARCHAR2(50),
    GENDER      VARCHAR2(50),
    AGE              NUMBER,
    BIRTHDAY  VARCHAR2(50),
    PHONE        VARCHAR2(50),
    REGDATE   DATE
);

--National Language 바이트수
select length('ab') from dual;
select length('한글') from dual;

select lengthb('ab') from dual;
select lengthb('한글') from dual;

SELECT * FROM NLS_DATABASE_PARAMETERS;
--NLS_CHARACTERSET	                        AL32UTF8
--NLS_NCHAR_CHARACTERSET     	AL16UTF16

-- 테이블 삭제
DROP TABLE MEMBER;

--데이터 형식 수정
CREATE TABLE MEMBER(
    ID                  VARCHAR2(50),
    PWD             VARCHAR2(50),
    NAME          VARCHAR2(50),
--    GENDER      CHAR(2),    --남성, 여성, UTF
--    GENDER      CHAR(2 CHAR),   --2개 문자라는 의미
    GENDER      NCHAR(2),  --2개 문자, UTF16을 사용 문자당 2bytes로 처리, 공간 절약
    AGE              NUMBER,
    BIRTHDAY  CHAR(10),     --2000-01-02
    PHONE        CHAR(13),      --010-1234-2345
    REGDATE   DATE
);

--Nchar , Nvarchar2		크기의 단위가 Byte가 아니라 글자수를 나타냄

INSERT INTO MEMBER (GENDER) VALUES('남성');
SELECT LENGTH (GENDER) FROM MEMBER;
SELECT LENGTHB (GENDER) FROM MEMBER;

DESC MEMBER;

-- 대용량 문자 형식
LONG : 최대 2Gbyte, 테이블에서 한번만 사용, 잘 사용하지 않으며 CLOB를 주로 사용
CLOB : 대용량 텍스트 데이터 타입(최대 4Gbyte)
NCLOB : 대용량 텍스트 유니코드 데이터 타입(최대 4Gbyte)

ALTER TABLE MEMBER ADD TEXT NCLOB;
INSERT INTO MEMBER (ID,PWD, TEXT) VALUES('200903','234','정치는 국민을 위해 존재한다');
SELECT * FROM MEMBER;

--NUMBER [ (p [, s]) ] : NUMBER value는 1 to 22 bytes, p는 1 to 38, s는 -84 to 127
--    number (정수 및 실수 모두 포함)
--    number(5) 		-> -99999 ~ 99999
--    number(3) 		-> -999 ~ 999
--    number(5,2) 	-> -999.99 ~ 999.99
--    number(6,3) 	-> -999.999 ~ 999.999

SELECT * FROM TABS;
DESC MEMBER;
DROP TABLE MEMBER;
CREATE TABLE MEMBER(
    ID                  VARCHAR2(50),
    PWD             NVARCHAR2(50),
    NAME          NVARCHAR2(50),
    GENDER      NCHAR(2),  
    AGE              NUMBER(3),
    BIRTHDAY  CHAR(10),    
    PHONE        CHAR(13),      
    REGDATE   DATE
);

--DATE(날짜)                         4712 BC~9999 AD (EX:01-JAN-99)
--TIMESTAMP(시분초)        NLS_TIMESTAMP_FORMAT 파라미터에 명시된 값을 따름  

--CREATE
--테이블 생성
CREATE TABLE MEMBER
(
   ID                          VARCHAR2(50) NOT NULL,
   PWD                     VARCHAR2(50),
   NAME                  VARCHAR2(50),
   GENDER              NCHAR(2),  --글자수
   AGE                      NUMBER,
   BIRTHDAY          CHAR(10),  --2000-01-02 
   PHONE                CHAR(13), --010-1234-2345
   REGDATE           DATE
);
INSERT INTO MEMBER (ID, PWD, NAME) VALUES('200901','111','kevin');

--SELECT 문자을 통한 테이블 생성
CREATE TABLE MEMBER1 AS SELECT * FROM MEMBER;
SELECT * FROM MEMBER1;
DESC MEMBER1;
SELECT * FROM TABS;
--데이터 삽입
INSERT INTO MEMBER1 (ID, PWD, NAME, GENDER) 
VALUES('200902','123','dragon','남성');
SELECT LENGTHB (GENDER) FROM MEMBER;
SELECT * FROM MEMBER1;

--ALTER
--수정 : MODIFY
--Nchar , Nvarchar2	크기의 단위가 Byte가 아니라 글자수를 나타냄
ALTER TABLE MEMBER1 MODIFY( ID NVARCHAR2(50), NAME NVARCHAR2(50));
ALTER TABLE MEMBER1 MODIFY(PWD CONSTRAINT MEMBER1_NN NOT NULL);

--변경: RENAME
ALTER TABLE MEMBER1 RENAME COLUMN BIRTHDAY TO BD;
--삭제: DROP
ALTER TABLE MEMBER1 DROP COLUMN AGE;
--추가: ADD
ALTER TABLE MEMBER1 ADD TEXT NCLOB;
INSERT INTO MEMBER1 (ID,PWD, TEXT) 
VALUES('200903','234','정치는 국민을 위해 존재한다');
SELECT * FROM MEMBER1;
-- 제약조건 추가: ADD CONTRAINT
ALTER TABLE MEMBER1 ADD CONSTRAINT MEMBER_PK PRIMARY KEY (ID);
DESC MEMBER1;
--제약조건 확인: USER_CONSTRAINTS
--CONTRAINT_TYPE이 C이면 NOT_NULL 또는 CHECK라은 의미
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME FROM USER_CONSTRAINTS;
--제약조건 삭제: DROP CONTRAINT
ALTER TABLE MEMBER1 DROP CONSTRAINT MEMBER_PK;
--테이블에 들어있는 모든 행 제거
TRUNCATE TABLE MEMBER1;
SELECT * FROM MEMBER1;

-----------------------------------------------------------------------------
	트랜잭션
-----------------------------------------------------------------------------

--트랜잭션 관리	
--트랜잭션 데이터 처리의 한 단위를 의미한다.
--하나의 트랜잭션은 All-Or-Nothing 방식으로 처리된다.
--여러 개의 명령이 모두 정상적으로 처리되면 정상 종료 하고
--하나라도 비정상적으로 처리되면 모두를 취소한다.
--
--    commit		저장되지 않은 모든 테이터베이스를 저장하고 현재의 트랜잭션을 종료한다.
--			트랜잭션 처리과정이 모두 반영되며 하나의 트랜잭션 과정이 끝난다.
--    savepoint 이름;	현재까지의 트랜잭션을 특정 이름으로 지정하는 명령
--    rollback [to 이름]	저장되지 않은 데이터를 모두 취소하고 트랜잭션을 종료한다.
--			savepoint 로 지정한 위치로 돌아간다.
--	
--    create alter drop 등은 자동 커밋이 발생한다.
  
SELECT * FROM member;

INSERT INTO MEMBER (ID, PWD, NAME) VALUES('200901','111','kevin');
SAVEPOINT SV1;
INSERT INTO member (ID, PWD, NAME, AGE) VALUES('200902','112','james',25);
UPDATE MEMBER SET PWD='121' WHERE NAME='kevin';
UPDATE MEMBER SET PWD='122', AGE='25' WHERE ID='200902'; 
SAVEPOINT SV2;
--ROLLBACK TO SV1;
INSERT INTO member (ID, PWD, NAME, AGE) VALUES('200902','112','james',35);
UPDATE member SET ID='200903', NAME='susan' WHERE AGE=35;
ROLLBACK TO SV1;
ROLLBACK TO SV2;
DELETE member WHERE ID='200901';
DELETE member WHERE ID='200902';
DELETE member WHERE ID='200903';
COMMIT;
-----------------------------------------------------------------------------
	제약 조건 Constraints
-----------------------------------------------------------------------------

무결성 제약 조건
테이블에 부적절한 자료가 입력되는 것을 방지하기 위해 테이블을 생성할 때 컬럼에 정의하는 규칙

not null	해당 컬럼 값으로 NULL을 허용하지 않는다.
unique	해당 컬럼 값은 항상 유일무이한 값을 가진다.
primary key	해당 컬럼 값은 반드시 존재해야 하고 유일해야 한다.
    not null과 unique를 결합한 형태
foreign key	해당 컬럼 값이 타 컬럼의 값을 참조해야 한다.
    참조되는 컬럼에 없는 값은 입력 불가
check	해당 컬럼에 저장 가능한 데이터 값의 범위나 사용자 조건을 지정

제약 조건 확인하기
select * from user_constraints;

P 		primary key
R 		foreign key
C 		check, not null

제약조건 이름은 테이블명_컬럼명_제약 조건 유형 순으로 정한다.
pk		primary key
fk		    foreign key
nn		not null
uk    	unique
ck		check

제약조건 이름 변경
alter table table_name RENAME CONSTRAINTS 
old_constraint_name TO new_constraint_name;

제약 조건 삭제하기	
alter table test drop constraint test1_name_pk;

create table test1 (
id number( 3 ) primary key, 
name varchar2( 10 ) not null,
tel varchar2( 10 ),
address varchar2( 50 )
);

SELECT * FROM test1;
DESC test1;
ALTER TABLE test1 MODIFY name constraint SYS_C0010273 null;
ALTER TABLE test1 DROP  constraint SYS_C0010274;

--not null 제한 조건
--name varchar2(10) constraint test1_name_nn not null,
    
create table test2 (
id number( 3 ) constraint test2_id_pk primary key,
name varchar2(10) constraint test2_name_nn not null,
tel varchar2( 10 ),
address varchar2( 50 )
);
	
DESC test2
ALTER TABLE test2 DROP  constraint test2_name_nn;
ALTER TABLE test2 DROP  constraint test2_id_pk;
    
기존 테이블의 컬럼을 not null 로 변경할 경우는 
alter table ~ add constraint ~을 사용할 수 없다.
not null 조건은 추가하는 것이 아니라 null 인 상태를 not null 로 바꾸는 것이다.

alter table test1 modify name constraint test1_name_nn not null;
     

--기본키 제약 조건
--기본 키 컬럼에는 NULL 값이 올 수 없으며 중복 될 수 없다.   

id varchar2(10) constraint test1_id_pk primary key,	

alter table test1 add constraint test1_id_pk primary key(id);
alter table test1 drop constraint test1_id_pk;

--유일키 제약조건
--UNIQUE 제약 조건을 지정하면 중복 값을 허용하지 않는다. 
--하나의 테이블에 여러 개를 지정할 수 있다.
--단 NULL은 값이 아니기 때문에 여러 개가 가능하다.

name varchar2(10) constraint test2_name_uk unique,

alter table test1 add constraint test1_email_uk unique(email);
alter table test1 drop constraint test1_email_uk;

--check 제한 조건
--데이터를 검사하여 특정 조건에 맞는 데이터만 입력하도록 설정 한다.

age number constraint test1_age_ck check( age between 0 and 150 ),

alter table test1 add constraint test1_sal_ck check( sal between 0 and 20000 );
alter table test1 drop constraint test1_sal_ck;

참조무결성
create table depart (
deno number primary key,
dename varchar2( 30 ) unique
);

부서 테이블에 부서번호가 10 20 30 40이 존재한다면
사원 테이블에 존재하는 부서번호는 반드시 부서 테이블의 부서 번호 내의 번호가 가져야 한다.
이런 경우 사원 테이블이 부서 테이블을 참조하는 종속관계가 성립된다.
사원 테이블은 자식 테이블이 되고 부서 테이블은 부모 테이블이 된다.

사원 테이블의 부서번호 컬럼은 외래키라 하고 부서 테이블의 부서번호 컬럼이 부모키가 된다.
부서번호 컬럼이 부모키가 되려면 UNIQUE 제약 조건으로 지정되어야 한다.

새로 입력되는 사원정보중 부서번호가 부모키에 존재하지 않는 번호라면 
무결성 제약 조건에 위배된다는 에러가 발생한다.

create table test2(
...
deno varchar2(10) references depart( deno ),
...
);
test1 테이블의 deno 컬럼을 참조하는 외래키를 설정한다.
제약 조건명을 붙이지 않을 경우 오라클 서버 제약조건명을 붙인다.

deno varchar2(10) constraint test2_deno_fk references depart( deno ),
제약 조건명을 직접 붙여준다.

alter table test2 add constraint test2_deno_fk foreign key(deno) references depart( deno );

cascade
참조 무결성 제약조건 탓에 기본키를 가진 테이블이 삭제되지 않는 경우는 
맨 뒤에 cascade 옵션을 지정한다.

drop table depart cascade constraint;

select * from user_constraints where table_name = 'DBTEST';
부모키를 가진 테이블이 삭제되면 제약조건도 삭제된다.
    

-----------------------------------------------------------------------------
	Merge
-----------------------------------------------------------------------------

INSERT or UPDATE 구문을 한 쿼리 안에 넣는 MERGE 구문
테이블을 조회해서 같은 데이터가 없을 경우에는 INSERT
같은 데이터가 있을 경우에는 UPDATE

MERGE INTO 테이블명  별칭
USING 대상테이블/뷰  
ON 조인조건
WHEN MATCHED THEN
UPDATE SET
        컬럼1=값1
            컬럼2=값2
WHEN NOT MATCHED THEN
INSERT (컬럼1,컬럼2,...) VALUES (값1,값2,...);    

merge into employees
using dual
on ( salary < 10000 )
when matched then 
update set commission_pct = commission_pct + 0.1;

80번 부서 직원만 존재하는 commission 테이블을 업데이트 하는 경우
employees 테이블의 모든 데이터를 사번으로 비교한 후 변경한다.
연봉이 8000 이하인 경우는 10000으로 변경한다.
이상인 경우는 그대로 입력한다.

create table commission as select employee_id, salary from employees where department_id=80;

merge into commission c
using ( select * from employees ) e
on ( e.employee_id = c.employee_id )
when matched then
update set c.salary = 9999 where e.salary < 8000
when not matched then
insert ( c.employee_id, c.salary ) 
values ( e.employee_id, e.salary ) 

commission 테이블에 존재하는 80번 부서 중 
8000 미만는 10000으로 변경되고
8000 이상은 변경되지 않는다.
employee 테이블에서 존재하는 다른 직원들은 
commission 테이블로 입력된다. 

select * from departments;
select * from employees;

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

--문제: orders 테이블에서 orderdate가 '2020-07-05' 이후인 주문만을 포함하는 뷰 recent_orders를 생성하는 SQL 명령문을 작성하시오.
SELECT * FROM orders;
CREATE VIEW recent_orders AS
SELECT *
FROM orders
WHERE orderdate > '2020-07-05';
SELECT * FROM recent_orders;

create view special_employee as
select * 
from employees
where salary >= 10000;
select * from special_employee;

CREATE VIEW long_term_employees AS
SELECT *
FROM employees
WHERE SYSDATE - hire_date >= 3650;

select * from long_term_employees;

CREATE VIEW department_employee_count AS
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;
select * from department_employee_count;


--* GRANT : 데이터베이스 사용자에게 사용 권한을 부여하는 명령어 이다.
--옵션 GRANT & REVOKE 동일
--CONNECT : 데이터베이스에 접속할 수 있는 기본권한 제공 한다.
--RESOURCE : 기본적인 객체(테이블, 인덱스, 뷰, 클러스트 등) 생성, 변경, 삭제할수 있는 권한 제공 한다.
--
--사용자에게 테이블의 SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER 권한을 부여
--GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON (테이블명) TO 사용자;
--사용자에게?테이블의 모든권한을 부여
--GRANT ALL PRIVILEGES ON (table 명)  TO 사용자명;

--
--* REVOKE?: 사용자에 대한 권한을 회수한다.

--REVOKE 권한이름?ON 소유자명.테이블명 ?FROM 사용자;
--EX) ?REVOKE CONNECT, RESOURCE FROM USER01
--
--* CREATE USER : 사용자 생성(생성된 사용자는 아무런 권한이 없다.)
--CREATE USER 사용자ID
--IDENTIFIED BY 비밀번호

select * from user_sys_privs where username='C##KITA';

CREATE USER C##USER1
IDENTIFIED BY USERPASS;

-- USER1 생성

DROP USER C##USER1;
CREATE USER C##USER1 IDENTIFIED BY pw123;

-- USER1에게 기본적인 접근 권한과 객체 생성 권한 부여
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO C##USER1;

-- USER1로부터 CREATE VIEW 권한 회수
REVOKE CREATE VIEW FROM C##USER1;

-- USER1 삭제
DROP USER C##USER1 CASCADE;

--* GRANT : 시스템 권한
--GRANT 권한이름|롤|PUBLIC
--[WITH ADMIN OPTION]WITH GRANT OPTION]

--권한 종류 확인
SELECT * FROM system privilege_map;
select * from user_sys_privs where username='C##KITA';
--USER01사용자에게 데이터베이스에 연결할 수 있는 권한과 테이블을 생성할 수 있는 권한을 부여
GRANT CREATE SESSION,CREATE TABLE TO C##USER01;

SELECT * FROM all_users;

REVOKE CREATE SESSION,CREATE TABLE FROM C##USER01;

DROP USER C##USER01;

--* 트랜잭션

--트랜잭션은 데이터베이스의 논리적 연산단위이다. 
--트랜잭션(TRANSACTION)이란 밀접히 관련되어 분리될 수 없는 한 개 이상 의 데이터베이스 조작을 가리킨다. 
--하나의 트랜잭션에는 하나 이상의 SQL 문장이 포함된다.
--트랜잭션은 의미적으로 분할할 수 없는 최소의 단위이다.  그렇기 때문에 전부 적용하거나 전부 취소한다. 
--즉, TRANSACTION 은 ALL OR NOTHING ALL OR NOTHING의 개념인 것이다.
--[사례] 계좌이체라는 작업단위는 두개의 스텝이 모두 성공적으로 완료되었을 때 종료된다. 
-- 둘 중 하나라도 실패할 경우 계좌이체는 원래의 금액을 유지하고 있어야만 한다.
--- STEP1. 100번 계좌의 잔액에서 10,000원을 뺀다. 
--STEP2. 200번 계좌의 잔액에 10,000원을 더한다

--TCL (Transaction Control Language)
--COMMIT: 현재 트랜잭션 내에서 수행된 모든 변경(INSERT, UPDATE, DELETE 등)을 데이터베이스에 영구적으로 저장.
--COMMIT 명령을 실행하면, 트랜잭션은 완료되며, 그 이후에는 변경 사항을 되돌릴 수 없다.
--ROLLBACK: 현재 트랜잭션 내에서 수행된 변경들을 취소하고, 데이터베이스를 트랜잭션이 시작하기 전의 상태로 되돌린다. 
--오류가 발생했거나 다른 이유로 트랜잭션을 취소해야 할 경우에 사용된다.
--SAVEPOINT: 트랜잭션 내에서 중간 체크포인트를 생성합니다. 오류가 발생할 경우, ROLLBACK을 사용하여 최근의 SAVEPOINT까지 되돌릴 수 있다.
--트랜잭션을 콘트롤하는 TCL(TRANSACTION CONTROL LANGUAGE)

--업무적인 단위 : 계좌이체
 
User
members라는 테이블을 생성하고 적합한 속성 5개를 설정하여 데이터를 입력하고 그중 3개의 데이터를 수정해줘.
수정한 데이터를 취소하기 위하요 롤백을 사용해줘.
2개의 데이터를 추가로 입력하는데 커밋하기전에 마지막 입력한 데이터는 취소하고 커밋해줘.
위의 내용을 코드로 작성해줘

-- members 테이블 생성
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    join_date DATE,
    status VARCHAR2(20)
);

-- 데이터 입력
INSERT INTO members (member_id, name, email, join_date, status) VALUES (1, 'John Doe', 'john@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (2, 'Jane Doe', 'jane@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (3, 'Mike Smith', 'mike@example.com', SYSDATE, 'Inactive');
select * from members;
commit;
-- 데이터 수정
UPDATE members SET status = 'Inactive' WHERE member_id = 1;
UPDATE members SET status = 'Inactive' WHERE member_id = 2;
UPDATE members SET status = 'Active' WHERE member_id = 3;

-- 롤백을 사용하여 수정 취소
ROLLBACK;

-- 2개의 데이터 추가
INSERT INTO members (member_id, name, email, join_date, status) VALUES (4, 'Alice Johnson', 'alice@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (5, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');


-- 이 지점에서 SAVEPOINT 설정
SAVEPOINT sp1;

-- 두 번째 데이터 추가
INSERT INTO members (member_id, name, email, join_date, status) VALUES (6, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');

-- 마지막 입력만 롤백 (SAVEPOINT sp1로 되돌아감)
ROLLBACK TO sp1;

-- 첫 번째 추가 데이터에 대한 변경사항을 커밋
COMMIT;

문제:

orders라는 테이블을 생성하고, order_id, customer_id, order_date, amount, status라는 속성을 설정하세요.
데이터를 5개 입력하세요.
입력한 데이터 중 2개를 수정하세요.
수정한 데이터를 취소하기 위해 롤백을 사용하세요.
3개의 새로운 데이터를 입력하고, 그 중 마지막 데이터 입력만 취소한 후 나머지를 커밋하세요.





-Q1. HR EMPLOYEES 테이블에서 이름, 연봉, 10% 인상된 연봉을 출력하세요.
--A.
SELECT FIRST_NAME, SALARY, SALARY*1.1 UPSALARY FROM EMPLOYEES;
    
--Q2.  2005년 상반기에 입사한 사람들만 출력	
--A.        
SELECT * FROM EMPLOYEES WHERE HIRE_DATE BETWEEN '05/01/01' AND '05/06/30';  

--Q3. 업무 SA_MAN, IT_PROG, ST_MAN 인 사람만 출력
--A.
SELECT * FROM EMPLOYEES WHERE JOB_ID IN('SA_MAN','IT_PROG','ST_MAN');
   
--Q4. manager_id 가 101에서 103인 사람만 출력
--A.   	
select * from employees where manager_id between 101 and 103;

--Q5. EMPLOYEES 테이블에서 LAST_NAME, HIRE_DATE 및 입사일의 6개월 후 첫 번째 월요일을 출력하세요.
--A.
select last_name, hire_date, next_day( add_months( hire_date, 6 ), '월' ) "TARGET" from employees;

--Q6. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME, SALARY, HIRE_DATE 및 입사일 기준으로 현재일까지의 W_MONTH(근속월수)를 정수로 계산해서 출력하세요.(근속월수 기준 내림차순)
--A.
select employee_id, last_name, salary, hire_date, 
trunc((months_between(sysdate, hire_date))) 
w_month from employees order by w_month desc;

--Q7. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME, SALARY, HIRE_DATE 및 입사일 기준으로 W_YEAR(근속년수)를 계산해서 출력하세요.(근속년수 기준 내림차순)
--A.
select employee_id, last_name, salary, hire_date,  
trunc( ( sysdate - hire_date ) / 365 ) w_year 
from employees order by w_year desc; 

--Q8. EMPLOYEE_ID가 홀수인 직원의 EMPLPYEE_ID와 LAST_NAME을 출력하세요.
--A. 
select employee_id, last_name from employees where mod( employee_id, 2 )= 1;

--Q9. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME 및 M_SALARY(월급)을 출력하세요. 단 월급은 소수점 둘째자리까지만 표현하세요.
--A
select employee_id, last_name, round( salary/12, 2 ) m_salary from employees;  

--Q10. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME, SALARY, HIRE_DATE 및 입사일 기준으로 근속년수를 계산해서 아래사항을 추가한 후에 출력하세요.
--2001년 1월 1일 창업하여 현재까지 20년간 운영되온 회사는 직원의  근속년수에 따라 30 등급으로 나누어  등급에 따라 1000원의 BONUS를 지급.
--내림차순 정렬.    
--A.
select employee_id, last_name, salary, hire_date,
trunc( ( ( to_date('20/12/31') - hire_date ) / 365)) 근속연수,
(width_bucket( trunc( ( to_date('20/12/31') - hire_date ) / 365),0,20,30)) wb,
(width_bucket( trunc( ( to_date('20/12/31') - hire_date ) / 365),0,20,30))  * 1000 bonus
from employees
order by bonus desc;  

--20개 보너스 등급 적용시
select employee_id, last_name, salary, hire_date, trunc( ( sysdate - hire_date ) / 365) 근속연수,
trunc(( sysdate - hire_date ) / 365) 등급,(width_bucket( trunc( ( sysdate - hire_date ) / 365),0,22,20)) wb,
(width_bucket( trunc( ( sysdate - hire_date ) / 365),0,22,20))  * 1000 bonus_wb,
trunc(( sysdate - hire_date ) / 365) * 1000 bonus_등급
from employees order by bonus_wb desc;



--Q11. EMPLOYEES 테이블에서 commission_pct 의  Null값 갯수를  출력하세요.
--A.
SELECT count(*) FROM employees
WHERE commission_pct is null;

--Q12. EMPLOYEES 테이블에서 deparment_id 가 없는 직원을 추출하여  POSITION을 '신입'으로 출력하세요.
--A.
select last_name, department_id, nvl(to_char(department_id),'신입') position
from employees where department_id is null;


--Q13. 사번이 120번인 사람의 사번, 이름, 업무(job_id), 업무명(job_title)을 출력(join~on, where 로 조인하는 두 가지 방법 모두)
--A.
select e.employee_id, e.last_name, j.job_id, j.job_title from employees e
join jobs j on e.job_id=j.job_id where employee_id=120;

select  e.employee_id, e.last_name, j.job_id, j. job_title from employees e, jobs j
where e.job_id=j.job_id and employee_id = 120;

--Q14.  employees 테이블에서 이름에 FIRST_NAME에 LAST_NAME을 붙여서 'NAME' 컬럼명으로 출력하세요.
--예) Steven King
--A. 
SELECT FIRST_NAME || ' ' || LAST_NAME NAME FROM EMPLOYEES;

--Q15. lmembers purprod 테이블로 부터 총구매액, 2014 구매액, 2015 구매액을 한번에 출력하세요.
select (select sum(p1.구매금액) from purprod p1)  as amt,
(select sum(p2.구매금액) from purprod p2 where p2.구매일자 <20150101) as amt_2014,
(select sum(p3.구매금액) from purprod p3 where p3.구매일자 >20141231) as amt_2015
from dual;

--Q16. HR EMPLOYEES 테이블에서 escape 옵션을 사용하여 아래와 같이 출력되는 SQL문을 작성하세요.
--job_id 칼럼에서  _을 와일드카드가 아닌 문자로 취급하여 '_A'를 포함하는  모든 행을 출력
--A.
-- _을 와일드카드가 아닌 문자로 취급하고 싶을 때 escape 옵션을 사용한다. \다음에 값('_')을 특수문자로 필터링
select * from employees where job_id like '%\_A%' escape '\';

--Q17. HR EMPLOYEES 테이블에서 SALARY, LAST_NAME 순으로 올림차순 정렬하여 출력하세요.
--A. 
select SALARY, LAST_NAME from employees order by salary asc, last_name asc;

   
--Q18. Seo라는 사람의 부서명을 출력하세요.
--A.
select department_name from departments 
where department_id=(select department_id from employees where last_name='Seo');     

--Q19. LMEMBERS 데이터에서 고객별 구매금액의 합계를 구한 CUSPUR 테이블을 생성한 후 CUSTDEMO 테이블과 
--고객번호를 기준으로 결합하여 출력하세요.
CREATE TABLE CUSPUR
AS SELECT 고객번호, SUM(구매금액) 구매금액
FROM PURPROD
GROUP BY 고객번호
ORDER BY 고객번호;
SELECT * FROM CUSPUR;


--CUST와 CUSPUR 고객번호 기준 결합
SELECT C.*, CP.구매금액
FROM CUSTDEMO C, CUSPUR CP
WHERE C.고객번호 = CP.고객번호;

--Q20.PURPROD 테이블로 부터 아래 사항을 수행하세요.
-- 2년간 구매금액을 연간 단위로 분리하여 고객별, 제휴사별로 구매액을 표시하는 AMT_14, AMT_15 테이블 2개를 생성 (출력내용 : 고객번호, 제휴사, SUM(구매금액) 구매금액)
--AMT14와 AMT15 2개 테이블을 고객번호와 제휴사를 기준으로 FULL OUTER JOIN 적용하여 결합한 AMT_YEAR_FOJ 테이블 생성
--14년과 15년의 구매금액 차이를 표시하는 증감 컬럼을 추가하여 출력(단, 고객번호, 제휴사별로 구매금액 및 증감이 구분되어야 함)

SELECT * FROM PURPROD
WHERE YEAR <2015;
DESC PURPROD;

CREATE TABLE AMT14
AS SELECT 고객번호, 제휴사, SUM(구매금액) 구매금액 
FROM PURPROD
WHERE 구매일자 < 20150101
GROUP BY 고객번호, 제휴사
ORDER BY 고객번호;

select * from amt14;

CREATE TABLE AMT15
AS SELECT 고객번호, 제휴사, SUM(구매금액) 구매금액 
FROM PURPROD
WHERE 구매일자 > 20141231
GROUP BY 고객번호, 제휴사
ORDER BY 고객번호;

select * from amt15;

--FULL OUTER JOIN 테이블 생성
CREATE TABLE AMT_YEAR_FOJ
AS SELECT A4.고객번호, A4.제휴사, A4.구매금액 구매14, A5.구매금액 구매15
FROM AMT14 A4 FULL OUTER JOIN AMT15 A5
ON (A4.고객번호=A5.고객번호 AND A4.제휴사=A5.제휴사);

--FULL OUTER JOIN 적용시 증감 출력
SELECT 고객번호,제휴사, NVL(구매14,0) 구매14, NVL(구매15,0) 구매15,
(NVL(구매15,0)-NVL(구매14,0)) 증감
FROM AMT_YEAR_FOJ A;

DROP TABLE amt14;
DROP TABLE amt15;
DROP TABLE AMT_YEAR_FOJ;

--Q(BONUS). HR 테이블들을 분석해서 전체 현황을 설명할 수 있는 요약 테이블을 작성하세요. (예 : 부서별 평균 SALARY 순위)
--A.
부서별 평균 SALARY 순위
SELECT d.DEPARTMENT_NAME, ROUND(AVG(e.SALARY)) AVG
FROM DEPARTMENTS d, EMPLOYEES e
WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
ORDER BY AVG DESC;




# hackerrank 문제 풀지 못함
# 1. set을 통해 object를 만들어 활용할 수 있음.
# 2. 자동적으로 row을 순회하는 sql 특성상 case 구문으로 생성한 object를 조건에 맞춰 업데이트를 할 수 있음.
set @D = 0, @P = 0, @S = 0, @A = 0 ; # case when을 통해 직업별 컬럼을 만들 때 해당 row에 부여할 object 생성

select min(Doctor), min(Professor), min(Singer), min(Actor)
from (
select case when occupation = 'Doctor' then name end as Doctor, # 해당 column은 table의 모든 row를 대상으로 occupation이 Doctor면 이름을 출력 아니면 Null값을 가짐
       case when occupation = 'Professor' then name end as Professor,
       case when occupation = 'Singer' then name end as Singer,
       case when occupation = 'Actor' then name end as Actor,
       case
            when occupation = 'Doctor' then (@D := @D + 1)
            when occupation = 'Professor' then (@P := @P + 1)
            when occupation = 'Singer' then (@S := @S + 1)
            when occupation = 'Actor' then (@A := @A + 1)
       end as Rownumber # 해당 row의 occupation에 따라 object를 +1 업데이트하며 반환
from OCCUPATIONS
order by name
) sub
group by Rownumber # Rownumber를 통해 grouping 하여 row 개수 

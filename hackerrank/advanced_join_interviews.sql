# 코드가 돌아가지 않아 예제 데이터를 생성하여 답을 도출하였음.
# 코드가 너무 해비하여 그런가 싶었는데 구글링을 통해 얻은 다른 답안을 제출하여도 제출되지 않았음.

########################################################################################################################################################### 테이블 생성
# 문제풀이가 주요 목적이라 table의 primary key 등 columns 의 제약은 신경쓰지 않았다.

create table contests(
	contest_id integer,
    hacker_id integer,
    name varchar(100)
) ;

create table colleges(
	college_id integer,
    contest_id integer
);


create table challenges(
	challenge_id integer,
    college_id integer
);

create table view_stats(
	challenge_id integer,
    total_views integer,
    total_unique_views integer
);

create table submission_stats(
	challenge_id integer,
    total_submissions integer,
    total_accepted_submissions integer
);


insert into contests values
(66406,17973, 'Rose'), (66556, 79153, 'Angela'), (94828, 80275, 'Frank');

insert into colleges values
(11219, 66406), (32473, 66556), (56685, 94828);

insert into challenges values
(18765, 11219), (47127, 11219), (60292, 32473), (72974, 56685);

insert into view_stats values
(47127, 26, 19), (47127, 15, 14),
(18765, 43, 10), (18765, 72, 13),
(75516, 35, 17),
(60292, 11, 10),
(72974, 41, 15),
(75516, 75, 11);

insert into submission_stats values
(75516, 34, 12),
(47127, 27, 10), (47127, 56, 18),
(75516, 74, 12), (75516, 83, 8),
(72974, 68, 24), (72974, 82, 14),
(47127, 28, 11);


############################################################################################################################################################ 1차 풀이


select contests.*,
       ifnull(sum(total_submissions),0) a,                         # <- left join을 하다보면 NUll 값이 나온다. 
       ifnull(sum(total_accepted_submissions),0) b,                #    null을 그냥 sum하면 null이 나오기 때문에 0으로 바꿔준다.
       ifnull(sum(total_views),0) c,
       ifnull(sum(total_unique_views),0) d
from contests 
left join colleges
	on contests.contest_id = colleges.contest_id                     # 아무리 찾아봐도 다중 join을 손쉽게 하는 방법이 보이지 않는다. 아쉽다.
left join challenges
	on colleges.college_id = challenges.college_id
left join view_stats as views
	on challenges.challenge_id = views.challenge_id
left join submission_stats as submissions
	on challenges.challenge_id = submissions.challenge_id
group by contest_id
having a+b+c+d != 0
order by contest_id;

# output 
# 66406	17973	Rose	222	78	238	122 # <- 오답
# 66556	79153	Angela	0	0	11	10  # <- 정답
# 94828	80275	Frank	150	38	82	30  # <- 오답      # (contests, colleges, challenges) table 과 views, submissions table이 N:N 관계이다 보니 문제가 생기는
                                                                   # 것으로 보인다.
                                                                   
                                                                   
########################################################################################################################################################## 문제점 확인


select *
from
	(select contests.contest_id, hacker_id, name, colleges.college_id, challenges.challenge_id
	 from contests, colleges, challenges
	 where contests.contest_id = colleges.contest_id
		 and colleges.college_id = challenges.college_id) as A 
left join view_stats as view
	on A.challenge_id = view.challenge_id;
  
# output #######################################
# 66406	17973	Rose	  11219	18765	18765	72	13 #                     <- 보면 A와 view를 조인할 때 challenge_id가 즐어나는 것을 볼 수 있음.
# 66406	17973	Rose	  11219	18765	18765	43	10 #                        여기서 submission을 추가하면 x 2 가 되어 1차 풀이 결과가 나오는 것을 확인. 
# 66406	17973	Rose	  11219	47127	47127	15	14 #
# 66406	17973	Rose	  11219	47127	47127	26	19 #
# 65556	79153	Angela	  32473	60292	60292	11	10 #
# 94828	80275	Frank	  56685	72974	72974	41	15 # 
################################################  
  
########################################################################################################################################################### 최종 답안

select A.contest_id,
       A.hacker_id,
       A.name,
       ifnull(sum(a),0) as a,
       ifnull(sum(b),0) as b,
       ifnull(sum(c),0) as c,
       ifnull(sum(d),0) as d
from
	 (select contests.contest_id, hacker_id, name, colleges.college_id, challenges.challenge_id   
	 from contests, colleges, challenges
	 where contests.contest_id = colleges.contest_id
	 and colleges.college_id = challenges.college_id) as A 
left join (select challenge_id,
	          sum(total_submissions) as a,                 # <- 해결책은 submission, view table에서 계산하고 A table과 1:1 관계 or 1:0 관계를 만들어야 했다.
	          sum(total_accepted_submissions) as b         #    N:N 관계에서 Join을 하는 것은 주의해야하는 것을 다시 한 번 느낀 문제엿다.
           from submission_stats
	   group by challenge_id) as submission
	       on A.challenge_id = submission.challenge_id
left join (select challenge_id,
		  sum(total_views) as c,
		  sum(total_unique_views) as d
	   from view_stats
	   group by challenge_id) as view
	   on A.challenge_id = view.challenge_id
group by A.contest_id
having a + b + c + d != 0
order by A.contest_id;
  




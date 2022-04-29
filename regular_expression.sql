# hackerrank sql question


# eureka 1. 첫글자와 끝글자가 aeiou로 끝나는 city를 출력하라.

SELECT DISTINCT(CITY)
FROM STATION
WHERE CITY REGEXP('^[aeiou].*[aeiou]$');

#

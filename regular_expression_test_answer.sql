----- 문제

-- 박민수가 예약한 기차명과, 좌석넘버 출력해줘
SELECT r.customer_name, t.train_name, r.seat_number
FROM reservations r
JOIN trains t ON r.train_id = t.train_id
WHERE r.customer_name = '박민수';

SELECT r.customer_name, t.train_name, r.seat_number
FROM reservations r
JOIN trains t ON r.train_id = t.train_id
WHERE r.customer_name REGEXP '^박민수$';


-- 이메일로 한메일을 사용하는 사용자의 정보를 출력해주세요.
select * 
from reservations
where customer_email like '%@hanmail.net';

SELECT * 
FROM reservations
WHERE customer_email REGEXP '@hanmail\.net$';


-- 기차가 시간이 지연되었습니다.
-- 기차가 10시 이후 기차부터 모든 기차의 출발 시간과 도착시간을 30분씩 미뤄서 검색해보세요.
SELECT 
    ADDDATE(departure_time, INTERVAL 30 MINUTE) AS new_departure_time,
    ADDDATE(arrival_time, INTERVAL 30 MINUTE) AS new_arrival_time
FROM trains
WHERE TIME(departure_time) >= '10:00:00';

SELECT train_name, departure_station, arrival_station,
    ADDDATE(departure_time, INTERVAL 30 MINUTE) AS new_departure_time,
    ADDDATE(arrival_time, INTERVAL 30 MINUTE) AS new_arrival_time
FROM trains
WHERE departure_time REGEXP '\\d{4}-\\d{2}-\\d{2} (1[0-9]|2[0-3]):\\d{2}:\\d{2}';


-- 9시 이전(9시 포함) 출발 열차의 예약자 연락처 찾기
SELECT r.*, t.departure_time 
FROM reservations r
JOIN trains t ON r.train_id = t.train_id
WHERE HOUR(t.departure_time) BETWEEN 0 AND 9;

SELECT r.*, t.departure_time 
FROM reservations r
JOIN trains t ON r.train_id = t.train_id
WHERE t.departure_time REGEXP '^\\d{4}-\\d{2}-\\d{2} 0[0-9]:';


-- 기차 이름과 부산 도착 열차의 출발역 및 중간 정차역을 출력해주세요.
SELECT DISTINCT t.train_name, tr.station_name 
FROM train_routes tr
JOIN trains t ON tr.train_id = t.train_id 
WHERE t.arrival_station = '부산'
  AND tr.station_name != '부산';

SELECT DISTINCT t.train_name, tr.station_name
FROM train_routes tr
JOIN trains t ON tr.train_id = t.train_id
WHERE t.arrival_station = '부산'
  AND tr.station_name REGEXP '^(?!부산$).*$';


-- 'KTX' 열차 중 서울에서 출발하여 부산에 도착하는 열차의 모든 정차역을 순서대로 나열하세요. 단, 열차 이름에 숫자가 홀수인 열차만 선택하세요.
-- SELECT t.train_id, t.train_name, tr.station_order, tr.station_name,
--            t.departure_time, t.arrival_time
-- FROM trains t
-- JOIN train_routes tr ON t.train_id = tr.train_id
-- WHERE t.train_name REGEXP '^KTX-[13579]'
--       AND t.departure_station = '서울'
--       AND t.arrival_station = '부산'
      

-- 기차 출발역가 아닌 중간 정차역에서 탑승하는 사람을 검색하시요.
SELECT r.*
FROM reservations r
JOIN trains t ON r.train_id = t.train_id
WHERE r.departure_station != t.departure_station;

SELECT r.*
FROM reservations r
JOIN trains t ON r.train_id = t.train_id
WHERE r.departure_station NOT REGEXP CONCAT('^', t.departure_station, '$');


-- 역 이름에서 '산'이라는 글자가 들어가지 않는 기차역 이름들을 출력
SELECT DISTINCT station_name
FROM train_routes
WHERE station_name NOT LIKE '%산%';

SELECT DISTINCT station_name
FROM train_routes
WHERE station_name NOT REGEXP '산';

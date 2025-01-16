use train;


-- 기차 추가
INSERT INTO trains (train_name, departure_station, arrival_station, departure_time, arrival_time) VALUES
('KTX-101', '서울', '부산', '2025-01-16 08:00:00', '2025-01-16 11:00:00'),
('KTX-202', '서울', '광주', '2025-01-16 09:00:00', '2025-01-16 12:00:00'),
('SRT-303', '대전', '부산', '2025-01-16 10:00:00', '2025-01-16 13:00:00'),
('SRT-404', '대전', '부산', '2025-01-17 08:00:00', '2025-01-16 12:00:00'),
('KTX-505', '서울', '부산', '2025-01-17 11:00:00', '2025-01-16 14:00:00');


-- 기차 경로 추가
INSERT INTO train_routes (train_id, station_order, station_name) VALUES
(1, 1, '서울'),
(1, 2, '대전'),
(1, 3, '부산'),
(2, 1, '서울'),
(2, 2, '대전'),
(2, 3, '광주'),
(3, 1, '대전'),
(3, 2, '대구'),
(3, 3, '부산'),
(4, 1, '대전'),
(4, 2, '대구'),
(4, 3, '경주'),
(4, 4, '울산'),
(4, 5, '부산'),
(5, 1, '서울'),
(5, 2, '천안'),
(5, 3, '대전'),
(5, 4, '부산');



-- 예약자 추가
INSERT INTO reservations (train_id, customer_name, customer_email, contact_number, seat_number, departure_station, arrival_station) VALUES
(1, '김철수', 'kimcs@gmail.com', '010-1234-5678', 'A1', '서울', '대전'),
(1, '이영희', 'leeyh@naver.com', '010-8765-4321', 'A2', '대전', '부산'), -- 좌석 A2로 수정
(2, '박민수', 'parkms@gmail.com', '010-2345-6789', 'B1', '서울', '광주'),
(3, '최지영', 'choijy@hanmail.net', '010-3456-7890', 'C1', '대전', '부산'),
(3, '홍길동', 'honggd@hanmail.net', '010-4567-8901', 'C2', '대전', '대구'), -- 좌석 C2로 수정
(4, '정은지', 'jungej@gmail.com', '010-5678-1234', 'D1', '대전', '대구'),
(4, '김도윤', 'kimdy@naver.com', '010-6789-2345', 'D2', '대구', '울산'),
(4, '이서준', 'leesj@hanmail.net', '010-7890-3456', 'D3', '울산', '부산'),
(5, '박소현', 'parksy@gmail.com', '010-8901-4567', 'E1', '서울', '천안'),
(5, '한지민', 'hanjm@naver.com', '010-9012-5678', 'E2', '천안', '대전'),
(5, '이준호', 'leejh@gmail.com', '010-1234-6789', 'E3', '대전', '부산');


select *
from reservations;
CREATE database train;

show tables;

use train;
DROP TABLE train_routes;
DROP TABLE reservations;
DROP TABLE trains;

-- 기차 테이블 생성
CREATE TABLE trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,         -- 기차 ID
    train_name VARCHAR(50) NOT NULL,                -- 기차 이름
    departure_station VARCHAR(50) NOT NULL,         -- 출발역
    arrival_station VARCHAR(50) NOT NULL,           -- 도착역
    departure_time DATETIME NOT NULL,               -- 출발 시간
    arrival_time DATETIME NOT NULL,                 -- 도착 시간
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 수정 시간
);

-- 기차 이름 중복 방지
ALTER TABLE trains 
ADD CONSTRAINT unique_train_name 
UNIQUE (train_name);

-- 기차 구간 테이블 생성
CREATE TABLE train_routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,   -- 노선 ID
    train_id INT NOT NULL,                     -- 기차 ID
    station_order INT NOT NULL,                -- 역 순서 (경유 순서)
    station_name VARCHAR(50) NOT NULL,         -- 역 이름
    FOREIGN KEY (train_id) REFERENCES trains(train_id) ON DELETE CASCADE
);

-- 예약 테이블 생성
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,  -- 예약 ID
    train_id INT NOT NULL,                          -- 기차 ID
    customer_name VARCHAR(50) NOT NULL,             -- 예약자 이름
    customer_email VARCHAR(100) NOT NULL,           -- 예약자 이메일
    contact_number VARCHAR(15) NOT NULL,            -- 연락처
    seat_number VARCHAR(10) NOT NULL,               -- 좌석 번호
    departure_station VARCHAR(50) NOT NULL,         -- 출발역
    arrival_station VARCHAR(50) NOT NULL,           -- 도착역
    reservation_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- 예약 날짜
    FOREIGN KEY (train_id) REFERENCES trains(train_id) ON DELETE CASCADE
);

-- 특정 기차에서 좌석, 출발역, 도착역 중복 방지
ALTER TABLE reservations 
ADD CONSTRAINT unique_reservation_per_seat 
UNIQUE (train_id, seat_number, departure_station, arrival_station);

-- 동일한 고객이 동일한 기차에서 중복 예약 방지
ALTER TABLE reservations 
ADD CONSTRAINT unique_customer_reservation 
UNIQUE (train_id, customer_email, departure_station, arrival_station);


show tables;
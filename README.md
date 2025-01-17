# 🚆Going Home
### 기차 예약 시스템 데이터베이스
<br>

## 🚦목차

1. 🖥️프로젝트 소개 
2. 📒설계  
      2-1. 개발 환경  
      2-2. 아키텍처  
      2-3.  테이블 설계   
3. 💻개발  
      3-1. 데이터베이스 생 및 사용자 생성  
      3-2. 테이블 생성(DDL)  
      3-3. 생성형 AI 사용하여 더미데이터 생성 후 데이터 삽입  
4. 💡정규 표현식 활용  
      4-1. 정규표현식 기초 문법 정리  
      4-2. 실습 예제  
5. 💣트러블 슈팅 
6. 🤔고찰 
<br>

# 1. 🖥️프로젝트 소개

### 프로젝트 소개

- 정차역을 고려한 기차 예약 시스템의 데이터베이스를 설계하고, 이를 바탕으로 정규 표현식을 연습하기 위한 프로젝트입니다.

### 배경

- 설 연휴 기차표 예매 과정에서, 기차 예약 시스템 구조에 대해 궁금증이 생겼습니다.
- DB를 설계를 통해 예약 시스템을 이해하고 구성한 DB를 기반으로 SELECT문과 정규 표현식 예제를 작성하여 SQL을 깊이 있게 이해하고자 했습니다.

### 팀원 소개

|                                         강릉                                         |                                        당진                                         |                                         대전                                         |                                        천안                                        |
|:---------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------:|
| <img src="https://avatars.githubusercontent.com/u/165532198?v=4" width=200px alt="김소연"> | <img src="https://avatars.githubusercontent.com/u/103468518?v=4" width=200px alt="김창성"> | <img src="https://avatars.githubusercontent.com/u/193213283?v=4" width=200px alt="박진현"> | <img src="https://avatars.githubusercontent.com/u/123963462?v=4" width=200px alt="어태"> |
|                          [김소연](https://github.com/ssoyeonni)                           |                           [김창성](https://github.com/kcs19)                            |                           [박진현](https://github.com/jinhyunpark929)                            |                          [어태규](https://github.com/EOTAEGYU)                           |

---
<br>

# 2. 📒설계

## 2-1. 개발 환경

- Ubuntu 24.04.1
- mysq 8.0.40
- DBeaver

## 2-2. 아키텍처
<img src="https://github.com/user-attachments/assets/9ca7ab5a-11cb-40fc-9d1c-a76e84872206" width ="800">


## 2-3. ERD 설계

## table 목록

- trains - 기차 기본 정보
- train_routes - 기차 노선 정보
- reservations - 예약 정보
<img src="https://github.com/user-attachments/assets/24f92fb7-cd62-42fe-a777-c5add1f1a76f" width ="400">

- 기차 예약의 기능을 위해 기차 정보(trains)와 예약 정보(reservations)를 저장하는 두 개의 기본 테이블을 설계하였습니다.
- 같은 출발지와 목적지를 가진 기차들이 서로 다른 정차역을 경유할 수 있다는 점을 고려하여, 별도의 노선 테이블(train_routes)을 추가하였고, train_routes 테이블의 도입으로 전체 노선 중 승객이 원하는 일부 구간만을 예약할 수 있습니다.

### trains

 각 기차에 대한 기본 정보가 저장되어 있습니다.

| **칼럼명** | **설명** | **데이터 타입** |
| --- | --- | --- |
| train_id | 기차 ID | INT |
| train_name | 기차 이름 | VARCHAR(50) |
| departure_station | 출발역 | VARCHAR(50) |
| arrival_station | 도착역 | VARCHAR(50) |
| departure_time | 출발 시간 | DATETIME |
| arrival_time | 도착 시간 | DATETIME |
| created_at | 생성 시간 | TIMESTAMP |
| updated_at | 수정 시간 | TIMESTAMP |
- CONSTRAINS
    - primary key : train_id
    

### train_routes

기차가 경유하는 모든 역에 대한 정보가 저장되어 있습니다.

| **칼럼명** | **설명** | **데이터 타입** |
| --- | --- | --- |
| route_id | 노선 ID | INT |
| train_id | 기차 ID | INT |
| station_order | 역 순서 | INT |
| station_name | 역 이름 | VARCHAR(50) |
- CONSTRAINS
    - primary key : route_id
    - foreign key : train_routes table의 train_id → trains table의 train_id 참조
    

### reservations

사용자가 기차를 예약한 정보가 저장되어 있습니다.

| **칼럼명** | **설명** | **데이터 타입** |
| --- | --- | --- |
| reservation_id | 예약 ID | INT |
| train_id | 기차 ID | INT |
| customer_name | 예약자 이름 | VARCHAR(50) |
| customer_email | 예약자 이메일 | VARCHAR(100) |
| contact_number | 연락처 | VARCHAR(15) |
| seat_number | 좌석 번호 | VARCHAR(10) |
| departure_station | 출발역 | VARCHAR(50) |
| arrival_station | 도착역 | VARCHAR(50) |
| reservation_date | 예약 날짜 | DATETIME |
- CONSTRAINS
    - primary key : reservation_id
    - foreign key : reservations table 의 train_id → trains table 의 train_id 참조

---
<br>

# 3. 🧑‍💻개발

## 3-1. 데이터베이스 생성 및 사용자 생성

### **1. MySQL에 접속**

MySQL 서버에 접속합니다.

```bash
mysql -u <username> -p
```

- `<username>`: MySQL 사용자 이름 (`root` 또는 다른 사용자 계정)
- 비밀번호를 입력하면 MySQL 프롬프트로 진입합니다.

### 2. train 데이터 베이스 생성

```sql
CREATE DATABASE train
```

- 데이터베이스 생성 후 데이터베이스 목록을 확인합니다.

```sql
SHOW DATABASES;
```

### 3. 팀원 계정 생성

`CREATE USER` 명령어를 사용하여 새로운 계정을 생성합니다.

```sql
CREATE USER 'username'@'%' IDENTIFIED BY 'password';

```

- **`username`**: 새 계정 이름
- **`%`**: 모든 IP 주소에서 접속 가능하도록 설정, 특정 IP만 허용하려면 `'192.168.0.100'`처럼 지정
- **`password`**: 새 계정의 비밀번호

### 4. 권한 부여

새 계정에 MySQL **최고 권한**을 부여합니다.

```sql
GRANT ALL PRIVILEGES ON *train* TO 'username'@'%';
```

- **`*train*`**: train 데이터베이스 대해 권한 부여
- `GRANT ALL PRIVILEGES` 의 역할
    - **데이터베이스 작업 권한**
    - **스키마 작업 권한**
    - **관리 작업 권한**

**변경된 사항 적용!!!(중요)**

```sql
FLUSH PRIVILEGES;
```

#### 조회만 가능한 테스트 계정 생성
```sql
CREATE USER 'test01'@'%' IDENTIFIED BY 'test01';
GRANT SELECT ON train.* TO '%'@'localhost';
FLUSH PRIVILEGES;
```

### 5. DBeaver에서 외부 접속 확인하기

1. 데이터베이스가 실행중인 PC 터미널에서 `ip config` 명령을 통해 ip 주소를 조회합니다.
<img src="https://github.com/user-attachments/assets/5c1e5a52-3e41-48a1-8e84-e882df10476b" width ="600">

1. 외부 접속을 위해 포트 포워딩 규칙을 추가하고 호스트 IP 주소에 조회한 IP 주소를 입력합니다.

<img src="https://github.com/user-attachments/assets/f0749d1a-c242-43be-96bc-3b969551296b" width ="600">

1. DBeaver 에서 IP 주소와 사용자 계정, 비밀번호 입력 후 Test Connection을 눌러 외부 접속이 되는지 확인합니다. 성공!!!
<img src="https://github.com/user-attachments/assets/168cbffc-0b39-4c42-8148-40f61e114d0a" width ="600">
<br>

## 3-2. 테이블 생성

설계한 테이블의 DDL 문장을 실행하여 테이블을 생성합니다.

```sql
-- train 데이터 베이스 사용
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
```

테이블 조회 결과

<img src="https://github.com/user-attachments/assets/ab6d5717-4ada-45ac-88d1-e52099159204" width ="400">
<br> 
## 3-3. 생성형 AI 사용하여 더미데이터 생성 후 데이터 INSERT

ChatGPT에게 DDL.sql 파일을 넣고 더미데이터 생성해 달라고 요청합니다! 

생성된 DML문을 데이터베이스에 접속 후 실행합니다.

```sql
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
(1, '이영희', 'leeyh@naver.com', '010-8765-4321', 'A2', '대전', '부산'),
(2, '박민수', 'parkms@gmail.com', '010-2345-6789', 'B1', '서울', '광주'),
(3, '최지영', 'choijy@hanmail.net', '010-3456-7890', 'C1', '대전', '부산'),
(3, '홍길동', 'honggd@hanmail.net', '010-4567-8901', 'C2', '대전', '대구'),
(4, '정은지', 'jungej@gmail.com', '010-5678-1234', 'D1', '대전', '대구'),
(4, '김도윤', 'kimdy@naver.com', '010-6789-2345', 'D2', '대구', '울산'),
(4, '이서준', 'leesj@hanmail.net', '010-7890-3456', 'D3', '울산', '부산'),
(5, '박소현', 'parksy@gmail.com', '010-8901-4567', 'E1', '서울', '천안'),
(5, '한지민', 'hanjm@naver.com', '010-9012-5678', 'E2', '천안', '대전'),
(5, '이준호', 'leejh@gmail.com', '010-1234-6789', 'E3', '대전', '부산');

select *
from reservations;
```
<br>

# 4. 💡정규 표현식 활용

## 4-1. 정규 표현식 기초 문법

정규 표현식(Regular Expression)은 다양한 프로그래밍 언어와 텍스트 편집기에서 공통적으로 사용되는 문자열 처리 도구입니다. 이는 복잡한 문자열 패턴을 효율적으로 검색, 추출, 치환하는 데 필수적인 도구로, 데이터 처리와 텍스트 분석에서 광범위하게 활용됩니다.

- **`[ABC]`**: 대괄호 안의 문자 중 하나와 일치
- **`[a-z]`**: 문자 범위를 지정할 때 사용
- **`[^ABC]`**: 대괄호 내 문자를 제외한 모든 문자와 일치 (부정)
- **`^[ABC]`**: 문자열의 시작을 의미, 대괄호 내 문자로 시작해야 함
- **`[.]`**: 어떤 문자든 매치 (와일드카드)
- **`[\.]`**: 마침표 문자 그대로를 매치 (이스케이프)
- **`CONCAT()`**: 여러 문자열을 하나로 결합하는 함수
- **`X(?=Y)`**: Positive Lookahead - X 뒤에 Y가 오는 경우 X만 매치
- **`X(?!Y)`**: Negative Lookahead - X 뒤에 Y가 오지 않는 경우 X만 매치

---
<br>

## 4-2. 실습 예제

**regular_expression_test.sql 문제 파일 있습니다.**

당신은 철도공사의 데이터베이스 관리자입니다. 기차 운행 정보(trains), 노선 정보(train_routes), 예약 정보(reservations)를 관리하고 있습니다. 오늘 다음과 같은 업무를 처리해야 합니다.

1. 고객 서비스팀에서 박민수 씨의 예약 정보 확인을 요청했습니다. 박민수가 예약한 열차명과 좌석 번호를 조회해 주세요.
2. 더 이상 사용할 수 없는 이메일 도메인이 있다고 합니다. hanmail.net으로 가입한 고객들의 정보를 모두 추출해 주세요.
3. 태풍으로 인해 일부 열차가 지연되었습니다. 오전 10시 이후 출발하는 모든 열차의 출발 시간과 도착 시간이 30분씩 지연된 것을 데이터에 적용해 주세요.
4. 폭설로 인해 기차역 입구에 정체 현상이 있음을 일부 고객에게 알려야 합니다. 오전 9시 이전(9시 포함) 출발 열차의 예약자 연락처를 찾아주세요.
5. 부산역을 종착지로 하는 열차의 운행 정보를 조회해야 합니다. 부산에 도착하는 열차의 이름, 출발역 및 주요 정차역을 알려주세요.
6. 승객 서비스 개선을 위해 중간 정차역에서 탑승하는 승객들의 데이터를 분석하고자 합니다. 출발역이 아닌 중간 정차역에서 탑승한 승객들의 정보를 조회해 주세요.
7. 새로운 역명 정책으로 인해 '산'이 들어가지 않은 역 이름을 검토해야 합니다. 역 이름에 '산'이라는 글자가 들어가지 않는 모든 기차역 이름을 출력해 주세요.
<br>

# 5. 💣트러블 슈팅

## 데이터 베이스 외부 접속 오류
<img src="https://github.com/user-attachments/assets/614e0b91-58a6-40a4-91e7-e33ae26fded7" width ="600">

`Communications link failure` 오류는 애플리케이션이 MySQL 서버와 연결하려고 할 때 발생하며, 연결이 이루어지지 않을 때 나타납니다.

오류 원인으로는 2가지 정도로 예상됩니다.

### 1. MySQL 서버가 실행 중이지 않음

`sudo system status mysql` 명령을 통해 MySQL이 실행중인 것을 확인했습니다.
<img src="https://github.com/user-attachments/assets/73f42c28-7e85-4e5d-8168-a99b94e888a4" width ="600">

### 2. 포트포워딩 문제

3306 포트의 호스트 IP가 127.0.0.1 로컬 주소로 되어있어 외부 접속이 안됐던 것이었습니다!
<img src="https://github.com/user-attachments/assets/5e4cf93b-6b37-42b5-8336-ed35ef0aa26e" width ="600">

호스트 IP 주소를 PC IP 주소로 변경하여 설정했더니 외부 접속이 되어 문제가 해결 됐습니다 🎉
<img src="https://github.com/user-attachments/assets/a6865887-e0ce-4cea-941c-a3a6e3551e54" width ="600">

---
<br>

# 6. 🤔고찰

- 김소연
    
    정규표현식을 위한 적절한 select 문제를 만드는게 예상보다 복잡했습니다. 정규표현식의 장점인 복잡한 문자열 패턴을 좀 더 간단하게 처리할 수 있다는 점을 보여주기 위한 문제를 만들기 위해서 정규표현식에 대해 더 공부하고, 연습하게 되었습니다. 그 결과로 정규표현식에 익숙해질 수 있었습니다. 
    
    팀 프로젝트를 위해 공통 데이터베이스를 사용하려 했을 때, 서버로 지정된 컴퓨터의 데이터베이스에 연결하는 과정에서 접근이 되지 않고 refuse되는 문제가 발생하였습니다. 방화벽 문제, 사용자 인증 문제 등을 하나하나 해결하니 서버가 작동하는 방식을 조금 이해한 것 같지만, 네트워크 관련된 지식이 더 필요함을 느꼈습니다.
    
- 김창성<br><br>
  테이블 설계는 기능과 유지보수에 중요한 영향을 미친다는 것을 깨달았습니다.<br>
  처음에는 중간 하차역을 고려하지 않고 테이블을 구성했으나, 이를 고려한 설계는 테이블 구조를 완전히 달라지게 만들었습니다. 이처럼 기능에 따라 테이블 설계가 달라질 수 있음을 알게 되었습니다.
  또한, 한 명의 유저가 여러 기차를 예약하는 경우 비효율이 발생할 수 있다는 우려가 생겼습니다. 테이블 구조를 변경하기 어려운 점을 고려할 때, 초기 설계에서 유연하고 확장 가능한 구조를 마련하는 것이 매우 중요하다는 것을 깨달았습니다.
  <br><br>외부 통신 방법을 이해하게 되었습니다.<br>
  스위치나 Wi-Fi 등 다양한 외부 통신 방식이 있었습니다.  조건에 맞는 방법을 선택하는 것이 중요했습니다. 또한, 유저 권한 설정을 고려해야 했고, 포트워딩을 고정된 ip로 설정하여 연결할 수 있었습니다.
  방화벽 설정은 필요하지 않았습니다. 이를 구분해 필요한 설정만 선별하여 보안에도 신경써야 했습니다.
  와이파이로 연결하는 데 실패했습니다. 이후 이를 해결하기 위해 추가로 공부해야겠습니다.<br>
- 박진현
    
    SQL 실습을 통해 데이터베이스 생성부터 문제 작성까지 전 과정을 경험하며, SQL 쿼리의 논리 구조가 문제 해결을 위한 사고 과정과 유사하다는 점을 깨달았습니다. 또한 기본 SQL 문법과 정규표현식 활용을 통해 다양한 형태의 SELECT 문을 구성할 수 있음을 배웠고, 이를 통해 데이터 처리의 효율성과 최적화의 중요성을 인식하게 되었습니다. 향후 대규모 데이터셋에 정규표현식을 활용함으로써 효율적인 문자 데이터 관리를 좀 더 구체적으로 경험해 보고 싶습니다.
    
- 어태규
    
    데이터베이스 연결 도중 외부 접속 하는 부분에서 문제가 생겼습니다. 먼저 어떤 문제인지 파악하는 과정이 오래 걸렸고, 하나 하나 설정하고 해제하면서 테스트 하는 과정에서 정확한 문제를 판단하고 해결하는 과정이 재미있었습니다. 트러블 슈팅을 자주 기록하지 않았는데 작성해보니 똑같은 문제가 일어났을 때 금방 해결할 수 있을 것 같습니다!😊
    

---

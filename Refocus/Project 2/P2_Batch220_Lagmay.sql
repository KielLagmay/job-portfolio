CREATE TABLE IF NOT EXISTS schedules(
	type VARCHAR,
	dates VARCHAR,
	time_start TIME,
	time_end TIME,
	timezone VARCHAR,
	time_planned DECIMAL,
	break_time DECIMAL,
	leave_type VARCHAR,
	user_id VARCHAR
);

SELECT * FROM schedules;

SELECT
REPLACE(REPLACE(REPLACE(dates, '[', ''), ']', ''), ' ', '') AS dates,
time_start || ' ' || timezone AS time_start,
time_end || ' ' || timezone AS time_end,
time_planned,
break_time,
REPLACE(REPLACE(user_id, '{', ''), '}', '') AS user_id
FROM schedules
WHERE type = 'work';

SELECT
REPLACE(REPLACE(REPLACE(dates, '[', ''), ']', ''), ' ', '') AS dates,
leave_type,
REPLACE(REPLACE(user_id, '{', ''), '}', '') AS user_id
FROM schedules
WHERE type = 'leave';

CREATE TABLE IF NOT EXISTS leave_requests(
	user_id VARCHAR,
	first_name VARCHAR,
	last_name VARCHAR,
	type VARCHAR,
	leave_type VARCHAR,
	dates VARCHAR,
	time_start TIME,
	time_end TIME,
	timezone VARCHAR,
	status VARCHAR,
	created_at TIMESTAMP
);

SELECT * FROM leave_requests;

SELECT
user_id,
type,
leave_type,
REPLACE(REPLACE(REPLACE(dates, '[', ''), ']', ''), ' ', '') AS dates,
status,
created_at
FROM leave_requests;

CREATE TABLE IF NOT EXISTS attendance(
	user_id VARCHAR,
	first_name VARCHAR,
	last_name VARCHAR,
	location VARCHAR,
	date DATE,
	time TIME,
	timezone VARCHAR,
	type VARCHAR,
	source VARCHAR
);

SELECT * FROM attendance;

SELECT
user_id,
date,
date || ' ' || time || ' ' || timezone AS timestamp,
source
FROM attendance
WHERE type = 'IN';

SELECT
user_id,
date,
date || ' ' || time || ' ' || timezone AS timestamp,
source
FROM attendance
WHERE type = 'OUT';
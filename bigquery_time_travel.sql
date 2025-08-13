%%bigquery
drop table if exists teak-mantis-242819.appinfo.activity_log;
CREATE TABLE `teak-mantis-242819.appinfo.activity_log` (
    activity_id INT64,
    activity_timestamp TIMESTAMP,
    person_name STRING,
    activity_type STRING,
    duration_minutes INT64,
    status STRING
);

%%bigquery

INSERT INTO
  `teak-mantis-242819.appinfo.activity_log` ( activity_id,
    activity_timestamp,
    person_name,
    activity_type,
    duration_minutes,
    status)
VALUES
  (1, TIMESTAMP '2023-01-15 10:30:00', 'Priya Sharma', 'Logout', 5, 'Success'),
  ( 2, TIMESTAMP '2023-01-15 11:00:00', 'Rahul Singh', 'Data Upload', 30, 'Completed'),
  ( 3, TIMESTAMP '2023-01-15 12:45:00', 'Anjali Devi', 'Report Generation', 15, 'Failed'),
  (4, TIMESTAMP '2023-01-16 09:10:00', 'Vikram Kumar', 'Logout', 2, 'Success'),
  ( 5, TIMESTAMP '2023-01-16 14:20:00', 'Sneha Reddy', 'Configuration Change', 10, 'Success'),
  ( 6, TIMESTAMP '2023-01-17 08:05:00', 'Arjun Patel', 'File Download', 8, 'Completed'),
  ( 7, TIMESTAMP '2023-01-17 16:50:00', 'Kavita Gupta', 'System Update', 60, 'Pending'),
  (8, TIMESTAMP '2023-01-18 10:00:00', 'Rohan Joshi', 'Login', 3, 'Success'),
  ( 9, TIMESTAMP '2023-01-18 13:15:00', 'Meera Rao', 'Data Export', 25, 'Completed'),
  ( 10, TIMESTAMP '2023-01-19 09:40:00', 'Suresh Menon', 'Error Log Review', 45, 'Resolved'),
  ( 11, TIMESTAMP '2023-01-19 11:30:00', 'Deepa Nair', 'User Creation', 7, 'Success'),
  (12, TIMESTAMP '2023-01-20 10:00:00', 'Amit Sharma', 'Login', 4, 'Success'),
  ( 13, TIMESTAMP '2023-01-20 14:00:00', 'Pooja Singh', 'Report Generation', 20, 'Completed'),
  ( 14, TIMESTAMP '2023-01-21 09:00:00', 'Rajesh Kumar', 'Data Upload', 35, 'Completed'),
  ( 15, TIMESTAMP '2023-01-21 16:00:00', 'Divya Reddy', 'Configuration Change', 12, 'Success'),
  ( 16, TIMESTAMP '2023-01-22 11:00:00', 'Alok Patel', 'File Download', 9, 'Completed'),
  ( 17, TIMESTAMP '2023-01-22 15:00:00', 'Neha Gupta', 'System Update', 70, 'Completed'),
  (18, TIMESTAMP '2023-01-23 08:30:00', 'Gaurav Joshi', 'Login', 6, 'Success'),
  ( 19, TIMESTAMP '2023-01-23 12:40:00', 'Swati Rao', 'Data Export', 28, 'Completed'),
  ( 20, TIMESTAMP '2023-01-24 10:10:00', 'Vikas Menon', 'Error Log Review', 50, 'Pending');


%%bigquery
select * from teak-mantis-242819.appinfo.activity_log

%%bigquery

UPDATE `teak-mantis-242819.appinfo.activity_log`
SET activity_type = 'Login'
WHERE activity_id = 1;


%%bigquery --project=teak-mantis-242819 --location=US
SELECT
  job_id,
  start_time,
  end_time
FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE project_id = 'teak-mantis-242819'AND LOWER(query) LIKE '%appinfo.activity_log%'
  AND statement_type = 'UPDATE'
ORDER BY start_time DESC
LIMIT 1;


%%bigquery
select * from teak-mantis-242819.appinfo.activity_log where activity_id=1


%%bigquery  --project=teak-mantis-242819 --location=US

SELECT *
FROM `teak-mantis-242819.appinfo.activity_log`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(TIMESTAMP("2025-08-10 12:51:23 UTC"), INTERVAL 5 SECOND)
WHERE activity_id = 1;



%%bigquery

UPDATE `teak-mantis-242819.appinfo.activity_log` t   -- error 
SET activity_type = old.activity_type
FROM (
  SELECT activity_id, activity_type
  FROM `teak-mantis-242819.appinfo.activity_log`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(TIMESTAMP("2025-08-10 12:41:14 UTC"), INTERVAL 5 SECOND)
) old
WHERE t.activity_id = old.activity_id
  AND t.activity_id = 1;


%%bigquery

drop table if exists teak-mantis-242819.appinfo.activity_log_tt  ;
create table  teak-mantis-242819.appinfo.activity_log_tt as
SELECT *
FROM teak-mantis-242819.appinfo.activity_log
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(TIMESTAMP("2025-08-10 12:51:23 UTC"), INTERVAL 5 SECOND)
WHERE activity_id = 1;



%%bigquery
select * from teak-mantis-242819.appinfo.activity_log_tt



%%bigquery

UPDATE `teak-mantis-242819.appinfo.activity_log` AS main
SET main.activity_type = backup.activity_type
FROM `teak-mantis-242819.appinfo.activity_log_tt` AS backup
WHERE main.activity_id = backup.activity_id



%%bigquery
select * from teak-mantis-242819.appinfo.activity_log where activity_id=1

%%bigquery

DELETE FROM `teak-mantis-242819.appinfo.activity_log`
WHERE activity_id = 2;


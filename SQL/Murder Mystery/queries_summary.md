# **Queries Summary**

## Query 1: Identify witnesses from Northwestern Dr
```SQL
SELECT description FROM crime_scene_report
WHERE date = 20180115 AND type = 'murder' AND city = 'SQL City'
```
> We're given that one witness was Annabel. She lives in Franklin Ave. <br>
> We're also told a witness lives on Northwestern Dr. <br>
> If we parse through transcripts for people living in Northwestern Dr, we find that Morty is the most relevant. <br>

## Query 2: Retrieve Morty's transcript
```SQL
WITH nw_drive_residents AS
(
  SELECT id, name FROM person
  WHERE address_street_name = 'Northwestern Dr'
),
relev_info AS
(
  SELECT B.name, A.person_id, A.transcript FROM interview AS A
  JOIN nw_drive_residents AS B
  ON A.person_id = B.id
)
SELECT * FROM relev_info
WHERE name = 'Morty Schapiro'
```

## Query 3: Retrieve Annabel's transcript
```SQL
SELECT transcript FROM interview
WHERE person_id =
  (
    SELECT id AS second_witness_id FROM person
    WHERE address_street_name = 'Franklin Ave'
    AND name LIKE 'Annabel%'
  )
```
 	

## Query 4: Determine when Annabel checked in and out from the gym
```SQL
SELECT * FROM get_fit_now_check_in
WHERE check_in_date = 20180109
AND check_out_time >= 1530
ORDER BY check_in_time DESC
```
> Annabel checked in at 15:30. There were 2 potential suspects matching.

## Query 5: Find the names of the 2 suspects
```SQL
SELECT B.name, B.person_id FROM get_fit_now_check_in AS A
JOIN get_fit_now_member AS B
ON A.membership_id = B.id
WHERE check_in_date = 20180109
AND check_out_time >= 1530
ORDER BY check_in_time DESC
```
> Narrowed down the names to either Jeremy Bowers or Joe Germuska. 

## Query 6: Match license plate of the two suspects with the murderer.
```SQL
SELECT B.name, B.id, A.plate_number, A.car_make, A.car_model
FROM drivers_license AS A
JOIN person AS B
ON B.license_id = A.id
WHERE A.plate_number LIKE '%H42W%'
LIMIT 5
```
> Found incriminating evidence via license plate and identified Jeremy Bowers as a prime suspect. 
> Using his transcript, we can determine the true mastermind.

## Query 7: Identify the true mastermind
```SQL
WITH id_list AS (
  SELECT DISTINCT person_id FROM facebook_event_checkin
  WHERE event_name = 'SQL Symphony Concert'
  GROUP BY person_id
  HAVING COUNT(person_id) = 3
  ORDER BY COUNT(person_id) DESC
),
expanded_ppl_info AS (
  SELECT * FROM id_list AS A
  JOIN person AS B
  ON A.person_id = B.id
),
villain_info AS (
  SELECT A.person_id, A.name, B.car_make, B.car_model FROM expanded_ppl_info AS A
  JOIN drivers_license AS B
  ON A.license_id = B.id
  WHERE car_make = 'Tesla'
)
SELECT A.person_id, name, car_make, car_model, transcript FROM villain_info AS A
LEFT JOIN interview AS B
ON A.person_id = B.person_id
```

> The true mastermind was Miranda Priestly! Her ticket, number of times went, and car model match!

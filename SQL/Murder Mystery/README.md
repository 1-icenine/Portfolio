# 🕵️ SQL Murder Mystery

## 🧩 Overview

In this SQL project, I investigated a fictional murder in SQL City by analyzing a relational database of crime scene reports, citizen info, gym check-ins, vehicle registrations, and more. Using SQL, I tracked down two key witnesses, identified the prime suspect, and ultimately revealed the criminal mastermind behind the murder.

![68747470733a2f2f6769746875622e636f6d2f66726565737461636b696e69746961746976652f636f6f705f73716c5f6e6f7465626f6f6b732f626c6f622f76322f6173736574732f6d75726465725f6d7973746572795f736368656d612e706e673f7261773d31](https://github.com/user-attachments/assets/7b983541-3944-461f-85db-98492424e3b0)


## 💡 Key Takeaways
- SQL is a more than just querying rows. It's about connecting clues across messy, real-world datasets.
- Writing readable queries with CTEs helped me simplify complex logic.
- Using `HAVING` helps with filtering aggregated data, which reminded me that sometimes the most important filters come **after** the `GROUP BY`

## 🔍 Investigation Summary

### Step 1: Investigate the Crime Scene

```SQL
SELECT description
FROM crime_scene_report
WHERE date = 20180115 AND type = 'murder' AND city = 'SQL City';
```
**Findings**: Two witnesses mentioned: Annabel (lives on Franklin Ave) and an unnamed one on Northwestern Dr.

### Step 2: Track Down the Witness Statements
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
```SQL
SELECT transcript FROM interview
WHERE person_id =
  (
    SELECT id AS second_witness_id FROM person
    WHERE address_street_name = 'Franklin Ave'
    AND name LIKE 'Annabel%'
  )
```
**Findings**: Witnesses saw the killer leave the gym at a specific time with a specific license plate.

### Step 3: Determine Annabel's Gym Check-in and Check-out Time
```SQL
SELECT * FROM get_fit_now_check_in
WHERE check_in_date = 20180109
AND check_out_time >= 1530
ORDER BY check_in_time DESC
```
**Findings**: Annabel checked in at 15:30. There were two other matching suspects.

### Step 4: Identify the Names of the Two Suspects
```SQL
SELECT B.name, B.person_id FROM get_fit_now_check_in AS A
JOIN get_fit_now_member AS B
ON A.membership_id = B.id
WHERE check_in_date = 20180109
AND check_out_time >= 1530
ORDER BY check_in_time DESC
```
**Findings**: The suspect is either Jeremy Bowers or Joe Germuska. 

### Step 5: Match the license plate of the two suspects to that of the murderer's
```SQL
SELECT B.name, B.id, A.plate_number, A.car_make, A.car_model
FROM drivers_license AS A
JOIN person AS B
ON B.license_id = A.id
WHERE A.plate_number LIKE '%H42W%'
LIMIT 5
```
**Findings**: Found incriminating evidence via license plate and identified Jeremy Bowers as a prime suspect. Using his transcript, we can get clues on who the mastermind was (attending 3 concerts, driving a Tesla, etc.).

### Step 6: Identify the True Mastermind in under 2 queries
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
**Mastermind Revealed:** Miranda Priestly — the true architect behind the crime.

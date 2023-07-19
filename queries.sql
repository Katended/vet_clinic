SELECT * FROM animals WHERE name like '%mon';
SELECT name FROM animals WHERE EXTRACT('Year' FROM date_of_birth) BETWEEN '2016' AND  '2019';
SELECT name FROM animals WHERE neutered =TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name like 'Agumon' or name like 'Pikachu';
SELECT name,escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered =TRUE;
SELECT * FROM animals WHERE name not like 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.5  AND weight_kg <= 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified
begin;
update animals set species ='unspecified';
select * from animals;
rollback;

-- Inside a transaction - species
BEGIN;
update animals set species ='digimon ' where NAME LIKE '%mon';
update animals set species ='pokemon' where species IS NULL;
COMMIT;
select * from animals;

-- delete records and rollback
begin;
delete from animals;
select * from animals;
rollback;
select * from animals;

-- Add save points
BEGIN;
delete from animals where date_of_birth >'2022-01-01';
SAVEPOINT SP1;
Update animals set weight_kg=weight_kg*-1;
ROLLBACK TO SAVEPOINT SP1;
Update animals set weight_kg=weight_kg*-1;
COMMIT;
SELECT * FROM animals;

-- How many animals are there
SELECT count(name) numofanimals FROM animals;

-- How many animals have never tried to escape
SELECT count(name) numofanimals from animals where escape_attempts = 0;

-- What is the average weight of animals
select sum(weight_kg)/count(name) avg from animals;

-- Who escapes the most, neutered or not neutered animals
select name  from animals where escape_attempts=
(SELECT MAX(escape_attempts) FROM animals);

-- What is the minimum and maximum weight of each type of animal
select species,MAX(weight_kg),MIN(weight_kg)  from animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000
select sum(escape_attempts)/count(id)  from animals
WHERE EXTRACT(YEAR from date_of_birth) BETWEEN 1990 and 2000;
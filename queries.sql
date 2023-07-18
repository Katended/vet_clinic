SELECT * FROM animals WHERE name like '%mon';
SELECT name FROM animals WHERE EXTRACT('Year' FROM date_of_birth) BETWEEN '2016' AND  '2019';
SELECT name FROM animals WHERE neutered =TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name like 'Agumon' or name like 'Pikachu';
SELECT name,escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered =TRUE;
SELECT * FROM animals WHERE name not like 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.5  AND weight_kg <= 17.3;

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


-- Modify your inserted animals so it includes the species_id
UPDATE animals set species_id = (SELECT id from species WHERE name='Digimon') WHERE name LIKE '%mon'

-- Modify your inserted animals to include owner information
UPDATE animals set owner_id = 
(select id FROM owners where full_name='Sam Smith') WHERE name='Agumon';
UPDATE animals set owner_id = 
(select id FROM owners where full_name='Jennifer Orwell') WHERE name='Pikachu' or name='Gabumon';
UPDATE animals set owner_id = 
(select id FROM owners where full_name='Bob') WHERE name='Plantmon' or name='Devimon';
UPDATE animals set owner_id = 
(select id FROM owners where full_name='Melody Pond') WHERE name='Squirtle' or name='Blossom' or name='Charmander';
UPDATE animals set owner_id = 
(select id FROM owners where full_name='Dean Winchester') WHERE name='Angemon' or name ='Boarmon';

-- What animals belong to Melody Pond?
select * from animals inner join owners on animals.owner_id=owners.id where full_name='Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
select * from animals inner join species on animals.species_id=species.id where species.name='Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal
select * from owners left outer join animals on owners.id=animals.owner_id;

-- How many animals are there per species?
select species.name,count(animals.species_id) from animals inner join species on animals.species_id=species.id group by species.id

-- List all Digimon owned by Jennifer Orwell.
select animals.* from owners , species,animals 
WHERE animals.species_id=species.id 
and animals.owner_id=owners.id  
and full_name='Jennifer Orwell' 
AND species.name='Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
select animals.* from owners , animals where
 animals.owner_id=owners.id  
and full_name='Dean Winchester' 
AND animals.escape_attempts = 0;

-- Who owns the most animals
select owners.*,aa.count FROM (select owner_id,count(id) count from animals group by owner_id) as aa , owners
where aa.owner_id =owners.id and count =(select max(bb.count2) from (select owner_id,count(id) count2 from animals group by owner_id)as bb)

-- Who was the last animal seen by William Tatcher?
select animals.name from visits,vets,animals where visits.vets_id=vets.id 
and vets.name ='William Tatcher'  and visits.animals_id=animals.id and visits.visit_date 
=(select max(visits.visit_date) from visits,vets where visits.vets_id=vets.id 
and vets.name ='William Tatcher');

-- How many different animals did Stephanie Mendez see?
select count(animals_id) numofanimals from (select visits.animals_id from visits,vets where visits.vets_id=vets.id 
and vets.name ='Stephanie Mendez' group by visits.animals_id)  aa;

-- List all vets and their specialties, including vets with no specialties.
select vets.name,species.name from vets left join specializations  
on vets.id=specializations.vets_id 
left join species   
on  species.id=specializations.species_id
group by vets.name,species.name;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
select * from visits,vets where visits.vets_id=vets.id and vets.name='Stephanie Mendez'
and visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
select animals.name from visits,vets,animals where visits.vets_id=vets.id 
and animals.id=visits.animals_id
group by animals.name
order by count(*) desc
limit 1;

-- Who was Maisy Smith's first visit?
select animals.name from visits,vets,animals where visits.vets_id=vets.id 
and animals.id=visits.animals_id and vets.name='Maisy Smith'
group by animals.name,visits.visit_date
order by visits.visit_date asc
limit 1;

-- Details for most recent visit: animal information, vet information, and date of visit
select vets.name,animals.name,visits.visit_date from visits,vets,animals where visits.vets_id=vets.id 
and animals.id=visits.animals_id 
group by vets.name,animals.name,visits.visit_date
order by visits.visit_date desc
limit 1;

-- How many visits were with a vet that did not specialize in that animal's species?
select vets.name,count(*) visits from visits, vets where vets.id =visits.vets_id and visits.vets_id not in (
select visits.vets_id from visits,animals,specializations where specializations.vets_id=visits.vets_id and animals.id=visits.animals_id and specializations.species_id  in 
    (
    select species_id from
    (select animals.species_id,visits.visit_date from visits,vets,specializations,animals where visits.vets_id=vets.id 
    and animals.id=visits.animals_id 
    group by animals.species_id,visits.visit_date
    order by visits.visit_date desc
    limit 1) aa
    )
 ) group by vets.name;


 -- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
select species.name,count(species.name) 
from visits,animals,vets,species where animals.id=visits.animals_id and visits.vets_id=vets.id 
and vets.name='Maisy Smith' and species.id=animals.species_id
group by  species.name
order by count(*) DESC
limit 1;






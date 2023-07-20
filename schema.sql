
CREATE DATABASE vet_clinic;

CREATE TABLE animals  (
   id INT NOT NULL,
   name VARCHAR (100),
   date_of_birth DATE,
   escape_attempts INT NOT NULL,
   neutered BOOLEAN,
   weight_kg DECIMAL (18, 2)
);

-- Add a column species of type string to your animals table.
ALTER TABLE animals 
ADD COLUMN species VARCHAR(100);

-- Create a table named owners
CREATE TABLE owners  (
   id SERIAL PRIMARY KEY,
   full_name VARCHAR (100) NOT NULL,
   age INT NOT NULL
);

--Create a table named species
CREATE TABLE species  (
   id SERIAL PRIMARY KEY,
   name VARCHAR (100) NOT NULL
);

-- Make sure that id is set as autoincremented PRIMARY KEY
ALTER TABLE animals 
DROP COLUMN id;

ALTER TABLE animals 
ADD COLUMN id  SERIAL PRIMARY KEY;

-- Remove column species
ALTER TABLE animals 
DROP COLUMN species;

ALTER TABLE animals 
ADD COLUMN species_id  INT;


-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD CONSTRAINT FK_SPECIES FOREIGN KEY(species_id) REFERENCES species(id);

ALTER TABLE animals 
ADD COLUMN owner_id  INT;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD CONSTRAINT FK_OWNERS FOREIGN KEY(owner_id ) REFERENCES owners(id);

-- Create a table named vets with the following columns
CREATE TABLE vets  (
   id SERIAL PRIMARY KEY,
   name VARCHAR (100),
   age INT,
   date_of_graduation DATE
);

-- create join table specializations
CREATE TABLE specializations (
   vets_id INT,
   species_id INT,
);

-- create join table visits
CREATE TABLE visits (
   vets_id INT,
   animals_id INT,
   visit_date DATE
);

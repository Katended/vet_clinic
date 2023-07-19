
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
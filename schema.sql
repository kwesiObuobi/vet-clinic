/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name varchar(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutured BOOLEAN,
    weight_kg DECIMAL
);

ALTER TABLE animals
ADD COLUMN species VARCHAR(100);

CREATE TABLE owners (
	id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
	full_name VARCHAR(100),
	age INT,
	PRIMARY KEY(id)
);

CREATE TABLE species (
	id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
	name VARCHAR(100),
	PRIMARY KEY(id)
);

ALTER TABLE animals ADD PRIMARY KEY (id);
ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY(species_id)
REFERENCES species(id)
ON DELETE CASCADE;

ALTER TABLE animals ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_owners
FOREIGN KEY(owner_id)
REFERENCES owners(id)
ON DELETE CASCADE;

CREATE TABLE vets (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(100),
	age INT,
	date_of_graduation DATE,
	PRIMARY KEY(id)
);

CREATE TABLE specializations (
	vet_id INT,
	species_id INT,
	CONSTRAINT fk_vets FOREIGN KEY(vet_id)
	REFERENCES vets(id),
	CONSTRAINT fk_species_spec FOREIGN KEY(species_id)
	REFERENCES species(id),
	PRIMARY KEY(vet_id, species_id)
);

CREATE TABLE visits (
	animal_id INT,
	vet_id INT,
	date_of_visit DATE,
	CONSTRAINT fk_animal_visit FOREIGN KEY(animal_id)
	REFERENCES animals(id),
	CONSTRAINT fk_vet_visit FOREIGN KEY(vet_id)
	REFERENCES vets(id),
	PRIMARY KEY(animal_id, vet_id, date_of_visit)
);

CREATE INDEX visits_animal_id_idx ON visits(animal_id);
CREATE INDEX visits_vet_id_idx ON visits(vet_id);
CREATE INDEX owners_email_idx ON owners(email);

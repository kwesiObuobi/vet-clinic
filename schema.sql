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
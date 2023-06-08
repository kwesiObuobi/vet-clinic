/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' and '2019-12-31';
SELECT name FROM animals WHERE neutured IS true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutured is true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT delete_after_jan_1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO delete_after_jan_1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) from animals;
SELECT neutured, SUM(escape_attempts) from animals GROUP BY neutured;
SELECT species, MIN(weight_kg) AS min_weigth, MAX(weight_kg) AS max_weight FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

SELECT animals.name AS animal, owners.full_name AS owner_name
FROM animals JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

SELECT a.name AS animal, s.name AS species
FROM animals a JOIN species s
ON a.species_id = s.id
WHERE a.species_id = 1;

SELECT o.full_name, a.name
FROM owners o LEFT JOIN animals a
ON o.id = a.owner_id;

SELECT COUNT(*), s.name
FROM animals a JOIN species s
ON a.species_id = s.id
GROUP BY s.id;

SELECT o.full_name AS owner, a.name AS animal, s.name AS species
FROM animals a JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE s.id = 2 and o.full_name = 'Jennifer Orwell';

SELECT a.name AS animals
FROM animals a JOIN owners o
ON a.owner_id = o.id
WHERE a.escape_attempts = 0 AND o.full_name = 'Dean Winchester';

SELECT o.full_name AS person, COUNT(*) AS animals
FROM owners o JOIN animals a
ON o.id = a.owner_id
WHERE o.id = (
	SELECT owner_id FROM animals GROUP BY owner_id ORDER BY COUNT(*) DESC LIMIT 1
) GROUP BY o.full_name;


/* 'JOIN TABLES' queries */
SELECT v.name AS vet, a.name AS last_animal
FROM vets v JOIN visits vs
ON v.id = vs.vet_id
JOIN animals a
ON a.id = vs.animal_id
WHERE v.id = 1 ORDER BY vs.date_of_visit DESC LIMIT 1;

SELECT COUNT(DISTINCT animal_id) FROM visits
WHERE vet_id = 3 GROUP BY vet_id;

SELECT v.name AS vet, s.name AS specialty
FROM vets v LEFT JOIN specializations spec
ON v.id = spec.vet_id
LEFT JOIN species s ON s.id = spec.species_id;

SELECT v.name AS vet, a.name AS animal, vs.date_of_visit
FROM vets v JOIN visits vs
ON v.id = vs.vet_id
JOIN animals a
ON a.id = vs.animal_id
WHERE (vs.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30')
AND v.name = 'Stephanie Mendez';

SELECT a.name, COUNT(*) AS most_visits
FROM animals a JOIN visits vs
ON a.id = vs.animal_id
WHERE a.id = (
	SELECT animal_id FROM visits GROUP BY animal_id ORDER BY COUNT(*) DESC LIMIT 1
) GROUP BY a.name;

SELECT a.name
FROM animals a JOIN visits vs
ON a.id = vs.animal_id
WHERE vs.date_of_visit = (
	SELECT date_of_visit FROM visits WHERE visits.vet_id = 2 ORDER BY date_of_visit LIMIT 1
);

SELECT * FROM animals
FULL JOIN visits
ON animals.id = visits.animal_id
FULL JOIN vets
ON vets.id = visits.vet_id
WHERE visits.date_of_visit = (
	SELECT MAX(date_of_visit) from visits
);

SELECT (COUNT(*) - 
	( SELECT COUNT(*)
	  FROM visits vs JOIN specializations spec ON vs.vet_id = spec.vet_id
	  JOIN animals a ON a.species_id = spec.species_id AND vs.animal_id = a.id )
) AS visits FROM visits;

SELECT COUNT(*), s.name
FROM visits vs JOIN animals a ON a.id = vs.animal_id
JOIN species s ON a.species_id = s.id
WHERE vs.vet_id = 2
GROUP BY s.name
ORDER BY COUNT(*) DESC LIMIT 1;

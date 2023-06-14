CREATE TABLE patients (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(100),
	date_of_birth DATE,
	PRIMARY KEY(id)
);

CREATE TABLE medical_histories (
	id INT GENERATED ALWAYS AS IDENTITY,
	admitted_at DATE,
	status VARCHAR(100),
	patient_id INT,
	PRIMARY KEY(id),
	CONSTRAINT fk_patients FOREIGN KEY(patient_id) REFERENCES patients(id)
);

CREATE TABLE treatments (
	id INT GENERATED ALWAYS AS IDENTITY,
	type VARCHAR(100),
	name VARCHAR(100),
	PRIMARY KEY (id)
);

CREATE TABLE treatment_medical_history (
	id INT GENERATED ALWAYS AS IDENTITY,
	medical_history_id INT,
	treatment_id INT,
	CONSTRAINT fk_treatment_history_id FOREIGN KEY(treatment_id) REFERENCES treatments(id),
	CONSTRAINT fk_medical_history_id FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id),
	PRIMARY KEY (id)
);

CREATE TABLE invoices (
	id INT GENERATED ALWAYS AS IDENTITY,
	total_amount DECIMAL,
	generated_at TIMESTAMP,
	payed_at TIMESTAMP,
	medical_history_id INT,
	PRIMARY KEY(id),
	CONSTRAINT fk_med_history FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id)
);

CREATE TABLE invoice_items (
	id INT GENERATED ALWAYS AS IDENTITY,
	unit_price DECIMAL,
	quantity INT,
	total_price DECIMAL,
	invoice_id INT,
	treatment_id INT,
	PRIMARY KEY (id),
	CONSTRAINT fk_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id),
	CONSTRAINT fk_treatment FOREIGN KEY (treatment_id) REFERENCES treatments(id),
);

CREATE INDEX idx_medical_histories_patient_id ON medical_histories(patient_id);
CREATE INDEX idx_invoices_medical_history_id ON invoices(medical_history_id);
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX idx_invoice_items_treatment_id ON invoice_items(treatment_id);
CREATE INDEX idx_treatment_history_med_history_id ON treatment_medical_history (medical_history_id);
CREATE INDEX idx_treatment_history_treatment_id ON treatment_medical_history (treatment_id);

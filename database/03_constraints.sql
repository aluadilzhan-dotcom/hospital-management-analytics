-- 03_constraints.sql
-- Деректер тұтастығын тексеру (CHECK constraints) және индекстер

ALTER TABLE departments
    ADD CONSTRAINT chk_departments_floor CHECK (floor >= 1);

ALTER TABLE patients
    ADD CONSTRAINT chk_patients_gender CHECK (gender IN ('Male', 'Female')),
    ADD CONSTRAINT chk_patients_birth CHECK (birth_date <= CURRENT_DATE);

ALTER TABLE insurance_companies
    ADD CONSTRAINT chk_insurance_coverage CHECK (coverage_percent BETWEEN 0 AND 100);

ALTER TABLE patient_insurance
    ADD CONSTRAINT chk_policy_dates CHECK (valid_to >= valid_from);

ALTER TABLE services
    ADD CONSTRAINT chk_services_price CHECK (base_price >= 0),
    ADD CONSTRAINT chk_services_duration CHECK (duration_min > 0);

ALTER TABLE appointments
    ADD CONSTRAINT chk_appointments_status CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show'));

ALTER TABLE appointment_services
    ADD CONSTRAINT chk_app_services_qty CHECK (quantity > 0),
    ADD CONSTRAINT chk_app_services_price CHECK (unit_price >= 0);

ALTER TABLE diagnoses
    ADD CONSTRAINT chk_diagnosis_type CHECK (diagnosis_type IN ('Primary', 'Secondary', 'Preliminary'));

ALTER TABLE medicines
    ADD CONSTRAINT chk_medicines_price CHECK (unit_price >= 0),
    ADD CONSTRAINT chk_medicines_stock CHECK (stock_qty >= 0);

ALTER TABLE prescriptions
    ADD CONSTRAINT chk_prescriptions_duration CHECK (duration_days > 0),
    ADD CONSTRAINT chk_prescriptions_qty CHECK (quantity > 0);

ALTER TABLE laboratory_tests
    ADD CONSTRAINT chk_lab_tests_price CHECK (price >= 0);

ALTER TABLE test_results
    ADD CONSTRAINT chk_test_results_status CHECK (status IN ('Pending', 'Completed'));

ALTER TABLE payments
    ADD CONSTRAINT chk_payments_amounts CHECK (total_amount >= 0 AND insurance_covered >= 0 AND paid_amount >= 0),
    ADD CONSTRAINT chk_payments_status CHECK (payment_status IN ('Unpaid', 'Partial', 'Paid'));

-- Іздеу мен есептерді жылдамдатуға арналған индекстер
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_test_results_patient ON test_results(patient_id);
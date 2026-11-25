-- 01_create_tables.sql
-- CASE 03: HOSPITAL MANAGEMENT SYSTEM

CREATE TABLE specializations (
    specialization_id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    floor INTEGER NOT NULL,
    phone VARCHAR(30)
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    specialization_id INTEGER NOT NULL REFERENCES specializations(specialization_id),
    department_id INTEGER NOT NULL REFERENCES departments(department_id),
    license_number VARCHAR(60) NOT NULL UNIQUE,
    hire_date DATE NOT NULL
);

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    iin_or_passport VARCHAR(30) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    gender VARCHAR(15) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(120),
    address VARCHAR(255)
);

CREATE TABLE insurance_companies (
    insurance_company_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    contact_phone VARCHAR(30),
    coverage_percent NUMERIC(5, 2) NOT NULL DEFAULT 0.00
);

CREATE TABLE patient_insurance (
    patient_insurance_id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(insurance_company_id),
    policy_number VARCHAR(80) NOT NULL UNIQUE,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);

CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES departments(department_id),
    name VARCHAR(150) NOT NULL,
    base_price NUMERIC(10, 2) NOT NULL,
    duration_min INTEGER NOT NULL DEFAULT 30
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id),
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Scheduled',
    notes TEXT
);

CREATE TABLE appointment_services (
    appointment_service_id SERIAL PRIMARY KEY,
    appointment_id INTEGER NOT NULL REFERENCES appointments(appointment_id),
    service_id INTEGER NOT NULL REFERENCES services(service_id),
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE medical_records (
    medical_record_id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id),
    appointment_id INTEGER NOT NULL REFERENCES appointments(appointment_id),
    record_date DATE NOT NULL DEFAULT CURRENT_DATE,
    symptoms TEXT,
    recommendations TEXT
);

CREATE TABLE diagnoses (
    diagnosis_id SERIAL PRIMARY KEY,
    medical_record_id INTEGER NOT NULL REFERENCES medical_records(medical_record_id),
    icd_code VARCHAR(20) NOT NULL,
    title VARCHAR(200) NOT NULL,
    diagnosis_type VARCHAR(40) NOT NULL DEFAULT 'Primary'
);

CREATE TABLE medicines (
    medicine_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    dosage_form VARCHAR(80),
    unit_price NUMERIC(10, 2) NOT NULL,
    stock_qty INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    medical_record_id INTEGER NOT NULL REFERENCES medical_records(medical_record_id),
    medicine_id INTEGER NOT NULL REFERENCES medicines(medicine_id),
    dosage VARCHAR(100) NOT NULL,
    duration_days INTEGER NOT NULL,
    quantity INTEGER NOT NULL
);

CREATE TABLE laboratory_tests (
    laboratory_test_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    reference_range VARCHAR(120),
    price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE test_results (
    test_result_id SERIAL PRIMARY KEY,
    appointment_id INTEGER NOT NULL REFERENCES appointments(appointment_id),
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    laboratory_test_id INTEGER NOT NULL REFERENCES laboratory_tests(laboratory_test_id),
    result_value VARCHAR(120),
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    tested_at TIMESTAMP
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    appointment_id INTEGER NOT NULL REFERENCES appointments(appointment_id),
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    total_amount NUMERIC(10, 2) NOT NULL,
    insurance_covered NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    paid_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'Unpaid',
    payment_date TIMESTAMP
);
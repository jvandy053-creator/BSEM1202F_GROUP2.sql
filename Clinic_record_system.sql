
-- PUBLIC HEALTH CLINIC RECORDS SYSTEM  --


-- CREATE DATABASE
CREATE DATABASE  Clinic_record_system;


-- PATIENTS 
CREATE TABLE Patients
(
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    registration_date DATE DEFAULT(CURRENT_DATE),
    is_active BOOLEAN DEFAULT TRUE
);

-- HEALTH_WORKERS 
CREATE TABLE HealthWorkers
(
    Health_worker_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    license_number VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE
);

-- APPOINTMENTS 
CREATE TABLE Appointments
(
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    health_worker_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')) DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (health_worker_id) REFERENCES HealthWorkers(Health_worker_id)
);

-- DIAGNOSES 
CREATE TABLE Diagnoses
(
    diagnosis_id INT PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL UNIQUE,
    diagnosis_name VARCHAR(200) NOT NULL,
    description TEXT,
    is_chronic BOOLEAN DEFAULT FALSE
);



-- PRESCRIPTIONS 
CREATE TABLE Prescriptions
(
    prescription_id INT PRIMARY KEY,
    patient_id INT,
    health_worker_id INT,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    prescribed_date DATE,
    duration_days INT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (health_worker_id) REFERENCES HealthWorkers(Health_worker_id)
);

-- BILLS 
CREATE TABLE Billing
(
    bill_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    service_description VARCHAR(200),
    amount DECIMAL(10, 2),
    insurance_coverage DECIMAL(10, 2),
    patient_responsibility DECIMAL(10, 2),
    amount_paid DECIMAL(10, 2),
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Partial', 'Paid', 'Overdue')) DEFAULT 'Pending',
    due_date DATE,
    paid_date DATE,
    FOREIGN KEY
    (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY
    (appointment_id) REFERENCES Appointments(appointment_id)
);

-- PAYMENTS  (Track payments)
CREATE TABLE Payments
(
    payment_id INT PRIMARY KEY,
    bill_id INT,
    payment_date DATE,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(20) CHECK (payment_method IN ('Cash', 'Card', 'Insurance', 'Online')),
    reference_number VARCHAR(50),
    FOREIGN KEY
    (bill_id) REFERENCES Billing(bill_id) ON
    DELETE CASCADE
);



-- INSURANCE_PROVIDERS 
CREATE TABLE Insurance_Providers
(
    insurance_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    contact_phone VARCHAR(20) ,
    contact_email VARCHAR(100),
    address TEXT,
    coverage_percentage DECIMAL(5,2) DEFAULT 80.00,
    max_coverage_per_year DECIMAL(12,2) NOT NULL,
    approval_rate DECIMAL(5,2) DEFAULT 100.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- PATIENT_INSURANCE 
CREATE TABLE Patient_Insurance
(
    patient_insurance_id INT PRIMARY KEY,
    patient_id INT,
    insurance_id INT,
    policy_number VARCHAR(50),
    group_number VARCHAR(50),
    effective_date DATE,
    expiry_date DATE,
    is_primary BOOLEAN DEFAULT TRUE,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id) ON
    DELETE CASCADE,
    FOREIGN KEY (insurance_id)REFERENCES Insurance_Providers(insurance_id) ON
    DELETE CASCADE
);



-- LAB_TESTS 
CREATE TABLE Lab_Tests
(
    lab_test_id INT PRIMARY KEY ,
    test_name VARCHAR(100),
    test_code VARCHAR(20) ,
    category VARCHAR(50),
    normal_range_min DECIMAL(10,2),
    normal_range_max DECIMAL(10,2),
    unit_of_measure VARCHAR(20),
    cost DECIMAL(10,2),
    preparation_instructions TEXT,
    turnaround_hours INT DEFAULT 24
);


-- PATIENT_LAB_RESULTS 
CREATE TABLE Patient_Lab_Results
(
    result_id INT PRIMARY KEY,
    patient_id INT,
    lab_test_id INT,
    doctor_id INT,
    test_date DATETIME,
    result_value VARCHAR(50),
    is_abnormal BOOLEAN DEFAULT FALSE,
    notes TEXT,
    result_file_path VARCHAR(255),
    reviewed_by_doctor BOOLEAN DEFAULT FALSE,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY(lab_test_id) REFERENCES Lab_Tests(lab_test_id),
    FOREIGN KEY(doctor_id) REFERENCES Doctors(doctor_id)
);

-- VACCINATIONS 
CREATE TABLE Vaccinations
(
    vaccine_id INT PRIMARY KEY,
    vaccine_name VARCHAR(100),
    manufacturer VARCHAR(100),
    vaccine_type VARCHAR(50),
    doses_required INT,
    dose_interval_days INT,
    storage_temperature VARCHAR(20),
    expiration_months INT,
    current_stock INT,
    cost_per_dose DECIMAL(10,2)
);

-- PATIENT_VACCINATIONS 
CREATE TABLE Patient_Vaccinations
(
    vaccination_record_id INT PRIMARY KEY,
    patient_id INT,
    vaccine_id INT,
    administered_by INT,
    dose_number INT,
    administration_date DATE,
    batch_number VARCHAR(50),
    administration_site VARCHAR(50),
    adverse_reaction TEXT,
    next_dose_due_date DATE,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY(vaccine_id) REFERENCES Vaccinations(vaccine_id),
    FOREIGN KEY(administered_by) REFERENCES Doctors(doctor_id)
);

--- WARDS_ROOMS 
CREATE TABLE Wards_Rooms
(
    room_id INT PRIMARY KEY,
    ward_name VARCHAR(50),
    room_number VARCHAR(10),
    room_type VARCHAR(20) CHECK (room_type IN ('Private', 'Semi-Private', 'General')),
    bed_count INT,
    daily_rate DECIMAL(10,2),
    is_occupied BOOLEAN DEFAULT FALSE,
    has_oxygen BOOLEAN DEFAULT FALSE,
    has_monitor BOOLEAN DEFAULT FALSE,
    has_ac BOOLEAN DEFAULT FALSE,
    has_attached_bathroom BOOLEAN DEFAULT FALSE
);

-- PATIENT_ADMISSIONS 
CREATE TABLE Patient_Admissions
(
    admission_id INT PRIMARY KEY,
    patient_id INT,
    room_id INT,
    admitting_doctor_id INT,
    admission_date DATETIME,
    admission_reason TEXT,
    discharge_date DATETIME,
    discharge_condition VARCHAR(20) CHECK (discharge_condition IN ('Recovered', 'Stable', 'Transferred', 'Deceased')),
    discharge_instructions TEXT,
    total_bill_amount DECIMAL(12,2),
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY(room_id) REFERENCES Wards_Rooms(room_id),
    FOREIGN KEY(admitting_doctor_id) REFERENCES Doctors(doctor_id)
);

-- MEDICAL_SUPPLIES 
CREATE TABLE Medical_Supplies
(
    supply_id INT PRIMARY KEY,
    supply_name VARCHAR(100),
    category VARCHAR(50),
    unit_of_measure VARCHAR(20),
    quantity_in_stock INT,
    reorder_level INT,
    reorder_quantity INT,
    unit_cost DECIMAL(10,2),
    supplier_name VARCHAR(100),
    expiry_date DATE,
    last_ordered_date DATE
);


-- REFERRALS 
CREATE TABLE Referrals
(
    referral_id INT PRIMARY KEY,
    patient_id INT,
    referring_doctor_id INT,
    referred_to VARCHAR(200),
    referral_reason TEXT,
    referral_date DATE,
    urgency_level VARCHAR(20) DEFAULT 'Routine' CHECK (urgency_level IN ('Routine', 'Urgent', 'Emergency')),
    external_facility_contact VARCHAR(100),
    follow_up_required BOOLEAN DEFAULT FALSE,
    feedback_received DATE,
    referral_status VARCHAR(20) DEFAULT 'Pending' CHECK (referral_status IN ('Pending', 'Accepted', 'Completed', 'Rejected')),
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY(referring_doctor_id) REFERENCES Doctors(doctor_id)
);


-- PATIENT_FEEDBACK 
CREATE TABLE Patient_Feedback
(
    feedback_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    visit_date DATE,
    rating_doctor INT CHECK(rating_doctor BETWEEN 1 AND 5),
    rating_wait_time INT CHECK(rating_wait_time BETWEEN 1 AND 5),
    rating_facility_cleanliness INT CHECK(rating_facility_cleanliness BETWEEN 1 AND 5),
    rating_overall INT CHECK(rating_overall BETWEEN 1 AND 5),
    comments TEXT,
    recommendation_willingness BOOLEAN DEFAULT TRUE,
    feedback_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_responded BOOLEAN DEFAULT FALSE,
    response_text TEXT,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY(appointment_id) REFERENCES Appointments(appointment_id)
);

-- EMERGENCY_CONTACTS
CREATE TABLE Emergency_Contacts
(
    emergency_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    contact_name VARCHAR(100),
    relationship VARCHAR(50),
    primary_phone VARCHAR(20),
    secondary_phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    is_primary_contact BOOLEAN DEFAULT FALSE,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id) ON
    DELETE CASCADE
);

--- Sample data insertion ---

INSERT INTO Appointments
    (appointment_id, patient_id, health_worker_id, appointment_date, appointment_time, status, reason)
VALUES
    (1, 1, 1, '2026-01-10', '09:00:00', 'Completed', 'Routine checkup'),
    (2, 2, 2, '2026-01-12', '10:30:00', 'Scheduled', 'Dental cleaning'),
    (3, 3, 3, '2026-01-14', '14:00:00', 'Completed', 'Child vaccination'),
    (4, 4, 4, '2026-01-15', '15:30:00', 'Cancelled', 'Allergy consultation'),
    (5, 5, 5, '2026-01-18', '09:00:00', 'Scheduled', 'Heart checkup'),
    (6, 6, 6, '2026-01-20', '11:00:00', 'Completed', 'Eye examination'),
    (7, 7, 7, '2026-01-22', '14:30:00', 'No-Show', 'Orthopedic consult'),
    (8, 8, 8, '2026-01-25', '10:00:00', 'Scheduled', 'Pregnancy follow-up'),
    (9, 9, 9, '2026-01-27', '09:30:00', 'Completed', 'Neurology follow-up'),
    (10, 10, 10, '2026-01-29', '16:00:00', 'Scheduled', 'Skin check');






INSERT INTO Health_Workers
    (Health_Worker_id, first_name, last_name, specialization, license_number, phone, email, hire_date)
VALUES
    (1, 'Grace', 'Atieno', 'General Practitioner', 'LIC-001-2020', '0711-111111', 'grace.atieno@hospital.ke', '2020-01-15'),
    (2, 'James', 'Maina', 'Dentist', 'LIC-002-2019', '0722-222222', 'james.maina@hospital.ke', '2019-06-01'),
    (3, 'Raj', 'Patel', 'Pediatrician', 'LIC-003-2018', '0733-333333', 'raj.patel@hospital.ke', '2018-09-10'),
    (4, 'Susan', 'Kariuki', 'Immunologist', 'LIC-004-2021', '0744-444444', 'susan.kariuki@hospital.ke', '2021-03-20'),
    (5, 'Peter', 'Ochieng', 'Cardiologist', 'LIC-005-2017', '0755-555555', 'peter.ochieng@hospital.ke', '2017-11-01'),
    (6, 'Mary', 'Wanjiru', 'Ophthalmologist', 'LIC-006-2020', '0766-666666', 'mary.wanjiru@hospital.ke', '2020-07-15'),
    (7, 'John', 'Mwangi', 'Orthopedic Surgeon', 'LIC-007-2016', '0777-777777', 'john.mwangi@hospital.ke', '2016-04-01'),
    (8, 'Sarah', 'Chelangat', 'Gynecologist', 'LIC-008-2019', '0788-888888', 'sarah.chelangat@hospital.ke', '2019-08-20'),
    (9, 'Robert', 'Kimani', 'Neurologist', 'LIC-009-2018', '0799-999999', 'robert.kimani@hospital.ke', '2018-12-01'),
    (10, 'Elizabeth', 'Nyokabi', 'Dermatologist', 'LIC-010-2021', '0700-000000', 'elizabeth.nyokabi@hospital.ke', '2021-06-15');




INSERT INTO Patients
    (patient_id, first_name, last_name, date_of_birth, gender, phone, email, address, registration_date, is_active)
VALUES
    (1, 'John', 'Doe', '1985-05-15', 'Male', '0711-123456', 'john.doe@email.com', '123 Main St, Nairobi', '2026-01-01', TRUE),
    (2, 'Jane', 'Smith', '1990-08-20', 'Female', '0722-234567', 'jane.smith@email.com', '456 Oak Ave, Mombasa', '2026-01-02', TRUE),
    (3, 'Robert', 'Johnson', '1978-12-03', 'Male', '0733-345678', 'robert.j@email.com', '789 Pine Rd, Kisumu', '2026-01-03', TRUE),
    (4, 'Mary', 'Williams', '1995-03-10', 'Female', '0744-456789', 'mary.w@email.com', '101 Elm St, Eldoret', '2026-01-04', TRUE),
    (5, 'David', 'Brown', '1982-07-22', 'Male', '0755-567890', 'david.b@email.com', '202 Cedar Ln, Nakuru', '2026-01-05', TRUE),
    (6, 'Sarah', 'Davis', '1998-11-11', 'Female', '0766-678901', 'sarah.d@email.com', '303 Birch Blvd, Thika', '2026-01-06', TRUE),
    (7, 'Michael', 'Wilson', '1975-09-30', 'Male', '0777-789012', 'michael.w@email.com', '404 Walnut St, Malindi', '2026-01-07', TRUE),
    (8, 'Emily', 'Taylor', '2000-01-15', 'Female', '0788-890123', 'emily.t@email.com', '505 Ash Ct, Nanyuki', '2026-01-08', TRUE),
    (9, 'James', 'Anderson', '1988-06-25', 'Male', '0799-901234', 'james.a@email.com', '606 Poplar Dr, Meru', '2026-01-09', TRUE),
    (10, 'Patricia', 'Thomas', '1993-04-18', 'Female', '0700-012345', 'patricia.t@email.com', '707 Sycamore Way, Embu', '2026-01-10', TRUE);
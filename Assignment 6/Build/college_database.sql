rem Project Deliverable 4
rem Amrit Reddy, 000928762
rem June 2024

spool 'projectdeliverable4.txt'
DROP TABLE sis_instructor_course CASCADE CONSTRAINTS;
DROP TABLE sis_Instructor CASCADE CONSTRAINTS;
DROP TABLE sis_Student_course_record CASCADE CONSTRAINTS;
DROP TABLE sis_scheduled_course CASCADE CONSTRAINTS;
DROP TABLE sis_Student_Credential CASCADE CONSTRAINTS;
DROP TABLE sis_courses_within_cred CASCADE CONSTRAINTS;
DROP TABLE sis_course CASCADE CONSTRAINTS;
DROP TABLE sis_Credential CASCADE CONSTRAINTS;
DROP TABLE SIS_Student CASCADE CONSTRAINTS;

--- SIS_Student ---
CREATE TABLE SIS_Student (
    studentID NUMBER, 
    first_name NVARCHAR2(50) NOT NULL, 
    last_name NVARCHAR2(50) NOT NULL, 
    status NVARCHAR2(2) NOT NULL, 
    status_date DATE NOT NULL, 
    phone NCHAR(12) NOT NULL, 
    email NVARCHAR2(100) NOT NULL
);
ALTER TABLE SIS_Student ADD CONSTRAINT studentID_pk PRIMARY KEY(studentID);
ALTER TABLE SIS_Student ADD CONSTRAINT status_ck CHECK (status IN ('A','AP','S','E'));
ALTER TABLE SIS_Student ADD CONSTRAINT phone_ck CHECK (REGEXP_LIKE(phone, '^[0-9]{3}\.[0-9]{3}\.[0-9]{4}$'));
ALTER TABLE SIS_Student ADD CONSTRAINT email_ck CHECK (REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'));

--- SIS_Credential ---
CREATE TABLE sis_Credential (
    credential# NUMBER,
    school_name NVARCHAR2(50) NOT NULL,
    name NVARCHAR2(50) NOT NULL,
    type NVARCHAR2(2) NOT NULL
);
ALTER TABLE sis_Credential ADD CONSTRAINT credential#_pk PRIMARY KEY(credential#);
ALTER TABLE sis_Credential ADD CONSTRAINT type_ck CHECK (type IN('MI', 'FT', 'CT', 'DP', 'AD', 'D'));

--- SIS_course ---
CREATE TABLE sis_course (
    course_code NCHAR(7),
    name NVARCHAR2(100) NOT NULL,
    num_of_credits NUMBER(2,1) NOT NULL,
    prereq_course_code NCHAR(7)
);
ALTER TABLE sis_course ADD CONSTRAINT course_code_pk PRIMARY KEY(course_code);
ALTER TABLE sis_course ADD CONSTRAINT prereq_course_code_fk FOREIGN KEY(prereq_course_code) REFERENCES sis_course(course_code);
ALTER TABLE sis_course ADD CONSTRAINT course_code_ck CHECK (REGEXP_LIKE(course_code, '^[A-Z]{4}[0-9]{3}$'));

--- SIS_courses_within_cred ---
CREATE TABLE sis_courses_within_cred (
    credential# NUMBER,
    course_code NCHAR(7),
    type_flag NUMBER(1) NOT NULL
);
ALTER TABLE sis_courses_within_cred ADD CONSTRAINT credential_course_code_pk PRIMARY KEY(credential#, course_code);
ALTER TABLE sis_courses_within_cred ADD CONSTRAINT credential_fk1 FOREIGN KEY(credential#) REFERENCES sis_Credential(credential#);
ALTER TABLE sis_courses_within_cred ADD CONSTRAINT course_code_fk2 FOREIGN KEY(course_code) REFERENCES sis_course(course_code);
ALTER TABLE sis_courses_within_cred ADD CONSTRAINT type_flag_ck CHECK (type_flag IN (0,1));

--- SIS_Student_Credential ---
CREATE TABLE sis_Student_Credential (
    studentID NUMBER,
    credential# NUMBER,
    startdate DATE NOT NULL,
    completion_date DATE,
    credential_status NCHAR(1) NOT NULL,
    gpa NUMBER(3,2) NOT NULL
);
ALTER TABLE sis_Student_Credential ADD CONSTRAINT student_ID_pk PRIMARY KEY(studentID, credential#);
ALTER TABLE sis_Student_Credential ADD CONSTRAINT studentID_fk1 FOREIGN KEY(studentID) REFERENCES SIS_Student(studentID);
ALTER TABLE sis_Student_Credential ADD CONSTRAINT credential_fk2 FOREIGN KEY(credential#) REFERENCES sis_Credential(credential#);
ALTER TABLE sis_Student_Credential ADD CONSTRAINT credential_status_ck CHECK (credential_status IN ('A', 'G', 'E'));

---SIS_scheduled_course ---
CREATE TABLE sis_scheduled_course (
    crn NUMBER(5),
    semester_code NCHAR(7),
    course_code NCHAR(7) NOT NULL,
    section_code NCHAR(1) NOT NULL
);
ALTER TABLE sis_scheduled_course ADD CONSTRAINT crn_semester_code_pk PRIMARY KEY (crn, semester_code);
ALTER TABLE sis_scheduled_course ADD CONSTRAINT course_code_fk FOREIGN KEY(course_code) REFERENCES sis_course(course_code);
ALTER TABLE sis_scheduled_course ADD CONSTRAINT semester_code_ck CHECK (REGEXP_LIKE(semester_code, '^[A-Z]{4}[0-9]{3}$'));
ALTER TABLE sis_scheduled_course ADD CONSTRAINT course_code_ck1 CHECK (REGEXP_LIKE(course_code, '^[A-Z]{4}[0-9]{3}$'));
ALTER TABLE sis_scheduled_course ADD CONSTRAINT section_code_ck CHECK (REGEXP_LIKE(section_code, '^[A-Z]$'));

--- SIS_student_course_record ---
CREATE TABLE sis_Student_course_record (
    crn NUMBER,
    semester_code NCHAR(7),
    studentid NUMBER,
    credential# NUMBER NOT NULL,
    course_code NCHAR(7) NOT NULL,
    letter_grade NVARCHAR2(2)
);
ALTER TABLE sis_Student_course_record ADD CONSTRAINT crn_semester_code_studentID_pk PRIMARY KEY(crn, semester_code, studentID);
ALTER TABLE sis_Student_course_record ADD CONSTRAINT crn_semester_code_fk1 FOREIGN KEY(crn, semester_code) REFERENCES sis_scheduled_course(crn, semester_code);
ALTER TABLE sis_Student_course_record ADD CONSTRAINT studentid_fk2 FOREIGN KEY(studentID) REFERENCES sis_student (studentID);
ALTER TABLE sis_Student_course_record ADD CONSTRAINT credential_fk3 FOREIGN KEY(studentID, credential#) REFERENCES sis_Student_Credential (studentID, credential#);
ALTER TABLE sis_Student_course_record ADD CONSTRAINT course_code_fk4 FOREIGN KEY(course_code) REFERENCES sis_course (course_code);
ALTER TABLE sis_Student_course_record ADD CONSTRAINT letter_grade_ck CHECK (letter_grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'I'));

--- SIS_Instructor ---
CREATE TABLE sis_Instructor (
    instructorid NUMBER,
    firstname NVARCHAR2(50) NOT NULL,
    lastname NVARCHAR2(50) NOT NULL,
    address NVARCHAR2(100) NOT NULL,
    city NVARCHAR2(40) NOT NULL,
    prov NCHAR(2) NOT NULL,
    postal_code NCHAR(6) UNIQUE NOT NULL,
    phonenumber NCHAR(12) UNIQUE NOT NULL,
    email NVARCHAR2(100) UNIQUE NOT NULL
);
ALTER TABLE sis_Instructor ADD CONSTRAINT instructorid_pk PRIMARY KEY (instructorid);
ALTER TABLE sis_Instructor ADD CONSTRAINT prov_ck CHECK (prov IN ('AB', 'BC', 'SK', 'MB', 'ON', 'QC', 'NB', 'NS', 'PE', 'NL', 'YT', 'NT', 'NU'));
ALTER TABLE sis_Instructor ADD CONSTRAINT postal_code_ck CHECK (REGEXP_LIKE(postal_code, '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$'));
ALTER TABLE sis_Instructor ADD CONSTRAINT phone_number_ck CHECK (REGEXP_LIKE(phonenumber, '^[0-9]{3}\.[0-9]{3}\.[0-9]{4}$'));
ALTER TABLE sis_Instructor ADD CONSTRAINT email_ck1 CHECK (REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'));

--- SIS_instructor_course ---
CREATE TABLE sis_instructor_course (
    crn NUMBER,
    semester_code NCHAR(7),
    instructorid NUMBER
);
ALTER TABLE sis_instructor_course ADD CONSTRAINT crn_semester_code_instructorid_pk PRIMARY KEY (crn, semester_code, instructorid);
ALTER TABLE sis_instructor_course ADD CONSTRAINT crn_semestr_code_fk1 FOREIGN KEY (crn, semester_code) REFERENCES sis_scheduled_course(crn, semester_code);
ALTER TABLE sis_instructor_course ADD CONSTRAINT instructorid_fk2 FOREIGN KEY(instructorid) REFERENCES sis_Instructor (instructorid);

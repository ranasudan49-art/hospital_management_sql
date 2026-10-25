Hospital Management System – SQL Assignment III

Project Description

This project demonstrates the use of SQL table manipulation in PostgreSQL for a simple Hospital Management System.

Database Tables

The database contains three related tables:

- patients: Stores patient information, including name, age, gender, phone number, and email.
- doctors: Stores doctors' names, specialties, and phone numbers.
- visits: Stores patient visits, visit dates, diagnoses, and references to patients and doctors.

SQL Tasks Completed

1. SELECT queries to retrieve, filter, and sort records.
2. JOIN queries to combine information from related tables.
3. UPDATE queries to modify existing records.
4. ALTER TABLE queries to modify table structure and data types.
5. INSERT queries to add new patients, doctors, and visits.

Relationships

- Each visit references a patient through "patient_id".
- Each visit references a doctor through "doctor_id".
- Foreign keys maintain relationships between the tables.

Tools Used

- PostgreSQL
- pgAdmin 4
- GitHub

Files

- "assignment_iii.sql" — SQL statements for the assignment.
- "erd.png" — Entity Relationship Diagram.

Conclusion

This assignment demonstrates basic SQL operations, table relationships, data modification, and database structure changes using PostgreSQL.

--Academic Status Report 
--Jacob Jobse 930841
--Version 2024-08-06
--(JOIN, USER INPUT, SINGLE ROW FUNCTIONS)
--Report description:
--This report will show students firstname, lastname, studentID, academic status, and gpa.
--based on (user input) to filter the students by their academic status,
--by (joining) the appropriate tables. It will capitalize the
--first letter of the first name, and last name of the filtered students and order them 2,1.

--PROMPTS FOR REPORT 1:
--Create a script that uses JOINS, single row functions, and user input based off the sis physical model
--user input in oracle 12 c using UPPER
--Format script to fit within the output
--Include cases for each of the 4 status's.


spool 'JJ_Academic_Status_Report.txt'

SET pagesize 100;
COLUMN firstName FORMAT A15;
COLUMN lastName FORMAT A10;
COLUMN studentID FORMAT 999999;
COLUMN academicStatus FORMAT A15;
COLUMN GPA FORMAT A10;

PROMPT Enter the student status to filter by (e.g., 'A' for active, 'AP' for academic probation, 'S' for suspended, 'E' for expelled):
ACCEPT student_status CHAR;
--CHAT GPT WAS USED FOR THE ABOVE PROMPT AND ACCEPT
SELECT DISTINCT
    INITCAP(first_name) firstName,
    INITCAP(last_name) lastName,
    studentID,
    gpa GPA,
    status academicStatus
FROM 
    SIS_Student 
    JOIN sis_Student_Credential USING(studentID)
WHERE 
    UPPER(status) = UPPER('&student_status') --CHAT GPT WAS ALSO USED HERE
ORDER BY
    2,1;

spool off



    



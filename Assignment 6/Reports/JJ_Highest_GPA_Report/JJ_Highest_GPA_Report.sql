--Report 3 (RESTRICTING DATA, SUBQUERIES)
--Jacob Jobse
--2024-08-06
--Report Description:
--This report shows the studentID's, names and gpa's of students
--who have a higher gpa than the average of gpas from all students, order by gpa
--Using WHERE, AVG, AND SUBQUERIES

--CHAT GPT PROMPTS
--IS WHERE CONSIDERED RESTRICITING DATA

spool 'JJ_Highest_GPA_Report.txt'



COLUMN firstName FORMAT A10;
COLUMN lastName FORMAT A10;
COLUMN studentID FORMAT A10;
COLUMN GPA FORMAT A10

WITH renee AS (
    SELECT
        studentid,
        first_name firstname,
        last_name  lastname,
        gpa        gpa
    FROM
             sis_student
        JOIN sis_student_credential USING ( studentid )
    ORDER BY
        4
)
SELECT
    *
FROM
    renee
WHERE
    gpa > (
        SELECT
            AVG(gpa)
        FROM
            renee
    );

spool off

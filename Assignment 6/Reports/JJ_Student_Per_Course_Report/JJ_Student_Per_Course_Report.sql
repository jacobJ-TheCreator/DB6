--Student Per Course Report
--Jacob Jobse 930841
--(GROUP FUNCTIONS, OLAP)
--Report Description:
--This report will show the calculated number of students in each course,
--and then will also show the grand total of unique students across all courses, ordered by 1.
--Using, COUNT, group by grouping sets.

--CHAT GPT PROMPTS:
--which of the three olap features would make this task easiest, rollout, grouping sets or cube

spool 'JJ_Student_Per_Course_Report'


SET PAGESIZE 10000;
SET LINESIZE 300;

SELECT
    nvl(course_code, 'Grand Total') "Course Code",
    name                            "Course Name",
    COUNT(DISTINCT(studentid))      "Students Enrolled"
FROM
         sis_course
    JOIN sis_student_course_record USING ( course_code )
GROUP BY
    GROUPING SETS ( ( course_code,
                      name ), ( ) )
ORDER BY
    1,
    2;
        
    
    
spool off
    
    
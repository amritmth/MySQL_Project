USE psyliq;
SELECT * FROM psyliq.employee_survey_data;
SELECT * FROM psyliq.manager_survey_data;
SELECT * FROM psyliq.general_hr_data;

# 1. Retrieve the total number of employees in the dataset.
SELECT COUNT(*) AS total_employees
FROM employee_survey_data;

# 2. List all unique job roles in the dataset.
SELECT DISTINCT JobRole
FROM general_hr_data;


# 3. Find the average age of employees.
SELECT AVG(Age) AS Average_age
FROM general_hr_data;

# 4. Retrieve the names and ages of employees who have worked at the company for more than 5 years.
SELECT Employee_name AS Employees_Name, Age
FROM general_hr_data
WHERE YearsAtCompany < 5;

# 5. Get a count of employees grouped by their department.
SELECT Department, COUNT(*) AS Employee_count
FROM general_hr_data
GROUP BY Department;

# 6. List employees who have 'High' Job Satisfaction.
SELECT EmployeeID, Employee_name
FROM general_hr_data 
WHERE joblevel = 3;


#7. Find the highest Monthly Income in the dataset.
SELECT MAX(MonthlyIncome) as Max_Monthly_Income 
FROM general_hr_data;


#8. List employees who have 'Travel_Rarely' as their BusinessTravel type.
SELECT EmployeeID, Employee_name as Employees_who_Travel_Rarely 
FROM general_hr_data 
WHERE BusinessTravel IN ('Travel_Rarely');


#9. Retrieve the distinct MaritalStatus categories in the dataset.
SELECT DISTINCT(MaritalStatus) as MaritalStatus_Categories_Wise
FROM general_hr_data;

#10. Get a list of employees with more than 2 years of work experience but less than 4 years in their current role.
SELECT EmployeeID, Employee_name as `Employee with years between 2 and 4 at Company`
FROM general_hr_data 
WHERE TotalWorkingYears > 2 AND YearsAtCompany < 4;

#11. List employees who have changed their job roles within the company (JobLevel and JobRole differ from their previous job).
SELECT EmployeeID, Employee_name, CurrentJobRole, CurrentJobLevel
FROM (SELECT EmployeeID, Employee_name, JobRole AS CurrentJobRole, JobLevel AS CurrentJobLevel,
           LEAD(JobRole, 1) OVER (PARTITION BY EmployeeID ORDER BY YearsAtCompany) AS PreviousJobRoles,
           LEAD(JobLevel, 1) OVER (PARTITION BY EmployeeID ORDER BY YearsAtCompany) AS PreviousJobLevels
           FROM general_hr_data) AS `Jobs Change`
           WHERE CurrentJobRole <> PreviousJobRoles OR CurrentJobLevel <> PreviousJobLevels;


#12. Find the average distance from home for employees in each department.
SELECT Department, avg(DistanceFromHome) as `Average Distance from Home to Office`
FROM general_hr_data
GROUP BY Department;

#13. Retrieve the top 5 employees with the highest MonthlyIncome.
SELECT EmployeeID, Employee_name, MonthlyIncome
FROM general_hr_data
ORDER BY MonthlyIncome DESC
LIMIT 5;

#14. Calculate the percentage of employees who have had a promotion in the last year.
SELECT COUNT(CASE WHEN YearsSinceLastPromotion<= 1 THEN 1 END) AS `Employees With Promotion Last Year`,COUNT(*) AS `Total Employees`, 
(COUNT(CASE WHEN YearsSinceLastPromotion <= 1 THEN 1 END) * 100.0 / COUNT(*)) AS `Percentage Promoted Last Year`
FROM general_hr_data;

#15. List the employees with the highest and lowest EnvironmentSatisfaction.
SELECT a.EmployeeID, a.Employee_name, b.environmentsatisfaction 
FROM general_hr_data a JOIN employee_survey_data b ON a.EmployeeID = b.EmployeeID
WHERE b.EnvironmentSatisfaction IN (SELECT MAX(EnvironmentSatisfaction)
                                    FROM employee_survey_data
                                    UNION SELECT MIN(EnvironmentSatisfaction)
                                          FROM employee_survey_data);


#16. Find the employees who have the same JobRole and MaritalStatus.
SELECT EmployeeID, Employee_name, JobRole, MaritalStatus FROM general_hr_data e1
WHERE EXISTS (SELECT 1 
              FROM general_hr_data e2 
			  WHERE e1.EmployeeID <> e2.EmployeeID AND e1.JobRole = e2.JobRole AND e1.MaritalStatus = e2.MaritalStatus)
			  ORDER BY JobRole, MaritalStatus, EmployeeID, Employee_name;

# 17. List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4.
SELECT a.EmployeeID, a.Employee_name
FROM general_hr_data a JOIN manager_survey_data b ON a.EmployeeID = b.EmployeeID 
WHERE b.PerformanceRating = 4 AND a.TotalWorkingYears = (SELECT MAX(TotalWorkingYears) 
                                                         FROM general_hr_data
													     WHERE EmployeeID IN (SELECT EmployeeID
                                                                              FROM manager_survey_data
                                                                              WHERE PerformanceRating = 4));
                                                                              
# 18. Calculate the average Age and JobSatisfaction for each BusinessTravel type.
SELECT AVG(age) as `Average Age`, AVG(JobSatisfaction) as `Job Satisfaction Average`
FROM general_hr_data a join employee_survey_data b on a.EmployeeID = b.EmployeeID
GROUP BY BusinessTravel;

# 19. Retrieve the most common EducationField among employees.
SELECT EducationField, COUNT(*) AS FieldCount
FROM general_hr_data
GROUP BY EducationField
ORDER BY COUNT(*) DESC
Limit 1;

# 20. List the employees who have worked for the company the longest but haven't had a promotion.
SELECT EmployeeID, Employee_name, YearsAtCompany, YearsSinceLastPromotion
FROM general_hr_data
WHERE YearsAtCompany = (SELECT MAX(YearsAtCompany)
					    FROM general_hr_data) AND YearsSinceLastPromotion = 0;


SELECT * FROM psyliq.general_hr_data;
SELECT * FROM psyliq.manager_survey_data;
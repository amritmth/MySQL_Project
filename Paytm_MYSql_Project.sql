USE psyliq;
SELECT * FROM psyliq.purchase_data;

# Q1 . What does the "Category_Grouped" column represent, and how many unique categories are there?
Select distinct Category_Grouped
From purchase_data;

# Q2. List the top 5 shipping cities in terms of the number of orders.
Select shipping_city, COUNT(*) as Quantity
From purchase_data
Group By shipping_city
Order By Quantity Desc
Limit 5;


# Q3. Show me a table with all the data for products that belong to the "Electronics" category.
Select *
From purchase_data
Where Category = 'Electronics';

# Q4. Filter the data to show only rows with a "Sale_Flag" of 'Yes'.
Select *
From purchase_data
Where Sale_Flag = 'On Sale';

# Q5. Sort the data by "Item_Price" in descending order. What is the most expensive item?
Select Item_NM, Item_Price
From purchase_data
Order By Item_Price Desc
Limit 1;

# Q7. Create a pivot table to find the total sales value for each category.
SELECT Category, SUM(Item_Price) AS Total_Sales_Value
FROM purchase_data
GROUP BY Category
ORDER BY Total_Sales_Value DESC;

SELECT Category, SUM(Paid_pr) AS Total_Sales_Value
FROM purchase_data
GROUP BY Category
ORDER BY Total_Sales_Value DESC;

# Q8. Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender."
Select Product_Gender, Avg(Quantity) as `Average Quantity`
From purchase_data  
Where Category_Grouped = 'Clothing'
Group By Product_Gender;

# Q10. Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios.
Select *, (Value_CM1 / Value_CM2) as Ratio
From purchase_data
Order By Ratio Desc
Limit 5;

# Q11. Identify the top 3 "Class" categories with the highest total sales. Create a stacked bar chart to represent this data.
Select Class, SUM(Special_Price_effective) as Total_Sales
From purchase_data
Group By Class
Order By Total_Sales Desc
Limit 3;

# Q12. Find the total sales for each "Brand" and display the top 3 brands in terms of sales.
Select Brand, SUM(Special_Price_effective) as Total_Sales
From purchase_data
Group By Brand
Order By Total_Sales Desc
Limit 3;

# Q13. Calculate the total revenue generated from "Electronics" category products with a "Sale_Flag" of 'Yes'.
Select SUM(Special_Price_effective) as Total_Revenue
From purchase_data
Where Category = 'Electronics' And Sale_Flag = 'Yes';

# Q14. Identify the top 5 shipping cities based on the average order value (total sales amount divided by the number of orders) and display their average order values.
Select Shipping_city, 
    COUNT(*) as Number_of_Orders,
    SUM(Special_Price_effective) as Total_Sales,
    (SUM(Special_Price_effective) / COUNT(*)) as Average_Order_Value
From purchase_data
Group By Shipping_city
Order By Average_Order_Value Desc
Limit 5;

# Q15. Determine the total number of orders and the total sales amount for each "Product_Gender" within the "Clothing" category
Select Product_Gender, 
    COUNT(*) AS Number_of_Orders,
    SUM(Special_Price_effective) AS Total_Sales
From purchase_data
Where Category = 'Clothing'
Group By Product_Gender;

#Q16. Calculate the percentage contribution of each "Category" to the overall total sales.
Select 
    Category,
    SUM(Special_Price_effective) as Total_Sales,
    (SUM(Special_Price_effective) / (Select SUM(Special_Price_effective) 
                                     From purchase_data) * 100) as Percentage_Contribution
From purchase_data
Group By Category;

#Q17. Identify the "Category" with the highest average "Item_Price" and its corresponding average price.
Select Category, Avg(Item_Price) As Average_Item_Price
From purchase_data
Group By Category
Order By Average_Item_Price Desc
Limit 1;

#Q18. Find the month with the highest total sales revenue.
-- 1. Add the RandomDate column to the table
ALTER TABLE purchase_data
ADD Random_Data_Col DATE;

-- 2. Update the RandomDate column with random dates
UPDATE purchase_data
SET Random_Data_Col = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 65530), '1753-01-01')
WHERE Random_Data_Col IS NULL;

-- 3. Select the top month by revenue
SELECT  FORMAT(Random_Data_Col, 'MMMM') AS Month, SUM(Paid_pr) AS Total_Revenue 
FROM purchase_data
GROUP BY FORMAT(Random_Data_Col, 'MMMM')
ORDER BY SUM(Paid_pr) DESC
Limit 1;

#Q19. Calculate the total sales for each "Segment" and the average quantity sold per order for each segment.
Select Distinct Segment, COUNT(Paid_pr) As Total_Sales,
    Avg(Quantity) As Average_Quantity_Sold
FROM purchase_data
GROUP BY Segment
Order By COUNT(Paid_pr) Desc;



SELECT * FROM psyliq.purchase_data;
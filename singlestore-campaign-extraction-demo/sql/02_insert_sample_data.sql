USE db_sanjay_543dd;

INSERT INTO consumer_profile VALUES
(1,'John','Smith','1985-04-12','10 Main St','Los Angeles','CA','90001','75K-100K'),
(2,'Mary','Jones','1990-08-20','22 Oak St','Dallas','TX','75001','50K-75K'),
(3,'David','Brown','1978-02-10','33 Pine St','Miami','FL','33101','100K-150K'),
(4,'Lisa','Davis','1988-11-05','44 Cedar St','Atlanta','GA','30301','75K-100K'),
(5,'Robert','Wilson','1982-06-17','55 Lake St','Houston','TX','77001','50K-75K'),
(6,'Emily','Taylor','1995-01-22','66 Hill St','San Diego','CA','92101','100K-150K'),
(7,'Michael','Lee','1980-09-14','77 Park St','Orlando','FL','32801','75K-100K'),
(8,'Sarah','Miller','1992-03-03','88 River St','Austin','TX','73301','50K-75K'),
(9,'James','Anderson','1975-12-25','99 Elm St','San Jose','CA','95101','150K+'),
(10,'Anna','Thomas','1987-07-09','11 Maple St','Tampa','FL','33601','75K-100K');

INSERT INTO credit_attributes VALUES
(1,720,0.91,15000,6000,210000,12000,CURRENT_DATE()),
(2,690,0.82,25000,11000,180000,9000,CURRENT_DATE()),
(3,710,0.88,32000,13000,250000,15000,CURRENT_DATE()),
(4,760,0.95,12000,4000,300000,8000,CURRENT_DATE()),
(5,650,0.79,22000,9000,160000,7000,CURRENT_DATE()),
(6,735,0.77,45000,17000,280000,14000,CURRENT_DATE()),
(7,705,0.86,18000,8000,190000,10000,CURRENT_DATE()),
(8,680,0.74,9000,3000,150000,6000,CURRENT_DATE()),
(9,790,0.97,38000,14000,350000,20000,CURRENT_DATE()),
(10,675,0.70,11000,5000,175000,7500,CURRENT_DATE());

INSERT INTO suppression_list VALUES
(101,'CLIENT_A',2,'Previous opt-out',CURRENT_DATE()),
(102,'CLIENT_A',7,'Do not contact',CURRENT_DATE());

INSERT INTO campaign_history VALUES
(1001,'CLIENT_A',3,DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY),1,0),
(1002,'CLIENT_A',8,DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY),1,1),
(1003,'CLIENT_A',9,DATE_SUB(CURRENT_DATE(), INTERVAL 10 DAY),0,0);

SELECT 'consumer_profile' AS table_name, COUNT(*) AS row_count FROM consumer_profile
UNION ALL
SELECT 'credit_attributes', COUNT(*) FROM credit_attributes
UNION ALL
SELECT 'suppression_list', COUNT(*) FROM suppression_list
UNION ALL
SELECT 'campaign_history', COUNT(*) FROM campaign_history;

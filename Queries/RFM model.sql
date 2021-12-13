-- recency: extract the recent purchase time
CREATE VIEW rr AS
SELECT user_id, MAX(dates) AS recent_purchase
FROM userbehavior
WHERE behavior_type = 'buy'
GROUP BY user_id
ORDER BY recent_purchase DESC;

-- classify the recent purchase time, the closer to 2017-12-03, the larger the R
-- datediff in this case is max(recent_purchase)-'2017-11-25'
CREATE VIEW r AS
SELECT user_id, recent_purchase, 
	   datediff(recent_purchase,'2017-11-25') AS days_count, (CASE 
       WHEN datediff(recent_purchase,'2017-11-25') <= 2 then 5
       WHEN datediff(recent_purchase,'2017-11-25') <= 4 then 4
       WHEN datediff(recent_purchase,'2017-11-25') <= 6 then 3
       WHEN datediff(recent_purchase,'2017-11-25') <= 8 then 2
       ELSE 1 END) AS r_value
FROM rr
ORDER BY r_value DESC;


-- frequency: number of purchase
CREATE VIEW ff AS
SELECT user_id, COUNT(behavior_type) AS number_purchase
FROM userbehavior
WHERE behavior_type = 'buy'
GROUP BY user_id
ORDER BY number_purchase DESC;

-- calculate average purchase frequency to set a scoring mechanism
SELECT avg(number_purchase) 
FROM ff;
# average is 2.9353

-- classify the frequency, the higher the number of purchase, the larger the F 
CREATE VIEW f AS
SELECT user_id, 
	   number_purchase, (CASE
	   WHEN number_purchase <=1 THEN 1
       WHEN number_purchase <=2 THEN 2
       WHEN number_purchase <=3 THEN 3
       WHEN number_purchase <=4 THEN 4
       ELSE 5 END) AS f_value
FROM ff
ORDER BY f_value DESC;


-- Since this dataset does not have monetary value
-- Calculate average r_value and f_value
SELECT AVG(r_value)
FROM r;
# average is 3.1169
SELECT AVG(f_value)
FROM f;
# average is 2.5087

-- Classify customers 
CREATE VIEW RFM AS
SELECT r.user_id, r.r_value, f.f_value, (CASE
WHEN r.r_value >= 3.1169 and f.f_value >= 2.5087 THEN 'Best Users'
WHEN r.r_value >= 3.1169 and f.f_value < 2.5087 THEN 'Development/New Users'
WHEN r.r_value < 3.1169 and f.f_value >= 2.5087 THEN 'Low Active Users'
WHEN r.r_value < 3.1169 and f.f_value < 2.5087 THEN 'Churned Users'
END) AS user_classify
FROM r AS r, f AS f
WHERE r.user_id = f.user_id;

SELECT user_classify, COUNT(user_id)
FROM RFM
GROUP BY user_classify;
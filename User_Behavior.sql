-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/user.csv'
-- INTO TABLE userbehavior
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ',';

SELECT COUNT(user_id),
	   COUNT(item_id),
       COUNT(category_id),
       COUNT(behavior_type),
       COUNT(timestamps),
       COUNT(dates),
       COUNT(hours)
FROM userbehavior;

-- UV为独立访客数，PV为页面流量次数，PV/UV为平均一个独立访问者所浏览的页面访问量 
SELECT COUNT(DISTINCT user_id)AS 'UV',
(SELECT COUNT(*) FROM userbehavior WHERE behavior_type = 'pv') AS 'PV',
(SELECT COUNT(*) FROM userbehavior WHERE behavior_type = 'pv')/(COUNT(DISTINCT user_id)) AS 'PV/UV'
FROM userbehavior;

-- PV、UV每日变化趋势 
CREATE VIEW PVandUV_daytrends AS
SELECT dates,
SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS 'PV per day',
COUNT(DISTINCT user_id) AS 'number of user per day'
FROM userbehavior
GROUP BY dates
ORDER BY dates;

-- 根据每个用户计算其用户各行为数量
CREATE VIEW user_behavior
AS SELECT user_id,
COUNT(behavior_type) AS '用户行为总数',
SUM(CASE WHEN behavior_type = 'pv' then 1 else 0 end) AS '点击量',
SUM(CASE WHEN behavior_type = 'buy' then 1 else 0 end) AS '购买量',
SUM(CASE WHEN behavior_type = 'fav' then 1 else 0 end) AS '收藏数',
SUM(CASE WHEN behavior_type = 'cart' then 1 else 0 end) AS '加购数'
FROM userbehavior
GROUP BY user_id;

-- 计算用户各行为总数 
SELECT SUM(点击量) AS total_pv,
	   SUM(购买量) AS total_buy,
       SUM(收藏数) AS total_fav,
       SUM(加购数) AS total_cart
FROM user_behavior;

-- 计算各行为的转化率
CREATE VIEW conversion_rate
AS SELECT concat(round(sum(点击量)/sum(用户行为总数)*100,2),'%') AS total_to_pv,
		  concat(round(sum(加购数)/sum(点击量)*100,2),'%') AS pv_to_cart,
          concat(round(sum(收藏数)/sum(加购数)*100,2),'%') AS cart_to_fav,
          concat(round(sum(购买量)/sum(收藏数)*100,2),'%') AS fav_to_buy
FROM user_behavior;

SELECT SUM(CASE WHEN 购买量 >=2 then 1 else 0 end)
FROM user_behavior
GROUP BY 

-- 用户留存分析，计算3，5，7日留存率（注册后n日后还登录的用户数）/第一天新增用户数
-- 第一天新用户数
CREATE TABLE retention_rate AS 
SELECT COUNT(DISTINCT user_id) AS 第一天新用户数
FROM userbehavior
WHERE dates = '2017-11-25';
-- 第二天留存用户数
ALTER TABLE retention_rate ADD COLUMN 第二天留存用户 INT;
UPDATE retention_rate 
SET 第二天留存用户 = (SELECT COUNT(DISTINCT user_id) FROM userbehavior WHERE dates = '2017-11-26'
AND user_id in (SELECT user_id FROM userbehavior WHERE dates = '2017-11-25'));
-- 第三天留存用户数
ALTER TABLE retention_rate ADD COLUMN 第三天留存用户 INT;
UPDATE retention_rate 
SET 第三天留存用户 = (SELECT COUNT(DISTINCT user_id) FROM userbehavior WHERE dates = '2017-11-27'
AND user_id in (SELECT user_id FROM userbehavior WHERE dates = '2017-11-25'));
-- 第五天留存用户数
ALTER TABLE retention_rate ADD COLUMN 第五天留存用户 INT;
UPDATE retention_rate
SET 第五天留存用户 = (SELECT COUNT(DISTINCT user_id) FROM userbehavior WHERE dates = '2017-11-29'
AND user_id in (SELECT user_id FROM userbehavior WHERE dates = '2017-11-25'));
-- 第七天留存用户数
ALTER TABLE retention_rate ADD COLUMN 第七天留存用户 INT;
UPDATE retention_rate
SET 第七天留存用户 = (SELECT COUNT(DISTINCT user_id) FROM userbehavior WHERE dates = '2017-12-1'
AND user_id in (SELECT user_id FROM userbehavior WHERE dates = '2017-11-25'));

-- 计算用户留存率
-- CREATE VIEW retention AS
-- SELECT CONCAT(ROUND(第二天留存用户/第一天新用户数),'%') AS 次日留存率，
-- 	   CONCAT(ROUND(第三天留存用户/第一天新用户数*100,2),'%') AS 三日留存率，
--        CONCAT(ROUND(第五天留存用户/第一天新用户数*100,2),'%') AS 五日留存率，
--        CONCAT(ROUND(第七天留存用户/第一天新用户数*100,2),'%') AS 七日留存率
-- FROM retention_rate;

-- 四种用户行为每时变化趋势 
-- 一天中用户的活跃时段分布
CREATE VIEW behavior_hours AS
SELECT hours AS '时段', 
	   SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS 点击量,
       SUM(CASE WHEN behavior_type = 'fav' THEN 1 ELSE 0 END) AS 收藏数,
       SUM(CASE WHEN behavior_type = 'cart' THEN 1 ELSE 0 END) AS 加购数,
       SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) AS 购买数
FROM userbehavior
GROUP BY hours
ORDER BY hours;

-- 每天用户行为数据
CREATE VIEW behavior_days AS
SELECT dates as '日期',
	   sum(case when behavior_type ='pv' then 1 else 0 end) as 点击量,
       sum(case when behavior_type ='fav' then 1 else 0 end) as 收藏数,
       sum(case when behavior_type ='cart' then 1 else 0 end) as 加购数,
       sum(case when behavior_type ='buy' then 1 else 0 end) as 购买数
FROM userbehavior
GROUP BY dates
ORDER BY dates;

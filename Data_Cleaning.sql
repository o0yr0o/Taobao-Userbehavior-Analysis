DROP TABLE IF EXISTS userbehavior;
CREATE TABLE userbehavior (userid INT,
						   itemid INT,
						   categoryid INT,
						   behavior TEXT,
						   timestamps TEXT);
ALTER TABLE userbehavior DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 缺失值处理，查询每列是否有空值 
SELECT COUNT(userid),
	   COUNT(itemid),
       COUNT(categoryid),
       COUNT(behavior),
       COUNT(timestamps)
FROM userbehavior
WHERE userid IS NULL
	  OR itemid IS NULL
      OR categoryid IS NULL
      OR behavior IS NULL
      OR timestamps IS NULL;
      
-- 将timestamps转换为日期格式，并创建dates列和hours列分别对应日期和小时 
-- 将timestamps转为日期格式 
UPDATE userbehavior SET timestamps = FROM_UNIXTIME(timestamps, '%Y-%M-%D %H:%I:%S');
-- 新建dates列并从timestamps截取日期 
ALTER TABLE userbehavior ADD dates VARCHAR(10);
UPDATE userbehavior SET dates = SUBSTRING(timestamps,1,10);
-- 新建hours列并从timestamps截取小时
ALTER TABLE userbehavior ADD hours VARCHAR(10);
UPDATE userbehavior SET hours = SUBSTRING(timestamps,12,2);

-- 异常值处理，查询dates列看是否存在异常值
-- 查询日期列最小值和最大值
SELECT MIN(dates), MAX(dates) FROM userbehavior;
-- 删除指定日期之外的异常值 
DELETE FROM userbehavior
WHERE dates < '2017-11-25' OR dates > '2017-12-03';
-- 再次查询是否有异常值，确保处理后没有异常值 
SELECT MIN(dates), MAX(dates) FROM userbehavior;
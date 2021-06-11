# Taobao Userbehavior Analysis with SQL

## Summary
With the rapid development in the m-commerce industry and continuous expansion of the platform in China. Big data can help to analyze the potential needs of consumers. This project is based on one of the biggest m-commerce platforms in China, Taobao. MySQL is used to analyze Taobao's user behaviour, explore user behaviour trends, and find high-value users from enormous data.

The data set includes all behaviours (including page view of item's page, purchase, favourites, and adding to shopping carts) of one million random users with behaviours between November 25 to December 3 in 2017. Each row of the data set represents a user's behaviour, which is composed of user ID, product ID, product category ID, behaviour type, and timestamp.

This Data set can be gathered from Alibaba's website: https://tianchi.aliyun.com/dataset/dataDetail?dataId=649&userId=1

## Analysis
We can analyze user shopping situation based on Acquisition, Activation, Retention, and Revenue.

### 1. Acquisition
![image](https://user-images.githubusercontent.com/82549782/121743203-fb1d3080-cace-11eb-8983-308ac4f13172.png)

The number of daily new users showed a declining trend from November 25 to December 3. We can offer new users discounts and promotions to attract new users who have been considering using Taobao but needed an incentive to actually change their shopping platform to Taobao.

### 2. Activation
![image](https://user-images.githubusercontent.com/82549782/121743511-77177880-cacf-11eb-8272-26981f427606.png)
![image](https://user-images.githubusercontent.com/82549782/121743536-7da5f000-cacf-11eb-8dff-2b4cb84d2598.png)

Daily user behaviour charts showed an overall upward trend from November 30 to December 2. There was an increase in page views, purchases, and the number of items added to favourites and shopping carts, due to the fact that it was the weekend. The number of items added to shopping carts and favourites was higher than the number of items purchased, which may be because users are preparing for the December 12 sale. Users are searching for the items they want, adding them to their shopping carts and favourites will allow them to buy directly at the best prices on December 12.


![image](https://user-images.githubusercontent.com/82549782/121748737-797dd080-cad7-11eb-8d16-89f80874f66d.png)
![image](https://user-images.githubusercontent.com/82549782/121748759-839fcf00-cad7-11eb-8383-bff86ae57ff1.png)

As can be seen from the distribution chart, the activity of users from 9pm to 3am every day drops sharply to the lowest value of activity in a day; from 4am to 9am, users begin to wake up and gradually increase in activity; from 5pm to 8pm, users' activity rises sharply and reaches the highest value in a day. The activity time of users is very consistent with people's normal work and rest time. Most users start to go off work at 5pm and gradually enter the rest time at 8pm. It is recommended to push promotional activities or product live broadcast during this period to users to purchase.

### 3. Retention
![image](https://user-images.githubusercontent.com/82549782/121746138-66690180-cad3-11eb-8895-da5c4372b30e.png)

The conversion rate from viewing items page to adding items to shopping cart and favourite was 9.39%, and the conversion rate from page viewing to final purchase was 2.25%. This indicates that there are a large number of users who click into the item page and view the item details but do not add the item to cart or favourite, which may be determined by several factors such as the item details page, online customer service, and comments of the items.

![image](https://user-images.githubusercontent.com/82549782/121744007-3bc97980-cad0-11eb-975c-665293416ceb.png)

Overall, new user retention is flat, the retention rate is relatively stable. 7-day retention rate is picking up, probably because December 1 is Friday which is a turning point in customer activity.

### 4. Revenue
User Repurchase Rate = number of repurchased users / total number of purchased users = 432,317 / 663,196 = 65.2%
Portion of purchase of repurchase users = purchases of repurchase users / total purchases = 1,517,023 / 1,946,706 = 77.9%

From the above results, the repurchase rate of users exceeds 50%, and the portion of purchase of repurchase users is 77.9%, indicating that the platform users are highly sticky and motivated to purchase.

## Conclusion and Recommendations
1. Due to the low conversion rate from viewing items page to adding items to shopping cart and favourite, this may be caused by the following factors:
   - The quality of item details page, such as photos are not attractive enough, item page layout is messy, item descriptions are not detailed;
   - Online customer service index, such as long customer service response time, unsatisfactory response;
   - Reviews of the items, such as low rate of review of items, the content of negative reviews, etc.
2. The user's active time is concentrated from 6pm to 11pm (peak at 8pm). New products, merchant discounts and promotions can be pushed during this active time to increase the purchase rate.
3. Daily new users shows declined trend, we can offer new users discounts and promotions to attract new users.

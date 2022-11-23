
/* ---- ---- ---- Users ---- ---- ---- */
-- Q1.Read user info (example: user_id = 1)
    SELECT * FROM users 
    WHERE user_id = 1;

-- Q2.Generate order history for a specific user (Example: user_id = 2)
    SELECT po.customer_id, po.order_id, po.timestamp, po.fee_base_price, oi.item_id
    FROM placed_orders po
    INNER JOIN order_item oi
    ON po.order_id = oi.order_id
    WHERE po.customer_id = 2
    ORDER BY po.timestamp DESC, po.order_id DESC; 

-- Q3.Find users with similar food tastes for a specific user (example. user_id = 3) 
    SELECT oh.customer_id, COUNT(DISTINCT vi.vendor_id) as similarity_val
    FROM 
        (SELECT po.customer_id, po.order_id, po.timestamp, po.fee_base_price, oi.item_id
        FROM placed_orders po
        INNER JOIN order_item oi
        ON po.order_id = oi.order_id
        ORDER BY po.timestamp DESC, po.order_id DESC) AS oh 
    INNER JOIN vendor_items vi
    ON oh.item_id = vi.item_id
    WHERE customer_id != 3 AND vi.vendor_id IN 
        (SELECT DISTINCT vendor_id
        FROM 
            (SELECT po.customer_id, po.order_id, po.timestamp, po.fee_base_price, oi.item_id
            FROM placed_orders po
            INNER JOIN order_item oi
            ON po.order_id = oi.order_id
            ORDER BY po.timestamp DESC, po.order_id DESC) AS oh 
        INNER JOIN vendor_items vi
        ON oh.item_id = vi.item_id
        WHERE customer_id = 3) 
    GROUP BY oh.customer_id
    ORDER BY COUNT(DISTINCT vi.vendor_id) DESC; 

-- Q4. Generate cuisine trends for a specific user (what kind of cuisine they tend to buy) 
    SELECT pa.customer_id, vc.cuisine_id, c.cuisine_name, COUNT(pa.customer_id) total_cuisine 
    FROM placed_orders pa 
    INNER JOIN order_item oi 
    INNER JOIN vendor_items vi 
    INNER JOIN vendor_cuisine vc 
    INNER JOIN cuisine c
    ON pa.order_id = oi.order_id 
        AND oi.item_id = vi.item_id 
        AND vi.vendor_id = vc.vendor_id 
        AND vc.cuisine_id = c.cuisine_id
    WHERE pa.customer_id = 5 
    GROUP BY vc.cuisine_id 
    ORDER BY total_cuisine DESC; 

-- Q5. Find the customer who has placed the highest number of orders.
    SELECT *
    FROM (SELECT customer_id, COUNT(*) as orderCount
            FROM placed_orders
            GROUP BY customer_id
        ) oc,
        (SELECT MAX(orderCount) as maxOrder 
            FROM( SELECT customer_id, COUNT(*) as orderCount
                    FROM placed_orders
                    GROUP BY customer_id
                ) oc1
        ) mo
    WHERE oc.orderCount = mo.maxOrder;

-- Q6. Find the user with the highest spending. (≠ the number of orders placed) 
    SELECT o.customer_id, SUM(order_fee + fee_cut_from_vendor + fee_service_fee + fee_delivery_fee + fee_tips + fee_tax) as totalSpending
    FROM placed_orders o
    JOIN
        (SELECT order_id, SUM(unit_price * unit_ordered) order_fee
          FROM order_item 
          GROUP BY order_id) of
    ON o.order_id = of.order_id
    GROUP BY o.customer_id
    ORDER BY totalSpending DESC
    LIMIT 1;

-- Q7. Identify the customer who gave the highest tips, so that we can increase the customer’s discount credit.
    SELECT PO.fee_tips,C.user_id,C.email, C.last_name, C.first_name, C.middle_name, C.discount_credit 
    FROM users C 
    INNER JOIN placed_orders PO
    ON C.user_id=PO.customer_id
    ORDER BY PO.fee_tips DESC
    LIMIT 1;



/* ---- ---- ----- Vendors ---- ---- ---- */
-- Q8. List all the vendor items from a specific vendor, and sort them by price (Example: vendor_name = 'SAQ')
    SELECT item_name, item_section, item_description, price 
    FROM vendor_items vi, vendors v 
    WHERE vi.vendor_id = v.vendor_id 
    AND vendor_name = 'SAQ'
    ORDER BY price DESC;

-- Q9. List the total number of vendor items each vendor has. 
    SELECT v.vendor_id, v.vendor_name, COUNT(vi.item_id) as item_count
    FROM vendor_items vi, vendors v
    WHERE vi.vendor_id = v.vendor_id
    GROUP BY vi.vendor_id 
    ORDER BY item_count DESC; 

-- Q10. Find the vendor with the highest sales.
    SELECT v.vendor_id, v.vendor_name, SUM(oi.unit_ordered * oi.unit_price) as Sales 
    FROM vendors v, vendor_items vi, order_item oi 
    WHERE v.vendor_id = vi.vendor_id 
    AND vi.item_id = oi.item_id 
    GROUP BY v.vendor_id 
    ORDER BY Sales DESC 
    LIMIT 1;

-- Q11. Identify the vendor products that contain eggs. 
-- This will help the customers plan on their diet such as allergy.
    SELECT vi.item_name, v.vendor_name 
    FROM vendor_items vi, vendors v
    WHERE vi.vendor_id = v.vendor_id
    AND item_description LIKE '%egg%';

-- Q12. Understand the average calories of the offerings of each vendor, 
-- and find the most ‘heavy’ vendor and also the vendor that is the most ‘clean’.
    SELECT V.vendor_id, V.vendor_name, AVG(VI.calories) AS avg_cal
    FROM vendor_items VI INNER JOIN vendors V 
    ON V.vendor_id=VI.vendor_id
    GROUP BY V.vendor_id
    ORDER BY avg_cal DESC;


-- Q13. Company A is looking to analyze the opening hours of the vendors on its platform. 
-- It is looking to incentivize vendors who are available to stay open for the longest time.  
    SELECT vendor_id, vendor_name, 
    CONCAT(
    	MOD(HOUR(TIMEDIFF(end_time, start_time)), 24), ' hours ',
     	MINUTE(TIMEDIFF(end_time, start_time)), ' minutes '
    )
    AS opening_hours
    FROM vendors 
    ORDER BY vendor_ID; 


-- Q14. Find the lowest priced item offered by each vendor. 
    SELECT vi.vendor_id, vi.item_id, vi.item_name, vi.price
    FROM vendor_items vi
    INNER JOIN
    (SELECT vendor_id, MIN(price) AS price
        FROM vendor_items
        GROUP BY vendor_id) min_price_vendor
    ON vi.vendor_id = min_price_vendor.vendor_id
    AND vi.price = min_price_vendor.price
    ORDER BY vi.vendor_id;

-- Q15. Check to see which vendors provide gluten-free options. 
-- -- Explanation:  We identify gluten-free item as FALSE
-- --               Return yes as long as it provide any gluten-free item (ANY gluten_free = 0)
-- --               Return no if it does not provide ANY gluten-free item (ALL gluten_free = 1)
-- First select all vendor that provides any gluten free item (subquery)
-- Then the vendor NOT IN this will return NO
    SELECT DISTINCT vendor_id,
    CASE 
        WHEN vendor_id NOT IN(SELECT vendor_id
                                FROM vendor_items
                                WHERE gluten_free = 0) THEN 'no'
        ELSE 'yes'
    END as check_gf
    FROM vendor_items;

-- Q16. List the vendor items which are ‘breakfast’ and available after noon 
    SELECT item_name, item_description, avl_end_time
    FROM vendor_items
    WHERE item_section = 'breakfast'
    AND avl_end_time > '12:00';



/* ---- ---- ---- COURIER ---- ---- ---- */

-- Q17. Display couriers that have not delivered any order yet. 
SELECT courier_id, CONCAT(first_name, ' ', last_name) AS full_name  FROM couriers 
WHERE courier_id NOT IN  
    (SELECT DISTINCT courier_id 
    FROM placed_orders 
    WHERE courier_id IS NOT NULL); 

-- Q18. As a result of various orders where couriers using vehicles were late in delivering, 
-- Company A is seeking to implement a policy on couriers that limits the use of vehicles that were made more than 12 years ago. 
-- The following query evaluates the impact of this potential policy by displaying the impact on couriers. 
    SELECT first_name, last_name, vehicle_year 
    FROM couriers 
    WHERE vehicle_year < YEAR(CURDATE()) - 12; 

-- Q19. Find the total amount that each courier has delivered on the platform. 
    SELECT SUM(po.fee_base_price) AS sum, po.courier_id 
    FROM placed_orders po 
    INNER JOIN couriers C 
    ON C.courier_id=po.courier_id
    WHERE po.status = 'delivered'
    GROUP BY C.courier_id 
    ORDER BY sum;

-- Q20.Find couriers that are currently working (either available or delivering)
    SELECT courier_id, first_name, last_name, current_availability
    FROM couriers
    WHERE current_availability = 'available'
    OR current_availability = 'delivering';

-- Q21. Determine the most favorable delivery method by couriers.
-- Method 1
    SELECT delivery_method, COUNT(*) as method_count
    FROM placed_orders
    GROUP BY delivery_method
    ORDER BY method_count DESC
    LIMIT 1;

-- Method 2
    SELECT delivery_method, methodCount
    FROM (SELECT delivery_method, COUNT(*) as methodCount
            FROM placed_orders
            GROUP BY delivery_method
        ) mc,
        (SELECT MAX(methodCount) as bestMethod 
            FROM( SELECT delivery_method, COUNT(*) as methodCount
                    FROM placed_orders
                    GROUP BY delivery_method
                ) mc1
        ) bm
    WHERE mc.methodCount = bm.bestMethod;

-- Method 3: Windows Function
    WITH method_ranks AS (
    SELECT DISTINCT delivery_method, 
    COUNT(*) OVER(PARTITION BY delivery_method) AS method_count
    FROM placed_orders)
    
    SELECT delivery_method 
    FROM (
            SELECT delivery_method, RANK() OVER(ORDER BY method_count DESC) method_rank
            FROM method_ranks
         ) rnk
    WHERE method_rank = 1;

/* ---- ---- ---- CUISINE ---- ---- ---- */
-- Q21. Find out which cuisine is the most popular. 
    SELECT c.cuisine_name
    FROM vendor_cuisine vc, cuisine c
    WHERE vc.cuisine_id = c.cuisine_id
    AND vc.vendor_id = (
        SELECT vendor_id 
        FROM( SELECT vi.vendor_id, COUNT(o.order_ID)  as total_orders
                FROM vendor_items vi, order_item oi, placed_orders o
                WHERE vi.item_id = oi.item_id                 
                AND oi.order_id = o.order_id
                GROUP BY vi.vendor_id
                ORDER BY total_orders DESC
                LIMIT 1) q1
            );

/* ---- ---- ---- BOROUGH ---- ---- ---- */
-- Q22. List the fee cut from Uber of the restaurants in the borough named ‘Rosemont–La Petite-Patrie’, and rank the data from high to low.

    SELECT PO.fee_cut_from_vendor, V.vendor_id,V.vendor_type,V.vendor_name
    FROM vendors V 

    INNER JOIN placed_orders PO 
    INNER JOIN vendor_items VI
    INNER JOIN order_item OI
    INNER JOIN borough B 

    ON OI.order_id=PO.order_id 
    AND OI.item_id = VI.item_id
    AND VI.vendor_id = V.vendor_id
    AND PO.delivery_borough_id=B.borough_id

    WHERE vendor_type='restaurant' AND B.borough_id=3
    ORDER BY PO.fee_cut_from_vendor DESC;


-- Q23. Count the number of users per boroughs. 
    SELECT b.borough_id, b.borough_name, COUNT(*) as number_users
    FROM borough b, user_location ul 
    WHERE b.borough_id = ul.borough_id
    GROUP BY b.borough_id;


/* ---- ---- ---- ---- ORDERS ---- ---- ---- */
-- Q24. For orders which have not been delivered, display their customers and respective stores's names.
    SELECT o.order_id, o.status, CONCAT(u.first_name, ' ', u.last_name) as customer_name, v.vendor_name
    FROM placed_orders o, users u, order_item oi, vendor_items vi, vendors v
    WHERE o.customer_id = u.user_id 
    AND o.order_id = oi.order_id 
    AND oi.item_id = vi.item_id 
    AND vi.vendor_id = v.vendor_id
    AND o.status != 'delivered';

-- Q25. List the number of orders per placed through the platform per month.
    SELECT date_format(timestamp, '%M') AS month, COUNT(*) AS sales_per_month
    FROM placed_orders o
    GROUP BY month
    ORDER BY sales_per_month DESC;


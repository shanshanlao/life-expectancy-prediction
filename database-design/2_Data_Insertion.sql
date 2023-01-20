INSERT INTO borough (borough_name) VALUES 
	('Côte-des-Neiges–Notre-Dame-de-Grâce'), 
	('Villeray–Saint-Michel–Parc-Extension'), 
	('Rosemont–La Petite-Patrie'), 
	('Mercier–Hochelaga-Maisonneuve'), 
	('Ahuntsic-Cartierville');

INSERT INTO borough_fees (borough_from, borough_to,fee) VALUES 
	('1','1','2'), ('1','2','6'), ('1','3','3'), ('1','4','5'), ('1','5','6'), 
	('2','1','3'), ('2','2','2'), ('2','3','4'), ('2','4','4'), ('2','5','3'), 
	('3','1','3'), ('3','2','3'), ('3','3','2'), ('3','4','3'), ('3','5','4'), 
	('4','1','3'), ('4','2','4'), ('4','3','3'), ('4','4','2'), ('4','5','3'), 
	('5','1','5'), ('5','2','5'), ('5','3','3'), ('5','4','3'), ('5','5','2');

INSERT INTO users (email,password,username,phone,identity_document,date_of_birth,last_name,first_name,middle_name,credit_card_number,credit_card_expiry_date,credit_card_CVV,discount_credit) VALUES
	('Delany.Rick@mail.com','temp_pass','Delany.Rick','19852109637','https://www.google.ca/','1995-4-19','Delany','Rick','L.','492932433991','45017','725','0'),
	('Pumphrey.Elizabeth@mail.com','temp_pass','Pumphrey.Elizabeth','13143892236','https://www.google.ca/','1997-3-8','Pumphrey','Elizabeth','J.','545420549002','45200','83','0'),
	('Dubin.Janet@mail.com','temp_pass','Dubin.Janet','13366685902','https://www.google.ca/','1985-2-27','Janet','Dubin','C.','448584158188','46327','224','0'),
	('Patterson.Kirk@mail.com','temp_pass','Patterson.Kirk','16157184368','https://www.google.ca/','1988-6-26','Kirk','Patterson','W.','556690011429','45017','77','0'),
	('Parker.Adam@mail.com','temp_pass','Parker.Adam','12157076470','https://www.google.ca/','1993-9-23','Adam','Parker','S.','448552362792','46631','66','50');

INSERT INTO  user_location (user_id,street_number,city,country,postal_code,borough_id) VALUES
	('1','2901 James Street','Burnaby','Canada','V5G1J9','1'),
	('1','691 Venture Place','High Prairie','Canada','T0G1E0','5'),
	('2','3805 Roger Street','Comox','Canada','V9N6A1','1'),
	('2','1805 Fourth Avenue','Calgary','Canada','T2P0H3','4'),
	('3','995 rue Parc','Sherbrooke','Canada','J1H1R6','2'),
	('4','4987 Blanshard','Victoria','Canada','V8W2H9','3'),
	('5','4511 Silver Springs Blvd','Calgary','Canada','T3B2C3','3');

INSERT INTO couriers (phone_number,email,password,username,last_name,first_name,middle_name,work_permit,driver_license,street_number,city,country,postal_code,SIN,vehicle_year,vehicle_make,vehicle_color,vehicle_license_plate,vehicle_insurance_number,vehicle_insurance_expiry,payment_frequency,direct_deposit,current_availability,current_location_GPS,current_delivery_method) VALUES
	('15056447558','Jones.Gregory@mail.com','temp_pass','Jones.Gregory','Jones','Gregory','A.',	'https://www.google.ca/','https://www.google.ca/','422 Melisa Mountains','Israelland','Canada','H1G0J1','139518829','2006','honda','red','ABCD EFGH','9783586289','04/2025','monthly','23663-2319-324295221597','available','123123','car'),
	('1505644207','Rivera.Kimberly@mail.com','temp_pass','Rivera.Kimberly','Rivera','Kimberly','B.','https://www.google.ca/','https://www.google.ca/','74069 Luella Cliffs','Jettfurt','Canada','B3F4I9','712236381','2015','toyota','gray','ABCD EFGH','2763633257','10/2025','bimonthly','81465-5365-297789165888','available','123123','car'),
	('15055960698','Alvarado.Angela@mail.com','temp_pass','Alvarado.Angela','Alvarado','Angela','C.','https://www.google.ca/','https://www.google.ca/','0750 Weldon Square','Abshirefurt','Canada','R9Y4J0','836689257','2009','audi','blue','ABCD EFGH','3927324476','11/2027','monthly','76321-7882-175149727314','not available',NULL,NULL),
	('15823223033','Wilson.Linda@mail.com','temp_pass','Wilson.Linda','Wilson','Linda','D.','https://www.google.ca/','https://www.google.ca/','29685 Ratke Union','Lake Bertram','Canada','H4F2H4','729547787','2017','toyota','green','ABCD EFGH','8339343587','04/2028','bimonthly','91946-3689-229715879869','not available',NULL,NULL),
	('15056638073','Baker.Dominic@mail.com','temp_pass','Baker.Dominic','Baker','Dominic','E.','https://www.google.ca/','https://www.google.ca/','16019 Courtney Route','South Kolby','Canada','X1N5L0','315681765',NULL,NULL,NULL,NULL,NULL,NULL,'bimonthly','16444-3617-982839753537','delivering','123123','bike');

INSERT INTO  vendors (vendor_type,username,email,password,phone_number,device_id,vendor_name,start_time,end_time,street_number,city,country,postal_code,borough_id) VALUES
	('grocery','Walmart-username','Walmart@mail.com','temp_pass','15825836488','361523923','Walmart','07:00:00','23:00:00','','Gleichnerstad','Canada','Y3P4C9','1'),
	('liquor','SAQ-username','SAQ@mail.com','temp_pass','15826001895','869382641','SAQ','07:00:00','23:00:00','','Funkmouth','Canada','T7A3P5','2'),
	('restaurant','La Banquise-username','La Banquise@mail.com','temp_pass','1248690025','237758216','La Banquise','00:00:00','23:59:59','','Port Darbychester','Canada','A9A8Y8','3'),
	('restaurant','McDonalds-username','McDonalds@mail.com','temp_pass','12312086188','575856586','McDonalds','07:00:00','23:00:00','','Arnaldohaven','Canada','S4S2B8','1'),
	('restaurant','Freshii-username','Freshii@mail.com','temp_pass','1582262963','455238415','Freshii','07:00:00','23:00:00','','New Natashaside','Canada','T1S5V4','1'),
	('restaurant','Yinji-username','Yinji@mail.com','temp_pass','5142357357','835486164','YinJi ChangFen','10:00:00','22:00:00','1861','Montreal','Canada','H3H1M2','1'),
	('restaurant','Qinghua-username','Qinghua@mail.com','temp_pass','5142628494','681593111','QingHua Dumplings','11:00:00','23:00:00','','Montreal','Canada','H3H1J6','5'),
	('resetaurant','kazumi-username','kazumi@mail.com','temp_pass','64789023567','725493415','Kazumi Sushi Lounge','17:00:00','21:00:00','','Port Somewhere','Canada','S4S2B9','4');

INSERT INTO  vendor_items (item_name,item_section,item_description,price,discount,availability_status,avl_start_time,avl_end_time,allergy_info,gluten_free,calories,vendor_id) VALUES
	('Egg McMuffin','breakfast','bread and egg','4.19','0',TRUE,'07:00:00','11:00:00',FALSE,TRUE,'228','4'),
	('Bacon and Egg McMuffin','breakfast','bread, egg, with bacon','3.89','0',TRUE,'07:00:00','11:00:00',FALSE,TRUE,'305','4'),
	('Big Mac','burger','beef patties with sesame seed bum','5.69','0',TRUE,'07:00:00','23:00:00',FALSE,TRUE,'257','4'),
	('Caesar Salad','salad','leaves and sauce','2.89','0',TRUE,'07:00:00','23:00:00',FALSE,FALSE,'44','4'),
	('20 Chicken McNuggets','Chicken','fried chicken nugget','10.29','0',TRUE,'07:00:00','23:00:00',FALSE,FALSE,'960','4'),
	('Lays Classic potato chips','snacks','Specially Selected Potatoes','3.27','0',TRUE,'07:00:00','23:00:00',FALSE,FALSE,'150','1'),
	('Local strawberries','fruits & vegetables','local strawbeeries','3.97','0',TRUE,'07:00:00','23:00:00',FALSE,FALSE,'30','1'),
	('Banana','fruits & vegetables','banana','0.3','0',TRUE,'07:00:00','23:00:00',FALSE,FALSE,'15','1'),
	('White Castle Butter Cookie','snacks','cookie with butter','4.97','0',TRUE,'07:00:00','23:00:00',TRUE,FALSE,'1050','1'),
	('La Taquise','poutine','guacamole, sour cream & tomatoes','13.25','0',TRUE,'00:00:00','23:59:59',FALSE,FALSE,'510','3'),
	('La Festival','poutine','ground beef, swiss cheese, hot peppers & onion rings','13.95','0',TRUE,'00:00:00','23:59:59',FALSE,FALSE,'750','3'),
	('Le Traditionnel','breakfast','2 eggs, bacon or pork & beef sausages or ham, toasts','8.25','0',TRUE,'00:00:00','23:59:59',FALSE,FALSE,'700','3'),
	('Toast & Jam','breakfast','ham, honey or peanut butter, with coffee','3.95','0',TRUE,'00:00:00','23:59:59',FALSE,TRUE,'600','3'),
	('1769 Distillery Azura','Dry gin','42% alcohol','43.75','0',TRUE,'09:30:00','21:00:00',FALSE,FALSE,'500','2'),
	('1800 Blanco','Tequila','double distilled and blended with a special selection of white tequilas','37.25','0',TRUE,'09:30:00','21:00:00',FALSE,FALSE,'400','2'),
	('Marinated pork & shrimp with chives rice noodle roll','rice noodle roll','rice noddle roll with prok and shrimp','11.56','0',TRUE,'10:00:00','22:00:00',TRUE,TRUE,'550','6'),
	('BBQ pork with chives rice noodle roll','rice noodle roll','rice noddle with BBQ pork','9.69','0',TRUE,'10:00:00','22:00:00',TRUE,TRUE,'450','6'),
	('Fried dough rice noodle roll','rice noodle roll','rice noodle with fried dough','9.38','0',TRUE,'17:00:00','21:00:00',TRUE,TRUE,'950','6'),
	('Tofu et legume','vegetables','tofu dumplings','16.89','0',TRUE,'11:00:00','23:00:00',TRUE,TRUE,'360','7'),
	('Poulet et coriandre','chicken','chicken & corriander dumplings','16.89','0',TRUE,'11:00:00','23:00:00',TRUE,TRUE,'480','7'),
	('Cheech and Chong Roll','sushi','Smoked salmon, avocado, and deep-fried in tempura drizzled with sweet soy.','13.5','0',TRUE,'17:00:00','21:00:00',FALSE,TRUE,'166','8'),
	('Coyote Roll','sushi','Chipotle crab and tempura serrano pepper topped with salmon','17','0',TRUE,'17:00:00','21:00:00',FALSE,FALSE,'150','8');

INSERT INTO cuisine (cuisine_name) VALUES 
	('french'), 
	('chinese'), 
	('japanese'), 
	('italian'), 
	('fast food');

INSERT INTO vendor_cuisine (vendor_id,cuisine_id) VALUES 
	('3', '1'), 
	('4', '5'), 
	('5', '5'), 
	('6', '2'), 
	('7', '2'), 
	('8', '3');

INSERT INTO licenses (license_name) VALUES 
	('liquor license'), 
	('grocery license'), 
	('food ministry license'), 
	('sanitation license '), 
	('corporate registry license');

INSERT INTO vendor_licenses (vendor_id,license_id) VALUES 
	('1', '1'), 
	('2', '2'), 
	('3', '3'), 
	('4', '3'), 
	('5', '3');

INSERT INTO placed_orders (timestamp, fee_base_price,fee_cut_from_vendor,fee_service_fee,fee_delivery_fee,fee_tips,fee_tax,status, delivery_street_number,delivery_city,delivery_country,delivery_postal_code,delivery_borough_id,delivery_method,payment_reference, chat_history,customer_id,courier_id) VALUES
	('2022-04-04 17:00:51', '8.08','2.42','2','0','1.36','1.51','delivered', '3550 ja mont','Montreal','canada','Y2Y5N5','3','pickup','google.ca', 'google.ca','4',null),
	('2022-07-09 04:30:59', '7.24','2.17','2','6','0.26','2.29','placed', '3927 mon camp st','Montreal','canada','H8X 3P7','2','scooter','google.ca', 'google.ca','3','2'),
	('2022-07-25 15:14:00', '53','15.9','2','5','6.54','9','delivered', '4820 elm st','Montreal','canada','P2Y5N5','3','walking','google.ca', 'google.ca','5','3'),
	('2022-03-23 01:10:50', '43.75','13.13','2','2','4.03','7.16','in preparation', '2550 due roche st','Montreal','canada','N1Y7M2','4','car','google.ca', 'google.ca','2','4'),
	('2022-07-19 05:41:49', '37.25','11.18','2','0','1.11','5.89','delivered', '3598 mansfield st','Montreal','canada','R2Y5N6','5','pickup','google.ca', 'google.ca','1',null),
	('2022-05-19 05:05:44', '1.5','0.45','2','2','0.26','0.83','delivered', '7568 drummond st','Montreal','canada','B2Y5L3','1','scooter','google.ca', 'google.ca','1','1'),
	('2022-02-06 07:29:34', '9.94','2.98','2','2','0.67','2.09','placed', '2550 due roche st','Montreal','canada','N1Y7M2','4','car','google.ca', 'google.ca','2','3'),
	('2022-04-02 23:07:29', '28.45','8.54','2','5','1.88','5.32','in preparation', '4820 elm st','Montreal','canada','P2Y5N5','3','car','google.ca', 'google.ca','5','1'),
	('2022-04-18 11:33:22', '8.67','2.6','2','3','0.49','2.05','delivered', '1234 sendeni st','Montreal','canada','Y4Y5N5','2','walking','google.ca', 'google.ca','3','2'),
	('2022-03-08 21:04:34', '20.58','6.17','2','5','1.99','4.14','delivered', '4820 elm st','','','P2Y5N5','3','scotter','google.ca', 'google.ca','5','4');

INSERT INTO order_item (unit_ordered,unit_price,order_id,item_id) VALUES 
	('1', '4.19','1','1'), 
	('1', '3.89','1','2'), 
	('1', '3.27','2','6'), 
	('1', '3.97','2','7'), 
	('4', '13.25','3','10'), 
	('1', '43.75','4','14'), 
	('1', '37.25','5','15'), 
	('5', '0.3','6','8'), 
	('2', '4.97','7','9'), 
	('5', '5.69','8','3'), 
	('3', '2.89','9','4'), 
	('2', '10.29','10','5');

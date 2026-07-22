USE [ProductIntro_WS2_ThangNDC_SE203709];
GO

BEGIN TRANSACTION;

UPDATE categories SET categoryName = N'Kitchenware' WHERE typeId = 1;
UPDATE categories SET categoryName = N'Home Appliances' WHERE typeId = 2;
UPDATE categories SET categoryName = N'Home Decor' WHERE typeId = 3;
UPDATE categories SET categoryName = N'Fitness Equipment' WHERE typeId = 4;
UPDATE categories SET categoryName = N'Smart Devices' WHERE typeId = 5;
UPDATE categories SET categoryName = N'Fashion Apparel' WHERE typeId = 6;

UPDATE products SET productName = N'SUNHOUSE 3-Ply Stainless Steel Cookware Set', productImage = N'/images/sanPham/boNoiInoxSunhouse.jpg', brief = N'Durable stainless steel cookware with heat-resistant handles, tempered glass lids, and induction-ready bases for everyday cooking.', unit = N'set' WHERE productId = N'SHG2303MRA';
UPDATE products SET productName = N'Nagakawa Premium Stainless Steel Pressure Cooker', productImage = N'/images/sanPham/noiApSuatNagakawa.jpg', brief = N'Safe pressure cooker with dual valves, sealed lid design, 304 stainless steel body, and a 3-layer base for even heat distribution.', unit = N'set' WHERE productId = N'NAG1452';
UPDATE products SET productName = N'Tefal Nonstick Frying Pan Combo', productImage = N'/images/sanPham/chaoChienTefal.jpg', brief = N'Two-pan nonstick combo with durable titanium coating, easy-clean exterior, and smart heat indicator for reliable home cooking.', unit = N'set' WHERE productId = N'SHG2303TEF';
UPDATE products SET productName = N'Relax Lounge Chair', productImage = N'/images/sanPham/gheThuGian.jpg', brief = N'Comfortable folding lounge chair made with sturdy materials for home, office, balcony, or outdoor relaxation.', unit = N'piece' WHERE productId = N'4062373305';
UPDATE products SET productName = N'IGEA Nordic Style Sofa Coffee Table', productImage = N'/images/sanPham/banTraSofaIGEA.jpg', brief = N'Modern MDF coffee table with melamine finish, oak legs, compact dimensions, and a clean white Nordic look.', unit = N'piece' WHERE productId = N'8868354221';
UPDATE products SET productName = N'Seven-Tier Shoe Rack Organizer', productImage = N'/images/sanPham/keGiaDeGiay.jpg', brief = N'Space-saving seven-tier shoe rack with water-resistant melamine frame, easy assembly, and storage capacity for up to 12 pairs.', unit = N'piece' WHERE productId = N'2759614408';
UPDATE products SET productName = N'Nordic TV Stand T350-1', productImage = N'/images/sanPham/keTiviPhongCachBacAu.png', brief = N'Minimal multi-purpose TV stand made from imported MDF with melamine coating, modern wood and white finish, and practical storage.', unit = N'set' WHERE productId = N'5746333511';
UPDATE products SET productName = N'Toshiba Inverter Front Load Washing Machine', productImage = N'/images/sanPham/mayGiatToshiba.jpg', brief = N'9.5 kg Toshiba inverter front-load washer with a modern horizontal drum, energy-saving operation, and elegant white design.', unit = N'set' WHERE productId = N'BK105S2VWS';
UPDATE products SET productName = N'Panasonic Inverter Washing Machine 10.5 kg', productImage = N'/images/sanPham/mayGiatPanasonic.jpg', brief = N'10.5 kg Panasonic inverter washer with StainMaster cleaning technology for stronger stain removal and efficient daily laundry.', unit = N'set' WHERE productId = N'NAFD10AR1B';
UPDATE products SET productName = N'Panasonic Inverter Refrigerator 642L', productImage = N'/images/sanPham/tuLanhPanasonic.png', brief = N'Large 642L Panasonic six-door inverter refrigerator with glass finish, strong tempered shelves, and flexible food storage.', unit = N'set' WHERE productId = N'NRF654GTX2';
UPDATE products SET productName = N'Electrolux Inverter Refrigerator 524L', productImage = N'/images/sanPham/tuLanhELECTROLUX.png', brief = N'524L Electrolux refrigerator with 360-degree cooling, stable shelf-by-shelf temperature control, and TasteLock crisper storage.', unit = N'set' WHERE productId = N'EHE5224B-A';
UPDATE products SET productName = N'Premium Adjustable Ankle Weights', productImage = N'/images/sanPham/taDeoChanCaoCap.jpg', brief = N'Adjustable ankle weights with durable polyester fabric, chrome-plated steel bars, and comfortable fit for strength training.', unit = N'set' WHERE productId = N'7823080768';
UPDATE products SET productName = N'Fitme Body Compression Sports Shirt', productImage = N'/images/sanPham/aoTheThaoFitness.png', brief = N'High-performance compression sports shirt for gym, basketball, football, volleyball, and high-intensity training sessions.', unit = N'piece' WHERE productId = N'6075086733';
UPDATE products SET productName = N'Wall-Mounted Pull-Up Bar', productImage = N'/images/sanPham/xaDonTreoTuong.jpg', brief = N'Adjustable wall-mounted pull-up bar for upper-body workouts, core training, and compact home fitness routines.', unit = N'set' WHERE productId = N'8640589401';
UPDATE products SET productName = N'Air Walker Exercise Machine', productImage = N'/images/sanPham/mayChayBoTrenKhong.jpg', brief = N'Compact air walker exercise machine for cardio training, walking motion, arm movement, and low-impact home workouts.', unit = N'set' WHERE productId = N'9024218247';
UPDATE products SET productName = N'Plaid Bow Babydoll Dress', productImage = N'/images/sanPham/vayBabadollCaro.jpg', brief = N'Lightweight plaid babydoll dress with round neckline, bow detail, and soft textured fabric for casual styling.', unit = N'piece' WHERE productId = N'6681948644';
UPDATE products SET productName = N'Short-Sleeve Plain Mens Shirt', productImage = N'/images/sanPham/aoSoMiNamNganTay.jpg', brief = N'Modern slim-fit short-sleeve shirt for office and casual wear with a clean, youthful, and polished look.', unit = N'piece' WHERE productId = N'1688993802';
UPDATE products SET productName = N'Water-Resistant Laptop Backpack', productImage = N'/images/sanPham/baloNuChongNuoc.jpg', brief = N'Stylish water-resistant laptop backpack with practical compartments, compact design, and everyday school or work utility.', unit = N'piece' WHERE productId = N'4494738964';
UPDATE products SET productName = N'Womens Athletic Sneakers', productImage = N'/images/sanPham/giayTheThaoNu.jpg', brief = N'Comfortable athletic sneakers with modern styling, rubber outsole, soft cushioning, and sizes from 35 to 39.', unit = N'pair' WHERE productId = N'9680372888';
UPDATE products SET productName = N'Mens High-Top Leather Boots', productImage = N'/images/sanPham/giayBotDaNamCaoCo.jpg', brief = N'High-top mens boots with bold styling, synthetic leather upper, breathable fabric details, and black or brown options.', unit = N'pair' WHERE productId = N'8709925437';
UPDATE products SET productName = N'iPhone 11 Pro Max 64GB', productImage = N'/images/sanPham/iPhone11_ProMax.jpg', brief = N'Premium iPhone 11 Pro Max with strong performance, refreshed design, and advanced rear camera system for everyday use.', unit = N'piece' WHERE productId = N'11MAX64213';
UPDATE products SET productName = N'Samsung Galaxy Note 10 Plus', productImage = N'/images/sanPham/samsungGalaxyNote10Plus.jpg', brief = N'Samsung Galaxy Note 10 Plus with vivid color design, Gorilla Glass protection, polished finish, and intuitive One UI experience.', unit = N'piece' WHERE productId = N'10NOTEP256';
UPDATE products SET productName = N'Xiaomi Redmi Note 8', productImage = N'/images/sanPham/XiaomiRedmiNote8.jpg', brief = N'Xiaomi Redmi Note 8 smartphone with quad-camera setup, Gorilla Glass protection, and a 48 MP main camera for sharp photos.', unit = N'piece' WHERE productId = N'XRN8012121';
UPDATE products SET productName = N'Y98 Bluetooth Sports Headphones', productImage = N'/images/sanPham/TaiNgheBluetoothY98.jpg', brief = N'Bluetooth sports headphones designed for workouts, active listening, and long training sessions with comfortable wireless use.', unit = N'set' WHERE productId = N'Y98HEAD802';

COMMIT;
GO

SELECT typeId, categoryName FROM categories ORDER BY typeId;
SELECT TOP 8 productId, productName FROM products ORDER BY postedDate DESC, productId DESC;
GO

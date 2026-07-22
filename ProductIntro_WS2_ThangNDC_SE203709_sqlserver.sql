IF DB_ID(N'ProductIntro_WS2_ThangNDC_SE203709') IS NULL
BEGIN
    CREATE DATABASE [ProductIntro_WS2_ThangNDC_SE203709];
END
GO

USE [ProductIntro_WS2_ThangNDC_SE203709];
GO

SET NOCOUNT ON;
DROP TABLE IF EXISTS [orderdetails];
DROP TABLE IF EXISTS [orders];
DROP TABLE IF EXISTS [viewhistory];
DROP TABLE IF EXISTS [cart];
DROP TABLE IF EXISTS [products];
DROP TABLE IF EXISTS [categories];
DROP TABLE IF EXISTS [accounts];

CREATE TABLE [accounts] (
    account NVARCHAR(20) PRIMARY KEY NOT NULL,
    pass NVARCHAR(20) NOT NULL,
    lastName NVARCHAR(50) NULL,
    firstName NVARCHAR(30) NOT NULL,
    birthday DATETIME2 NULL,
    gender BIT DEFAULT 1,
    phone NVARCHAR(20),
    isUse BIT DEFAULT 0,
    roleInSystem INT DEFAULT 0,
    sessionId NVARCHAR(128) NULL
);

CREATE TABLE [categories] (
    typeId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    categoryName NVARCHAR(88) NOT NULL,
    memo NVARCHAR(MAX) DEFAULT NULL
);

CREATE TABLE [products] (
    productId NVARCHAR(10) PRIMARY KEY NOT NULL,
    productName NVARCHAR(500) NOT NULL,
    productImage NVARCHAR(MAX),
    brief NVARCHAR(MAX),
    postedDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    typeId INT NOT NULL,
    account NVARCHAR(20) NOT NULL,
    unit NVARCHAR(32) DEFAULT N'pcs',
    price INT DEFAULT 0,
    discount INT DEFAULT 0 CHECK (discount >= 0 AND discount <= 100),
    CONSTRAINT fk_products_category FOREIGN KEY (typeId) REFERENCES categories(typeId),
    CONSTRAINT fk_products_account FOREIGN KEY (account) REFERENCES accounts(account) ON UPDATE CASCADE
);

-- Seed data for administrative accounts, storefront categories, and products
insert into accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem)
values(N'manager',N'123',N'Nguyen Minh',N'Quang',N'1996-06-12',1,N'0935694223',1,2);
insert into accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem)
values(N'admin',N'abc',N'Nguyen Quang',N'Hung',N'1996-10-28',1,N'0705101028',1,1);
insert into categories(categoryName) values(N'Kitchenware');
insert into categories(categoryName) values(N'Home Appliances');
insert into categories(categoryName) values(N'Home Decor');
insert into categories(categoryName) values(N'Fitness Equipment');
insert into categories(categoryName) values(N'Smart Devices');
insert into categories(categoryName) values(N'Fashion Apparel');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'SHG2303MRA', N'SUNHOUSE 3-Ply Stainless Steel Cookware Set', N'/images/sanPham/boNoiInoxSunhouse.jpg',
       N'Durable stainless steel cookware with heat-resistant handles, tempered glass lids, and induction-ready bases for everyday cooking.',
       N'manager', 399000,10,1, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'NAG1452', N'Nagakawa Premium Stainless Steel Pressure Cooker', N'/images/sanPham/noiApSuatNagakawa.jpg',
       N'Safe pressure cooker with dual valves, sealed lid design, 304 stainless steel body, and a 3-layer base for even heat distribution.',
       N'manager', 1328000,5,1, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'SHG2303TEF', N'Tefal Nonstick Frying Pan Combo', N'/images/sanPham/chaoChienTefal.jpg',
       N'Two-pan nonstick combo with durable titanium coating, easy-clean exterior, and smart heat indicator for reliable home cooking.',
       N'admin', 709000,0,1, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'4062373305', N'Relax Lounge Chair', N'/images/sanPham/gheThuGian.jpg',
       N'Comfortable folding lounge chair made with sturdy materials for home, office, balcony, or outdoor relaxation.',
       N'admin', 699000,10,3, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'8868354221', N'IGEA Nordic Style Sofa Coffee Table', N'/images/sanPham/banTraSofaIGEA.jpg',
       N'Modern MDF coffee table with melamine finish, oak legs, compact dimensions, and a clean white Nordic look.',
       N'manager', 290000,5,3, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'2759614408', N'Seven-Tier Shoe Rack Organizer', N'/images/sanPham/keGiaDeGiay.jpg',
       N'Space-saving seven-tier shoe rack with water-resistant melamine frame, easy assembly, and storage capacity for up to 12 pairs.',
       N'admin', 439000,10,3, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'5746333511', N'Nordic TV Stand T350-1', N'/images/sanPham/keTiviPhongCachBacAu.png',
       N'Minimal multi-purpose TV stand made from imported MDF with melamine coating, modern wood and white finish, and practical storage.',
       N'admin', 569000,0,3, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'BK105S2VWS', N'Toshiba Inverter Front Load Washing Machine', N'/images/sanPham/mayGiatToshiba.jpg',
       N'9.5 kg Toshiba inverter front-load washer with a modern horizontal drum, energy-saving operation, and elegant white design.',
       N'manager', 7390000,0,2, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'NAFD10AR1B', N'Panasonic Inverter Washing Machine 10.5 kg', N'/images/sanPham/mayGiatPanasonic.jpg',
       N'10.5 kg Panasonic inverter washer with StainMaster cleaning technology for stronger stain removal and efficient daily laundry.',
       N'manager', 9290000,0,2, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'NRF654GTX2', N'Panasonic Inverter Refrigerator 642L', N'/images/sanPham/tuLanhPanasonic.png',
       N'Large 642L Panasonic six-door inverter refrigerator with glass finish, strong tempered shelves, and flexible food storage.',
       N'admin', 88990000,0,2, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'EHE5224B-A', N'Electrolux Inverter Refrigerator 524L', N'/images/sanPham/tuLanhELECTROLUX.png',
       N'524L Electrolux refrigerator with 360-degree cooling, stable shelf-by-shelf temperature control, and TasteLock crisper storage.',
       N'manager', 22590000,0,2, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'7823080768', N'Premium Adjustable Ankle Weights', N'/images/sanPham/taDeoChanCaoCap.jpg',
       N'Adjustable ankle weights with durable polyester fabric, chrome-plated steel bars, and comfortable fit for strength training.',
       N'manager', 315000,0,4, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'6075086733', N'Fitme Body Compression Sports Shirt', N'/images/sanPham/aoTheThaoFitness.png',
       N'High-performance compression sports shirt for gym, basketball, football, volleyball, and high-intensity training sessions.',
       N'admin', 152000,0,4, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'8640589401', N'Wall-Mounted Pull-Up Bar', N'/images/sanPham/xaDonTreoTuong.jpg',
       N'Adjustable wall-mounted pull-up bar for upper-body workouts, core training, and compact home fitness routines.',
       N'manager', 119000,0,4, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'9024218247', N'Air Walker Exercise Machine', N'/images/sanPham/mayChayBoTrenKhong.jpg',
       N'Compact air walker exercise machine for cardio training, walking motion, arm movement, and low-impact home workouts.',
       N'admin', 1020000,0,4, N'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'6681948644', N'Plaid Bow Babydoll Dress', N'/images/sanPham/vayBabadollCaro.jpg',
       N'Lightweight plaid babydoll dress with round neckline, bow detail, and soft textured fabric for casual styling.',
       N'admin', 109000,0,6, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'1688993802', N'Short-Sleeve Plain Mens Shirt', N'/images/sanPham/aoSoMiNamNganTay.jpg',
       N'Modern slim-fit short-sleeve shirt for office and casual wear with a clean, youthful, and polished look.',
       N'admin', 99000,0,6, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'4494738964', N'Water-Resistant Laptop Backpack', N'/images/sanPham/baloNuChongNuoc.jpg',
       N'Stylish water-resistant laptop backpack with practical compartments, compact design, and everyday school or work utility.',
       N'admin', 105000,0,6, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'9680372888', N'Womens Athletic Sneakers', N'/images/sanPham/giayTheThaoNu.jpg',
       N'Comfortable athletic sneakers with modern styling, rubber outsole, soft cushioning, and sizes from 35 to 39.',
       N'manager', 153000,0,6, N'pair');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'8709925437', N'Mens High-Top Leather Boots', N'/images/sanPham/giayBotDaNamCaoCo.jpg',
       N'High-top mens boots with bold styling, synthetic leather upper, breathable fabric details, and black or brown options.',
       N'manager', 189000,0,6, N'pair');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'11MAX64213', N'iPhone 11 Pro Max 64GB', N'/images/sanPham/iPhone11_ProMax.jpg',
       N'Premium iPhone 11 Pro Max with strong performance, refreshed design, and advanced rear camera system for everyday use.',
       N'admin', 26500000,0,5, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'10NOTEP256', N'Samsung Galaxy Note 10 Plus', N'/images/sanPham/samsungGalaxyNote10Plus.jpg',
       N'Samsung Galaxy Note 10 Plus with vivid color design, Gorilla Glass protection, polished finish, and intuitive One UI experience.',
       N'admin', 25450000,0,5, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'XRN8012121', N'Xiaomi Redmi Note 8', N'/images/sanPham/XiaomiRedmiNote8.jpg',
       N'Xiaomi Redmi Note 8 smartphone with quad-camera setup, Gorilla Glass protection, and a 48 MP main camera for sharp photos.',
       N'manager', 3750000,0,5, N'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values(N'Y98HEAD802', N'Y98 Bluetooth Sports Headphones', N'/images/sanPham/TaiNgheBluetoothY98.jpg',
       N'Bluetooth sports headphones designed for workouts, active listening, and long training sessions with comfortable wireless use.',
       N'manager', 299000,0,5, N'set');
CREATE TABLE [cart] (
    account NVARCHAR(20) NOT NULL,
    productId NVARCHAR(10) NOT NULL,
    quantity INT DEFAULT 1,
    PRIMARY KEY (account, productId),
    CONSTRAINT fk_cart_account FOREIGN KEY (account) REFERENCES accounts(account) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
);

CREATE TABLE [viewhistory] (
    account NVARCHAR(20) NOT NULL,
    productId NVARCHAR(10) NOT NULL,
    viewedAt DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (account, productId),
    CONSTRAINT fk_viewhistory_account FOREIGN KEY (account) REFERENCES accounts(account) ON DELETE CASCADE,
    CONSTRAINT fk_viewhistory_product FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
);

CREATE TABLE [orders] (
    orderId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    account NVARCHAR(20),
    orderDate DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    address NVARCHAR(500) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    status INT DEFAULT 0,
    CONSTRAINT fk_orders_account FOREIGN KEY (account) REFERENCES accounts(account)
);

CREATE TABLE [orderdetails] (
    orderId INT NOT NULL,
    productId NVARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    price INT NOT NULL,
    discount INT DEFAULT 0,
    PRIMARY KEY (orderId, productId),
    CONSTRAINT fk_orderdetails_order FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
    CONSTRAINT fk_orderdetails_product FOREIGN KEY (productId) REFERENCES products(productId)
);

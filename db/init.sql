SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS viewhistory;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS accounts;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE accounts (
    account VARCHAR(20) PRIMARY KEY NOT NULL,
    -- Wide enough for a PBKDF2 hash ("pbkdf2$<iters>$<salt>$<hash>", ~100 chars).
    -- The seed rows below still hold plain text; the app hashes them in place
    -- the first time each account logs in successfully.
    pass VARCHAR(255) NOT NULL,
    lastName VARCHAR(50) NULL,
    firstName VARCHAR(30) NOT NULL,
    birthday DATETIME NULL,
    gender BOOLEAN DEFAULT TRUE,
    phone VARCHAR(20),
    isUse BOOLEAN DEFAULT FALSE,
    roleInSystem INT DEFAULT 0,
    sessionId VARCHAR(128) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
    typeId INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    categoryName VARCHAR(88) NOT NULL,
    memo TEXT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    productId VARCHAR(10) PRIMARY KEY NOT NULL,
    productName VARCHAR(500) NOT NULL,
    productImage TEXT,
    brief TEXT,
    postedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    typeId INT NOT NULL,
    account VARCHAR(20) NOT NULL,
    unit VARCHAR(32) DEFAULT 'pcs',
    price INT DEFAULT 0,
    discount INT DEFAULT 0 CHECK (discount >= 0 AND discount <= 100),
    CONSTRAINT fk_products_category FOREIGN KEY (typeId) REFERENCES categories(typeId),
    CONSTRAINT fk_products_account FOREIGN KEY (account) REFERENCES accounts(account) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed data for administrative accounts, storefront categories, and products
insert into accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem)
values('manager','123','Nguyen Minh','Quang','1996/06/12',1,'0935694223',1,2);
insert into accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem)
values('admin','abc','Nguyen Quang','Hung','1996/10/28',1,'0705101028',1,1);
insert into categories(categoryName) values('Kitchenware');
insert into categories(categoryName) values('Home Appliances');
insert into categories(categoryName) values('Home Decor');
insert into categories(categoryName) values('Fitness Equipment');
insert into categories(categoryName) values('Smart Devices');
insert into categories(categoryName) values('Fashion Apparel');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('SHG2303MRA', 'SUNHOUSE 3-Ply Stainless Steel Cookware Set', 'images/sanPham/boNoiInoxSunhouse.jpg',
       'Durable stainless steel cookware with heat-resistant handles, tempered glass lids, and induction-ready bases for everyday cooking.',
       'manager', 399000,10,1, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('NAG1452', 'Nagakawa Premium Stainless Steel Pressure Cooker', 'images/sanPham/noiApSuatNagakawa.jpg',
       'Safe pressure cooker with dual valves, sealed lid design, 304 stainless steel body, and a 3-layer base for even heat distribution.',
       'manager', 1328000,5,1, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('SHG2303TEF', 'Tefal Nonstick Frying Pan Combo', 'images/sanPham/chaoChienTefal.jpg',
       'Two-pan nonstick combo with durable titanium coating, easy-clean exterior, and smart heat indicator for reliable home cooking.',
       'admin', 709000,0,1, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('4062373305', 'Relax Lounge Chair', 'images/sanPham/gheThuGian.jpg',
       'Comfortable folding lounge chair made with sturdy materials for home, office, balcony, or outdoor relaxation.',
       'admin', 699000,10,3, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('8868354221', 'IGEA Nordic Style Sofa Coffee Table', 'images/sanPham/banTraSofaIGEA.jpg',
       'Modern MDF coffee table with melamine finish, oak legs, compact dimensions, and a clean white Nordic look.',
       'manager', 290000,5,3, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('2759614408', 'Seven-Tier Shoe Rack Organizer', 'images/sanPham/keGiaDeGiay.jpg',
       'Space-saving seven-tier shoe rack with water-resistant melamine frame, easy assembly, and storage capacity for up to 12 pairs.',
       'admin', 439000,10,3, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('5746333511', 'Nordic TV Stand T350-1', 'images/sanPham/keTiviPhongCachBacAu.png',
       'Minimal multi-purpose TV stand made from imported MDF with melamine coating, modern wood and white finish, and practical storage.',
       'admin', 569000,0,3, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('BK105S2VWS', 'Toshiba Inverter Front Load Washing Machine', 'images/sanPham/mayGiatToshiba.jpg',
       '9.5 kg Toshiba inverter front-load washer with a modern horizontal drum, energy-saving operation, and elegant white design.',
       'manager', 7390000,0,2, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('NAFD10AR1B', 'Panasonic Inverter Washing Machine 10.5 kg', 'images/sanPham/mayGiatPanasonic.jpg',
       '10.5 kg Panasonic inverter washer with StainMaster cleaning technology for stronger stain removal and efficient daily laundry.',
       'manager', 9290000,0,2, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('NRF654GTX2', 'Panasonic Inverter Refrigerator 642L', 'images/sanPham/tuLanhPanasonic.png',
       'Large 642L Panasonic six-door inverter refrigerator with glass finish, strong tempered shelves, and flexible food storage.',
       'admin', 88990000,0,2, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('EHE5224B-A', 'Electrolux Inverter Refrigerator 524L', 'images/sanPham/tuLanhELECTROLUX.png',
       '524L Electrolux refrigerator with 360-degree cooling, stable shelf-by-shelf temperature control, and TasteLock crisper storage.',
       'manager', 22590000,0,2, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('7823080768', 'Premium Adjustable Ankle Weights', 'images/sanPham/taDeoChanCaoCap.jpg',
       'Adjustable ankle weights with durable polyester fabric, chrome-plated steel bars, and comfortable fit for strength training.',
       'manager', 315000,0,4, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('6075086733', 'Fitme Body Compression Sports Shirt', 'images/sanPham/aoTheThaoFitness.png',
       'High-performance compression sports shirt for gym, basketball, football, volleyball, and high-intensity training sessions.',
       'admin', 152000,0,4, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('8640589401', 'Wall-Mounted Pull-Up Bar', 'images/sanPham/xaDonTreoTuong.jpg',
       'Adjustable wall-mounted pull-up bar for upper-body workouts, core training, and compact home fitness routines.',
       'manager', 119000,0,4, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('9024218247', 'Air Walker Exercise Machine', 'images/sanPham/mayChayBoTrenKhong.jpg',
       'Compact air walker exercise machine for cardio training, walking motion, arm movement, and low-impact home workouts.',
       'admin', 1020000,0,4, 'set');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('6681948644', 'Plaid Bow Babydoll Dress', 'images/sanPham/vayBabadollCaro.jpg',
       'Lightweight plaid babydoll dress with round neckline, bow detail, and soft textured fabric for casual styling.',
       'admin', 109000,0,6, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('1688993802', 'Short-Sleeve Plain Mens Shirt', 'images/sanPham/aoSoMiNamNganTay.jpg',
       'Modern slim-fit short-sleeve shirt for office and casual wear with a clean, youthful, and polished look.',
       'admin', 99000,0,6, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('4494738964', 'Water-Resistant Laptop Backpack', 'images/sanPham/baloNuChongNuoc.jpg',
       'Stylish water-resistant laptop backpack with practical compartments, compact design, and everyday school or work utility.',
       'admin', 105000,0,6, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('9680372888', 'Womens Athletic Sneakers', 'images/sanPham/giayTheThaoNu.jpg',
       'Comfortable athletic sneakers with modern styling, rubber outsole, soft cushioning, and sizes from 35 to 39.',
       'manager', 153000,0,6, 'pair');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('8709925437', 'Mens High-Top Leather Boots', 'images/sanPham/giayBotDaNamCaoCo.jpg',
       'High-top mens boots with bold styling, synthetic leather upper, breathable fabric details, and black or brown options.',
       'manager', 189000,0,6, 'pair');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('11MAX64213', 'iPhone 11 Pro Max 64GB', 'images/sanPham/iPhone11_ProMax.jpg',
       'Premium iPhone 11 Pro Max with strong performance, refreshed design, and advanced rear camera system for everyday use.',
       'admin', 26500000,0,5, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('10NOTEP256', 'Samsung Galaxy Note 10 Plus', 'images/sanPham/samsungGalaxyNote10Plus.jpg',
       'Samsung Galaxy Note 10 Plus with vivid color design, Gorilla Glass protection, polished finish, and intuitive One UI experience.',
       'admin', 25450000,0,5, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('XRN8012121', 'Xiaomi Redmi Note 8', 'images/sanPham/XiaomiRedmiNote8.jpg',
       'Xiaomi Redmi Note 8 smartphone with quad-camera setup, Gorilla Glass protection, and a 48 MP main camera for sharp photos.',
       'manager', 3750000,0,5, 'piece');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
values('Y98HEAD802', 'Y98 Bluetooth Sports Headphones', 'images/sanPham/TaiNgheBluetoothY98.jpg',
       'Bluetooth sports headphones designed for workouts, active listening, and long training sessions with comfortable wireless use.',
       'manager', 299000,0,5, 'set');
CREATE TABLE cart (
    account VARCHAR(20) NOT NULL,
    productId VARCHAR(10) NOT NULL,
    quantity INT DEFAULT 1,
    PRIMARY KEY (account, productId),
    CONSTRAINT fk_cart_account FOREIGN KEY (account) REFERENCES accounts(account) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE viewhistory (
    account VARCHAR(20) NOT NULL,
    productId VARCHAR(10) NOT NULL,
    viewedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (account, productId),
    CONSTRAINT fk_viewhistory_account FOREIGN KEY (account) REFERENCES accounts(account) ON DELETE CASCADE,
    CONSTRAINT fk_viewhistory_product FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    orderId INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    account VARCHAR(20),
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    address VARCHAR(500) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    status INT DEFAULT 0,
    CONSTRAINT fk_orders_account FOREIGN KEY (account) REFERENCES accounts(account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orderdetails (
    orderId INT NOT NULL,
    productId VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    price INT NOT NULL,
    discount INT DEFAULT 0,
    PRIMARY KEY (orderId, productId),
    CONSTRAINT fk_orderdetails_order FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
    CONSTRAINT fk_orderdetails_product FOREIGN KEY (productId) REFERENCES products(productId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
